
%% ��ѹ��ֵ���в������� ���ںÿ�
% �������
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

% FootTest ��ԭʼѹ�����ݽ���ѹ�� ȥ������ļ�壡
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
plot(FootTest(:,1),FootTest(:,2),'k');  %���ѹ��x
hold on; plot(FootTest(:,1),FootTest(:,3),'r');
hold on; plot(FootTest(:,1),FootTest(:,4),'g');
hold on; plot(FootTest(:,1),FootTest(:,5),'b');
xlabel('\it t \rm / s');       
title('�ŵ�ѹ��');
grid on;
hold on;plot(IMU(:,1),IMU(:,4)*100,'-.');  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5)*500,'r-.');  %����
legend('�Ÿ��ڲ�','�Ÿ����','�����ڲ�','�������','�Ӽ�Z','����X');