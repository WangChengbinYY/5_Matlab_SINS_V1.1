% ADIS16467静止放置 KF 处理
% 测试仅使用80个采样周期的估计处理结果

profile on

%% 1.读取数据
    clear;
    load('右脚桌面静止_20190716第2组_截取测试用.mat');
    
%% 2.初始化设置
%% 2.1 全局参数
    G_Const = CONST_Init();
    G_IMU.Hz = 200;  
    Ts = 1/G_IMU.Hz;  %采样间隔50ms
    [L,m] = size(Data_IMU_R);
%% 2.2 起点信息
    G_Start_Att = [0.065*pi/180;-0.37*pi/180;10*pi/180];
    G_Start_Vel = [0;0;0];
    G_Start_Pos = [34.1*pi/180;114.1*pi/180;50];
%% 2.3 各类控制参数设置
    %(1)计算时长
    L = 80*1000;
    %(2)KF模型参数
    KF_switch = 1;  %1 进行KF滤波，0 不进行KF滤波
    %KF模式 Mode=1 位置反馈 2 速度反馈 3 位置速度反馈 4 水平姿态 速度 位置 5 姿态(水平加航向约束) 速度 位置
    mode = 3;     %模型选择 
    nTs = 1;      %KF滤波周期，单位是采样周期  1s滤波是 200 
    BackCoef = 0.5;   %KF滤波估计误差反馈系数 0.0~1.0 0.0不反馈，1.0全反馈
    %(3)IMU器件参数
    imuerr.eb = [2.5;2.5;2.5].*pi/180/3600;     %陀螺零偏 度/h;  器件手册标称 转换为 rad/s
    imuerr.db = [13;13;13].*1e-6*9.7803267714;  %加计零偏 ug;    器件手册标称 转换为 m/s
    imuerr.web = [0.15;0.15;0.15].*pi/180/sqrt(3600);    %陀螺角度随机游走ARW du/sqrt(h) 器件手册标称 转换为 rad/s
    imuerr.wdb = [0.037;0.037;0.037]./sqrt(3600);    %加计速度随机游走VRW m/s/sqrt(h) 器件手册标称 转换为 m/s
%% 2.4 初始化    
    %(1)惯导解算结构体初始化 
    INSData_Now = INS_DataInit(G_Const,Data_IMU_R(1,1),G_Start_Att,G_Start_Vel,G_Start_Pos,[0;0;0],[0;0;0],Ts);
    INSData_Pre = INSData_Now;

    %(2)KF滤波初始化
    X0 = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0]; 
    P0=diag([0.5*pi/180;0.5*pi/180;1*pi/180;
                1e-2;1e-2;1e-2;
                1e-2/G_Const.earth_Re;1e-2/G_Const.earth_Re;1e-2; 
                imuerr.eb; 
                imuerr.db])^2;
    q0=diag([imuerr.web; imuerr.wdb])^2;
    switch mode
        case 1
            %Mode_1 位置反馈
            r0=diag([0.01/G_Const.earth_Re;0.01/G_Const.earth_Re;0.01])^2;
        case 2
            %Mode_2 速度反馈  仅速度反馈时，应该考虑系统状态方程中不包含位置误差信息 以后做实验
            r0=diag([0.01;0.01;0.01])^2;
        case 3
            %Mode_3 速度位置反馈
            r0=diag([1e-3;1e-3;1e-3;
                    1e-4/G_Const.earth_Re;1e-4/G_Const.earth_Re;1e-4])^2;
        case 4
            %Mode_4 水平姿态速度位置反馈
            r0=diag([0.2*pi/180;0.2*pi/180;
                    0.01;0.01;0.01;
                    0.01/G_Const.earth_Re;0.01/G_Const.earth_Re;0.01])^2;
        case 5
            %Mode_5 姿态(水平+航向约束)速度位置反馈
            r0=diag([0.2*pi/180;0.2*pi/180;0.5*pi/180;
                    0.01;0.01;0.01;
                    0.01/G_Const.earth_Re;0.01/G_Const.earth_Re;0.01])^2;                
    end
    %KF结构体初始化
    KF = KF_Init(mode,X0,P0,q0,r0);

    %(3)待保存数据空间声明
    %结果数据存放
    Result_AVP = zeros(L,10);               %解算的结果 时间 姿态 速度 位置      
    %KF滤波参数保存结构体
    XkPk = zeros(fix(L/nTs),31);
    j=1;
        
%% 3.解算过程
    for i=1:L
    %(1)获取IMU原始数据
        INSData_Now.time = Data_IMU_R(i,1);    
        INSData_Now.w_ib_b = Data_IMU_R(i,5:7)';           
        INSData_Now.f_ib_b = Data_IMU_R(i,2:4)';  
        
    %(2)陀螺和加计零偏修正
        %INSData_Now.w_ib_b = Data_IMU_R(i,5:7)'-IMUError_Bias(1:3,1);           
        %INSData_Now.f_ib_b = Data_IMU_R(i,2:4)'-IMUError_Bias(4:6,1);
        
    %(3)惯导解算
        INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts);
                    
    %Test
