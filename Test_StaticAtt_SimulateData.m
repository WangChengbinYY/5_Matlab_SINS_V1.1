% 测试 KF 仿真数据解算
%-------------设置解算数据长度
    Num_Start = 1;  Num_End = length(IMU);
%-------------参数初始设置
    Ts = 1/200;
    G_Const = CONST_Init();  
    
%-------------计算参数   
    Start_Att_theory = [-0.0845;0.0965;1.4706];  % 姿态理论值
    Start_Att_error = Start_Att_theory + 0.01;                        % 理论值 + 误差(约0.5度)     
    Gyro_Bias_theory = [-0.0617633;-0.006840;0.00976214];
    Gyro_Bias_error = Gyro_Bias_theory.*0.9; %有偏差的零偏

%-------------KF滤波参数设定
    Xk_1 = zeros(6,1);
    Pkk_1 = zeros(6,6);
    Ft = zeros(6,1);
    Phikk_1 = eye(6);    
    Zk = zeros(3,1);
    Hk = zeros(3,6);    
    % KF初始值设定
    Gyro_Bias_KF = Gyro_Bias_error;
    %Gyro_Bias_KF = zeros(3,1);
    Xk = [0.01;0.01;0.01;0;0;0];   %X0=0;
    %Pk = diag([0.01,0.01,0.01,(Gyro_Bias_error-Gyro_Bias_theory)'])^2;
    Pk = diag([0.01,0.01,0.01,Gyro_Bias_theory'.*1000])^2;
    % 观测噪声方差 零偏不稳定性 弧度/s 
    Gyro_Bias_Const_Var = [9.435526099935672e-06;6.358767510985477e-06*0.02;1.989738785153631e-06];
    qt = diag(Gyro_Bias_Const_Var);   %零偏不稳定性
    Att_Const_Var = [0.001;0.001;0.001].*(pi/180);
    rt = diag(Att_Const_Var);  %姿态误差观测误差
    % KF滤波参数初始化
    Hk(1:3,1:3) = eye(3);
    %Rk = rt/(nn);  
    Rk = rt;
    
%-----------------------存储设置    
    Num = Num_End - Num_Start + 1;
    Result_Att = zeros(Num,4);
    Result_Att(1,1) = IMU(1,1);
    Result_Att(1,2:4) = Start_Att_theory';
    % KF 存储
    
    Result_Att_KF = zeros(Num,4);
    Result_Att_KF(1,1) = IMU(1,1);
    Result_Att_KF(1,2:4) = Start_Att_error';
    nn = 50;
    XkPk = zeros(fix(Num/nn),12);
    Result_Bias_KF = zeros(fix(Num/nn),3);
    Result_Bias_KF(1,:) = Gyro_Bias_KF';
    j = 1;
    
for i = 2:Num_End
    %--------正常姿态解算
    Result_Att(i,1) = IMU(i,1);
    Result_Att(i,2:4) = Result_Att(i-1,2:4) + ((IMU(i,5:7)'-Gyro_Bias_theory).*(Ts))';
    
    %---------KF 滤波
    Result_Att_KF(i,1) = IMU(i,1);
    Result_Att_KF(i,2:4) = Result_Att_KF(i-1,2:4) + ((IMU(i,5:7)'-Gyro_Bias_KF).*(Ts))';
    
    % KF 时间更新
    % 计算Ft
    Ft = zeros(6);
    Ft(1:3,4:6) = eye(3);
    % 更新 Phikk_1
    Phikk_1 = Phikk_1*(eye(6)+Ft.*Ts);
        Gk_1 = [eye(3);zeros(3,3)];         
        Qk_1 = Gk_1*(qt)*Gk_1';                      %问题1：直接使用   Qt = qt    
    % KF 量测更新
    if mod(i,nn) == 0
        % Xk一步预测
        Xkk_1 = Phikk_1*Xk;
        % 计算Qk_1

        % 一步预测均方误差阵
        Pkk_1 = Phikk_1*Pk*Phikk_1' + Qk_1;
        % 滤波增益矩阵
        Kk = Pkk_1*Hk'*(Hk*Pkk_1*Hk'+Rk)^-1;         %问题2： 这里  Rk = rt
        % 获取观测量
        %Zk = (Result_Att_KF(i,2:4) - Z_Att_HuDu(i,1:3))';             %姿态观测量      
        Zk = Result_Att_KF(i,2:4)' - Start_Att_theory;
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


% 5.结果绘制比较
%Plot_AVP_Att_1(Result_Att_KF,Num);

Plot_Att_Bias_1(Gyro_Bias_theory,Result_Bias_KF,j-1);
Plot_XkPk_AttTest(XkPk);
Plot_AVP_Group_Att(Result_Att_KF,Result_Att,Num);
