% 测试航姿解算KF滤波算法
    %clear;clc;
    %load('D:\清华博士\2_博士课题_JG\2_实验记录\20200326_办公室内短距离2来回\原地左右旋转3圈\MPU_L_1_43000_52300.mat')    
% 设置解算数据长度
    Num_Start = 1;  Num_End = 1000;
% 参数初始设置
    Start_Att = [-0.0845;0.0965;1.4706];  %起始姿态
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
    %Temp = [50	80	50].*(pi/180/3600);
    qt = diag([0.003071,0.002521,0.001410])^2;   %零偏不稳定性
    rt = diag([0.0001 0.0001 0.0001].*(pi/180))^2;  %姿态误差观测误差
    % KF滤波参数初始化
    nn = 50; %滤波周期 10个采样点
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
    Result_Att = zeros(Num,4);
    
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

    if mod(i,nn) == 0

            AttData_Now.att = Start_Att;
            AttData_Now.C_b_n = Att_Euler2DCM(AttData_Now.att);
            AttData_Now.Q_b_n = Att_DCM2Q(AttData_Now.C_b_n);
            %Gyro_Bias = mean(IMU(i-nn+1:i,5:7))';
        %保存结果
        % (4)保存导航结果
        Result_Att(i,1) = AttData_Now.time;      
        Result_Att(i,2:4) = AttData_Now.att';
        %(5)更新导航数据
        AttData_Pre =  AttData_Now;          
    else
        %(4)保存导航结果
        Result_Att(i,1) = AttData_Now.time;      
        Result_Att(i,2:4) = AttData_Now.att';
        %(5)更新导航数据
        AttData_Pre =  AttData_Now;    
     end   
    
     
end    
 

% 5.结果绘制比较
Plot_AVP_Att_1(Result_Att,Num);
%Plot_AVP_Group_Att(Result_Att,Result_Att_new,Num);
% figure;plot(XkPk(:,1).*(180/pi));
% figure;plot((Result_Att(:,2)-Start_Att(1,1)).*(180/pi),'r');