%     INSData_Now.att = G_Start_Att;
%     INSData_Now.C_b_n = Att_Euler2DCM(INSData_Now.att);
%     INSData_Now.Q_b_n = Att_DCM2Q(INSData_Now.C_b_n);
        
    %(4)保存导航结果
        Result_AVP(i,1) = INSData_Now.time;      
        Result_AVP(i,2:4) = INSData_Now.att';
        Result_AVP(i,5:7) = INSData_Now.vel';
        Result_AVP(i,8:10) = INSData_Now.pos';     
        
    %(5)更新KF滤波所需的参数
        [KF.Ft,KF.Gt] = KF_Update_Ft(mode,INSData_Now);
        [KF.Fk,KF.Rk,Phikk_1,Qk_1] = KF_Update_C2D(mode,KF,Ts,3);
        KF.Phikk_1 = Phikk_1*KF.Phikk_1;
        KF.Qk_1 = KF.Qk_1+Qk_1;   
        
    %(6)KF更新计算
    if (KF_switch == 1)&&(mod(i,nTs)==0)
        %根据不同模型选择不同观测量
        switch mode
            case 1 %位置 观测
                KF.Zk = INSData_Now.pos-G_Start_Pos;
            case 2 %速度 观测
                KF.Zk = INSData_Now.vel-G_Start_Vel;  
            case 3 %速度、位置 观测
                KF.Zk(1:3,1) = INSData_Now.vel-G_Start_Vel;    
                KF.Zk(4:6,1) = INSData_Now.pos-G_Start_Pos;
            case 4 %水平姿态、速度、位置 观测
                %KF.Zk(1:2,1) = INSData_Now.att(1:2,1)-Vel_mean(i,5:6)';     
                KF.Zk(3:5,1) = INSData_Now.vel-G_Start_Vel;    
                KF.Zk(6:8,1) = INSData_Now.pos-G_Start_Pos;
            case 5 %水平姿态、航向约束、速度、位置 观测
                %KF.Zk(1:2,1) = INSData_Now.att(1:2,1)-Vel_mean(i,5:6)';    
                KF.Zk(3,1) = INSData_Now.att(3,1) - 10*pi/180;
                KF.Zk(4:6,1) = INSData_Now.vel-G_Start_Vel;    
                KF.Zk(7:9,1) = INSData_Now.pos-G_Start_Pos;                   
        end
        
        %KF滤波更新
        KF = KF_Update_TM(mode,KF,KF.Zk);        
        
        %KF参数保存
        XkPk(j,1) = INSData_Now.time;
        XkPk(j,2:16) = KF.Xk';
        for k=1:15
            XkPk(j,k+16) = KF.Pk(k,k);
        end      
        
        %姿态反馈
        Phi = KF.Xk(1:3).*BackCoef;
        KF.Xk(1:3) = KF.Xk(1:3) - KF.Xk(1:3).*BackCoef;        
        INSData_Now.Q_b_n = Math_QmulQ(Att_Rv2Q(Phi),INSData_Now.Q_b_n); 
        INSData_Now.C_b_n = Att_Q2DCM(INSData_Now.Q_b_n);
        INSData_Now.att = Att_DCM2euler(INSData_Now.C_b_n);
        %速度反馈
        INSData_Now.vel = INSData_Now.vel - KF.Xk(4:6).*BackCoef;
        KF.Xk(4:6) = KF.Xk(4:6) - KF.Xk(4:6).*BackCoef;
        %位置反馈
        INSData_Now.pos = INSData_Now.pos - KF.Xk(7:9).*BackCoef;
        KF.Xk(7:9) = KF.Xk(7:9) - KF.Xk(7:9).*BackCoef; 
        %陀螺零偏反馈
        INSData_Now.eb = INSData_Now.eb + KF.Xk(10:12).*BackCoef;
        KF.Xk(10:12) = KF.Xk(10:12) - KF.Xk(10:12).*BackCoef;
        %加计零偏反馈
        INSData_Now.db = INSData_Now.db + KF.Xk(13:15).*BackCoef;
        KF.Xk(13:15) = KF.Xk(13:15) - KF.Xk(13:15).*BackCoef;        

        %记录新的导航结果数据
        Result_AVP(i,2:4) = INSData_Now.att';
        Result_AVP(i,5:7) = INSData_Now.vel';
        Result_AVP(i,8:10) = INSData_Now.pos';   
        
        %更新周期后，参数清零
        n = length(KF.Phikk_1);
        KF.Phikk_1 = eye(n);
        KF.Qk_1 = zeros(n,n);
        j=j+1;
    end        
        
    %(6)更新导航数据
        INSData_Pre =  INSData_Now;
    end
    
profile viewer
profile off
    
%% 4.数据绘图
    %Plot_AVP_Group(Result_AVP);
    Plot_AVP_XkPk_Group(Result_AVP0,XkPk0);
