% 测试陀螺输出求姿态 的累积是否 和 3个陀螺分别累积一致
clear;clc;
L = 200*60*20;

Hz = 1/60;
w = 2*pi*Hz;
A = 0.0001;
B = pi/3;
t = (1:L).*0.005;
xGyroData = A*sin(w*t+B);

Hz = 1/600;
w = 2*pi*Hz;
A = 0.001;
B = pi/2;
t = (1:L).*0.005;
yGyroData = A*sin(w*t+B);

Hz = 1/1200;
w = 2*pi*Hz;
A = 0.005;
B = 0;
t = (1:L).*0.005;
zGyroData = A*sin(w*t+B);


Attitude0 = [3,1.2,5];      %初始姿态  ZYX
q = quaternion(Attitude0,'eulerd','ZYX','frame');          

recordX = zeros(L,3);     %单独计算 X 轴姿态
recordXcum = zeros(L,3);     %单独计算 X 轴姿态
recordXY = zeros(L,3);     %单独计算 Y 轴姿态
recordXYcum = zeros(L,3);     %单独计算 Y 轴姿态
recordXYZ = zeros(L,3);     %单独计算 Z 轴姿态
recordXYZcum = zeros(L,3);     %单独计算 Z 轴姿态

priorDelTheta = zeros(3,1);     %前一时刻角增量
for i = 1:L
    % 计算当前时刻角增量
    Theta = [xGyroData(1,i);yGyroData(1,i);zGyroData(1,i)].*0.005;
%     Vector = Theta + cross(priorDelTheta,Theta)./12;
%     priorDelTheta = Theta;
    Vector = Theta;
    deltaq = quaternion(Vector', 'rotvec');
    q = q*deltaq;
        if parts(q) < 0
            q = -q;
        end 
        q = normalize(q);    
        % 记录姿态 和 零偏信息
        recordXYZ(i,:) =  eulerd(q,'ZYX','frame');     
end
recordXYZcum(:,1) =Attitude0(1,3) + (cumsum(xGyroData)').*0.005;
recordXYZcum(:,2) =Attitude0(1,2) + (cumsum(yGyroData)').*0.005;
recordXYZcum(:,3) =Attitude0(1,1) + (cumsum(zGyroData)').*0.005;

figure;
plot(recordXYZ(:,3)); hold on; plot(recordXYZcum(:,1),'r'); title('XYZ-x');
figure;
plot(recordXYZ(:,2)); hold on; plot(recordXYZcum(:,2),'r'); title('XYZ-y');
figure;
plot(recordXYZ(:,1)); hold on; plot(recordXYZcum(:,3),'r'); title('XYZ-z');

figure;
plot(recordX(:,2)); hold on; plot(recordX(:,1),'g'); title('Y Z');







