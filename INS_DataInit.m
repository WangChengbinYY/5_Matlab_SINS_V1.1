function INSData = INS_DataInit(G_Const,time,att,vel,pos,eb,db,T)
% 初始化惯导解算结构体
% 输入：G_Const 常值参数
%       time 采样时刻
%       att[pitch roll yaw]'
%       vel[v_e v_n v_u]'
%       pos[lat lon h]'
%       eb[x y z]' - gyro constant bias (rad/s)    
%       db[x y z]' - acc constant bias (m/s)
%       T  采样间隔

%% 主要数据区
    INSData.time = time; 
    INSData.att = att;
    INSData.vel = vel;
    INSData.pos = pos;
       
%% 传感器数据
    INSData.w_ib_b = zeros(3,1);                    %陀螺输出 角速率
    INSData.DeltaTheta_ib_b = zeros(3,1);         %陀螺输出 角增量
    INSData.f_ib_b = zeros(3,1);                     %加计输出 加速度
    INSData.DeltaV_ib_b = zeros(3,1);              %加计输出 速度增量
    
    INSData.eb = eb;   %xyz陀螺零偏
    INSData.db = db;   %xyz加计零偏
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
    INSData.f_ib_n          = zeros(3,1);    
    

    
    
    
    
    
    