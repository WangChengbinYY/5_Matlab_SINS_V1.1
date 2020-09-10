%% ����ʵ��  ����ֹ״̬����ȡ�� ˮƽ�ͺ���� ������һ��

% 1. ��ȡ��ֹ���ݶε���ʼ�ͽ�β���
    L = length(FootPres_State);
    j = 1;
    TStart = 0;  %�ж��Ƿ���뾲ֹ�׶�
    for i = 1:L
        %��һ������ж�
        if i == 1
            if FootPres_State(1,2) == 1
                TStart = 1;  %���뾲ֹ�׶�
                StaticRecord(1,1) = 1;
            end
        else
            if FootPres_State(i,2) ~= FootPres_State(i-1,2)
               % ״̬�����仯
               if FootPres_State(i-1,2) == 1
                  % ����β��
                  StaticRecord(j,2) = i;
                  j = j+1;
               else
                  % ��ʱ�εĿ�ʼ
                  StaticRecord(j,1) = i;
               end
            end
        end  
    end
    % ���ӽ�β�ж�
    if StaticRecord(j,2) == 0
        StaticRecord(j,2) = L;
    end
    
% 2. ���÷ֶξ�ֹ���ݽ��� ��̬�ǵ���ȡ
    Att = zeros(L,4);
    Att(:,1) = Result_1(:,1);
% 2.1 �ֶλ�ȡ�Ӽƺʹ�ǿ�� ��ֹʱ�����������ľ�ֵ
    L = length(StaticRecord);
    Mean_Acc = zeros(L,3);
    Mean_Mag = zeros(L,3);
    for i = 1:L
        Mean_Acc(i,:) = mean(IMU(StaticRecord(i,1):StaticRecord(i,2),2:4));
        Mean_Mag(i,:) = mean(Magnetic(ceil(StaticRecord(i,1)/2):ceil(StaticRecord(i,2)/2-1),2:4));
    end

% 2.2 �Ƚ��Ӽƽ���У׼��Ȼ�����ˮƽ��̬����ȡ
    % �ӼƷ����� У������
    Acc_Calibrat = [1.000264037	-0.00004585	-0.006794537;
                    -0.0051893  0.99927623	0.01848056;
                    0.024396733	-0.00342088	0.998533567];  
    Mean_Acc_Calibrat = zeros(L,3);
    Mean_Att_Calibrat = zeros(L,3);
    for i = 1:L
        Mean_Acc_Calibrat(i,:) = (Acc_Calibrat * Mean_Acc(i,:)')';  
        [Mean_Att_Calibrat(i,1),Mean_Att_Calibrat(i,2)] = Att_Accel2Att(Mean_Acc_Calibrat(i,1),Mean_Acc_Calibrat(i,2),Mean_Acc_Calibrat(i,3));     
    end
    
% 2.3 ����ǿ�Ƶ����ݽ���ˮƽ��ͶӰ У������ȡ����
    Mean_Mag_Level = zeros(L,3);
    for i = 1:L
        C_b_n = Att_Euler2DCM(Mean_Att_Calibrat(i,:)');
        Mag = C_b_n*[Mean_Mag(i,:)'];
        Mean_Mag_Level(i,:) = Mag'; 
    end        
    % ��ǿ��У������
    Mag_A22 = [1.0001,0.0065848;0.0071925,0.91558];
    Mag_B21 = [7.4162;0.95541];
    Mean_Mag_Calibrat = zeros(L,2);
    for i = 1:L
        Mean_Mag_Calibrat(i,1:2) = ((Mag_A22*Mean_Mag_Level(i,1:2)') - Mag_B21)';
    end
    % ��ȡ����
    for i = 1:L
        Mean_Att_Calibrat(i,3) = -Att_Mag2Yaw(0,0,Mean_Mag_Calibrat(i,1),Mean_Mag_Calibrat(i,2),0);
    end   
    
% 3. ����̬�����Ӧ�������
    L = length(StaticRecord);
    for i=1:L
        for j = StaticRecord(i,1):StaticRecord(i,2)
            Att(j,2:4) = Mean_Att_Calibrat(i,1:3);
        end
    end
    

    Plot_AVP_Group_Test(Att,Result_4);
 
    