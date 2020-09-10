function INSData = INS_DataInit(G_Const,time,att,vel,pos,eb,db,T)
% ��ʼ���ߵ�����ṹ��
% ���룺G_Const ��ֵ����
%       time ����ʱ��
%       att[pitch roll yaw]'
%       vel[v_e v_n v_u]'
%       pos[lat lon h]'
%       eb[x y z]' - gyro constant bias (rad/s)    
%       db[x y z]' - acc constant bias (m/s)
%       T  �������

%% ��Ҫ������
    INSData.time = time; 
    INSData.att = att;
    INSData.vel = vel;
    INSData.pos = pos;
       
%% ����������
    INSData.w_ib_b = zeros(3,1);                    %������� ������
    INSData.DeltaTheta_ib_b = zeros(3,1);         %������� ������
    INSData.f_ib_b = zeros(3,1);                     %�Ӽ���� ���ٶ�
    INSData.DeltaV_ib_b = zeros(3,1);              %�Ӽ���� �ٶ�����
    
    INSData.eb = eb;   %xyz������ƫ
    INSData.db = db;   %xyz�Ӽ���ƫ
%% ��̬����ת��
    INSData.C_b_n = Att_Euler2DCM(INSData.att);
    INSData.Q_b_n = Att_DCM2Q(INSData.C_b_n);    
    
%% �м��������
    INSData.DeltaTheta_in_n = [0.0;0.0;0.0];                %nϵ��ת���ۻ�
    INSData.DeltaV_n        = [0.0;0.0;0.0];                %vn�ٶ����� v(m)=v(m-1)+DeltaV_n
    INSData.Rmh             = Earth_get_Rmh(G_Const,pos(1,1),pos(3,1));
    INSData.Rnh             = Earth_get_Rnh(G_Const,pos(1,1),pos(3,1));
    INSData.w_ie_n          = Earth_get_w_ie_n(G_Const,pos(1,1));
    INSData.w_en_n          = Earth_get_w_en_n(pos(1,1),INSData.vel,INSData.Rmh,INSData.Rnh);
    INSData.w_in_n          = INSData.w_ie_n+INSData.w_en_n;
    INSData.wie             = G_Const.earth_wie;
    INSData.f_ib_n          = zeros(3,1);    
    

    
    
    
    
    
    