% Ðý×ªÊ¸Á¿²¹³¥
att = [1.0257;1.4789;1.9846].*(pi/180);
C_b_n = Att_Euler2DCM(att);
Q_b_n = Att_DCM2Q(C_b_n);

error_att = att;
Q_b_n_new = Math_QmulQ(Math_Q2conj(Att_Rv2Q(error_att)), Q_b_n);
C_b_n_new = Att_Q2DCM(Q_b_n_new);
att_new = Att_DCM2euler(C_b_n_new).*(180/pi)

%¾«Ï¸»¯ Ðý×ªÊ¸Á¿²¹³¥
att = [1.0257;1.4789;1.9846].*(pi/180);
C_b_n = Att_Euler2DCM(att);
Q_b_n = Att_DCM2Q(C_b_n);

error_att = att;
C_b_n_error = Att_Euler2DCM(error_att);
Q_b_n_error = Att_DCM2Q(C_b_n_error);
Q_b_n_new = Math_QmulQ(Math_Q2conj(Q_b_n_error), Q_b_n);
C_b_n_new = Att_Q2DCM(Q_b_n_new);
att_new = Att_DCM2euler(C_b_n_new).*(180/pi)

% ·½ÏòÓàÏÒ¾ØÕó²¹³¥
att = [1.0257;1.4789;1.9846].*(pi/180);
C_b_n = Att_Euler2DCM(att);


error_att = att;
C_error = Att_Euler2DCM(error_att)';
C_b_n_new = C_error*C_b_n;
att_new = Att_DCM2euler(C_b_n_new).*(180/pi)