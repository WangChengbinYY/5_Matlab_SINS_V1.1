clear; clc;
load('E:\5_实验记录\20200107_单位办公桌静态试验汇总\静止放置\MPU_L_A_1_静止2小时\MPU_L.mat');
    Fs = 200;
    IMU = IMU(100*200:end,:);
    L = length(IMU);
    L = 200*60*20;
    
    
    acc = IMU(1:end,3);
    

figure;
b1 = [0.1];
a1 = [1 -0.9];
freqz(b1,a1);    
accFilter_M = filter(b1,a1,acc);

figure;
plot(acc);
hold on; plot(accFilter_M,'r');

L = length(acc);
accSum = zeros(L,1);
accSum_M = zeros(L,1);
for i = 50:L
    accSum(i,1) =  accSum(i-1,1) + acc(i-1,1)/Fs;
    accSum_M(i,1) =  accSum_M(i-1,1) + accFilter_M(i-1,1)/Fs;
end
figure;
plot(accSum);
hold on; plot(accSum_M,'r');




figure;
plot(acc);
hold on; plot(xFilter,'r');