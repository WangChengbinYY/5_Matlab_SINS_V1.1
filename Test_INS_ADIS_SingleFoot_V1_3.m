% 精仪系楼道内来回走   ZUPT水平姿态校准 加计校准 陀螺校准  + 航向保持
% 
% profile on

%% 1.读取数据
     clc;
     clear;
    load('20191109_在单位办公楼内楼道来回试验_第一次.mat');
    %依据前面静止状态下，利用加速度计求水平姿态角
    Data_IMU = Data_IMUB_L;
    Temp_Number = 2000;
    Temp_f = [mean(Data_IMU(1:Temp_Number,2));mean(Data_IMU(1:Temp_Number,3));mean(Data_IMU(1:Temp_Number,4))];
    [Temp_Pitch,Temp_Roll]=Att_Accel2Att(Temp_f(1,1),Temp_f(2,1),Temp_f(3,1));
    Temp_Pitch*180/pi;
    Temp_Roll*180/pi;
%% 2.初始化设置
%% 2.1 全局参数
    G_Const = CONST_Init();
    G_IMU.Hz = 200;  
    Ts = 1/G_IMU.Hz;  %采样间隔50ms
    [L,m] = size(Data_IMU);
%% 2.2 起点信息
    G_Start_Att = [Temp_Pitch;Temp_Roll;0*pi/180];
    G_Start_Vel = [0;0;0];
    %精仪系坐标40.003575 116.337489
    %G_Start_Pos = [40.003575*pi/180;116.337489*pi/180;50];     
    %所里坐标 108.970278,34.237838
    G_Start_Pos = [34.237838*pi/180;108.970278*pi/180;50]; 
    clear Temp_Number Temp_f Temp_Pitch Temp_Roll;
%% 2.3 各类控制参数设置
    %(1)计算时长
    %L = 80*1000;
    %(2)IMU器件参数
    imuerr.bias_gyro=[0;0;0];                   %陀螺常值零偏
    imuerr.bias_acc=[0;0;0];                    %加计常值零偏
    imuerr.eb = [2.5;2.5;2.5].*pi/180/3600;     %陀螺零偏不稳定性 度/h;  器件手册标称 转换为 rad/s
    imuerr.db = [13;13;13].*1e-6*9.7803267714;  %加计零偏不稳定性 ug;    器件手册标称 转换为 m/s
    imuerr.web = [0.15;0.15;0.15].*pi/180/sqrt(3600);    %陀螺角度随机游走ARW du/sqrt(h) 器件手册标称 转换为 rad/s
    imuerr.wdb = [0.037;0.037;0.037]./sqrt(3600);    %加计速度随机游走VRW m/s/sqrt(h) 器件手册标称 转换为 m/s
    
    %通过校准得到的 加速度计 误差参数   对“20191028_ADIS清华桌上预热后6位置数据采集.mat”数据进行标校估计得到的结果
    M_a = [ 0.998399276848119,-0.00397028074921105,-0.00785084769711597,-0.0176094161989268;
            0.00191732435213797,0.998374888862787,0.00848871511161596,0.00282715789554676;
            0.00861374365798878,-0.00471224768141091,0.998030948532028,-0.000527073119519568];
    M_g = [ 1,-0.00397028074921105,-0.00785084769711597;
        0.00191732435213797,1,0.00848871511161596;
        0.00861374365798878,-0.00471224768141091,1];
        
    %(3)设置静态状态标识
    State_Static = 0;           %静态标识，1 是静态 0 标识动态
    Temp_fb = [0;0;0];          %加计累加计算姿态用
    Temp_Num = 0;
    Temp_Wait = 0;
    Temp_gyro_bias = [0;0;0];   %零偏估计    
        
