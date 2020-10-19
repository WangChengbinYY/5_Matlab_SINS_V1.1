 %------数据转换
    clear; clc;
    
    %profile on
    
    %load('E:\5_实验记录\20200107_单位办公桌静态试验汇总\静止放置\ADI_L_B_1_静止2小时\ADI_L.mat');
     load('E:\5_实验记录\20200107_单位办公桌静态试验汇总\静止放置\MPU_L_A_1_静止2小时\MPU_L.mat');
    Fs = 200;
    IMU = IMU(100*200:end,:);
    L = length(IMU);
    L = 200*60*20;

%-------获取陀螺 和 加计数据输出的原始数据
    %   坐标系  NED 和 前右下   加速度计的单位为g  gn假定为单位向量
    gyroData = zeros(L,3);
    accData = zeros(L,3);
    accData(1:L,1) = IMU(1:L,4);  accData(1:L,2) = IMU(1:L,3);  accData(1:L,3) = -IMU(1:L,5); 
    accData = accData.*9.81;
    gyroData(1:L,1) = IMU(1:L,7);  gyroData(1:L,2) = IMU(1:L,6);  gyroData(1:L,3) = -IMU(1:L,8); 
    
%-----参数设定  起始姿态为  航向指北 水平姿态角有 加速度计求取 
    %------初始参数设定
        orientPrior = quaternion();   orientPost = quaternion();        %姿态的先验 后延 估计
        gyroBias = zeros(3,1);                                                           %陀螺的零偏估计
        linAccelPrior = zeros(3,1);     linAccelPost = zeros(3,1);         %线性加速度的 先验 后延 估计
        linAccDecayFactor = 0.5;                                                       %线性加速度 阻尼参数  参照Matlab0.5
        periodSensor = 1/Fs;                                                             %传感器测量周期
        periodKalman = 1*periodSensor;                                          %KF滤波周期
        gravityVector = [0;0;1];                                                          %NED坐标系下 重力的是矢量方向 单位g
        % 记录数据空间分配
        recordGyroBias = zeros(L,3);
        recordLinAccErr = zeros(L,3);
        recordOrientErr = zeros(L,3);       % Z Y X
        recordOrient = zeros(L,3);

    %------KF滤波相关参数设定
        XPrior = zeros(9,1);    XPost = zeros(9,1);                 %系统状态量
        PPrior = zeros(9,9);    PPost = zeros(9,9);                 %系统状态估计方差阵
        Qw = zeros(9,9);        Qv = zeros(3,3);                      %系统噪声方差阵  观测噪声方差阵
        A =zeros(9,9);            H = zeros(3,9);                        %状态矩阵  观测矩阵
        
        % KF滤波参数初始化
            % ----------P阵的初始化 XPrior=0;
                % 单位 rad 初始姿态误差，注意这里的顺序是按照 ZYX 放置 航向0.5度 水平0.1度
                %intiOrientErr = [deg2rad(0.5); deg2rad(0.1); deg2rad(0.1)];   
                intiOrientErrVar = [1;1;1].*(deg2rad(1)*deg2rad(1)*2000e-5);   
                % 单位 rad/s 初始零偏误差 500度/h
                intiGyroBiasErrVar = [1;1;1].*(deg2rad(1)*deg2rad(1)*250e-3);
                % 单位 g 初始线性加速度的误差 0.01g
                intiLineAccErrVar = [1;1;1].*(10e-5 *9.81^2);
                PPrior(1:3,1:3) = diag(intiOrientErrVar);
                PPrior(4:6,4:6) = diag(intiGyroBiasErrVar);
                PPrior(7:9,7:9) = diag(intiLineAccErrVar);
             %-----------Qw阵 系统噪声协方差阵的初始化  器件参数相关
                % gyroNoise_MPU9250  陀螺噪声均方差MSE 单位 rad/s   约为 360度/h
                Qvg = diag([0.001745, 0.001745,0.001745].^2);           
                % gyroDriftNoise_MPU9250 = 陀螺零偏漂移噪声均方差  单位 rad/s 约为 0.11度/h
                Qwb = diag([5.52e-7, 5.52e-7, 5.52e-7].^2);     
                % accelerometerNoise = 加速度计噪声 均方差 单位 g  约为 2ug 
                %Qva = diag([2e-6; 2e-6; 2e-6].^2);      
                Qva = diag([0.0061; 0.0061; 0.0061]); 
                % linearAccelerationNoise = 线性加速度噪声 均方差 单位 g  1mg的量级 大概估计 0.01 m/s2  
                %Qwa = diag([1e-3; 1e-3; 1e-3].^2);   
                Qwa = diag([0.009623; 0.009623; 0.009623]); 
