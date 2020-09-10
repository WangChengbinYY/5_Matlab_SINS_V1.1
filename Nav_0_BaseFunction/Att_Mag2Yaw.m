function Yaw = Att_Mag2Yaw(Pitch,Roll,Magx,Magy,Magz)
% ���������ˮƽ��̬�Ǻʹ�ǿ�����ݣ����㺽���
%       nϵ �����죻bϵ ��ǰ��
%       ŷ������ת˳��Ϊ -Z X Y  ���� ���� ���  ��λ:����
%   ע�⣺������� ����ʱ�����ն���������ϵ��˳ʱ��Ϊ����������

%1. ������̬�������ת���� C_b_n bϵ��nϵ����ת����
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