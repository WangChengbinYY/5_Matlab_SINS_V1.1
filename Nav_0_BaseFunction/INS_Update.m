function INSData_Now = INS_Update(G_Const,insdata_pre,insdata_now,T)
% 1、纯惯性解算，时间更新
% 2、已考虑旋转误差补偿等 高精度惯导应用


%% 一、计算需要的信息
T_DeltaTime = T;                    %采样间隔时间 可以直接利用采样频率计算，也可以利用采样间隔计算(防止丢包)
% T_DeltaTime = insdata_now.time - insdata_pre.time;

%% 二、速度更新计算
% 速度的更新等于上一时刻的速度 加上 Delta_Vn_sf 和 Delta_Vn_cor
%-----------------------------------------------------------------
%--------------------------Delta_Vn_cor---------------------------
%-----------------------------------------------------------------
% 其中 Delta_Vn_cor 的计算是关于 w_ie_n w_in_n g_n ，在采样间隔期间变化小，直接采用中间数值进行计算
% 1. 计算(m-1/2)时刻的速度Vn
T_Vn_half = insdata_pre.vel+ 0.5*insdata_pre.DeltaV_n;
% 2. 计算(m-1/2)时刻的位置pos
%   计算半个采样周期内行走的距离
T_Delta_Distance = (insdata_pre.vel+T_Vn_half)*T_DeltaTime/4.0;
%   计算半个采样周期内行走的距离 对位置的增量
T_Delta_Pos(1,1) = T_Delta_Distance(2,1)/insdata_pre.Rmh;   %纬度增量
T_Delta_Pos(2,1) = T_Delta_Distance(1,1)/insdata_pre.Rnh/cos(insdata_pre.pos(1,1));  %经度增量
T_Delta_Pos(3,1) = T_Delta_Distance(3,1);        %高程增量
T_Pos_half = insdata_pre.pos+T_Delta_Pos;
% 3. 利用(m-1/2)时刻的位置pos 计算新的Rmh Rnh 
T_Rmh = Earth_get_Rmh(G_Const,T_Pos_half(1,1),T_Pos_half(3,1));
T_Rnh = Earth_get_Rnh(G_Const,T_Pos_half(1,1),T_Pos_half(3,1));
% 4. 利用(m-1/2)时刻的位置vn pos 计算w_ie_n,w_en_n,w_in_n
T_w_ie_n = Earth_get_w_ie_n(G_Const,T_Pos_half(1,1));
T_w_en_n = Earth_get_w_en_n(T_Pos_half(1,1),T_Vn_half,T_Rmh,T_Rnh);
T_w_in_n = T_w_ie_n+T_w_en_n;
% 5. 计算(m-1/2)时刻的位置pos 对应的gn
T_gn_half = Earth_get_g_n(G_Const,T_Pos_half(1,1),T_Pos_half(3,1));
% 6. 计算 Delta_Vn_cor 
T_Delta_Vn_cor = (-cross((T_w_in_n+T_w_ie_n),T_Vn_half)+T_gn_half)*T_DeltaTime;
%-----------------------------------------------------------------
%--------------------------Delta_Vn_sf---------------------------
%-----------------------------------------------------------------
% Delta_Vn_sf 包含三个部分，一部分是加计的累积增量，
%   一部分是 旋转误差补偿量 Delta_Vn_rot
%   一部分是 划桨误差补偿量 Delta_Vn_scull
% 1. 计算(m)当前时刻 陀螺增量 和 加计增量
%   陀螺输出 角增量
insdata_now.DeltaTheta_ib_b = (insdata_now.w_ib_b+insdata_pre.w_ib_b)*T_DeltaTime/2;
%   加计输出 速度增量
insdata_now.DeltaV_ib_b = (insdata_now.f_ib_b+insdata_pre.f_ib_b)*T_DeltaTime/2;
% 2. 计算 DeltaV_rot_b
T_DeltaV_rot_b = 0.5*cross(insdata_now.DeltaTheta_ib_b,insdata_now.DeltaV_ib_b);
% 3. 计算 DeltaV_scull_b
TempV = cross(insdata_pre.DeltaTheta_ib_b,insdata_now.DeltaV_ib_b);
TempV1 = cross(insdata_pre.DeltaV_ib_b,insdata_now.DeltaTheta_ib_b);
T_DeltaV_scull_b = (TempV+TempV1)/12.0;
% 4. 计算 DeltaV_sf_n
TempM = eye(3) - Math_v2m_askew(T_w_in_n)*T_DeltaTime/2.0;
T_DeltaV_sf_n = TempM*insdata_pre.C_b_n*(insdata_now.DeltaV_ib_b+T_DeltaV_rot_b+T_DeltaV_scull_b);
%-----------------------------------------------------------------
%--------------------------Delta_Vn-------------------------------
%-----------------------------------------------------------------
% 1. 计算 当前时刻的速度增量INSData.DeltaV_n
insdata_now.DeltaV_n = T_DeltaV_sf_n + T_Delta_Vn_cor;
% 2. 计算 当前时刻的速度
insdata_now.vel = insdata_pre.vel + insdata_now.DeltaV_n;

