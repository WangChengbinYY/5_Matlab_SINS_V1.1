function Gyro_Bias_Stability =  Estimate_Bias_Gyro_10s(Gyro_Data,Hz)
% 利用10s平滑的方法测试陀螺的零偏稳定性  1倍 Sigma
% 输入的 Gyro_Data 陀螺数据 单位为 弧度/s
% 输出的零偏稳定性 单位为 度/h

L = length(Gyro_Data);
M = Hz*10;
m = fix(L/M);
if m < 7
    Gyro_Bias_Stability = 0;
    return;
end

Mean_Gyro = zeros(m,1);
for i = 1:m
    Mean_Gyro(i,1) = mean(Gyro_Data((i-1)*M+1:i*M,1));
end
Gyro_Bias_Stability = sqrt(var(Mean_Gyro)) * (180/pi*3600);

