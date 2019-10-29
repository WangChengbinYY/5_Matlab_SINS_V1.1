% 对IMU进行参数的标校
%    包括：加速度计的 比力因子、非正交参数、常值零偏
%
%


% 对 “20191028_ADIS清华桌上预热后6位置数据采集.mat”数据进行标校估计
Data_IMU = Data_IMUB_L;

% 预热20分钟后，进行6位置数据采集，顺序为
% X轴向上 X轴向下 Y轴向上 Y轴向下 Z轴向上 Z轴向下
% 分别设定 每阶段所采集数据的起始和结束时间
Temp_X_Up_Start = 14000;    Temp_X_Up_End = Temp_X_Up_Start + 119999;
Temp_X_Down_Start = 182000;  Temp_X_Down_End = Temp_X_Down_Start + 119999;
Temp_Y_Up_Start = 343000;    Temp_Y_Up_End = Temp_Y_Up_Start + 119999;
Temp_Y_Down_Start = 576000;  Temp_Y_Down_End = Temp_Y_Down_Start + 119999;
Temp_Z_Up_Start = 720400;    Temp_Z_Up_End = Temp_Z_Up_Start + 119999;
Temp_Z_Down_Start = 930000;  Temp_Z_Down_End = Temp_Z_Down_Start + 119999;

% 精仪系的坐标
Temp_Pos = [40.003575*pi/180;116.337489*pi/180;20]; 
% 计算当地重力数值
G_Const = CONST_Init();
g_n = Earth_get_g_n(G_Const,Temp_Pos(1,1),Temp_Pos(3,1));
gn = -g_n(3,1);

%构造6次观测的观测量
a1=[gn;0;0;1];  a2=[-gn;0;0;1];
a3=[0;gn;0;1];  a4=[0;-gn;0;1];
a5=[0;0;gn;1];  a6=[0;0;-gn;1];
A = [a1,a2,a3,a4,a5,a6];

%构造6次测量量
u1=[mean(Data_IMU(Temp_X_Up_Start:Temp_X_Up_End,2));
    mean(Data_IMU(Temp_X_Up_Start:Temp_X_Up_End,3));
    mean(Data_IMU(Temp_X_Up_Start:Temp_X_Up_End,4))];
u2=[mean(Data_IMU(Temp_X_Down_Start:Temp_X_Down_End,2));
    mean(Data_IMU(Temp_X_Down_Start:Temp_X_Down_End,3));
    mean(Data_IMU(Temp_X_Down_Start:Temp_X_Down_End,4))];
u3=[mean(Data_IMU(Temp_Y_Up_Start:Temp_Y_Up_End,2));
    mean(Data_IMU(Temp_Y_Up_Start:Temp_Y_Up_End,3));
    mean(Data_IMU(Temp_Y_Up_Start:Temp_Y_Up_End,4))];
u4=[mean(Data_IMU(Temp_Y_Down_Start:Temp_Y_Down_End,2));
    mean(Data_IMU(Temp_Y_Down_Start:Temp_Y_Down_End,3));
    mean(Data_IMU(Temp_Y_Down_Start:Temp_Y_Down_End,4))];
u5=[mean(Data_IMU(Temp_Z_Up_Start:Temp_Z_Up_End,2));
    mean(Data_IMU(Temp_Z_Up_Start:Temp_Z_Up_End,3));
    mean(Data_IMU(Temp_Z_Up_Start:Temp_Z_Up_End,4))];
u6=[mean(Data_IMU(Temp_Z_Down_Start:Temp_Z_Down_End,2));
    mean(Data_IMU(Temp_Z_Down_Start:Temp_Z_Down_End,3));
    mean(Data_IMU(Temp_Z_Down_Start:Temp_Z_Down_End,4))];
U = [u1,u2,u3,u4,u5,u6];

%求解加速度计校准参数
M = U*A'*(A*A')^-1;