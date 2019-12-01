function IMU = DataPrepare_LoadData_IMU_Only(mLoadPath)
% 读取不包含磁强计数据的 IMU 数据 (ADIS)


IMU = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %陀螺单位是度/s  加计 m/s2 磁强计 uT
    IMU = zeros(L,8);       %最后一列带时间标
    IMU(1:L,1) = Temp(1:L,1)+Temp(1:L,2)./1000.0;
    IMU(1:L,2:4) = Temp(1:L,3:5);
    IMU(1:L,5:7) = Temp(1:L,6:8)./(180.0/pi);   
    IMU(1:L,8) = Temp(1:L,11);
end

