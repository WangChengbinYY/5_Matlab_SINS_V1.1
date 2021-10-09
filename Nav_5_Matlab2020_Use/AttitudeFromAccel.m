%  ------------------加计求取姿态


    % 获取原始数据，这里注意 要将 ENU 坐标系 转到 NED
    L = length(IMU(1:12000,:));
    accData = zeros(L,4);
    %   坐标系  NED 和 前右下   加速度计的单位为g
    accData(1:L,1) = IMU(1:L,3);  
    accData(1:L,2) = IMU(1:L,2);  
    accData(1:L,3) = -IMU(1:L,4); 
    accData(1:L,4) = IMU(1:L,1);
    L_KF = fix(L/4);
    Attitude = zeros(L_KF,4);    % Z Y X  航向 俯仰 横滚    
    magnetic = [1,0,0]; 
    priorAcc = zeros(1,3);  postAcc = zeros(1,3);
    c = 0.6;
    for i = 1:L_KF
        if i == 1
            postAcc = mean(accData(1+(i-1)*4:i*4,1:3));
%             priorAcc = postAcc;
        else
            postAcc = mean(accData(1+(i-1)*4:i*4,1:3));
%             postAcc = priorAcc.*c + postAcc.*(1-c);
%             priorAcc = postAcc;
        end
        q = ecompass(postAcc,magnetic);

        Attitude(i,1) = accData(i*4,4);
        Attitude(i,2:4) = eulerd(q, 'ZYX', 'frame');        
    end
    
    sqrt(var(Attitude(:,2)))
    sqrt(var(Attitude(:,3)))