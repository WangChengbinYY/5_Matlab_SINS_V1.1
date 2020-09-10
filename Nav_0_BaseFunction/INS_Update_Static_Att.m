function INSData_Now = INS_Update_Static_Att(G_Const,insdata_pre,insdata_now,T)
% 1、静止状态下，依据陀螺输入，更新姿态
% 2、考虑旋转不可交换误差补偿 单子样+前一周角增量 补偿算法



%% 一、计算需要的信息
T_DeltaTime = T;                    %采样间隔时间 可以直接利用采样频率计算，也可以利用采样间隔计算(防止丢包)
% T_DeltaTime = insdata_now.time - insdata_pre.time;

%% 二、默认速度为0 位置不变 情况下求取姿态变化
% 仅计算陀螺输出引起的姿态变化增量，不考虑导航系速度引起姿态增量
% 利用旋转矢量更新 四元数 ，然后利用四元数更新姿态
% 1. 计算n系从(m-1)时刻到(m)时刻的旋转四元数 Q_n(m-1)_n(m)
%   利用新的 速度 位置，重新计算 w_in_n ，并计算当前时刻的DeltaTheta_in_n
insdata_now.w_ie_n = Earth_get_w_ie_n(G_Const,insdata_now.pos(1,1));
insdata_now.w_ie_n = zeros(3,1);
insdata_now.Rmh = Earth_get_Rmh(G_Const,insdata_now.pos(1,1),insdata_now.pos(3,1));
insdata_now.Rnh = Earth_get_Rnh(G_Const,insdata_now.pos(1,1),insdata_now.pos(3,1));
%insdata_now.w_en_n = Earth_get_w_en_n(insdata_now.pos(1,1),insdata_now.vel,insdata_now.Rmh,insdata_now.Rnh);
insdata_now.w_en_n = zeros(3,1);
insdata_now.w_in_n = insdata_now.w_ie_n+insdata_now.w_en_n;
insdata_now.DeltaTheta_in_n = (insdata_pre.w_in_n+insdata_now.w_in_n)*T_DeltaTime/2.0;
%   由前一时刻和当前时刻的 DeltaTheta_in_n 计算对应的旋转矢量 Phi_in_n
T_Phi_in_n = insdata_now.DeltaTheta_in_n + cross(insdata_pre.DeltaTheta_in_n,insdata_now.DeltaTheta_in_n)/12.0;
%   计算 n系的 旋转四元数 Q_n(m-1)_n(m)
T_Q_nm_nm_1 = Att_Rv2Q(T_Phi_in_n);
T_Q_nm_1_nm = Math_Q2conj(T_Q_nm_nm_1);

% 2. 计算b系从(m)时刻到(m-1)时刻的旋转四元数 Q_b(m)_b(m-1)
%   根据(m-1)和(m)时刻的陀螺输出，计算 旋转矢量 Phi_ib_b
%   陀螺输出 角增量
    insdata_now.DeltaTheta_ib_b = (insdata_now.w_ib_b+insdata_pre.w_ib_b)*T_DeltaTime/2;
    T_Phi_ib_b = insdata_now.DeltaTheta_ib_b + cross(insdata_pre.DeltaTheta_ib_b,insdata_now.DeltaTheta_ib_b)/12.0;
    T_Q_bm_bm_1 = Att_Rv2Q(T_Phi_ib_b);
% 3. 计算当前时刻姿态对应的四元数 Q_b_n
    insdata_now.Q_b_n = Math_QmulQ(Math_QmulQ(T_Q_nm_1_nm,insdata_pre.Q_b_n),T_Q_bm_bm_1);
% 4. 计算对应的姿态，并跟新 C_b_n
%   由 四元数 求解对应的 DCM
    insdata_now.C_b_n = Att_Q2DCM(insdata_now.Q_b_n);
%   由 DCM 更新 当前时刻的姿态
    insdata_now.att = Att_DCM2euler(insdata_now.C_b_n);

%% 三、姿态更新   
INSData_Now = insdata_now;
INSData_Now.Q_b_n = insdata_now.Q_b_n;
INSData_Now.C_b_n = insdata_now.C_b_n;
INSData_Now.att = insdata_now.att;
