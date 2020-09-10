function [sigma,tau,Err] = AllonVar_Analysis_Interval(y0,tau0,n,interval)
% 方差分析 
%   输入：y0 一列数据，tau0 采样周期, n 为分组数最大小于整个数据长度的1/n

% 将输入数据按照 采样间隔的 1,2,3，...K倍进行分割，并分别求方差
N = length(y0);
Max_num = fix(N/n);   
Max_Group = fix(Max_num/interval);      %一共分割的组数
Max_num = Max_Group * interval + 1;     %一组内，最大的数据数目
T = zeros(Max_Group,1);
for i = 1:Max_Group
    T(i,1) = (i-1)*interval + 1;
end

sigma = zeros(Max_Group,1);
tau = zeros(Max_Group,1);
Err = zeros(Max_Group,1);

for k = 1:Max_Group
    tau(k,1) = T(k,1)*tau0;
    k_num = fix(N/T(k,1));   %分成k_num组，每组T(k,1)个数据    
    W_mean = zeros(k_num,1);
    for p = 1:k_num
       W_mean(p,1) =  mean(y0((p-1)*T(k,1)+1:p*T(k,1),1));
    end
    sigma(k,1) = sum([W_mean(2:k_num,1)-W_mean(1:k_num-1,1)].^2)/(2*(k_num-1)); 
end

