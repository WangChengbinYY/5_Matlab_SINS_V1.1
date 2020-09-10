%% ��ֽ����㷨����

%% ����һ�� ��ά�� ��ɫͼ�Σ���ȡ�����ֵ
    % ��Ȼ���� e  exp(1)
    % x [-4 4]; y [-4 4];
    % z = -20*exp(-0.2*sqrt(x^2+y^2/2))-exp(cos((2*pi*x)+cos(2*pi*y))/2)+exp(1);
    
% ����ͼ��
    [x,y] = meshgrid(-5:0.1:5);
    L = length(x);
    z = zeros(L,L);
    for i = 1:L
        for j = 1:L
        z(j,i) = 20*exp(-0.2*sqrt(x(j,i)^2+y(j,i)^2/2))+exp(cos((2*pi*x(j,i))+cos(2*pi*y(j,i)))/2)+exp(1);
        end
    end
    
    figure; plot3(x,y,z);
    figure; mesh(x,y,z);
    figure; surf(x,y,z);
    
%% ���� ��ֽ��� �㷨��ȡ����ļ���ֵ ����ĺ����ж������
clear all; clc;
% �����趨
size = 50;  %Ⱥ�����
Code1 = 2;  %����ı�������

MinX(1) = -5; MaxX(1) = 5;  %��1�������ķ�Χ
MinX(2) = -5; MaxX(2) = 5;  %��2�������ķ�Χ

G = 200;    %��������
F = 1.2;    %��������[0 2]
CR = 0.8;   %�������� [0.6 0.9]

% ��ʼ����Ⱥ
P = zeros(size,Code1);
for i = 1:1:Code1
    P(:,i) = MinX(i) + (MaxX(i)-MinX(i))*rand(size,1);
end

% ��ʼ�� ȫ�����Ÿ���  �˴�Ĭ��ȡ��һ������
Best = P(1,:);

% ���㵱ǰȺ���е� ÿ���������Ӧ�Ⱥ���ֵ �����ŵ��Ǹ���ֵ�� Best
for i = 2:size
   if( fun_DE(P(i,1),P(i,2)) > fun_DE(Best(1),Best(2)) )
       Best = P(i,:);
   end       
end

% ��ʼ����ѭ���������㾫��Ҫ����ߴﵽ�������� ��ֹͣ
Best_f = zeros(1,G);
Best_f(1) = fun_DE(Best(1),Best(2));
for Kg = 1:1:G
   time(Kg) = Kg;   
   
   v = zeros(size,Code1);   %��ȡ�ı�����Ⱥ
   u = zeros(size,Code1);   %��ȡ����������Ⱥ
   for i = 1:size
       % 1 ��ʼ����
       r1 = 1; r2 = 1; r3 = 1; 
       % 1.1 ���Ѱ������3�����ڱ���ĸ��� r1 r2 r3���ܵ���i,����֮�䲻�����
       %    ��ǰ��������Ƚϱ���������������ų�i�������ȡ3�����ֵķ������иĽ�
       while(r1==i||r2==i||r3==i||r1==r2||r1==r3||r2==r3)
           r1 = ceil(size*rand(1));  % ����ȡ��
           r2 = ceil(size*rand(1)); 
           r3 = ceil(size*rand(1)); 
       end       
       % 1.2 ��ʼ����
       v(i,:) = P(r1,:) + F*(P(r2,:)-P(r3,:));  %�����������
       % h(i,:) = Best + F*(P(r2,:)-P(r3,:));   %�Ľ��� ���ű������
       
       % 1.3 ������ �Ƿ�Խ�� 
       for j = 1:Code1
           if(v(i,j)<MinX(j))
               v(i,j)=MinX(j);
           elseif(v(i,j)>MaxX(j))
               v(i,j)=MaxX(j);
           end
       end
       
       % 2 ����
       for j = 1:Code1
           Temp = rand(1);  %��ȡһ��[0 1]��Χ���������
           if (Temp < CR)
               u(i,j) = v(i,j);  %�������С��CR���򽻲�
           else
               u(i,j) = P(i,j);  %������ʴ���CR���򲻽��棬�������������Ӧ��Ԫ��
           end   
       end       
       
       % 3 ѡ��
       %  3.1 ��ȡ����Ⱥ�ж�Ӧ�ĸ���
       if(fun_DE(u(i,1),u(i,2))>fun_DE(P(i,1),P(i,2)))
           % ������Ӧ�Ⱥ��������ж�(��ֵ����)���Ƿ������콻�����¸���
           P(i,:) = u(i,:);
       end
       % 3.2 �������Ÿ���
       if( fun_DE(P(i,1),P(i,2)) > fun_DE(Best(1),Best(2)))
           Best = P(i,:);
       end   
   end
   % ���㾫����ֹͣ����
   if(fun_DE(Best(1),Best(2)) - Best_f(Kg) < 0.001)
       break;
   end   
   Best_f(Kg) = fun_DE(Best(1),Best(2)); 
end
fprintf('���Ž��Ϊ %f,%f\n',Best(1),Best(2));
fprintf('�����ֵΪ %f\n',Best_f(Kg));
figure; plot(time,Best_f(time),'*-');












