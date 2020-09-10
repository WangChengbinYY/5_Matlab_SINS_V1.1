function Plot_AVP_Group_Att(AVP0,AVP1,num)
% �����������̬��Ϣ
% ��������������ݣ���һ��Ϊ�������ݣ����ú�ɫ
% ��������ĸ�ʽΪ(����)  
%       ʱ��(��λms) ��̬(��������������򣬵�λ����) �ٶ� λ��(γ�ȡ����ȣ���λ���ȣ��߳� ��λ��)
%



%% ������̬��Ϣ   
if nargin == 2
    figure;
    set(gcf,'position',[250,250,1200,480]);
    subplot(1,3,1);
    plot(AVP0(:,1),AVP0(:,2).*(180/pi),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,2).*(180/pi));    
    xlabel('n');
    ylabel('\it \theta \rm / \circ');
    title('��̬-����');
    
    subplot(1,3,2);
    plot(AVP0(:,1),AVP0(:,3).*(180/pi),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,3).*(180/pi));    
    xlabel('n');
    ylabel('\it \gamma \rm / \circ');
    title('��̬-���');
    
    subplot(1,3,3);
    plot(AVP0(:,1),AVP0(:,4).*(180/pi),'r');
    hold on;
    plot(AVP1(:,1),AVP1(:,4).*(180/pi));    
    xlabel('n');
    ylabel('\it \psi \rm / \circ');
    title('��̬-����');
end


if nargin == 3    
    figure;
    set(gcf,'position',[250,250,1200,480]);
    subplot(1,3,1);
    plot(1:num,AVP0(1:num,2).*(180/pi),'r');
    hold on;
    plot(1:num,AVP1(1:num,2).*(180/pi));    
    xlabel('n');
    ylabel('\it \theta \rm / \circ');
    title('��̬-����');
    
    subplot(1,3,2);
    plot(1:num,AVP0(1:num,3).*(180/pi),'r');
    hold on;
    plot(1:num,AVP1(1:num,3).*(180/pi));
    xlabel('n');
    ylabel('\it \gamma \rm / \circ');
    title('��̬-���');
    
    subplot(1,3,3);
    plot(1:num,AVP0(1:num,4).*(180/pi),'r');
    hold on;
    plot(1:num,AVP1(1:num,4).*(180/pi));
    xlabel('n');
    ylabel('\it \psi \rm / \circ');
    title('��̬-����');
end

