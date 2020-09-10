[n,m] = size(Data_Foot_Press);
% 1. �Ȼ�ȡǰ���ƺͺ�Ÿ���ѹ������
% �����趨 ��̬��������ʼʱ��ͽ���ʱ��  Ҳ����IMU�ߵ��������ʼʱ��ͽ���ʱ��
% ���������Ƴ�����������һ��������ʱ�䣬һ���Ǿ�ֹ����ʱ�䣬һ���ǵ�������ʱ��
StartNumber = 84850; EndNumber = 224740; Number = EndNumber-StartNumber+1;
Foot_Press_front = zeros(Number,2);  
Foot_Press_back = zeros(Number,2);  
Foot_Press_back(:,1) = Data_Foot_Press(StartNumber:EndNumber,1);
Foot_Press_front(:,1) = Data_Foot_Press(StartNumber:EndNumber,1);
Foot_Press_back(:,2) = Data_Foot_Press(StartNumber:EndNumber,2)+Data_Foot_Press(StartNumber:EndNumber,3);
Foot_Press_front(:,2) = Data_Foot_Press(StartNumber:EndNumber,4)+Data_Foot_Press(StartNumber:EndNumber,5);

figure;
plot(Foot_Press_front(:,1),Foot_Press_front(:,2),'k');  %���ѹ��x
hold on; plot(Foot_Press_back(:,1),Foot_Press_back(:,2),'g');
hold on;plot(IMU(StartNumber:EndNumber,1),IMU(StartNumber:EndNumber,4)*100,'-.');  %�Ӽ�
hold on;plot(IMU(StartNumber:EndNumber,1),IMU(StartNumber:EndNumber,5)*500,'r-.');  %����
% legend('ǰ����','��Ÿ�');
legend('ǰ����','��Ÿ�','�Ӽ�Z','����X');
grid on;


% 2. �ȴ����Ÿ������ݣ���Ϊ��Ÿ�����ʱ����أ����ҳ�����
%   һ�㿪�����˶����ھ�ֹ״̬�ģ����Կ������ݳ�ʼ�ĵ�һ��ѹ��ֵ�ж��Ƿ��ھ�ֹ״̬
[n,m] = size(Foot_Press_back);
% �����Ÿ���״̬
Foot_Back_State = zeros(n,2);
Foot_Back_State(:,1) = Foot_Press_back(:,1);
i = 0;
while i < n
    i = i+1;
    if i == 1
        %��ʼ�׶� ���ж�
        if Foot_Press_back(1,2) >= 100
            %��ʼ��ֹ״̬
            Foot_Back_State(1,2) = 1;
            i = i+1;
            while Foot_Press_back(i,2) >= 100
                Foot_Back_State(i,2) = 1;
                i = i+1;
            end
                Foot_Back_State(i,2) = 0;
        else
            %��ʼ�˶�״̬
            Foot_Back_State(1,2) = 0;
             i = i+1;
            while Foot_Press_back(i,2) < 100
                Foot_Back_State(i,2) = 0;
                i = i+1;
            end
                Foot_Back_State(i,2) = 1;         
        end
    end
    if (Foot_Back_State(i-1,2) == 0) && (Foot_Press_back(i,2) > 100)
        %���˶� ���� ��ֹ
        Foot_Back_State(i,2) = 1;
        continue;
    end        
    if (Foot_Back_State(i-1,2) == 1) && (Foot_Press_back(i,2) < 100)
        %�Ӿ�ֹ ���� �˶�
        Foot_Back_State(i,2) = 0;  
        continue;
    end    
    Foot_Back_State(i,2) = Foot_Back_State(i-1,2);
end

% �Դ��������о�ƫ ��������
TStartSerial = 1;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if Foot_Back_State(i,2) ~= Foot_Back_State(i-1,2)
        if StateNum >= 10
            %�����任
            TStartSerial = i;
            StateNum = 1;
        else
            %������
            Foot_Back_State(TStartSerial:i-1,2) = Foot_Back_State(TStartSerial-1,2);
            StateNum = StateNum+10;
        end
    else
        StateNum = StateNum + 1;
    end
end

figure;
plot(Foot_Press_front(:,1),Foot_Press_front(:,2),'k');  %���ѹ��x
hold on; plot(Foot_Press_back(:,1),Foot_Press_back(:,2),'g');
hold on;plot(Foot_Back_State(:,1),Foot_Back_State(:,2).*1500,'b');
grid on;
legend('ǰ����','��Ÿ�','��Ÿ��ж�');
% hold on;plot(IMU(StartNumber:EndNumber,1),IMU(StartNumber:EndNumber,4)*100,'-.');  %�Ӽ�
% hold on;plot(IMU(StartNumber:EndNumber,1),IMU(StartNumber:EndNumber,5)*500,'r-.');  %����
% legend('ǰ����','��Ÿ�','�Ӽ�Z','����X');


