function [Pitch,Roll] = Att_Accel2Att(fx,fy,fz)
% 静止状态下：根据输入的加速度计信息求取水平姿态角 
%       n系 东北天；b系 右前上
%

Temp_g = sqrt(fx^2+fy^2+fz^2);
Pitch = asin(fy/Temp_g);
Roll = -atan(fx/fz);
