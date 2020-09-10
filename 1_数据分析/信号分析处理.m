%% Ƶ�׷���
% ����ĵ�ά�ź�
y=Magnetic(:,3)-mean(Magnetic(:,3));

N = 2^fix(log2(length(y)));
figure;
plot(y(1:N,1));

fs=100; %����Ƶ��
df = fs/(N-1); %�ֱ���
f=((0:N-1)*df)';  %����ÿ���Ƶ��
Y=fft(y)/N*2;  %��ʵ�ķ�ֵ

figure;
plot(f(1:N/2,1),abs(Y(1:N/2,1)),'r');

Wp = 2/100; Rp = 1;
Ws = 5/100; Rs = 30;
[n,Wp] = cheb1ord(Wp,Ws,Rp,Rs);
[b,a] = cheby1(n,Rp,Wp);
Y_Filter = filter(b,a,y);

figure;plot(y);
hold on; plot(Y_Filter,'g.');
