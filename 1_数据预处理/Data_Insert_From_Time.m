function InsertData = Data_Insert_From_Time(First,Second,Time)
%第一列是时间，后面是数据 没有时间标志位 
[L,m] = size(First);
InsertData = zeros(1,m);
InsertData(1,1) = Time;
InsertData(1,2:m) = (Second(1,2:m)-First(1,2:m)).*((Time-First(1,1))/(Second(1,1)-First(1,1)))+First(1,2:m);
