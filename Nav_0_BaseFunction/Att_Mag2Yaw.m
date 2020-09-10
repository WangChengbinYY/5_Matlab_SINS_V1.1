function Yaw = Att_Mag2Yaw(Pitch,Roll,Magx,Magy,Magz)
% 根据输入的水平姿态角和磁强计数据，计算航向角
%       n系 东北天；b系 右前上
%       欧拉角旋转顺序为 -Z X Y  航向 俯仰 横滚  单位:弧度
%   注意：这里求解 航向时，按照东北天坐标系，顺时针为正！！！！

%1. 依据姿态角求解旋转矩阵 C_b_n b系到n系的旋转矩阵
att = [Pitch;Roll;0];
C_b_n = Att_Euler2DCM(att);

Mag = C_b_n*[Magx;Magy;Magz];
Mag_x = Mag(1,1); Mag_y = Mag(2,1);

if Mag_x >= 0 && Mag_y > 0 
   Yaw = atan(abs(Mag_x/Mag_y));    
    return;
end
if Mag_x > 0 && Mag_y == 0 
   Yaw = pi/2;    
    return;
end
if Mag_x > 0 && Mag_y < 0 
   Yaw = pi - atan(abs(Mag_x/Mag_y));    
    return;
end
if Mag_x <= 0 && Mag_y < 0 
   Yaw = -pi + atan(abs(Mag_x/Mag_y));    
    return;
end
if Mag_x < 0 && Mag_y == 0 
   Yaw = -pi/2;                                                                                                                                                   n                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       mmmmmmmmmmmmmm
    return;
end
if Mag_x < 0 && Mag_y > 0 
   Yaw = -atan(abs(Mag_x/Mag_y));    
    return;
end