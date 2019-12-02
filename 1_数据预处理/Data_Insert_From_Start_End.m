function NewData = Data_Insert_From_Start_End(First,Second,Number)
%根据起点和终点，进行 Number个数据插值 线性插值
%第一列为时间  其余为数据 最后一列为时间状态
[L,m] = size(First);
NewData = zeros(Number,m);
%插值的范围是 从第3列 到 倒数第2列
%1.计算时间间隔
DistanceTime = Second(1,1) - First(1,1);
DistanceData = Second(1,2:m-1) - First(1,2:m-1);
for i = 1:Number
    %时间更新
    NewTime = First(1,1)+DistanceTime*i/(Number+1);
    NewData(i,1) = NewTime;
    %数据更新
    NewData(i,2:m-1) = First(1,2:m-1) + DistanceData.*(i/(Number+1));
end
    