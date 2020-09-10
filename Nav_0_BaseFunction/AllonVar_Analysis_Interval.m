function [sigma,tau,Err] = AllonVar_Analysis_Interval(y0,tau0,n,interval)
% ������� 
%   ���룺y0 һ�����ݣ�tau0 ��������, n Ϊ���������С���������ݳ��ȵ�1/n

% ���������ݰ��� ��������� 1,2,3��...K�����зָ���ֱ��󷽲�
N = length(y0);
Max_num = fix(N/n);   
Max_Group = fix(Max_num/interval);      %һ���ָ������
Max_num = Max_Group * interval + 1;     %һ���ڣ�����������Ŀ
T = zeros(Max_Group,1);
for i = 1:Max_Group
    T(i,1) = (i-1)*interval + 1;
end

sigma = zeros(Max_Group,1);
tau = zeros(Max_Group,1);
Err = zeros(Max_Group,1);

for k = 1:Max_Group
    tau(k,1) = T(k,1)*tau0;
    k_num = fix(N/T(k,1));   %�ֳ�k_num�飬ÿ��T(k,1)������    
    W_mean = zeros(k_num,1);
    for p = 1:k_num
       W_mean(p,1) =  mean(y0((p-1)*T(k,1)+1:p*T(k,1),1));
    end
    sigma(k,1) = sum([W_mean(2:k_num,1)-W_mean(1:k_num-1,1)].^2)/(2*(k_num-1)); 
end

