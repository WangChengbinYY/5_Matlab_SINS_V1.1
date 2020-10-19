%%-----------------一阶自反馈 滤波特性试验
    %   y(n) = c*y(n-1) + (1-c)*x(n)  0<c<1
    
    % 信号产生
    clear; clc;
    Fs = 200;  %采样频率
    L = Fs*60*10;      %数据长度 10分钟
    t = (0 : L-1).*(1/Fs);
    
    x1 = ones(1,L).*2;      % 常值分量 2
    x2 = 2* sin(2*pi*10*t);     % 10Hz
    x3 = 3* sin(2*pi*50*t);     % 50Hz
    x4 = 4* sin(2*pi*70*t);     % 70Hz
    x = x1 + x2 + x3 + x4;
    
    c = 0.5;        %自回归系数
    b = [1-c];
    a = [1 -c];
    figure;
    freqz(b,a);         % 对传递函数做频谱分析
    
    xFilter = filter(b,a,x);    %利用传递函数进行 滤波
    
    figure;
    plot(x); hold on;
    plot(xFilter,'r'); 