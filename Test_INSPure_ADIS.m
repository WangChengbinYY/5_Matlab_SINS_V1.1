% ���ߵ�������ԡ������ߵ��豸
% �������   ADIS16467
clear;clc;
load('D:/IMUGPS2_200_152350.mat');
Data_IMU_R = IMU;
%% һ����ʼ��
% 1. ��ֵ��ʼ��
G_Const = CONST_Init();

% 3. ���������趨
G_IMU.Hz = 200;                         %IMU�Ĳ���Ƶ��

% 4. ��ʼ��̬���ٶȡ�λ���趨
G_Start_Att(1,1) = deg2rad(10);   %��̬ ������ ��
G_Start_Att(2,1) = deg2rad(5);   %��̬ ����� ��
G_Start_Att(3,1) = deg2rad(-20);   %��̬ ����� (��ƫ��Ϊ������)
G_Start_Vel(1,1) = 200.0;                 %�ٶ� v_e �����ٶ�
G_Start_Vel(2,1) = 100.0;                 %�ٶ� v_n �����ٶ�
G_Start_Vel(3,1) = 50.0;                 %�ٶ� v_u �����ٶ�
G_Start_Pos(1,1) = 34.1 * G_Const.D2R;   %λ�� γ�� ��
G_Start_Pos(2,1) = 114.1 * G_Const.D2R;   %λ�� ���� ��
G_Start_Pos(3,1) = 50.0 * G_Const.D2R;   %λ�� �߳� m

% Bias_Gyro = [-8.6012e-04;7.3177e-04;4.5023e-04];


%% �����߾��ȹߵ�����
% 1. ����׼��
[n,m] = size(Data_IMU_R);
Result_AVP = zeros(n,10);               %����Ľ�� ʱ�� ��̬ �ٶ� λ��
Result_AVP(1,1) = Data_IMU_R(1,1);     %ʱ��
Result_AVP(1,2:4) = G_Start_Att';       %��̬
Result_AVP(1,4) = -Result_AVP(1,4);

Result_AVP(1,5:7) = G_Start_Vel';       %�ٶ�
Result_AVP(1,8:10) = G_Start_Pos';       %λ��


INSData_Now = INS_DataInit(G_Const,Result_AVP(1,1),G_Start_Att,G_Start_Vel,G_Start_Pos,zeros(3,1),zeros(3,1),1/G_IMU.Hz);
INSData_Pre = INSData_Now;

% 2. ѭ������
for i=2:n
    INSData_Now.time = Data_IMU_R(i,1);    
    INSData_Now.w_ib_b = Data_IMU_R(i,5:7)';           
%     INSData_Now.f_ib_b = Data_IMU_R(i,2:4)'.*9.7803267714;
    INSData_Now.f_ib_b = [30;10;20];
    
    INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,1/G_IMU.Hz);
    
    if (INSData_Now.vel(1,1)^2+INSData_Now.vel(2,1)^2+INSData_Now.vel(3,1)^2) > 10
        INSData_Now.vel = zeros(3,1);
    end
    
    Result_AVP(i,1) = INSData_Now.time;      
    Result_AVP(i,2:4) = INSData_Now.att';
    Result_AVP(i,5:7) = INSData_Now.vel';
    Result_AVP(i,8:10) = INSData_Now.pos';
    Result_AVP(i,4) = -Result_AVP(i,4);
    INSData_Pre =  INSData_Now;
end
Plot_AVP(Result_AVP);
Result_AVP_old = Result_AVP;
save('D:/oldResultAVP.mat','Result_AVP_old');


% 
% %% ����MIMU�ߵ�����
% % 1. ����׼��
% [n,m] = size(Data_IMU_R);
% n = 10000;
% Result_AVP_MIMU = zeros(n,10);               %����Ľ�� ʱ�� ��̬ �ٶ� λ��
% Result_AVP_MIMU(1,1) = Data_IMU_R(1,1);     %ʱ��
% Result_AVP_MIMU(1,2:4) = G_Start_Att';       %��̬
% Result_AVP_MIMU(1,5:7) = G_Start_Vel';       %�ٶ�
% Result_AVP_MIMU(1,8:10) = G_Start_Pos';       %λ��
% 
% INSDataMIMU_Now = INS_DataInit(G_Const,Result_AVP_MIMU(1,1),G_Start_Att,G_Start_Vel,G_Start_Pos,Data_IMU_R(1,5:7)',Data_IMU_R(1,2:4)',1/G_IMU.Hz);
% INSDataMIMU_Pre = INSDataMIMU_Now;
% 
% % 2. ѭ������
% for i=2:n
%     INSDataMIMU_Now.time = Data_IMU_R(i,1);    
%     INSDataMIMU_Now.w_ib_b = Data_IMU_R(i,5:7)';           
%     INSDataMIMU_Now.f_ib_b = Data_IMU_R(i,2:4)';
%     
%     INSDataMIMU_Now = INS_Update_MIMU(G_Const,INSDataMIMU_Pre,INSDataMIMU_Now,1/G_IMU.Hz);
%     %INSDataMIMU_Now = INS_Update_MIMU_Test(G_Const,INSDataMIMU_Pre,INSDataMIMU_Now,1/G_IMU.Hz);
%     
%     Result_AVP_MIMU(i,1) = INSDataMIMU_Now.time;      
%     Result_AVP_MIMU(i,2:4) = INSDataMIMU_Now.att';
%     Result_AVP_MIMU(i,5:7) = INSDataMIMU_Now.vel';
%     Result_AVP_MIMU(i,8:10) = INSDataMIMU_Now.pos';
%   
%     INSDataMIMU_Pre =  INSDataMIMU_Now;
% end
% 
% %% ���ƱȽ�
% Plot_AVP(Result_AVP,Result_AVP_MIMU);




