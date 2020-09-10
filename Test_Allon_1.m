%Allan方差分析
clear;
load('D:\清华博士\2_博士课题_JG\2_实验记录\20200107_单位办公桌静止放置_MPU_L\ADI_L.mat');
ADIS_static_data=IMU(60*60*200:end-10*200,6:8)*180/pi*3600;

data_raw=ADIS_static_data;
fs=200;  %实际采样率
f_slow=10;  %降低后的采样率，后面的程序是以10Hz为基础的
len_raw=length(data_raw);%数据总长
len_smooth=fs/f_slow;% 平均每len_smooth个数据平滑
len=floor(len_raw/len_smooth);%降低采样率时采用的数据长度
% 10Hz平滑
gyrodata = zeros(len,3);
for i = 1:len
    for j = 1:3
        gyrodata(i,j) = mean(data_raw((i-1)*len_smooth+1:i*len_smooth,j));
    end
end
    
    for kaxis=1:3
        gyro_new=gyrodata(:,kaxis);   %****//修改这里的参数*****//
        %%
        t0=0.1; %采样率10Hz,样本数据为10Hz
        rate=gyro_new; %*****角速率化为deg/h
        num=length(rate);    %样本的个数
        loop=fix(num/5);     %分组，每组m个数据，m取值从1取到样本总数的1/5。
        T=(1:loop)*t0;
        w_average = [];
        allan = [];
        for m=1:loop   
            K=fix(num/m);   %每组m个数据，分成K组，K取整数。
            for i=1:K       %计算每组的平均值，并将数据放到数组w_average当中
               w_average(i)=mean(rate(m*(i-1)+1:m*i)); %将对应的第i组的m个元素求平均后放到w_average(i)位置
            end
            S=0;           %采用累加的方式求Allan方差，初始化为0
            for j=1:K-1
               S=S+(w_average(j+1)-w_average(j))^2;
            end
            allan(m)=S/(2*(K-1));%将所得的Allan方差放到Allan数组的第m个位置，
        end
        figure;
        T=(1:loop)*t0;
        loglog(T,sqrt(allan),'red');
        grid on;
        xlabel('相关时间[s]');ylabel('Allan标准差[°/h]');title('Allan方差');

        Tn=zeros(loop,5);%利用公式作最小二乘拟合计算
        for i=1:5
            n=i-3;
            Tn(:,i)=T.^n;  %***惯性数据测试p143 式8.3-23
        end
        A=Tn'*Tn;
        B=Tn'*allan';
        An=abs(A\B); %利用公式，得到最小二乘拟合的多项式系数矩阵
        %***p145,表8.3-2***

        quant_Q=sqrt(An(1)/3)*(1000000*pi/180/3600);   %量化噪声Q  Q= μrad,3600是将deg/h化为deg/s
        arw_N=sqrt(An(2))/60;   %角度随机游走N
        bias_B=sqrt(An(3))/0.6643;  %零偏不稳定性B
        rrw_K=sqrt(An(4)*3)*60; %速率随机游走K
        rr_R=sqrt(An(5)*2)*3600;  %速率斜坡R

        disp(['quant_Q: ',num2str(quant_Q)]);
        disp(['arw_N: ',num2str(arw_N)]);
        disp(['bias_B: ',num2str(bias_B)]);
        disp(['rrw_K: ',num2str(rrw_K)]);
        disp(['rr_R: ',num2str(rr_R)]);
    end

         
               
                 