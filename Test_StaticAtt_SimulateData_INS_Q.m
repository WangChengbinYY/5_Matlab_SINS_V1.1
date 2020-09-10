% 测试 KF 仿真数据解算
%-------------设置解算数据长度
clear all;clc;
load('D:\N_WorkSpace_GitHub\5_Matlab\5_Matlab_SINS_V1.1\0_实验数据\IMU_Simulate.mat');
glvs
    Num_Start = 1;  Num_End = length(IMU);
%-------------参数初始设置
    Ts = 1/200;
    G_Const = CONST_Init();  
    
%-------------计算参数   
    Start_Att_theory = [4.5;5.5;85].*(pi/180);  % 姿态理论值
    Start_Vel = zeros(3,1);
    Start_Pos = [34.2*(pi/180);108.9*(pi/180);400.0];       
    Gyro_Bias_theory = [1*glv.dph;1*glv.dph;0.01*glv.dph];
%-----------------------存储设置    
    Num = Num_End - Num_Start + 1;

    % 姿态解算
    Result_Att_INS = zeros(Num,4);
    Result_Att_INS(1,1) = IMU(1,1);
    Result_Att_INS(1,2:4) = Start_Att_theory';
    %(1)惯导解算结构体初始化 
    AttData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att_theory,Start_Vel,Start_Pos,Gyro_Bias_theory,[0;0;0],Ts);
    AttData_Pre = AttData_Now;     
    
    % 四元数解算
    Q_Now = AttData_Now.Q_b_n;
    Q_Pre = Q_Now;   
    Result_Att_Q = zeros(Num,4);
    Result_Att_Q(1,1) = IMU(1,1);
    Result_Att_Q(1,2:4) = Start_Att_theory';

for i = 2:Num    
%----------------------------惯导姿态解算
    AttData_Now.time = IMU(i,1);    
    AttData_Now.w_ib_b = IMU(i,5:7)';   %陀螺          
    AttData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %加计 
    %陀螺零偏修正
    AttData_Now.w_ib_b = AttData_Now.w_ib_b;
    AttData_Now = INS_Update_Static_Att(G_Const,AttData_Pre,AttData_Now,Ts);  
    %保存导航结果
    Result_Att_INS(i,1) = AttData_Now.time;      
    Result_Att_INS(i,2:4) = AttData_Now.att';
    %更新导航数据
    AttData_Pre =  AttData_Now;  
%----------------------------惯导姿态解算 四元数更新
    Thita0 = IMU(i-1,5:7)'.*Ts;
    Thita1 = IMU(i,5:7)'.*Ts;
    Vector = Thita1 + cross(Thita0,Thita1)/12;
    Q_add = Att_Rv2Q(Thita0);
    Q_Now = Math_QmulQ(Q_Pre, Q_add);
    Att = Att_DCM2euler(Att_Q2DCM(Q_Now));    
    Result_Att_Q(i,1) = IMU(i,1);
    Result_Att_Q(i,2:4) = Att';
    Q_Pre = Q_Now;  

end    


% 5.结果绘制比较
Plot_AVP_Group_Att(Result_Att_INS,Result_Att_Q,Num);

%Plot_AVP_Group_Att(Result_Att_INS,Result_att);
%Plot_AVP_Group_Att(Result_Att_INS,Result_Att_JiFen,Num);
% Plot_Att_Bias_1(Gyro_Bias_theory,Result_Bias_KF,j-1);
% Plot_XkPk_AttTest(XkPk);

