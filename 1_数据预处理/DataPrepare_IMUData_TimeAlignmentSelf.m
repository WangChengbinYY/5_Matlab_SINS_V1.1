function DataPrepare_IMUData_TimeAlignmentSelf(mDataPath,HzIMU,HzMag,mTimeStart,mTimeEnd)
% 数据时间的自对整包括以下内容
%1.将输入的数据，先按照内部时钟(从0开始)，进行采样间隔对整，IMU和Mag的采样间隔不一样
%2.将UWB的数据进行插值对齐
%3.然后再按照设定的时间段，进行数据截取 

HzIMU = 200;
HzMag = 100;
%% 1.时间对整处理
%采样间隔
DeltaT_IMU = 1/HzIMU;
DeltaT_Mag = 1/HzMag;

%读取数据
load(mDataPath);
% 1.1 处理IMU数据
if exist('IMU','var')
    [L,n] = size(IMU);
    %先判断IMU是否丢数
    j = 1;    
    mLoseRecord=[0,0];
    mLoseTime = 0;
    for i=1:L-1
        tNumber = round((IMU(i+1,1)-IMU(i,1))/DeltaT_IMU)-1;
        if tNumber > 0            
            mLoseRecord(j,1) = i+1;
            mLoseRecord(j,2) = tNumber;
            j = j+1;
            mLoseTime = mLoseTime+1;
        end
    end    
    
    %丢数，进行插值
    mStartTime = round(IMU(1,1)/DeltaT_IMU)*DeltaT_IMU;
    if mLoseTime > 0
        IMUNew = zeros(L+sum(mLoseRecord(:,2)),n);
        if exist('FootPres','var')
            [k,m] = size(FootPres);
            FootPresNew = zeros(L+sum(mLoseRecord(:,2)),m);
        end
        j=1;
        mAddNumber = 0;
        for i=1:L
            if i == mLoseRecord(j,1)
                % 按照缺的个数插值！
                for k=1:mLoseRecord(j,2)
                   %插值！ 
                   % IMUNew(i+mAddNumber,:) 
                   IMUNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                   if exist('FootPres','var')
                        %插值！ 
                        % FootPresNew(i+mAddNumber,:) 
                        FootPresNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                    end
                   mAddNumber = mAddNumber+1;
                end                
                %插完后，正常赋值                
                IMUNew(i+mAddNumber,:) = IMU(i,:);
                IMUNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                if exist('FootPres','var')
                    FootPresNew(i+mAddNumber,:) = FootPres(i,:);
                    FootPresNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                end                
                if j < mLoseTime
                    j=j+1;
                end
            else
               % 正常赋值               
               IMUNew(i+mAddNumber,:) = IMU(i,:);
               IMUNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
               if exist('FootPres','var')
                    FootPresNew(i+mAddNumber,:) = FootPres(i,:);
                    FootPresNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
               end 
            end        
        end
    else
    %否则，从开始时间按照等间隔进行时间对齐
        IMUNew = zeros(L,n);
        for i = 1:L
            IMUNew(i,:) = IMU(i,:);
            IMUNew(i,1) = mStartTime + (i-1)*DeltaT_IMU;            
        end  
        if exist('FootPres','var') 
            [k,m] = size(FootPres);
            FootPresNew = zeros(k,m);
            for i = 1:k
                FootPresNew(i,:) = FootPres(i,:);
                FootPresNew(i,1) = mStartTime + (i-1)*DeltaT_IMU;            
            end             
        end
    end
    IMU = IMUNew; 
    save(mDataPath,'IMU','-append');
    if exist('FootPres','var')     
        FootPres = FootPresNew;
        save(mDataPath,'FootPres','-append');
    end
end

% 1.2 处理UWB数据  按照IMU的采样频率对整   
if exist('UWB','var')
    [L,n] = size(UWB);
    %先判断IMU是否丢数
    j = 1;    
    mLoseRecord=[0,0];
    mLoseTime = 0;
    for i=1:L-1
        tNumber = round((UWB(i+1,1)-UWB(i,1))/DeltaT_IMU)-1;
        if tNumber > 0            
            mLoseRecord(j,1) = i+1;
            mLoseRecord(j,2) = tNumber;
            j = j+1;
            mLoseTime = mLoseTime+1;
        end
    end    
    
    %丢数，进行插值
    mStartTime = round(UWB(1,1)/DeltaT_IMU)*DeltaT_IMU;
    if mLoseTime > 0
        UWBNew = zeros(L+sum(mLoseRecord(:,2)),n);
        j=1;
        mAddNumber = 0;
        for i=1:L
            if i == mLoseRecord(j,1)
                % 按照缺的个数插值！
                for k=1:mLoseRecord(j,2)
                   %插值！ 
                   % UWBNew(i+mAddNumber,:) 
                   UWBNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                   mAddNumber = mAddNumber+1;
                end                
                %插完后，正常赋值                
                UWBNew(i+mAddNumber,:) = UWB(i,:);
                UWBNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;             
                if j < mLoseTime
                    j=j+1;
                end
            else
               % 正常赋值               
               UWBNew(i+mAddNumber,:) = UWB(i,:);
               UWBNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
            end        
        end
    else
    %否则，从开始时间按照等间隔进行时间对齐
        UWBNew = zeros(L,n);
        for i = 1:L
            UWBNew(i,:) = UWB(i,:);
            UWBNew(i,1) = mStartTime + (i-1)*DeltaT_IMU;            
        end  
    end
    UWB = UWBNew; 
    save(mDataPath,'UWB','-append');
end

% 1.3 处理Magnetic数据   
if exist('Magnetic','var')
    [L,n] = size(Magnetic);
    %先判断IMU是否丢数
    j = 1;    
    mLoseRecord=[0,0];
    mLoseTime = 0;
    for i=1:L-1
        tNumber = round((Magnetic(i+1,1)-Magnetic(i,1))/DeltaT_Mag)-1;
        if tNumber > 0            
            mLoseRecord(j,1) = i+1;
            mLoseRecord(j,2) = tNumber;
            j = j+1;
            mLoseTime = mLoseTime+1;
        end
    end    
    
    %丢数，进行插值
    mStartTime = round(Magnetic(1,1)/DeltaT_Mag)*DeltaT_Mag;
    if mLoseTime > 0
        MagneticNew = zeros(L+sum(mLoseRecord(:,2)),n);
        j=1;
        mAddNumber = 0;
        for i=1:L
            if i == mLoseRecord(j,1)
                % 按照缺的个数插值！
                for k=1:mLoseRecord(j,2)
                   %插值！ 
                   % MagneticNew(i+mAddNumber,:) 
                   MagneticNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_Mag;
                   mAddNumber = mAddNumber+1;
                end                
                %插完后，正常赋值                
                MagneticNew(i+mAddNumber,:) = Magnetic(i,:);
                MagneticNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_Mag;             
                if j < mLoseTime
                    j=j+1;
                end
            else
               % 正常赋值               
               MagneticNew(i+mAddNumber,:) = Magnetic(i,:);
               MagneticNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_Mag;
            end        
        end
    else
    %否则，从开始时间按照等间隔进行时间对齐
        MagneticNew = zeros(L,n);
        for i = 1:L
            MagneticNew(i,:) = Magnetic(i,:);
            MagneticNew(i,1) = mStartTime + (i-1)*DeltaT_Mag;            
        end  
    end
    Magnetic = MagneticNew; 
    save(mDataPath,'Magnetic','-append');
end



