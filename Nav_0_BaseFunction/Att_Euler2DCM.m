function C_b_n = Att_Euler2DCM(att)
% �������ŷ���� �任�� DCM  
%       nϵ �����죻bϵ ��ǰ��
%       ŷ���� (-z)-x-y
% ����:   att - att=[pitch; roll; yaw] ��λ����  �����������м�����ĺ�����˳ʱ��Ϊ������ʱ��Ϊ��
% ���:   C_b_n bϵ��nϵ����ת����
%

s_pitch = sin(att(1,1));    c_pitch = cos(att(1,1));
s_roll = sin(att(2,1));     c_roll = cos(att(2,1));
s_yaw = sin(att(3,1));      c_yaw = cos(att(3,1));

C_b_n = [c_roll*c_yaw-s_pitch*s_roll*s_yaw,     -c_pitch*s_yaw,	s_roll*c_yaw+s_pitch*c_roll*s_yaw;
            c_roll*s_yaw+s_pitch*s_roll*c_yaw,  c_pitch*c_yaw,	s_roll*s_yaw-s_pitch*c_roll*c_yaw;
           -c_pitch*s_roll,                     s_pitch,        c_pitch*c_roll      ];
