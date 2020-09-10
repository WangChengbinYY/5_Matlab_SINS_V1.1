% �趨�������ʼ�����ֹ��
clear;clc;
load('D:\�廪��ʿ\2_��ʿ����_JG\2_ʵ���¼\20200326_�칫���ڶ̾���2����\ԭ��������ת3Ȧ\MPU_L_1_43000_52300.mat')
Num_Start = 1;  Num_End = 1096;

Start_Att = [-0.0845;0.0965;1.4706];  %��ʼ��̬
Start_Vel = zeros(3,1);
Start_Pos = [0.5975;1.9017;400.0000];
Ts = 1/200;
G_Const = CONST_Init();

Num = 1096;
Result_Att = zeros(Num,4);

Gyro_Bias = [mean(IMU(1:Num,5));mean(IMU(1:Num,6));mean(IMU(1:Num,7))];
Acc_Bias = [0;0;0];

%(1)�ߵ�����ṹ���ʼ�� 
INSData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
INSData_Pre = INSData_Now; 

   for i = Num_Start:Num_End
        %(1)��ȡIMUԭʼ����
        INSData_Now.time = IMU(i,1);    
        INSData_Now.w_ib_b = IMU(i,5:7)';   %����          
        INSData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %�Ӽ� 
        
        %(2)���ݺͼӼ� ԭʼ��������
        %������ƫ����
        INSData_Now.w_ib_b = INSData_Now.w_ib_b - INSData_Now.eb;
        
        %(3)�ߵ�����
        INSData_Now = INS_Update_Static_Att(G_Const,INSData_Pre,INSData_Now,Ts);        
            
        %(4)���浼�����
        Result_Att(i,1) = INSData_Now.time;      
        Result_Att(i,2:4) = INSData_Now.att';
        
        %(5)���µ�������
        INSData_Pre =  INSData_Now;        
    end

% 5.������ƱȽ�
Plot_AVP_Group_Att(Result_Att,Result_0)