function Plot_Att_Bias_1(Gyro_Bias_theory,Result_Bias_KF,m)
% ���� ��ƫ���ƵĽ��

figure;
    x = 1:m;
    y1 = ones(m,1)*Gyro_Bias_theory(1,1);
    y2 = ones(m,1)*Gyro_Bias_theory(2,1);
    y3 = ones(m,1)*Gyro_Bias_theory(3,1);
    set(gcf,'position',[250,250,1200,480]);    
    subplot(1,3,1);
    plot(x,y1,'r');
    hold on;
    plot(x,Result_Bias_KF(1:m,1));
    xlabel('�˲����');
    ylabel('��ƫ��ֵ');
    title('X������');
    legend('����ֵ','����ֵ');
    
    subplot(1,3,2);
    plot(x,y2,'r');
    hold on;
    plot(x,Result_Bias_KF(1:m,2));
    xlabel('�˲����');
    ylabel('��ƫ��ֵ');
    title('Y������');
    legend('����ֵ','����ֵ');
    
    subplot(1,3,3);
    plot(x,y3,'r');
    hold on;
    plot(x,Result_Bias_KF(1:m,3));
    xlabel('�˲����');
    ylabel('��ƫ��ֵ');
    title('Z������');
    legend('����ֵ','����ֵ');