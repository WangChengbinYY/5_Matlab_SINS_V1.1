function Distance = Cal_Distance_Pos2Pos(Pos0,Pos1)
% ����������γ������֮��ľ���
% Inputs:   λ������  γ�� ���� �߳� ��λ������ ��
% Output:   ������Ϣ ��
%

%�򵥼���һ�£��п��ܲ�׼ȷ  γ�ȶ�Ӧ��Rmh ���ȶ�Ӧ��Rnh
G_CONST = CONST_Init();
Rmh = Earth_get_Rmh(G_CONST,Pos0(1,1),Pos0(3,1));
Rnh = Earth_get_Rnh(G_CONST,Pos0(1,1),Pos0(3,1));
x = Rnh*abs(Pos1(2,1)-Pos0(2,1));
y = Rmh*abs(Pos1(1,1)-Pos0(1,1));
z = abs(Pos1(3,1)-Pos0(3,1));

Distance = sqrt(x^2+y^2+z^2);

