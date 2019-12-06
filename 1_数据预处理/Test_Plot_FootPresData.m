%% 时间对齐后，绘制足底压力传感器和陀螺 加计数据，对照显示
%  压力传感器顺序'脚跟内侧6','脚跟外侧7','脚掌内侧5','脚掌外侧2'

%原始压力信息的比较，此时压力数值代表的还是电压
figure;
plot(FootPres(:,1),FootPres(:,2),'k');  %足底压力x
hold on; plot(FootPres(:,1),FootPres(:,3),'r');
hold on; plot(FootPres(:,1),FootPres(:,4),'g');
hold on; plot(FootPres(:,1),FootPres(:,5),'b');
xlabel('\it t \rm / s');       
title('脚底压力+陀螺X+加速度计Z');
grid on;
hold on;plot(IMU(:,1),IMU(:,4)*10+990,'-.');  %加计
hold on;plot(IMU(:,1),IMU(:,5)*50+1000,'r-.');  %陀螺
legend('脚跟内侧','脚跟外侧','脚掌内侧','脚掌外侧','加计Z','陀螺X');


%% 对压力原始数据进行 电压——压力转化
% 1. FootPres_Limit 先去掉毛刺   880 对应3.0938V 对应61K欧 对应 24g  去掉原始数据最上面的毛刺和数据回跳
[n,m] = size(FootPres);
FootPres_Limit = FootPres;
for j = 2:5
    for i = 1:n
        if FootPres_Limit(i,j) > 880
            FootPres_Limit(i,j) = 880;
        end
%         if FootPres_Limit(i,j) < 200
%             FootPres_Limit(i,j) = 200;
%         end        
    end
end
% 2. Data_Foot_Press 转化为压力值！
Data_Foot_Press = zeros(n,5);       %对应的压力数据   将电压转化为电阻  再将电阻转化为压力值
Data_Foot_Press(:,1) = FootPres_Limit(:,1);
% 拟合 压力(Y/g)—电阻(X/kR) 曲线
    %Temp_X = [50.00,30.30,20.80,14.20,9.18,6.92,5.85,5.00,4.36,4.02,3.43,3.28,3.16,3.05,2.91,2.78,2.71,2.61,2.53,2.49,2.45,2.42,2.37]';
    %Temp_Y = [300,500,1000,1500,2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000,10500,11000]';
    %用指数曲线拟合 参数如下：  f(x) = a*exp(b*x) + c*exp(d*x)
       a = 2.181e+05;
       b = -1.474;
       c = 5077;
       d = -0.08735;
       R1 = 10;
Temp_Rx = zeros(n,5);       
Temp_Vx = zeros(n,5);         
for i=2:5
    for j=1:n
        %将输出转化为 电压 Vx = Data_Foot .* (3.6/1024.0) 单位 V
        Temp_Vx(j,i) = FootPres_Limit(j,i)*3.6/1024.0;
        %将电压转化为电阻 R1 = 10K  R2 = 压力阻值 = Vx*R1/(3.6-Vx) 单位kR
        Temp_Rx(j,i) = Temp_Vx(j,i)*R1/(3.6 - Temp_Vx(j,i));
        %将电阻转化为压力值
        Data_Foot_Press(j,i) = a*exp(b*Temp_Rx(j,i)) + c*exp(d*Temp_Rx(j,i));
    end
end     
figure;
plot(Data_Foot_Press(:,1),Data_Foot_Press(:,2),'k');  %足底压力x
hold on; plot(Data_Foot_Press(:,1),Data_Foot_Press(:,3),'r');
hold on; plot(Data_Foot_Press(:,1),Data_Foot_Press(:,4),'g');
hold on; plot(Data_Foot_Press(:,1),Data_Foot_Press(:,5),'b');
xlabel('\it t \rm / s');       
title('脚底压力');
grid on;
hold on;plot(IMU(:,1),IMU(:,4)*100,'-.');  %加计
hold on;plot(IMU(:,1),IMU(:,5)*500,'r-.');  %陀螺
legend('脚跟内侧','脚跟外侧','脚掌内侧','脚掌外侧','加计Z','陀螺X');



%% 对压力值进行波形整型 便于好看
% 拟合曲线
x = [500,1000,2000,5000, 10000,15000,20000];
z = [300,400, 450, 500,  600,  800,  1000];
for i = 1:7
    y(1,i) = z(1,i)/x(1,i);
end
% p1 = 1443;  p2 = -6.565;
% % q1 = 1904;  q2 = 6.311;
% f_y = (p1*f_x+p2)/(f_x^2+q1*f_x+q2);
a = 39.16; b = -0.6657; c = -0.0169;
f_y = a*f_x^b+c;

% FootTest 将原始压力数据进行压缩 去掉上面的尖峰！
FootTest = Data_Foot_Press;
for j = 2:5
    for i = 1:n
        if(FootTest(i,j)) > 4500
            f_x = FootTest(i,j) - 4500;
%             f_y = (p1*f_x+p2)/(f_x^2+q1*f_x+q2)*f_x;
            f_y = (a*f_x^b+c)*f_x;
            FootTest(i,j) = 4500 + f_y;
        end
    end
end
figure;
plot(FootTest(:,1),FootTest(:,2),'k');  %足底压力x
hold on; plot(FootTest(:,1),FootTest(:,3),'r');
hold on; plot(FootTest(:,1),FootTest(:,4),'g');
hold on; plot(FootTest(:,1),FootTest(:,5),'b');
xlabel('\it t \rm / s');       
title('脚底压力');
grid on;
hold on;plot(IMU(:,1),IMU(:,4)*100,'-.');  %加计
hold on;plot(IMU(:,1),IMU(:,5)*500,'r-.');  %陀螺
legend('脚跟内侧','脚跟外侧','脚掌内侧','脚掌外侧','加计Z','陀螺X');


%% 步态分析 利用去过毛刺的数据 试验 Data_Foot_Press



