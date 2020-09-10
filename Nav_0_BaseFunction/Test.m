%% 请教一下，对于姿态误差的反馈，总是感觉有点不对 做了下面的一个测试，但是不知道问题在哪里
    % 欧拉角转动顺序  -Z X Y    X俯仰 Y横滚 Z航向  b系 右前上
clear;
Att_Cal=[20;30;45].*pi/180;             %假设得到的计算姿态信息 欧拉角
C_Cal = Att_Euler2DCM(Att_Cal);         %计算姿态信息对应的 变换矩阵
Q_Cal = Att_DCM2Q(C_Cal);               %计算姿态信息对应的 四元数
R_Cal = m2rv(C_Cal);

Att_Measure=[5;12;12].*pi/180;       %外部测量的精确姿态
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

% 反馈方式3
% Att_erro = Att_Cal - Att_Measure;
% C_new = (eye(3) + Math_v2m_askew(Att_erro))*C_Cal;
% Att_new = Att_DCM2euler(C_new);  
% (Att_new - Att_Measure).*(180/pi)

% 反馈方式2
% Q_erro = Math_QmulQ(Q_Cal,Math_Q2conj(Q_Measure));
% Q_new = Math_QmulQ(Math_Q2conj(Q_erro),Q_Cal); 
% C_new = Att_Q2DCM(Q_new); 
% Att_new = Att_DCM2euler(C_new);  
% (Att_new - Att_Measure).*(180/pi)

% 反馈方式0
C_erro = C_Cal * C_Measure';             %姿态误差的旋转矩阵
C_new = C_erro'*C_Cal;
Att_new = Att_DCM2euler(C_new);
(Att_new - Att_Measure).*(180/pi) 

C_erro = C_Cal * C_Measure'; 
Att_erro = Att_DCM2euler(C_erro);
Att_erro.*(180/pi) 

% 反馈方式1
    % 将 姿态误差角 转化为 四元数，通过共轭后 左乘到 计算姿态四元数上
Q_erro = Att_Rv2Q(Att_erro);        % 姿态误差角 转为 四元数 Q_erro         
Q_erro = Math_Q2conj(Q_erro);       % 对Q_erro 求 共轭
Q_new = Math_QmulQ(Q_erro,Q_Cal);   % 对 计算姿态四元数 进行更新 (左乘误差四元数)
C_new = Att_Q2DCM(Q_new);           
Att_new = Att_DCM2euler(C_new);         

(Att_new - Att_Measure).*(180/pi)   % 补偿后的姿态 和 外部测量的精确姿态 相差的角度 度 ：   -0.0414 0.0998 0.0000
                                    % 就航向角
                                    % 修补回去了，水平姿态角并没有补偿，看了其它的程序代码，好像也是这样，不知道哪里出了问题

                                  
                                    
                                    
                                    
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


