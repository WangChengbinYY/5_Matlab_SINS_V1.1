
Vel = zeros(L,2);
for i=1:L
    Vel(i,1) = Data_IMU(i,1);
    Vel(i,2) = sqrt(Data_IMU(i,2)^2+Data_IMU(i,3)^2+Data_IMU(i,4)^2);
end
%%求加速度矢量和
L=length(Data_IMUB_L);
Vel = zeros(L,2);
for i=1:L
    Vel(i,1) = Data_IMUB_L(i,1);
    Vel(i,2) = sqrt(Data_IMUB_L(i,3)^2+Data_IMUB_L(i,4)^2+Data_IMUB_L(i,5)^2);
end

m = fix(L/80);
Vel_mean = zeros(m,7);
for i = 1:m
   Vel_mean(i,1) = mean(Data_IMU_R((i-1)*80+1:i*80,2));
   Vel_mean(i,2) = mean(Data_IMU_R((i-1)*80+1:i*80,3));
   Vel_mean(i,3) = mean(Data_IMU_R((i-1)*80+1:i*80,4));
   Vel_mean(i,4) =sqrt(Vel_mean(i,1)^2+Vel_mean(i,2)^2+Vel_mean(i,3)^2);
   Vel_mean(i,5) = asin(Vel_mean(i,2)/Vel_mean(i,4))*180/pi;
   Vel_mean(i,6) = -atan(Vel_mean(i,1)/Vel_mean(i,3))*180/pi;
   if i > 1
        Vel_mean(i,7) = Vel_mean(i-1,7) + (Vel_mean(i,4)-temp_g)*0.005*80;
        %Vel_mean(i,7) = Vel_mean(i-1,7) + (50*10e-6*temp_g)*0.005*80;
   end
end



m = L;
Vel_mean = zeros(m,6);
   Vel_mean(1,1) = Data_IMU_R(1,2);
   Vel_mean(1,2) = Data_IMU_R(1,3);
   Vel_mean(1,3) = Data_IMU_R(1,4);
   Vel_mean(1,4) =sqrt(Vel_mean(1,1)^2+Vel_mean(1,2)^2+Vel_mean(1,3)^2);
   Vel_mean(1,5) = asin(Vel_mean(1,2)/Vel_mean(1,4))*180/pi;
   Vel_mean(1,6) = -atan(Vel_mean(1,1)/Vel_mean(1,3))*180/pi;
for i = 2:m
   Vel_mean(i,1) = (Vel_mean(i-1,1)*(i-1)+Data_IMU_R(i,2))/i;
   Vel_mean(i,2) = (Vel_mean(i-1,2)*(i-1)+Data_IMU_R(i,3))/i;
   Vel_mean(i,3) = (Vel_mean(i-1,3)*(i-1)+Data_IMU_R(i,4))/i;
   Vel_mean(i,4) =sqrt(Vel_mean(i,1)^2+Vel_mean(i,2)^2+Vel_mean(i,3)^2);
   Vel_mean(i,5) = asin(Vel_mean(i,2)/Vel_mean(i,4))*180/pi;
   Vel_mean(i,6) = -atan(Vel_mean(i,1)/Vel_mean(i,3))*180/pi;
end


t=0:1/256:1;%采样步长
y= 2+3*cos(2*pi*50*t-pi*30/180)+1.5*cos(2*pi*75*t+pi*90/180);
N=length(t); %样点个数
plot(t,y);

N = length(Y_Gyro);
fs=200;%采样频率
df=fs/(N-1);%分辨率
f=(0:N-1)*df;%其中每点的频率
Y=fft(Y_Gyro(1:N))/N*2;%真实的幅值
figure;
plot(f(1:N/2),abs(Y(1:N/2)));

rank([KF.Ft^15*KF.Gt KF.Ft^14*KF.Gt KF.Ft^13*KF.Gt KF.Ft^12*KF.Gt KF.Ft^11*KF.Gt 
    KF.Ft^10*KF.Gt KF.Ft^9*KF.Gt KF.Ft^8*KF.Gt KF.Ft^7*KF.Gt KF.Ft^6*KF.Gt 
    KF.Ft^5*KF.Gt KF.Ft^4*KF.Gt KF.Ft^3*KF.Gt KF.Ft^2*KF.Gt KF.Ft^1*KF.Gt ])

rank([KF.Hk*KF.Ft;KF.Hk*KF.Ft^2;KF.Hk*KF.Ft^3;KF.Hk*KF.Ft^4;KF.Hk*KF.Ft^5;
    KF.Hk*KF.Ft^6;KF.Hk*KF.Ft^7;KF.Hk*KF.Ft^8;KF.Hk*KF.Ft^9;KF.Hk*KF.Ft^10;
    KF.Hk*KF.Ft^11;KF.Hk*KF.Ft^12;KF.Hk*KF.Ft^13;KF.Hk*KF.Ft^14;KF.Hk*KF.Ft^15;])


[Pitch,Roll]=Att_Accel2Att(mean(Data_IMU_R(1:4000,2)),mean(Data_IMU_R(1:4000,3)),mean(Data_IMU_R(1:4000,4)));

