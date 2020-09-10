K_Start = 1000;
Acc_Mean = zeros(K_Start,3);
Mag_Mean = zeros(K_Start,3);
for i=1:K_Start
    Acc_Mean(i,:) = mean(IMU((i-1)*2+1:i*2,3:5));
end
Temp = Magnetic(1:K_Start,3:5);
Mag_Mean(:,1) = Temp(:,2);
Mag_Mean(:,2) = Temp(:,1);
Mag_Mean(:,3) = -Temp(:,3);
pitch = zeros(K_Start,1);
roll = zeros(K_Start,1);
yaw = zeros(K_Start,1);
for i = 1:K_Start
   [pitch(i,1),roll(i,1)] = Att_Accel2Att(Acc_Mean(i,1),Acc_Mean(i,2),Acc_Mean(i,3)); 
end

%依据 磁强计三轴输出 和 水平姿态角，计算 航向角
for i = 1:K_Start
    yaw(i,1) = Att_Mag2Yaw(pitch(i,1),roll(i,1),Mag_Mean(i,1),Mag_Mean(i,2),Mag_Mean(i,3));
end
yaw = yaw .*(-180/pi);


%======================== 开始  结尾
Start = 1;  End = 16848
K_Start = End - Start + 1;
Acc_Mean = zeros(K_Start,3);
Mag_Mean = zeros(K_Start,3);
Temp = Magnetic(1:K_Start,3:5);
Mag_Mean(:,1) = Temp(:,2);
Mag_Mean(:,2) = Temp(:,1);
Mag_Mean(:,3) = -Temp(:,3);
for i=Start:End
    Acc_Mean(i,:) = mean(IMU(i*2-1:i*2,3:5));
end

pitch = zeros(K_Start,1);
roll = zeros(K_Start,1);
yaw = zeros(K_Start,1);
for i = 1:K_Start
   [pitch(i,1),roll(i,1)] = Att_Accel2Att(Acc_Mean(i,1),Acc_Mean(i,2),Acc_Mean(i,3)); 
end

%依据 磁强计三轴输出 和 水平姿态角，计算 航向角
for i = 1:K_Start
    yaw(i,1) = Att_Mag2Yaw(pitch(i,1),roll(i,1),Mag_Mean(i,1),Mag_Mean(i,2),Mag_Mean(i,3));
end
yaw = yaw .*(-180/pi);






[L,n] = size(Magnetic);
k = fix(45879/2);
Magnetic_mean = zeros(k,n);

[L,n] = size(IMU);
k = fix(22939/1);
IMU_mean = zeros(k,n);

for i=1:k
    IMU_mean(i,:) = mean(IMU((i-1)*2+1:i*2,:));
    Magnetic_mean(i,:) = mean(Magnetic((i-1)*1+1:i*1,:));
end

pitch = zeros(k,1);
roll = zeros(k,1);
yaw = zeros(k,1);
for i = 1:k
   [pitch(i,1),roll(i,1)] = Att_Accel2Att(IMU_mean(i,3),IMU_mean(i,4),IMU_mean(i,5)); 
end

%依据 磁强计三轴输出 和 水平姿态角，计算 航向角
for i = 1:k
    yaw(i,1) = Att_Mag2Yaw(pitch(i,1),roll(i,1),Magnetic_mean(i,3),Magnetic_mean(i,4),Magnetic_mean(i,5));
end
yaw = yaw .*(-180/pi);





Vn = [0;10;0];

att=[0;0;-pi/4];
Vb=[-10*sin(pi/4);10*sin(pi/4);0];
Vn = Att_Euler2DCM(att)*Vb

C_b_n = Att_Euler2DCM(att);
att1 =  Att_DCM2euler(C_b_n);



