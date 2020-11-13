%---------加速度计 静态 特性测试，用于提取 零速检测 阈值参数
clear;clc;
load('E:\5_实验记录\20200916_ADI_R_B_姿态实验\IMUGPS1_20000_350000.mat');
amplAccel = sqrt(IMU(:,2).^2+IMU(:,3).^2+IMU(:,4).^2);
L = length(amplAccel);
num_KF = 4;
L_KF = fix(L/num_KF);

meanAccel = zeros(L_KF,2);
rmsAccel = zeros(L_KF,2);

for i = 1:L_KF
    meanAccel(i,1) = i*num_KF;
    rmsAccel(i,1) = i*num_KF;
    meanAccel(i,2) = mean(amplAccel((i-1)*num_KF+1:i*num_KF,1));
    rmsAccel(i,2) = sqrt(var(amplAccel((i-1)*num_KF+1:i*num_KF,1)));
end

time = 1:L;
tmpMean =ones(L,1).*mean(amplAccel);
figure;
plot(meanAccel(:,1),meanAccel(:,2)-1,'g'); 
hold on;plot(time,tmpMean,'Color','r','LineWidth',3); 
hold on;plot(time,amplAccel-1,'Color','k');
title('平均值'); 

tmpRMS = ones(L,1).*sqrt(var(amplAccel));
figure;
plot(rmsAccel(:,1),rmsAccel(:,2),'g'); 
hold on;plot(time,tmpRMS,'Color','r','LineWidth',3); 
hold on;plot(time,amplAccel-1,'Color','k');
title('均方差'); 




