function C_b_n = Att_Euler2DCM(att)
% 将输入的欧拉角 变换成 DCM  
%       n系 东北天；b系 右前上
%       欧拉角 (-z)-x-y
% 输入:   att - att=[pitch; roll; yaw] 单位弧度  ！！！这里切记输入的航向，是顺时针为负，逆时针为正
% 输出:   C_b_n b系到n系的旋转矩阵
%

s_pitch = sin(att(1,1));    c_pitch = cos(att(1,1));
s_roll = sin(att(2,1));     c_roll = cos(att(2,1));
s_yaw = sin(att(3,1));      c_yaw = cos(att(3,1));

C_b_n = [c_roll*c_yaw-s_pitch*s_roll*s_yaw,     -c_pitch*s_yaw,	s_roll*c_yaw+s_pitch*c_roll*s_yaw;
            c_roll*s_yaw+s_pitch*s_roll*c_yaw,  c_pitch*c_yaw,	s_roll*s_yaw-s_pitch*c_roll*c_yaw;
           -c_pitch*s_roll,                     s_pitch,        c_pitch*c_roll      ];
