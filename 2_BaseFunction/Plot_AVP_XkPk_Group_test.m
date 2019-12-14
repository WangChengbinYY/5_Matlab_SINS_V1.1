function Plot_AVP_XkPk_Group_test(AVP0,XkPk)
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
    ylabel('\it 俯仰 \rm / \circ');
    title('姿态-俯仰');
    
    subplot(3,3,2);
    plot(AVP0(:,1),AVP0(:,3).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it 横滚 \rm / \circ');
    title('姿态-横滚');
    
    subplot(3,3,3);
    plot(XkPk(10500:339171,1),XkPk(10500:339171,12).*15000+10);
    xlabel('\it t \rm / s');
    ylabel('\it 航向 \rm / \circ');
    title('姿态-航向');      
    
%% 绘制速度信息    
    subplot(3,3,4);
    plot(AVP0(:,1),AVP0(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it V_E \rm / m/s');
    title('速度-东向');

    subplot(3,3,5);
    plot(AVP0(:,1),AVP0(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it V_N \rm / m/s');
    title('速度-北向');

    subplot(3,3,6);
    plot(AVP0(:,1),AVP0(:,7));
    xlabel('\it t \rm / s');
    ylabel('\it V_U \rm / m/s');
    title('速度-天向');       
    
%%  绘制位置信息  
    subplot(3,3,7);
    plot(AVP0(:,1),(AVP0(:,8)-AVP0(1,8))*6378137*cos(AVP0(1,8)));
    xlabel('\it t \rm / s');
    ylabel('\it 东向 \rm / m');
    title('位置-东向');
    
    subplot(3,3,8);
    plot(AVP0(:,1),(AVP0(:,9)-AVP0(1,9))*6378137);
    xlabel('\it t \rm / s');
    ylabel('\it 北向 \rm / m');
    title('位置-北向');
    
    subplot(3,3,9);
    plot(AVP0(:,1),AVP0(:,10)-49.8);
    xlabel('\it t \rm / s');
    ylabel('\it 高程 \rm / m');
    title('位置-高程');    
    