Rmh=Earth_get_Rmh(G_Const,G_Start_Pos(1,1),G_Start_Pos(3,1));
Rnh=Earth_get_Rnh(G_Const,G_Start_Pos(1,1),G_Start_Pos(3,1));
w_en_n = Earth_get_w_en_n(G_Start_Pos(1,1),[500;500;500],Rmh,Rnh);
w_ie_n = Earth_get_w_ie_n(G_Const,G_Start_Pos(1,1));
w_in_n = w_ie_n+w_en_n;
Ts=0.005;
Phi = w_in_n*Ts+cross(w_in_n,w_in_n)/12;
Q=Att_Rv2Q(Phi);
C_b_n = Att_Q2DCM(Q);
att = Att_DCM2euler(C_b_n);
att.*180/pi

figure;plot(Data_Foot_R_StateTime(:,2),'r');
hold on;plot(Data_IMU_R(:,5));





figure;plot(Data_IMU_R(:,1),Data_IMU_R(:,4));
hold on;plot(Data_Foot_R_StateTime(:,1),Data_Foot_R_StateTime(:,2)*9.78,'-.r');

%% 绘制GPS轨迹图
figure;
plot(Origion_GPS_L(:,3),Origion_GPS_L(:,4),'r*');
hold on;plot(Origion_GPS_R(:,3),Origion_GPS_R(:,4),'*');

%% 压力传感器判断静态和加速度计矢量和的比较
L=length(Data_IMU_R);
F_vel = zeros(L,2);
for i=1:L
  F_vel(i,1) = Data_IMU_R(i,1);
  F_vel(i,2) = sqrt(Data_IMU_R(i,2)^2+Data_IMU_R(i,3)^2+Data_IMU_R(i,4)^2);  
end
figure;plot(Data_Foot_R_StateTime(:,1),Data_Foot_R_StateTime(:,2)*9.78,'r');
hold on;plot(F_vel(:,1),F_vel(:,2));

%% 绘制压力传感器数据
figure;plot(Data_Foot_L(:,2),'r-');
hold on;plot(Data_Foot_L(:,4));
hold on;plot(Data_Foot_L(:,5),'b.-');

figure;plot(Data_Foot_L_Ex(:,2),'r-');
hold on;plot(Data_Foot_L_Ex(:,4));
hold on;plot(Data_Foot_L_Ex(:,5),'b.-');

%% 测试压力数据 直接利用输出 静止判断
L=length(Data_IMUB_L);
Temp_Data_Foot_State = zeros(L,2);
Temp_Start = 11810;  Temp_End = 44150;
Temp_State = 1; %开始站立阶段
for i = 1:L
    Temp_Data_Foot_State(i,1) = Data_Foot_L(i,1);
    %开头和结尾默认静止站立状态
    if (i<Temp_Start) || (i>Temp_End)
        Temp_Data_Foot_State(i,2) = 1;
    else 
    %中间行走状态判断    
        if (Temp_State == 1) && 
        
        
        
    end
end

%% 测试压力数据 直接压力值 静止判断


L=length(Data_IMUB_L);
Data_Foot_L_State2 = zeros(L,2);
Temp_Start = 11810;  Temp_End = 44150;
for i = 1:L
    Data_Foot_L_State2(i,1) = Data_Foot_L_Ex(i,1);
    if (i<Temp_Start) || (i>Temp_End)
        Data_Foot_L_State2(i,2) = 1;
    else 
        if (Data_Foot_L_Ex(i,2)>5) 
            Data_Foot_L_State2(i,2) = 1;
        else
            Data_Foot_L_State2(i,2) = 0;
        end
    end
end
L=length(Data_IMUB_L);
Data_Foot_L_State4 = zeros(L,2);
Temp_Start = 11810;  Temp_End = 44150;
for i = 1:L
    Data_Foot_L_State4(i,1) = Data_Foot_L_Ex(i,1);
    if (i<Temp_Start) || (i>Temp_End)
        Data_Foot_L_State4(i,2) = 1;
    else 
        if (Data_Foot_L_Ex(i,4)>5) 
            Data_Foot_L_State4(i,2) = 1;
        else
            Data_Foot_L_State4(i,2) = 0;
        end
    end
end
L=length(Data_IMUB_L);
Data_Foot_L_State5 = zeros(L,2);
Temp_Start = 11810;  Temp_End = 44150;
for i = 1:L
    Data_Foot_L_State5(i,1) = Data_Foot_L_Ex(i,1);
    if (i<Temp_Start) || (i>Temp_End)
        Data_Foot_L_State5(i,2) = 1;
    else 
        if (Data_Foot_L_Ex(i,5)>5) 
            Data_Foot_L_State5(i,2) = 1;
        else
            Data_Foot_L_State5(i,2) = 0;
        end
    end
end

