function INSData_Now = INS_Update_MIMU(G_Const,insdata_pre,insdata_now,T)
% 1�������Խ��㣬ʱ�����
% 2��Ӧ���ڵͳɱ���MIMU���򻯹ߵ����㾫��
% 3��������̬�������ת��� �� �ٶȵ� (2*w_ie_n+w_en_n)xV_en_n �к����
% 4����̬���ٶȡ�λ�þ����ü�ģ��


%% һ��������Ҫ����Ϣ
T_DeltaTime = T;                    %�������ʱ�� ����ֱ�����ò���Ƶ�ʼ��㣬Ҳ�������ò����������(��ֹ����)
% T_DeltaTime = insdata_now.time - insdata_pre.time;

%% �����򻯰���̬����
%   ֱ��������������������������ֱ�ӵ�����תʸ��
insdata_now.DeltaTheta_ib_b = (insdata_now.w_ib_b+insdata_pre.w_ib_b)*T_DeltaTime/2;
T_Phi_ib_b = insdata_now.DeltaTheta_ib_b;
T_Q_bm_bm_1 = Att_Rv2Q(T_Phi_ib_b);
insdata_now.Q_b_n = Math_QmulQ(insdata_pre.Q_b_n,T_Q_bm_bm_1);
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
 
%% �ġ������������   
INSData_Now = insdata_now;
% ʵ��ʹ�ÿ��Բ��ø���
INSData_Now.f_ib_n          = INSData_Now.C_b_n*INSData_Now.f_ib_b;
INSData_Now.Rmh             = Earth_get_Rmh(G_Const,INSData_Now.pos(1,1),INSData_Now.pos(3,1));
INSData_Now.Rnh             = Earth_get_Rnh(G_Const,INSData_Now.pos(1,1),INSData_Now.pos(3,1));
INSData_Now.w_ie_n          = Earth_get_w_ie_n(G_Const,INSData_Now.pos(1,1));
INSData_Now.w_en_n          = Earth_get_w_en_n(INSData_Now.pos(1,1),INSData_Now.vel,INSData_Now.Rmh,INSData_Now.Rnh);
INSData_Now.w_in_n          = INSData_Now.w_ie_n+INSData_Now.w_en_n;