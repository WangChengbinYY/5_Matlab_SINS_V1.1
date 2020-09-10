function G_Const = CONST_Init()
%��ʼ�� ȫ�ֱ�������ֵ

%% ��λ�������
    G_Const.PI         = 3.141592653589793;               %����ʹ��Ϊpi��C�����к궨��    
    G_Const.D2R        = G_Const.PI/180.0;                   %��ת����
    G_Const.R2D        = 180.0/G_Const.PI;                   %����ת��

    G_Const.g0         = 9.7803267714;                    %��λ��m/s2
    G_Const.mg         = 1.0e-3*G_Const.g0;                  %��λ��m/s2
    G_Const.ug         = 1.0e-6*G_Const.g0;                  %��λ��m/s2
    G_Const.mGal       = 1.0e-3*0.01;                     %��λ��m/s2
    
%% ����ֵ����    
    G_Const.earth_wie   = 7.2921151467e-5;              %������ת���ٶ� ���� ��λ������/s
    G_Const.earth_f     = 0.003352813177897;
    G_Const.earth_Re    = 6378137;                      %��λ��m
    G_Const.earth_e     = 0.081819221455524;    
    G_Const.earth_g0    = 9.7803267714;                 %��λ��m/s2   
        