L=length(Data_IMUB_L);
Var_Gyro_X = zeros(L,7);
Temp_GyroX_Mean = mean(Data_IMUB_L(1:10000,5));
for i = 1:L-10
    Temp_Gyro_Sum = (Data_IMUB_L(i,5)-Temp_GyroX_Mean)^2;
    for j=1:3
        Temp_Gyro_Sum = Temp_Gyro_Sum+(Data_IMUB_L(i+j,5)-Temp_GyroX_Mean)^2;
    end
    Var_Gyro_X(i,1) = sqrt(Temp_Gyro_Sum)/(j+1);
    
    Temp_Gyro_Sum = (Data_IMUB_L(i,5)-Temp_GyroX_Mean)^2;
    for j=1:4
        Temp_Gyro_Sum = Temp_Gyro_Sum+(Data_IMUB_L(i+j,5)-Temp_GyroX_Mean)^2;
    end
    Var_Gyro_X(i,2) = sqrt(Temp_Gyro_Sum)/(j+1);    
    
    Temp_Gyro_Sum = (Data_IMUB_L(i,5)-Temp_GyroX_Mean)^2;
    for j=1:5
        Temp_Gyro_Sum = Temp_Gyro_Sum+(Data_IMUB_L(i+j,5)-Temp_GyroX_Mean)^2;
    end
    Var_Gyro_X(i,3) = sqrt(Temp_Gyro_Sum)/(j+1);   
   
    Temp_Gyro_Sum = (Data_IMUB_L(i,5)-Temp_GyroX_Mean)^2;
    for j=1:6
        Temp_Gyro_Sum = Temp_Gyro_Sum+(Data_IMUB_L(i+j,5)-Temp_GyroX_Mean)^2;
    end
    Var_Gyro_X(i,4) = sqrt(Temp_Gyro_Sum)/(j+1);  
    
    Temp_Gyro_Sum = (Data_IMUB_L(i,5)-Temp_GyroX_Mean)^2;
    for j=1:7
        Temp_Gyro_Sum = Temp_Gyro_Sum+(Data_IMUB_L(i+j,5)-Temp_GyroX_Mean)^2;
    end
    Var_Gyro_X(i,5) = sqrt(Temp_Gyro_Sum)/(j+1);
    
    Temp_Gyro_Sum = (Data_IMUB_L(i,5)-Temp_GyroX_Mean)^2;
    for j=1:8
        Temp_Gyro_Sum = Temp_Gyro_Sum+(Data_IMUB_L(i+j,5)-Temp_GyroX_Mean)^2;
    end
    Var_Gyro_X(i,6) = sqrt(Temp_Gyro_Sum)/(j+1);  
        
    Temp_Gyro_Sum = (Data_IMUB_L(i,5)-Temp_GyroX_Mean)^2;
    for j=1:9
        Temp_Gyro_Sum = Temp_Gyro_Sum+(Data_IMUB_L(i+j,5)-Temp_GyroX_Mean)^2;
    end
    Var_Gyro_X(i,7) = sqrt(Temp_Gyro_Sum)/(j+1);

end


figure;plot(Data_IMUB_L(:,5));
hold on;plot(Data_Foot_L_State2(:,2).*0.1,'r');
hold on;plot(Data_Foot_L_State4(:,2).*0.1,'b.-');
hold on;plot(Data_Foot_L_State5(:,2).*0.1,'g.-');

figure;plot(Vel(:,2));hold on;plot(Data_IMUB_L(:,5)+10,'-.');
hold on;plot(Temp_Data_Foot_State(:,2).*10,'r*-');
hold on;plot(Var_Gyro_X(:,1)+10,'g.-');

hold on;plot(Data_Foot_L_State2(:,2).*10,'r');
hold on;plot(Data_Foot_L_State4(:,2).*10,'b.-');
hold on;plot(Data_Foot_L_State5(:,2).*10,'g.-');
hold on;plot(Temp_Data_Foot_State(:,2).*10,'r*-');

figure;plot(Vel(:,2));
hold on;plot(Data_IMUB_L(:,5)+10,'r');



L=length(Data_IMUB_L);
Vel = zeros(L,2);
for i=1:L
    Vel(i,1) = Data_IMUB_L(i,1);
    Vel(i,2) = sqrt(Data_IMUB_L(i,3)^2+Data_IMUB_L(i,4)^2+Data_IMUB_L(i,5)^2);
end
L=length(Data_IMUB_L);
Temp_Data_Foot_State = zeros(L,2);
Temp_Start = 11810;  Temp_End = 44150;
for i = 1:L
    Temp_Data_Foot_State(i,1) = Data_Foot_L_Press(i,1);
    if (i<Temp_Start) || (i>Temp_End)
        Temp_Data_Foot_State(i,2) = 1;
    else 
        if ((Data_Foot_L_Press(i,2)+Data_Foot_L_Press(i,4)+Data_Foot_L_Press(i,5))>10) 
            Temp_Data_Foot_State(i,2) = 1;
        else
            Temp_Data_Foot_State(i,2) = 0;
        end
    end
end
figure;
plot(Data_IMUB_L(:,5)+10);
hold on; plot(Vel(:,2),'r');
%hold on; plot(Var_Gyro_X(:,1)+10,'g.-');
hold on;plot(Temp_Data_Foot_State(:,2).*10,'g*-');
hold on; plot(Data_Foot_L_State(:,2).*10,'b.-.');

figure;
plot(Result_AVP(:,9),Result_AVP(:,8),'r*-');

