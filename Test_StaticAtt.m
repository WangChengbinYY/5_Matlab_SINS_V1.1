% 设定解算的起始点和终止点
% clear;clc;
% load('D:\清华博士\2_博士课题_JG\2_实验记录\20200326_办公室内短距离2来回\原地左右旋转3圈\MPU_L_1_43000_52300.mat')
%Num_Start = 1;  Num_End = 1096;
Num_Start = 1;  Num_End = length(IMU);
%Start_Att = [-0.0845;0.0965;1.4706];  %起始姿态
Start_Att = [0;0;0];
Start_Vel = zeros(3,1);
Start_Pos = [0.5975;1.9017;400.0000];
Ts = 1/200;
%Ts = 1;
G_Const = CONST_Init();

Num = length(IMU);
Result_Att = zeros(Num,4);
Result_Att_JiFen = zeros(Num,4);
Result_Att_JiFen(1,2:4) = Start_Att';
INS_AVP = zeros(Num,10);

%Gyro_Bias = [mean(IMU(1:Num,5));mean(IMU(1:Num,6));mean(IMU(1:Num,7))];
%Gyro_Bias = [-0.0617633;-0.006840;0.00976214];
Gyro_Bias = [0;0;0];
Acc_Bias = [0;0;0];

%(1)惯导解算结构体初始化 
INSData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
INSData_Pre = INSData_Now; 

AttData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
AttData_Pre = AttData_Now; 

   for i = 2:Num_End
 
  %------------正常惯导解算-------------------
                %(1)获取IMU原始数据
        INSData_Now.time = IMU(i,1);    
        INSData_Now.w_ib_b = IMU(i,5:7)';   %陀螺          
        INSData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %加计 
        
        %(2)陀螺和加计 原始数据修正
        %加计修正 (此处仅修正加计的，因为6位置法仅校准加计的非正交)，后面可以试验，同时修正陀螺的是否有效果！        
        %INSData_Now.f_ib_b = M_a*[INSData_Now.f_ib_b;1];
        %陀螺零偏修正
        INSData_Now.w_ib_b = INSData_Now.w_ib_b - INSData_Now.eb;
        
        %(3)惯导解算
        INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts);             
            
        %(4)保存导航结果
        INS_AVP(i,1) = INSData_Now.time;      
        INS_AVP(i,2:4) = INSData_Now.att';
        INS_AVP(i,5:7) = INSData_Now.vel';
        INS_AVP(i,8:10) = INSData_Now.pos';     
    

        %(5)更新导航数据
        INSData_Pre =  INSData_Now;               
  
  %------------姿态解算-----------------------
        %(1)获取IMU原始数据
        AttData_Now.time = IMU(i,1);    
        AttData_Now.w_ib_b = IMU(i,5:7)';   %陀螺          
        AttData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %加计 
        
        %(2)陀螺和加计 原始数据修正
        %陀螺零偏修正
        AttData_Now.w_ib_b = AttData_Now.w_ib_b - AttData_Now.eb;
        
        %(3)惯导解算
        AttData_Now = INS_Update_Static_Att(G_Const,AttData_Pre,AttData_Now,Ts);        
            
        %(4)保存导航结果
        Result_Att(i,1) = AttData_Now.time;      
        Result_Att(i,2:4) = AttData_Now.att';
        
        %(5)更新导航数据
        AttData_Pre =  AttData_Now;        
        
        if i>1
            Result_Att_JiFen(i,1) = IMU(i,1);  
            Result_Att_JiFen(i,2:4) = Result_Att_JiFen(i-1,2:4) + (IMU(i,5:7)-AttData_Now.eb').*(Ts);
        end
        
    end

% 5.结果绘制比较
Plot_AVP_Att_1(Result_Att,Num);
Plot_AVP_Group_Att(Result_Att_JiFen,Result_Att,Num);
% Plot_AVP_Group_Att(Result_Att,Result_1);
% figure;plot((Result_Att(:,2)-INS_AVP(:,2)).*(180/pi));