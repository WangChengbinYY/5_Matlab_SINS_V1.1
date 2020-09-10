%--------------------------------------------------------------------------
% �Ե���ʵ������ ����Ԥ����
%       ע�� ���������ļ�txt�ĸ�ʽ
%  V1.0 20191024 
%       ����ѹ��������x����Ϣͬʱ�ж�״̬
%  V1.1 201911109 
%       �Ų�״̬����������һ��������ѹ������״̬�ж�
%                       �ڶ���������������X�����ݽ��� ��ͷȥβ��
%--------------------------------------------------------------------------
clc;
clear all;
fprintf('---------Ԥ����ʼ��\n');
%% һ�����ò���
    fprintf('һ�����ò���\n');
    OnOff_GPS = 0;                  %�Ƿ����GPS����
    OnOff_IMUA = 0;                 %�Ƿ����IMUA ������
    OnOff_IMUB = 1;                 %�Ƿ����IMUB ������
    OnOff_FootPre = 1;              %�Ƿ�����ŵ�ѹ��������������
    OnOff_UWB = 0;                  %�Ƿ����UWB�������
    
    LorR = 1;                       %��������ݻ����ҽ�����  1 ������� 0 �����ҽ�
    SerialNumber = '4';             %��¼���ݵ�˳����

    Number_Start = 1;                %׼����ȡ���ݶε���� Ĭ��Ϊ1
    Number_End = 0;                  %׼����ȡ���ݶε���� Ĭ��Ϊ0 ���Ϊ0�Ļ�������һֱ������ĩβ
    
%% ������ȡ����
    fprintf('������ȡ����\n');
    %�������ݴ���ļ���·��
    if LorR == 1
        %FilenamePach = 'F:\2_��ʿ����_JG\2_ʵ���¼\20191024_�廪ʵ����¥����Ų���ѹ���߸�����\0_ԭʼ����\L_IMUGPS';
        FilenamePach = 'E:\2_��ʿ����_JG\2_ʵ���¼\20191109_�ڵ�λ�칫¥��¥����������\0_ԭʼ����\IMUGPS';
    else
        %FilenamePach = 'F:\2_��ʿ����_JG\2_ʵ���¼\20191024_�廪ʵ����¥����Ų���ѹ���߸�����\0_ԭʼ����\R_IMUGPS';
    end
    
    %��ȡGPS����
    if OnOff_GPS == 1
        Filename_GPS = strcat(FilenamePach,SerialNumber,'_GPS.txt');
        Origion_GPS = importdata(Filename_GPS);
        clear Filename_GPS;       
    end
    %��ȡIMUA����
    if OnOff_IMUA == 1
        Filename_IMUA = strcat(FilenamePach,SerialNumber,'_IMU_A.txt');
        Origion_IMUA = importdata(Filename_IMUA);
        clear Filename_IMUB;        
    end
    %��ȡIMUB����
    if OnOff_IMUB == 1
        Filename_IMUB = strcat(FilenamePach,SerialNumber,'_IMU_B.txt');
        Origion_IMUB = importdata(Filename_IMUB);
        clear Filename_IMUB;        
    end    
    %��ȡѹ��������������
    if OnOff_FootPre == 1
        Filename_Foot = strcat(FilenamePach,SerialNumber,'_FootPressure.txt');
        Origion_Foot = importdata(Filename_Foot);
        clear Filename_Foot;        
    end
    %��ȡUWB������    
    if OnOff_UWB == 1
        Filename_UWB = strcat(FilenamePach,SerialNumber,'_UWB.txt');
        Origion_UWB = importdata(Filename_UWB);
        clear Filename_UWB;        
    end

    %%����һ�������֣�IMU�����ݲ����٣���IMU�����ݳ���Ϊ��׼
    if OnOff_IMUA == 1
        n = length(Origion_IMUA);
    else
        n = length(Origion_IMUB);       
    end
    if Number_Start > n
        return
    end
    if Number_End == 0 || Number_End > n
        Number_End = n - 10;
    end
    n = Number_End - Number_Start + 1;
        
%% ��������Ԥ������IMUB
    fprintf('��������Ԥ������IMUB\n');