% 3. ͬ�ϴ���ǰ��������
[n,m] = size(Foot_Press_front);
% �����Ÿ���״̬
Foot_front_State = zeros(n,2);
Foot_front_State(:,1) = Foot_Press_front(:,1);
i = 0;
while i < n
    i = i+1;
    if i == 1
        %��ʼ�׶� ���ж�
        if Foot_Press_front(1,2) >= 100
            %��ʼ��ֹ״̬
            Foot_front_State(1,2) = 1;
            i = i+1;
            while Foot_Press_front(i,2) >= 100
                Foot_front_State(i,2) = 1;
                i = i+1;
            end
                Foot_front_State(i,2) = 0;
        else
            %��ʼ�˶�״̬
            Foot_front_State(1,2) = 0;
             i = i+1;
            while Foot_Press_front(i,2) < 100
                Foot_front_State(i,2) = 0;
                i = i+1;
            end
                Foot_front_State(i,2) = 1;          
        end
    end
    if (Foot_front_State(i-1,2) == 0) && (Foot_Press_front(i,2) > 100)
        %���˶� ���� ��ֹ
        Foot_front_State(i,2) = 1;
        continue;
    end        
    if (Foot_front_State(i-1,2) == 1) && (Foot_Press_front(i,2) < 100)
        %�Ӿ�ֹ ���� �˶�
        Foot_front_State(i,2) = 0;  
        continue;
    end    
    Foot_front_State(i,2) = Foot_front_State(i-1,2);
end

% �Դ��������о�ƫ ��������
TStartSerial = 1;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if Foot_front_State(i,2) ~= Foot_front_State(i-1,2)
        if StateNum >= 10
            %�����任
            TStartSerial = i;
            StateNum = 1;
        else
            %������
            Foot_front_State(TStartSerial:i-1,2) = Foot_front_State(TStartSerial-1,2);
            StateNum = StateNum+10;
        end
    else
        StateNum = StateNum + 1;
    end
end

figure;
plot(Foot_Press_front(:,1),Foot_Press_front(:,2),'k');  %���ѹ��x
hold on; plot(Foot_Press_back(:,1),Foot_Press_back(:,2),'g');
legend('ǰ����','��Ÿ�');
hold on;plot(Foot_front_State(:,1),Foot_front_State(:,2).*1400,'b');
hold on;plot(Foot_Back_State(:,1),Foot_Back_State(:,2).*1500,'b');
grid on;
legend('ǰ����','��Ÿ�','��Ÿ��ж�','ǰ�����ж�');
hold on;plot(IMU(StartNumber:EndNumber,1),IMU(StartNumber:EndNumber,4)*100,'-.');  %�Ӽ�
hold on;plot(IMU(StartNumber:EndNumber,1),IMU(StartNumber:EndNumber,5)*500,'r-.');  %����


% 3. �Խ��ƺͽŸ���״̬�����ۺ��ж� ��̬
% 3.1 �ȶԽŸ� ����״̬�ľ��࣬��ȡ����ѹ������ʼ����ֹ�㣬�Լ���Ӧʱ����ڵķ�ֵ��
[n,m] = size(Foot_Back_State);
% ��ʼ�� ������ ��ֵ��
j=1;
RecoardBack = [];
for i = 1:n
    if i == 1
        while (Foot_Back_State(i,2)>0)
           i = i+1; 
        end
        continue;
    end
    
    if (Foot_Back_State(i,2) == 1) && (Foot_Back_State(i-1,2) == 0)
        RecoardBack(j,1) = i;
    end
    if (Foot_Back_State(i,2) == 0) && (Foot_Back_State(i-1,2) == 1)
        RecoardBack(j,2) = i;        
        %�������ֵ
        %RecoardBack(j,3) = max(Foot_Back_State(RecoardBack(j,1):RecoardBack(j,2),2));
        j = j+1;
    end        
end




[n,m] = size(Data_Foot_Press);
FootPres_State = zeros(n,2);
FootPres_State(:,1) = Data_Foot_Press(:,1);
for i = 1:n
    if i == 1
       %��ʼ״̬
       while (Foot_front_State(i,2)+Foot_Back_State(i,2))>0
           FootPres_State(:,2) = 1;
           i = i+1;
       end
       continue;
    end
    
    
    
    
end



