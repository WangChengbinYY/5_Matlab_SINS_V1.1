function Rmh = Earth_get_Rmh(G_CONST,lat,h)
% 计算Rmh 仅需要 纬度 和 高程
% Inputs:   常量， 纬度、高程，单位弧度 m
% Output:   Rmh     单位 m
%

Rmh = G_CONST.earth_Re*(1-G_CONST.earth_e^2)/(1-G_CONST.earth_e^2*sin(lat)^2)^1.5 + h;