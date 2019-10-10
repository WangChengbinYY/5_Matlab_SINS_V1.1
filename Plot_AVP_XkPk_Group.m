function Plot_AVP_XkPk_Group(AVP0,XkPk)
% 绘制KF滤波的过程信息
% Xk 状态信息   姿态 速度 位置 陀螺零偏 加计零偏
% Pk 对应的方差


%% 绘制姿态信息    
    temp = 180/pi;
    figure;
    set(gcf,'position',[250,250,1200,480]);    
    subplot(3,3,1);
    plot(AVP0(:,1),AVP0(:,2).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it \theta \rm / \circ');
    title('姿态-俯仰');
    
    subplot(3,3,2);
    plot(AVP0(:,1),AVP0(:,3).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it \gamma \rm / \circ');
    title('姿态-横滚');
    
    subplot(3,3,3);
    plot(AVP0(:,1),AVP0(:,4).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it \psi \rm / \circ');
    title('姿态-航向');  
    
    subplot(3,3,4);
    plot(XkPk(:,1),XkPk(:,2).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it \delta\theta \rm / \circ');
    title('Xk姿态-俯仰');
    
    subplot(3,3,5);
    plot(XkPk(:,1),XkPk(:,3).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it \delta\gamma \rm / \circ');
    title('Xk姿态-横滚');
    
    subplot(3,3,6);
    plot(XkPk(:,1),XkPk(:,4).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it \delta\psi \rm / \circ');
    title('Xk姿态-航向');
    
    temp = temp*temp;
    subplot(3,3,7);
    plot(XkPk(:,1),XkPk(:,17).*temp);
    xlabel('\it t \rm / s');
    %ylabel('\it \theta \rm / \circ');
    title('Pk姿态-俯仰');
    
    subplot(3,3,8);
    plot(XkPk(:,1),XkPk(:,18).*temp);
    xlabel('\it t \rm / s');
    %ylabel('\it \gamma \rm / \circ');
    title('Pk姿态-横滚');
    
    subplot(3,3,9);
    plot(XkPk(:,1),XkPk(:,19).*temp);
    xlabel('\it t \rm / s');
    %ylabel('\it \psi \rm / \circ');
    title('Pk姿态-航向');    
    
    
%% 绘制速度信息    
    figure;
    set(gcf,'position',[250,250,1200,480]);
    subplot(3,3,1);
    plot(AVP0(:,1),AVP0(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it V_E \rm / m/s');
    title('速度-东向');

    subplot(3,3,2);
    plot(AVP0(:,1),AVP0(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it V_N \rm / m/s');
    title('速度-北向');

    subplot(3,3,3);
    plot(AVP0(:,1),AVP0(:,7));
    xlabel('\it t \rm / s');
    ylabel('\it V_U \rm / m/s');
    title('速度-天向');       
    
    subplot(3,3,4);
    plot(XkPk(:,1),XkPk(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it \deltaV_E \rm / m/s');
    title('Xk速度-东向');

    subplot(3,3,5);
    plot(XkPk(:,1),XkPk(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it \deltaV_N \rm / m/s');
    title('Xk速度-北向');

    subplot(3,3,6);
    plot(XkPk(:,1),XkPk(:,7));
    xlabel('\it t \rm / s');
    ylabel('\it \deltaV_U \rm / m/s');
    title('Xk速度-天向');   
  
     subplot(3,3,7);
    plot(XkPk(:,1),XkPk(:,20));
    xlabel('\it t \rm / s');
    %ylabel('\it V_E \rm / m/s');
    title('Pk速度-东向');

    subplot(3,3,8);
    plot(XkPk(:,1),XkPk(:,21));
    xlabel('\it t \rm / s');
    %ylabel('\it V_N \rm / m/s');
    title('Pk速度-北向');

    subplot(3,3,9);
    plot(XkPk(:,1),XkPk(:,22));
    xlabel('\it t \rm / s');
    %ylabel('\it V_U \rm / m/s');
    title('Pk速度-天向');      

%%  绘制位置信息  
    figure;
    set(gcf,'position',[250,250,1200,480]);
    subplot(3,3,1);
    temp = 180/pi;
    plot(AVP0(:,1),AVP0(:,8).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it 纬度 \rm / \circ');
    title('位置-纬度');
    
    subplot(3,3,2);
    plot(AVP0(:,1),AVP0(:,9).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it 经度 \rm / \circ');
    title('位置-经度');
    
    subplot(3,3,3);
    plot(AVP0(:,1),AVP0(:,10));
    xlabel('\it t \rm / s');
    ylabel('\it 高程 \rm / m');
    title('位置-高程');    
    
	subplot(3,3,4);
    plot(XkPk(:,1),XkPk(:,8).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it 纬度 \rm / \circ');
    title('Xk位置-纬度');
    
    subplot(3,3,5);
    plot(XkPk(:,1),XkPk(:,9).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it 经度 \rm / \circ');
    title('Xk位置-经度');
    
    subplot(3,3,6);
    plot(XkPk(:,1),XkPk(:,10));
    xlabel('\it t \rm / s');
    ylabel('\it 高程 \rm / m');
    title('Xk位置-高程');   
    
    temp = temp*temp;
    subplot(3,3,7);
    plot(XkPk(:,1),XkPk(:,23).*temp);
    xlabel('\it t \rm / s');
    %ylabel('\it 纬度 \rm / \circ');
    title('Pk位置-纬度');
    
    subplot(3,3,8);
    plot(XkPk(:,1),XkPk(:,24).*temp);
    xlabel('\it t \rm / s');
    %ylabel('\it 经度 \rm / \circ');
    title('Pk位置-经度');
    
    subplot(3,3,9);
    plot(XkPk(:,1),XkPk(:,25));
    xlabel('\it t \rm / s');
    %ylabel('\it 高程 \rm / m');
    title('Pk位置-高程');       

%% 绘制陀螺零偏信息
    figure;
    set(gcf,'position',[250,250,1200,480]);    
	subplot(2,3,1);
    plot(XkPk(:,1),XkPk(:,11));
    xlabel('\it t \rm / s');
    ylabel('\it X gyro \rm / \circ/h');
    title('Xk陀螺零偏 X');
    
    subplot(2,3,2);
    plot(XkPk(:,1),XkPk(:,12));
    xlabel('\it t \rm / s');
    ylabel('\it Y gyro \rm / \circ/h');
    title('Xk陀螺零偏 Y');
    
    subplot(2,3,3);
    plot(XkPk(:,1),XkPk(:,13));
    xlabel('\it t \rm / s');
    ylabel('\it Z gyro \rm / \circ/h');
    title('Xk陀螺零偏 Z');   
    
    subplot(2,3,4);
    plot(XkPk(:,1),XkPk(:,26));
    xlabel('\it t \rm / s');
    %ylabel('\it 纬度 \rm / \circ');
    title('Pk陀螺零偏 X');
    
    subplot(2,3,5);
    plot(XkPk(:,1),XkPk(:,27));
    xlabel('\it t \rm / s');
    %ylabel('\it 经度 \rm / \circ');
    title('Pk陀螺零偏 Y');
    
    subplot(2,3,6);
    plot(XkPk(:,1),XkPk(:,28));
    xlabel('\it t \rm / s');
    %ylabel('\it 高程 \rm / m');
    title('Pk陀螺零偏 Z');           
    
%% 绘制加计零偏信息
    figure;
    set(gcf,'position',[250,250,1200,480]);    
	subplot(2,3,1);
    plot(XkPk(:,1),XkPk(:,14));
    xlabel('\it t \rm / s');
    ylabel('\it X acc \rm / \circ/h');
    title('Xk加计零偏_X');
    
    subplot(2,3,2);
    plot(XkPk(:,1),XkPk(:,15));
    xlabel('\it t \rm / s');
    ylabel('\it Y acc \rm / \circ/h');
    title('Xk加计零偏_Y');
    
    subplot(2,3,3);
    plot(XkPk(:,1),XkPk(:,16));
    xlabel('\it t \rm / s');
    ylabel('\it Z acc \rm / \circ/h');
    title('Xk加计零偏_Z');   
    
    subplot(2,3,4);
    plot(XkPk(:,1),XkPk(:,29));
    xlabel('\it t \rm / s');
    %ylabel('\it 纬度 \rm / \circ');
    title('Pk加计零偏_X');
    
    subplot(2,3,5);
    plot(XkPk(:,1),XkPk(:,30));
    xlabel('\it t \rm / s');
    %ylabel('\it 经度 \rm / \circ');
    title('Pk加计零偏_Y');
    
    subplot(2,3,6);
    plot(XkPk(:,1),XkPk(:,31));
    xlabel('\it t \rm / s');
    %ylabel('\it 高程 \rm / m');
    title('Pk加计零偏_Z');           
      
%% 绘制以起点为出发点的行驶轨迹
    figure;
    plot(0, 0, 'rp');     %在起始位置画一个 五角星
    legend(sprintf('%.6f, %.6f / 度', AVP0(1,8)*180/pi,AVP0(1,9)*180/pi));
    hold on;    
    plot((AVP0(:,8)-AVP0(1,8))*6378137*cos(AVP0(1,8)), (AVP0(:,9)-AVP0(1,9))*6378137);
    xlabel('\it 东向 \rm / m');
    ylabel('\it 北向 \rm / m');
    title('行驶路线');

    
