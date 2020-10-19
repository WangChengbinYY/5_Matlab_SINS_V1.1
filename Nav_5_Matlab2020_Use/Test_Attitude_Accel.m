% -----------测试 直接采用 IMU中的加速度计 进行水平姿态测量 的分析
%  原始数据 拆分
% clear;clc;
% load('E:\5_实验记录\20200916_ADI_R_B_姿态实验\IMUGPS1_20000_350000.mat');
% L = length(IMU);
%     % 加计数据拆分
%     accXData(1:L,1) = IMU(1:L,2);  
%     accYData(1:L,1) = IMU(1:L,3);  
%     accZData(1:L,1) = IMU(1:L,4); 

%-----------------  一、  分析加计器件本身精度   (先不考虑 安装非正交补偿)
clear;clc;
load('E:\5_实验记录\20200916_ADI_R_B_姿态实验\半仿真数据\IMUData.mat');
L = length(IMU);
%   坐标系  NED 和 前右下   加速度计的单位为g
accData(:,1) = accYData;  accData(:,2) = accXData;   accData(:,3) = -accZData; 

%   直接利用加计进行姿态求取，看其误差分布
 meanNum = 4;       %平均数
 L_KF = fix(L/meanNum);
    Attitude = zeros(L_KF,3);    % Z Y X  航向 俯仰 横滚    
    magnetic = [1,0,0]; 
    for i = 1:L_KF
        if meanNum > 1
            tpAccel = -mean(accData(1+(i-1)*meanNum:i*meanNum,:));
        else
             tpAccel = -accData(1+(i-1)*meanNum:i*meanNum,:);
        end
        q = ecompass(tpAccel,magnetic);
        if parts(q) < 0
                q = -q;
        end 
        Attitude(i,:) = eulerd(q, 'ZYX', 'frame');        
    end
    
    sqrt(var(Attitude(:,2)))
    sqrt(var(Attitude(:,3)))
figure;
plot(Attitude(:,3)); title('姿态 X 横滚'); ylabel('度');   
figure;
plot(Attitude(:,2)); title('姿态 Y 俯仰'); ylabel('度');   






