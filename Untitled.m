clear;
load('D:\清华博士\2_博士课题_JG\2_实验记录\20200107_单位办公桌静止放置_MPU_L\3_ADI_L_ADI_静止4小时\ADI_L.mat')
IMU = IMU(90*60*200:end-10*200,:)*180/pi*3600;
fs=200;  %实际采样率
f_slow=10;  %降低后的采样率，后面的程序是以10Hz为基础的
len_raw=length(IMU);%数据总长
len_smooth=fs/f_slow;% 平均每len_smooth个数据平滑
len=floor(len_raw/len_smooth);%降低采样率时采用的数据长度

Gyro_X = zeros(len,1);
for i = 1:len
    Gyro_X(i,1) = mean(IMU((i-1)*len_smooth+1:i*len_smooth,6));
end

%% ====================================自己  10Hz===================================
[sigma,tau,Err] = AllonVar_Analysis(Gyro_X,1/f_slow,5);
% sigma = sigma(10:end,1);
% tau = tau(10:end,1);
T = tau;
n = length(T);
A = zeros(n,3);
Y = sigma;
for i=2:4
    n=i-3;
    A(:,i-1)=T.^n;  %***惯性数据测试p143 式8.3-23
end
X = abs((A'*A)^-1 * A'*Y);
arw_N =     sqrt(X(1)) ;                %角度随机游走N
bias_B =    sqrt(X(2)*pi/2/log(2)) ;             %零偏不稳定性B
rrw_K =     sqrt(X(3)*3) ;    %速率随机游走K
disp(['角度随机游走N arw_N: ',num2str(arw_N)]);
disp(['零偏不稳定性B bias_B: ',num2str(bias_B)]);
disp(['速率随机游走K rrw_K: ',num2str(rrw_K)]);

[L,m] = size(A);
sigma_NIHE = zeros(L,1);
for i = 1:L
    for j = 1:3
        sigma_NIHE(i,1) = sigma_NIHE(i,1) + X(j,1)*A(i,j);
    end
end

figure;
loglog(tau,sqrt(sigma),'red-*');
hold on; loglog(tau,sqrt(sigma_NIHE),'g');
grid on;
xlabel('相关时间[s]');ylabel('Allan标准差[弧度/s]');title('自己 10Hz Allan方差');

%% ===================================YGM 10Hz===================================
[sigma_YGM,tau_YGM,Err] = AllonVar_Analysis_YGM(Gyro_X,1/f_slow);
sigma_YGM = sigma_YGM(4:end,1);
tau_YGM = tau_YGM(4:end,1);
T = tau_YGM;
n = length(T);
A = zeros(n,3);
Y = sigma_YGM;
for i=2:4
    n=i-3;
    A(:,i-1)=T.^n;  %***惯性数据测试p143 式8.3-23
end
X = abs((A'*A)^-1 * A'*Y);
arw_N =     sqrt(X(1))/60 ;                %角度随机游走N
bias_B =    sqrt(X(2))*2/3 ;             %零偏不稳定性B
rrw_K =     sqrt(X(3)*3)*60 ;    %速率随机游走K

[L,m] = size(A);
sigma_NIHE = zeros(L,1);
for i = 1:L
    for j = 1:m
        sigma_NIHE(i,1) = sigma_NIHE(i,1) + X(j,1)*A(i,j);
    end
end

figure;
loglog(tau_YGM,sqrt(sigma_YGM),'red-*');
hold on; loglog(tau_YGM,sqrt(sigma_NIHE),'g');
grid on;
xlabel('相关时间[s]');ylabel('Allan标准差[弧度/s]');title('YGM 10Hz 方差');
disp(['角度随机游走N arw_N: ',num2str(arw_N)]);
disp(['零偏不稳定性B bias_B: ',num2str(bias_B)]);
disp(['速率随机游走K rrw_K: ',num2str(rrw_K)]);

%% ===================================YGM 原始===================================
[sigma_YGM,tau_YGM,Err] = AllonVar_Analysis_YGM(IMU(:,6),1/200);
sigma_YGM = sigma_YGM(9:end,1);
tau_YGM = tau_YGM(9:end,1);
T = tau_YGM;
n = length(T);
A = zeros(n,3);
Y = sigma_YGM;
for i=2:4
    n=i-3;
    A(:,i-1)=T.^n;  %***惯性数据测试p143 式8.3-23
end
X = abs((A'*A)^-1 * A'*Y);
arw_N =     sqrt(X(1))/60 ;                %角度随机游走N
bias_B =    sqrt(X(2))*2/3 ;             %零偏不稳定性B
rrw_K =     sqrt(X(3)*3)*60 ;    %速率随机游走K

[L,m] = size(A);
sigma_NIHE = zeros(L,1);
for i = 1:L
    for j = 1:m
        sigma_NIHE(i,1) = sigma_NIHE(i,1) + X(j,1)*A(i,j);
    end
end

figure;
loglog(tau_YGM,sqrt(sigma_YGM),'red-*');
hold on; loglog(tau_YGM,sqrt(sigma_NIHE),'g');
grid on;
xlabel('相关时间[s]');ylabel('Allan标准差[弧度/s]');title('YGM 原始 方差');
disp(['角度随机游走N arw_N: ',num2str(arw_N)]);
disp(['零偏不稳定性B bias_B: ',num2str(bias_B)]);
disp(['速率随机游走K rrw_K: ',num2str(rrw_K)]);





%% 
clear;    
load('D:\清华博士\2_博士课题_JG\2_实验记录\20200107_单位办公桌静止放置_MPU_L\3_ADI_L_ADI_静止4小时\ADI_L.mat')
IMU = IMU(90*60*200:end-10*200,:)*180/pi*3600;
% [sigma20,tau20,Err] = AllonVar_Analysis_Interval(IMU(:,6),1/200,5,20);
% [sigma40,tau40,Err] = AllonVar_Analysis_Interval(IMU(:,6),1/200,5,40);
% [sigma60,tau60,Err] = AllonVar_Analysis_Interval(IMU(:,6),1/200,5,60);
[sigma80,tau80,Err] = AllonVar_Analysis_Interval(IMU(:,6),1/200,5,80);
% figure;     loglog(tau20,sqrt(sigma20),'r.-'); grid on;
% hold on;    loglog(tau40,sqrt(sigma40),'g.-');
% hold on;    loglog(tau60,sqrt(sigma60),'b.-');
% hold on;    loglog(tau80,sqrt(sigma80),'y.-');
% xlabel('相关时间[s]');ylabel('Allan标准差[弧度/s]');title('Allan方差');
% legend('20倍间隔','40倍间隔','60倍间隔','80倍间隔');

tau80_new = tau80(1:end,1);
sigma80_new = sigma80(1:end,1);
T = tau80_new;
n = length(T);
A = zeros(n,5);
Y = sigma80_new;
for i=1:5
    n=i-3;
    A(:,i)=T.^n;  %***惯性数据测试p143 式8.3-23
end
X = abs((A'*A)^-1 * A'*Y);

quant_Q=sqrt(X(1)/3);   %量化噪声Q  Q= μrad,3600是将deg/h化为deg/s
arw_N=sqrt(X(2));   %角度随机游走N
bias_B=sqrt(X(3)*pi/2/log(2));  %零偏不稳定性B
rrw_K=sqrt(X(4)*3); %速率随机游走K
rr_R=sqrt(X(5)*2);  %速率斜坡R

[L,m] = size(A);
sigma_NIHE = zeros(L,1);
for i = 1:L
    for j = 1:m
        sigma_NIHE(i,1) = sigma_NIHE(i,1) + X(j,1)*A(i,j);
    end
end

figure;
loglog(tau80_new,sqrt(sigma80_new),'red-*');
hold on; loglog(tau80_new,sqrt(sigma_NIHE),'g');grid on;
xlabel('相关时间[s]');ylabel('Allan标准差[弧度/s]');title('Allon方差最小二乘拟合');
legend('80倍 Allon方差曲线','拟合曲线');

disp(['quant_Q: ',num2str(quant_Q)]);
disp(['角度随机游走N arw_N: ',num2str(arw_N)]);
disp(['零偏不稳定性B bias_B: ',num2str(bias_B)]);
disp(['速率随机游走K rrw_K: ',num2str(rrw_K)]);
disp(['rr_R: ',num2str(rr_R)]);


%%
clear;
load('D:\清华博士\2_博士课题_JG\2_实验记录\20200107_单位办公桌静止放置_MPU_L\ADI_L.mat');
IMU = IMU(60*60*200:end-10*200,:)*180/pi*3600;
fs=200;  %实际采样率
f_slow=10;  %降低后的采样率，后面的程序是以10Hz为基础的
len_raw=length(IMU);%数据总长
len_smooth=fs/f_slow;% 平均每len_smooth个数据平滑
len=floor(len_raw/len_smooth);%降低采样率时采用的数据长度

Gyro_X = zeros(len,1);
for i = 1:len
    Gyro_X(i,1) = mean(IMU((i-1)*len_smooth+1:i*len_smooth,6));
end
[sigma,tau,Err] = AllonVar_Analysis(Gyro_X,1/f_slow,5);
[sigma20,tau20,Err] = AllonVar_Analysis_Interval(IMU(:,6),1/200,5,20);

figure;     loglog(tau20,sqrt(sigma20),'r.-'); grid on;
hold on;    loglog(tau,sqrt(sigma),'g.-');
xlabel('相关时间[s]');ylabel('Allan标准差[弧度/s]');title('Allan方差');
legend('海峰10Hz平滑','20倍间隔');









% sigma = sigma(10:end,1);
% tau = tau(10:end,1);
T = tau;
n = length(T);
A = zeros(n,3);
Y = sigma;
for i=2:4
    n=i-3;
    A(:,i-1)=T.^n;  %***惯性数据测试p143 式8.3-23
end
X = abs((A'*A)^-1 * A'*Y);
arw_N =     sqrt(X(1)) ;                %角度随机游走N
bias_B =    sqrt(X(2)*pi/2/log(2)) ;             %零偏不稳定性B
rrw_K =     sqrt(X(3)*3) ;    %速率随机游走K
disp(['角度随机游走N arw_N: ',num2str(arw_N)]);
disp(['零偏不稳定性B bias_B: ',num2str(bias_B)]);
disp(['速率随机游走K rrw_K: ',num2str(rrw_K)]);


