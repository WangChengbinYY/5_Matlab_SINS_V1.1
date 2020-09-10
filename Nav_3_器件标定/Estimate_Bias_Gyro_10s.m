function Gyro_Bias_Stability =  Estimate_Bias_Gyro_10s(Gyro_Data,Hz)
% ����10sƽ���ķ����������ݵ���ƫ�ȶ���  1�� Sigma
% ����� Gyro_Data �������� ��λΪ ����/s
% �������ƫ�ȶ��� ��λΪ ��/h

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