if OnOff_IMUB == 1
    Data_IMUB = zeros(n,8);
    Data_IMUB(:,1) = Origion_IMUB(Number_Start:Number_End,1) + Origion_IMUB(Number_Start:Number_End,2)./1000;
    Data_IMUB(:,2:4) = Origion_IMUB(Number_Start:Number_End,3:5);
    Data_IMUB(:,5:7) = Origion_IMUB(Number_Start:Number_End,6:8).*(pi/180);  %���������ɶ�/s ת��Ϊ rad/s
    Data_IMUB(:,8) = Origion_IMUB(Number_Start:Number_End,9);     
    if LorR == 1   %�����������
        Data_IMUB_L = Data_IMUB;
    else
        %�����ҽŵ�����
        Data_IMUB_R = Data_IMUB;
    end   
end

%% ��������Ԥ������ѹ��������
%   ѹ������������ ʱ�� 4��ѹ��ֵ  ��˳��ֱ���� 6 7 5 2��ѹ����
    fprintf('��������Ԥ������ѹ��������\n');
if OnOff_FootPre == 1
%-----------------------ѹ������ת��---------------------------    
    Data_Foot = zeros(n,5);             %�ɼ��ĵ�ѹ����
    Data_Foot_Press = zeros(n,5);       %��Ӧ��ѹ������   ����ѹת��Ϊ����  �ٽ�����ת��Ϊѹ��ֵ
    
    Data_Foot(:,1) = Origion_Foot(Number_Start:Number_End,1) + Origion_Foot(Number_Start:Number_End,2)./1000;
    Data_Foot(:,2:5) = Origion_Foot(Number_Start:Number_End,3:6);
    Data_Foot_Press(:,1) = Data_Foot(:,1);  
    
    % ��� ѹ��(Y/g)������(X/kR) ����
    %Temp_X = [50.00,30.30,20.80,14.20,9.18,6.92,5.85,5.00,4.36,4.02,3.43,3.28,3.16,3.05,2.91,2.78,2.71,2.61,2.53,2.49,2.45,2.42,2.37]';
    %Temp_Y = [300,500,1000,1500,2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000,10500,11000]';
    %��ָ��������� �������£�  f(x) = a*exp(b*x) + c*exp(d*x)
       a = 2.181e+05;
       b = -1.474;
       c = 5077;
       d = -0.08735;
       R1 = 10;
    for i=2:5
        for j=1:n
            %�����ת��Ϊ ��ѹ Vx = Data_Foot .* (3.6/1024.0) ��λ V
            Temp_Vx = Data_Foot(j,i)*3.6/1024.0;
            %����ѹת��Ϊ���� R1 = 10K  R2 = ѹ����ֵ = Vx*R1/(3.6-Vx) ��λkR
            Temp_Rx = Temp_Vx*R1/(3.6 - Temp_Vx);
            %������ת��Ϊѹ��ֵ
            Data_Foot_Press(j,i) = a*exp(b*Temp_Rx) + c*exp(d*Temp_Rx);
        end
    end     
