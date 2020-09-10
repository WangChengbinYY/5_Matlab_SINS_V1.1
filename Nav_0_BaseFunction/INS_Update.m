function INSData_Now = INS_Update(G_Const,insdata_pre,insdata_now,T)
% 1�������Խ��㣬ʱ�����
% 2���ѿ�����ת������ �߾��ȹߵ�Ӧ��


%% һ��������Ҫ����Ϣ
T_DeltaTime = T;                    %�������ʱ�� ����ֱ�����ò���Ƶ�ʼ��㣬Ҳ�������ò����������(��ֹ����)
% T_DeltaTime = insdata_now.time - insdata_pre.time;

%% �����ٶȸ��¼���
% �ٶȵĸ��µ�����һʱ�̵��ٶ� ���� Delta_Vn_sf �� Delta_Vn_cor
%-----------------------------------------------------------------
%--------------------------Delta_Vn_cor---------------------------
%-----------------------------------------------------------------
% ���� Delta_Vn_cor �ļ����ǹ��� w_ie_n w_in_n g_n ���ڲ�������ڼ�仯С��ֱ�Ӳ����м���ֵ���м���
% 1. ����(m-1/2)ʱ�̵��ٶ�Vn
T_Vn_half = insdata_pre.vel+ 0.5*insdata_pre.DeltaV_n;
% 2. ����(m-1/2)ʱ�̵�λ��pos
%   �������������������ߵľ���
T_Delta_Distance = (insdata_pre.vel+T_Vn_half)*T_DeltaTime/4.0;
%   �������������������ߵľ��� ��λ�õ�����
T_Delta_Pos(1,1) = T_Delta_Distance(2,1)/insdata_pre.Rmh;   %γ������
T_Delta_Pos(2,1) = T_Delta_Distance(1,1)/insdata_pre.Rnh/cos(insdata_pre.pos(1,1));  %��������
T_Delta_Pos(3,1) = T_Delta_Distance(3,1);        %�߳�����
T_Pos_half = insdata_pre.pos+T_Delta_Pos;
% 3. ����(m-1/2)ʱ�̵�λ��pos �����µ�Rmh Rnh 
T_Rmh = Earth_get_Rmh(G_Const,T_Pos_half(1,1),T_Pos_half(3,1));
T_Rnh = Earth_get_Rnh(G_Const,T_Pos_half(1,1),T_Pos_half(3,1));
% 4. ����(m-1/2)ʱ�̵�λ��vn pos ����w_ie_n,w_en_n,w_in_n
T_w_ie_n = Earth_get_w_ie_n(G_Const,T_Pos_half(1,1));
T_w_en_n = Earth_get_w_en_n(T_Pos_half(1,1),T_Vn_half,T_Rmh,T_Rnh);
T_w_in_n = T_w_ie_n+T_w_en_n;
% 5. ����(m-1/2)ʱ�̵�λ��pos ��Ӧ��gn
T_gn_half = Earth_get_g_n(G_Const,T_Pos_half(1,1),T_Pos_half(3,1));
% 6. ���� Delta_Vn_cor 
T_Delta_Vn_cor = (-cross((T_w_in_n+T_w_ie_n),T_Vn_half)+T_gn_half)*T_DeltaTime;
%-----------------------------------------------------------------
%--------------------------Delta_Vn_sf---------------------------
%-----------------------------------------------------------------
% Delta_Vn_sf �����������֣�һ�����ǼӼƵ��ۻ�������
%   һ������ ��ת������ Delta_Vn_rot
%   һ������ ���������� Delta_Vn_scull
% 1. ����(m)��ǰʱ�� �������� �� �Ӽ�����
%   ������� ������
insdata_now.DeltaTheta_ib_b = (insdata_now.w_ib_b+insdata_pre.w_ib_b)*T_DeltaTime/2;
%   �Ӽ���� �ٶ�����
insdata_now.DeltaV_ib_b = (insdata_now.f_ib_b+insdata_pre.f_ib_b)*T_DeltaTime/2;
% 2. ���� DeltaV_rot_b
T_DeltaV_rot_b = 0.5*cross(insdata_now.DeltaTheta_ib_b,insdata_now.DeltaV_ib_b);
% 3. ���� DeltaV_scull_b
TempV = cross(insdata_pre.DeltaTheta_ib_b,insdata_now.DeltaV_ib_b);
TempV1 = cross(insdata_pre.DeltaV_ib_b,insdata_now.DeltaTheta_ib_b);
T_DeltaV_scull_b = (TempV+TempV1)/12.0;
% 4. ���� DeltaV_sf_n
TempM = eye(3) - Math_v2m_askew(T_w_in_n)*T_DeltaTime/2.0;
T_DeltaV_sf_n = TempM*insdata_pre.C_b_n*(insdata_now.DeltaV_ib_b+T_DeltaV_rot_b+T_DeltaV_scull_b);
%-----------------------------------------------------------------
%--------------------------Delta_Vn-------------------------------
%-----------------------------------------------------------------
% 1. ���� ��ǰʱ�̵��ٶ�����INSData.DeltaV_n
insdata_now.DeltaV_n = T_DeltaV_sf_n + T_Delta_Vn_cor;
% 2. ���� ��ǰʱ�̵��ٶ�
insdata_now.vel = insdata_pre.vel + insdata_now.DeltaV_n;

