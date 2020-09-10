Angle = 0:0.5:10;
Angle = Angle.*(pi/180);
L = length(Angle);

a_nosie = [5,10,20,40,60,80,100]/1000;    %mg
M = length(a_nosie);
a_g = [0;0;1];      %���ۼ��ٶ�
att_error_pitch = zeros(M,L);
att_error_roll = zeros(M,L);
for i = 1:L
   att_theory = [Angle(1,i);Angle(1,i);45*pi/180];
   C_b_n = Att_Euler2DCM(att_theory);
   a_theory = C_b_n * a_g;
   % �Ӽ�x��������� ������
   for j = 1:M
       acc = a_theory + [a_nosie(1,j);a_nosie(1,j);a_nosie(1,j)];
       [pitch,roll] = Att_Accel2Att(acc(1,1),acc(2,1),acc(3,1));
       att_error_pitch(j,i) = (abs(pitch-Angle(1,i)))*180/pi;
       att_error_roll(j,i) = (abs(roll-Angle(1,i)))*180/pi;
   end    
end

x = 0:0.5:10;
y = [5,10,20,40,60,80,100];
[X,Y] = meshgrid(x,y);
figure; mesh(X,Y,att_error_pitch); xlabel('��������ֵ/��');ylabel('�Ӽ���ƫ/mg');zlabel('�Ƕ����/��');

x = 0:0.5:10;
y = [5,10,20,40,60,80,100];
[X,Y] = meshgrid(x,y);
figure; mesh(X,Y,att_error_roll); xlabel('�������ֵ/��');ylabel('�Ӽ���ƫ/mg');zlabel('�Ƕ����/��');
