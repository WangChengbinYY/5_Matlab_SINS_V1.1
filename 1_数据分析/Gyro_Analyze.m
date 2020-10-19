clear;
% 未预热
 load('E:\5_实验记录\20200916_ADI_R_B_姿态实验\IMUGPS1_20000_350000.mat')
% 已预热
% load('E:\5_实验记录\20200107_单位办公桌静态试验汇总\静止放置\ADI_L_R_B_3_静止1_360000_1200000.mat')

t = 3;
Fs = 200;
L = t*Fs;
periodSensor = 1/Fs;
        gyroData = zeros(L,3);
        accData = zeros(L,3);
        %   坐标系  NED 和 前右下   加速度计的单位为g
        accData(1:L,1) =IMU(1:L,3);  
        accData(1:L,2) =IMU(1:L,2);  
        accData(1:L,3) = -IMU(1:L,4); 
        gyroData(1:L,1) =IMU(1:L,6);  
        gyroData(1:L,2) =IMU(1:L,5);  
        gyroData(1:L,3) = -IMU(1:L,7);  

meanGyro3S = mean(gyroData(1:3*Fs,:));
meanAccel3S = mean(accData(1:3*Fs,:));

% 陀螺去3s零偏后的 噪声方差
sqrt(var(gyroData-meanGyro3S))
% 加计去3s零偏后的 噪声方差
sqrt(var(accData-meanAccel3S))
