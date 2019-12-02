function DataPrepare_IMUData_TimeAlignmentUTC(mDataPath,HzIMU,HzMag,mTimeStart,mTimeEnd)
% 利用GPS的UTC(天内秒)进行时间对齐，使用以下规则
%1.对设定的起始和结束时间，进行前后1秒的扩展。
%2.若是没有设定起始和结束时间，则默认搜索，以最后一列的时间状态为开始，默认多1S
%3.数据时间对齐后，进行插值处理！
%采样频率
HzIMU = 200;
HzMag = 100;
%采样间隔
DeltaT_IMU = 1/HzIMU;
DeltaT_Mag = 1/HzMag;

%% 一、 准备工作阶段
% 0.错误排查
if (mTimeStart<0)||(mTimeEnd<0)||((mTimeEnd>0)&&(mTimeStart>=mTimeEnd))
    disp('错误:时间起点和终点设置错误！')
    return;
end

% 1. 读取数据
load(mDataPath);
if ~exist('IMU','var')   %以是否存在IMU判断是否读到数据
    disp('错误:未读取到IMU数据！')
    return;
end
[L,m] = size(IMU);

% 2. 查找数据的有效起始时间和结束时间
% 2.1 搜索有效起始时间
Temp_Start = 0; Temp_End = 0;
TimeState = 0;  Temp_StartIsFind = 0;
for i = 1:L
    %首次GPS时间有效
    if(TimeState == 0)&&(IMU(i,m) == 1 )            
        Temp_Start = IMU(i,1)+2; %开始定位时间会有1s的延迟
        TimeState = 1;
    end
    %判断设定的起始时间是否有效
    if(Temp_Start==IMU(i,1))&&(IMU(i,m) == 1)
        Temp_StartIsFind = 1;
        break;
    end
end
if Temp_StartIsFind == 0
    disp('错误:没有GPS起始时间！')
    return;
end
% 2.2 搜索有效结束时间
for i = L:-1:1
    if IMU(i,m) == 1 
        Temp_End = IMU(i,1);
        break;
    end    
end
if Temp_Start>=Temp_End
    disp('错误:GPS结束时间搜索错误！')
    return;
end

TimeStart = 0; TimeEnd = 0;
% 3. 确定所要截取数据的起始和终点
if (mTimeStart == 0)
    TimeStart = Temp_Start;
else
    if Temp_Start>=mTimeStart
        TimeStart = Temp_Start;
    else
        TimeStart = mTimeStart;
    end
end
%因为最后1s 时间不完整，去掉
if (mTimeEnd == 0)
    TimeEnd = Temp_End-1;
else
    if Temp_End>mTimeEnd
        TimeEnd = mTimeEnd;
    else
        TimeEnd = Temp_End-1;
    end
end

%% 二、 进入数据截取阶段，包含缺数插值





fuck = 1;



