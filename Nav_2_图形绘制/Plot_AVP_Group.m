function Plot_AVP_Group(AVP0,AVP1)
% �����������̬��Ϣ
% ��������������ݣ���һ��Ϊ�������ݣ����ú�ɫ
% ��������ĸ�ʽΪ(����)  
%       ʱ��(��λms) ��̬(��������������򣬵�λ����) �ٶ� λ��(γ�ȡ����ȣ���λ���ȣ��߳� ��λ��)
%
G_CONST = CONST_Init();
Rmh = Earth_get_Rmh(G_CONST,AVP0(1,8),AVP0(1,10));
Rnh = Earth_get_Rnh(G_CONST,AVP0(1,8),AVP0(1,10));

if nargin == 1
%% ������̬��Ϣ    
    figure;
    set(gcf,'position',[250,250,1200,240]);
    subplot(1,3,1);
    plot(AVP0(:,1),AVP0(:,2).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it \theta \rm / \circ');
    title('��̬-����');
    
    subplot(1,3,2);
    plot(AVP0(:,1),AVP0(:,3).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it \gamma \rm / \circ');
    title('��̬-���');
    
    subplot(1,3,3);
    plot(AVP0(:,1),AVP0(:,4).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it \psi \rm / \circ');
    title('��̬-����');
    
%% �����ٶ���Ϣ    
    figure;
    set(gcf,'position',[250,250,1200,240]);
    subplot(1,3,1);
    plot(AVP0(:,1),AVP0(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it V_E \rm / m/s');
    title('�ٶ�-����');

    subplot(1,3,2);
    plot(AVP0(:,1),AVP0(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it V_N \rm / m/s');
    title('�ٶ�-����');

    subplot(1,3,3);
    plot(AVP0(:,1),AVP0(:,7));
    xlabel('\it t \rm / s');
    ylabel('\it V_U \rm / m/s');
    title('�ٶ�-����');   
  

%% ����λ����Ϣ  
    figure;
    set(gcf,'position',[250,250,1200,240]);
    subplot(1,3,1);
    plot(AVP0(:,1),(AVP0(:,8)-AVP0(1,8))*Rmh*cos(AVP0(1,8)));
    xlabel('\it t \rm / s');
    ylabel('\it ���� \rm / m');
    title('λ��-����');
    
    subplot(1,3,2);
    plot(AVP0(:,1),(AVP0(:,9)-AVP0(1,9))*Rnh);
    xlabel('\it t \rm / s');
    ylabel('\it ���� \rm / m');
    title('λ��-����');
    
    subplot(1,3,3);
    plot(AVP0(:,1),AVP0(:,10));
    xlabel('\it t \rm / s');
    ylabel('\it �߳� \rm / m');
    title('λ��-�߳�');    
    
    figure;
    subplot(1,2,1);
    plot(AVP0(:,1),(sqrt(AVP0(:,5).^2+AVP0(:,6).^2+AVP0(:,7).^2)));
    xlabel('\it t \rm / s');
    ylabel('\it V \rm / m/s');
    title('�����ٶ�');  
    
    
    %���������Ϊ���������ʻ�켣
    subplot(1,2,2);
    plot(0, 0, 'rp');     %����ʼλ�û�һ�� �����
    %legend(sprintf('%.6f, %.6f / ��', AVP0(1,8)*180/pi,AVP0(1,9)*180/pi));
    hold on;    
    plot((AVP0(:,9)-AVP0(1,9))*Rnh,(AVP0(:,8)-AVP0(1,8))*Rmh*cos(AVP0(1,8)));
    xlabel('\it ���� \rm / m');
    ylabel('\it ���� \rm / m');
    title('��ʻ·��');
    
end

if nargin == 2
%% ������̬��Ϣ    
    figure;
    set(gcf,'position',[250,250,1200,480]);
    subplot(1,3,1);
    plot(AVP0(:,1),AVP0(:,2).*(180/pi),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,2).*(180/pi));    
    xlabel('\it t \rm / s');
    ylabel('\it \theta \rm / \circ');
    title('��̬-����');
    
    subplot(1,3,2);
    plot(AVP0(:,1),AVP0(:,3).*(180/pi),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,3).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it \gamma \rm / \circ');
    title('��̬-���');
    
    subplot(1,3,3);
    plot(AVP0(:,1),AVP0(:,4).*(180/pi),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,4).*(180/pi));
    xlabel('\it t \rm / s');
    ylabel('\it \psi \rm / \circ');
    title('��̬-����');
    
%% �����ٶ���Ϣ    
    figure;
    set(gcf,'position',[250,250,1200,480]);
    subplot(1,3,1);
    plot(AVP0(:,1),AVP0(:,5),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,5));
    xlabel('\it t \rm / s');
    ylabel('\it V_E \rm / m/s');
    title('�ٶ�-����');

    subplot(1,3,2);
    plot(AVP0(:,1),AVP0(:,6),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,6));
    xlabel('\it t \rm / s');
    ylabel('\it V_N \rm / m/s');
    title('�ٶ�-����');

    subplot(1,3,3);
    plot(AVP0(:,1),AVP0(:,7),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,7));
    xlabel('\it t \rm / s');
    ylabel('\it V_U \rm / m/s');
    title('�ٶ�-����');
    


%% ����λ����Ϣ  
    figure;
    set(gcf,'position',[250,250,1200,480]);
    subplot(1,3,1);
    plot(AVP0(:,1),(AVP0(:,8)-AVP0(1,8))*Rmh*cos(AVP0(1,8)),'r');
    hold on;
    plot(AVP1(:,1),(AVP1(:,8)-AVP1(1,8))*Rmh*cos(AVP1(1,8)));
    xlabel('\it t \rm / s');
    ylabel('\it ���� \rm / m');
    title('λ��-����');
    
    subplot(1,3,2);
    plot(AVP0(:,1),(AVP0(:,9)-AVP0(1,9))*Rnh,'r');
    hold on;
    plot(AVP1(:,1),(AVP1(:,9)-AVP1(1,9))*Rnh);
    xlabel('\it t \rm / s');
    ylabel('\it ���� \rm / m');
    title('λ��-����');
    
    subplot(1,3,3);
    plot(AVP0(:,1),AVP0(:,10),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,10));
    xlabel('\it t \rm / s');
    ylabel('\it �߳� \rm / m');
    title('λ��-�߳�');    
    
    figure;
    set(gcf,'position',[250,250,1200,240]);
    subplot(1,2,1);
    plot(AVP0(:,1),(sqrt(AVP0(:,5).^2+AVP0(:,6).^2+AVP0(:,7).^2)),'r');
    hold on;
    plot(AVP1(:,1),(sqrt(AVP1(:,5).^2+AVP1(:,6).^2+AVP1(:,7).^2)));
    xlabel('\it t \rm / s');
    ylabel('\it V \rm / m/s');
    title('�����ٶ�');    
    
    %���������Ϊ���������ʻ�켣
    subplot(1,2,2);
    plot(0, 0, 'rp');     %����ʼλ�û�һ�� �����
    %legend(sprintf('%.6f, %.6f / ��', AVP0(1,8)*180/pi,AVP0(1,9)*180/pi));
    hold on;    
    plot((AVP0(:,9)-AVP0(1,9))*Rnh,(AVP0(:,8)-AVP0(1,8))*Rmh*cos(AVP0(1,8)),'r');
    hold on;
    plot((AVP1(:,9)-AVP1(1,9))*Rnh,(AVP1(:,8)-AVP1(1,8))*Rmh*cos(AVP1(1,8)));
    xlabel('\it ���� \rm / m');
    ylabel('\it ���� \rm / m');
    title('��ʻ·��');
end


