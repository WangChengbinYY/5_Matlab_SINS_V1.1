function G_Const = CONST_Init()
%初始化 全局变量及常值

%% 单位换算相关
    G_Const.PI         = 3.141592653589793;               %后面使用为pi，C语言中宏定义    
    G_Const.D2R        = G_Const.PI/180.0;                   %度转弧度
    G_Const.R2D        = 180.0/G_Const.PI;                   %弧度转度

    G_CONST.g0         = 9.7803267714;                    %单位：m/s2
    G_CONST.mg         = 1.0e-3*G_CONST.g0;                  %单位：m/s2
    G_CONST.ug         = 1.0e-6*G_CONST.g0;                  %单位：m/s2
    G_CONST.mGal       = 1.0e-3*0.01;                     %单位：m/s2
    
%% 地球常值参数    
    G_Const.earth_wie   = 7.2921151467e-5;              %地球自转角速度 标量 单位：弧度/s
    G_Const.earth_f     = 0.003352813177897;
    G_Const.earth_Re    = 6378137;                      %单位：m
    G_Const.earth_e     = 0.081819221455524;    
    G_Const.earth_g0    = 9.7803267714;                 %单位：m/s2
    %G_Const.earth_g0    = 9.7553; 
    
        