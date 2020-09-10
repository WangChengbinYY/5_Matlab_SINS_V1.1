function Bias_mean = Gyro_Mean_Plot(IMU,nn,Num)
L = fix(Num/nn);
Bias_mean = zeros(L,3);
for i = 1:L
    Bias_mean(i,1:3) = mean(IMU((i-1)*nn+1:i*nn,5:7));
end
figure; plot(Bias_mean(:,1)); title('XÖáÍÓÂİÁãÆ«');
figure; plot(Bias_mean(:,2)); title('YÖáÍÓÂİÁãÆ«');
figure; plot(Bias_mean(:,3)); title('ZÖáÍÓÂİÁãÆ«');