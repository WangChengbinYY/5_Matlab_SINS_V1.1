function KF = KF_Init(mode,X0,P0,q0,r0)
% 初始化KF滤波数据结构体
% 输入 mode 模型类型
% 连续系统：
%  X(t)_Dot = F(t)*X(t) + G(t)*w(t)  w(t)的方差为qt
%  Z(t) = H(t)*X(t)+v(t)             v(t)的方差为rt
%
% 离散系统：
%  Xk = Phikk_1*Xk_1 + Wkk_1   Wk的方差为Qk_1
%  Zk = Hk*Xk + Vk                   Vk的方差为Rk

% 输入：n 状态变量维度; m 观测变量维度; k 系统噪声维度
if(mode == 1)
    % 15纬状态量 系统噪声仅陀螺和加计零偏，观测量仅位置反馈
    n = 15;
    m = 3;
    k = 6;    
    KF.Gt = zeros(n,k);         
    KF.Hk = zeros(m,n); KF.Hk(1:3,7:9) = eye(3); 
    KF.qt = q0;         %连续系统 系统噪声方差矩阵
    KF.rt = r0;         %连续系统 观测噪声方差矩阵    
    KF.Rk = KF.rt;
end

% 连续变量
KF.Ft = zeros(n,n);         %连续系统状态转移矩阵

% 离散变量
KF.Xkk_1 = zeros(n,1);
KF.Xk = X0;
KF.Zk = zeros(m,1);
KF.Phikk_1 = eye(n);
KF.Pkk_1 = zeros(n,n);
KF.Pk = P0;
KF.Kk = zeros(n,m);
KF.Qk_1 = zeros(n,n);






