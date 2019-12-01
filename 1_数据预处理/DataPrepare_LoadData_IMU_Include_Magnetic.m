function [IMU,Magnetic] = DataPrepare_LoadData_IMU_Include_Magnetic(mLoadPath)
% 读取包含磁强计数据的 IMU 数据 
% 注意：目前使用的是MPU9250 IMU采样频率是200Hz，磁强计是100Hz，如果变动，这里需要进行改变

IMU = [];
Magnetic = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %陀螺单位是度/s  加计 m/s2 磁强计 uT
    IMU = zeros(L,8);       %最后一列带时间标
    IMU(1:L,1) = Temp(1:L,1)+Temp(1:L,2)./1000.0;
    IMU(1:L,2:4) = Temp(1:L,3:5);
    IMU(1:L,5:7) = Temp(1:L,6:8)./(180.0/pi);   
    IMU(1:L,8) = Temp(1:L,13);  %时间状态
    %拆分磁强计数据 
    Magnetic = zeros(fix(L/2),5);
    for i=1:fix(L/2)
        Magnetic(i,1) = IMU(1+(i-1)*2,1); %时间
        Magnetic(i,2:4) = Temp(1+(i-1)*2,9:11);
        Magnetic(i,5) = Temp(1+(i-1)*2,13); %时间状态
    end      
end