function CutData = DataPrepare_IMUData_TimeAlignmentUTC_Cut(mData,Hz,mStartT,mEndT)
% 0.该函数调用前，确保 输入的起始和结束时间是在有效范围内的
% 1.针对输入的数据按照起点和终点进行截断
% 2.并按照采样频率进行对齐
% 3.并进行插值处理
% 数据的格式，一般是 秒 毫秒 数据.... 时间状态

%% 0. 首先对输入的 起始时间和结束时间，进行GPS授时有效性的判断
Second_StartSerial = 0; Second_NextStartSerial = 0;
Second_StartTime = 0;   Second_NextStartTime = 0;
% 起点时间的有效性判断
[Second_StartTime,Second_StartSerial] = DataPrepare_IMUData_FindSecondSerial(mData,mStartT);
if Second_StartSerial == 0
    %查找失败
    fprintf('警告:GPS有效范围数据切割，发现无效时间设定！秒 %d!\n',mStartT);
    return;
end 
if Second_StartTime ~= mStartT
    fprintf('警告:GPS有效时间起点更改为 %d!\n',Second_StartTime);
    mStartT = Second_StartTime;
end 
% 终点时间的有效性判断
for s=mEndT:-1:mStartT
    [Second_NextStartTime,Second_NextStartSerial] = DataPrepare_IMUData_FindSecondSerial(mData,s);
    if Second_NextStartSerial ~= 0
        break;
    end
end
if Second_NextStartSerial == 0
    %查找失败
    fprintf('警告:GPS有效范围数据切割，发现无效时间设定！秒 %d!\n',mEndT);
    return;
end     
if Second_NextStartTime ~= mEndT
    fprintf('警告:GPS有效时间起点更改为 %d!\n',Second_NextStartTime);
    mEndT = Second_NextStartTime-1;
end 
% 时间范围的有效性判断
if mEndT <= mStartT
    fprintf('警告:GPS时间切割范围无效！%d %d\n',mStartT,mEndT);
    return;  
end

%% 一、在有效的授时起始和终点范围之间，进行数据处理
[L,m] = size(mData);
DeltaT = fix((1/Hz)*1000);  %ms对应数据第二列
CutData = zeros((mEndT-mStartT+1)*Hz,m-1);
CutData_SavedNum = 0;
% 从修订后的起始时间，开始，搜索每一段有GPS授时的数据
Second_NextStartTime = Second_StartTime; 
Second_NextStartSerial = Second_StartSerial;
Second_StartTime = 0;       Second_StartSerial = 0;
s = mStartT;

while s <= mEndT
    %1.找到授时的起始点
    Second_StartTime = Second_NextStartTime;
    Second_StartSerial = Second_NextStartSerial;
    %2.找到下一个授时的起始点    
    [Second_NextStartTime,Second_NextStartSerial]=DataPrepare_IMUData_FindSecondSerial(mData,Second_StartTime+1);
    s = Second_NextStartTime;
    
    if Second_NextStartSerial == 0
        break;
    end
    
    %3.获取这段前后有授时的时间 >= 1s 
    %   第一个 和 最后一个(授时点) 时间是准确的，中间 是内部时钟顺序累加，没有跳点，有可能有丢数，需要插值
    Temp_Data = zeros(Second_NextStartSerial-Second_StartSerial+1,m-1);   %这里转换时间
    Temp_Data(:,1) = mData(Second_StartSerial:Second_NextStartSerial,1)+mData(Second_StartSerial:Second_NextStartSerial,2)./1000.0;
    Temp_Data(:,2:m-1) = mData(Second_StartSerial:Second_NextStartSerial,3:m);
    Last_Data = Temp_Data(Second_NextStartSerial-Second_StartSerial+1,:);
    %4.针对这段数据，进行丢包检测,并插值补上丢包数据(只有第一个数是授时点，最后一个授时点不要输入)
    Temp_Data = DataPrepare_IMUData_LoseCheck_And_Insert(Temp_Data(1:Second_NextStartSerial-Second_StartSerial,:),Hz);
    %5.补数后，加上当前段的最后一点(有效时间)，进行时间对齐的插值
    %(在两个有效时间之间，进行时间对齐，包含第一个点，但不包含最后一个点，以防重复)
    Temp_Data=[Temp_Data;Last_Data];
    Temp_Data = DataPrepare_IMUData_TimeAlignmentUTC_SecondAlign(Temp_Data,Hz);
    %6.处理后的数据，进行存储
    [L1,m1] = size(Temp_Data);
    CutData(CutData_SavedNum+1:CutData_SavedNum+L1,:) = Temp_Data;    
    CutData_SavedNum = CutData_SavedNum+L1;
end    



fuck=1;

