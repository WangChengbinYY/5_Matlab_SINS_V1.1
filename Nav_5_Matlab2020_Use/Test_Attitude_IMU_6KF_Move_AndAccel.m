% 利用加计对水平姿态角的估计
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
   
    % 记录数据空间分配
    recordOrient = zeros(L,3);            %  recordOrient 这里记录的顺序是  ZYX 切记
    recordGyroBias = zeros(L,3);  
    recordXk = zeros(L_Z,6);
    recordXkk_1 = zeros(L_Z,6);
    recordKFTime = zeros(L_Z,1);
    recordKFNum = 0;
    recordPk = zeros(6,6,L_Z);
    recordPkk_1 = zeros(6,6,L_Z);
    recordKk = zeros(6,3,L_Z);
    recordZk = zeros(L_Z,3);
    recordZkNew = zeros(L_Z,3);
    
    % 惯导解算的中间存储变量 用于进行旋转矢量补偿 前一时刻的角增量
    deltaAng_prior = zeros(1,3);  
    % 陀螺零偏赋初值
    gyroBias = mean(gyroData(1:3*Fs,:));          % 取3s陀螺 数据均值作为 初始的零偏
         
% 3. KF滤波相关参数设定  6维  仅观测 姿态误差 陀螺零偏
    priorX = zeros(6,1);    postX = zeros(6,1);       %系统状态量                

% 4. KF滤波参数初始化
    % 初始方差阵P0 6维 姿态误差  零偏误差     姿态 零偏  都按照 XYZ 顺序排列
        % 用静止状态下的加速度计3秒平均 数 计算初始水平姿态，航向默认为0
        tpAccel = -mean(accData(1:3*Fs,:));
        magnetic = [1,0,0]; 
        q = ecompass(tpAccel,magnetic);
        if parts(q) < 0
                q = -q;
        end
        Attitude0 = euler(q, 'ZYX', 'frame');        
        initVar_Attitude = deg2rad([0.3,0.3,0.3]).^2;      %方差去 加计姿态方差的10倍
        tmp_VarBias = [30,30,30].*(pi/180/3600);         %初始 零偏方差 取30度/h        
        initVar_Bias = tmp_VarBias.^2;
        postP = diag([initVar_Attitude,initVar_Bias]);
        XPost = zeros(6,1);
    % 系统状态噪声方差阵
        % 姿态噪声方差 =（ 陀螺输出噪声方差+零偏随机游走噪声方差 ）* periodSensor^2
        % 注意，这里按照 X Y Z 陀螺 来和姿态的欧拉角对应
        varGyroNoise = ([150,150,150].*(pi/180/3600)).^2;
        varGyroDriftNoise =  ([10,10,10].*(pi/180/3600)).^2;
        Qw = diag([varGyroNoise.*(periodKF^2),varGyroDriftNoise]);

    % 系统测量噪声方差阵 按照加速度计的噪声水平评估  0.03度
        Qv = diag(deg2rad([0.03,0.03,0.03]).^2);

    % 状态转移矩阵  观测矩阵
        A = [eye(3),-eye(3).*periodKF;zeros(3,3),eye(3)];
        H = [eye(3),zeros(3,3)];

% 5. 获取初始姿态信息           
        priorOrient = quaternion([Attitude0(1,1),Attitude0(1,2),Attitude0(1,3)],'euler','ZYX','frame');                                                            

% 6. 循环解算
    j = 0;
    k_feedback = 1;    % 滤波反馈校正参数  1 代表全反馈
    c = 0.5;    %对加速度计进行的 一阶马尔科夫 滤波 低通
    priorAcc = zeros(3,1);   postAcc = zeros(3,1);