%% 三、位置更新
% 采用 梯形积分更新法，利用计算的(m)时刻速度 进行计算
T_Delta_Distance = (insdata_pre.vel+insdata_now.vel)*T_DeltaTime/2.0;
TempV(1,1) = T_Delta_Distance(2,1)/T_Rmh;                       %纬度增量
TempV(2,1) = T_Delta_Distance(1,1)/T_Rnh/cos(T_Pos_half(1,1));  %经度增量
TempV(3,1) = T_Delta_Distance(3,1);                             %高程增量
% 位置的更新
insdata_now.pos = insdata_pre.pos+TempV;
    
%% 四、姿态更新    
% 利用旋转矢量更新 四元数 ，然后利用四元数更新姿态
% 1. 计算n系从(m-1)时刻到(m)时刻的旋转四元数 Q_n(m-1)_n(m)
%   利用新的 速度 位置，重新计算 w_in_n ，并计算当前时刻的DeltaTheta_in_n
insdata_now.w_ie_n = Earth_get_w_ie_n(G_Const,insdata_now.pos(1,1));
insdata_now.Rmh = Earth_get_Rmh(G_Const,insdata_now.pos(1,1),insdata_now.pos(3,1));
insdata_now.Rnh = Earth_get_Rnh(G_Const,insdata_now.pos(1,1),insdata_now.pos(3,1));
insdata_now.w_en_n = Earth_get_w_en_n(insdata_now.pos(1,1),insdata_now.vel,insdata_now.Rmh,insdata_now.Rnh);
insdata_now.w_in_n = insdata_now.w_ie_n+insdata_now.w_en_n;
insdata_now.DeltaTheta_in_n = (insdata_pre.w_in_n+insdata_now.w_in_n)*T_DeltaTime/2.0;
%   由前一时刻和当前时刻的 DeltaTheta_in_n 计算对应的旋转矢量 Phi_in_n
T_Phi_in_n = insdata_now.DeltaTheta_in_n + cross(insdata_pre.DeltaTheta_in_n,insdata_now.DeltaTheta_in_n)/12.0;
%   计算 n系的 旋转四元数 Q_n(m-1)_n(m)
T_Q_nm_nm_1 = Att_Rv2Q(T_Phi_in_n);
T_Q_nm_1_nm = Math_Q2conj(T_Q_nm_nm_1);
% 2. 计算b系从(m)时刻到(m-1)时刻的旋转四元数 Q_b(m)_b(m-1)
%   根据(m-1)和(m)时刻的陀螺输出，计算 旋转矢量 Phi_ib_b
T_Phi_ib_b = insdata_now.DeltaTheta_ib_b + cross(insdata_pre.DeltaTheta_ib_b,insdata_now.DeltaTheta_ib_b)/12.0;
T_Q_bm_bm_1 = Att_Rv2Q(T_Phi_ib_b);
% 3. 计算当前时刻姿态对应的四元数 Q_b_n
insdata_now.Q_b_n = Math_QmulQ(Math_QmulQ(T_Q_nm_1_nm,insdata_pre.Q_b_n),T_Q_bm_bm_1);
% 4. 计算对应的姿态，并跟新 C_b_n
%   由 四元数 求解对应的 DCM
insdata_now.C_b_n = Att_Q2DCM(insdata_now.Q_b_n);
%   由 DCM 更新 当前时刻的姿态
insdata_now.att = Att_DCM2euler(insdata_now.C_b_n);

%% 五、计算参数更新   
INSData_Now = insdata_now;
INSData_Now.f_ib_n          = INSData_Now.C_b_n*INSData_Now.f_ib_b;
INSData_Now.Rmh             = Earth_get_Rmh(G_Const,INSData_Now.pos(1,1),INSData_Now.pos(3,1));
INSData_Now.Rnh             = Earth_get_Rnh(G_Const,INSData_Now.pos(1,1),INSData_Now.pos(3,1));
INSData_Now.w_ie_n          = Earth_get_w_ie_n(G_Const,INSData_Now.pos(1,1));
INSData_Now.w_en_n          = Earth_get_w_en_n(INSData_Now.pos(1,1),INSData_Now.vel,INSData_Now.Rmh,INSData_Now.Rnh);
INSData_Now.w_in_n          = INSData_Now.w_ie_n+INSData_Now.w_en_n;


   
    

    
