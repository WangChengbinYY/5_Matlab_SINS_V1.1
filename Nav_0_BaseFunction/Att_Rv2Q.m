function Q = Att_Rv2Q(rv)
% 将输入的旋转矢量 变换成 四元数 
%       n系 东北天；b系 右前上
% Inputs:   rv - rotation vector
% Output:   Q - corresponding transformation quaternion, such that
%             Q = [ cos(|rv|/2); sin(|rv|/2)/|rv|*rv ]
%
 
    Q = zeros(4,1);
    n2 = rv(1)*rv(1) + rv(2)*rv(2) + rv(3)*rv(3);
    if n2<1.0e-8  % cos(n/2)=1-n2/8+n4/384; sin(n/2)/n=1/2-n2/48+n4/3840
        Q(1) = 1-n2*(1/8-n2/384); s = 1/2-n2*(1/48-n2/3840);
    else
        n = sqrt(n2); n_2 = n/2;
        Q(1) = cos(n_2); s = sin(n_2)/n;
    end
    Q(2) = s*rv(1); Q(3) = s*rv(2); Q(4) = s*rv(3);