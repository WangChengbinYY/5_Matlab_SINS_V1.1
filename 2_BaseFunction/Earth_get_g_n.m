function g_n = Earth_get_g_n(G_Const,lat,h)
% 计算补偿过的g在n系下的投影  n系  东北天  
% Inputs:   纬度、高程，单位弧度 m
% Output:   g_n     单位 m/s2
%

temp_g = G_Const.earth_g0*(1+5.27094e-3*sin(lat)^2+2.32718e-5*sin(lat)^4)-3.086e-6*h; % grs80
g_n = [0;0;-temp_g];