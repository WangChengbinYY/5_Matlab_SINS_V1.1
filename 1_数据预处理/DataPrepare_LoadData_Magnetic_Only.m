function Magnetic = DataPrepare_LoadData_Magnetic_Only(mLoadPath)
% 读取磁强计数据  从IMUA_MPU9250采集   磁强计采集频率100Hz

Magnetic = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %磁强计单位 uT
    Magnetic = zeros(L,5);
    Magnetic(1:L,1) = Temp(1:L,1)+Temp(1:L,2)./1000.0;
    Magnetic(1:L,2:5) = Temp(1:L,3:6);    %包含时间状态
end