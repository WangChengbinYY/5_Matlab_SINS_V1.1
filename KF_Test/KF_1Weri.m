% 一维 KF滤波测试

%% 模拟数据
% clear;clc;
% Ts = 1/200;
% L = 60*60/Ts;
% nn = 10;
% % a数据仿真
% a_var = 1e-04;
% a_const = 0.6;
% Noise = wgn(1,L,10*log10(a_var))'; Noise = Noise-mean(Noise);
% a = Noise + a_const;
% % V数据仿真
% V_var = (0.005)^2;
% V_const = 0;
% Noise = wgn(1,fix(L/nn),10*log10(V_var))'; Noise = Noise-mean(Noise);
% V = Noise + V_const;
% 
% % 理论值为
% V_theory = zeros(L,1);
% for i = 2:L
%    V_theory(i,1) = V_theory(i-1,1) + (a(i-1,1)-a_const)*Ts; 
% end
% save('D:\N_WorkSpace_GitHub\5_Matlab\5_Matlab_SINS_V1.1\0_实验数据\KF_1Wei.mat','a','V_theory','V','nn','Ts');
% figure; plot(V);title('V');
% figure; plot(V_theory); title('V theory');


%% 一维KF滤波
clear;clc;
load('D:\N_WorkSpace_GitHub\5_Matlab\5_Matlab_SINS_V1.1\0_实验数据\KF_1Wei.mat');
L = length(a);
nn = 10;
a_var = 1e-08;
    %Xk = [0.1;0.1];
    Xk = [1;1];
    Pk = diag([1,1])^2;
    Xk_1 = zeros(2,1);
    Pkk_1 = zeros(2,2);
    Ft = zeros(2,2); Ft(1,2) = 1;  
    Zk = 0;
    Hk = [1,0];
    Gk_1 = [0;1];
    Qk_1 = Gk_1*a_var*Gk_1';
    Rk = (0.002)^2;
    Phikk_1 = eye(2);
    a_biase_KF = 2;
    V_KF = zeros(L,1);
    V_biase_KF = zeros(L,1);
    V_biase_KF(1,1) = a_biase_KF;
    XkPk = zeros(fix(L/nn),4);
    j = 1;
    for i = 2:L
       V_KF(i,1) = V_KF(i-1,1) + (a(i-1,1)-a_biase_KF)*Ts; 
       Phikk_1 = Phikk_1*(eye(2)+Ft.*Ts); 
       Xk =  Phikk_1*Xk;
       Pk = Phikk_1*Pk*Phikk_1' + Qk_1;
       if mod(i,nn) == 0
          Xkk_1 = Xk;
          Pkk_1 = Pk;
          Kk = Pkk_1*Hk'*(Hk*Pkk_1*Hk'+Rk)^-1;
          Zk = V_KF(i,1);
          %Zk = V_KF(i,1) - V(j,1);
          Zk = V_KF(i,1) - V_theory(j*nn,1);
          Xk = Xkk_1 + Kk*(Zk - Hk*Xkk_1);
          Pk = (eye(2)-Kk*Hk)*Pkk_1;      
          XkPk(j,1:2) = Xk';
          XkPk(j,3:4) = diag(Pk)'; 
          V_KF(i,1) = V_KF(i,1) - Xk(1,1)*0.9;
          Xk(1,1) = Xk(1,1)*0.1;
          a_biase_KF = a_biase_KF+Xk(2,1);
          Phikk_1 = eye(2);
          j=j+1;
       end    
       V_biase_KF(i,1) = a_biase_KF;
    end

    figure;plot(V_theory(1:end,1));
    hold on; plot(V_KF(1:end,1),'r');
    figure;plot(V_biase_KF(1:end,1));

    figure; 
    subplot(2,2,1);
    plot(XkPk(:,1));
    xlabel('采集序号');
    title('x1 误差');
        subplot(2,2,2);
    plot(XkPk(:,2));
    xlabel('采集序号');
    title('x2 误差');
        subplot(2,2,3);
    plot(XkPk(:,3));
    xlabel('采集序号');
    title('Pk1 误差');
       subplot(2,2,4);
    plot(XkPk(:,4));
    xlabel('采集序号');
    title('Pk2 误差'); 
    
    
    
    