%% 2.4 初始化    
    %(1)惯导解算结构体初始化 
    INSData_Now = INS_DataInit(G_Const,Data_IMU(1,1),G_Start_Att,G_Start_Vel,G_Start_Pos,[0;0;0],[0;0;0],Ts);
    INSData_Pre = INSData_Now;

    %(2)待保存数据空间声明
    %结果数据存放
    Result_AVP = zeros(L,10);               %解算的结果 时间 姿态 速度 位置     
    %TEST
    Result_Bias = zeros(L,4);
        
    %(3)设置静态状态标识
    State_Static = 0;           %静态标识，1 是静态 0 标识动态
    Temp_fb = [0;0;0];          %加计累加计算姿态用
    Temp_Num = 0;
    Temp_gyro_bias = [0;0;0];   %零偏估计
    Temp_Yaw = 0;               %静态初始航向
    
%% 3.解算过程
    for i=1:L
    %(1)获取IMU原始数据
        INSData_Now.time = Data_IMU(i,1);    
        INSData_Now.w_ib_b = Data_IMU(i,5:7)';           
        INSData_Now.f_ib_b = Data_IMU(i,2:4)';  
        
    %(2)陀螺和加计零偏修正
        %INSData_Now.w_ib_b = Data_IMU(i,5:7)'-imuerr.bias_gyro;           
        %INSData_Now.f_ib_b = Data_IMU(i,2:4)'-IMUError_Bias(4:6,1);
        %TEST
        INSData_Now.f_ib_b = M_a*[Data_IMU(i,2:4)';1];
        INSData_Now.w_ib_b = M_g*Data_IMU(i,5:7)';  
    %(3)惯导解算
        INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts);       
        
    %(4)保存导航结果
        Result_AVP(i,1) = INSData_Now.time;      
        Result_AVP(i,2:4) = INSData_Now.att';
        Result_AVP(i,5:7) = INSData_Now.vel';
        Result_AVP(i,8:10) = INSData_Now.pos';           
        
    %(5)利用加计计算姿态，其它不变
        if(State_Static==0)&&(Data_Foot_L_State(i,2)==1)
            %从动态进入静态
            State_Static=1;
            Temp_fb = [0;0;0];
            Temp_gyro_bias = [0;0;0];
            Temp_Num = 0;
            Temp_Yaw = INSData_Now.att(3,1);
        end
        if(State_Static==1)&&(Data_Foot_L_State(i,2)==0)
            %从静态进入动态
            State_Static=0;
            %imuerr.bias_gyro = Temp_gyro_bias;
            Temp_fb = [0;0;0];
            Temp_gyro_bias = [0;0;0];
            Temp_Num = 0;
        end        
        
        if(State_Static==1)
            Temp_Num = Temp_Num+1;
            Temp_Wait = Temp_Wait+1;
            %加计输出求取水平姿态
            Temp_fb = (Temp_fb*(Temp_Num-1)+Data_IMU(i,2:4)')/Temp_Num; 
            %水平姿态校准            
            if Temp_Num >= 10
                [INSData_Now.att(1,1),INSData_Now.att(2,1)]=Att_Accel2Att(Temp_fb(1,1),Temp_fb(2,1),Temp_fb(3,1));   
                INSData_Now.C_b_n = Att_Euler2DCM(INSData_Now.att);  
                INSData_Now.Q_b_n = Att_DCM2Q(INSData_Now.C_b_n);
                Result_AVP(i,2:4) = INSData_Now.att';     
            end
            %速度清零 位置保持不变    
            INSData_Now.vel = G_Start_Vel;
            Result_AVP(i,5:7) = INSData_Now.vel';
            INSData_Now.pos = INSData_Pre.pos;
            Result_AVP(i,8:10) = INSData_Now.pos'; 
        end    
        
    %(6)更新导航数据
        INSData_Pre =  INSData_Now;
    end
    
% profile viewer
% profile off
    
%% 4.数据绘图
    Plot_AVP_Group(Result_AVP);
    %Plot_AVP_Group(Result_AVP,Result_AVP0);  %Result_AVP 红色
    %Plot_AVP_XkPk_Group(Result_AVP0,XkPk0);
