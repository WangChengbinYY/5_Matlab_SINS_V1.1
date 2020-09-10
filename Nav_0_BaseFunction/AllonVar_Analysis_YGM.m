function [sigma,tau,Err] = AllonVar_Analysis_YGM(y0,tau0)
% 方差分析 
%   输入：y0 一列数据，tau0 采样周期


N = length(y0);
y = y0; NL = N;
for k=1:N
    sigma(k,1) = sum([y(2:NL) - y(1:NL-1)].^2)/(2*(NL-1)) ;
    tau(k,1) = 2^(k-1) * tau0;
    Err(k,1) = 1/sqrt(2*(NL-1));
    NL = floor(NL/2);
    if NL < 3
        break;
    end
    y = 1/2 *(y(1:2:2*NL)+y(2:2:2*NL));
end

