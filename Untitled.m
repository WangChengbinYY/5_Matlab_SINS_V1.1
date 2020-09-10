clear;
load('D:\�廪��ʿ\2_��ʿ����_JG\2_ʵ���¼\20200107_��λ�칫����ֹ����_MPU_L\3_ADI_L_ADI_��ֹ4Сʱ\ADI_L.mat')
IMU = IMU(90*60*200:end-10*200,:)*180/pi*3600;
fs=200;  %ʵ�ʲ�����
f_slow=10;  %���ͺ�Ĳ����ʣ�����ĳ�������10HzΪ������
len_raw=length(IMU);%�����ܳ�
len_smooth=fs/f_slow;% ƽ��ÿlen_smooth������ƽ��
len=floor(len_raw/len_smooth);%���Ͳ�����ʱ���õ����ݳ���

Gyro_X = zeros(len,1);
for i = 1:len
    Gyro_X(i,1) = mean(IMU((i-1)*len_smooth+1:i*len_smooth,6));
end

%% ====================================�Լ�  10Hz===================================
[sigma,tau,Err] = AllonVar_Analysis(Gyro_X,1/f_slow,5);
% sigma = sigma(10:end,1);
% tau = tau(10:end,1);
T = tau;
n = length(T);
A = zeros(n,3);
Y = sigma;
for i=2:4
    n=i-3;
    A(:,i-1)=T.^n;  %***�������ݲ���p143 ʽ8.3-23
