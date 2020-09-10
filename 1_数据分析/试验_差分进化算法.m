%% 差分进化算法试验

%% 绘制一个 三维的 彩色图形，求取其最大值
    % 自然常数 e  exp(1)
    % x [-4 4]; y [-4 4];
    % z = -20*exp(-0.2*sqrt(x^2+y^2/2))-exp(cos((2*pi*x)+cos(2*pi*y))/2)+exp(1);
    
% 绘制图形
    [x,y] = meshgrid(-5:0.1:5);
    L = length(x);
    z = zeros(L,L);
    for i = 1:L
        for j = 1:L
        z(j,i) = 20*exp(-0.2*sqrt(x(j,i)^2+y(j,i)^2/2))+exp(cos((2*pi*x(j,i))+cos(2*pi*y(j,i)))/2)+exp(1);
        end
    end
    
    figure; plot3(x,y,z);
    figure; mesh(x,y,z);
    figure; surf(x,y,z);
    
%% 利用 差分进化 算法求取上面的极大值 上面的函数有多个波峰
clear all; clc;
% 参数设定
size = 50;  %群体个数
Code1 = 2;  %所求的变量个数

MinX(1) = -5; MaxX(1) = 5;  %第1个变量的范围
MinX(2) = -5; MaxX(2) = 5;  %第2个变量的范围

G = 200;    %迭代次数
F = 1.2;    %变异因子[0 2]
CR = 0.8;   %交叉因子 [0.6 0.9]

% 初始化种群
P = zeros(size,Code1);
for i = 1:1:Code1
    P(:,i) = MinX(i) + (MaxX(i)-MinX(i))*rand(size,1);
end

% 初始化 全局最优个体  此处默认取第一个个体
Best = P(1,:);

% 计算当前群体中的 每个个体的适应度函数值 将最优的那个赋值给 Best
for i = 2:size
   if( fun_DE(P(i,1),P(i,2)) > fun_DE(Best(1),Best(2)) )
       Best = P(i,:);
   end       
end

% 开始进入循环处理，满足精度要求或者达到迭代次数 则停止
Best_f = zeros(1,G);
Best_f(1) = fun_DE(Best(1),Best(2));
for Kg = 1:1:G
   time(Kg) = Kg;   
   
   v = zeros(size,Code1);   %获取的变异种群
   u = zeros(size,Code1);   %获取到的试验种群
   for i = 1:size
       % 1 开始变异
       r1 = 1; r2 = 1; r3 = 1; 
       % 1.1 随机寻找另外3个用于变异的个体 r1 r2 r3不能等于i,并且之间不能相等
       %    当前这个方法比较笨，后面可以利用排除i后随机抽取3个数字的方法进行改进
       while(r1==i||r2==i||r3==i||r1==r2||r1==r3||r2==r3)
           r1 = ceil(size*rand(1));  % 向上取整
           r2 = ceil(size*rand(1)); 
           r3 = ceil(size*rand(1)); 
       end       
       % 1.2 开始变异
       v(i,:) = P(r1,:) + F*(P(r2,:)-P(r3,:));  %基本变异操作
       % h(i,:) = Best + F*(P(r2,:)-P(r3,:));   %改进的 最优变异操作
       
       % 1.3 检查变异 是否越界 
       for j = 1:Code1
           if(v(i,j)<MinX(j))
               v(i,j)=MinX(j);
           elseif(v(i,j)>MaxX(j))
               v(i,j)=MaxX(j);
           end
       end
       
       % 2 交叉
       for j = 1:Code1
           Temp = rand(1);  %获取一个[0 1]范围的随机概率
           if (Temp < CR)
               u(i,j) = v(i,j);  %随机概率小于CR，则交叉
           else
               u(i,j) = P(i,j);  %随机概率大于CR，则不交叉，保留父代个体对应的元素
           end   
       end       
       
       % 3 选择
       %  3.1 获取新种群中对应的个体
       if(fun_DE(u(i,1),u(i,2))>fun_DE(P(i,1),P(i,2)))
           % 利用适应度函数进行判断(极值函数)，是否保留变异交叉后的新个体
           P(i,:) = u(i,:);
       end
       % 3.2 保留最优个体
       if( fun_DE(P(i,1),P(i,2)) > fun_DE(Best(1),Best(2)))
           Best = P(i,:);
       end   
   end
   % 满足精度则停止迭代
   if(fun_DE(Best(1),Best(2)) - Best_f(Kg) < 0.001)
       break;
   end   
   Best_f(Kg) = fun_DE(Best(1),Best(2)); 
end
fprintf('最优结果为 %f,%f\n',Best(1),Best(2));
fprintf('最大函数值为 %f\n',Best_f(Kg));
figure; plot(time,Best_f(time),'*-');












