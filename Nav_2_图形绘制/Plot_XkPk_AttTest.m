function Plot_XkPk_AttTest(XkPk)
% 绘制KF滤波 测试  

%% 绘制姿态误差  
    temp = 180/pi;
    figure;
    set(gcf,'position',[250,250,1200,480]);    
    subplot(2,3,1);
    plot(XkPk(:,1).*temp);
    xlabel('采集序号');
    ylabel('度');
    title('x1 误差');
    
    subplot(2,3,2);
    plot(XkPk(:,2).*temp);
    xlabel('采集序号');
    ylabel('度');
    title('x2 误差');
    
    subplot(2,3,3);
    plot(XkPk(:,3).*temp);
    xlabel('采集序号');
    ylabel('度');
    title('x3 误差');
    
    subplot(2,3,4);
    plot(XkPk(:,7).*temp);
    xlabel('采集序号');
    ylabel('度');
    title('x1 方差 Pk');
    
    subplot(2,3,5);
    plot(XkPk(:,8).*temp);
    xlabel('采集序号');
    ylabel('度');
    title('x2 方差 Pk');
    
    subplot(2,3,6);
    plot(XkPk(:,9).*temp);
    xlabel('采集序号');
    ylabel('度');
    title('x3 方差 Pk');
    

%% 绘制 零偏误差
    figure;
    set(gcf,'position',[250,250,1200,480]);    
    subplot(2,3,1);
    plot(XkPk(:,4));
    xlabel('采集序号');
    ylabel('弧度/s');
    title('x4 误差');
    
    subplot(2,3,2);
    plot(XkPk(:,5));
    xlabel('采集序号');
    ylabel('弧度/s');
    title('x5 误差');
    
    subplot(2,3,3);
    plot(XkPk(:,6));
    xlabel('采集序号');
    ylabel('弧度/s');
    title('x6 误差');   
    
    subplot(2,3,4);
    plot(XkPk(:,10));
    xlabel('采集序号');
    ylabel('弧度/s');
    title('x4 方差 Pk');
    
    subplot(2,3,5);
    plot(XkPk(:,11));
    xlabel('采集序号');
    ylabel('弧度/s');
    title('x5 方差 Pk');
    
    subplot(2,3,6);
    plot(XkPk(:,12));
    xlabel('采集序号');
    ylabel('弧度/s');
    title('x6 方差 Pk');    
    
    
    