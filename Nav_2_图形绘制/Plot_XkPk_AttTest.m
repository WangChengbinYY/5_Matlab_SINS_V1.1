function Plot_XkPk_AttTest(XkPk)
% ����KF�˲� ����  

%% ������̬���  
    temp = 180/pi;
    figure;
    set(gcf,'position',[250,250,1200,480]);    
    subplot(2,3,1);
    plot(XkPk(:,1).*temp);
    xlabel('�ɼ����');
    ylabel('��');
    title('x1 ���');
    
    subplot(2,3,2);
    plot(XkPk(:,2).*temp);
    xlabel('�ɼ����');
    ylabel('��');
    title('x2 ���');
    
    subplot(2,3,3);
    plot(XkPk(:,3).*temp);
    xlabel('�ɼ����');
    ylabel('��');
    title('x3 ���');
    
    subplot(2,3,4);
    plot(XkPk(:,7).*temp);
    xlabel('�ɼ����');
    ylabel('��');
    title('x1 ���� Pk');
    
    subplot(2,3,5);
    plot(XkPk(:,8).*temp);
    xlabel('�ɼ����');
    ylabel('��');
    title('x2 ���� Pk');
    
    subplot(2,3,6);
    plot(XkPk(:,9).*temp);
    xlabel('�ɼ����');
    ylabel('��');
    title('x3 ���� Pk');
    

%% ���� ��ƫ���
    figure;
    set(gcf,'position',[250,250,1200,480]);    
    subplot(2,3,1);
    plot(XkPk(:,4));
    xlabel('�ɼ����');
    ylabel('����/s');
    title('x4 ���');
    
    subplot(2,3,2);
    plot(XkPk(:,5));
    xlabel('�ɼ����');
    ylabel('����/s');
    title('x5 ���');
    
    subplot(2,3,3);
    plot(XkPk(:,6));
    xlabel('�ɼ����');
    ylabel('����/s');
    title('x6 ���');   
    
    subplot(2,3,4);
    plot(XkPk(:,10));
    xlabel('�ɼ����');
    ylabel('����/s');
    title('x4 ���� Pk');
    
    subplot(2,3,5);
    plot(XkPk(:,11));
    xlabel('�ɼ����');
    ylabel('����/s');
    title('x5 ���� Pk');
    
    subplot(2,3,6);
    plot(XkPk(:,12));
    xlabel('�ɼ����');
    ylabel('����/s');
    title('x6 ���� Pk');    
    
    
    