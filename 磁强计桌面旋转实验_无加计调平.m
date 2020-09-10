% 针对实验数据 20200312_办公桌面静止旋转
% 采集原始数据，2个IMU数据对应1个Mag数据
%   磁强计坐标轴变换 y x -z 对应陀螺的 x y z

%-------------------8位置单点处理方法------------------------
% 设定8个点的起始终止位置
%   磁强计对应的数据位置 为  (num+1)/2
%   第9点回到原始位置，可用于比较重复性，但是手工操作不一定对齐！
Num = 9;
Location = zeros(Num,2);  %每段数据的起始终止位置
%第一组
Location(1,1) = 500;    Location(1,2) = 2000;      
Location(2,1) = 4000;   Location(2,2) = 6400;
Location(3,1) = 7000;   Location(3,2) = 9500;    
Location(4,1) = 12000;  Location(4,2) = 14500;
Location(5,1) = 15500;  Location(5,2) = 17500;   
Location(6,1) = 19000;  Location(6,2) = 21000;
Location(7,1) = 22280;  Location(7,2) = 24650;   
Location(8,1) = 26000;  Location(8,2) = 28000;
Location(9,1) = 29000;  Location(9,2) = 31000;  
%第二组
% Location(1,1) = 500;    Location(1,2) = 2500;      
% Location(2,1) = 4000;   Location(2,2) = 7000;
% Location(3,1) = 9000;   Location(3,2) = 11000;    
% Location(4,1) = 12500;  Location(4,2) = 15000;
% Location(5,1) = 16500;  Location(5,2) = 18500;   
% Location(6,1) = 20500;  Location(6,2) = 22500;
% Location(7,1) = 24000;  Location(7,2) = 26000;   
% Location(8,1) = 28500;  Location(8,2) = 30500;
% Location(9,1) = 32400;  Location(9,2) = 33400;  
%第三组  鞋面上
% Location(1,1) = 1000;   Location(1,2) = 5000;      
% Location(2,1) = 6500;   Location(2,2) = 9000;
% Location(3,1) = 11000;  Location(3,2) = 14000;    
% Location(4,1) = 16000;  Location(4,2) = 19000;
% Location(5,1) = 20500;  Location(5,2) = 23500;   
% Location(6,1) = 25000;  Location(6,2) = 28000;
% Location(7,1) = 30500;  Location(7,2) = 33500;   
% Location(8,1) = 35500;  Location(8,2) = 38500;
% Location(9,1) = 40000;  Location(9,2) = 43500;  


% 求取均值
Mean_Acc = zeros(Num,3);
Mean_Mag = zeros(Num,3);
for i = 1:Num
    Mean_Acc(i,1:3) = mean(IMU(Location(i,1):Location(i,2),3:5));
    Temp = mean(Magnetic(fix((Location(i,1)+1)/2):fix((Location(i,2)+1)/2),3:5));
    Mean_Mag(i,1) = Temp(1,2);  Mean_Mag(i,2) = Temp(1,1); Mean_Mag(i,3) = -Temp(1,3); 
    %利用加计求水平姿态，进行磁强计投影变换
    [pitch,roll] = Att_Accel2Att(Mean_Acc(i,1),Mean_Acc(i,2),Mean_Acc(i,3)); 
    att = [pitch;roll;0];
    C_b_n = Att_Euler2DCM(att);
    Mag = C_b_n*[Mean_Mag(i,1);Mean_Mag(i,2);Mean_Mag(i,3)];
    Mean_Mag(i,1) = Mag(1,1); Mean_Mag(i,2) = Mag(2,1); Mean_Mag(i,3) = Mag(3,1); 
end
figure;
plot(Mean_Mag(:,1),Mean_Mag(:,2),'*-'); grid on; 
hold on; plot(0,0,'ro');

% 利用磁强计数据求取航向
Yaw = zeros(Num,1);
for i = 1:Num
    Yaw(i,1) = Att_Mag2Yaw(0,0,Mean_Mag(i,1),Mean_Mag(i,2),Mean_Mag(i,3));
