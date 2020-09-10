function [A22,B21] = Calibration_Mag_2D(Mean_Mag)
% 利用旋转磁强计数据 进行 校准参数的求取
%   输入：Mean_Mag  3列 为 x y z轴磁强计数据

Num = length(Mean_Mag);
H01 = abs(max(Mean_Mag(:,1))-min(Mean_Mag(:,1)))/2;
B = zeros(Num,1);
A = zeros(Num,5);
X = zeros(5,1);
for i = 1:Num
   B(i,1) = H01*H01;
   A(i,1) = Mean_Mag(i,1)^2;
   A(i,2) = Mean_Mag(i,2)^2;
   A(i,3) = Mean_Mag(i,1)*Mean_Mag(i,2);
   A(i,4) = Mean_Mag(i,1);
   A(i,5) = Mean_Mag(i,2);
end
X = (A'*A)^-1*A'*B;
c1 = X(1,1); c2 = X(2,1); c3 = X(3,1); c4 = X(4,1); c5 = X(5,1);
% 参数解算
b_x0 = (c3*c5-2*c2*c4)/(4*c1*c2-c3^2);
b_y0 = (c3*c5-2*c1*c5)/(4*c1*c2-c3^2);
Temp = c3/2/sqrt(abs(c1*c2));
if c1<0
    Temp = -Temp;
end
PHi_p = -asin(Temp)/2;
k_x = 1; k_y = sqrt(abs(c1/c2));
A_h = [cos(PHi_p),sin(PHi_p);sin(PHi_p),cos(PHi_p)]^-1;
K_h = [1,0;0,k_y]^-1;

A22 = A_h*K_h;
B21 = [b_x0;b_y0];



