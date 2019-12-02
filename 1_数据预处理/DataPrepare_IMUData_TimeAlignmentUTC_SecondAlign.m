function   NewData = DataPrepare_IMUData_TimeAlignmentUTC_SecondAlign(mData,Hz)
%将输入的数据按照 第一个点 和最后一个点 的时间，对中间的数据进行对齐

%1.判断第一个数是否要保存的数据
DeltaT_Ms = (1/Hz)*1000;
[L,m] = size(mData);
TempData = zeros(L,m-2);
TempData(:,1) = mData(:,1)+mData(:,2)./1000.0;
TempData(:,2:m-2) = mData(:,3:m-1);
DeltaT = 1/Hz;

if mod(mData(1,2),DeltaT_Ms)==0 
    Time = TempData(1,1);
    StartTime = Time;
else
    Time = (fix(TempData(1,1)/DeltaT)+1)*DeltaT;
    StartTime = Time;
end
N = 0;
while Time < TempData(L,1)
    N = N+1;
    Time = Time+DeltaT;
end
%将TempData中的时间，除了首尾外，其它时间进行平均
AverageTime = (TempData(L,1)-TempData(1,1))/(L-1);
for i = 2:L-1
    TempData(i,1) = TempData(i-1,1)+AverageTime;    
end


%声明新的数据
NewData = zeros(N,m-2);
for i =1:N
    NewData(i,1) = StartTime+(i-1)*DeltaT;
    Time = NewData(i,1);
    %进行插值计算
    for j = 1:L
        if TempData(j,1) == Time
            NewData(i,:) = TempData(j,:);
            break;
        end
        if TempData(j,1) < Time
            First = j;
            continue;
        else
            Second = j;
            InsertData = Data_Insert_From_Time(TempData(First,:),TempData(Second,:),Time);
            NewData(i,:) = InsertData;
            break;
        end    
    end    
end

fuck = 1;