end
Yaw = Yaw .*(-180/pi);

figure;
plot(Yaw,'*-'); grid on; 
hold on;

% 进行参数辨识  利用最小二乘解算
H01 = abs(max(Mean_Mag(:,1))-min(Mean_Mag(:,1)))/2;
B = zeros(Num,1);
A = zeros(Num,5);
X = zeros(5,1);
for i = 1:Num
   B(i,1) = H01*H01;
   A(i,1) = Mean_Mag(i,1)^2;
   A(i,2) = Mean_Mag(i,2)^2;
   A(i,3) = Mean_Mag(i,1)*Mean_Mag(i,2);
   A(i,4) = Mean_Mag(i,1);
   A(i,5) = Mean_Mag(i,2);
end
X = (A'*A)^-1*A'*B;
c1 = X(1,1); c2 = X(2,1); c3 = X(3,1); c4 = X(4,1); c5 = X(5,1);
% 参数解算
b_x0 = (c3*c5-2*c2*c4)/(4*c1*c2-c3^2);
b_y0 = (c3*c5-2*c1*c5)/(4*c1*c2-c3^2);
Temp = c3/2/sqrt(abs(c1*c2));
if c1<0
    Temp = -Temp;
end
PHi_p = -asin(Temp)/2;
k_x = 1; k_y = sqrt(abs(c1/c2));
A_h = [cos(PHi_p),sin(PHi_p);sin(PHi_p),cos(PHi_p)]^-1;
K_h = [1,0;0,k_y]^-1;

[A22,B21] = Calibration_Mag_2D(Mean_Mag);
A22 - A_h*K_h
B21 - [[b_x0;b_y0]]


% 数据校准
Mean_MagNew = zeros(Num,2);
for i = 1:Num
     Mean_MagNew(i,:)=(A_h*K_h*[Mean_Mag(i,1)-b_x0;Mean_Mag(i,2)-b_y0])';
end

figure;
plot(Mean_Mag(:,1),Mean_Mag(:,2),'*-'); grid on; 
hold on; plot(0,0,'ro');
hold on; plot(Mean_MagNew(:,1),Mean_MagNew(:,2),'r*-');

% 利用校准后的数据进行航向求解
Yaw_New = zeros(Num,1);
for i = 1:Num
    Yaw_New(i,1) = Att_Mag2Yaw(0,0,Mean_MagNew(i,1),Mean_MagNew(i,2),0);
end
Yaw_New = Yaw_New .*(-180/pi);
figure;
plot(Yaw,'*-'); grid on; 
hold on; plot(Yaw_New,'r*-');


% 测试连续旋转的航向计算
L = length(Magnetic);
Yaw_Continue_Old = zeros(L,1);
Yaw_Continue_New = zeros(L,1);
Mag_Old = zeros(L,3);
Mag_Old(:,1) = Magnetic(:,4); Mag_Old(:,2) = Magnetic(:,3); Mag_Old(:,3) = -Magnetic(:,5);
Mag_New = zeros(L,3);
for i = 1:L
    Mag_New(i,1:2)=(A_h*K_h*[Mag_Old(i,1)-b_x0;Mag_Old(i,2)-b_y0])';
end
figure;
plot(Mag_Old(:,1),Mag_Old(:,2)),grid on;
hold on;plot(Mag_New(:,1),Mag_New(:,2),'r');

% 计算连续航向
for i = 1:L
    Yaw_Continue_Old(i,1) = Att_Mag2Yaw(0,0,Mag_Old(i,1),Mag_Old(i,2),0);
    Yaw_Continue_New(i,1) = Att_Mag2Yaw(0,0,Mag_New(i,1),Mag_New(i,2),0);
end
Yaw_Continue_Old = Yaw_Continue_Old .*(-180/pi);
Yaw_Continue_New = Yaw_Continue_New .*(-180/pi);
figure;
plot(Yaw_Continue_Old); grid on; 
hold on; plot(Yaw_Continue_New,'r');







