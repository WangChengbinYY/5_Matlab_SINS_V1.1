% 20190421_2_�Ͼ��ٳ��ڶ���һȦ��ѹ��  ���ݴ���
% 
% profile on

%% 1.��ȡ����
     clc;
     clear;
    load('20191024_�廪ʵ����¥����Ŵ�ѹ���¶��ȶ��߸�����.mat');
    %����ǰ�澲ֹ״̬�£����ü��ٶȼ���ˮƽ��̬��
    Data_IMU = Data_IMUB_L;
    Temp_Number = 2000;
    Temp_f = [mean(Data_IMU(1:Temp_Number,2));mean(Data_IMU(1:Temp_Number,3));mean(Data_IMU(1:Temp_Number,4))];
    [Temp_Pitch,Temp_Roll]=Att_Accel2Att(Temp_f(1,1),Temp_f(2,1),Temp_f(3,1));
    Temp_Pitch*180/pi;
    Temp_Roll*180/pi;
%% 2.��ʼ������
%% 2.1 ȫ�ֲ���
    G_Const = CONST_Init();
    G_IMU.Hz = 200;  
    Ts = 1/G_IMU.Hz;  %�������50ms
    [L,m] = size(Data_IMU);
%% 2.2 �����Ϣ
    G_Start_Att = [Temp_Pitch;Temp_Roll;-90*pi/180];
    G_Start_Vel = [0;0;0];
    G_Start_Pos = [40.003575*pi/180;116.337489*pi/180;50];   %����ϵ����40.003575 116.337489
    clear Temp_Number Temp_f Temp_Pitch Temp_Roll;
%% 2.3 ������Ʋ�������
    %(1)����ʱ��
    %L = 80*1000;
    %(2)IMU��������
    imuerr.bias_gyro=[0;0;0];                   %���ݳ�ֵ��ƫ
    imuerr.bias_acc=[0;0;0];                    %�ӼƳ�ֵ��ƫ
    imuerr.eb = [2.5;2.5;2.5].*pi/180/3600;     %������ƫ���ȶ��� ��/h;  �����ֲ��� ת��Ϊ rad/s
    imuerr.db = [13;13;13].*1e-6*9.7803267714;  %�Ӽ���ƫ���ȶ��� ug;    �����ֲ��� ת��Ϊ m/s
    imuerr.web = [0.15;0.15;0.15].*pi/180/sqrt(3600);    %���ݽǶ��������ARW du/sqrt(h) �����ֲ��� ת��Ϊ rad/s
    imuerr.wdb = [0.037;0.037;0.037]./sqrt(3600);    %�Ӽ��ٶ��������VRW m/s/sqrt(h) �����ֲ��� ת��Ϊ m/s
    
    %ͨ��У׼�õ��� ���ٶȼ� ������   �ԡ�20191028_ADIS�廪����Ԥ�Ⱥ�6λ�����ݲɼ�.mat�����ݽ��б�У���Ƶõ��Ľ��
    M_a = [ 0.998399276848119,-0.00397028074921105,-0.00785084769711597,-0.0176094161989268;
            0.00191732435213797,0.998374888862787,0.00848871511161596,0.00282715789554676;
            0.00861374365798878,-0.00471224768141091,0.998030948532028,-0.000527073119519568];
    M_g = [ 1,-0.00397028074921105,-0.00785084769711597;
        0.00191732435213797,1,0.00848871511161596;
        0.00861374365798878,-0.00471224768141091,1];
        
    %(3)���þ�̬״̬��ʶ
    State_Static = 0;           %��̬��ʶ��1 �Ǿ�̬ 0 ��ʶ��̬
    Temp_fb = [0;0;0];          %�Ӽ��ۼӼ�����̬��
    Temp_Num = 0;
    Temp_Wait = 0;
    Temp_gyro_bias = [0;0;0];   %��ƫ����    
        
%% 2.4 ��ʼ��    
    %(1)�ߵ�����ṹ���ʼ�� 
    INSData_Now = INS_DataInit(G_Const,Data_IMU(1,1),G_Start_Att,G_Start_Vel,G_Start_Pos,[0;0;0],[0;0;0],Ts);
    INSData_Pre = INSData_Now;

    %(2)���������ݿռ�����
    %������ݴ��
    Result_AVP = zeros(L,10);               %����Ľ�� ʱ�� ��̬ �ٶ� λ��     
    %ʵʱ��������
    Result_StepDistance = zeros(L,2);
        
    %(3)���þ�̬״̬��ʶ
    State_Static = 0;           %��̬��ʶ��1 �Ǿ�̬ 0 ��ʶ��̬
    Temp_fb = [0;0;0];          %�Ӽ��ۼӼ�����̬��
    Temp_Num = 0;
    Temp_gyro_bias = [0;0;0];   %��ƫ����
    Temp_Static_Pos = G_Start_Pos;  %��̬���λ��
    
    %Test
    kk = 1;
    
