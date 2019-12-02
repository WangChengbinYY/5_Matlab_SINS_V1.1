

function NewData = Data_Insert_From_Start_End(First,Second,Number)
%根据起点和终点，进行 Number个数据插值
[L,m] = size(First);
NewData = zeros(Number,m);
%插值的范围是 从第3列 到 倒数第2列
%1.计算时间间隔
DistanceTime = Second(1,1)+Second(1,2)/1000.0 - First(1,1)-First(1,2)/1000.0;
DistanceData = Second(1,3:m-1) - First(1,3:m-1);
for i = 1:Number
    %时间更新
    NewTime = (First(1,1)+First(1,2)/1000.0)+DistanceTime*i/(Number+1);
    NewData(i,1) = fix(NewTime);
    NewData(i,2) = round((NewTime-NewData(i,1))*1000);
    %数据更新
    NewData(i,3:m-1) = First(1,3:m-1) + DistanceData.*(i/(Number+1));
end
    