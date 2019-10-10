function INSData = INS_DataInit(G_Const,time,att,vel,pos,gyro,acc,T)
% 初始化惯导解算结构体
% 输入：pos[lat lon h]'
%       att[pitch roll yaw]'
%       vel[v_e v_n v_u]'
%       gyro[x y z]'  角速率
%       acc[x y z]'   加速度
%       T  采样间隔

%% 主要数据区
    INSData.time = time; 
    INSData.att = att;
    INSData.vel = vel;
    INSData.pos = pos;
       
%% 传感器数据
    INSData.w_ib_b = gyro;                    %陀螺输出 角速率
    INSData.DeltaTheta_ib_b = gyro*T;         %陀螺输出 角增量
    INSData.f_ib_b = acc;                     %加计输出 加速度
    INSData.DeltaV_ib_b = acc*T;              %加计输出 速度增量

%% 姿态参数转换
    INSData.C_b_n = Att_Euler2DCM(INSData.att);
    INSData.Q_b_n = Att_DCM2Q(INSData.C_b_n);    
    
%% 中间计算数据
    INSData.DeltaTheta_in_n = [0.0;0.0;0.0];                %n系旋转的累积
    INSData.DeltaV_n        = [0.0;0.0;0.0];                %vn速度增量 v(m)=v(m-1)+DeltaV_n
    INSData.Rmh             = Earth_get_Rmh(G_Const,pos(1,1),pos(3,1));
    INSData.Rnh             = Earth_get_Rnh(G_Const,pos(1,1),pos(3,1));
    INSData.w_ie_n          = Earth_get_w_ie_n(G_Const,pos(1,1));
    INSData.w_en_n          = Earth_get_w_en_n(pos(1,1),INSData.vel,INSData.Rmh,INSData.Rnh);
    INSData.w_in_n          = INSData.w_ie_n+INSData.w_en_n;
    INSData.wie             = G_Const.earth_wie;
    INSData.f_ib_n          = [0.0;0.0;0.0];    
    
%暂未看懂干啥用的    
%     INSData.phi             = [0.0;0.0;0.0];
%     INSData.DeltaV_n_sf     = [0.0;0.0;0.0];
%     

%     INSData.fb              = [0.0;0.0;0.0];    %补偿以后的
    
    
    
    
    
    