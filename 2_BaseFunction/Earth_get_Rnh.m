function Rnh = Earth_get_Rnh(G_CONST,lat,h)
% 计算Rnh   仅需要 纬度 和 高程
% Inputs:   常量， 纬度、高程，单位弧度 m
% Output:   Rnh     单位 m

Rnh = G_CONST.earth_Re/(1-G_CONST.earth_e^2*sin(lat)^2)^0.5 + h;
