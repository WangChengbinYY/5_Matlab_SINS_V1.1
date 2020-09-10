function DataPrepare_PlotData_SelfNumber(mData,mChoose)
% ���ڲ�ʱ�䰴����Ž�ȡ������ݽ��л��ƣ����ڲ鿴ͼ��״̬
% ���룺mData ���ݣ�mChoose ��������(1=IMU,2=Magnetic,3=FootPress)��

switch mChoose
    case 1
        %����IMU���� ʱ�� �Ӽ� ���� ʱ��״̬
        figure;
        plot(mData(:,2),'k');  %�Ӽ�x
        hold on; plot(mData(:,3),'r');
        hold on; plot(mData(:,4),'g');
        xlabel('\it t \rm / s');
        ylabel('\it g');
        title('�Ӽ����');
        legend('x','y','z');
        grid on;
        
        figure;
        plot(mData(:,5),'k');  %����x
        hold on; plot(mData(:,6),'r');
        hold on; plot(mData(:,7),'g');
        xlabel('\it t \rm / s');
        ylabel('\it ���� \rm / s');
        title('�������');
        legend('x','y','z');
        grid on;     
    case 2
        %��ǿ�����
        figure;
        plot(mData(:,2),'k');  %��ǿ��x
        hold on; plot(mData(:,3),'r');
        hold on; plot(mData(:,4),'g');
        xlabel('\it t \rm / s');
        ylabel('\it uT');
        title('��ǿ�����');
        legend('x','y','z');
        grid on;
    case 3
        %ѹ�����������
        figure;
        plot(mData(:,2),'k');  %���ѹ��x
        hold on; plot(mData(:,3),'r');
        hold on; plot(mData(:,4),'g');
        hold on; plot(mData(:,5),'b');
        xlabel('\it t \rm / s');       
        title('�ŵ�ѹ�����');
        legend('�Ÿ��ڲ�','�Ÿ����','�����ڲ�','�������');
        grid on;    
end