%% ����λ�ø���
% ���� ���λ��ָ��·������ü����(m)ʱ���ٶ� ���м���
T_Delta_Distance = (insdata_pre.vel+insdata_now.vel)*T_DeltaTime/2.0;
TempV(1,1) = T_Delta_Distance(2,1)/T_Rmh;                       %γ������
TempV(2,1) = T_Delta_Distance(1,1)/T_Rnh/cos(T_Pos_half(1,1));  %��������
TempV(3,1) = T_Delta_Distance(3,1);                             %�߳�����
% λ�õĸ���
insdata_now.pos = insdata_pre.pos+TempV;
    
%% �ġ���̬����    
% ������תʸ������ ��Ԫ�� ��Ȼ��������Ԫ��������̬
% 1. ����nϵ��(m-1)ʱ�̵�(m)ʱ�̵���ת��Ԫ�� Q_n(m-1)_n(m)
%   �����µ� �ٶ� λ�ã����¼��� w_in_n �������㵱ǰʱ�̵�DeltaTheta_in_n
insdata_now.w_ie_n = Earth_get_w_ie_n(G_Const,insdata_now.pos(1,1));
insdata_now.Rmh = Earth_get_Rmh(G_Const,insdata_now.pos(1,1),insdata_now.pos(3,1));
insdata_now.Rnh = Earth_get_Rnh(G_Const,insdata_now.pos(1,1),insdata_now.pos(3,1));
insdata_now.w_en_n = Earth_get_w_en_n(insdata_now.pos(1,1),insdata_now.vel,insdata_now.Rmh,insdata_now.Rnh);
insdata_now.w_in_n = insdata_now.w_ie_n+insdata_now.w_en_n;
insdata_now.DeltaTheta_in_n = (insdata_pre.w_in_n+insdata_now.w_in_n)*T_DeltaTime/2.0;
%   ��ǰһʱ�̺͵�ǰʱ�̵� DeltaTheta_in_n �����Ӧ����תʸ�� Phi_in_n
T_Phi_in_n = insdata_now.DeltaTheta_in_n + cross(insdata_pre.DeltaTheta_in_n,insdata_now.DeltaTheta_in_n)/12.0;
%   ���� nϵ�� ��ת��Ԫ�� Q_n(m-1)_n(m)
T_Q_nm_nm_1 = Att_Rv2Q(T_Phi_in_n);
T_Q_nm_1_nm = Math_Q2conj(T_Q_nm_nm_1);
% 2. ����bϵ��(m)ʱ�̵�(m-1)ʱ�̵���ת��Ԫ�� Q_b(m)_b(m-1)
%   ����(m-1)��(m)ʱ�̵�������������� ��תʸ�� Phi_ib_b
T_Phi_ib_b = insdata_now.DeltaTheta_ib_b + cross(insdata_pre.DeltaTheta_ib_b,insdata_now.DeltaTheta_ib_b)/12.0;
T_Q_bm_bm_1 = Att_Rv2Q(T_Phi_ib_b);
% 3. ���㵱ǰʱ����̬��Ӧ����Ԫ�� Q_b_n
insdata_now.Q_b_n = Math_QmulQ(Math_QmulQ(T_Q_nm_1_nm,insdata_pre.Q_b_n),T_Q_bm_bm_1);
% 4. �����Ӧ����̬�������� C_b_n
%   �� ��Ԫ�� ����Ӧ�� DCM
insdata_now.C_b_n = Att_Q2DCM(insdata_now.Q_b_n);
%   �� DCM ���� ��ǰʱ�̵���̬
insdata_now.att = Att_DCM2euler(insdata_now.C_b_n);

%% �塢�����������   
INSData_Now = insdata_now;
INSData_Now.f_ib_n          = INSData_Now.C_b_n*INSData_Now.f_ib_b;
INSData_Now.Rmh             = Earth_get_Rmh(G_Const,INSData_Now.pos(1,1),INSData_Now.pos(3,1));
INSData_Now.Rnh             = Earth_get_Rnh(G_Const,INSData_Now.pos(1,1),INSData_Now.pos(3,1));
INSData_Now.w_ie_n          = Earth_get_w_ie_n(G_Const,INSData_Now.pos(1,1));
INSData_Now.w_en_n          = Earth_get_w_en_n(INSData_Now.pos(1,1),INSData_Now.vel,INSData_Now.Rmh,INSData_Now.Rnh);
INSData_Now.w_in_n          = INSData_Now.w_ie_n+INSData_Now.w_en_n;


   
    

    
