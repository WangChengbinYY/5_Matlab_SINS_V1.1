% ���� KF �������ݽ���
%-------------���ý������ݳ���
    Num_Start = 1;  Num_End = length(IMU);
%-------------������ʼ����
    Ts = 1/200;
    G_Const = CONST_Init();  
    
%-------------�������   
    Start_Att_theory = [-0.0845;0.0965;1.4706];  % ��̬����ֵ
    Start_Att_error = Start_Att_theory + 0.01;                        % ����ֵ + ���(Լ0.5��)     
    Gyro_Bias_theory = [-0.0617633;-0.006840;0.00976214];
    Gyro_Bias_error = Gyro_Bias_theory.*0.9; %��ƫ�����ƫ

%-------------KF�˲������趨
    Xk_1 = zeros(6,1);
    Pkk_1 = zeros(6,6);
    Ft = zeros(6,1);
    Phikk_1 = eye(6);    
    Zk = zeros(3,1);
    Hk = zeros(3,6);    
    % KF��ʼֵ�趨
    Gyro_Bias_KF = Gyro_Bias_error;
    %Gyro_Bias_KF = zeros(3,1);
    Xk = [0.01;0.01;0.01;0;0;0];   %X0=0;
    %Pk = diag([0.01,0.01,0.01,(Gyro_Bias_error-Gyro_Bias_theory)'])^2;
    Pk = diag([0.01,0.01,0.01,Gyro_Bias_theory'.*1000])^2;
    % �۲��������� ��ƫ���ȶ��� ����/s 
    Gyro_Bias_Const_Var = [9.435526099935672e-06;6.358767510985477e-06*0.02;1.989738785153631e-06];
    qt = diag(Gyro_Bias_Const_Var);   %��ƫ���ȶ���
    Att_Const_Var = [0.001;0.001;0.001].*(pi/180);
    rt = diag(Att_Const_Var);  %��̬���۲����
    % KF�˲�������ʼ��
    Hk(1:3,1:3) = eye(3);
    %Rk = rt/(nn);  
    Rk = rt;
    
%-----------------------�洢����    
    Num = Num_End - Num_Start + 1;
    Result_Att = zeros(Num,4);
    Result_Att(1,1) = IMU(1,1);
    Result_Att(1,2:4) = Start_Att_theory';
    % KF �洢
    
    Result_Att_KF = zeros(Num,4);
    Result_Att_KF(1,1) = IMU(1,1);
    Result_Att_KF(1,2:4) = Start_Att_error';
    nn = 50;
    XkPk = zeros(fix(Num/nn),12);
    Result_Bias_KF = zeros(fix(Num/nn),3);
    Result_Bias_KF(1,:) = Gyro_Bias_KF';
    j = 1;
    
for i = 2:Num_End
    %--------������̬����
    Result_Att(i,1) = IMU(i,1);
    Result_Att(i,2:4) = Result_Att(i-1,2:4) + ((IMU(i,5:7)'-Gyro_Bias_theory).*(Ts))';
    
    %---------KF �˲�
    Result_Att_KF(i,1) = IMU(i,1);
    Result_Att_KF(i,2:4) = Result_Att_KF(i-1,2:4) + ((IMU(i,5:7)'-Gyro_Bias_KF).*(Ts))';
    
    % KF ʱ�����
    % ����Ft
    Ft = zeros(6);
    Ft(1:3,4:6) = eye(3);
    % ���� Phikk_1
    Phikk_1 = Phikk_1*(eye(6)+Ft.*Ts);
        Gk_1 = [eye(3);zeros(3,3)];         
        Qk_1 = Gk_1*(qt)*Gk_1';                      %����1��ֱ��ʹ��   Qt = qt    
    % KF �������
    if mod(i,nn) == 0
        % Xkһ��Ԥ��
        Xkk_1 = Phikk_1*Xk;
        % ����Qk_1

        % һ��Ԥ����������
        Pkk_1 = Phikk_1*Pk*Phikk_1' + Qk_1;
        % �˲��������
        Kk = Pkk_1*Hk'*(Hk*Pkk_1*Hk'+Rk)^-1;         %����2�� ����  Rk = rt
        % ��ȡ�۲���
        %Zk = (Result_Att_KF(i,2:4) - Z_Att_HuDu(i,1:3))';             %��̬�۲���      
        Zk = Result_Att_KF(i,2:4)' - Start_Att_theory;
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
        Result_Att_KF(i,2:4) = Result_Att_KF(i,2:4) - Xk(1:3,1)'.*k;
        Xk(1:3,1) = Xk(1:3,1).*(1-k);
        Gyro_Bias_KF = Gyro_Bias_KF+Xk(4:6,1).*k; 
        Xk(4:6,1) = Xk(4:6,1).*(1-k);
        Result_Bias_KF(j,:) = Gyro_Bias_KF';
        j = j+1;
    else
        Xk = Phikk_1*Xk;
        Pk = Phikk_1*Pk*Phikk_1' + Qk_1;
    end
end    


% 5.������ƱȽ�
%Plot_AVP_Att_1(Result_Att_KF,Num);

Plot_Att_Bias_1(Gyro_Bias_theory,Result_Bias_KF,j-1);
Plot_XkPk_AttTest(XkPk);
Plot_AVP_Group_Att(Result_Att_KF,Result_Att,Num);
