function DataPrepare_PlotData_Original(mData,mChoose)
% 对读取的数据进行绘制，便于查看图形状态
% 输入：mData 数据；mChoose 数据种类(1=IMU,2=Magnetic,3=FootPress,
%   4=UWB,5=GPS,6=HighGPS,)；


switch mChoose
    case 1
        %绘制IMU数据 时间 加计 陀螺 时间状态
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,3),'k');  %加计x
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,4),'r');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,5),'g');
        xlabel('\it t \rm / s');
        ylabel('\it g');
        title('加计输出');
        legend('x','y','z');
        grid on;
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,6),'k');  %陀螺x
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,7),'r');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,8),'g');
        xlabel('\it t \rm / s');
        ylabel('\it 弧度 \rm / s');
        title('陀螺输出');
        legend('x','y','z');
        grid on;     
    case 2
        %磁强计输出
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,3),'k');  %磁强计x
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,4),'r');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,5),'g');
        xlabel('\it t \rm / s');
        ylabel('\it uT');
        title('磁强计输出');
        legend('x','y','z');
        grid on;
    case 3
        %压力传感器输出
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,3),'k');  %足底压力x
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,4),'r');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,5),'g');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,6),'b');
        xlabel('\it t \rm / s');       
        title('脚底压力输出');
        legend('脚跟内侧','脚跟外侧','脚掌内侧','脚掌外侧');
        grid on;        
    case 4
        %UWB输出
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,3),'k');  %UWB
        xlabel('\it t \rm / s');
        ylabel('\it m');        
        title('UWB测距');
        legend('UWB');
        grid on;
    case 5
        %GPS输出
        %原始数据GPS经纬度是 角度，要转换为弧度
        G_CONST = CONST_Init();
        Rmh = Earth_get_Rmh(G_CONST,mData(1,2),mData(1,4));
        Rnh = Earth_get_Rnh(G_CONST,mData(1,2),mData(1,4));
        figure;  
        set(gcf,'position',[250,250,1200,480]);
        %水平轨迹
        subplot(1,3,1);
        plot(0, 0, 'rp');     %在起始位置画一个 五角星
        hold on;    
        plot((mData(:,3)-mData(1,3))*Rnh,(mData(:,2)-mData(1,2))*Rmh*cos(mData(1,2)));        
        xlabel('\it 东向 \rm / m');
        ylabel('\it 北向 \rm / m');
        title('行驶路线');
        grid on;
        %高程
        subplot(1,3,2);
        plot(mData(:,1),mData(:,4));
        xlabel('\it t \rm / s');
        ylabel('\it m'); 
        title('高程');
        grid on;
        %水平精度
        subplot(1,3,3);
        plot(mData(:,1),mData(:,5));
        xlabel('\it t \rm / s');
        ylabel('\it HDop \rm m'); 
        title('定位精度');
        grid on;   
     case 6   
        %高精度GPS输出
        G_CONST = CONST_Init();
        Rmh = Earth_get_Rmh(G_CONST,mData(1,2),mData(1,4));
        Rnh = Earth_get_Rnh(G_CONST,mData(1,2),mData(1,4));
        figure;  
        set(gcf,'position',[50,50,680,680]);
        %水平轨迹
        subplot(2,2,1);
        plot(0, 0, 'rp');     %在起始位置画一个 五角星
        hold on;    
        plot((mData(:,3)-mData(1,3))*Rnh,(mData(:,2)-mData(1,2))*Rmh*cos(mData(1,2)));        
        xlabel('\it 东向 \rm / m');
        ylabel('\it 北向 \rm / m');
        title('行驶路线');
        grid on;
        %高程
        subplot(2,2,2);
        plot(mData(:,1),mData(:,4));
        xlabel('\it t \rm / s');
        ylabel('\it m'); 
        title('高程');
        grid on;
        %水平精度
        subplot(2,2,3);
        plot(mData(:,1),mData(:,5));
        xlabel('\it t \rm / s');
        ylabel('\it HDop \rm m'); 
        title('定位精度');
        grid on;       
        %定位方式
        subplot(2,2,4);
        plot(mData(:,1),mData(:,6));
        xlabel('\it t \rm / s');
        ylabel('\it 定位方式'); 
        title('定位模式');
        legend('0无效 1单点 4RTK浮点 5RTK固定 6惯导')
        grid on;          
end
