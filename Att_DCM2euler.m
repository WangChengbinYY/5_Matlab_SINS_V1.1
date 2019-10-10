function Euler = Att_DCM2euler(C_b_n)
% 将输入的旋转矩阵 转为 欧拉姿态角
%       n系 东北天；b系 右前上
% Inputs:   C_b_n DCM from body-frame to navigation-frame
% Output:   Euler - Euler=[pitch; roll; yaw] in radians
%


pitch = asin(C_b_n(3,2));
Euler(1,1) = pitch;
roll = -atan(C_b_n(3,1)/C_b_n(3,3));
if C_b_n(3,3) >= 0.0
    Euler(2,1) = roll;
else
    if roll >= 0.0
        Euler(2,1) = roll-pi;
    else
        Euler(2,1) = roll+pi;
    end
end

if abs(C_b_n(2,2)) <= 1e-8
    if C_b_n(1,2) >= 0.0
        Euler(3,1) = -pi/2;
    else
        Euler(3,1) = pi/2;
    end        
else
    yaw = -atan(C_b_n(1,2)/C_b_n(2,2));
    if C_b_n(2,2) >= 0.0
        Euler(3,1) = yaw;
    else
        if C_b_n(1,2) >= 0.0
            Euler(3,1) = yaw - pi;
        else
            Euler(3,1) = yaw + pi;
        end
    end
end