for i_s = 1:L_s
    for s = 1:200
        i = (i_s-1)*200 + s;
    % 1. 更新先验估计姿态 陀螺数据时间累积 变成角增量            
        deltaAng = (gyroData(i,:) - gyroBias).*periodSensor;       %去除先验估计零偏的 角增量；
        deltaVector = deltaAng + cross(deltaAng_prior,deltaAng)./12;
        deltaAng_prior = deltaAng;
        deltaq = quaternion(deltaVector, 'rotvec');

        priorOrient = priorOrient*deltaq;                                    %利用前一时刻的姿态 更新当前姿态的 先验估计；
        priorOrient = normalize(priorOrient);
        % Force rotation angle to be positive
        if parts(priorOrient) < 0
            priorOrient = -priorOrient;
        end 
        priorOrient = normalize(priorOrient);    
        % 记录姿态 和 零偏信息
        recordOrient(i,:) =  euler(priorOrient,'ZYX','frame'); 
        recordGyroBias(i,:) = gyroBias;
        
    % 2. 判断是否进入KF环节
        % 判断条件1 初期给3s的收敛时间   
        % 判断条件2 在每一秒的头40个周期内
        % 判断条件3 KF周期
        KF_isOk = 0;
        if (i <= 3*Fs) 
            if (mod(i,Fs_KF) == 0) 
                KF_isOk = 1;
            else
                KF_isOk = 0;
            end
        else
            if (s <= 80) && (mod(i,Fs_KF) == 0) 
                KF_isOk = 1;
            else
                KF_isOk = 0;
            end
        end    
        
%         if  (mod(i,Fs_KF) == 0)
%             KF_isOk = 1;
%         else
%             KF_isOk = 0;
%         end
        
        if KF_isOk
            % 保存上一个状态的时间长度
            if (i > 3*Fs) && (s ==1)
                periodKF = periodSensor * 120;
                Qw = diag([varGyroNoise.*(periodKF^2),varGyroDriftNoise]);
                A = [eye(3),-eye(3).*periodKF;zeros(3,3),eye(3)];
            else
                periodKF = periodSensor * Fs_KF;
                Qw = diag([varGyroNoise.*(periodKF^2),varGyroDriftNoise]);
                A = [eye(3),-eye(3).*periodKF;zeros(3,3),eye(3)];
            end
             %（1）计算 观测量 Z                                    
                j = j+1;
                recordKFTime(j,1) = i;
                % 利用当前时刻的前4个加计数据的平均值 进行姿态测量
                if s == 4
                    postAcc = -mean(accData(i-Fs_KF+1:i,:));
                    priorAcc = postAcc;
                else
                    postAcc = -mean(accData(i-Fs_KF+1:i,:));
                    postAcc = priorAcc.*c + postAcc.*(1-c);
                    priorAcc = postAcc;
                end
                magnetic = [1,0,0]; 
                q = ecompass(postAcc,magnetic);
                if parts(q) < 0
                        q = -q;
                end
                tpAtt = euler(q, 'ZYX', 'frame');                      
                
                Z(1,1) = recordOrient(i,3) - tpAtt(1,3);
                Z(2,1) = recordOrient(i,2) - tpAtt(1,2);
                Z(3,1) = recordOrient(i,1) - tpAtt(1,1);
                
                recordZk(j,:) = [Z(3,1),Z(2,1),Z(1,1)];                
                
            % （2）计算 状态观测的一步预测  
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
                %postP = priorP - K * H * priorP;  
                
                postP = (eye(6)-K*H)*priorP*(eye(6)-K*H)' + K*Qv*K';
                
                recordPk(:,:,j) = postP;
                
              %（7）依据估计结果进行 反馈校正   
                % 姿态反馈 校正  这里的姿态是  XYZ           
                    orientErr =( XPost(1:3).*k_feedback)';
                    XPost(1:3) = XPost(1:3).*(1-k_feedback);
                    qerr = conj(quaternion(orientErr, 'rotvec')); 
                    postOrient = priorOrient * qerr;
                    if parts(postOrient) < 0
                        postOrient = -postOrient;
                    end 
                    postOrient = normalize(postOrient);
                    priorOrient = postOrient;

                % 陀螺零偏估计 反馈校正
                    gyroOffsetErr = (XPost(4:6).*k_feedback)';
                    XPost(4:6) = XPost(4:6).*(1-k_feedback);
                    gyroBias = gyroBias - gyroOffsetErr;

              %（8）记录信息
                    recordOrient(i,:) =  euler(postOrient,'ZYX','frame'); 
                    recordGyroBias(i,:) = gyroBias;
                    recordKFNum = j;
                    
                    recordZkNew(j,:) = recordOrient(i,:) - tpAtt(1,:);
         end        
    end
