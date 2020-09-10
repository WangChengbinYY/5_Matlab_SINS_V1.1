%---------------------------���ɷ�������

%% ��������
clear;clc;
%����Ƶ��
Hz = 200;
% ��ֵ��ƫ ��/h
%Gyro_Bias_Const = [50;80;60].*(pi/180/3600);
Gyro_Bias_Const = [-0.0617633;-0.006840;0.00976214];   %����/s
Start_Pos = [34.2*(pi/180);108.9*(pi/180);400.0];
G_Const = CONST_Init();
% ��ֵ��ƫ ������ ���� (����/s)^2
Gyro_Bias_Const_Var = [9.435526099935672e-06;6.358767510985477e-06;1.989738785153631e-06];
% ����ʱ�� s
Time = 60*10;
% �������ݳ���
L = Hz*Time;
% IMU����
IMU = zeros(L,7);
IMU(:,1) = 1/Hz:1/Hz:Time;
Noise = wgn(1,L,10*log10(Gyro_Bias_Const_Var(1,1)))'; Noise = Noise-mean(Noise);
IMU(:,5) = Noise + Gyro_Bias_Const(1,1);
Noise = wgn(1,L,10*log10(Gyro_Bias_Const_Var(2,1)))'; Noise = Noise-mean(Noise);
IMU(:,6) = Noise + Gyro_Bias_Const(2,1)+cos(Start_Pos(1,1))*G_Const.earth_wie;
% IMU(:,6) = Noise + Gyro_Bias_Const(2,1);
Noise = wgn(1,L,10*log10(Gyro_Bias_Const_Var(3,1)))'; Noise = Noise-mean(Noise);
IMU(:,7) = Noise + Gyro_Bias_Const(3,1)+sin(Start_Pos(1,1))*G_Const.earth_wie;
% IMU(:,7) = Noise + Gyro_Bias_Const(3,1);

%% �۲�����
% �۲��ֵ
    Att_Const = [-0.0845;0.0965;1.4706].*(180/pi);
% ��ͬ�Ĺ۲��������� 0.001��
    Att_Const_Var = [0.0001;0.0001;0.0001];
    Noise = wgn(1,L,10*log10(Att_Const_Var(1,1)))'; Noise = Noise-mean(Noise);
% ����Ĺ۲�����
    Z_Att = zeros(L,3);
    Z_Att(:,1) = ones(L,1)*Att_Const(1,1) + Noise;
    Z_Att(:,2) = ones(L,1)*Att_Const(2,1) + Noise;
    Z_Att(:,3) = ones(L,1)*Att_Const(3,1) + Noise;
    Z_Att_HuDu = Z_Att.*(pi/180);
    
%%-----------------��̬�������� ��������
% clear;clc;
%    % �������ݳ���
%     Hz = 200;
%     Time = 60*10;  %��
%     L = Hz*Time;
%     % IMU����
%     IMU = zeros(L,7);
%     IMU(:,1) = 1/Hz:1/Hz:Time; 
%     G_Const = CONST_Init();
%     Start_Pos = [0.5975;1.9017;400.0000];
%     
%     IMU(:,5) = zeros(L,1);
%     IMU(:,6) = ones(L,1)*cos(Start_Pos(1,1))*G_Const.earth_wie;
%     IMU(:,7) = ones(L,1)*sin(Start_Pos(1,1))*G_Const.earth_wie;



    