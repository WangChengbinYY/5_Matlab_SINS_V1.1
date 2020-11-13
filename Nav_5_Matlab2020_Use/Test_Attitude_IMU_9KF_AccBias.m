% 利用静止状态对 “伪速度观测量” 对 水平姿态角和加速度计零偏的估计
% 1. 获取原始数据
    clear;clc;
    load('E:\5_实验记录\20200916_ADI_R_B_姿态实验\半仿真数据\IMUData.mat')

    % 获取原始数据，这里注意 要将 ENU 坐标系 转到 NED
    Fs = 200;
    L = length(gyroXData);
    L_s = fix(L/Fs);   % 取整秒
    L = L_s * Fs;
    gyroData = zeros(L,3);
    accData = zeros(L,3);
    %-------对加速度计的数据进行 非正交校准
    M_ADI_UB = [0.999844387	0.01471722 	0.002556173
                            -0.01469017	0.99978481 	0.00053635
                            -0.01245593	-0.00133620 	1.000481267];
    for i = 1:L
        tmp = M_ADI_UB*[accXData(i,1);accYData(i,1);accZData(i,1)];
        accXData(i,1) = tmp(1,1);
        accYData(i,1) = tmp(2,1);
        accZData(i,1) = tmp(3,1);
    end
    
    %   坐标系  NED 和 前右下
    gyroData(1:L,1) = gyroYData(1:L,1);  
    gyroData(1:L,2) = gyroXData(1:L,1);  
    gyroData(1:L,3) = -gyroZData(1:L,1); 
    accData(1:L,1) = accYData(1:L,1);  
    accData(1:L,2) = accXData(1:L,1);  
    accData(1:L,3) = -accZData(1:L,1);  
    
    gyroBiase_True = zeros(L,3);
    gyroBiase_True(1:L,1) = gyroYData_BiaDenoise(1:L,1);  
    gyroBiase_True(1:L,2) = gyroXData_BiaDenoise(1:L,1);  
    gyroBiase_True(1:L,3) = -gyroZData_BiaDenoise(1:L,1); 
    
% 2. 初始参数设定    
    Fs_KF = 4;
    L_Z = fix(L/Fs_KF);
    periodSensor = 1.0/Fs;        %姿态更新周期
    periodKF = periodSensor * Fs_KF;    %KF滤波更新的周期
    
    priorOrient = quaternion();     %姿态的先验估计四元数
    postOrient = quaternion();      %姿态的后验估计四元数                
   
    % 计算当地重力数值g
    g0 = 9.7803267714; lat = deg2rad(34);   h = 40;
    g = g0*(1+5.27094e-3*sin(lat)^2+2.32718e-5*sin(lat)^4)-3.086e-6*h; % grs80
    
    % 记录数据空间分配
    recordOrient = zeros(L,3);            %  recordOrient 这里记录的顺序是  ZYX 切记
    recordXk = zeros(L_Z,9);
    recordXkk_1 = zeros(L_Z,9);
    recordKFTime = zeros(L_Z,1);
    recordKFNum = 0;
    recordPk = zeros(9,9,L_Z);
    recordPkk_1 = zeros(9,9,L_Z);
    recordKk = zeros(9,3,L_Z);
    recordVelocity = zeros(L,3);
    recordPos = zeros(L,3);
    recordBiasAcc = zeros(L,3);
    
% 3. KF滤波相关参数设定  6维  仅观测 姿态误差 陀螺零偏
    priorX = zeros(9,1);    postX = zeros(9,1);       %系统状态量                

