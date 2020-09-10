function INSData_Now = INS_Update_MIMU_Test(G_Const,insdata_pre,insdata_now,T)
% 1、纯惯性解算，时间更新
% 2、应用用于低成本的MIMU，简化惯导解算精度
% 3、姿态采用高精度误差模型，速度、位置采用简化误差模型


%% 一、计算需要的信息
T_DeltaTime = T;                    %采样间隔时间 可以直接利用采样频率计算，也可以利用采样间隔计算(防止丢包)
% T_DeltaTime = insdata_now.time - insdata_pre.time;

%% 二、误差补偿姿态更新    
% 利用旋转矢量更新 四元数 ，然后利用四元数更新姿态
% 1. 计算n系从(m-1)时刻到(m)时刻的旋转四元数 Q_n(m-1)_n(m)
%   利用新的 速度 位置，重新计算 w_in_n ，并计算当前时刻的DeltaTheta_in_n
insdata_now.w_ie_n = Earth_get_w_ie_n(G_Const,insdata_pre.pos(1,1));
insdata_now.Rmh = Earth_get_Rmh(G_Const,insdata_pre.pos(1,1),insdata_pre.pos(3,1));
insdata_now.Rnh = Earth_get_Rnh(G_Const,insdata_pre.pos(1,1),insdata_pre.pos(3,1));
insdata_now.w_en_n = Earth_get_w_en_n(insdata_pre.pos(1,1),insdata_pre.vel,insdata_pre.Rmh,insdata_pre.Rnh);
insdata_now.w_in_n = insdata_now.w_ie_n+insdata_now.w_en_n;
insdata_now.DeltaTheta_in_n = (insdata_pre.w_in_n+insdata_now.w_in_n)*T_DeltaTime/2.0;
%   由前一时刻和当前时刻的 DeltaTheta_in_n 计算对应的旋转矢量 Phi_in_n
T_Phi_in_n = insdata_now.DeltaTheta_in_n + cross(insdata_pre.DeltaTheta_in_n,insdata_now.DeltaTheta_in_n)/12.0;
%   计算 n系的 旋转四元数 Q_n(m-1)_n(m)
T_Q_nm_nm_1 = Att_Rv2Q(T_Phi_in_n);
T_Q_nm_1_nm = Math_Q2conj(T_Q_nm_nm_1);
% 2. 计算b系从(m)时刻到(m-1)时刻的旋转四元数 Q_b(m)_b(m-1)
%   根据(m-1)和(m)时刻的陀螺输出，计算 旋转矢量 Phi_ib_b
insdata_now.DeltaTheta_ib_b = (insdata_now.w_ib_b+insdata_pre.w_ib_b)*T_DeltaTime/2;
T_Phi_ib_b = insdata_now.DeltaTheta_ib_b + cross(insdata_pre.DeltaTheta_ib_b,insdata_now.DeltaTheta_ib_b)/12.0;
T_Q_bm_bm_1 = Att_Rv2Q(T_Phi_ib_b);
% 3. 计算当前时刻姿态对应的四元数 Q_b_n
insdata_now.Q_b_n = Math_QmulQ(Math_QmulQ(T_Q_nm_1_nm,insdata_pre.Q_b_n),T_Q_bm_bm_1);
% 4. 计算对应的姿态，并跟新 C_b_n
%   由 四元数 求解对应的 DCM
insdata_now.C_b_n = Att_Q2DCM(insdata_now.Q_b_n);
%   由 DCM 更新 当前时刻的姿态
insdata_now.att = change_DCM2euler(insdata_now.C_b_n);

%% 三、简化版速度更新
%   当前时刻的加速度输出的 速度增量
insdata_now.DeltaV_ib_b = (insdata_now.f_ib_b+insdata_pre.f_ib_b)*T_DeltaTime/2;
T_Delta_Vn = insdata_now.C_b_n * (insdata_now.DeltaV_ib_b + cross(insdata_now.DeltaTheta_ib_b,insdata_now.DeltaV_ib_b)/2);
T_gn = Earth_get_g_n(G_Const,insdata_pre.pos(1,1),insdata_pre.pos(3,1));
insdata_now.vel = insdata_pre.vel + T_Delta_Vn + T_gn*T;

%% 三、简化版位置更新
% 采用 梯形积分更新法，利用计算的(m)时刻速度 进行计算
T_Delta_Distance = (insdata_pre.vel+insdata_now.vel)*T_DeltaTime/2.0;
T_Rmh = Earth_get_Rmh(G_Const,insdata_pre.pos(1,1),insdata_pre.pos(3,1));
T_Rnh = Earth_get_Rnh(G_Const,insdata_pre.pos(1,1),insdata_pre.pos(3,1));
TempV(1,1) = T_Delta_Distance(2,1)/T_Rmh;                       %纬度增量
TempV(2,1) = T_Delta_Distance(1,1)/T_Rnh/cos(insdata_pre.pos(1,1));  %经度增量
TempV(3,1) = T_Delta_Distance(3,1);                             %高程增量
% 位置的更新
insdata_now.pos = insdata_pre.pos+TempV;
 
INSData_Now = insdata_now;