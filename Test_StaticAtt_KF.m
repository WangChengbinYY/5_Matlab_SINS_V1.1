% 测试航姿解算KF滤波算法
%      clear;clc;
%      load('D:\清华博士\2_博士课题_JG\2_实验记录\20200326_办公室内短距离2来回\原地左右旋转3圈\MPU_L_1_43000_52300.mat')    
% 设置解算数据长度
    %Num_Start = 1;  Num_End = 1000;
    Num_Start = 1;  Num_End = length(IMU);
% 参数初始设置
    Start_Att = [-0.0845;0.0965;1.4706];  %起始姿态
    %Start_Att = [0;0;0];
    Start_Vel = zeros(3,1);
    Start_Pos = [0.5975;1.9017;400.0000];
    Ts = 1/200;
    G_Const = CONST_Init();
    % KF滤波参数设定
    Xk_1 = zeros(6,1);
    Pkk_1 = zeros(6,6);
    Ft = zeros(6,1);
    Phikk_1 = eye(6);    
    Zk = zeros(3,1);
    Hk = zeros(3,6);
    % 观测噪声方差 零偏不稳定性 弧度/s
    %qt = diag([0.003071,0.002521,0.001410])^2;   %零偏不稳定性
    qt = diag([9.435526099935672e-06,6.358767510985477e-06,1.989738785153631e-06]);
    rt = diag([0.0001 0.0001 0.0001].*(pi/180))^2;  %姿态误差观测误差
    % KF滤波参数初始化
    nn = 10; %滤波周期 10个采样点
    %Bias_mean = Gyro_Mean_Plot(IMU,nn,Num_End);
    Hk(1:3,1:3) = eye(3);
    Rk = rt/(Ts*nn);    
    % KF初始值设定
    %Xk = [0.1*pi/180;0.1*pi/180;0.1*pi/180;-0.06;-0.006;0.013];   %X0=0;
    Xk = [0.01*pi/180;0.01*pi/180;0.01*pi/180;-0.0617633;-0.006840;0.00976214];   %X0=0;
    Pk = diag([0.0001*pi/180,0.0001*pi/180,0.0001*pi/180,0.003071,0.002521,0.001410])^2;
% 惯导解算设置
    Gyro_Bias = [-0.0617633;-0.006840;0.00976214];  %前1000个数的平均值
    Acc_Bias = [0;0;0];    
    AttData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
    AttData_Pre = AttData_Now;        
% 存储设置    
    Num = Num_End - Num_Start + 1;
    Result_Att_KF = zeros(Num,4);
    Result_GyroBias = zeros(fix(Num/nn),3);
    XkPk = zeros(fix(Num/nn),12);
    Result_Zk = zeros(fix(Num/nn),3);
    j = 1;
    
    Att_Pre = Start_Att;
    
for i = Num_Start:Num_End
    %--------正常姿态解算
    %(1)获取IMU原始数据
    AttData_Now.time = IMU(i,1);    
    AttData_Now.w_ib_b = IMU(i,5:7)';   %陀螺          
    AttData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %加计 
    %(2)陀螺零偏修正
    AttData_Now.w_ib_b = AttData_Now.w_ib_b - Gyro_Bias;    
     %(3)姿态解算
    AttData_Now = INS_Update_Static_Att(G_Const,AttData_Pre,AttData_Now,Ts);   

     
    % KF 时间更新
        % 计算Ft
            Ft(1:3,4:6) = -AttData_Now.C_b_n;
        % 更新 Phikk_1
            Phikk_1 = Phikk_1*(eye(6)+Ft.*Ts);
    % KF 量测更新
    if mod(i,nn) == 0
        % Xk一步预测
        Xkk_1 = Phikk_1*Xk;
        % 计算Qk_1
        Gk_1 = [-AttData_Now.C_b_n;zeros(3,3)];    %问题1 这里计算并不是太精确！
        Qk_1 = Gk_1*(qt*(Ts*nn))*Gk_1';                %问题2 这里测试严恭敏所说的 直接等效为 Qk 是否有区别
        % 一步预测均方误差阵
        Pkk_1 = Phikk_1*Pk*Phikk_1' + Qk_1;
        % 滤波增益矩阵
        Kk = Pkk_1*Hk'*(Hk*Pkk_1*Hk'+Rk)^-1;
        % 获取观测量
        Zk = AttData_Now.att - Start_Att;   %姿态的伪观测量        
        % 状态估计
        Xk = Xkk_1 + Kk*(Zk - Hk*Xkk_1);
        % 状态估计均方误差阵
        Pk = (eye(6)-Kk*Hk)*Pkk_1;       
        
        % 状态估计保存
        XkPk(j,1:6) = Xk';
        XkPk(j,7:12) = sqrt(diag(Pk)');        
        
        % 状态反馈
            % 姿态反馈   反馈系数k    %问题3 是否全反馈
            k = 1;
            phi = Xk(1:3,1).*k;
            AttData_Now.att = AttData_Now.att - phi;
            AttData_Now.C_b_n = Att_Euler2DCM(AttData_Now.att);
            AttData_Now.Q_b_n = Att_DCM2Q(AttData_Now.C_b_n);

%             AttData_Now.Q_b_n = Math_QmulQ(Att_Rv2Q(phi), AttData_Now.Q_b_n);
%             AttData_Now.C_b_n = Att_Q2DCM(AttData_Now.Q_b_n);
%             AttData_Now.att = Att_DCM2euler(AttData_Now.C_b_n);

            % 零偏反馈
              Gyro_Bias = Xk(4:6,1);
            % 记录零偏
            Result_GyroBias(j,1:3) =  Gyro_Bias';
            Result_Zk(j,1:3) = Zk';
              Xk(1:3,1) = zeros(3,1);
            
        j = j+1;
        Phikk_1 = eye(6);
            
        %保存结果
        % (4)保存导航结果
        Result_Att_KF(i,1) = AttData_Now.time;      
        Result_Att_KF(i,2:4) = AttData_Now.att';
        %(5)更新导航数据
        AttData_Pre =  AttData_Now;          
    else
        %(4)保存导航结果
        Result_Att_KF(i,1) = AttData_Now.time;      
        Result_Att_KF(i,2:4) = AttData_Now.att';
        %(5)更新导航数据
        AttData_Pre =  AttData_Now;    
     end   
    
     
end    
 

% 5.结果绘制比较
Plot_AVP_Group_Att(Result_Att_KF,Result_Att,Num);
% figure;plot(XkPk(:,1).*(180/pi));
% figure;plot((Result_Att(:,2)-Start_Att(1,1)).*(180/pi),'r');