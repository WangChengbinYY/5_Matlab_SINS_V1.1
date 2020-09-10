% ���Ժ��˽���KF�˲��㷨
%      clear;clc;
%      load('D:\�廪��ʿ\2_��ʿ����_JG\2_ʵ���¼\20200326_�칫���ڶ̾���2����\ԭ��������ת3Ȧ\MPU_L_1_43000_52300.mat')    
% ���ý������ݳ���
    %Num_Start = 1;  Num_End = 1000;
    Num_Start = 1;  Num_End = length(IMU);
% ������ʼ����
    Start_Att = [-0.0845;0.0965;1.4706];  %��ʼ��̬
    %Start_Att = [0;0;0];
    Start_Vel = zeros(3,1);
    Start_Pos = [0.5975;1.9017;400.0000];
    Ts = 1/200;
    G_Const = CONST_Init();
    % KF�˲������趨
    Xk_1 = zeros(6,1);
    Pkk_1 = zeros(6,6);
    Ft = zeros(6,1);
    Phikk_1 = eye(6);    
    Zk = zeros(3,1);
    Hk = zeros(3,6);
    % �۲��������� ��ƫ���ȶ��� ����/s
    %qt = diag([0.003071,0.002521,0.001410])^2;   %��ƫ���ȶ���
    qt = diag([9.435526099935672e-06,6.358767510985477e-06,1.989738785153631e-06]);
    rt = diag([0.0001 0.0001 0.0001].*(pi/180))^2;  %��̬���۲����
    % KF�˲�������ʼ��
    nn = 10; %�˲����� 10��������
    %Bias_mean = Gyro_Mean_Plot(IMU,nn,Num_End);
    Hk(1:3,1:3) = eye(3);
    Rk = rt/(Ts*nn);    
    % KF��ʼֵ�趨
    %Xk = [0.1*pi/180;0.1*pi/180;0.1*pi/180;-0.06;-0.006;0.013];   %X0=0;
    Xk = [0.01*pi/180;0.01*pi/180;0.01*pi/180;-0.0617633;-0.006840;0.00976214];   %X0=0;
    Pk = diag([0.0001*pi/180,0.0001*pi/180,0.0001*pi/180,0.003071,0.002521,0.001410])^2;
% �ߵ���������
    Gyro_Bias = [-0.0617633;-0.006840;0.00976214];  %ǰ1000������ƽ��ֵ
    Acc_Bias = [0;0;0];    
    AttData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
    AttData_Pre = AttData_Now;        
% �洢����    
    Num = Num_End - Num_Start + 1;
    Result_Att_KF = zeros(Num,4);
    Result_GyroBias = zeros(fix(Num/nn),3);
    XkPk = zeros(fix(Num/nn),12);
    Result_Zk = zeros(fix(Num/nn),3);
    j = 1;
    
    Att_Pre = Start_Att;
    
for i = Num_Start:Num_End
    %--------������̬����
    %(1)��ȡIMUԭʼ����
    AttData_Now.time = IMU(i,1);    
    AttData_Now.w_ib_b = IMU(i,5:7)';   %����          
    AttData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %�Ӽ� 
    %(2)������ƫ����
    AttData_Now.w_ib_b = AttData_Now.w_ib_b - Gyro_Bias;    
     %(3)��̬����
    AttData_Now = INS_Update_Static_Att(G_Const,AttData_Pre,AttData_Now,Ts);   

     
    % KF ʱ�����
        % ����Ft
            Ft(1:3,4:6) = -AttData_Now.C_b_n;
        % ���� Phikk_1
            Phikk_1 = Phikk_1*(eye(6)+Ft.*Ts);
    % KF �������
    if mod(i,nn) == 0
        % Xkһ��Ԥ��
        Xkk_1 = Phikk_1*Xk;
        % ����Qk_1
        Gk_1 = [-AttData_Now.C_b_n;zeros(3,3)];    %����1 ������㲢����̫��ȷ��
        Qk_1 = Gk_1*(qt*(Ts*nn))*Gk_1';                %����2 ��������Ϲ�����˵�� ֱ�ӵ�ЧΪ Qk �Ƿ�������
        % һ��Ԥ����������
        Pkk_1 = Phikk_1*Pk*Phikk_1' + Qk_1;
        % �˲��������
        Kk = Pkk_1*Hk'*(Hk*Pkk_1*Hk'+Rk)^-1;
        % ��ȡ�۲���
        Zk = AttData_Now.att - Start_Att;   %��̬��α�۲���        
        % ״̬����
        Xk = Xkk_1 + Kk*(Zk - Hk*Xkk_1);
        % ״̬���ƾ��������
        Pk = (eye(6)-Kk*Hk)*Pkk_1;       
        
        % ״̬���Ʊ���
        XkPk(j,1:6) = Xk';
        XkPk(j,7:12) = sqrt(diag(Pk)');        
        
        % ״̬����
            % ��̬����   ����ϵ��k    %����3 �Ƿ�ȫ����
            k = 1;
            phi = Xk(1:3,1).*k;
            AttData_Now.att = AttData_Now.att - phi;
            AttData_Now.C_b_n = Att_Euler2DCM(AttData_Now.att);
            AttData_Now.Q_b_n = Att_DCM2Q(AttData_Now.C_b_n);

%             AttData_Now.Q_b_n = Math_QmulQ(Att_Rv2Q(phi), AttData_Now.Q_b_n);
%             AttData_Now.C_b_n = Att_Q2DCM(AttData_Now.Q_b_n);
%             AttData_Now.att = Att_DCM2euler(AttData_Now.C_b_n);

            % ��ƫ����
              Gyro_Bias = Xk(4:6,1);
            % ��¼��ƫ
            Result_GyroBias(j,1:3) =  Gyro_Bias';
            Result_Zk(j,1:3) = Zk';
              Xk(1:3,1) = zeros(3,1);
            
        j = j+1;
        Phikk_1 = eye(6);
            
        %������
        % (4)���浼�����
        Result_Att_KF(i,1) = AttData_Now.time;      
        Result_Att_KF(i,2:4) = AttData_Now.att';
        %(5)���µ�������
        AttData_Pre =  AttData_Now;          
    else
        %(4)���浼�����
        Result_Att_KF(i,1) = AttData_Now.time;      
        Result_Att_KF(i,2:4) = AttData_Now.att';
        %(5)���µ�������
        AttData_Pre =  AttData_Now;    
     end   
    
     
end    
 

% 5.������ƱȽ�
Plot_AVP_Group_Att(Result_Att_KF,Result_Att,Num);
% figure;plot(XkPk(:,1).*(180/pi));
% figure;plot((Result_Att(:,2)-Start_Att(1,1)).*(180/pi),'r');