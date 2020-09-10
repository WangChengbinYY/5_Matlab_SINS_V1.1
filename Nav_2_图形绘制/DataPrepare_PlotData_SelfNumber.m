function DataPrepare_PlotData_SelfNumber(mData,mChoose)
% 对内部时间按照序号截取后的数据进行绘制，便于查看图形状态
% 输入：mData 数据；mChoose 数据种类(1=IMU,2=Magnetic,3=FootPress)；

switch mChoose
    case 1
        %绘制IMU数据 时间 加计 陀螺 时间状态
        figure;
        plot(mData(:,2),'k');  %加计x
        hold on; plot(mData(:,3),'r');
        hold on; plot(mData(:,4),'g');
        xlabel('\it t \rm / s');
        ylabel('\it g');
        title('加计输出');
        legend('x','y','z');
        grid on;
        
        figure;
        plot(mData(:,5),'k');  %陀螺x
        hold on; plot(mData(:,6),'r');
        hold on; plot(mData(:,7),'g');
        xlabel('\it t \rm / s');
        ylabel('\it 弧度 \rm / s');
        title('陀螺输出');
        legend('x','y','z');
        grid on;     
    case 2
        %磁强计输出
        figure;
        plot(mData(:,2),'k');  %磁强计x
        hold on; plot(mData(:,3),'r');
        hold on; plot(mData(:,4),'g');
        xlabel('\it t \rm / s');
        ylabel('\it uT');
        title('磁强计输出');
        legend('x','y','z');
        grid on;
    case 3
        %压力传感器输出
        figure;
        plot(mData(:,2),'k');  %足底压力x
        hold on; plot(mData(:,3),'r');
        hold on; plot(mData(:,4),'g');
        hold on; plot(mData(:,5),'b');
        xlabel('\it t \rm / s');       
        title('脚底压力输出');
        legend('脚跟内侧','脚跟外侧','脚掌内侧','脚掌外侧');
        grid on;    
end
