%% 0 ����Ϊѹ����������ԭʼ����  FootPres
% ʱ�����󣬻������ѹ�������������� �Ӽ����ݣ�������ʾ
%  ѹ��������˳��'�Ÿ��ڲ�6','�Ÿ����7','�����ڲ�5','�������2'
%ԭʼѹ����Ϣ�ıȽϣ���ʱѹ����ֵ����Ļ��ǵ�ѹ
clear all;
load('E:\ADIS_L_26605_27308.mat');
figure;
plot(FootPres(:,1),FootPres(:,2),'k');  %���ѹ��x
hold on; plot(FootPres(:,1),FootPres(:,3),'r');
hold on; plot(FootPres(:,1),FootPres(:,4),'g');
hold on; plot(FootPres(:,1),FootPres(:,5),'b');
hold on;plot(IMU(:,1),IMU(:,4)*10+990,'-.');  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5)*50+1000,'r-.');  %����
grid on;
legend('�Ÿ��ڲ�','�Ÿ����','�����ڲ�','�������','�Ӽ�Z','����X');
xlabel('\it t \rm / s');       
title('ѹ��������ԭʼ����');

%% һ����ѹ��ԭʼ���ݽ��д��� 
%   �ž�ֹ����ѹ��������С����ѹС
%   ���˶�����ѹ��������󣬵�ѹ��
% 1. FootPres_Limit ��ȥ��ë��   880 ��Ӧ3.0938V ��Ӧ61Kŷ ��Ӧ 24g  ȥ��ԭʼ�����������ë�̺����ݻ���
[n,m] = size(FootPres);
FootPres_Limit = FootPres;
for j = 2:5
    for i = 1:n
        if FootPres_Limit(i,j) > 900
            FootPres_Limit(i,j) = 900;
        end   
    end
end
% ��ת  ��������ѹ��
for j = 2:5
    for i = 1:n
        FootPres_Limit(i,j) = (-1)*FootPres_Limit(i,j)+900;   
    end
end
figure;
plot(FootPres_Limit(:,1),FootPres_Limit(:,2)+FootPres_Limit(:,3),'k');  %���ѹ��x
hold on; plot(FootPres_Limit(:,1),FootPres_Limit(:,4)+FootPres_Limit(:,5),'g');
hold on;plot(IMU(:,1),IMU(:,4)*10,'-.');  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5)*50,'r-.');  %����
grid on;
legend('�Ÿ�ѹ��','����ѹ��','�Ӽ�Z','����X');
xlabel('\it t \rm / s');       
title('ѹ��������ԭʼ����');


%% ������ת�����ѹ�� FootPres_Pa ���в�̬�ж� 
% 1. �Ȼ�ȡǰ���ƺͺ�Ÿ���ѹ������ �ֱ�ǰ �� ���������������
% �����趨 ��̬��������ʼʱ��ͽ���ʱ��  Ҳ����IMU�ߵ��������ʼʱ��ͽ���ʱ��
% ���������Ƴ�����������һ��������ʱ�䣬һ���Ǿ�ֹ����ʱ�䣬һ���ǵ�������ʱ��
FootPres_Pa = FootPres_Limit;
[n,m] = size(FootPres_Pa);
FootPres_Pa_front = zeros(n,2);  
FootPres_Pa_back = zeros(n,2);  
FootPres_Pa_back(:,1) = FootPres_Pa(:,1);
FootPres_Pa_front(:,1) = FootPres_Pa(:,1);
FootPres_Pa_back(:,2) = FootPres_Pa(:,2)+FootPres_Pa(:,3);
FootPres_Pa_front(:,2) = FootPres_Pa(:,4)+FootPres_Pa(:,5);

