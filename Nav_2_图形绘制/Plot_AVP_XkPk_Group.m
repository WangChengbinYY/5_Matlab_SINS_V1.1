function Plot_AVP_XkPk_Group(AVP0,XkPk)
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
    ylabel('\it \theta \rm / \circ');
    title('��̬-����');
    
    subplot(3,3,2);
    plot(AVP0(:,1),AVP0(:,3).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it \gamma \rm / \circ');
    title('��̬-���');
    
    subplot(3,3,3);
    plot(AVP0(:,1),AVP0(:,4).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it \psi \rm / \circ');
    title('��̬-����');  
    
    subplot(3,3,4);
    plot(XkPk(:,1),XkPk(:,2).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it \delta\theta \rm / \circ');
    title('Xk��̬-����');
    
    subplot(3,3,5);
    plot(XkPk(:,1),XkPk(:,3).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it \delta\gamma \rm / \circ');
    title('Xk��̬-���');
    
    subplot(3,3,6);
    plot(XkPk(:,1),XkPk(:,4).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it \delta\psi \rm / \circ');
    title('Xk��̬-����');
    
    temp = temp*temp;
    subplot(3,3,7);
    plot(XkPk(:,1),XkPk(:,17).*temp);
    xlabel('\it t \rm / s');
    %ylabel('\it \theta \rm / \circ');
    title('Pk��̬-����');
    
    subplot(3,3,8);
    plot(XkPk(:,1),XkPk(:,18).*temp);
    xlabel('\it t \rm / s');
    %ylabel('\it \gamma \rm / \circ');
    title('Pk��̬-���');
    
    subplot(3,3,9);
    plot(XkPk(:,1),XkPk(:,19).*temp);
    xlabel('\it t \rm / s');
    %ylabel('\it \psi \rm / \circ');
    title('Pk��̬-����');    
    
    
%% �����ٶ���Ϣ    
    figure;
    set(gcf,'position',[250,250,1200,480]);
    subplot(3,3,1);
    plot(AVP0(:,1),AVP0(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it V_E \rm / m/s');
    title('�ٶ�-����');

    subplot(3,3,2);
    plot(AVP0(:,1),AVP0(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it V_N \rm / m/s');
    title('�ٶ�-����');

    subplot(3,3,3);
    plot(AVP0(:,1),AVP0(:,7));
    xlabel('\it t \rm / s');
    ylabel('\it V_U \rm / m/s');
    title('�ٶ�-����');       
    
    subplot(3,3,4);
    plot(XkPk(:,1),XkPk(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it \deltaV_E \rm / m/s');
    title('Xk�ٶ�-����');

    subplot(3,3,5);
    plot(XkPk(:,1),XkPk(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it \deltaV_N \rm / m/s');
    title('Xk�ٶ�-����');

    subplot(3,3,6);
    plot(XkPk(:,1),XkPk(:,7));
    xlabel('\it t \rm / s');
    ylabel('\it \deltaV_U \rm / m/s');
    title('Xk�ٶ�-����');   
  
     subplot(3,3,7);
    plot(XkPk(:,1),XkPk(:,20));
    xlabel('\it t \rm / s');
    %ylabel('\it V_E \rm / m/s');
    title('Pk�ٶ�-����');

    subplot(3,3,8);
    plot(XkPk(:,1),XkPk(:,21));
    xlabel('\it t \rm / s');
    %ylabel('\it V_N \rm / m/s');
    title('Pk�ٶ�-����');

    subplot(3,3,9);
    plot(XkPk(:,1),XkPk(:,22));
    xlabel('\it t \rm / s');
    %ylabel('\it V_U \rm / m/s');
    title('Pk�ٶ�-����');      

%%  ����λ����Ϣ  
    figure;
    set(gcf,'position',[250,250,1200,480]);
    subplot(3,3,1);
    temp = 180/pi;
    plot(AVP0(:,1),(AVP0(:,8)-AVP0(1,8))*6378137*cos(AVP0(1,8)));
    xlabel('\it t \rm / s');
    ylabel('\it ���� \rm / m');
    title('λ��-����');
    
    subplot(3,3,2);
    plot(AVP0(:,1),(AVP0(:,9)-AVP0(1,9))*6378137);
    xlabel('\it t \rm / s');
    ylabel('\it ���� \rm / m');
    title('λ��-����');
    
    subplot(3,3,3);
    plot(AVP0(:,1),AVP0(:,10));
    xlabel('\it t \rm / s');
    ylabel('\it �߳� \rm / m');
    title('λ��-�߳�');    
    
	subplot(3,3,4);
    plot(XkPk(:,1),XkPk(:,8).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it γ�� \rm / \circ');
    title('Xkλ��-γ��');
    
    subplot(3,3,5);
    plot(XkPk(:,1),XkPk(:,9).*temp);
    xlabel('\it t \rm / s');
    ylabel('\it ���� \rm / \circ');
    title('Xkλ��-����');
    
    subplot(3,3,6);
    plot(XkPk(:,1),XkPk(:,10));
    xlabel('\it t \rm / s');
    ylabel('\it �߳� \rm / m');
    title('Xkλ��-�߳�');   
    
    temp = temp*temp;
    subplot(3,3,7);
    plot(XkPk(:,1),XkPk(:,23).*temp);
    xlabel('\it t \rm / s');
    %ylabel('\it γ�� \rm / \circ');
    title('Pkλ��-γ��');
    
    subplot(3,3,8);
    plot(XkPk(:,1),XkPk(:,24).*temp);
    xlabel('\it t \rm / s');
    %ylabel('\it ���� \rm / \circ');
    title('Pkλ��-����');
    
    subplot(3,3,9);
    plot(XkPk(:,1),XkPk(:,25));
    xlabel('\it t \rm / s');
    %ylabel('\it �߳� \rm / m');
    title('Pkλ��-�߳�');       

%% ����������ƫ��Ϣ
    figure;
    set(gcf,'position',[250,250,1200,480]);    
	subplot(2,3,1);
    plot(XkPk(:,1),XkPk(:,11));
    xlabel('\it t \rm / s');
    ylabel('\it X gyro \rm / \circ/h');
    title('Xk������ƫ X');
    
    subplot(2,3,2);
    plot(XkPk(:,1),XkPk(:,12));
    xlabel('\it t \rm / s');
    ylabel('\it Y gyro \rm / \circ/h');
    title('Xk������ƫ Y');
    
    subplot(2,3,3);
    plot(XkPk(:,1),XkPk(:,13));
    xlabel('\it t \rm / s');
    ylabel('\it Z gyro \rm / \circ/h');
    title('Xk������ƫ Z');   
    
    subplot(2,3,4);
    plot(XkPk(:,1),XkPk(:,26));
    xlabel('\it t \rm / s');
    %ylabel('\it γ�� \rm / \circ');
    title('Pk������ƫ X');
    
    subplot(2,3,5);
    plot(XkPk(:,1),XkPk(:,27));
    xlabel('\it t \rm / s');
    %ylabel('\it ���� \rm / \circ');
    title('Pk������ƫ Y');
    
    subplot(2,3,6);
    plot(XkPk(:,1),XkPk(:,28));
    xlabel('\it t \rm / s');
    %ylabel('\it �߳� \rm / m');
    title('Pk������ƫ Z');           
    
%% ���ƼӼ���ƫ��Ϣ
    figure;
    set(gcf,'position',[250,250,1200,480]);    
	subplot(2,3,1);
    plot(XkPk(:,1),XkPk(:,14));
    xlabel('\it t \rm / s');
    ylabel('\it X acc \rm / m/s');
    title('Xk�Ӽ���ƫ X');
    
    subplot(2,3,2);
    plot(XkPk(:,1),XkPk(:,15));
    xlabel('\it t \rm / s');
    ylabel('\it Y acc \rm / m/s');
    title('Xk�Ӽ���ƫ Y');
    
    subplot(2,3,3);
    plot(XkPk(:,1),XkPk(:,16));
    xlabel('\it t \rm / s');
    ylabel('\it Z acc \rm / m/s');
    title('Xk�Ӽ���ƫ Z');   
    
    subplot(2,3,4);
    plot(XkPk(:,1),XkPk(:,29));
    xlabel('\it t \rm / s');
    %ylabel('\it γ�� \rm / \circ');
    title('Pk�Ӽ���ƫ X');
    
    subplot(2,3,5);
    plot(XkPk(:,1),XkPk(:,30));
    xlabel('\it t \rm / s');
    %ylabel('\it ���� \rm / \circ');
    title('Pk�Ӽ���ƫ Y');
    
    subplot(2,3,6);
    plot(XkPk(:,1),XkPk(:,31));
    xlabel('\it t \rm / s');
    %ylabel('\it �߳� \rm / m');
    title('Pk�Ӽ���ƫ Z');           
      
%% ���������Ϊ���������ʻ�켣
    figure;
    plot(0, 0, 'rp');     %����ʼλ�û�һ�� �����
    legend(sprintf('%.6f, %.6f / ��', AVP0(1,8)*180/pi,AVP0(1,9)*180/pi));
    hold on;    
    plot((AVP0(:,8)-AVP0(1,8))*6378137*cos(AVP0(1,8)), (AVP0(:,9)-AVP0(1,9))*6378137);
    xlabel('\it ���� \rm / m');
    ylabel('\it ���� \rm / m');
    title('��ʻ·��');

    
