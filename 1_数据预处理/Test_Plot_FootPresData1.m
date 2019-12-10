[n,m] = size(Data_Foot_Press);
% 1. 先获取前脚掌和后脚跟的压力数据
% 这里设定 步态分析的起始时间和结束时间  也就是IMU惯导解算的起始时间和结束时间
% 这里可以设计成三个参数，一个是启动时间，一个是静止结束时间，一个是导航结束时间
StartNumber = 84850; EndNumber = 224740; Number = EndNumber-StartNumber+1;
Foot_Press_front = zeros(Number,2);  
Foot_Press_back = zeros(Number,2);  
Foot_Press_back(:,1) = Data_Foot_Press(StartNumber:EndNumber,1);
Foot_Press_front(:,1) = Data_Foot_Press(StartNumber:EndNumber,1);
Foot_Press_back(:,2) = Data_Foot_Press(StartNumber:EndNumber,2)+Data_Foot_Press(StartNumber:EndNumber,3);
Foot_Press_front(:,2) = Data_Foot_Press(StartNumber:EndNumber,4)+Data_Foot_Press(StartNumber:EndNumber,5);

figure;
plot(Foot_Press_front(:,1),Foot_Press_front(:,2),'k');  %足底压力x
hold on; plot(Foot_Press_back(:,1),Foot_Press_back(:,2),'g');
hold on;plot(IMU(StartNumber:EndNumber,1),IMU(StartNumber:EndNumber,4)*100,'-.');  %加计
hold on;plot(IMU(StartNumber:EndNumber,1),IMU(StartNumber:EndNumber,5)*500,'r-.');  %陀螺
% legend('前脚掌','后脚跟');
legend('前脚掌','后脚跟','加计Z','陀螺X');
grid on;


% 2. 先处理后脚跟的数据，因为后脚跟行走时先落地，并且冲击最大
%   一般开机，人都是在静止状态的，所以可以依据初始的第一个压力值判断是否在静止状态
[n,m] = size(Foot_Press_back);
% 处理后脚跟的状态
Foot_Back_State = zeros(n,2);
Foot_Back_State(:,1) = Foot_Press_back(:,1);
i = 0;
while i < n
    i = i+1;
    if i == 1
        %起始阶段 的判断
        if Foot_Press_back(1,2) >= 100
            %起始静止状态
            Foot_Back_State(1,2) = 1;
            i = i+1;
            while Foot_Press_back(i,2) >= 100
                Foot_Back_State(i,2) = 1;
                i = i+1;
            end
                Foot_Back_State(i,2) = 0;
        else
            %起始运动状态
            Foot_Back_State(1,2) = 0;
             i = i+1;
            while Foot_Press_back(i,2) < 100
                Foot_Back_State(i,2) = 0;
                i = i+1;
            end
                Foot_Back_State(i,2) = 1;         
        end
    end
    if (Foot_Back_State(i-1,2) == 0) && (Foot_Press_back(i,2) > 100)
        %从运动 进入 静止
        Foot_Back_State(i,2) = 1;
        continue;
    end        
    if (Foot_Back_State(i-1,2) == 1) && (Foot_Press_back(i,2) < 100)
        %从静止 进入 运动
        Foot_Back_State(i,2) = 0;  
        continue;
    end    
    Foot_Back_State(i,2) = Foot_Back_State(i-1,2);
end

% 对处理结果进行纠偏 纠正跳点
TStartSerial = 1;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if Foot_Back_State(i,2) ~= Foot_Back_State(i-1,2)
        if StateNum >= 10
            %正常变换
            TStartSerial = i;
            StateNum = 1;
        else
            %有跳点
            Foot_Back_State(TStartSerial:i-1,2) = Foot_Back_State(TStartSerial-1,2);
            StateNum = StateNum+10;
        end
    else
        StateNum = StateNum + 1;
    end
end

figure;
plot(Foot_Press_front(:,1),Foot_Press_front(:,2),'k');  %足底压力x
hold on; plot(Foot_Press_back(:,1),Foot_Press_back(:,2),'g');
hold on;plot(Foot_Back_State(:,1),Foot_Back_State(:,2).*1500,'b');
grid on;
legend('前脚掌','后脚跟','后脚跟判断');
% hold on;plot(IMU(StartNumber:EndNumber,1),IMU(StartNumber:EndNumber,4)*100,'-.');  %加计
% hold on;plot(IMU(StartNumber:EndNumber,1),IMU(StartNumber:EndNumber,5)*500,'r-.');  %陀螺
% legend('前脚掌','后脚跟','加计Z','陀螺X');