%-----------------------��̬״̬���ж�---------------------------
%�÷���Ŀǰ�����������߻���ߣ����ܶ��Ļ�û�в���
    %(1)ѹ���������˶�״̬�ж�    
    fprintf('  (1)ѹ���������˶�״̬�ж�\n'); 
    Data_Foot_State = zeros(n,2);
    Temp_Press = 50;            %�ŵ�ѹ��ֵ ��ֵ    
    % (1.1)����ѹ�����ݵ�״̬�ж�   
    fprintf('  (1.1)����ѹ�����ݵ�״̬�ж�\n'); 
    for i = 1:n
        Data_Foot_State(i,1) = Data_Foot_Press(i,1);   %ʱ��
        if ((Data_Foot_Press(i,2)+Data_Foot_Press(i,3)+Data_Foot_Press(i,4)+Data_Foot_Press(i,5))>Temp_Press) 
            Data_Foot_State(i,2) = 1;
        else
            Data_Foot_State(i,2) = 0;
        end
    end
    % (1.2)���״̬����ͳ��  
    fprintf('  (1.2)���״̬����ͳ��\n');     
    Temp_Num = 200*0.05;    %һ��1s ���ڵ�5%
    Temp_j = 1;
    Temp_Step(Temp_j,1) = Data_Foot_State(1,2);  % ��ʼ״̬
    Temp_Step(Temp_j,2) = 1;                    % ��ǰ״̬����
    Temp_Step(Temp_j,3) = 1;                    % ״̬���
    for i = 2:n
        if Temp_Step(Temp_j,1) ~= Data_Foot_State(i,2)
            %״̬�����
            Temp_Step(Temp_j,4) = i-1;         % ״̬�յ�
            if Temp_Step(Temp_j,2) <= Temp_Num
                fprintf('    ����	����:%d	���:%d	�յ�:%d\n',Temp_Step(Temp_j,2),Temp_Step(Temp_j,3),Temp_Step(Temp_j,4));
            end
            Temp_j = Temp_j + 1;                % ��ʼ�µ�״̬��¼
            Temp_Step(Temp_j,1) = Data_Foot_State(i,2);  % ��ʼ״̬
            Temp_Step(Temp_j,2) = 1;                    % ��ǰ״̬����
            Temp_Step(Temp_j,3) = i;                    % ״̬���            
        else
            %״̬���� ����ֵ����
            Temp_Step(Temp_j,2) = Temp_Step(Temp_j,2)+1;
        end
    end
    % (1.3)���״̬ͳ����Ϣ���� ����
    %     Ϊ��������������״̬��Ϣ�鲢��ǰһ��״̬��ȥ
    fprintf('  (1.3)���״̬ͳ����Ϣ���� ����\n');      
    Temp_j = length(Temp_Step);    
    for i = 2:Temp_j
        if Temp_Step(i,2)<=Temp_Num            
            for j = Temp_Step(i,3):Temp_Step(i,4)
                Data_Foot_State(j,2) = Temp_Step(i-1,1);
            end
        end
    end
    
    % (1.4)���������������֤
    fprintf('  (1.4)���������������֤\n');      
    clear Temp_j Temp_Step;
    Temp_j = 1;
    Temp_Step(Temp_j,1) = Data_Foot_State(1,2);  % ��ʼ״̬
    Temp_Step(Temp_j,2) = 1;                    % ��ǰ״̬����
    Temp_Step(Temp_j,3) = 1;                    % ״̬���
    for i = 2:n
        if Temp_Step(Temp_j,1) ~= Data_Foot_State(i,2)
            %״̬�����
            Temp_Step(Temp_j,4) = i-1;         % ״̬�յ�
            if Temp_Step(Temp_j,2) <= Temp_Num
                fprintf('    ����	����:%d	���:%d	�յ�:%d\n',Temp_Step(Temp_j,2),Temp_Step(Temp_j,3),Temp_Step(Temp_j,4));
            end
            Temp_j = Temp_j + 1;                % ��ʼ�µ�״̬��¼
            Temp_Step(Temp_j,1) = Data_Foot_State(i,2);  % ��ʼ״̬
            Temp_Step(Temp_j,2) = 1;                    % ��ǰ״̬����
            Temp_Step(Temp_j,3) = i;                    % ״̬���
        else
            %״̬���� ����ֵ����
            Temp_Step(Temp_j,2) = Temp_Step(Temp_j,2)+1;
        end
    end
    clear Temp_j Temp_Num Temp_Step;
    %Test
    figure;
    plot(Data_IMUB_L(:,1),Data_IMUB_L(:,5)+1);
    hold on;
    plot(Data_Foot_State(:,1),Data_Foot_State(:,2),'r-.');
    hold on;
    
    %(2)���ݸ���ѹ���������ж�
    fprintf('  (2)���ݸ���ѹ���������ж�\n');      
    %(2.1)����X�᷽�����
    fprintf('  (2.1)����X�᷽�����\n');    
    Temp_GyroX_Num = 5;         %ѡ�ü��������������ݽ����ж�
    Temp_GyroX_VarMax = 0.1;    %�������ݷ����жϵ� ��ֵ  
    fprintf('    ѡ�õĲ������������� %d  X�����ݷ�����ֵ��%f\n',Temp_GyroX_Num,Temp_GyroX_VarMax);      
    Temp_GyroX_Mean = mean(Data_IMUB(10*200:50*200,5));        %X���ݾ�ֹ�����ֵ �ӵ�10�뿪ʼ��50�����
    fprintf('               X�����ݾ�ֹ�����ֵΪ��%f��/h\n',Temp_GyroX_Mean*180/pi*3600);     
    Temp_GyroX_Var = zeros(n,2);
    for i = 1:n
        Temp_GyroX_Var(i,1) = Data_IMUB(i,1);
        if i<Temp_GyroX_Num
            Temp_Var = 0;
            for j=1:i
                Temp_Var = Temp_Var + (Data_IMUB(j,5)-Temp_GyroX_Mean)^2;
            end
            Temp_GyroX_Var(i,2) = sqrt(Temp_Var)/i;
        else
            Temp_Var = 0;
            for j=i-Temp_GyroX_Num+1:i
                Temp_Var = Temp_Var + (Data_IMUB(j,5)-Temp_GyroX_Mean)^2;
            end
            Temp_GyroX_Var(i,2) = sqrt(Temp_Var)/Temp_GyroX_Num;
        end
    end
    %Test
    plot(Temp_GyroX_Var(:,1),Temp_GyroX_Var(:,2)+1,'g-*');
    hold on;
    
    %(2.2)��������X��ķ����ѹ�����жϽ�����ͷȥβ
    Temp_Foot_State = Data_Foot_State(1,2);
    for i = 1:n
        %����ͷ�ж�
        if (Temp_Foot_State == 0) && (Data_Foot_State(i,2) == 1)
            if Temp_GyroX_Var(i,2) > Temp_GyroX_VarMax
                Data_Foot_State(i,2) = 0;
                continue;
            else
                Temp_Foot_State = 1;
            end
        end
        %����β�ж�
        if (Temp_Foot_State == 1) && (Data_Foot_State(i,2) == 0)
            %��ǰ׷�� 4��Temp_GyroX_Num���ڵ�����
            if i < 4*Temp_GyroX_Num
                Temp_Foot_State = 0;
                continue;
            end       
            for j = 1:4*Temp_GyroX_Num
                if Temp_GyroX_Var(i-j+1,2)>Temp_GyroX_VarMax
                    Data_Foot_State(i-j+1,2) = 0; 
                else
                    Data_Foot_State(i-j+1,2) = 0; 
                    Data_Foot_State(i-j,2) = 0;
                    Data_Foot_State(i-j-1,2) = 0;
                    Data_Foot_State(i-j-2,2) = 0;
                    Data_Foot_State(i-j-3,2) = 0;
                    break;
                end                            
            end 
            Temp_Foot_State = 0;
        end        
    end
    plot(Data_Foot_State(:,1),Data_Foot_State(:,2),'r');
    hold on;   
    
