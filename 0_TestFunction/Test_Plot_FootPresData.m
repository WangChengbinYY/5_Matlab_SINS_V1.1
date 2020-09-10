%% 0 输入为压力传感器的原始数据  FootPres
% 时间对齐后，绘制足底压力传感器和陀螺 加计数据，对照显示
%  压力传感器顺序'脚跟内侧6','脚跟外侧7','脚掌内侧5','脚掌外侧2'
%原始压力信息的比较，此时压力数值代表的还是电压
clear all;
load('E:\ADIS_L_26605_27308.mat');
figure;
plot(FootPres(:,1),FootPres(:,2),'k');  %足底压力x
hold on; plot(FootPres(:,1),FootPres(:,3),'r');
hold on; plot(FootPres(:,1),FootPres(:,4),'g');
hold on; plot(FootPres(:,1),FootPres(:,5),'b');
hold on;plot(IMU(:,1),IMU(:,4)*10+990,'-.');  %加计
hold on;plot(IMU(:,1),IMU(:,5)*50+1000,'r-.');  %陀螺
grid on;
legend('脚跟内侧','脚跟外侧','脚掌内侧','脚掌外侧','加计Z','陀螺X');
xlabel('\it t \rm / s');       
title('压力传感器原始数据');

%% 一、对压力原始数据进行处理 
%   脚静止，有压力，电阻小，电压小
%   脚运动，无压力，电阻大，电压大
% 1. FootPres_Limit 先去掉毛刺   880 对应3.0938V 对应61K欧 对应 24g  去掉原始数据最上面的毛刺和数据回跳
[n,m] = size(FootPres);
FootPres_Limit = FootPres;
for j = 2:5
    for i = 1:n
        if FootPres_Limit(i,j) > 900
            FootPres_Limit(i,j) = 900;
        end   
    end
end
% 翻转  波动代表压力
for j = 2:5
    for i = 1:n
        FootPres_Limit(i,j) = (-1)*FootPres_Limit(i,j)+900;   
    end
end
figure;
plot(FootPres_Limit(:,1),FootPres_Limit(:,2)+FootPres_Limit(:,3),'k');  %足底压力x
hold on; plot(FootPres_Limit(:,1),FootPres_Limit(:,4)+FootPres_Limit(:,5),'g');
hold on;plot(IMU(:,1),IMU(:,4)*10,'-.');  %加计
hold on;plot(IMU(:,1),IMU(:,5)*50,'r-.');  %陀螺
grid on;
legend('脚跟压力','脚掌压力','加计Z','陀螺X');
xlabel('\it t \rm / s');       
title('压力传感器原始数据');


%% 二、对转化后的压力 FootPres_Pa 进行步态判断 
% 1. 先获取前脚掌和后脚跟的压力数据 分别将前 后 的两个点数据求和
% 这里设定 步态分析的起始时间和结束时间  也就是IMU惯导解算的起始时间和结束时间
% 这里可以设计成三个参数，一个是启动时间，一个是静止结束时间，一个是导航结束时间
FootPres_Pa = FootPres_Limit;
[n,m] = size(FootPres_Pa);
FootPres_Pa_front = zeros(n,2);  
FootPres_Pa_back = zeros(n,2);  
FootPres_Pa_back(:,1) = FootPres_Pa(:,1);
FootPres_Pa_front(:,1) = FootPres_Pa(:,1);
FootPres_Pa_back(:,2) = FootPres_Pa(:,2)+FootPres_Pa(:,3);
FootPres_Pa_front(:,2) = FootPres_Pa(:,4)+FootPres_Pa(:,5);

% 2. 先处理后脚跟的数据，因为后脚跟行走时先落地，并且冲击最大
%   一般开机，人都是在静止状态的，所以可以依据初始的第一个压力值判断是否在静止状态
[n,m] = size(FootPres_Pa_back);
% 处理后脚跟的状态
FootPreState_back = zeros(n,2);
FootPreState_back(:,1) = FootPres_Pa_back(:,1);
i = 0;
while i < n
    i = i+1;
    if i == 1
        %起始阶段 的判断
        if FootPres_Pa_back(1,2) >= 100
            %起始静止状态
            FootPreState_back(1,2) = 1;
            i = i+1;
            while FootPres_Pa_back(i,2) >= 100
                FootPreState_back(i,2) = 1;
                i = i+1;
            end
                FootPreState_back(i,2) = 0;
        else
            %起始运动状态
            FootPreState_back(1,2) = 0;
             i = i+1;
            while FootPres_Pa_back(i,2) < 100
                FootPreState_back(i,2) = 0;
                i = i+1;
            end
                FootPreState_back(i,2) = 1;         
        end
    end
    if (FootPreState_back(i-1,2) == 0) && (FootPres_Pa_back(i,2) > 100)
        %从运动 进入 静止
        FootPreState_back(i,2) = 1;
        continue;
    end        
    if (FootPreState_back(i-1,2) == 1) && (FootPres_Pa_back(i,2) < 100)
        %从静止 进入 运动
        FootPreState_back(i,2) = 0;  
        continue;
    end    
    FootPreState_back(i,2) = FootPreState_back(i-1,2);
