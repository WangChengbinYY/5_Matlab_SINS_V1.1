% clear; clc;
% load 'rpy_9axis.mat' sensorData Fs
% accelerometerReadings = sensorData.Acceleration;
% gyroscopeReadings = sensorData.AngularVelocity;
% fuse = imufilter('SampleRate',Fs);
% q = fuse(accelerometerReadings,gyroscopeReadings);
% 
% time = (0:size(accelerometerReadings,1)-1)/Fs;
% figure;
% plot(time,eulerd(q,'ZYX','frame'))
% title('Orientation Estimate')
% legend('Z-axis', 'Y-axis', 'X-axis')
% xlabel('Time (s)')
% ylabel('Rotation (degrees)')



%------数据转换
clear; clc;
% load('E:\5_实验记录\20200107_单位办公桌静态试验汇总\静止放置\ADI_L_B_1_静止2小时\ADI_L.mat');
load('E:\5_实验记录\20200107_单位办公桌静态试验汇总\静止放置\MPU_L_A_1_静止2小时\MPU_L.mat');
Fs = 200;
IMU = IMU(100*200:end,:);
L = length(IMU);
L = 200*60*20;
GyroData = zeros(L,3);
AccData = zeros(L,3);
lon = deg2rad(116.397128); lat = deg2rad(39.916527); h = 30;
    %计算 重力g的数值
    g0 = 9.7803267714;                    %单位：m/s2 
    g=g0*(1+5.27094e-3*sin(lat)^2+2.32718e-5*sin(lat)^4)-3.086e-6*h; % grs80
    g = 9.81;

% 按照Matlab的定义进行 数据重组   
%       东北天——>北东地
%       单位：加计 m/s^2  陀螺：rad/s
AccData(1:L,1) = -IMU(1:L,4).*g; 
AccData(1:L,2) = -IMU(1:L,3).*g; 
AccData(1:L,3) = IMU(1:L,5).*g; 
GyroData(1:L,1) = IMU(1:L,7); 
GyroData(1:L,2) = IMU(1:L,6); 
GyroData(1:L,3) = -IMU(1:L,8); 

GyroscopeNoiseMPU9250 = 3.0462e-06; % GyroscopeNoise (variance) in units of rad/s
AccelerometerNoiseMPU9250 = 0.0061; % AccelerometerNoise (variance) in units of m/s^2

recoardOrient = zeros(L,3);
FUSE = imufilter('SampleRate',Fs, 'GyroscopeNoise',GyroscopeNoiseMPU9250,'AccelerometerNoise', AccelerometerNoiseMPU9250);
for i = 1:L
    [q,angVelBodyRecovered]= FUSE(AccData(i,:),GyroData(i,:));
    e = eulerd(q,'ZYX','frame');
    recoardOrient(i,:) = e';
end

% fuse = imufilter('SampleRate',Fs,'ReferenceFrame','NED');
% q= fuse(AccData,GyroData);

% 绘制结果
figure;
time = (0:L-1)/Fs;
plot(time,recoardOrient);
title('Orientation Estimate')
legend('Z-axis', 'Y-axis', 'X-axis')
xlabel('Time (s)')
ylabel('Rotation (degrees)')

figure;
plot(time,GyroData(1:L,1)); hold on; plot(time,angVelBodyRecovered(1:L,1),'r');
 figure;
plot(time,GyroData(1:L,2)); hold on; plot(time,angVelBodyRecovered(1:L,2),'r');
 figure;
plot(time,GyroData(1:L,3)); hold on; plot(time,angVelBodyRecovered(1:L,3),'r');
 

 
% 绘制结果
figure;
time = (0:L-1)/Fs;
plot(time,eulerd(q,'ZYX','frame'))
title('Orientation Estimate')
legend('Z-axis', 'Y-axis', 'X-axis')
xlabel('Time (s)')
ylabel('Rotation (degrees)')

% 开始滤波
fuse = imufilter('SampleRate',Fs,'ReferenceFrame','NED');
[q, AngularVelocity]= fuse(AccData,GyroData);

test = zeros(100,3);
ifilt = imufilter('SampleRate', Fs);
ii = 1;
qimu = ifilt([0,0,-g],[0,0,0]);
eulerAnglesDegrees = eulerd(qimu,'ZYX','frame')

readSensorDataMPU9250

clear ;
lon = deg2rad(116.397128); lat = deg2rad(39.916527); h = 30;
    %计算 重力g的数值
    g0 = 9.7803267714;                    %单位：m/s2 
    g=g0*(1+5.27094e-3*sin(lat)^2+2.32718e-5*sin(lat)^4)-3.086e-6*h; % grs80
Fs=200;
euld=[0,20,30]; %转动顺序为 Z Y X
qeuld = quaternion(euld, 'eulerd', 'ZYX', 'frame');
viewer2 = HelperOrientationViewer;
viewer2(qeuld);
% imufilter 测试
G_n = [0,0,-g];
G_b = rotateframe(qeuld, G_n);
ifilt = imufilter('SampleRate', Fs,'ReferenceFrame','NED');
qimu = ifilt(G_b,[0,0,0]);
eulerAnglesDegrees1 = eulerd(qimu,'ZYX','frame')
viewer1 = HelperOrientationViewer;
viewer1(qimu);


% ahrsfilter测试
mMag = 53477;  %uT
theta = deg2rad(-6.746);
Mag_n = [mMag*cos(theta),0,mMag*sin(theta)];
Mag_b = rotateframe(qeuld, Mag_n);
FUSE = ahrsfilter('ReferenceFrame','NED','SampleRate', Fs);
[orientation,angularVelocity] = FUSE(G_b,[0,0,0],Mag_b);
eulerAnglesDegrees2 = eulerd(orientation,'ZYX','frame')




% for ii=1:L
%     
q = quaternion([0,0,0],'eulerd','ZYX','frame');
    viewer(q);
%     pause(0.005);
% end

viewer1 = HelperOrientationViewer;
ifilt1 = imufilter('SampleRate', Fs);

% for ii=1:L
    qimu1 = ifilt1(AccData(ii,:), GyroData(ii,:));
    viewer1(qimu1);

 
[X,Y,Z] = peaks;
f=figure;
surf(X,Y,Z)
xlabel('X')
ylabel('Y')
zlabel('Z')
ax = get(f,'CurrentAxes');
view(ax,[63,27]);
ax.ZDir = 'reverse';
ax.XDir = 'reverse';
[caz,cel] = view




viewer = HelperOrientationViewer;
q = quaternion([0,0,30],'eulerd','ZYX','frame');
viewer(q);




[caz,cel] = view
view(130,-35);



