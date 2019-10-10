function Q_b_n = Att_DCM2Q(C_b_n)
% 由输入的旋转矩阵 计算对应的四元数 
%       n系 东北天；b系 右前上
% Inputs:   C_b_n - DCM from body-frame to navigation-frame
% Output:   Q_b_n - attitude quaternion
%


    C11 = C_b_n(1,1); C12 = C_b_n(1,2); C13 = C_b_n(1,3); 
    C21 = C_b_n(2,1); C22 = C_b_n(2,2); C23 = C_b_n(2,3); 
    C31 = C_b_n(3,1); C32 = C_b_n(3,2); C33 = C_b_n(3,3); 
    if C11>=C22+C33
        q1 = 0.5*sqrt(1+C11-C22-C33);  qq4 = 4*q1;
        q0 = (C32-C23)/qq4; q2 = (C12+C21)/qq4; q3 = (C13+C31)/qq4;
    elseif C22>=C11+C33
        q2 = 0.5*sqrt(1-C11+C22-C33);  qq4 = 4*q2;
        q0 = (C13-C31)/qq4; q1 = (C12+C21)/qq4; q3 = (C23+C32)/qq4;
    elseif C33>=C11+C22
        q3 = 0.5*sqrt(1-C11-C22+C33);  qq4 = 4*q3;
        q0 = (C21-C12)/qq4; q1 = (C13+C31)/qq4; q2 = (C23+C32)/qq4;
    else
        q0 = 0.5*sqrt(1+C11+C22+C33);  qq4 = 4*q0;
        q1 = (C32-C23)/qq4; q2 = (C13-C31)/qq4; q3 = (C21-C12)/qq4;
    end
    Q_b_n = [q0; q1; q2; q3];