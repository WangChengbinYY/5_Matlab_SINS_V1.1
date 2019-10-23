function [Fk,Rk,Phikk_1,Qk_1] = KF_Update_C2D(mode,KF,Ts,n)
% 将状态方程离散化 
% 输入 Ft，rt，qt等，n 泰勒展开阶数
% 输出 Fk,Rk,Phikk_1,Qk_1



if((mode == 1)||(mode == 2)||(mode == 3)||(mode == 4)||(mode == 5))
    if n == 1
        Fk = KF.Ft;
        Phikk_1 = eye(size(KF.Ft)) + Fk*Ts;
        Qk_1 = KF.Gt*KF.qt*KF.Gt'.*Ts;
        Rk = KF.rt;  
    else
        if n>1
            Fk = KF.Ft;
            Rk = KF.rt;
            Phikk_1 = eye(size(KF.Ft));
            T_Fk = eye(size(KF.Ft));
            for i = 1:n
                T_Fk = T_Fk*Fk*Ts/i;
                Phikk_1 = Phikk_1+T_Fk;
            end
            Mi = KF.Gt*KF.qt*KF.Gt';
            Qk_1 = Mi*Ts;
            for i = 2:n
                Mi = Fk*Mi + (Fk*Mi)';
                T_Ts = 1;
                for j=1:i
                    T_Ts = T_Ts*Ts/j;
                end
                Qk_1 = Qk_1 + Mi*T_Ts;
            end        
        end
    end
    
end


