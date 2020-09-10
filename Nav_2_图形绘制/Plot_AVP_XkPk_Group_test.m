function Plot_AVP_XkPk_Group_test(AVP0,XkPk)
% ����KF�˲��Ĺ�����Ϣ
% Xk ״̬��Ϣ   ��̬ �ٶ� λ�� ������ƫ �Ӽ���ƫ
% Pk ��Ӧ�ķ���


%% ������̬��Ϣ    
    temp = 180/pi;
    figure;
    set(gcf,'position',[250,250,1200,480]);    
    subplot(3,3,1);
    plot(AVP0(:,1),AVP0(:,2).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it ���� \rm / \circ');
    title('��̬-����');
    
    subplot(3,3,2);
    plot(AVP0(:,1),AVP0(:,3).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it ��� \rm / \circ');
    title('��̬-���');
    
    subplot(3,3,3);
    plot(XkPk(10500:339171,1),XkPk(10500:339171,12).*15000+10);
    xlabel('\it t \rm / s');
    ylabel('\it ���� \rm / \circ');
    title('��̬-����');      
    
%% �����ٶ���Ϣ    
    subplot(3,3,4);
    plot(AVP0(:,1),AVP0(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it V_E \rm / m/s');
    title('�ٶ�-����');

    subplot(3,3,5);
    plot(AVP0(:,1),AVP0(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it V_N \rm / m/s');
    title('�ٶ�-����');

    subplot(3,3,6);
    plot(AVP0(:,1),AVP0(:,7));
    xlabel('\it t \rm / s');
    ylabel('\it V_U \rm / m/s');
    title('�ٶ�-����');       
    
%%  ����λ����Ϣ  
    subplot(3,3,7);
    plot(AVP0(:,1),(AVP0(:,8)-AVP0(1,8))*6378137*cos(AVP0(1,8)));
    xlabel('\it t \rm / s');
    ylabel('\it ���� \rm / m');
    title('λ��-����');
    
    subplot(3,3,8);
    plot(AVP0(:,1),(AVP0(:,9)-AVP0(1,9))*6378137);
    xlabel('\it t \rm / s');
    ylabel('\it ���� \rm / m');
    title('λ��-����');
    
    subplot(3,3,9);
    plot(AVP0(:,1),AVP0(:,10)-49.8);
    xlabel('\it t \rm / s');
    ylabel('\it �߳� \rm / m');
    title('λ��-�߳�');    
    
