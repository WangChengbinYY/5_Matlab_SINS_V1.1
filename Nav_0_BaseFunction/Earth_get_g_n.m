function g_n = Earth_get_g_n(G_Const,lat,h)
% ���㲹������g��nϵ�µ�ͶӰ  nϵ  ������  
% Inputs:   γ�ȡ��̣߳���λ���� m
% Output:   g_n     ��λ m/s2
%

temp_g = G_Const.earth_g0*(1+5.27094e-3*sin(lat)^2+2.32718e-5*sin(lat)^4)-3.086e-6*h; % grs80
g_n = [0;0;-temp_g];