%% IMU ���ݻ���
clear; clc;
load('D:\�廪��ʿ\2_��ʿ����_JG\2_ʵ���¼\20200205_�칫¥��¥��ֱ������\��1��_��ֱ��\MPU_L_20000_35000.mat')

% �Ӽ����ݻ���
figure;
    set(gcf,'position',[250,250,1200,900]);
    subplot(3,1,1);
    plot(IMU(600:3500,1),IMU(600:3500,2),'b');
    set(gca,'XLim',[IMU(600,1),IMU(3500,1)]);
    set(gca,'YLim',[-5,7]);
    xlabel('sample time(s)','FontName','Times New Roman','FontSize',14); 
    ylabel('X-axis acc(g)','FontName','Times New Roman','FontSize',14);
    title('(a)the data of X-axis accelerometer when walking','FontName','Times New Roman','FontSize',14);
    
    subplot(3,1,2);
    plot(IMU(600:3500,1),IMU(600:3500,3),'b');
    set(gca,'XLim',[IMU(600,1),IMU(3500,1)]);
    set(gca,'YLim',[-5,7]);
    xlabel('sample time(s)','FontName','Times New Roman','FontSize',14); 
    ylabel('Y-axis acc(g)','FontName','Times New Roman','FontSize',14);
    title('(b)the data of Y-axis accelerometer when walking','FontName','Times New Roman','FontSize',14); 
    
    subplot(3,1,3);
    plot(IMU(600:3500,1),IMU(600:3500,4),'b');
    set(gca,'XLim',[IMU(600,1),IMU(3500,1)]);
    set(gca,'YLim',[-5,7]);
    xlabel('sample time(s)','FontName','Times New Roman','FontSize',14); 
    ylabel('Z-axis acc(g)','FontName','Times New Roman','FontSize',14);
    title('(c)the data of Z-axis accelerometer when walking','FontName','Times New Roman','FontSize',14);    
    
% �������ݻ���
figure;
    set(gcf,'position',[250,250,1200,900]);
    subplot(3,1,1);
    plot(IMU(600:3500,1),IMU(600:3500,5).*(180/pi),'b');
    set(gca,'XLim',[IMU(600,1),IMU(3500,1)]);
    set(gca,'YLim',[-800,400]);
    xlabel('sample time(s)','FontName','Times New Roman','FontSize',14); 
    ylabel('X-axis gyro(deg/s)','FontName','Times New Roman','FontSize',14);
    title('(a)the data of X-axis gyro when walking','FontName','Times New Roman','FontSize',14);
    
    subplot(3,1,2);
    plot(IMU(600:3500,1),IMU(600:3500,6).*(180/pi),'b');
    set(gca,'XLim',[IMU(600,1),IMU(3500,1)]);
    set(gca,'YLim',[-800,400]);
    xlabel('sample time(s)','FontName','Times New Roman','FontSize',14); 
    ylabel('Y-axis gyro(deg/s)','FontName','Times New Roman','FontSize',14);
    title('(b)the data of Y-axis gyro when walking','FontName','Times New Roman','FontSize',14); 
    
    subplot(3,1,3);
    plot(IMU(600:3500,1),IMU(600:3500,7).*(180/pi),'b');
    set(gca,'XLim',[IMU(600,1),IMU(3500,1)]);
    set(gca,'YLim',[-800,400]);
    xlabel('sample time(s)','FontName','Times New Roman','FontSize',14); 
    ylabel('Z-axis gyro(deg/s)','FontName','Times New Roman','FontSize',14);
    title('(c)the data of Z-axis gyro when walking','FontName','Times New Roman','FontSize',14);        
    
%% ��ֹ״̬���ݺϲ�����
figure;    
    L = length(StaticRecord);
    set(gcf,'position',[250,250,1200,900]);   
    subplot(2,1,1);
    Num = 1;
    for i = 1:L
        hold on;
        plot((Num:Num+StaticRecord(i,2)-StaticRecord(i,1)),IMU(StaticRecord(i,1):StaticRecord(i,2),3));
        Num = Num + StaticRecord(i,2)-StaticRecord(i,1);
    end
    set(gca,'XLim',[600,2000]);
    xlabel('gathered serial number','FontName','Times New Roman','FontSize',14); 
    ylabel('Y-axis acc(g)','FontName','Times New Roman','FontSize',14);
    title('(a)the gathered data of Y-axis accelerometer when stationary','FontName','Times New Roman','FontSize',14);
    
    subplot(2,1,2);
    Num = 1;
    for i = 1:L
        hold on;
        plot((Num:Num+StaticRecord(i,2)-StaticRecord(i,1)),IMU(StaticRecord(i,1):StaticRecord(i,2),5));
        Num = Num + StaticRecord(i,2)-StaticRecord(i,1);
    end
    set(gca,'XLim',[600,2000]);
    xlabel('gathered serial number','FontName','Times New Roman','FontSize',14); 
    ylabel('X-axis gyro(deg/s)','FontName','Times New Roman','FontSize',14);
    title('(a)the gathered data of X-axis gyro when stationary','FontName','Times New Roman','FontSize',14);  
    
    
%% �ŵ�ѹ����Ϣ����   
[n,m] = size(FootPres);
FootPres_Limit = FootPres;
for j = 2:5
    for i = 1:n
        if FootPres_Limit(i,j) > 900
            FootPres_Limit(i,j) = 900;
        end   
    end
end
% ��ת  ��������ѹ��
for j = 2:5
    for i = 1:n
        FootPres_Limit(i,j) = (-1)*FootPres_Limit(i,j)+900;   
    end
end

figure;
set(gcf,'position',[250,250,1200,500]); 
hold on; plot(FootPres_Limit(:,1),FootPres_Limit(:,3).*2,'r');  
hold on; plot(FootPres_Limit(:,1),FootPres_Limit(:,5).*2,'b');
hold on;plot(IMU(:,1),IMU(:,4)*100,'g-');  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5)*50,'g-.');  %����
set(gca,'XLim',[114,117.5]);
set(gca,'YLim',[-600,1600]);
legend('Num5','Num8','Y-acc*10','X-gyro*50');
xlabel('sample time(s)','FontName','Times New Roman','FontSize',14); 
title('the planter pressure on two points','FontName','Times New Roman','FontSize',14); 








