clear all;
%load('D:\�廪��ʿ\2_��ʿ����_JG\2_ʵ���¼\20200107_��λ�칫����ֹ����_MPU_L\ADI_L.mat');
% load('D:\�廪��ʿ\2_��ʿ����_JG\2_ʵ���¼\20200107_��λ�칫����ֹ����_MPU_L\MPU_L.mat');
%y0 = IMU(15*60*200:end-10*200,6);
%y0 = IMU(1:end-10,6);

load('LoggedSingleAxisGyroscope', 'omega', 'Fs');
y0 = omega;

y = y0;
%tau0 = 0.005;
tau0 = 1/Fs;
N = length(y);
NL = N;
for k = 1:fix(N/2)
    sigma(k,1) = sqrt(1/(2*(NL-1)) * sum([y(2:NL)-y(1:NL-1)].^2));
    tau(k,1) = 2^(k-1)*tau0;
    Err(k,1) = 1/sqrt(2*(NL-1));
    NL = floor(NL/2);
    if NL < 3
        break;
    end
    y = 1/2 * (y(1:2:2*NL) + y(2:2:2*NL));
end

figure;
subplot(211),plot(tau0*[1:N],y0);grid
xlabel('\itt \rm/ s'); ylabel('\ity');
subplot(212),
loglog(tau,sigma,'-+',tau,[sigma.*(1+Err),sigma.*(1-Err)],'r--'); grid
xlabel('\itt \rm/ s'); ylabel('\it\sigma_A\rm( \tau)');

%������С������ϲ���  AX=Y X=(A'*A)^-1 * A'*Y
T = tau;
n = length(T);
A = zeros(n,5);
Y = sigma.^2;
for i=1:5
    n=i-3;
    A(:,i)=T.^n;  %***�������ݲ���p143 ʽ8.3-23
end
X = abs((A'*A)^-1 * A'*Y);
quant_Q =   sqrt(X(1)/3) * (180/pi*3600);               %��������Q
arw_N =     sqrt(X(2))/60 * (180/pi*60);                %�Ƕ��������N
bias_B =    sqrt(X(3))*2/3 * (180/pi*3600);             %��ƫ���ȶ���B
rrw_K =     sqrt(X(4)*3)*60 * (180/pi/(1/3600)^1.5);    %�����������K
rr_R =      sqrt(X(5)*2)*3600 * (180/pi*3600^2);        %����б��R

disp(['��������Q quant_Q: ',num2str(quant_Q)]);
disp(['�Ƕ��������N arw_N: ',num2str(arw_N)]);
disp(['��ƫ���ȶ���B bias_B: ',num2str(bias_B)]);
disp(['�����������K rrw_K: ',num2str(rrw_K)]);
disp(['����б��Rrr_R: ',num2str(rr_R)]);

%������С������ϲ���  AX=Y X=(A'*A)^-1 * A'*Y
% T = tau;
% n = length(T);
% A = zeros(n,3);
% Y = sigma.^2;
% for i=2:4
%     n=i-3;
%     A(:,i-1)=T.^n;  %***�������ݲ���p143 ʽ8.3-23
% end
% X = abs((A'*A)^-1 * A'*Y);
% 
% arw_N =     sqrt(X(1))/60 * (180/pi*60);                %�Ƕ��������N
% bias_B =    sqrt(X(2))*2/3 * (180/pi*3600);             %��ƫ���ȶ���B
% rrw_K =     sqrt(X(3)*3)*60 * (180/pi/(1/3600)^1.5);    %�����������K
% 
% disp(['�Ƕ��������N arw_N: ',num2str(arw_N)]);
% disp(['��ƫ���ȶ���B bias_B: ',num2str(bias_B)]);
% disp(['�����������K rrw_K: ',num2str(rrw_K)]);