% 2. �ȴ����Ÿ������ݣ���Ϊ��Ÿ�����ʱ����أ����ҳ�����
%   һ�㿪�����˶����ھ�ֹ״̬�ģ����Կ������ݳ�ʼ�ĵ�һ��ѹ��ֵ�ж��Ƿ��ھ�ֹ״̬
[n,m] = size(FootPres_Pa_back);
% �����Ÿ���״̬
FootPreState_back = zeros(n,2);
FootPreState_back(:,1) = FootPres_Pa_back(:,1);
i = 0;
while i < n
    i = i+1;
    if i == 1
        %��ʼ�׶� ���ж�
        if FootPres_Pa_back(1,2) >= 100
            %��ʼ��ֹ״̬
            FootPreState_back(1,2) = 1;
            i = i+1;
            while FootPres_Pa_back(i,2) >= 100
                FootPreState_back(i,2) = 1;
                i = i+1;
            end
                FootPreState_back(i,2) = 0;
        else
            %��ʼ�˶�״̬
            FootPreState_back(1,2) = 0;
             i = i+1;
            while FootPres_Pa_back(i,2) < 100
                FootPreState_back(i,2) = 0;
                i = i+1;
            end
                FootPreState_back(i,2) = 1;         
        end
    end
    if (FootPreState_back(i-1,2) == 0) && (FootPres_Pa_back(i,2) > 100)
        %���˶� ���� ��ֹ
        FootPreState_back(i,2) = 1;
        continue;
    end        
    if (FootPreState_back(i-1,2) == 1) && (FootPres_Pa_back(i,2) < 100)
        %�Ӿ�ֹ ���� �˶�
        FootPreState_back(i,2) = 0;  
        continue;
    end    
    FootPreState_back(i,2) = FootPreState_back(i-1,2);
end

% �Դ��������о�ƫ ��������
TStartSerial = 1;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if FootPreState_back(i,2) ~= FootPreState_back(i-1,2)
        if StateNum >= 10
            %�����任
            TStartSerial = i;
            StateNum = 1;
        else
            %������
            FootPreState_back(TStartSerial:i-1,2) = FootPreState_back(TStartSerial-1,2);
            StateNum = StateNum+10;
        end
    else
        StateNum = StateNum + 1;
    end
end

figure;
plot(FootPres_Pa_back(:,1),FootPres_Pa_back(:,2),'k');  %���ѹ��x
hold on; plot(FootPres_Pa_front(:,1),FootPres_Pa_front(:,2),'g');
hold on;plot(FootPreState_back(:,1),FootPreState_back(:,2).*1500,'b');
title('��Ÿ�ѹ��״̬State');
grid on;
legend('��Ÿ�','ǰ����','��Ÿ��ж�');
hold on;plot(IMU(:,1),IMU(:,4)*100,'-.');  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5)*500,'r-.');  %����
clear i m n Number StateNum TStartSerial;

% 3. ͬ�ϴ���ǰ��������
[n,m] = size(FootPres_Pa_front);
% ����ǰ���Ƶ�״̬
FootPreState_front = zeros(n,2);
FootPreState_front(:,1) = FootPres_Pa_front(:,1);
i = 0;
while i < n
    i = i+1;
    if i == 1
        %��ʼ�׶� ���ж�
        if FootPres_Pa_front(1,2) >= 100
            %��ʼ��ֹ״̬
            FootPreState_front(1,2) = 1;
            i = i+1;
            while FootPres_Pa_front(i,2) >= 100
                FootPreState_front(i,2) = 1;
                i = i+1;
            end
                FootPreState_front(i,2) = 0;
        else
            %��ʼ�˶�״̬
            FootPreState_front(1,2) = 0;
             i = i+1;
            while FootPres_Pa_front(i,2) < 100
                FootPreState_front(i,2) = 0;
                i = i+1;
            end
                FootPreState_front(i,2) = 1;          
        end
    end
    if (FootPreState_front(i-1,2) == 0) && (FootPres_Pa_front(i,2) > 100)
        %���˶� ���� ��ֹ
        FootPreState_front(i,2) = 1;
        continue;
    end        
    if (FootPreState_front(i-1,2) == 1) && (FootPres_Pa_front(i,2) < 100)
        %�Ӿ�ֹ ���� �˶�
        FootPreState_front(i,2) = 0;  
        continue;
    end    
    FootPreState_front(i,2) = FootPreState_front(i-1,2);
end

% �Դ��������о�ƫ ��������
TStartSerial = 1;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if FootPreState_front(i,2) ~= FootPreState_front(i-1,2)
        if StateNum >= 10
            %�����任
            TStartSerial = i;
            StateNum = 1;
        else
            %������
            FootPreState_front(TStartSerial:i-1,2) = FootPreState_front(TStartSerial-1,2);
            StateNum = StateNum+10;
        end
    else
        StateNum = StateNum + 1;
    end
end

figure;
plot(FootPres_Pa_back(:,1),FootPres_Pa_back(:,2),'k');            %���ѹ��x
hold on; plot(FootPres_Pa_front(:,1),FootPres_Pa_front(:,2),'g');
hold on;plot(FootPreState_front(:,1),FootPreState_front(:,2).*1400,'b');
hold on;plot(FootPreState_back(:,1),FootPreState_back(:,2).*1500,'b.-');
title('�ŵ�ѹ��״̬ State');
grid on;
hold on;plot(IMU(:,1),IMU(:,4)*100,'-.');  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5)*500,'r-.');  %����
legend('��Ÿ�','ǰ����','ǰ�����ж�','��Ÿ��ж�');
clear i m n StateNum TStartSerial;

