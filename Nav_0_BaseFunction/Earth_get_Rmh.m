function Rmh = Earth_get_Rmh(G_CONST,lat,h)
% ����Rmh ����Ҫ γ�� �� �߳�
% Inputs:   ������ γ�ȡ��̣߳���λ���� m
% Output:   Rmh     ��λ m
%

Rmh = G_CONST.earth_Re*(1-G_CONST.earth_e^2)/(1-G_CONST.earth_e^2*sin(lat)^2)^1.5 + h;