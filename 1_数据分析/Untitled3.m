%---------加速度计 静态 特性测试，用于提取 零速检测 阈值参数
amplAccel = sqrt(IMU(:,2).^2+IMU(:,3).^2+IMU(:,4).^2);
L = length(amplAccel);
num_KF = 4;
L_KF = fix(L/num_KF);

meanAccel = zeros(L_KF,1);
rmsAccel = zeros(L_KF,1);

for i = 1:L_KF
    meanAccel(i,)
    
end



mean(amplAccel)
sqrt(var(amplAccel))

