function w_ie_n = Earth_get_w_ie_n(G_CONST,lat)
% ���������ת���ٶ���nϵ�µ�ͶӰw_ie_n
%       ��������nϵ���� ������
% Inputs:     ������ γ�ȣ���λ����
% Output:   w_ie_n = [x;y;z]      ��λ ����/s 
%

w_ie_n = [0; G_CONST.earth_wie*cos(lat); G_CONST.earth_wie*sin(lat)];