end

% 对处理结果进行纠偏 纠正跳点
TStartSerial = 1;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if FootPreState_back(i,2) ~= FootPreState_back(i-1,2)
        if StateNum >= 10
            %正常变换
            TStartSerial = i;
            StateNum = 1;
        else
            %有跳点
            FootPreState_back(TStartSerial:i-1,2) = FootPreState_back(TStartSerial-1,2);
            StateNum = StateNum+10;
        end
    else
        StateNum = StateNum + 1;
    end
end

figure;
plot(FootPres_Pa_back(:,1),FootPres_Pa_back(:,2),'k');  %足底压力x
hold on; plot(FootPres_Pa_front(:,1),FootPres_Pa_front(:,2),'g');
hold on;plot(FootPreState_back(:,1),FootPreState_back(:,2).*1500,'b');
title('后脚跟压力状态State');
grid on;
legend('后脚跟','前脚掌','后脚跟判断');
hold on;plot(IMU(:,1),IMU(:,4)*100,'-.');  %加计
hold on;plot(IMU(:,1),IMU(:,5)*500,'r-.');  %陀螺
clear i m n Number StateNum TStartSerial;

% 3. 同上处理前脚掌数据
[n,m] = size(FootPres_Pa_front);
% 处理前脚掌的状态
FootPreState_front = zeros(n,2);
FootPreState_front(:,1) = FootPres_Pa_front(:,1);
i = 0;
while i < n
    i = i+1;
    if i == 1
        %起始阶段 的判断
        if FootPres_Pa_front(1,2) >= 100
            %起始静止状态
            FootPreState_front(1,2) = 1;
            i = i+1;
            while FootPres_Pa_front(i,2) >= 100
                FootPreState_front(i,2) = 1;
                i = i+1;
            end
                FootPreState_front(i,2) = 0;
        else
            %起始运动状态
            FootPreState_front(1,2) = 0;
             i = i+1;
            while FootPres_Pa_front(i,2) < 100
                FootPreState_front(i,2) = 0;
                i = i+1;
            end
                FootPreState_front(i,2) = 1;          
        end
    end
    if (FootPreState_front(i-1,2) == 0) && (FootPres_Pa_front(i,2) > 100)
        %从运动 进入 静止
        FootPreState_front(i,2) = 1;
        continue;
    end        
    if (FootPreState_front(i-1,2) == 1) && (FootPres_Pa_front(i,2) < 100)
        %从静止 进入 运动
        FootPreState_front(i,2) = 0;  
        continue;
    end    
    FootPreState_front(i,2) = FootPreState_front(i-1,2);
end

% 对处理结果进行纠偏 纠正跳点
TStartSerial = 1;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if FootPreState_front(i,2) ~= FootPreState_front(i-1,2)
        if StateNum >= 10
            %正常变换
            TStartSerial = i;
            StateNum = 1;
        else
            %有跳点
            FootPreState_front(TStartSerial:i-1,2) = FootPreState_front(TStartSerial-1,2);
            StateNum = StateNum+10;
        end
    else
        StateNum = StateNum + 1;
    end
end

figure;
plot(FootPres_Pa_back(:,1),FootPres_Pa_back(:,2),'k');            %足底压力x
hold on; plot(FootPres_Pa_front(:,1),FootPres_Pa_front(:,2),'g');
hold on;plot(FootPreState_front(:,1),FootPreState_front(:,2).*1400,'b');
hold on;plot(FootPreState_back(:,1),FootPreState_back(:,2).*1500,'b.-');
title('脚底压力状态 State');
grid on;
hold on;plot(IMU(:,1),IMU(:,4)*100,'-.');  %加计
hold on;plot(IMU(:,1),IMU(:,5)*500,'r-.');  %陀螺
legend('后脚跟','前脚掌','前脚掌判断','后脚跟判断');
clear i m n StateNum TStartSerial;

