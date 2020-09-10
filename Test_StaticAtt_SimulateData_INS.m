% ���� KF �������ݽ���
%-------------���ý������ݳ���
% clear all;clc;
% load('D:\N_WorkSpace_GitHub\5_Matlab\5_Matlab_SINS_V1.1\0_ʵ������\IMU_Simulate_Low.mat');
glvs
    Num_Start = 1;  Num_End = length(IMU);
%-------------������ʼ����
    Ts = 1/200;
    G_Const = CONST_Init();  
    
%-------------�������   
    %Start_Att_theory = [4.5;5.5;85].*(pi/180);  % ��̬����ֵ
    Start_Att_theory = zeros(3,1);
    Start_Att_error = Start_Att_theory + 0.01;                        % ����ֵ + ���(Լ0.5��)     
    Gyro_Bias_theory = [-0.0617633;-0.006840;0.00976214];
    %Gyro_Bias_theory = [0.01*glv.dph;0.01*glv.dph;0.01*glv.dph];
    Gyro_Bias_error = Gyro_Bias_theory.*0.9; %��ƫ�����ƫ

    Start_Vel = zeros(3,1);
    Start_Pos = [34.2*(pi/180);108.9*(pi/180);400.0];
    
%-------------KF�˲������趨
    Xk_1 = zeros(6,1);
    Pkk_1 = zeros(6,6);
    Ft = zeros(6,1);
    Phikk_1 = eye(6);    
    Zk = zeros(3,1);
    Hk = zeros(3,6);    
    % KF��ʼֵ�趨
    %Gyro_Bias_KF = Gyro_Bias_error;
    Gyro_Bias_KF = zeros(3,1);
    Xk = [0.01;0.01;0.01;0.1;0.1;0.1];   %X0=0;
    %Pk = diag([0.01,0.01,0.01,(Gyro_Bias_error-Gyro_Bias_theory)'])^2;
    Pk = diag([0.01,0.01,0.01,0.1,0.1,0.1])^2;
    % �۲��������� ��ƫ���ȶ��� ����/s 
    Gyro_Bias_Const_Var = [0.001*glv.dpsh;0.001*glv.dpsh;0.001*glv.dpsh,];
    qt = diag(Gyro_Bias_Const_Var)^2;   %��ƫ���ȶ���
    Att_Const_Var = [0.1;0.1;0.1].*(pi/180);
    rt = diag(Att_Const_Var)^2;  %��̬���۲����
    % KF�˲�������ʼ��
    Hk(1:3,1:3) = eye(3);
    %Rk = rt/(nn);  
    Rk = rt;
    
%-----------------------�洢����    
    Num = Num_End - Num_Start + 1;
    % ���ֽ���
    Result_Att_JiFen = zeros(Num,4);
    Result_Att_JiFen(1,1) = IMU(1,1);
    Result_Att_JiFen(1,2:4) = Start_Att_theory';
    % ��̬����
    Result_Att_INS = zeros(Num,4);
    Result_Att_INS(1,1) = IMU(1,1);
    Result_Att_INS(1,2:4) = Start_Att_theory';
    %(1)�ߵ�����ṹ���ʼ�� 
    AttData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att_theory,Start_Vel,Start_Pos,Gyro_Bias_theory,[0;0;0],Ts);
    AttData_Pre = AttData_Now;     
    
    % KF �洢    
    Result_Att_KF = zeros(Num,4);
    Result_Att_KF(1,1) = IMU(1,1);
    Result_Att_KF(1,2:4) = Start_Att_error';
    nn = 200;
    XkPk = zeros(fix(Num/nn),12);
    Result_Bias_KF = zeros(fix(Num/nn),3);
    Result_Bias_KF(1,:) = Gyro_Bias_KF';
    j = 1;
    C_b_n_Const = AttData_Now.C_b_n;
for i = 2:Num
    %--------������̬����
    Result_Att_JiFen(i,1) = IMU(i,1);
    Result_Att_JiFen(i,2:4) = Result_Att_JiFen(i-1,2:4) + ((IMU(i,5:7)'-Gyro_Bias_theory).*(Ts))';
    
    %--------�ߵ���̬����
    AttData_Now.time = IMU(i,1);    
    AttData_Now.w_ib_b = IMU(i,5:7)';   %����          
    AttData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %�Ӽ� 
    %������ƫ����
    AttData_Now.w_ib_b = AttData_Now.w_ib_b - Gyro_Bias_KF;
    %AttData_Now.w_ib_b = AttData_Now.w_ib_b;
    AttData_Now = INS_Update_Static_Att(G_Const,AttData_Pre,AttData_Now,Ts);  
    %���浼�����
    Result_Att_INS(i,1) = AttData_Now.time;      
    Result_Att_INS(i,2:4) = AttData_Now.att';
    %���µ�������
    AttData_Pre =  AttData_Now;  
            
    %---------KF �˲�  
    % KF ʱ�����
    % ����Ft
    Ft = zeros(6);
    Ft(1:3,4:6) = eye(3);
    Ft(1:3,4:6) = AttData_Now.C_b_n;
%     Ft(4,4) = -1/100;Ft(5,5) = -1/100;Ft(6,6) = -1/100;
    %Ft(1:3,4:6) = C_b_n_Const;
    % ���� Phikk_1
    Phikk_1 = Phikk_1*(eye(6)+Ft.*Ts); 
    
    % ����Qk_1
    Gk_1 = [eye(3);zeros(3,3)];       
    Gk_1 = [AttData_Now.C_b_n;zeros(3,3)]; 
    %Gk_1 = [C_b_n_Const;zeros(3,3)]; 
    Qk_1 = Gk_1*(qt)*Gk_1';                      %����1��ֱ��ʹ��   Qt = qt
    
    % KF �������
    if mod(i,nn) == 0
        % Xkһ��Ԥ��
        Xkk_1 = Phikk_1*Xk;

        % һ��Ԥ����������
        Pkk_1 = Phikk_1*Pk*Phikk_1' + Qk_1;
        % �˲��������
        Kk = Pkk_1*Hk'*(Hk*Pkk_1*Hk'+Rk)^-1;         %����2�� ����  Rk = rt
        % ��ȡ�۲���
        % ��̬�۲����Ļ�ȡ
        Att_Cal = AttData_Now.att;
        C_Cal = Att_Euler2DCM(Att_Cal);
        Att_Mea = Start_Att_theory;
        C_Mea = Att_Euler2DCM(Att_Mea);
        C_Z = C_Cal*C_Mea';
        Zk = Att_DCM2euler(C_Z);
        %Zk = (Result_Att_INS(i,2:4) - Z_Att_HuDu(i,1:3))';             %��̬�۲���      
        %Zk = Result_Att_INS(i,2:4)' - Start_Att_theory;
        % ״̬����
        Xk = Xkk_1 + Kk*(Zk - Hk*Xkk_1);
        % ״̬���ƾ��������
        Pk = (eye(6)-Kk*Hk)*Pkk_1;       
        
        % ״̬���Ʊ���
        XkPk(j,1:6) = Xk';
        XkPk(j,7:12) = diag(Pk)'; 
        Phikk_1 = eye(6);     

        % ��̬����   ����ϵ��k    %����3 �Ƿ�ȫ����
        k = 1;                
        error_att = Xk(1:3,1).*k;
        Xk(1:3,1) = Xk(1:3,1).*(1-k);
        %Gyro_Bias_KF = Gyro_Bias_KF+Xk(4:6,1).*k; 
        Gyro_Bias_KF = Xk(4:6,1); 
        Result_Bias_KF(j,:) = Gyro_Bias_KF';
        %��ϸ������
        C_error = Att_Euler2DCM(error_att);
        AttData_Now.C_b_n = C_error'*AttData_Now.C_b_n;
        AttData_Now.att = Att_DCM2euler(AttData_Now.C_b_n);
        AttData_Now.Q_b_n = Att_DCM2Q(AttData_Now.C_b_n);
       
        AttData_Pre =  AttData_Now;  
        j = j+1;  
        
        Result_Att_INS(i,1) = AttData_Now.time;      
        Result_Att_INS(i,2:4) = AttData_Now.att';
        
    else
        Xk = Phikk_1*Xk;
        Pk = Phikk_1*Pk*Phikk_1' + Qk_1;
        
    end
end    


% 5.������ƱȽ�
%Plot_AVP_Group_Att(Result_Att_INS,Result_att);
Plot_AVP_Group_Att(Result_Att_INS,Result_Att_JiFen,Num);
Plot_Att_Bias_1(Gyro_Bias_theory,Result_Bias_KF,j-1);
Plot_XkPk_AttTest(XkPk);

