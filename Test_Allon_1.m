%Allan�������
clear;
load('D:\�廪��ʿ\2_��ʿ����_JG\2_ʵ���¼\20200107_��λ�칫����ֹ����_MPU_L\ADI_L.mat');
ADIS_static_data=IMU(60*60*200:end-10*200,6:8)*180/pi*3600;

data_raw=ADIS_static_data;
fs=200;  %ʵ�ʲ�����
f_slow=10;  %���ͺ�Ĳ����ʣ�����ĳ�������10HzΪ������
len_raw=length(data_raw);%�����ܳ�
len_smooth=fs/f_slow;% ƽ��ÿlen_smooth������ƽ��
len=floor(len_raw/len_smooth);%���Ͳ�����ʱ���õ����ݳ���
% 10Hzƽ��
gyrodata = zeros(len,3);
for i = 1:len
    for j = 1:3
        gyrodata(i,j) = mean(data_raw((i-1)*len_smooth+1:i*len_smooth,j));
    end
end
    
    for kaxis=1:3
        gyro_new=gyrodata(:,kaxis);   %****//�޸�����Ĳ���*****//
        %%
        t0=0.1; %������10Hz,��������Ϊ10Hz
        rate=gyro_new; %*****�����ʻ�Ϊdeg/h
        num=length(rate);    %�����ĸ���
        loop=fix(num/5);     %���飬ÿ��m�����ݣ�mȡֵ��1ȡ������������1/5��
        T=(1:loop)*t0;
        w_average = [];
        allan = [];
        for m=1:loop   
            K=fix(num/m);   %ÿ��m�����ݣ��ֳ�K�飬Kȡ������
            for i=1:K       %����ÿ���ƽ��ֵ���������ݷŵ�����w_average����
               w_average(i)=mean(rate(m*(i-1)+1:m*i)); %����Ӧ�ĵ�i���m��Ԫ����ƽ����ŵ�w_average(i)λ��
            end
            S=0;           %�����ۼӵķ�ʽ��Allan�����ʼ��Ϊ0
            for j=1:K-1
               S=S+(w_average(j+1)-w_average(j))^2;
            end
            allan(m)=S/(2*(K-1));%�����õ�Allan����ŵ�Allan����ĵ�m��λ�ã�
        end
        figure;
        T=(1:loop)*t0;
        loglog(T,sqrt(allan),'red');
        grid on;
        xlabel('���ʱ��[s]');ylabel('Allan��׼��[��/h]');title('Allan����');

        Tn=zeros(loop,5);%���ù�ʽ����С������ϼ���
        for i=1:5
            n=i-3;
            Tn(:,i)=T.^n;  %***�������ݲ���p143 ʽ8.3-23
        end
        A=Tn'*Tn;
        B=Tn'*allan';
        An=abs(A\B); %���ù�ʽ���õ���С������ϵĶ���ʽϵ������
        %***p145,��8.3-2***

        quant_Q=sqrt(An(1)/3)*(1000000*pi/180/3600);   %��������Q  Q= ��rad,3600�ǽ�deg/h��Ϊdeg/s
        arw_N=sqrt(An(2))/60;   %�Ƕ��������N
        bias_B=sqrt(An(3))/0.6643;  %��ƫ���ȶ���B
        rrw_K=sqrt(An(4)*3)*60; %�����������K
        rr_R=sqrt(An(5)*2)*3600;  %����б��R

        disp(['quant_Q: ',num2str(quant_Q)]);
        disp(['arw_N: ',num2str(arw_N)]);
        disp(['bias_B: ',num2str(bias_B)]);
        disp(['rrw_K: ',num2str(rrw_K)]);
        disp(['rr_R: ',num2str(rr_R)]);
    end

         
               
                 