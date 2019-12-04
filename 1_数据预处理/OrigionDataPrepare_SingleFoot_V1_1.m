%--------------------------------------------------------------------------
% 对单脚实验数据 进行预处理
%       注意 输入数据文件txt的格式
%  V1.0 20191024 
%       利用压力和陀螺x轴信息同时判断状态
%  V1.1 201911109 
%       脚部状态分两步，第一步先利用压力进行状态判断
%                       第二步，再利用陀螺X轴数据进行 掐头去尾。
%--------------------------------------------------------------------------
clc;
clear all;
fprintf('---------预处理开始！\n');
%% 一、配置参数
    fprintf('一、配置参数\n');
    OnOff_GPS = 0;                  %是否包含GPS数据
    OnOff_IMUA = 0;                 %是否包含IMUA 的数据
    OnOff_IMUB = 1;                 %是否包含IMUB 的数据
    OnOff_FootPre = 1;              %是否包含脚底压力传感器的数据
    OnOff_UWB = 0;                  %是否包含UWB测距数据
    
    LorR = 1;                       %是左脚数据还是右脚数据  1 代表左脚 0 代表右脚
    SerialNumber = '4';             %记录数据的顺序编号

    Number_Start = 1;                %准备截取数据段的起点 默认为1
    Number_End = 0;                  %准备截取数据段的起点 默认为0 如果为0的话，就是一直到数据末尾
    
%% 二、读取数据
    fprintf('二、读取数据\n');
    %设置数据存放文件夹路径
    if LorR == 1
        %FilenamePach = 'F:\2_博士课题_JG\2_实验记录\20191024_清华实验室楼道左脚不带压力走个来回\0_原始数据\L_IMUGPS';
        FilenamePach = 'E:\2_博士课题_JG\2_实验记录\20191109_在单位办公楼内楼道来回试验\0_原始数据\IMUGPS';
    else
        %FilenamePach = 'F:\2_博士课题_JG\2_实验记录\20191024_清华实验室楼道左脚不带压力走个来回\0_原始数据\R_IMUGPS';
    end
    
    %读取GPS数据
    if OnOff_GPS == 1
        Filename_GPS = strcat(FilenamePach,SerialNumber,'_GPS.txt');
        Origion_GPS = importdata(Filename_GPS);
        clear Filename_GPS;       
    end
    %读取IMUA数据
    if OnOff_IMUA == 1
        Filename_IMUA = strcat(FilenamePach,SerialNumber,'_IMU_A.txt');
        Origion_IMUA = importdata(Filename_IMUA);
        clear Filename_IMUB;        
    end
    %读取IMUB数据
    if OnOff_IMUB == 1
        Filename_IMUB = strcat(FilenamePach,SerialNumber,'_IMU_B.txt');
        Origion_IMUB = importdata(Filename_IMUB);
        clear Filename_IMUB;        
    end    
    %读取压力传感器的数据
    if OnOff_FootPre == 1
        Filename_Foot = strcat(FilenamePach,SerialNumber,'_FootPressure.txt');
        Origion_Foot = importdata(Filename_Foot);
        clear Filename_Foot;        
    end
    %读取UWB的数据    
    if OnOff_UWB == 1
        Filename_UWB = strcat(FilenamePach,SerialNumber,'_UWB.txt');
        Origion_UWB = importdata(Filename_UWB);
        clear Filename_UWB;        
    end

    %%考虑一组数据种，IMU的数据不能少，以IMU的数据长度为标准
    if OnOff_IMUA == 1
        n = length(Origion_IMUA);
    else
        n = length(Origion_IMUB);       
    end
    if Number_Start > n
        return
    end
    if Number_End == 0 || Number_End > n
        Number_End = n - 10;
    end
    n = Number_End - Number_Start + 1;
        
%% 三、数据预处理——IMUB
    fprintf('三、数据预处理——IMUB\n');
