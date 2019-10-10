function w_ie_n = Earth_get_w_ie_n(G_CONST,lat)
% 计算地球自转角速度在n系下的投影w_ie_n
%       导航坐标n系采用 东北天
% Inputs:     常量， 纬度，单位弧度
% Output:   w_ie_n = [x;y;z]      单位 弧度/s 
%

w_ie_n = [0; G_CONST.earth_wie*cos(lat); G_CONST.earth_wie*sin(lat)];