end
X = abs((A'*A)^-1 * A'*Y);
arw_N =     sqrt(X(1)) ;                %�Ƕ��������N
bias_B =    sqrt(X(2)*pi/2/log(2)) ;             %��ƫ���ȶ���B
rrw_K =     sqrt(X(3)*3) ;    %�����������K
disp(['�Ƕ��������N arw_N: ',num2str(arw_N)]);
disp(['��ƫ���ȶ���B bias_B: ',num2str(bias_B)]);
disp(['�����������K rrw_K: ',num2str(rrw_K)]);

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
xlabel('���ʱ��[s]');ylabel('Allan��׼��[����/s]');title('�Լ� 10Hz Allan����');

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
    A(:,i-1)=T.^n;  %***�������ݲ���p143 ʽ8.3-23
end
X = abs((A'*A)^-1 * A'*Y);
arw_N =     sqrt(X(1))/60 ;                %�Ƕ��������N
bias_B =    sqrt(X(2))*2/3 ;             %��ƫ���ȶ���B
rrw_K =     sqrt(X(3)*3)*60 ;    %�����������K

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
xlabel('���ʱ��[s]');ylabel('Allan��׼��[����/s]');title('YGM 10Hz ����');
disp(['�Ƕ��������N arw_N: ',num2str(arw_N)]);
disp(['��ƫ���ȶ���B bias_B: ',num2str(bias_B)]);
disp(['�����������K rrw_K: ',num2str(rrw_K)]);

%% ===================================YGM ԭʼ===================================
[sigma_YGM,tau_YGM,Err] = AllonVar_Analysis_YGM(IMU(:,6),1/200);
sigma_YGM = sigma_YGM(9:end,1);
tau_YGM = tau_YGM(9:end,1);
T = tau_YGM;
n = length(T);
A = zeros(n,3);
Y = sigma_YGM;
for i=2:4
    n=i-3;
    A(:,i-1)=T.^n;  %***�������ݲ���p143 ʽ8.3-23
end
X = abs((A'*A)^-1 * A'*Y);
arw_N =     sqrt(X(1))/60 ;                %�Ƕ��������N
bias_B =    sqrt(X(2))*2/3 ;             %��ƫ���ȶ���B
rrw_K =     sqrt(X(3)*3)*60 ;    %�����������K

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
xlabel('���ʱ��[s]');ylabel('Allan��׼��[����/s]');title('YGM ԭʼ ����');
disp(['�Ƕ��������N arw_N: ',num2str(arw_N)]);
disp(['��ƫ���ȶ���B bias_B: ',num2str(bias_B)]);
disp(['�����������K rrw_K: ',num2str(rrw_K)]);





%% 
clear;    
load('D:\�廪��ʿ\2_��ʿ����_JG\2_ʵ���¼\20200107_��λ�칫����ֹ����_MPU_L\3_ADI_L_ADI_��ֹ4Сʱ\ADI_L.mat')
IMU = IMU(90*60*200:end-10*200,:)*180/pi*3600;
% [sigma20,tau20,Err] = AllonVar_Analysis_Interval(IMU(:,6),1/200,5,20);
% [sigma40,tau40,Err] = AllonVar_Analysis_Interval(IMU(:,6),1/200,5,40);
% [sigma60,tau60,Err] = AllonVar_Analysis_Interval(IMU(:,6),1/200,5,60);
[sigma80,tau80,Err] = AllonVar_Analysis_Interval(IMU(:,6),1/200,5,80);
% figure;     loglog(tau20,sqrt(sigma20),'r.-'); grid on;
% hold on;    loglog(tau40,sqrt(sigma40),'g.-');
% hold on;    loglog(tau60,sqrt(sigma60),'b.-');
% hold on;    loglog(tau80,sqrt(sigma80),'y.-');
% xlabel('���ʱ��[s]');ylabel('Allan��׼��[����/s]');title('Allan����');
% legend('20�����','40�����','60�����','80�����');

tau80_new = tau80(1:end,1);
sigma80_new = sigma80(1:end,1);
T = tau80_new;
n = length(T);
A = zeros(n,5);
Y = sigma80_new;
for i=1:5
    n=i-3;
    A(:,i)=T.^n;  %***�������ݲ���p143 ʽ8.3-23
end
X = abs((A'*A)^-1 * A'*Y);

quant_Q=sqrt(X(1)/3);   %��������Q  Q= ��rad,3600�ǽ�deg/h��Ϊdeg/s
arw_N=sqrt(X(2));   %�Ƕ��������N
bias_B=sqrt(X(3)*pi/2/log(2));  %��ƫ���ȶ���B
rrw_K=sqrt(X(4)*3); %�����������K
rr_R=sqrt(X(5)*2);  %����б��R

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
xlabel('���ʱ��[s]');ylabel('Allan��׼��[����/s]');title('Allon������С�������');
legend('80�� Allon��������','�������');

disp(['quant_Q: ',num2str(quant_Q)]);
disp(['�Ƕ��������N arw_N: ',num2str(arw_N)]);
disp(['��ƫ���ȶ���B bias_B: ',num2str(bias_B)]);
disp(['�����������K rrw_K: ',num2str(rrw_K)]);
disp(['rr_R: ',num2str(rr_R)]);


%%
clear;
load('D:\�廪��ʿ\2_��ʿ����_JG\2_ʵ���¼\20200107_��λ�칫����ֹ����_MPU_L\ADI_L.mat');
IMU = IMU(60*60*200:end-10*200,:)*180/pi*3600;
fs=200;  %ʵ�ʲ�����
f_slow=10;  %���ͺ�Ĳ����ʣ�����ĳ�������10HzΪ������
len_raw=length(IMU);%�����ܳ�
len_smooth=fs/f_slow;% ƽ��ÿlen_smooth������ƽ��
len=floor(len_raw/len_smooth);%���Ͳ�����ʱ���õ����ݳ���

Gyro_X = zeros(len,1);
for i = 1:len
    Gyro_X(i,1) = mean(IMU((i-1)*len_smooth+1:i*len_smooth,6));
end
[sigma,tau,Err] = AllonVar_Analysis(Gyro_X,1/f_slow,5);
[sigma20,tau20,Err] = AllonVar_Analysis_Interval(IMU(:,6),1/200,5,20);

figure;     loglog(tau20,sqrt(sigma20),'r.-'); grid on;
hold on;    loglog(tau,sqrt(sigma),'g.-');
xlabel('���ʱ��[s]');ylabel('Allan��׼��[����/s]');title('Allan����');
legend('����10Hzƽ��','20�����');









% sigma = sigma(10:end,1);
% tau = tau(10:end,1);
T = tau;
n = length(T);
A = zeros(n,3);
Y = sigma;
for i=2:4
    n=i-3;
    A(:,i-1)=T.^n;  %***�������ݲ���p143 ʽ8.3-23
end
X = abs((A'*A)^-1 * A'*Y);
arw_N =     sqrt(X(1)) ;                %�Ƕ��������N
bias_B =    sqrt(X(2)*pi/2/log(2)) ;             %��ƫ���ȶ���B
rrw_K =     sqrt(X(3)*3) ;    %�����������K
disp(['�Ƕ��������N arw_N: ',num2str(arw_N)]);
disp(['��ƫ���ȶ���B bias_B: ',num2str(bias_B)]);
disp(['�����������K rrw_K: ',num2str(rrw_K)]);


