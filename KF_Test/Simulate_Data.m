%---------------------------生成仿真数据

%% 陀螺数据
clear;clc;
%采样频率
Hz = 200;
% 常值零偏 度/h
%Gyro_Bias_Const = [50;80;60].*(pi/180/3600);
Gyro_Bias_Const = [-0.0617633;-0.006840;0.00976214];   %弧度/s
Start_Pos = [34.2*(pi/180);108.9*(pi/180);400.0];
G_Const = CONST_Init();
% 常值零偏 白噪声 方差 (弧度/s)^2
Gyro_Bias_Const_Var = [9.435526099935672e-06;6.358767510985477e-06;1.989738785153631e-06];
% 仿真时间 s
Time = 60*10;
% 仿真数据长度
L = Hz*Time;
% IMU数据
IMU = zeros(L,7);
IMU(:,1) = 1/Hz:1/Hz:Time;
Noise = wgn(1,L,10*log10(Gyro_Bias_Const_Var(1,1)))'; Noise = Noise-mean(Noise);
IMU(:,5) = Noise + Gyro_Bias_Const(1,1);
Noise = wgn(1,L,10*log10(Gyro_Bias_Const_Var(2,1)))'; Noise = Noise-mean(Noise);
IMU(:,6) = Noise + Gyro_Bias_Const(2,1)+cos(Start_Pos(1,1))*G_Const.earth_wie;
% IMU(:,6) = Noise + Gyro_Bias_Const(2,1);
Noise = wgn(1,L,10*log10(Gyro_Bias_Const_Var(3,1)))'; Noise = Noise-mean(Noise);
IMU(:,7) = Noise + Gyro_Bias_Const(3,1)+sin(Start_Pos(1,1))*G_Const.earth_wie;
% IMU(:,7) = Noise + Gyro_Bias_Const(3,1);

%% 观测数据
% 观测初值
    Att_Const = [-0.0845;0.0965;1.4706].*(180/pi);
% 相同的观测噪声方差 0.001度
    Att_Const_Var = [0.0001;0.0001;0.0001];
    Noise = wgn(1,L,10*log10(Att_Const_Var(1,1)))'; Noise = Noise-mean(Noise);
% 仿真的观测数据
    Z_Att = zeros(L,3);
    Z_Att(:,1) = ones(L,1)*Att_Const(1,1) + Noise;
    Z_Att(:,2) = ones(L,1)*Att_Const(2,1) + Noise;
    Z_Att(:,3) = ones(L,1)*Att_Const(3,1) + Noise;
    Z_Att_HuDu = Z_Att.*(pi/180);
    
%%-----------------静态理论数据 陀螺数据
% clear;clc;
%    % 仿真数据长度
%     Hz = 200;
%     Time = 60*10;  %秒
%     L = Hz*Time;
%     % IMU数据
%     IMU = zeros(L,7);
%     IMU(:,1) = 1/Hz:1/Hz:Time; 
%     G_Const = CONST_Init();
%     Start_Pos = [0.5975;1.9017;400.0000];
%     
%     IMU(:,5) = zeros(L,1);
%     IMU(:,6) = ones(L,1)*cos(Start_Pos(1,1))*G_Const.earth_wie;
%     IMU(:,7) = ones(L,1)*sin(Start_Pos(1,1))*G_Const.earth_wie;



    