% 4. KF滤波参数初始化
    % 初始方差阵P0 9维 速度误差  姿态误差   加计零偏误差  都按照 XYZ 顺序排列
    
        % 用静止状态下的加速度计3秒平均 数 计算初始水平姿态，航向默认为0
        tpAccel = -mean(accData(1:3*Fs,:));
        magnetic = [1,0,0]; 
        q = ecompass(tpAccel,magnetic);
        if parts(q) < 0
                q = -q;
        end
        Attitude0 = euler(q, 'ZYX', 'frame');        
        
   % 系统状态初始方差阵设定     
        initV = [0.1,0.1,0.1].^2;                           %初始速度RMS 0.1m/s
        initVar_Attitude = (Attitude0./10).^2;      %初始姿态误差RMS  取初始水平姿态的1/10  
        iniAccBias = (ones(1,3).*(4e-3*g)).^2;      %初始加计零偏 4mg
        postP = diag([initV,initVar_Attitude,iniAccBias]);         
        XPost = zeros(9,1);
    % 系统状态噪声方差阵
        % 速度误差噪声方差 取 0.1m/s 
        % 姿态误差噪声方差 取 0.1度 
        % 加计零偏噪声方差 取 2mg
        Qw = diag([initV, (deg2rad([0.1,0.1,0.1])).^2, (ones(1,3).*(2e-3*g)).^2]);

    % 系统测量噪声方差阵 速度伪观测量 取 0.01 m/s
        Qv = diag([0.01,0.01,0.01].^2);

    % 状态转移矩阵(依据姿态更新)  观测矩阵
        A = eye(9,9);
        H = [eye(3),zeros(3,6)];

% 5. 获取初始姿态信息           
        priorOrient = quaternion([Attitude0(1,1),Attitude0(1,2),Attitude0(1,3)],'euler','ZYX','frame');                                                            
        BiasAcc = zeros(1,3);
% 6. 循环解算
        j = 0;
        k_feedback = 1;    % 滤波反馈校正参数  1 代表全反馈
        Vkk_1 = zeros(1,3);     Vk = zeros(1,3);
        Poskk_1  = zeros(1,3);     Posk = zeros(1,3);
