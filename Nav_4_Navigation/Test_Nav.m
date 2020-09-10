%% 导航实验  将静止状态下求取的 水平和航向角 绘制在一起

% 1. 获取静止数据段的起始和结尾序号
    L = length(FootPres_State);
    j = 1;
    TStart = 0;  %判断是否进入静止阶段
    for i = 1:L
        %第一个点的判断
        if i == 1
            if FootPres_State(1,2) == 1
                TStart = 1;  %进入静止阶段
                StaticRecord(1,1) = 1;
            end
        else
            if FootPres_State(i,2) ~= FootPres_State(i-1,2)
               % 状态发生变化
               if FootPres_State(i-1,2) == 1
                  % 到结尾了
                  StaticRecord(j,2) = i;
                  j = j+1;
               else
                  % 新时段的开始
                  StaticRecord(j,1) = i;
               end
            end
        end  
    end
    % 增加结尾判断
    if StaticRecord(j,2) == 0
        StaticRecord(j,2) = L;
    end
    
% 2. 利用分段静止数据进行 姿态角的求取
    Att = zeros(L,4);
    Att(:,1) = Result_1(:,1);
% 2.1 分段获取加计和磁强计 静止时间段器件输出的均值
    L = length(StaticRecord);
    Mean_Acc = zeros(L,3);
    Mean_Mag = zeros(L,3);
    for i = 1:L
        Mean_Acc(i,:) = mean(IMU(StaticRecord(i,1):StaticRecord(i,2),2:4));
        Mean_Mag(i,:) = mean(Magnetic(ceil(StaticRecord(i,1)/2):ceil(StaticRecord(i,2)/2-1),2:4));
    end

% 2.2 先将加计进行校准，然后进行水平姿态的求取
    % 加计非正交 校正参数
    Acc_Calibrat = [1.000264037	-0.00004585	-0.006794537;
                    -0.0051893  0.99927623	0.01848056;
                    0.024396733	-0.00342088	0.998533567];  
    Mean_Acc_Calibrat = zeros(L,3);
    Mean_Att_Calibrat = zeros(L,3);
    for i = 1:L
        Mean_Acc_Calibrat(i,:) = (Acc_Calibrat * Mean_Acc(i,:)')';  
        [Mean_Att_Calibrat(i,1),Mean_Att_Calibrat(i,2)] = Att_Accel2Att(Mean_Acc_Calibrat(i,1),Mean_Acc_Calibrat(i,2),Mean_Acc_Calibrat(i,3));     
    end
    
% 2.3 将磁强计的数据进行水平面投影 校正后，求取航向
    Mean_Mag_Level = zeros(L,3);
    for i = 1:L
        C_b_n = Att_Euler2DCM(Mean_Att_Calibrat(i,:)');
        Mag = C_b_n*[Mean_Mag(i,:)'];
        Mean_Mag_Level(i,:) = Mag'; 
    end        
    % 磁强计校正参数
    Mag_A22 = [1.0001,0.0065848;0.0071925,0.91558];
    Mag_B21 = [7.4162;0.95541];
    Mean_Mag_Calibrat = zeros(L,2);
    for i = 1:L
        Mean_Mag_Calibrat(i,1:2) = ((Mag_A22*Mean_Mag_Level(i,1:2)') - Mag_B21)';
    end
    % 求取航向
    for i = 1:L
        Mean_Att_Calibrat(i,3) = -Att_Mag2Yaw(0,0,Mean_Mag_Calibrat(i,1),Mean_Mag_Calibrat(i,2),0);
    end   
    
% 3. 把姿态填入对应的序号内
    L = length(StaticRecord);
    for i=1:L
        for j = StaticRecord(i,1):StaticRecord(i,2)
            Att(j,2:4) = Mean_Att_Calibrat(i,1:3);
        end
    end
    

    Plot_AVP_Group_Test(Att,Result_4);
 
    