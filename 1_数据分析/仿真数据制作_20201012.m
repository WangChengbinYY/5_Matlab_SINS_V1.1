clear;clc;
load('E:\5_实验记录\20200916_ADI_R_B_姿态实验\IMUGPS1_20000_350000.mat');
load('E:\5_实验记录\20200916_ADI_R_B_姿态实验\半仿真数据\gyroData.mat');
clear gyroXData_Bia gyroYData_Bia gyroZData_Bia;
%% -----绘制原始数据显示
    figure;
    plot(gyroXData);    hold on;    plot(gyroXData_BiaDenoise,'r');
    legend('原始数据','零偏数据'); title('X轴陀螺');
    figure;
    plot(gyroYData);    hold on;    plot(gyroYData_BiaDenoise,'r');
    legend('原始数据','零偏数据'); title('Y轴陀螺');
    figure;
    plot(gyroZData);    hold on;    plot(gyroZData_BiaDenoise,'r');
    legend('原始数据','零偏数据'); title('Z轴陀螺');

%% -----去除零偏的陀螺    
    gyroXData_Noise = gyroXData-gyroXData_Denoise;
    gyroYData_Noise = gyroYData-gyroYData_Denoise;
    gyroZData_Noise = gyroZData-gyroZData_Denoise;
    
%%     
L = length(IMU);
gyroXData = IMU(:,5); gyroYData = IMU(:,6); gyroZData = IMU(:,7); 
accXData = IMU(:,2); accYData = IMU(:,3); accZData = IMU(:,4);


gyroXData_Denoise=gyroXData_Denoise'; gyroYData_Denoise=gyroYData_Denoise'; gyroZData_Denoise=gyroZData_Denoise';

gyroXData_BiaNoise = gyroXData_Bia-gyroXData_BiaDenoise;
gyroYData_BiaNoise = gyroYData_Bia-gyroYData_BiaDenoise;
gyroZData_BiaNoise = gyroZData_Bia-gyroZData_BiaDenoise;

tmp = wgn(L,1,0);
tmpsum = cumsum(tmp)*0.005;

sqrt(var(gyroXData_BiaNoise(1:L,1)))*180/pi*3600
sqrt(var(gyroYData_BiaNoise(1:L,1)))*180/pi*3600
sqrt(var(gyroZData_BiaNoise(1:L,1)))*180/pi*3600



sqrt(var(gyroXData_Noise(L/2:L,1)))*180/pi*3600
