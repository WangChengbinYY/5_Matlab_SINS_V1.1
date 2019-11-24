figure;
    plot(Result_AVP(:,1),Result_AVP(:,4).*(180/pi));
    hold on
    plot(Data_Foot_L_State(:,1),Data_Foot_L_State(:,2)*(-90),'r');
    
    figure;
    plot(Data_IMUB_L(:,1),Data_IMUB_L(:,5)+1);
    hold on;
    plot(Data_IMUB_L(:,1),Data_IMUB_L(:,7)+1,'y');
    hold on;
    plot(Temp_GyroX_Var(:,1),Temp_GyroX_Var(:,2)+1,'g-');
    hold on;
    plot(Temp_GyroXH_Var(:,1),Temp_GyroXH_Var(:,2)+1,'g-.');
    hold on
    plot(Data_Foot_State(:,1),Data_Foot_State(:,2),'r');
    
Temp_GyroX_Mean = mean(Data_IMUB(1:14000,7));        %X陀螺静止输出均值
fprintf('               X轴陀螺静止输出均值为：%f度/h\n',Temp_GyroX_Mean*180/pi*3600);


figure;
plot(Result_AVP1(:,1),Result_AVP1(:,2).*(180/pi),'r-*');
hold on;
plot(Result_AVP3(:,1),Result_AVP3(:,2).*(180/pi),'g-*');
hold on;
plot(Result_AVP2(:,1),Result_AVP2(:,2).*(180/pi),'-*');
hold on;
plot(Result_AVP3(:,1),Result_AVP3(:,2).*(180/pi),'g-*');
hold on;
plot(Result_AVP4(:,1),Result_AVP4(:,2).*(180/pi),'y-*');




    fprintf('  (2.1)陀螺X轴方差计算\n');    
    Temp_GyroXH_Num = 5;         %选用几个周期陀螺数据进行判断
    Temp_GyroXH_VarMax = 0.1;    %利用陀螺方法判断的 阈值  
    fprintf('    选用的参数：计算周期 %d  X轴陀螺方差阈值：%f\n',Temp_GyroXH_Num,Temp_GyroXH_VarMax);      
    Temp_GyroXH_Mean = mean(Data_IMUB(10*200:50*200,5));        %X陀螺静止输出均值 从第10秒开始到50秒结束
    fprintf('               X轴陀螺静止输出均值为：%f度/h\n',Temp_GyroXH_Mean*180/pi*3600);     
    Temp_GyroXH_Var = zeros(n,2);
    for i = 1:n-Temp_GyroXH_Num
         Temp_GyroXH_Var(i,1) = Data_IMUB(i,1);
            Temp_Var = 0;
            for j=i:i+Temp_GyroXH_Num-1
                Temp_Var = Temp_Var + (Data_IMUB(j,5)-Temp_GyroXH_Mean)^2;
            end
            Temp_GyroXH_Var(i,2) = sqrt(Temp_Var)/Temp_GyroXH_Num;
    end


figure;
% plot(Result_AVP0_10(:,1),Result_AVP0_10(:,2).*(180/pi),'r');
% hold on;
% plot(Result_AVP0_20(:,1),Result_AVP0_20(:,2).*(180/pi),'r-.');
% hold on;
plot(Result_AVP0_30(:,1),Result_AVP0_30(:,2).*(180/pi),'r--');
hold on;
plot(Result_AVP1(:,1),Result_AVP1(:,2).*(180/pi),'g');
hold on;
plot(Result_AVP3(:,1),Result_AVP3(:,2).*(180/pi));
hold on;
plot(Result_AVP4(:,1),Result_AVP4(:,2).*(180/pi),'black');
hold on;
plot(Data_IMUB_L(:,1),Data_IMUB_L(:,3)*5-5,'blue');