%                 Qw = [(Qwb+Qvg).*(periodKalman^2)	Qwb.*(-periodKalman)	zeros(3,3);
%                           Qwb.*(-periodKalman)                Qwb                               zeros(3,3);
%                           zeros(3,3)                                   zeros(3,3)                       Qwa];
                Qw = PPrior;
            %-----------Qv阵 观测噪声协方差阵的初始化  器件参数相关
                %Qv = (Qvg + Qwb).*(periodKalman^2) + Qva.*0.1 + Qwa.*0.1;    
                Qv = (Qvg + Qwb).*(periodKalman^2) + Qva + Qwa;  
            
    %------循环解算
        for i = 1:L

            % 第一次解算 求取初始姿态 
            if i == 1
                %暂时不考虑磁强计，假设初始磁场矢量水平，并且指向北 即
                magnetic = [1,0,0]';
                accLine = [0,0,0]';                                     %初始 线性加速度默认为0，即静止状态
                accGravity =accLine - accData(1,:)';         %加速度计测量的重力矢量    
                q = ecompass(accGravity',magnetic');                              
                % Force rotation angle to be positive
                if parts(q) < 0
                    q = -q;
                end                
                e = eulerd(q, 'ZYX', 'frame');                     %姿态角  e[航向 俯仰 横滚] 对应 ZYX
                orientPost = q;                                        %姿态角当前时刻的 后验估计                
                recordOrient(1,:) = e';
                %continue;
            end

            % 接收到新的陀螺 和 加计 数据
                % 1. 更新先验估计姿态 陀螺数据时间累积 变成角增量            
                deltaAng = (gyroData(i,:) - gyroBias').*periodSensor;       %去除先验估计零偏的 角增量；
                deltaq = quaternion(deltaAng, 'rotvec');
                orientPrior = orientPost*deltaq;                                    %利用前一时刻的姿态 更新当前姿态的 先验估计；
                rotMatriPrior = rotmat(orientPrior, 'frame');                   %利用四元数求取旋转矩阵

                %2. 进入KF 滤波环节
                    %（1）计算 观测量 Z                                    
                        gravityGyroMeas = rotMatriPrior * gravityVector;    %计算 由陀螺观测到的重力矢量    
                        gravityGyroMeas = gravityGyroMeas.*9.81;
                        linAccelPrior = linAccDecayFactor * linAccelPost;   %计算线性加速度 的先验估计       
                        gravityAccelMeas = linAccelPrior - accData(i,:)';      %计算加速度计估计的重力矢量  a= f+g
                        gravityAccelGyroDiff = gravityAccelMeas - gravityGyroMeas;      %观测量的求取
                        
                    % （2）计算 观测矩阵 H   
                        h1 = zeros(3,3);
                        h1(1,2) = gravityGyroMeas(3);
                        h1(1,3) = -gravityGyroMeas(2);
                        h1(2,3) = gravityGyroMeas(1);
                        h1 = h1 - h1.';
                        h2 = -h1.*periodKalman; 
                        H = [h1, h2, eye(3)];
                        
                    %（3）计算增益矩阵K
                        PPrior = Qw;    %一步预测方差阵
                        tmp =  ((H * PPrior * (H.') + Qv).');
                        K = PPrior * (H.')  / ( tmp);
                        
                     %（4）实现量测信息更新 得到系统状态的后验估计
                        Z = gravityAccelGyroDiff;
                        XPost = K * Z;
                        
                     %（5）计算X的后验估计协方差阵
                        Ppost = PPrior - K * (H * PPrior);
                     
                     %（6）根据Ppost更新 Qw  这里使用了经验(一些非主对角元素设为0)
                        Qw = [diag(diag(Ppost(1:3,1:3)))+(diag(diag(Ppost(4:6,4:6)))+Qwb+Qvg).*(periodKalman^2)     (diag(diag(Ppost(4:6,4:6)))+Qwb).*(-periodKalman)	 zeros(3,3);
                                   (diag(diag(Ppost(4:6,4:6)))+Qwb).*(-periodKalman)                                                        diag(diag(Ppost(4:6,4:6)))+Qwb                                 zeros(3,3);
                                  zeros(3,3)                                                                                        zeros(3,3)                                     diag(diag(Ppost(7:9,7:9))).*(linAccDecayFactor^2)+Qwa];                        
                     
                      %（7）依据估计结果进行 反馈校正   
                        % 姿态反馈 校正
                            orientErr = XPost(1:3).';
                            qerr = conj(quaternion(orientErr, 'rotvec')); 
                            orientPost = orientPrior * qerr;
                            % Force rotation angle to be positive
                            if parts(orientPost) < 0
                                orientPost = -orientPost;
                            end 
                            orientPost = normalize(orientPost);
                        % 陀螺零偏估计 反馈校正
                            gyroOffsetErr = XPost(4:6);
                            gyroBias = gyroBias - gyroOffsetErr;
                        % 线性加速度估计 反馈校正
                            linAccelErr = XPost(7:9);  
                            linAccelPost = linAccelPrior - linAccelErr;
            
                      %（8）记录中间计算过程变量信息                          
                            recordGyroBias(i,:) = gyroBias.';
                            recordLinAccErr(i,:)  = linAccelPost.';
                            recordOrientErr(i,:)  =orientErr.';       % Z Y X                                      
                            e = eulerd(orientPost, 'ZYX', 'frame');                     %姿态角  e[航向 俯仰 横滚] 对应 ZYX              
                            recordOrient(i,:) = e';                            
                            
        end

 %profile viewer
    
figure;
time = (0:L-1)/Fs;
plot(time,recordOrient);
title('Orientation Estimate')
legend('Z-axis', 'Y-axis', 'X-axis')
xlabel('Time (s)')
ylabel('Rotation (degrees)')   






