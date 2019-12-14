function Plot_AVP(AVP0,AVP1)
% 绘制输入的姿态信息
% 如果输入两组数据，第一组为参照数据，采用红色
% 输入参数的格式为(按列)  
%       时间(单位ms) 姿态(俯仰、横滚、航向，单位弧度) 速度 位置(纬度、经度，单位弧度，高程 单位米)
%


if nargin == 1
%% 绘制姿态信息    
    figure;
    plot(AVP0(:,1),AVP0(:,2).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it \theta \rm / \circ');
    title('姿态-俯仰');
    
    figure;
    plot(AVP0(:,1),AVP0(:,3).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it \gamma \rm / \circ');
    title('姿态-横滚');
    
    figure;
    plot(AVP0(:,1),AVP0(:,4).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it \psi \rm / \circ');
    title('姿态-航向');
    
%% 绘制速度信息    
    figure;
    plot(AVP0(:,1),AVP0(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it V_E \rm / m/s');
    title('速度-东向');

    figure;
    plot(AVP0(:,1),AVP0(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it V_N \rm / m/s');
    title('速度-北向');

    figure;
    plot(AVP0(:,1),AVP0(:,7));
    xlabel('\it t \rm / s');
    ylabel('\it V_U \rm / m/s');
    title('速度-天向');
    
    figure;
    plot(AVP0(:,1),(sqrt(AVP0(:,5).^2+AVP0(:,6).^2+AVP0(:,7).^2)));
    xlabel('\it t \rm / s');
    ylabel('\it V \rm / m/s');
    title('绝对速度');    

%% 绘制位置信息  
    figure;
    plot(AVP0(:,1),AVP0(:,8).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it 纬度 \rm / \circ');
    title('位置-纬度');
    
    figure;
    plot(AVP0(:,1),AVP0(:,9).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it 经度 \rm / \circ');
    title('位置-经度');
    
    figure;
    plot(AVP0(:,1),AVP0(:,10));
    xlabel('\it t \rm / s');
    ylabel('\it 高程 \rm / m');
    title('位置-高程');    
    
    %绘制以起点为出发点的行驶轨迹
    figure;
    plot(0, 0, 'rp');     %在起始位置画一个 五角星
    legend(sprintf('%.6f, %.6f / 度', AVP0(1,8)*180/pi,AVP0(1,9)*180/pi));
    hold on;    
    plot((AVP0(:,8)-AVP0(1,8))*6378137*cos(AVP0(1,8)), (AVP0(:,9)-AVP0(1,9))*6378137);
    xlabel('\it 东向 \rm / m');
    ylabel('\it 北向 \rm / m');
    title('行驶路线');
    
end

if nargin == 2
%% 绘制姿态信息    
    figure;
    plot(AVP0(:,1),AVP0(:,2).*(180/pi),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,2).*(180/pi));    
    xlabel('\it t \rm / s');
    ylabel('\it \theta \rm / \circ');
    title('姿态-俯仰');
    
    figure;
    plot(AVP0(:,1),AVP0(:,3).*(180/pi),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,3).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it \gamma \rm / \circ');
    title('姿态-横滚');
    
    figure;
    plot(AVP0(:,1),AVP0(:,4).*(180/pi),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,4).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it \psi \rm / \circ');
    title('姿态-航向');
    
%% 绘制速度信息    
    figure;
    plot(AVP0(:,1),AVP0(:,5),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it V_E \rm / m/s');
    title('速度-东向');

    figure;
    plot(AVP0(:,1),AVP0(:,6),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it V_N \rm / m/s');
    title('速度-北向');

    figure;
    plot(AVP0(:,1),AVP0(:,7),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,7));
    xlabel('\it t \rm / s');
    ylabel('\it V_U \rm / m/s');
    title('速度-天向');
    
    figure;
    plot(AVP0(:,1),(sqrt(AVP0(:,5).^2+AVP0(:,6).^2+AVP0(:,7).^2)),'r');
    hold on;
    plot(AVP1(:,1),(sqrt(AVP1(:,5).^2+AVP1(:,6).^2+AVP1(:,7).^2)));
    xlabel('\it t \rm / s');
    ylabel('\it V \rm / m/s');
    title('绝对速度');    

%% 绘制位置信息  
    figure;
    plot(AVP0(:,1),AVP0(:,8).*(180/pi),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,8).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it 纬度 \rm / \circ');
    title('位置-纬度');
    
    figure;
    plot(AVP0(:,1),AVP0(:,9).*(180/pi),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,9).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it 经度 \rm / \circ');
    title('位置-经度');
    
    figure;
    plot(AVP0(:,1),AVP0(:,10),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,10));
    xlabel('\it t \rm / s');
    ylabel('\it 高程 \rm / m');
    title('位置-高程');    
    
    %绘制以起点为出发点的行驶轨迹
    figure;
    plot(0, 0, 'rp');     %在起始位置画一个 五角星
    legend(sprintf('%.6f, %.6f / 度', AVP0(1,8)*180/pi,AVP0(1,9)*180/pi));
    hold on;    
    plot((AVP0(:,9)-AVP0(1,9))*6378137*cos(AVP0(1,8)), (AVP0(:,8)-AVP0(1,8))*6378137,'r');
    hold on;
    plot((AVP1(:,9)-AVP1(1,9))*6378137*cos(AVP1(1,8)), (AVP1(:,8)-AVP1(1,8))*6378137);
    xlabel('\it 东向 \rm / m');
    ylabel('\it 北向 \rm / m');
    title('行驶路线');end