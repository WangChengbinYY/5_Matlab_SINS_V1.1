function [sigma,tau,Err] = AllonVar_Analysis(y0,tau0,n)
% 方差分析 
%   输入：y0 一列数据，tau0 采样周期, n 为分组数最大小于整个数据长度的1/n

% 将输入数据按照 采样间隔的 1,2,3，...K倍进行分割，并分别求方差
N = length(y0);
K = fix(N/n);   %时间间隔从1到K

sigma = zeros(K,1);
tau = zeros(K,1);
Err = zeros(K,1);

for k = 1:K
    tau(k,1) = k*tau0;
    k_num = fix(N/k);   %分成k_num组，每组k个数据    
    W_mean = zeros(k_num,1);
    for p = 1:k_num
       W_mean(p,1) =  mean(y0((p-1)*k+1:p*k,1));
    end
    sigma(k,1) = sum([W_mean(2:k_num,1)-W_mean(1:k_num-1,1)].^2)/(2*(k_num-1)); 
end