for i_s = 1:L_s
    for s = 1:200
        i = (i_s-1)*200 + s;
        
    % 1. 利用当前姿态  进行速度更新
        fb = accData(i,:) - BiasAcc;
        fn = rotateframe(conj(priorOrient),fb);
        % 计算向心加速度
            wie = 15*pi/180/3600;
            tpWie = [wie*cos(lat);0;-wie*sin(lat)];
            R = 6317000;
            wen = [Vk(2)/(R+h);-Vk(1)/(R+h);Vk(2)*tan(lat)/(R+h)];
            tpVerr = cross((tpWie.*2 + wen),Vk');
        Vk = Vkk_1 + (fn+[0,0,1]).*periodSensor - tpVerr';
        Vkk_1 = Vk;
        Posk = Poskk_1 + (Vkk_1+Vk).*(periodSensor/2);
        Poskk_1 = Posk;
        
    % 2. 判断是否进入KF环节
        % -------（1）固定周期KF--------------
        KF_isOk = 0;
        if (mod(i,Fs_KF) == 0) 
            KF_isOk = 1;
        else
            KF_isOk = 0;
        end     

        if KF_isOk
             %（1）计算 观测量 Z                                    
                j = j+1;
                recordKFTime(j,1) = i;
                % 将当前的速度信息作为伪观测量
                Z = Vk';
                
            % （2）计算 状态观测的一步预测  
                % 更新 状态矩阵A
                Cnb = rotmat(q, 'frame')';
                A(1,5) = 1*periodKF; A(5,1) = -1*periodKF;
                A(1:3,7:9) = -Cnb.*periodKF;
                XPrior = A*XPost;
                recordXkk_1(j,:) = XPrior';
                
            %（3）计算 一步预测方差阵 priorP
                priorP = A * postP * A' + Qw;
                recordPkk_1(:,:,j) = priorP;
                
            %（4）计算增益矩阵K                            
                tmp =  ((H * priorP * (H.') + Qv).');
                K = priorP * (H.')  / (tmp);
                recordKk(:,:,j) = K;
                
            %（5）实现量测信息更新 得到系统状态的后验估计
                XPost = XPrior + K * ( Z - H*XPrior );
                recordXk(j,:) = XPost';
                
             %（6）计算X的后验估计协方差阵
                postP = (eye(9)-K*H)*priorP*(eye(9)-K*H)' + K*Qv*K';
                recordPk(:,:,j) = postP;
                
              %（7）依据估计结果进行 反馈校正   
              % 速度反馈
                    Vk = Vk - (XPost(1:3).*k_feedback)';
                    XPost(1:3) = XPost(1:3).*(1-k_feedback);
                    
              % 姿态反馈              
                % 姿态反馈 校正  这里的姿态是  XYZ           
                    orientErr =(XPost(4:6).*k_feedback)';
                    XPost(4:6) = XPost(4:6).*(1-k_feedback);
                    qerr = conj(quaternion(orientErr, 'rotvec')); 
                    postOrient = priorOrient * qerr;
                    if parts(postOrient) < 0
                        postOrient = -postOrient;
                    end 
                    postOrient = normalize(postOrient);
                    priorOrient = postOrient;

                % 加计零偏误差估计 反馈校正
                    BiasAcc = BiasAcc - (XPost(7:9).*k_feedback)';
                    XPost(7:9) = XPost(7:9).*(1-k_feedback);

              %（8）记录信息
                    recordBiasAcc(i,:) = BiasAcc;
                    recordKFNum = j;
         end        
         
        % 记录数据
        recordVelocity(i,:) = Vk;
        recordPos(i,:) = Posk;
        recordOrient(i,:) =  eulerd(priorOrient,'ZYX','frame'); 
        
    end
end   

   
   % 绘制结果
        % 加计零偏估计
        figure;
        plot(recordBiasAcc(:,1)./(g*1000));
        title('X轴加计零偏'); ylabel('mg');        
        figure;
        plot(recordBiasAcc(:,2)./(g*1000));
        title('Y轴加计零偏'); ylabel('mg');      
        figure;
        plot(recordBiasAcc(:,3)./(g*1000));
        title('Z轴加计零偏'); ylabel('mg');      


    % 状态量 Xk
        for i = 1:9
            figure;
            plot(recordXk(1:recordKFNum,i));
            title(['X',num2str(i),' 状态量']);            
        end 
     
      % 状态  方差 Pk
     for i = 9
            for j = 9
                figure; 
                tmpPk = zeros(recordKFNum,1);            
                for k = 1:recordKFNum
                    tmpPk(k,1) = recordPk(i,j,k); 
                end 
                plot(tmpPk);
                title(['Pk P',num2str(i),num2str(j),' 状态量方差']);     
            end
    end       
         
      % 状态  方差 Pkk_1
        for i = 5
            for j =5
                figure; 
                tmpPk = zeros(recordKFNum,1);            
                for k = 1:recordKFNum
                    tmpPkk_1(k,1) = recordPkk_1(i,j,k); 
                end 
                plot(tmpPkk_1);
                title(['Pkk-1 P',num2str(i),num2str(j),'-1 状态量方差']);     
            end
        end  
            
       % 状态  方差 Kk
        for i =9
            for j = 1:3
                figure; 
                tmpPk = zeros(recordKFNum,1);            
                for k = 1:recordKFNum
                    tmpKk(k,1) = recordKk(i,j,k); 
                end 
                plot(tmpKk);
                title(['Kk K',num2str(i),num2str(j),' 状态量方差']);     
            end
        end        
%         
%         P1_0 = recordPkk_1(:,:,1);
%         P1 = recordPk(:,:,1);
%         K1 = recordKk(:,:,1);
%         
%         P2_0 = recordPkk_1(:,:,2);
%         P2 = recordPk(:,:,2);
%         K2 = recordKk(:,:,2);       
%         
%         tpPkk_1 = recordPkk_1(:,:,end);
%         tpPk = recordPk(:,:,2);
        
        
        
        
        %记录当前的姿态信息 及 其它信息
%         e = euler(priorOrient, 'ZYX', 'frame');                               
%         recordOrient(i,:) = e';                     
%         recordGyroBias(i,:) = gyroBias';                       
% 
%   
% 
% % 7. 绘制图形
%     figure;
%     time = (0:L-1)/app.Fs;
%     plot(time,recordOrient.*(180/pi));
%     title('Orientation Estimate')
%     legend('Z-axis', 'Y-axis', 'X-axis')
%     xlabel('Time (s)')
%     ylabel('Rotation (degrees)')   
% 
% 
% app.CheckBox_DataStateNow.Value = 1;
% app.dataNow.recordOrient = recordOrient;
% app.dataNow.recordGyroBias = recordGyroBias;
% app.dataNow.Fs = app.Fs;
% app.dataNow.Fs_KF = app.Fs_KF;
% app.dataNow_isOK = 1;
% if app.Fs_KF > 0
%     app.dataNow.recordXk = recordXk(1:j_KF-1,:);
%     app.dataNow.recordPk = recordPk(1:j_KF-1,:);
%     app.dataNow.recordKFTime = recordKFTime(1:j_KF-1,1);
% end      
% 
% results = 1;