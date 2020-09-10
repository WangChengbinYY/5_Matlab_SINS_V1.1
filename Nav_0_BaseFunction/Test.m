%% ���һ�£�������̬���ķ��������Ǹо��е㲻�� ���������һ�����ԣ����ǲ�֪������������
    % ŷ����ת��˳��  -Z X Y    X���� Y��� Z����  bϵ ��ǰ��
clear;
Att_Cal=[20;30;45].*pi/180;             %����õ��ļ�����̬��Ϣ ŷ����
C_Cal = Att_Euler2DCM(Att_Cal);         %������̬��Ϣ��Ӧ�� �任����
Q_Cal = Att_DCM2Q(C_Cal);               %������̬��Ϣ��Ӧ�� ��Ԫ��
R_Cal = m2rv(C_Cal);

Att_Measure=[5;12;12].*pi/180;       %�ⲿ�����ľ�ȷ��̬
C_Measure = Att_Euler2DCM(Att_Measure);
Q_Measure = Att_DCM2Q(C_Measure);
R_Measure = m2rv(C_Measure);

C_erro = C_Cal * C_Measure';
R_erro = m2rv(C_erro).*(180/pi)
Att_DCM2euler(C_erro).*(180/pi)

C_temp = (eye(3) + Math_v2m_askew(R_erro));
att_erro = Att_DCM2euler(C_temp);  
att_erro.*(180/pi)

C_new = (eye(3) + Math_v2m_askew(R_erro))*C_Cal;
Att_new = Att_DCM2euler(C_new);  
(Att_new - Att_Measure).*(180/pi)

% ������ʽ3
% Att_erro = Att_Cal - Att_Measure;
% C_new = (eye(3) + Math_v2m_askew(Att_erro))*C_Cal;
% Att_new = Att_DCM2euler(C_new);  
% (Att_new - Att_Measure).*(180/pi)

% ������ʽ2
% Q_erro = Math_QmulQ(Q_Cal,Math_Q2conj(Q_Measure));
% Q_new = Math_QmulQ(Math_Q2conj(Q_erro),Q_Cal); 
% C_new = Att_Q2DCM(Q_new); 
% Att_new = Att_DCM2euler(C_new);  
% (Att_new - Att_Measure).*(180/pi)

% ������ʽ0
C_erro = C_Cal * C_Measure';             %��̬������ת����
C_new = C_erro'*C_Cal;
Att_new = Att_DCM2euler(C_new);
(Att_new - Att_Measure).*(180/pi) 

C_erro = C_Cal * C_Measure'; 
Att_erro = Att_DCM2euler(C_erro);
Att_erro.*(180/pi) 

% ������ʽ1
    % �� ��̬���� ת��Ϊ ��Ԫ����ͨ������� ��˵� ������̬��Ԫ����
Q_erro = Att_Rv2Q(Att_erro);        % ��̬���� תΪ ��Ԫ�� Q_erro         
Q_erro = Math_Q2conj(Q_erro);       % ��Q_erro �� ����
Q_new = Math_QmulQ(Q_erro,Q_Cal);   % �� ������̬��Ԫ�� ���и��� (��������Ԫ��)
C_new = Att_Q2DCM(Q_new);           
Att_new = Att_DCM2euler(C_new);         

(Att_new - Att_Measure).*(180/pi)   % ���������̬ �� �ⲿ�����ľ�ȷ��̬ ���ĽǶ� �� ��   -0.0414 0.0998 0.0000
                                    % �ͺ����
                                    % �޲���ȥ�ˣ�ˮƽ��̬�ǲ�û�в��������������ĳ�����룬����Ҳ����������֪�������������

                                  
                                    
                                    
                                    
%%                                    
                                    
clear;
Att_erro=[2;2.5;45].*pi/180;
C_Cal = Att_Euler2DCM(Att_erro);
Q_Cal = Att_DCM2Q(C_Cal);

Att_Measure=[1.8;2.1;44].*pi/180;
C_Measure = Att_Euler2DCM(Att_Measure);
Q_Measure = Att_DCM2Q(C_Measure);

C_erro = C_Cal*C_Measure';



Att_erro = Att_erro - Att_Measure;
C_erro = Att_Euler2DCM(Att_erro)';
C_new = C_erro*C_Cal;
Att_new = Att_DCM2euler(C_new);

(Att_new - Att_Measure).*(180/pi)


