function [sigma,tau,Err] = AllonVar_Analysis(y0,tau0,n)
% ������� 
%   ���룺y0 һ�����ݣ�tau0 ��������, n Ϊ���������С���������ݳ��ȵ�1/n

% ���������ݰ��� ��������� 1,2,3��...K�����зָ���ֱ��󷽲�
N = length(y0);
K = fix(N/n);   %ʱ������1��K

sigma = zeros(K,1);
tau = zeros(K,1);
Err = zeros(K,1);

for k = 1:K
    tau(k,1) = k*tau0;
    k_num = fix(N/k);   %�ֳ�k_num�飬ÿ��k������    
    W_mean = zeros(k_num,1);
    for p = 1:k_num
       W_mean(p,1) =  mean(y0((p-1)*k+1:p*k,1));
    end
    sigma(k,1) = sum([W_mean(2:k_num,1)-W_mean(1:k_num-1,1)].^2)/(2*(k_num-1)); 
end

