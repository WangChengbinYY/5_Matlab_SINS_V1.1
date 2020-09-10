%% ◊ÀÃ¨ŒÛ≤Ó≤π≥• ≤‚ ‘
clear; clc;
Att_base = [1 5 10 15 20 25 45 55 70].*(pi/180);
Att_error = [0.1:0.001:5]*pi/180;
figure;
for i = 1:length(Att_base)
    Att_theory = [Att_base(1,i);Att_base(1,i);Att_base(1,i)];  %¿Ì¬€÷µ    
    for j = 1:length(Att_error)
        Att_measure = Att_theory + [Att_error(1,j);Att_error(1,j);Att_error(1,j)]; 
        error_feedback = Att_measure - Att_theory;
        C_measure = Att_Euler2DCM(Att_measure);
        Q_measure = Att_DCM2Q(C_measure); 
        Q_new = Math_QmulQ(Math_Q2conj(Att_Rv2Q(error_feedback)), Q_measure);   
        C_new = Att_Q2DCM(Q_new);
     


%       C_measure = Att_Euler2DCM(Att_measure);
%       C_theory = Att_Euler2DCM(Att_theory);
%       error_feedback = Att_DCM2euler(C_measure*C_theory');      
%       C_error = Att_Euler2DCM(error_feedback)';
%       C_new = C_error*C_measure;
      
      Att_new = Att_DCM2euler(C_new);
      Att_cha(j,1:3) = (Att_new - Att_theory)';
   end    
   hold on; plot(Att_error.*(180/pi),Att_cha(:,3).*(180/pi));
end
legend('1','5','10','15','20','25','45','55','70');