function DataPrepare_PlotData_Original(mData,mChoose)
% �Զ�ȡ�����ݽ��л��ƣ����ڲ鿴ͼ��״̬
% ���룺mData ���ݣ�mChoose ��������(1=IMU,2=Magnetic,3=FootPress,
%   4=UWB,5=GPS,6=HighGPS,)��


switch mChoose
    case 1
        %����IMU���� ʱ�� �Ӽ� ���� ʱ��״̬
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,3),'k');  %�Ӽ�x
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,4),'r');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,5),'g');
        xlabel('\it t \rm / s');
        ylabel('\it g');
        title('�Ӽ����');
        legend('x','y','z');
        grid on;
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,6),'k');  %����x
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,7),'r');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,8),'g');
        xlabel('\it t \rm / s');
        ylabel('\it ���� \rm / s');
        title('�������');
        legend('x','y','z');
        grid on;     
    case 2
        %��ǿ�����
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,3),'k');  %��ǿ��x
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,4),'r');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,5),'g');
        xlabel('\it t \rm / s');
        ylabel('\it uT');
        title('��ǿ�����');
        legend('x','y','z');
        grid on;
    case 3
        %ѹ�����������
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,3),'k');  %���ѹ��x
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,4),'r');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,5),'g');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,6),'b');
        xlabel('\it t \rm / s');       
        title('�ŵ�ѹ�����');
        legend('�Ÿ��ڲ�','�Ÿ����','�����ڲ�','�������');
        grid on;        
    case 4
        %UWB���
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,3),'k');  %UWB
        xlabel('\it t \rm / s');
        ylabel('\it m');        
        title('UWB���');
        legend('UWB');
        grid on;
    case 5
        %GPS���
        %ԭʼ����GPS��γ���� �Ƕȣ�Ҫת��Ϊ����
        G_CONST = CONST_Init();
        Rmh = Earth_get_Rmh(G_CONST,mData(1,2),mData(1,4));
        Rnh = Earth_get_Rnh(G_CONST,mData(1,2),mData(1,4));
        figure;  
        set(gcf,'position',[250,250,1200,480]);
        %ˮƽ�켣
        subplot(1,3,1);
        plot(0, 0, 'rp');     %����ʼλ�û�һ�� �����
        hold on;    
        plot((mData(:,3)-mData(1,3))*Rnh,(mData(:,2)-mData(1,2))*Rmh*cos(mData(1,2)));        
        xlabel('\it ���� \rm / m');
        ylabel('\it ���� \rm / m');
        title('��ʻ·��');
        grid on;
        %�߳�
        subplot(1,3,2);
        plot(mData(:,1),mData(:,4));
        xlabel('\it t \rm / s');
        ylabel('\it m'); 
        title('�߳�');
        grid on;
        %ˮƽ����
        subplot(1,3,3);
        plot(mData(:,1),mData(:,5));
        xlabel('\it t \rm / s');
        ylabel('\it HDop \rm m'); 
        title('��λ����');
        grid on;   
     case 6   
        %�߾���GPS���
        G_CONST = CONST_Init();
        Rmh = Earth_get_Rmh(G_CONST,mData(1,2),mData(1,4));
        Rnh = Earth_get_Rnh(G_CONST,mData(1,2),mData(1,4));
        figure;  
        set(gcf,'position',[50,50,680,680]);
        %ˮƽ�켣
        subplot(2,2,1);
        plot(0, 0, 'rp');     %����ʼλ�û�һ�� �����
        hold on;    
        plot((mData(:,3)-mData(1,3))*Rnh,(mData(:,2)-mData(1,2))*Rmh*cos(mData(1,2)));        
        xlabel('\it ���� \rm / m');
        ylabel('\it ���� \rm / m');
        title('��ʻ·��');
        grid on;
        %�߳�
        subplot(2,2,2);
        plot(mData(:,1),mData(:,4));
        xlabel('\it t \rm / s');
        ylabel('\it m'); 
        title('�߳�');
        grid on;
        %ˮƽ����
        subplot(2,2,3);
        plot(mData(:,1),mData(:,5));
        xlabel('\it t \rm / s');
        ylabel('\it HDop \rm m'); 
        title('��λ����');
        grid on;       
        %��λ��ʽ
        subplot(2,2,4);
        plot(mData(:,1),mData(:,6));
        xlabel('\it t \rm / s');
        ylabel('\it ��λ��ʽ'); 
        title('��λģʽ');
        legend('0��Ч 1���� 4RTK���� 5RTK�̶� 6�ߵ�')
        grid on;          
end
