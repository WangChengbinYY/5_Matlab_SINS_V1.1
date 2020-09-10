function Rnh = Earth_get_Rnh(G_CONST,lat,h)
% ����Rnh   ����Ҫ γ�� �� �߳�
% Inputs:   ������ γ�ȡ��̣߳���λ���� m
% Output:   Rnh     ��λ m

Rnh = G_CONST.earth_Re/(1-G_CONST.earth_e^2*sin(lat)^2)^0.5 + h;