%% 三、 利用前后压力判断状态 进行 脚的步态判断
% 1.利用 后脚跟的状态 FootPreState_back 寻找 每个接地过程中的压力极值 FootPres_Pa_back
[n,m] = size(FootPreState_back);
mBegin = 0; mBegin_Serial = 0; 
mEnd = 0;   mEnd_Serial = 0; 
for i = 2:n
    if (FootPreState_back(i-1,2) == 0)&&(FootPreState_back(i,2) == 1)
        mBegin = 1;
        mBegin_Serial = i;
    end
    if (mBegin == 1)&&(FootPreState_back(i-1,2) == 1)&&(FootPreState_back(i,2) == 0)
        mEnd = 1;
        mEnd_Serial = i;
    end    
    if (mBegin == 1)&&(mEnd == 1)   
        if mEnd_Serial > mBegin_Serial
            [mMax,mIndex] = max(FootPres_Pa_back(mBegin_Serial:mEnd_Serial,2));
            FootPreState_back(mIndex+mBegin_Serial-1,2) = 2;
        end
        mBegin = 0;
        mEnd = 0;        
    end    
end

% 2.利用 前脚掌的状态 FootPreState_front 寻找 每个接地过程中的压力极值 FootPres_Pa_front
[n,m] = size(FootPreState_front);
mBegin = 0; mBegin_Serial = 0; 
mEnd = 0;   mEnd_Serial = 0; 
for i = 2:n
    if (FootPreState_front(i-1,2) == 0)&&(FootPreState_front(i,2) == 1)
        mBegin = 1;
        mBegin_Serial = i;
    end
    if (mBegin == 1)&&(FootPreState_front(i-1,2) == 1)&&(FootPreState_front(i,2) == 0)
        mEnd = 1;
        mEnd_Serial = i;
    end    
    if (mBegin == 1)&&(mEnd == 1)   
        if mEnd_Serial > mBegin_Serial
            [mMax,mIndex] = max(FootPres_Pa_front(mBegin_Serial:mEnd_Serial,2));
            FootPreState_front(mIndex+mBegin_Serial-1,2) = 2;
        end
        mBegin = 0;
        mEnd = 0;        
    end    
end

figure;
plot(FootPres_Pa_back(:,1),FootPres_Pa_back(:,2),'k');            %足底压力x
hold on; plot(FootPres_Pa_front(:,1),FootPres_Pa_front(:,2),'g');
hold on;plot(FootPreState_back(:,1),FootPreState_back(:,2)*1000,'b.-');
hold on;plot(FootPreState_front(:,1),FootPreState_front(:,2)*1500,'b.-');
title('脚底压力状态 State');
grid on;
hold on;plot(IMU(:,1),IMU(:,4)*100,'-.');  %加计
hold on;plot(IMU(:,1),IMU(:,5)*500,'r-.');  %陀螺
legend('后脚跟','前脚掌','前脚掌判断','后脚跟判断');

% 3.步态综合判断
[n,m] = size(FootPreState_back);
FootPre_State = zeros(n,2);
FootPre_State(:,1) = FootPres(:,1);
mBegin = 0; mBegin_Serial = 0; 
mEnd = 0;   mEnd_Serial = 0; 
i = 0;
while i<n
    i = i+1;
    %开头
    if i == 1
        while (FootPreState_back(i,2)+FootPreState_front(i,2))>0
            FootPre_State(i,2) = 1;
            i = i+1;
        end
    end
    if FootPreState_back(i,2) == 2
        mBegin = 1;
        mBegin_Serial = i;
    end
    
    if (FootPreState_front(i,2) == 2)&&(mBegin == 1)
        FootPre_State(mBegin_Serial:i,2) = 1;
        mBegin = 0;
        mBegin_Serial = 0;
    end       
end

figure;
plot(FootPre_State(:,1),FootPre_State(:,2),'r');            %足底压力x
hold on;plot(FootPreState_back(:,1),FootPreState_back(:,2),'b.-');
hold on;plot(FootPreState_front(:,1),FootPreState_front(:,2),'b.-');
grid on;
legend('步态','后脚跟','前脚掌');