%% �ġ����ݸ�ֵ    
    fprintf('�ġ����ݸ�ֵ\n');
	if LorR == 1   %�����������
        Data_Foot_L = Data_Foot;
        Data_Foot_L_Press = Data_Foot_Press;
        Data_Foot_L_State = Data_Foot_State;
        Origion_Foot_L = Origion_Foot;
        Origion_IMUB_L = Origion_IMUB;
    else
        %�����ҽŵ�����
        Data_Foot_R = Data_Foot;
        Data_Foot_R_Press = Data_Foot_Press;
        Data_Foot_R_State = Data_Foot_State;
        Origion_Foot_R = Origion_Foot;
        Origion_IMUB_R = Origion_IMUB;
    end  
    clear Temp_Foot_State Temp_GyroX_Mean Temp_GyroX_Num Origion_Foot Origion_IMUB;
    clear Temp_GyroX_Var Temp_GyroX_VarMax Temp_Press Temp_Var;
    clear a b c d R1 Data_Foot Data_Foot_Press i j Temp_Vx Temp_Rx;    
end
    fprintf('---------Ԥ���������\n');





%% ��֤���ݵ���ȷ��
% 1.��֤�������ݵ�׼ȷ��
% if OnOff_IMUB == 1
%     figure;
%     plot(Origion_IMUB(:,1)+Origion_IMUB(:,2)./1000,Origion_IMUB(:,5));
%     hold on; plot(Data_IMUB_L(:,1),Data_IMUB_L(:,4),'r*');
% end
% 2.��֤ѹ����������ֹ״̬�жϵ�׼ȷ��
% if  OnOff_FootPre == 1
%     Vel = zeros(n,2);
%     for i=1:n
%         Vel(i,1) = Data_IMUB(i,1);
%         Vel(i,2) = sqrt(Data_IMUB(i,3)^2+Data_IMUB(i,4)^2+Data_IMUB(i,5)^2);
%     end
%     
%     figure;
%     plot(Data_IMUB_L(:,7)+10);
%     hold on; plot(Vel(:,2),'g.-');
%     hold on; plot(Data_Foot_State(:,2).*10,'r');
%     
%     clear i Vel;
% end
%% �����Ҫ�ı���
    clear FilenamePach LorR n Number_End Number_Start OnOff_FootPre OnOff_GPS;
    clear OnOff_IMUA OnOff_IMUB OnOff_UWB SerialNumber Data_IMUB Data_Foot_State;