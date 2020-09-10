function w_en_n = Earth_get_w_en_n(lat,vn,Rmh,Rnh)
% ����nϵ���eϵ��ת�ٶ���nϵ�µ�ͶӰw_en_n
%       ��������nϵ���� ������
% Inputs:   lat γ�ȣ���λ����
%           vn = [x;y;z] ������Ե����ٶ���nϵ�µ�ͶӰ����λ���� m
% Output:   w_en_n = [x;y;z]      ��λ ����/s 
%


w_en_n = [-vn(2,1)/Rmh;vn(1,1)/Rnh;vn(1,1)/Rnh*tan(lat)];