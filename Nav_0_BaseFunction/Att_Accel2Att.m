function [Pitch,Roll] = Att_Accel2Att(fx,fy,fz)
% ��ֹ״̬�£���������ļ��ٶȼ���Ϣ��ȡˮƽ��̬�� 
%       nϵ �����죻bϵ ��ǰ��
%

Temp_g = sqrt(fx^2+fy^2+fz^2);
Pitch = asin(fy/Temp_g);
Roll = -atan(fx/fz);
