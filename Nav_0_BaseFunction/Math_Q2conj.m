function Qo = Math_Q2conj(Qi)
% 求输入四元数的共轭四元数.
% 
% Input:    Qi - input quaternion
% Output:   Qo - output quaternion ,if Qi = [Qi(1); Qi(2:4)]
%              then Qi = [Qi(1); -Qi(2:4)]


    Qo = [Qi(1); -Qi(2:4)];