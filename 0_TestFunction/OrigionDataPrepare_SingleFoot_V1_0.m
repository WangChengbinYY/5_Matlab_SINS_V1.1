%--------------------------------------------------------------------------
% �Ե���ʵ������ ����Ԥ����  V1.0 20191024
%       ע�� ���������ļ�txt�ĸ�ʽ
%  V1.0 ����ѹ��������x����Ϣͬʱ�ж�״̬
%
%--------------------------------------------------------------------------

clc;
clear all;
%% һ�����ò���
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
if OnOff_FootPre == 1
%-----------------------ѹ������ת��---------------------------    
    Data_Foot = zeros(n,5);             %�ɼ��ĵ�ѹ����
    Data_Foot_Press = zeros(n,5);          %��Ӧ��ѹ������   ����ѹת��Ϊ����  �ٽ�����ת��Ϊѹ��ֵ
    
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
    %��1��Ԥ�������ݵķ���
    Temp_GyroX_Num = 5;         %ѡ�ü��������������ݽ����ж�
    Temp_GyroX_VarMax = 0.1;    %�������ݷ����жϵ� ��ֵ  
    Temp_GyroX_Mean = mean(Data_IMUB(1:20*200,5));        %���ݾ�ֹ��������ֵ 20s 200Hz
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
    %��2���˶�״̬�ж�    
    Data_Foot_State = zeros(n,2);
    Temp_Foot_State = 0;    %��ʼĬ���ڶ�̬
    Temp_Press = 10;        %�ŵ�ѹ��ֵ ��ֵ
    for i = 1:n
        Data_Foot_State(i,1) = Data_Foot_Press(i,1);   %ʱ��
        if ((Data_Foot_Press(i,2)+Data_Foot_Press(i,3)+Data_Foot_Press(i,4)+Data_Foot_Press(i,5))>Temp_Press) 
            if Temp_Foot_State == 1 
                %�Ѿ����뾲ֹ״̬
                Data_Foot_State(i,2) = 1;
            else
                %״̬ת�䣬�ɶ��侲 ����������Ϣ�����ж�                
                %�ж���������ķ��С����ֵ������Ϊ����ʵ�� ���侲 ����������ٵ�
                if Temp_GyroX_Var(i,2) <= Temp_GyroX_VarMax
                    Temp_Foot_State = 1;
                    Data_Foot_State(i,2) = 1;
                end
            end
        else
            Data_Foot_State(i,2) = 0;
            if(Temp_Foot_State == 1)
                Temp_Foot_State = 0;
                %��ǰ׷�� 10�������ݷ����ж����� ����֮ǰ�ļ������ڵ�״̬�ж�
                if (i > 10*Temp_GyroX_Num)
                    for j = 1:10*Temp_GyroX_Num
                        if Temp_GyroX_Var(i-j+1,2)>Temp_GyroX_VarMax
                        	Data_Foot_State(i-j+1,2) = 0; 
                        else
                            break;
                        end                            
                    end                    
                end
            end  
        end        
    end    
    
    
    
    
	if LorR == 1   %�����������
        Data_Foot_L = Data_Foot;
        Data_Foot_L_Press = Data_Foot_Press;
        Data_Foot_L_State = Data_Foot_State;
    else
        %�����ҽŵ�����
        Data_Foot_R = Data_Foot;
        Data_Foot_R_Press = Data_Foot_Press;
        Data_Foot_R_State = Data_Foot_State;
    end  
    clear Temp_Foot_State Temp_GyroX_Mean Temp_GyroX_Num;
    clear Temp_GyroX_Var Temp_GyroX_VarMax Temp_Press Temp_Var;
    clear a b c d R1 Data_Foot Data_Foot_Press i j Temp_Vx Temp_Rx;    
end






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
    clear OnOff_IMUA OnOff_IMUB OnOff_UWB SerialNumber Data_IMUB;
    clear Origion_Foot_L Origion_IMUB_L Data_Foot_State ;