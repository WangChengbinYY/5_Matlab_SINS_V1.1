function INSData_Now = INS_Update_MIMU(G_Const,insdata_pre,insdata_now,T)
% 1、纯惯性解算，时间更新
% 2、应用于低成本的MIMU，简化惯导解算精度
% 3、不考姿态解算的旋转误差 和 速度的 (2*w_ie_n+w_en_n)xV_en_n 有害误差
% 4、姿态、速度、位置均采用简化模型


%% 一、计算需要的信息
T_DeltaTime = T;                    %采样间隔时间 可以直接利用采样频率计算，也可以利用采样间隔计算(防止丢包)
% T_DeltaTime = insdata_now.time - insdata_pre.time;

%% 二、简化版姿态更新
%   直接利用陀螺输出，计算角增量，直接等于旋转矢量
insdata_now.DeltaTheta_ib_b = (insdata_now.w_ib_b+insdata_pre.w_ib_b)*T_DeltaTime/2;
T_Phi_ib_b = insdata_now.DeltaTheta_ib_b;
T_Q_bm_bm_1 = Att_Rv2Q(T_Phi_ib_b);
insdata_now.Q_b_n = Math_QmulQ(insdata_pre.Q_b_n,T_Q_bm_bm_1);
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
 
%% 四、计算参数更新   
INSData_Now = insdata_now;
% 实际使用可以不用更新
INSData_Now.f_ib_n          = INSData_Now.C_b_n*INSData_Now.f_ib_b;
INSData_Now.Rmh             = Earth_get_Rmh(G_Const,INSData_Now.pos(1,1),INSData_Now.pos(3,1));
INSData_Now.Rnh             = Earth_get_Rnh(G_Const,INSData_Now.pos(1,1),INSData_Now.pos(3,1));
INSData_Now.w_ie_n          = Earth_get_w_ie_n(G_Const,INSData_Now.pos(1,1));
INSData_Now.w_en_n          = Earth_get_w_en_n(INSData_Now.pos(1,1),INSData_Now.vel,INSData_Now.Rmh,INSData_Now.Rnh);
INSData_Now.w_in_n          = INSData_Now.w_ie_n+INSData_Now.w_en_n;