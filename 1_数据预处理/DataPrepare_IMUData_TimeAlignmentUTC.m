function DataPrepare_IMUData_TimeAlignmentUTC(mDataPath,HzIMU,HzMag,mTimeStart,mTimeEnd)
% 利用GPS的UTC(天内秒)进行时间对齐，使用以下规则
%1.对设定的起始和结束时间，进行前后1秒的扩展。
%2.若是没有设定起始和结束时间，则默认搜索，以最后一列的时间状态为开始，默认多1S
%3.数据时间对齐后，进行插值处理！
%采样频率

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

%获取了真实有效的GPS时间，
    fprintf('获取真实有效的GPS截取时间为：%d  %d \n',TimeStart,TimeEnd);

%% 二、 进入数据截取阶段，包含缺数插值
%先全部截取完，然后绘制，并考虑对GPS 和高精度GPS的数据进行截取！
tIndex = strfind(mDataPath,'.');
NewPath = mDataPath(1:tIndex-1);
NewPath = [NewPath,sprintf('_%d_%d',TimeStart,TimeEnd),'.mat'];
%1.先截取IMU 并存储
IMU = DataPrepare_IMUData_TimeAlignmentUTC_Cut(IMU,200,TimeStart,TimeEnd);
if isempty(IMU) == 1
    disp('1.**** IMU数据时间截取失败！****')
else
    disp('1.IMU数据时间截取完成！')
    save(NewPath,'IMU');                        %存储截取后的新数据
    DataPrepare_PlotData_TimeCuted(IMU,1);       %绘制
end    
%2. 磁强计数据
if exist('Magnetic','var')   
    Magnetic = DataPrepare_IMUData_TimeAlignmentUTC_Cut(Magnetic,100,TimeStart,TimeEnd);
    if isempty(Magnetic) == 1
        disp('2.**** Magnetic数据时间截取失败！****')
    else
        disp('2.Magnetic数据时间截取完成！')
        save(NewPath,'Magnetic','-append');                  %存储
        DataPrepare_PlotData_TimeCuted(Magnetic,2);       %绘制
    end
end   
%3. 足底压力数据    
if exist('FootPres','var')   
    FootPres = DataPrepare_IMUData_TimeAlignmentUTC_Cut(FootPres,200,TimeStart,TimeEnd);
    if isempty(FootPres) == 1
        disp('3.**** FootPres数据时间截取失败！****')
    else
        disp('3.FootPres数据时间截取完成！')
        save(NewPath,'FootPres','-append');                  %存储
        DataPrepare_PlotData_TimeCuted(FootPres,3);          %绘制
    end
end    
%4. UWB数据
 if exist('UWB','var')   
    UWB = DataPrepare_IMUData_TimeAlignmentUTC_Cut(UWB,200,TimeStart,TimeEnd);
    if isempty(UWB) == 1
        disp('4.**** UWB数据时间截取失败！****')
    else
        disp('4.UWB数据时间截取完成！')
        save(NewPath,'UWB','-append');                  %存储
        DataPrepare_PlotData_TimeCuted(UWB,4);          %绘制
    end
end 
%5. 模块内GPS数据
if exist('GPS','var')       
    [L,m] = size(GPS);
    First = 0; Second = L;
    for i=1:L
       if TimeStart <= GPS(i,1)
           First = i;
           break;
       end
    end
    for i=1:L
       if TimeEnd <= GPS(i,1)
           Second = i;
           break;
       end
    end       
    GPS = GPS(First:Second,:);
    disp('5.GPS数据时间截取完成！')
    save(NewPath,'GPS','-append');                  %存储
    DataPrepare_PlotData_TimeCuted(GPS,5);          %绘制
end
%6. 外部高精度GPS数据
if exist('HighGPS','var')       
    [L,m] = size(HighGPS);
    First = 0; Second = L;
    for i=1:L
       if TimeStart <= HighGPS(i,1)
           First = i;
           break;
       end
    end
    for i=1:L
       if TimeEnd <= HighGPS(i,1)
           Second = i;
           break;
       end
    end       
    HighGPS = HighGPS(First:Second,:);
    disp('6.HighGPS数据时间截取完成！')
    save(NewPath,'HighGPS','-append');                  %存储
    DataPrepare_PlotData_TimeCuted(HighGPS,6);          %绘制
end    
    
    
  


