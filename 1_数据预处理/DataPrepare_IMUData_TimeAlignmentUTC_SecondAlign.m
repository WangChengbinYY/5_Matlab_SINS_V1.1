function   NewData = DataPrepare_IMUData_TimeAlignmentUTC_SecondAlign(mData,Hz)
%将输入的数据按照 第一个点 和最后一个点 的时间，对中间的数据进行对齐
% 输入的第一列为时间 

%1.判断第一个数是否要保存的数据
DeltaT = 1/Hz;
[L,m] = size(mData);

if mod(mData(1,1),DeltaT)==0 
    %输入的第一个点为 时刻点
    Time = mData(1,1);
    StartTime = Time;
else
    Time = (fix(mData(1,1)/DeltaT)+1)*DeltaT;
    StartTime = Time;
end

%2. 计算两个准确时刻之间，能包含多少个 时刻点
N = 0;  
while Time < mData(L,1)
    N = N+1;
    Time = Time+DeltaT;
end

%3. 该时间段内的数据已经补包，将其按照时间段进行平均
AverageTime = (mData(L,1)-mData(1,1))/(L-1);
TempData = mData;
%将TempData中的时间，除了首尾外，其它时间进行平均
for i = 2:L-1
    TempData(i,1) = TempData(i-1,1)+AverageTime;    
end

%4. 利用新的时间序列，进行插值处理，求取每个时刻点的数据
NewData = zeros(N,m);
for i =1:N
    %第i个数的 标准时刻时间
    NewData(i,1) = StartTime+(i-1)*DeltaT;
    %进行插值计算
    for j = 1:L
        if abs(NewData(i,1)-TempData(j,1))<0.00001
            NewData(i,2:m) = TempData(j,2:m);
            break;
        end
        if TempData(j,1) < NewData(i,1)
            First = j;
            continue;
        else
            Second = j;
            InsertData = Data_Insert_From_Time(TempData(First,:),TempData(Second,:),NewData(i,1));
            NewData(i,:) = InsertData;
            break;
        end    
    end    
end

fuck = 1;
