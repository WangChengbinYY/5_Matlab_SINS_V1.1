%%----------------------频谱分析
    % 信号产生
    clear; clc;
    y=x;
    y=xFilter;
    Fs = 200;   % 采样频率
    L = length(y);
    Y=fft(y);       %傅里叶变换
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;         
    figure;
    plot(f,P1); 
    title('Single-Sided Amplitude Spectrum of y(t)');
    xlabel('f (Hz)');
    ylabel('|P1(f)|');