if OnOff_IMUB == 1
    Data_IMUB = zeros(n,8);
    Data_IMUB(:,1) = Origion_IMUB(Number_Start:Number_End,1) + Origion_IMUB(Number_Start:Number_End,2)./1000;
    Data_IMUB(:,2:4) = Origion_IMUB(Number_Start:Number_End,3:5);
    Data_IMUB(:,5:7) = Origion_IMUB(Number_Start:Number_End,6:8).*(pi/180);  %陀螺数据由度/s 转变为 rad/s
    Data_IMUB(:,8) = Origion_IMUB(Number_Start:Number_End,9);     
    if LorR == 1   %处理左脚数据
        Data_IMUB_L = Data_IMUB;
    else
        %处理右脚的数据
        Data_IMUB_R = Data_IMUB;
    end   
end

%% 三、数据预处理——压力传感器
%   压力传感器数据 时间 4列压力值  按顺序分别代表 6 7 5 2号压力点
    fprintf('三、数据预处理——压力传感器\n');
if OnOff_FootPre == 1
%-----------------------压力数据转换---------------------------    
    Data_Foot = zeros(n,5);             %采集的电压数据
    Data_Foot_Press = zeros(n,5);       %对应的压力数据   将电压转化为电阻  再将电阻转化为压力值
    
    Data_Foot(:,1) = Origion_Foot(Number_Start:Number_End,1) + Origion_Foot(Number_Start:Number_End,2)./1000;
    Data_Foot(:,2:5) = Origion_Foot(Number_Start:Number_End,3:6);
    Data_Foot_Press(:,1) = Data_Foot(:,1);  
    
    % 拟合 压力(Y/g)—电阻(X/kR) 曲线
    %Temp_X = [50.00,30.30,20.80,14.20,9.18,6.92,5.85,5.00,4.36,4.02,3.43,3.28,3.16,3.05,2.91,2.78,2.71,2.61,2.53,2.49,2.45,2.42,2.37]';
    %Temp_Y = [300,500,1000,1500,2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000,10500,11000]';
    %用指数曲线拟合 参数如下：  f(x) = a*exp(b*x) + c*exp(d*x)
       a = 2.181e+05;
       b = -1.474;
       c = 5077;
       d = -0.08735;
       R1 = 10;
    for i=2:5
        for j=1:n
            %将输出转化为 电压 Vx = Data_Foot .* (3.6/1024.0) 单位 V
            Temp_Vx = Data_Foot(j,i)*3.6/1024.0;
            %将电压转化为电阻 R1 = 10K  R2 = 压力阻值 = Vx*R1/(3.6-Vx) 单位kR
            Temp_Rx = Temp_Vx*R1/(3.6 - Temp_Vx);
            %将电阻转化为压力值
            Data_Foot_Press(j,i) = a*exp(b*Temp_Rx) + c*exp(d*Temp_Rx);
        end
    end     
