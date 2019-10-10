function w_en_n = Earth_get_w_en_n(lat,vn,Rmh,Rnh)
% 计算n系相对e系旋转速度在n系下的投影w_en_n
%       导航坐标n系采用 东北天
% Inputs:   lat 纬度，单位弧度
%           vn = [x;y;z] 载体相对地球速度在n系下的投影，单位弧度 m
% Output:   w_en_n = [x;y;z]      单位 弧度/s 
%


w_en_n = [-vn(2,1)/Rmh;vn(1,1)/Rnh;vn(1,1)/Rnh*tan(lat)];