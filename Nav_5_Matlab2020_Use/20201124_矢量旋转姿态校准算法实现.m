%-----------------------通过矢量比对进行姿态测量---------------------
clear; clc;
mEuler = [35,28,13];   % zyx
q =quaternion(mEuler,'eulerd','ZYX','frame');
m_n = [23,0,45];
m_n = m_n./norm(m_n);
m_b = rotateframe(q, m_n);  %磁强计的输出
g_n = [0,0,1];
g_b = rotateframe(q, g_n);    %加计输出

mEuler_e = [28,21,19];  % 有误差的姿态
q_e = quaternion(mEuler_e,'eulerd','ZYX','frame');

%---------第一步 加计矢量纠正
g_b_e = rotateframe(q_e, g_n); 
%计算预测和加计之间的夹角及转动矢量
a_jia_angle = acos(g_b_e*g_b');
a_jia_vector = cross(g_b',g_b_e')';
a_jia_vector = a_jia_vector./norm(a_jia_vector);
q_a_pred = quaternion([cos(a_jia_angle/2),sin(a_jia_angle/2)*a_jia_vector(1),sin(a_jia_angle/2)*a_jia_vector(2),sin(a_jia_angle/2)*a_jia_vector(3)]);
q_a_new = q_e*q_a_pred;
eulerd(q_a_new, 'ZYX', 'frame')

%----------第二步 磁强计的矢量纠正
m_n_new =  rotateframe(conj(q_a_new), m_b);   %利用新的水平姿态矩阵 和 磁强计输出，逆推出n系下的磁矢量
% 计算n系下 磁矢量 在x y轴上的分量，及夹角
m_jia_angle = acos(m_n_new(1)/sqrt(m_n_new(1)^2+m_n_new(2)^2));    %这里具体要根据x y 的数值进行象限判断
m_jia_vector = [0,0,-1];
q_m_pred = quaternion([cos(m_jia_angle/2),sin(m_jia_angle/2)*m_jia_vector(1),sin(m_jia_angle/2)*m_jia_vector(2),sin(m_jia_angle/2)*m_jia_vector(3)]);
q_m_new = conj(q_a_new)*q_m_pred;
eulerd(conj(q_m_new), 'ZYX', 'frame')


%-----------------------直接利用电子罗盘方法 进行姿态测量---------------------
clear; clc;
mEuler = [35,28,13];   % zyx
q =quaternion(mEuler,'eulerd','ZYX','frame');
m_n = [23,0,45];
m_n = m_n./norm(m_n);
m_b = rotateframe(q, m_n);  %磁强计的输出
g_n = [0,0,1];
g_b = rotateframe(q, g_n);    %加计输出

orientation = ecompass(g_b,m_b);
eulerd(orientation, 'ZYX', 'frame')




