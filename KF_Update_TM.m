function KFNew = KF_Update_TM(mode,KF,Zk)
% KF滤波的更新，包括预测和量测更新
% 
if mode == 1
    KFNew = KF;
    KFNew.Zk = Zk;
    KFNew.Xkk_1 = KF.Phikk_1*KF.Xk;
    KFNew.Pkk_1 = KF.Phikk_1*KF.Pk*KF.Phikk_1'+KF.Qk_1;
    KFNew.Kk = KFNew.Pkk_1*KF.Hk'*Math_invMatrix(KF.Hk*KFNew.Pkk_1*KF.Hk'+KF.Rk);
    
    KFNew.Xk = KFNew.Xkk_1+KFNew.Kk*(KFNew.Zk-KF.Hk*KFNew.Xkk_1);
    KFNew.Pk = (eye(size(KFNew.Pkk_1))-KFNew.Kk*KF.Hk)*KFNew.Pkk_1*(eye(size(KFNew.Pkk_1))-KFNew.Kk*KF.Hk)'+KFNew.Kk*KF.Rk*KFNew.Kk';    
end