%% ���� ����ǰ��ѹ���ж�״̬ ���� �ŵĲ�̬�ж�
% 1.���� ��Ÿ���״̬ FootPreState_back Ѱ�� ÿ���ӵع����е�ѹ����ֵ FootPres_Pa_back
[n,m] = size(FootPreState_back);
mBegin = 0; mBegin_Serial = 0; 
mEnd = 0;   mEnd_Serial = 0; 
for i = 2:n
    if (FootPreState_back(i-1,2) == 0)&&(FootPreState_back(i,2) == 1)
        mBegin = 1;
        mBegin_Serial = i;
    end
    if (mBegin == 1)&&(FootPreState_back(i-1,2) == 1)&&(FootPreState_back(i,2) == 0)
        mEnd = 1;
        mEnd_Serial = i;
    end    
    if (mBegin == 1)&&(mEnd == 1)   
        if mEnd_Serial > mBegin_Serial
            [mMax,mIndex] = max(FootPres_Pa_back(mBegin_Serial:mEnd_Serial,2));
            FootPreState_back(mIndex+mBegin_Serial-1,2) = 2;
        end
        mBegin = 0;
        mEnd = 0;        
    end    
end

% 2.���� ǰ���Ƶ�״̬ FootPreState_front Ѱ�� ÿ���ӵع����е�ѹ����ֵ FootPres_Pa_front
[n,m] = size(FootPreState_front);
mBegin = 0; mBegin_Serial = 0; 
mEnd = 0;   mEnd_Serial = 0; 
for i = 2:n
    if (FootPreState_front(i-1,2) == 0)&&(FootPreState_front(i,2) == 1)
        mBegin = 1;
        mBegin_Serial = i;
    end
    if (mBegin == 1)&&(FootPreState_front(i-1,2) == 1)&&(FootPreState_front(i,2) == 0)
        mEnd = 1;
        mEnd_Serial = i;
    end    
    if (mBegin == 1)&&(mEnd == 1)   
        if mEnd_Serial > mBegin_Serial
            [mMax,mIndex] = max(FootPres_Pa_front(mBegin_Serial:mEnd_Serial,2));
            FootPreState_front(mIndex+mBegin_Serial-1,2) = 2;
        end
        mBegin = 0;
        mEnd = 0;        
    end    
end

figure;
plot(FootPres_Pa_back(:,1),FootPres_Pa_back(:,2),'k');            %���ѹ��x
hold on; plot(FootPres_Pa_front(:,1),FootPres_Pa_front(:,2),'g');
hold on;plot(FootPreState_back(:,1),FootPreState_back(:,2)*1000,'b.-');
hold on;plot(FootPreState_front(:,1),FootPreState_front(:,2)*1500,'b.-');
title('�ŵ�ѹ��״̬ State');
grid on;
hold on;plot(IMU(:,1),IMU(:,4)*100,'-.');  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5)*500,'r-.');  %����
legend('��Ÿ�','ǰ����','ǰ�����ж�','��Ÿ��ж�');

% 3.��̬�ۺ��ж�
[n,m] = size(FootPreState_back);
FootPre_State = zeros(n,2);
FootPre_State(:,1) = FootPres(:,1);
mBegin = 0; mBegin_Serial = 0; 
mEnd = 0;   mEnd_Serial = 0; 
i = 0;
while i<n
    i = i+1;
    %��ͷ
    if i == 1
        while (FootPreState_back(i,2)+FootPreState_front(i,2))>0
            FootPre_State(i,2) = 1;
            i = i+1;
        end
    end
    if FootPreState_back(i,2) == 2
        mBegin = 1;
        mBegin_Serial = i;
    end
    
    if (FootPreState_front(i,2) == 2)&&(mBegin == 1)
        FootPre_State(mBegin_Serial:i,2) = 1;
        mBegin = 0;
        mBegin_Serial = 0;
    end       
end

figure;
plot(FootPre_State(:,1),FootPre_State(:,2),'r');            %���ѹ��x
hold on;plot(FootPreState_back(:,1),FootPreState_back(:,2),'b.-');
hold on;plot(FootPreState_front(:,1),FootPreState_front(:,2),'b.-');
grid on;
legend('��̬','��Ÿ�','ǰ����');