% 3. 同上处理前脚掌数据
[n,m] = size(Foot_Press_front);
% 处理后脚跟的状态
Foot_front_State = zeros(n,2);
Foot_front_State(:,1) = Foot_Press_front(:,1);
i = 0;
while i < n
    i = i+1;
    if i == 1
        %起始阶段 的判断
        if Foot_Press_front(1,2) >= 100
            %起始静止状态
            Foot_front_State(1,2) = 1;
            i = i+1;
            while Foot_Press_front(i,2) >= 100
                Foot_front_State(i,2) = 1;
                i = i+1;
            end
                Foot_front_State(i,2) = 0;
        else
            %起始运动状态
            Foot_front_State(1,2) = 0;
             i = i+1;
            while Foot_Press_front(i,2) < 100
                Foot_front_State(i,2) = 0;
                i = i+1;
            end
                Foot_front_State(i,2) = 1;          
        end
    end
    if (Foot_front_State(i-1,2) == 0) && (Foot_Press_front(i,2) > 100)
        %从运动 进入 静止
        Foot_front_State(i,2) = 1;
        continue;
    end        
    if (Foot_front_State(i-1,2) == 1) && (Foot_Press_front(i,2) < 100)
        %从静止 进入 运动
        Foot_front_State(i,2) = 0;  
        continue;
    end    
    Foot_front_State(i,2) = Foot_front_State(i-1,2);
end

% 对处理结果进行纠偏 纠正跳点
TStartSerial = 1;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if Foot_front_State(i,2) ~= Foot_front_State(i-1,2)
        if StateNum >= 10
            %正常变换
            TStartSerial = i;
            StateNum = 1;
        else
            %有跳点
            Foot_front_State(TStartSerial:i-1,2) = Foot_front_State(TStartSerial-1,2);
            StateNum = StateNum+10;
        end
    else
        StateNum = StateNum + 1;
    end
end

figure;
plot(Foot_Press_front(:,1),Foot_Press_front(:,2),'k');  %足底压力x
hold on; plot(Foot_Press_back(:,1),Foot_Press_back(:,2),'g');
legend('前脚掌','后脚跟');
hold on;plot(Foot_front_State(:,1),Foot_front_State(:,2).*1400,'b');
hold on;plot(Foot_Back_State(:,1),Foot_Back_State(:,2).*1500,'b');
grid on;
legend('前脚掌','后脚跟','后脚跟判断','前脚掌判断');
hold on;plot(IMU(StartNumber:EndNumber,1),IMU(StartNumber:EndNumber,4)*100,'-.');  %加计
hold on;plot(IMU(StartNumber:EndNumber,1),IMU(StartNumber:EndNumber,5)*500,'r-.');  %陀螺


% 3. 对脚掌和脚跟的状态进行综合判断 步态
% 3.1 先对脚跟 进行状态的聚类，提取出有压力的起始和终止点，以及对应时间段内的峰值点
[n,m] = size(Foot_Back_State);
% 起始点 结束点 峰值点
j=1;
RecoardBack = [];
for i = 1:n
    if i == 1
        while (Foot_Back_State(i,2)>0)
           i = i+1; 
        end
        continue;
    end
    
    if (Foot_Back_State(i,2) == 1) && (Foot_Back_State(i-1,2) == 0)
        RecoardBack(j,1) = i;
    end
    if (Foot_Back_State(i,2) == 0) && (Foot_Back_State(i-1,2) == 1)
        RecoardBack(j,2) = i;        
        %查找最大值
        %RecoardBack(j,3) = max(Foot_Back_State(RecoardBack(j,1):RecoardBack(j,2),2));
        j = j+1;
    end        
end




[n,m] = size(Data_Foot_Press);
FootPres_State = zeros(n,2);
FootPres_State(:,1) = Data_Foot_Press(:,1);
for i = 1:n
    if i == 1
       %初始状态
       while (Foot_front_State(i,2)+Foot_Back_State(i,2))>0
           FootPres_State(:,2) = 1;
           i = i+1;
       end
       continue;
    end
    
    
    
    
end



