L=length(Data_IMUB_L);
%初步判断
Data_Foot_L_State_Sum = zeros(L,2);
Data_Foot_L_State = zeros(L,2);
Temp_sum = 5;  %使用5个数据进行判断  后面试验
Temp_State = 0;
Temp_GyroX_Max =  
for i = 1:L
    Data_Foot_L_State_Sum(i,1) = Data_Foot_L_Ex(i,1);
    Data_Foot_L_State(i,1) = Data_Foot_L_Ex(i,1);
    if ((Data_Foot_L_Ex(i,2)+Data_Foot_L_Ex(i,4)+Data_Foot_L_Ex(i,5))>10) 
        Data_Foot_L_State_Sum(i,2) = 1;
        if(Temp_State == 0)   %由动态进入到静态
            %判断后面5个数据是否合格
            if(i+Temp_sum-1 <= L)
                %计算后面五个平均值和方差
                if (1)%满足条件
                   Data_Foot_L_State(i,2) = 1;
                   Temp_State = 1;    %此刻才认定进入静态
                end
            end
        end                  
        if(Temp_State == 1)  %本身已经进入静态中
            Data_Foot_L_State(i,2) = 1;
        end
    else        
        Data_Foot_L_State_Sum(i,2) = 0;
        Data_Foot_L_State(i,2) = 0;
        if(Temp_State==1)
            Temp_State = 0;
            %往前追溯 判断静止状态
            
        end        
    end
end

%再次初步判断
%加速度计的矢量和 的 方差 及 均值
Temp_sum = 5;  %使用5个数据进行判断  后面试验
for i = 2:L-1
   %掐头
   if(Data_Foot_L_State_Sum(i-1,2)==0 && Data_Foot_L_State_Sum(i,2)==1)
       if(i+Temp_sum-1 <= L)
           
       end
   end
   %去尾
   if(Data_Foot_L_State_Sum(i,2)==1 && Data_Foot_L_State_Sum(i+1,2)==0)
       
   end   
end

for j = 1:10
   j 
end

