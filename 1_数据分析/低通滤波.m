%%----------------------低通滤波
    clear; clc;
    Fs = 200;   % 采样频率
    Wp = 1/Fs;         % 通过频率
    Rp = 1;                 % 通过频率 对应的 幅度降低程度 -dB
    Ws = 40/Fs;         % 截止频率
    Rs = 60;                % 截止频率 对应的 幅度降低程度 -dB
    [n,Wp] = cheb1ord(Wp,Ws,Rp,Rs);     % 得到切比雪夫滤波器 的最低阶数 和 对应参数
    [b,a] = cheby1(n,Rp,Wp);                    % 滤波器参数转变为 传递函数参数
    figure;
    freqz(b,a);                               % 对传递函数进行幅频特性分析
    xFilter = filter(b,a,x);

    figure;
    plot(x); hold on;
    plot(xFilter,'r'); 