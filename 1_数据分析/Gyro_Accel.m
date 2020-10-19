clear;
% 未预热
%   load('E:\5_实验记录\20200916_ADI_R_B_姿态实验\IMUGPS1_20000_350000.mat')
 % 已预热
load('E:\5_实验记录\20200107_单位办公桌静态试验汇总\静止放置\ADI_L_R_B_3_静止1_360000_1200000.mat')
t = 60*10;
Fs = 200;
L = t*Fs;
periodSensor = 1/Fs;
        gyroData = zeros(L,3);
        accData = zeros(L,3);
        %   坐标系  NED 和 前右下   加速度计的单位为g
        accData(1:L,1) =IMU(1:L,3);  
        accData(1:L,2) =IMU(1:L,2);  
        accData(1:L,3) = -IMU(1:L,4); 
        gyroData(1:L,1) =IMU(1:L,6);  
        gyroData(1:L,2) =IMU(1:L,5);  
        gyroData(1:L,3) = -IMU(1:L,7);  

attitudeAccel = zeros(L,4);
attitudeGyro = zeros(L,4);
% 计算由陀螺进行计算得到的姿态角
    % 初始姿态  利用3s加计数据
    magnetic = [1,0,0]; 
    accGravity = - mean(accData(1:3*Fs,:));                %  加速度计测量的重力矢量                                   
    q = ecompass(accGravity,magnetic);                  
        % Force rotation angle to be positive
        if parts(q) < 0
            q = -q;
        end 
    attitudeGyro(1,1:3) = eulerd(q, 'ZYX', 'frame');
    attitudeGyro(1,4) = 1/Fs; 
    % 利用 前3秒的数据平均值 作为零偏
    gyroBias = mean(gyroData(1:3*Fs,:));
    deltaAng_prior = zeros(3,1);
    for i = 2:L
        deltaAng = (gyroData(i,:) - gyroBias).*periodSensor;
        deltaVector = deltaAng + cross(deltaAng_prior,deltaAng)./12;
        deltaAng_prior = deltaAng;
        deltaq = quaternion(deltaVector, 'rotvec');
        
        q = q*deltaq;   
            if parts(q) < 0
                q = -q;
            end        
        attitudeGyro(i,1:3) = eulerd(q, 'ZYX', 'frame');
        attitudeGyro(i,4) = i/Fs; 
    end
    disp(['陀螺输出的零偏均方差为 X Y Z： ', num2str(sqrt(var(gyroData))),' 度/s']);
    disp(['陀螺求解的姿态均方差为 Z Y X： ', num2str(sqrt(var(attitudeGyro(:,1:3)))),' 度']);

    % 仿真加计数据
% accMean = mean(accData);  
% accDataNew(:,1) = accMean(1,1) + wgn(L,1,-80);    
% accDataNew(:,2) = accMean(1,2) + wgn(L,1,-80); 
% accDataNew(:,3) = accMean(1,3) + wgn(L,1,-80); 
% 计算由加速度计进行计算得到的姿态角
for i = 1:L
    q = ecompass(-accData(i,:),magnetic);                                                    
            % Force rotation angle to be positive
            if parts(q) < 0
                q = -q;
            end                
    attitudeAccel(i,1:3) = eulerd(q, 'ZYX', 'frame');    
    attitudeAccel(i,4) = i/Fs; 
end
    disp(['加计求解的姿态均方差为 Z Y X： ', num2str(sqrt(var(attitudeAccel(:,1:3)))),' 度']);    
        
  % 计算由加速度计 平均处理后 进行计算得到的姿态角
  Fs_KF = 8;
  L_KF = fix(L/8);
  attitudeAccelMean = zeros(L_KF,4);
  accMeanPior = zeros(1,3);
  a = 0.1;
for i = 1:L_KF
    accMean = mean(accData(1+(i-1)*Fs_KF:i*Fs_KF,:));
    accMean = accMeanPior.*(1-a) + accMean.*a; 
    accMeanPior = accMean;
    q = ecompass(-accMean,magnetic);                                                    
            % Force rotation angle to be positive
            if parts(q) < 0
                q = -q;
            end                
    attitudeAccelMean(i,1:3) = eulerd(q, 'ZYX', 'frame');    
    attitudeAccelMean(i,4) = i/Fs*Fs_KF; 
end
    disp(['加计平均的姿态均方差为 Z Y X： ', num2str(sqrt(var(attitudeAccelMean(:,1:3))).*(180/pi)),' 度']);      
    
    
    figure;
%      plot(attitudeGyro(:,4),attitudeGyro(:,1));
     hold on; plot(attitudeAccel(:,4),attitudeAccel(:,1),'r');
%     hold on; plot(attitudeAccelMean(:,4),attitudeAccelMean(:,1),'g');
    xlabel('时间s'); ylabel('度');
    title('Yaw');
    
    figure;
%      plot(attitudeGyro(:,4),attitudeGyro(:,2));
     hold on; plot(attitudeAccel(:,4),attitudeAccel(:,2),'r');
%     hold on; plot(attitudeAccelMean(:,4),attitudeAccelMean(:,2),'g');
xlabel('时间s'); ylabel('度');
    title('Pitch');  
    
    figure;
