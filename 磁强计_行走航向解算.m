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

% 3. ���÷ֶξ�ֹ���ݽ��д�ǿ��У׼
Para_Calibration = [  1.000264037	-0.00004585	-0.006794537;
            -0.0051893	0.99927623	0.01848056;
            0.024396733	-0.00342088	0.998533567];
        
        
% 3.1 �ֶλ�ȡ�Ӽƺʹ�ǿ�� ��ֹʱ�����������ľ�ֵ

L = length(StaticRecord);
Mean_Acc = zeros(L,3);
Mean_Mag = zeros(L,3);
for i = 1:L
    Mean_Acc(i,:) = mean(IMU(StaticRecord(i,1):StaticRecord(i,2),2:4));
    Mean_Mag(i,:) = mean(Magnetic(ceil(StaticRecord(i,1)/2):ceil(StaticRecord(i,2)/2-1),2:4));
end

% 3.2 �Ƚ��Ӽƽ���У׼��Ȼ�����ˮƽ��̬����ȡ
Mean_Acc_Calibrat = zeros(L,3);
Mean_Att_Calibrat = zeros(L,3);
for i = 1:L
    Mean_Acc_Calibrat(i,:) = (Para_Calibration * (Mean_Acc(i,:))')';  
    [Mean_Att_Calibrat(i,1),Mean_Att_Calibrat(i,2)] = Att_Accel2Att(Mean_Acc_Calibrat(i,1),Mean_Acc_Calibrat(i,2),Mean_Acc_Calibrat(i,3));     
end

% 3.3 ����ǿ�Ƶ����ݽ���ˮƽ��ͶӰ
Mean_Mag_Level = zeros(L,3);
for i = 1:L
    C_b_n = Att_Euler2DCM(Mean_Att_Calibrat(i,:)');
    Mag = C_b_n*[Mean_Mag(i,:)'];
    Mean_Mag_Level(i,:) = Mag'; 
end

% 3.4 ��ǿ����Բ�����������
% A22 = [1.0001,0.0065848;0.0071925,0.91558];
% B21 = [7.4162;0.95541];

A22 = [1.0001,0.0075696;0.0081637,0.92732];
B21 = [8.2566;1.5906];
% 3.5 ���ò���У׼ˮƽͶӰ��Ĵ�ǿ������
Mean_Mag_Calibrat = zeros(L,2);
for i = 1:L
    Mean_Mag_Calibrat(i,1:2) = ((A22*Mean_Mag_Level(i,1:2)') - B21)';
end

% 3.5 ���ƱȽ�ͼ��
figure;
plot(Mean_Mag(:,1),Mean_Mag(:,2),'*-'); grid on; 
hold on; plot(0,0,'ro');
hold on; plot(Mean_Mag_Calibrat(:,1),Mean_Mag_Calibrat(:,2),'r*-');

% 3.6 ������ȡ���Ƚ�
Yaw = zeros(L,1);
Yaw_Calibrat = zeros(L,1);
for i = 1:L
    Yaw(i,1) = Att_Mag2Yaw(0,0,Mean_Mag_Level(i,1),Mean_Mag_Level(i,2),0);
    Yaw_Calibrat(i,1) = Att_Mag2Yaw(0,0,Mean_Mag_Calibrat(i,1),Mean_Mag_Calibrat(i,2),0);
end
Yaw = Yaw .*(-180/pi);
Yaw_Calibrat = Yaw_Calibrat .*(-180/pi);
figure;
plot(Yaw,'*-'); grid on; 
hold on; plot(Yaw_Calibrat,'r*-');