%-----------------------步态状态的判断---------------------------
%该方法目前仅适用于慢走或快走，对跑动的还没有测试
    %(1)压力传感器运动状态判断    
    fprintf('  (1)压力传感器运动状态判断\n'); 
    Data_Foot_State = zeros(n,2);
    Temp_Press = 50;            %脚底压力值 阈值    
    % (1.1)基于压力数据的状态判断   
    fprintf('  (1.1)基于压力数据的状态判断\n'); 
    for i = 1:n
        Data_Foot_State(i,1) = Data_Foot_Press(i,1);   %时间
        if ((Data_Foot_Press(i,2)+Data_Foot_Press(i,3)+Data_Foot_Press(i,4)+Data_Foot_Press(i,5))>Temp_Press) 
            Data_Foot_State(i,2) = 1;
        else
            Data_Foot_State(i,2) = 0;
        end
    end
    % (1.2)针对状态进行统计  
    fprintf('  (1.2)针对状态进行统计\n');     
    Temp_Num = 200*0.05;    %一步1s 周期的5%
    Temp_j = 1;
    Temp_Step(Temp_j,1) = Data_Foot_State(1,2);  % 初始状态
    Temp_Step(Temp_j,2) = 1;                    % 当前状态数量
    Temp_Step(Temp_j,3) = 1;                    % 状态起点
    for i = 2:n
        if Temp_Step(Temp_j,1) ~= Data_Foot_State(i,2)
            %状态变更了
            Temp_Step(Temp_j,4) = i-1;         % 状态终点
            if Temp_Step(Temp_j,2) <= Temp_Num
                fprintf('    跳点	个数:%d	起点:%d	终点:%d\n',Temp_Step(Temp_j,2),Temp_Step(Temp_j,3),Temp_Step(Temp_j,4));
            end
            Temp_j = Temp_j + 1;                % 开始新的状态记录
            Temp_Step(Temp_j,1) = Data_Foot_State(i,2);  % 初始状态
            Temp_Step(Temp_j,2) = 1;                    % 当前状态数量
            Temp_Step(Temp_j,3) = i;                    % 状态起点            
        else
            %状态不变 计数值增加
            Temp_Step(Temp_j,2) = Temp_Step(Temp_j,2)+1;
        end
    end
    % (1.3)针对状态统计信息进行 修正
    %     为简单起见，将跳变的状态信息归并到前一个状态上去
    fprintf('  (1.3)针对状态统计信息进行 修正\n');      
    Temp_j = length(Temp_Step);    
    for i = 2:Temp_j
        if Temp_Step(i,2)<=Temp_Num            
            for j = Temp_Step(i,3):Temp_Step(i,4)
                Data_Foot_State(j,2) = Temp_Step(i-1,1);
            end
        end
    end
    
    % (1.4)对修正结果进行验证
    fprintf('  (1.4)对修正结果进行验证\n');      
    clear Temp_j Temp_Step;
    Temp_j = 1;
    Temp_Step(Temp_j,1) = Data_Foot_State(1,2);  % 初始状态
    Temp_Step(Temp_j,2) = 1;                    % 当前状态数量
    Temp_Step(Temp_j,3) = 1;                    % 状态起点
    for i = 2:n
        if Temp_Step(Temp_j,1) ~= Data_Foot_State(i,2)
            %状态变更了
            Temp_Step(Temp_j,4) = i-1;         % 状态终点
            if Temp_Step(Temp_j,2) <= Temp_Num
                fprintf('    跳点	个数:%d	起点:%d	终点:%d\n',Temp_Step(Temp_j,2),Temp_Step(Temp_j,3),Temp_Step(Temp_j,4));
            end
            Temp_j = Temp_j + 1;                % 开始新的状态记录
            Temp_Step(Temp_j,1) = Data_Foot_State(i,2);  % 初始状态
            Temp_Step(Temp_j,2) = 1;                    % 当前状态数量
            Temp_Step(Temp_j,3) = i;                    % 状态起点
        else
            %状态不变 计数值增加
            Temp_Step(Temp_j,2) = Temp_Step(Temp_j,2)+1;
        end
    end
    clear Temp_j Temp_Num Temp_Step;
    %Test
    figure;
    plot(Data_IMUB_L(:,1),Data_IMUB_L(:,5)+1);
    hold on;
    plot(Data_Foot_State(:,1),Data_Foot_State(:,2),'r-.');
    hold on;
    
    %(2)陀螺辅助压力传感器判断
    fprintf('  (2)陀螺辅助压力传感器判断\n');      
    %(2.1)陀螺X轴方差计算
    fprintf('  (2.1)陀螺X轴方差计算\n');    
    Temp_GyroX_Num = 5;         %选用几个周期陀螺数据进行判断
    Temp_GyroX_VarMax = 0.1;    %利用陀螺方法判断的 阈值  
    fprintf('    选用的参数：计算周期 %d  X轴陀螺方差阈值：%f\n',Temp_GyroX_Num,Temp_GyroX_VarMax);      
    Temp_GyroX_Mean = mean(Data_IMUB(10*200:50*200,5));        %X陀螺静止输出均值 从第10秒开始到50秒结束
    fprintf('               X轴陀螺静止输出均值为：%f度/h\n',Temp_GyroX_Mean*180/pi*3600);     
    Temp_GyroX_Var = zeros(n,2);
    for i = 1:n
        Temp_GyroX_Var(i,1) = Data_IMUB(i,1);
        if i<Temp_GyroX_Num
            Temp_Var = 0;
            for j=1:i
                Temp_Var = Temp_Var + (Data_IMUB(j,5)-Temp_GyroX_Mean)^2;
            end
            Temp_GyroX_Var(i,2) = sqrt(Temp_Var)/i;
        else
            Temp_Var = 0;
            for j=i-Temp_GyroX_Num+1:i
                Temp_Var = Temp_Var + (Data_IMUB(j,5)-Temp_GyroX_Mean)^2;
            end
            Temp_GyroX_Var(i,2) = sqrt(Temp_Var)/Temp_GyroX_Num;
        end
    end
    %Test
    plot(Temp_GyroX_Var(:,1),Temp_GyroX_Var(:,2)+1,'g-*');
    hold on;
    
    %(2.2)利用陀螺X轴的方差对压力的判断进行掐头去尾
    Temp_Foot_State = Data_Foot_State(1,2);
    for i = 1:n
        %进入头判断
        if (Temp_Foot_State == 0) && (Data_Foot_State(i,2) == 1)
            if Temp_GyroX_Var(i,2) > Temp_GyroX_VarMax
                Data_Foot_State(i,2) = 0;
                continue;
            else
                Temp_Foot_State = 1;
            end
        end
        %进入尾判断
        if (Temp_Foot_State == 1) && (Data_Foot_State(i,2) == 0)
            %往前追溯 4倍Temp_GyroX_Num周期的数据
            if i < 4*Temp_GyroX_Num
                Temp_Foot_State = 0;
                continue;
            end       
            for j = 1:4*Temp_GyroX_Num
                if Temp_GyroX_Var(i-j+1,2)>Temp_GyroX_VarMax
                    Data_Foot_State(i-j+1,2) = 0; 
                else
                    Data_Foot_State(i-j+1,2) = 0; 
                    Data_Foot_State(i-j,2) = 0;
                    Data_Foot_State(i-j-1,2) = 0;
                    Data_Foot_State(i-j-2,2) = 0;
                    Data_Foot_State(i-j-3,2) = 0;
                    break;
                end                            
            end 
            Temp_Foot_State = 0;
        end        
    end
    plot(Data_Foot_State(:,1),Data_Foot_State(:,2),'r');
    hold on;   
    
