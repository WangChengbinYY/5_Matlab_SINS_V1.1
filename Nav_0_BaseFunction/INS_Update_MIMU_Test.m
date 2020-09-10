function INSData_Now = INS_Update_MIMU_Test(G_Const,insdata_pre,insdata_now,T)
% 1�������Խ��㣬ʱ�����
% 2��Ӧ�����ڵͳɱ���MIMU���򻯹ߵ����㾫��
% 3����̬���ø߾������ģ�ͣ��ٶȡ�λ�ò��ü����ģ��


%% һ��������Ҫ����Ϣ
T_DeltaTime = T;                    %�������ʱ�� ����ֱ�����ò���Ƶ�ʼ��㣬Ҳ�������ò����������(��ֹ����)
% T_DeltaTime = insdata_now.time - insdata_pre.time;

%% ����������̬����    
% ������תʸ������ ��Ԫ�� ��Ȼ��������Ԫ��������̬
% 1. ����nϵ��(m-1)ʱ�̵�(m)ʱ�̵���ת��Ԫ�� Q_n(m-1)_n(m)
%   �����µ� �ٶ� λ�ã����¼��� w_in_n �������㵱ǰʱ�̵�DeltaTheta_in_n
insdata_now.w_ie_n = Earth_get_w_ie_n(G_Const,insdata_pre.pos(1,1));
insdata_now.Rmh = Earth_get_Rmh(G_Const,insdata_pre.pos(1,1),insdata_pre.pos(3,1));
insdata_now.Rnh = Earth_get_Rnh(G_Const,insdata_pre.pos(1,1),insdata_pre.pos(3,1));
insdata_now.w_en_n = Earth_get_w_en_n(insdata_pre.pos(1,1),insdata_pre.vel,insdata_pre.Rmh,insdata_pre.Rnh);
insdata_now.w_in_n = insdata_now.w_ie_n+insdata_now.w_en_n;
insdata_now.DeltaTheta_in_n = (insdata_pre.w_in_n+insdata_now.w_in_n)*T_DeltaTime/2.0;
%   ��ǰһʱ�̺͵�ǰʱ�̵� DeltaTheta_in_n �����Ӧ����תʸ�� Phi_in_n
T_Phi_in_n = insdata_now.DeltaTheta_in_n + cross(insdata_pre.DeltaTheta_in_n,insdata_now.DeltaTheta_in_n)/12.0;
%   ���� nϵ�� ��ת��Ԫ�� Q_n(m-1)_n(m)
T_Q_nm_nm_1 = Att_Rv2Q(T_Phi_in_n);
T_Q_nm_1_nm = Math_Q2conj(T_Q_nm_nm_1);
% 2. ����bϵ��(m)ʱ�̵�(m-1)ʱ�̵���ת��Ԫ�� Q_b(m)_b(m-1)
%   ����(m-1)��(m)ʱ�̵�������������� ��תʸ�� Phi_ib_b
insdata_now.DeltaTheta_ib_b = (insdata_now.w_ib_b+insdata_pre.w_ib_b)*T_DeltaTime/2;
T_Phi_ib_b = insdata_now.DeltaTheta_ib_b + cross(insdata_pre.DeltaTheta_ib_b,insdata_now.DeltaTheta_ib_b)/12.0;
T_Q_bm_bm_1 = Att_Rv2Q(T_Phi_ib_b);
% 3. ���㵱ǰʱ����̬��Ӧ����Ԫ�� Q_b_n
insdata_now.Q_b_n = Math_QmulQ(Math_QmulQ(T_Q_nm_1_nm,insdata_pre.Q_b_n),T_Q_bm_bm_1);
% 4. �����Ӧ����̬�������� C_b_n
%   �� ��Ԫ�� ����Ӧ�� DCM
insdata_now.C_b_n = Att_Q2DCM(insdata_now.Q_b_n);
%   �� DCM ���� ��ǰʱ�̵���̬
insdata_now.att = change_DCM2euler(insdata_now.C_b_n);

%% �����򻯰��ٶȸ���
%   ��ǰʱ�̵ļ��ٶ������ �ٶ�����
insdata_now.DeltaV_ib_b = (insdata_now.f_ib_b+insdata_pre.f_ib_b)*T_DeltaTime/2;
T_Delta_Vn = insdata_now.C_b_n * (insdata_now.DeltaV_ib_b + cross(insdata_now.DeltaTheta_ib_b,insdata_now.DeltaV_ib_b)/2);
T_gn = Earth_get_g_n(G_Const,insdata_pre.pos(1,1),insdata_pre.pos(3,1));
insdata_now.vel = insdata_pre.vel + T_Delta_Vn + T_gn*T;

%% �����򻯰�λ�ø���
% ���� ���λ��ָ��·������ü����(m)ʱ���ٶ� ���м���
T_Delta_Distance = (insdata_pre.vel+insdata_now.vel)*T_DeltaTime/2.0;
T_Rmh = Earth_get_Rmh(G_Const,insdata_pre.pos(1,1),insdata_pre.pos(3,1));
T_Rnh = Earth_get_Rnh(G_Const,insdata_pre.pos(1,1),insdata_pre.pos(3,1));
TempV(1,1) = T_Delta_Distance(2,1)/T_Rmh;                       %γ������
TempV(2,1) = T_Delta_Distance(1,1)/T_Rnh/cos(insdata_pre.pos(1,1));  %��������
TempV(3,1) = T_Delta_Distance(3,1);                             %�߳�����
% λ�õĸ���
insdata_now.pos = insdata_pre.pos+TempV;
 
INSData_Now = insdata_now;