end   
        
        figure;
        plot(rad2deg(recordZk(:,3)),'r');
        hold on; plot(rad2deg(recordXk(:,3)),'g');
        hold on; plot(rad2deg(recordZkNew(:,3)),'b');
   
   % 绘制结果
        % 零偏估计比较
        figure;
        plot(gyroXData_BiaDenoise.*(180/pi*3600)); hold on; plot(recordGyroBias(:,2).*(180/pi*3600),'r');
        legend('真实零偏','估计零偏'); title('X轴零偏'); ylabel('度/h');        
        figure;
        plot(gyroYData_BiaDenoise.*(180/pi*3600)); hold on; plot(recordGyroBias(:,1).*(180/pi*3600),'r');
        legend('真实零偏','估计零偏'); title('Y轴零偏'); ylabel('度/h');   
        figure;
        plot(gyroZData_BiaDenoise.*(180/pi*3600)); hold on; plot(recordGyroBias(:,3).*(-180/pi*3600),'r');
        legend('真实零偏','估计零偏'); title('Z轴零偏'); ylabel('度/h');
        
	% 姿态 结果
        time = [1:L]/Fs;
        recordOrient_deg = rad2deg(recordOrient);
        figure;
        plot(time,recordOrient_deg(:,3));        
        title('姿态估计 X 横滚'); ylabel('度'); ylim([-0.25,0.25]);
        figure;
        plot(time,recordOrient_deg(:,2));     
        title('姿态估计 Y 横滚'); ylabel('度'); ylim([-0.25,0.25]);
        figure;
        plot(time,recordOrient_deg(:,1));     
        title('姿态估计 Z 横滚'); ylabel('度'); ylim([-0.25,0.25]);
        sqrt(var(recordOrient_deg(:,3)))
        sqrt(var(recordOrient_deg(:,2)))
        sqrt(var(recordOrient_deg(:,1)))
        
%     timeRecord = recordKFTime(1:recordKFNum,1)./Fs;    
%     % 状态量 Xk
%         for i = 1:6
%             figure;
%             plot(timeRecord,recordXk(1:recordKFNum,i));
%             title(['X',num2str(i),' 状态量']);            
%         end 
%      
%       % 状态  方差 Pk
%      for i = 5
%             for j = 5
%                 figure; 
%                 tmpPk = zeros(recordKFNum,1);            
%                 for k = 1:recordKFNum
%                     tmpPk(k,1) = recordPk(i,j,k); 
%                 end 
%                 plot(timeRecord,tmpPk);
%                 title(['Pk P',num2str(i),num2str(j),' 状态量方差']);     
%             end
%     end       
%          
%       % 状态  方差 Pkk_1
%         for i = 1
%             for j =4
%                 figure; 
%                 tmpPk = zeros(recordKFNum,1);            
%                 for k = 1:recordKFNum
%                     tmpPkk_1(k,1) = recordPkk_1(i,j,k); 
%                 end 
%                 plot(timeRecord,tmpPkk_1);
%                 title(['Pkk-1 P',num2str(i),num2str(j),'-1 状态量方差']);     
%             end
%         end  
%             
%        % 状态  方差 Kk
%         for i =4
%             for j = 1
%                 figure; 
%                 tmpPk = zeros(recordKFNum,1);            
%                 for k = 1:recordKFNum
%                     tmpKk(k,1) = recordKk(i,j,k); 
%                 end 
%                 plot(timeRecord,tmpKk);
%                 title(['Kk K',num2str(i),num2str(j),' 状态量方差']);     
%             end
%         end        
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
%         
        
        
        
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