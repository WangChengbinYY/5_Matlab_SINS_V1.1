function Distance = Cal_Distance_Pos2Pos(Pos0,Pos1)
% 计算两个经纬度坐标之间的距离
% Inputs:   位置坐标  纬度 经度 高程 单位：弧度 米
% Output:   距离信息 米
%

%简单计算一下，有可能不准确  纬度对应的Rmh 经度对应的Rnh
G_CONST = CONST_Init();
Rmh = Earth_get_Rmh(G_CONST,Pos0(1,1),Pos0(3,1));
Rnh = Earth_get_Rnh(G_CONST,Pos0(1,1),Pos0(3,1));
x = Rnh*abs(Pos1(2,1)-Pos0(2,1));
y = Rmh*abs(Pos1(1,1)-Pos0(1,1));
z = abs(Pos1(3,1)-Pos0(3,1));

Distance = sqrt(x^2+y^2+z^2);