%% 四、数据赋值    
    fprintf('四、数据赋值\n');
	if LorR == 1   %处理左脚数据
        Data_Foot_L = Data_Foot;
        Data_Foot_L_Press = Data_Foot_Press;
        Data_Foot_L_State = Data_Foot_State;
        Origion_Foot_L = Origion_Foot;
        Origion_IMUB_L = Origion_IMUB;
    else
        %处理右脚的数据
        Data_Foot_R = Data_Foot;
        Data_Foot_R_Press = Data_Foot_Press;
        Data_Foot_R_State = Data_Foot_State;
        Origion_Foot_R = Origion_Foot;
        Origion_IMUB_R = Origion_IMUB;
    end  
    clear Temp_Foot_State Temp_GyroX_Mean Temp_GyroX_Num Origion_Foot Origion_IMUB;
    clear Temp_GyroX_Var Temp_GyroX_VarMax Temp_Press Temp_Var;
    clear a b c d R1 Data_Foot Data_Foot_Press i j Temp_Vx Temp_Rx;    
end
    fprintf('---------预处理结束！\n');





%% 验证数据的正确性
% 1.验证陀螺数据的准确性
% if OnOff_IMUB == 1
%     figure;
%     plot(Origion_IMUB(:,1)+Origion_IMUB(:,2)./1000,Origion_IMUB(:,5));
%     hold on; plot(Data_IMUB_L(:,1),Data_IMUB_L(:,4),'r*');
% end
% 2.验证压力传感器静止状态判断的准确性
% if  OnOff_FootPre == 1
%     Vel = zeros(n,2);
%     for i=1:n
%         Vel(i,1) = Data_IMUB(i,1);
%         Vel(i,2) = sqrt(Data_IMUB(i,3)^2+Data_IMUB(i,4)^2+Data_IMUB(i,5)^2);
%     end
%     
%     figure;
%     plot(Data_IMUB_L(:,7)+10);
%     hold on; plot(Vel(:,2),'g.-');
%     hold on; plot(Data_Foot_State(:,2).*10,'r');
%     
%     clear i Vel;
% end
%% 清除不要的变量
    clear FilenamePach LorR n Number_End Number_Start OnOff_FootPre OnOff_GPS;
    clear OnOff_IMUA OnOff_IMUB OnOff_UWB SerialNumber Data_IMUB Data_Foot_State;