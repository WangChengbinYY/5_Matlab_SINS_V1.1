% ����YGM�ĳ������ �������ݵ�����
clear all
glvs
ts = 1/200;       % ����ʱ��
avp0 = avpset([4.5;5.5;85], 0, [34.2;108.9;400.0]);    % ��ʼ��̬�ٶ�λ��
% �켣���
% trajectory segment setting
xxx = [];
seg = trjsegment(xxx, 'init',         0);      %��ʼ��ֹ״̬ 
seg = trjsegment(seg, 'uniform',      60*30);    %��ֹ״̬ ���� 100s
% ���� ��������
trj = trjsimu(avp0, seg.wat, ts, 1);
trjfile('trj10ms.mat', trj);
% ���� IMU ���� �� ���۵�������  ע�⣺�������ɵ�����������ģʽ
% insplot(trj.avp);
% imuplot(trj.imu);

%---------- һ�����ո߾��ȹߵ�ϵͳ������ �������
% % Example:
%     For inertial grade SIMU, typical errors are:
%       eb=0.01dph, db=50ug, web=0.001dpsh, wdb=10ugpsHz
%       scale factor error=10ppm, askew installation error=10arcsec
%       sqrtR0G=0.001dph, taug=1000s, sqrtR0A=10ug, taug=1000s
%    then call this funcion by
%       imuerr = imuerrset(0.01,100,0.001,10, 0.001,1000,10,1000, 10,10,10,10);%
%   ��1�������� ��ֹ״̬���������� 
%   ������ƫ 0.01��  ���ݽǶ�������� 0.001(deg/sqrt(h)) 
%------------------------------------------
%imuerr = imuerrset(0.01, 0, 0.001, 0);  %�߾���
imuerr = imuerrset(30, 0, 500, 0);  %�;���
imu = imuadderr(trj.imu, imuerr);
% imu = trj.imu;  %��������������
L = length(imu);
IMU = zeros(L,7);
IMU(:,1) = imu(:,end);
IMU(:,2:4) = imu(:,4:6)./((imu(2,end)-imu(1,end))*glv.g0);
IMU(:,5:7) = imu(:,1:3)./(imu(2,end)-imu(1,end));

avp_Result = inspure(imu, avp0);
avperr = avpcmp(avp_Result, trj.avp);
L = length(avp_Result);
Result_att = zeros(L,4);
Result_att(:,1) = avp_Result(:,end);
Result_att(:,2:4) = avp_Result(:,1:3);
inserrplot(avperr);

save('D:\N_WorkSpace_GitHub\5_Matlab\5_Matlab_SINS_V1.1\0_ʵ������\IMU_Simulate_Low.mat','IMU','Result_att');
%clear all;



