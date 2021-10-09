% ���ʵ������ 20200312_�칫���澲ֹ��ת
% �ɼ�ԭʼ���ݣ�2��IMU���ݶ�Ӧ1��Mag����
%   ��ǿ��������任 y x -z ��Ӧ���ݵ� x y z

%-------------------8λ�õ��㴦����------------------------
% �趨8�������ʼ��ֹλ��
%   ��ǿ�ƶ�Ӧ������λ�� Ϊ  (num+1)/2
%   ��9��ص�ԭʼλ�ã������ڱȽ��ظ��ԣ������ֹ�������һ�����룡

clear;clc;
IMU = importdata('D:\�廪��ʿ\n_ʵ���¼\20200312_�칫���澲ֹ��ת\MPU_L_1_UA_IMU_MPU.txt');
Magnetic(:,1:2) = IMU(:,1:2);    Magnetic(:,3:5) = IMU(:,9:11); 


Num = 9;
Location = zeros(Num,2);  %ÿ�����ݵ���ʼ��ֹλ��
Location(1,1) = 500;    Location(1,2) = 2000;      
Location(2,1) = 4000;   Location(2,2) = 6400;
Location(3,1) = 7000;   Location(3,2) = 9500;    
Location(4,1) = 12000;  Location(4,2) = 14500;
Location(5,1) = 15500;  Location(5,2) = 17500;   
Location(6,1) = 19000;  Location(6,2) = 21000;
Location(7,1) = 22280;  Location(7,2) = 24650;   
Location(8,1) = 26000;  Location(8,2) = 28000;
Location(9,1) = 29000;  Location(9,2) = 31000;  

% ��ȡ��ֵ
Mean_Acc = zeros(Num,3);
Mean_Mag = zeros(Num,3);
for i = 1:Num
    Mean_Acc(i,1:3) = mean(IMU(Location(i,1):Location(i,2),3:5));
    Temp = mean(Magnetic(fix((Location(i,1)+1)/2):fix((Location(i,2)+1)/2),3:5))/4;
    Mean_Mag(i,1) = Temp(1,2);  Mean_Mag(i,2) = Temp(1,1); Mean_Mag(i,3) = -Temp(1,3); 
end
figure;
plot(Mean_Mag(:,1),Mean_Mag(:,2),'*-'); grid on; 
hold on; plot(0,0,'ro');

% �ӼƵ�ƽ��ˮƽ��ǿ�Ƶ����
Mean_MagAcc = zeros(Num,3);
for i = 1:Num
    [pitch,roll] = Att_Accel2Att(Mean_Acc(i,1),Mean_Acc(i,2),Mean_Acc(i,3)); 
    att = [pitch;pitch;0];
    C_b_n = Att_Euler2DCM(att);
    Mean_MagAcc(i,:) = (C_b_n*[Mean_Mag(i,1);Mean_Mag(i,2);Mean_Mag(i,3)])';
end
figure;
plot(Mean_Mag(:,1),Mean_Mag(:,2),'*-'); grid on; 
hold on; plot(0,0,'ro'); 
hold on; plot(Mean_MagAcc(:,1),Mean_MagAcc(:,2),'o');

% ���ô�ǿ��������ȡ����
Yaw = zeros(Num,1);
Yaw_Acc = zeros(Num,1);
for i = 1:Num
    Yaw(i,1) = Att_Mag2Yaw(0,0,Mean_Mag(i,1),Mean_Mag(i,2),Mean_Mag(i,3));
    
    [pitch,roll] = Att_Accel2Att(Mean_Acc(i,1),Mean_Acc(i,2),Mean_Acc(i,3)); 
    Yaw_Acc(i,1) = Att_Mag2Yaw(pitch,roll,Mean_Mag(i,1),Mean_Mag(i,2),Mean_Mag(i,3));
end
Yaw = Yaw .*(-180/pi);
Yaw_Acc = Yaw_Acc .*(-180/pi);
figure;
plot(Yaw,'*-'); grid on; 
hold on; plot(Yaw_Acc,'ro'); 

% ���в�����ʶ  ������С���˽���
H01 = abs(max(Mean_Mag(:,1))-min(Mean_Mag(:,1)))/2;
B = zeros(Num,1);
A = zeros(Num,5);
X = zeros(5,1);
for i = 1:Num
%    B(i,1) = H01*H01;
%    A(i,1) = Mean_Mag(i,1)^2;
%    A(i,2) = Mean_Mag(i,2)^2;
%    A(i,3) = Mean_Mag(i,1)*Mean_Mag(i,2);
%    A(i,4) = Mean_Mag(i,1);
%    A(i,5) = Mean_Mag(i,2);
   B(i,1) = H01*H01;
   A(i,1) = Mean_MagAcc(i,1)^2;
   A(i,2) = Mean_MagAcc(i,2)^2;
   A(i,3) = Mean_MagAcc(i,1)*Mean_MagAcc(i,2);
   A(i,4) = Mean_MagAcc(i,1);
   A(i,5) = Mean_MagAcc(i,2);
end
X = (A'*A)^-1*A'*B;
c1 = X(1,1); c2 = X(2,1); c3 = X(3,1); c4 = X(4,1); c5 = X(5,1);
% ��������
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
% ����У׼
Mean_MagNew = zeros(Num,2);
for i = 1:Num
%     Mean_MagNew(i,:)=(A_h*K_h*[Mean_Mag(i,1)-b_x0;Mean_Mag(i,2)-b_y0])';
    Mean_MagNew(i,:)=(A_h*K_h*[Mean_MagAcc(i,1)-b_x0;Mean_MagAcc(i,2)-b_y0])';
end

figure;
plot(Mean_Mag(:,1),Mean_Mag(:,2),'*-'); grid on; 
hold on; plot(0,0,'ro');
hold on; plot(Mean_MagNew(:,1),Mean_MagNew(:,2),'r*-');

% ����У׼������ݽ��к������
Yaw_New = zeros(Num,1);
for i = 1:Num
    Yaw_New(i,1) = Att_Mag2Yaw(0,0,Mean_MagNew(i,1),Mean_MagNew(i,2),0);
end
Yaw_New = Yaw_New .*(-180/pi);
figure;
plot(Yaw,'*-'); grid on; 
hold on; plot(Yaw_New,'r*-');


figure;
hold on; plot(Mean_MagOld(:,1),Mean_MagOld(:,2),'*-');grid on; 
hold on; plot(0,0,'ro');
hold on; plot(Mean_MagNew(:,1),Mean_MagNew(:,2),'ro');

figure;
plot(Yaw_New,'*-'); grid on; 
% hold on; plot(Yaw_Old,'ro');