%      plot(attitudeGyro(:,4),attitudeGyro(:,3));
     hold on; plot(attitudeAccel(:,4),attitudeAccel(:,3),'r');
%     hold on; plot(attitudeAccelMean(:,4),attitudeAccelMean(:,3),'g');
xlabel('时间s'); ylabel('度');
    title('Roll');    
    
    
    
    
%     
%     
%     
%     
%     
%                         magnetic = [1,0,0];                    
%                     accGravity = - [0.4717   -0.6032   -0.6439];                %加速度计测量的重力矢量    
%                     q = ecompass(accGravity,magnetic);                              
%                     % Force rotation angle to be positive
%                     if parts(q) < 0
%                         q = -q;
%                     end                
%                     e = eulerd(q, 'ZYX', 'frame');
%     
%     
%     
% 
% 0.0094957   0.0075216   0.0097473 度
% 
% mean(IMU(1:200*3,5:7)).*(180/pi*3600)
% 
% accLine = sqrt(IMU(:,2).^2 +  IMU(:,3).^2 +  IMU(:,4).^2);
% 
% 
% L = length(IMU);
% nSize =8;
% L_KF = fix(L/nSize);
% meanAccel = zeros(L_KF,4);
% for i = 1:L_KF
%     meanAccel(i,1) = IMU(i*nSize,1);
%     meanAccel(i,2:4) = mean(IMU(1+(i-1)*nSize:i*nSize,2:4));
% end
% 
% figure;
% plot(IMU(:,1),IMU(:,2)); hold on; plot(meanAccel(:,1),meanAccel(:,2));
% figure;
% plot(IMU(:,1),IMU(:,3)); hold on; plot(meanAccel(:,1),meanAccel(:,3));
% figure;
% plot(IMU(:,1),IMU(:,4)); hold on; plot(meanAccel(:,1),meanAccel(:,4));
% 
% 
% sqrt(var(IMU(:,2)))*1000
% sqrt(var(IMU(:,3)))*1000
% sqrt(var(IMU(:,4)))*1000
% 
% sqrt(var(meanAccel(:,1)))*1000
% sqrt(var(meanAccel(:,2)))*1000
% sqrt(var(meanAccel(:,3)))*1000
% 
% 
% 
% x = meanAccel(:,1);
%     c = 0.2;        %自回归系数
%     b = [0.1];
%     a = [1 -0.9];
%     figure;
%     freqz(b,a);         % 对传递函数做频谱分析
%     xFilter = filter(b,a,x);    %利用传递函数进行 滤波
%     
%     figure;
%     plot(x); hold on;
%     plot(xFilter,'r'); 
% 
%     sqrt(var(IMU(:,2)))*1000
%     sqrt(var(meanAccel(:,1)))*1000
%     sqrt(var(xFilter))*1000
% 
%     
%     L = length(x);
%     y = zeros(L,1);
%     y(1,1) = x(1,1);
%     for i = 2:L        
%         y(i,1) = 0.9*y(i-1,1)+0.1*x(i,1);
%     end
%         figure;
%     plot(x); hold on;
%     plot(y,'r'); 
%     hold on; plot(IMU(:,2));
%     
%     sqrt(var(x))*1000
%     sqrt(var(y))*1000
%     
%     
%     L = length(IMU);
%    x = wgn( L,1,10*log10(var(IMU(:,4))))+mean(IMU(:,4));
%    figure;
%    plot(IMU(:,4)); hold on; plot(x,'r');
%     var(IMU(:,4))
%     var(x)
%     
%     
%     
%     
%     mean(IMU(:,2:4))
%     
%                     ax = -0.4717; ay = 0.6032; az = 0.6439;
%                     a = sqrt(ax^2+ay^2+az^2);
%                     roll = atan(ay/a)*180/pi
%                     pitch = asin(ax/az)*180/pi
%     
%                     magnetic = [1,0,0];                    
%                     accGravity = - [0.4717   -0.6032   -0.6439];                %加速度计测量的重力矢量    
%                     q = ecompass(accGravity,magnetic);                              
%                     % Force rotation angle to be positive
%                     if parts(q) < 0
%                         q = -q;
%                     end                
%                     e = eulerd(q, 'ZYX', 'frame');
%                     Cbn = rotmat(q,'frame');
%                     f = Cbn * [0;0;1];
%                     
%                     
%                     
%     
%                         accGravity = - [0.4717   -0.6002   -0.6439];                %加速度计测量的重力矢量    
%                     q = ecompass(accGravity,magnetic);                              
%                     % Force rotation angle to be positive
%                     if parts(q) < 0
%                         q = -q;
%                     end                 
%                     e1 = eulerd(q, 'ZYX', 'frame');
%                     e1-e
%     
%     
%     
%     L = length(IMU);
%     e = zeros(L,3);
%     for i=1:L
%         magnetic = [1,0,0]; 
%         q = ecompass(IMU(i,2:4),magnetic);
%          if parts(q) < 0
%             q = -q;
%         end                 
%         e(i,:) = eulerd(q, 'ZYX', 'frame');       
%     end
%     
%     
%     
%     
    