function [Second,SerialNum] = DataPrepare_IMUData_FindSecondSerial(mData,mSecond)
% 1.查找数据中对应整秒的起始位置
[L,m] = size(mData);

for i = 1:L
       %没找到输入的有效整秒数
       if ( mData(i,1) > mSecond)
           mSecond = mSecond + 1;
       end
       if  (mData(i,1) == mSecond)&&(mData(i,m)==1)
           %找到整秒的起点了
           Second = mSecond;
           SerialNum = i;
           return;
       end
end

%整个数据都没找到有效的整秒起点
SerialNum = 0;

