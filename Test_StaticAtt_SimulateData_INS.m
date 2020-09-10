% 测试 KF 仿真数据解算
%-------------设置解算数据长度
% clear all;clc;
% load('D:\N_WorkSpace_GitHub\5_Matlab\5_Matlab_SINS_V1.1\0_实验数据\IMU_Simulate_Low.mat');
glvs
    Num_Start = 1;  Num_End = length(IMU);
%-------------参数初始设置
    Ts = 1/200;
    G_Const = CONST_Init();  
    
%-------------计算参数   
    %Start_Att_theory = [4.5;5.5;85].*(pi/180);  % 姿态理论值
    Start_Att_theory = zeros(3,1);
    Start_Att_error = Start_Att_theory + 0.01;                        % 理论值 + 误差(约0.5度)     
    Gyro_Bias_theory = [-0.0617633;-0.006840;0.00976214];
    %Gyro_Bias_theory = [0.01*glv.dph;0.01*glv.dph;0.01*glv.dph];
    Gyro_Bias_error = Gyro_Bias_theory.*0.9; %有偏差的零偏

    Start_Vel = zeros(3,1);
    Start_Pos = [34.2*(pi/180);108.9*(pi/180);400.0];
    
%-------------KF滤波参数设定
    Xk_1 = zeros(6,1);
    Pkk_1 = zeros(6,6);
    Ft = zeros(6,1);
    Phikk_1 = eye(6);    
    Zk = zeros(3,1);
    Hk = zeros(3,6);    
    % KF初始值设定
    %Gyro_Bias_KF = Gyro_Bias_error;
    Gyro_Bias_KF = zeros(3,1);
    Xk = [0.01;0.01;0.01;0.1;0.1;0.1];   %X0=0;
    %Pk = diag([0.01,0.01,0.01,(Gyro_Bias_error-Gyro_Bias_theory)'])^2;
    Pk = diag([0.01,0.01,0.01,0.1,0.1,0.1])^2;
    % 观测噪声方差 零偏不稳定性 弧度/s 
    Gyro_Bias_Const_Var = [0.001*glv.dpsh;0.001*glv.dpsh;0.001*glv.dpsh,];
    qt = diag(Gyro_Bias_Const_Var)^2;   %零偏不稳定性
    Att_Const_Var = [0.1;0.1;0.1].*(pi/180);
    rt = diag(Att_Const_Var)^2;  %姿态误差观测误差
    % KF滤波参数初始化
    Hk(1:3,1:3) = eye(3);
    %Rk = rt/(nn);  
    Rk = rt;
    
%-----------------------存储设置    
    Num = Num_End - Num_Start + 1;
    % 积分解算
    Result_Att_JiFen = zeros(Num,4);
    Result_Att_JiFen(1,1) = IMU(1,1);
    Result_Att_JiFen(1,2:4) = Start_Att_theory';
    % 姿态解算
    Result_Att_INS = zeros(Num,4);
    Result_Att_INS(1,1) = IMU(1,1);
    Result_Att_INS(1,2:4) = Start_Att_theory';
    %(1)惯导解算结构体初始化 
    AttData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att_theory,Start_Vel,Start_Pos,Gyro_Bias_theory,[0;0;0],Ts);
    AttData_Pre = AttData_Now;     
    
    % KF 存储    
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
    %--------积分姿态解算
    Result_Att_JiFen(i,1) = IMU(i,1);
    Result_Att_JiFen(i,2:4) = Result_Att_JiFen(i-1,2:4) + ((IMU(i,5:7)'-Gyro_Bias_theory).*(Ts))';
    
    %--------惯导姿态解算
    AttData_Now.time = IMU(i,1);    
    AttData_Now.w_ib_b = IMU(i,5:7)';   %陀螺          
    AttData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %加计 
    %陀螺零偏修正
    AttData_Now.w_ib_b = AttData_Now.w_ib_b - Gyro_Bias_KF;
    %AttData_Now.w_ib_b = AttData_Now.w_ib_b;
    AttData_Now = INS_Update_Static_Att(G_Const,AttData_Pre,AttData_Now,Ts);  
    %保存导航结果
    Result_Att_INS(i,1) = AttData_Now.time;      
    Result_Att_INS(i,2:4) = AttData_Now.att';
    %更新导航数据
    AttData_Pre =  AttData_Now;  
            
    %---------KF 滤波  
    % KF 时间更新
    % 计算Ft
    Ft = zeros(6);
    Ft(1:3,4:6) = eye(3);
    Ft(1:3,4:6) = AttData_Now.C_b_n;
%     Ft(4,4) = -1/100;Ft(5,5) = -1/100;Ft(6,6) = -1/100;
    %Ft(1:3,4:6) = C_b_n_Const;
    % 更新 Phikk_1
    Phikk_1 = Phikk_1*(eye(6)+Ft.*Ts); 
    
    % 计算Qk_1
    Gk_1 = [eye(3);zeros(3,3)];       
    Gk_1 = [AttData_Now.C_b_n;zeros(3,3)]; 
    %Gk_1 = [C_b_n_Const;zeros(3,3)]; 
    Qk_1 = Gk_1*(qt)*Gk_1';                      %问题1：直接使用   Qt = qt
    
    % KF 量测更新
    if mod(i,nn) == 0
        % Xk一步预测
        Xkk_1 = Phikk_1*Xk;

        % 一步预测均方误差阵
        Pkk_1 = Phikk_1*Pk*Phikk_1' + Qk_1;
        % 滤波增益矩阵
        Kk = Pkk_1*Hk'*(Hk*Pkk_1*Hk'+Rk)^-1;         %问题2： 这里  Rk = rt
        % 获取观测量
        % 姿态观测量的获取
        Att_Cal = AttData_Now.att;
        C_Cal = Att_Euler2DCM(Att_Cal);
        Att_Mea = Start_Att_theory;
        C_Mea = Att_Euler2DCM(Att_Mea);
        C_Z = C_Cal*C_Mea';
        Zk = Att_DCM2euler(C_Z);
        %Zk = (Result_Att_INS(i,2:4) - Z_Att_HuDu(i,1:3))';             %姿态观测量      
        %Zk = Result_Att_INS(i,2:4)' - Start_Att_theory;
        % 状态估计
        Xk = Xkk_1 + Kk*(Zk - Hk*Xkk_1);
        % 状态估计均方误差阵
        Pk = (eye(6)-Kk*Hk)*Pkk_1;       
        
        % 状态估计保存
        XkPk(j,1:6) = Xk';
        XkPk(j,7:12) = diag(Pk)'; 
        Phikk_1 = eye(6);     

        % 姿态反馈   反馈系数k    %问题3 是否全反馈
        k = 1;                
        error_att = Xk(1:3,1).*k;
        Xk(1:3,1) = Xk(1:3,1).*(1-k);
        %Gyro_Bias_KF = Gyro_Bias_KF+Xk(4:6,1).*k; 
        Gyro_Bias_KF = Xk(4:6,1); 
        Result_Bias_KF(j,:) = Gyro_Bias_KF';
        %精细化补偿
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


% 5.结果绘制比较
%Plot_AVP_Group_Att(Result_Att_INS,Result_att);
Plot_AVP_Group_Att(Result_Att_INS,Result_Att_JiFen,Num);
Plot_Att_Bias_1(Gyro_Bias_theory,Result_Bias_KF,j-1);
Plot_XkPk_AttTest(XkPk);