%% 3.�������
    for i=1:L
    %(1)��ȡIMUԭʼ����
        INSData_Now.time = Data_IMU(i,1);    
        INSData_Now.w_ib_b = Data_IMU(i,5:7)';           
        INSData_Now.f_ib_b = Data_IMU(i,2:4)';  
        
    %(2)���ݺͼӼ���ƫ����
        %INSData_Now.w_ib_b = Data_IMU(i,5:7)'-imuerr.bias_gyro;           
        %INSData_Now.f_ib_b = Data_IMU(i,2:4)'-IMUError_Bias(4:6,1);
        %TEST
        INSData_Now.f_ib_b = M_a*[Data_IMU(i,2:4)';1];
        INSData_Now.w_ib_b = M_g*Data_IMU(i,5:7)';  
    %(3)�ߵ�����
        INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts);       
        
    %(4)���浼�����
        Result_AVP(i,1) = INSData_Now.time;      
        Result_AVP(i,2:4) = INSData_Now.att';
        Result_AVP(i,5:7) = INSData_Now.vel';
        Result_AVP(i,8:10) = INSData_Now.pos';           
        
    %(5)���üӼƼ�����̬����������
        if(State_Static==0)&&(Data_Foot_L_State(i,2)==1)
            %�Ӷ�̬���뾲̬
            State_Static=1;
            Temp_fb = [0;0;0];
            Temp_gyro_bias = [0;0;0];
            Temp_Num = 0;
            %Test
            Temp_Distanc(kk,1)=Cal_Distance_Pos2Pos(Temp_Static_Pos,INSData_Now.pos);
            kk = kk+1;
            
            Temp_Static_Pos = INSData_Pre.pos;
        end
        if(State_Static==1)&&(Data_Foot_L_State(i,2)==0)
            %�Ӿ�̬���붯̬
            State_Static=0;
            %imuerr.bias_gyro = Temp_gyro_bias;
            Temp_fb = [0;0;0];
            Temp_gyro_bias = [0;0;0];
            Temp_Num = 0;
        end        
        
        if(State_Static==1)
            Temp_Num = Temp_Num+1;
            Temp_Wait = Temp_Wait+1;
            %�Ӽ������ȡˮƽ��̬
            Temp_fb = (Temp_fb*(Temp_Num-1)+Data_IMU(i,2:4)')/Temp_Num; 
            %���������ȡ��ƫ
            Temp_gyro_bias = (Temp_gyro_bias.*(Temp_Num-1)+Data_IMU(i,5:7)')./Temp_Num; 
            %ˮƽ��̬У׼
            [INSData_Now.att(1,1),INSData_Now.att(2,1)]=Att_Accel2Att(Temp_fb(1,1),Temp_fb(2,1),Temp_fb(3,1));            
            INSData_Now.C_b_n = Att_Euler2DCM(INSData_Now.att);  
            INSData_Now.Q_b_n = Att_DCM2Q(INSData_Now.C_b_n);
            Result_AVP(i,2:4) = INSData_Now.att';
            %�ٶ����� λ�ñ��ֲ���    
            INSData_Now.vel = G_Start_Vel;
            Result_AVP(i,5:7) = INSData_Now.vel';
            INSData_Now.pos = INSData_Pre.pos;
            Result_AVP(i,8:10) = INSData_Now.pos';      
        end    
        
    %(6)���µ�������
        INSData_Pre =  INSData_Now;
        
    %(7)��¼������Ϣ
        Result_StepDistance(i,1) = INSData_Now.time;
        Result_StepDistance(i,2) = Cal_Distance_Pos2Pos(Temp_Static_Pos,INSData_Now.pos);
    end
    
% profile viewer
% profile off
    
%% 4.���ݻ�ͼ
    Plot_AVP_Group(Result_AVP);
    %Plot_AVP_Group(Result_AVP0,Result_AVP);
    %Plot_AVP_XkPk_Group(Result_AVP0,XkPk0);