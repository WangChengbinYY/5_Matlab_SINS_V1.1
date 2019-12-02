mData = ADISRUBIMUADIS;
[L,m] = size(mData);
mState = 0;
mSerialNum = 0; mSeconds = 26183; mMseconds = 0; mState = 0;
mTimeCorde = []; j=1;
for i=1:L
    if (mData(i,m)==1)&&(mSeconds == mData(i,1))
        mTimeCorde(j,1) = i;
        mTimeCorde(j,2) = mSeconds;
        mTimeCorde(j,3) = mData(i,2);
        mTimeCorde(j,4) = mData(i,m);
        mTimeCorde(j,5) = 0;
        if j>1
            mTimeCorde(j-1,5) = mTimeCorde(j,1)-mTimeCorde(j-1,1);
        end
        j=j+1;
        mSeconds = mSeconds+1;
    end
end

Try(:,2) = Try(:,2) - 5;    
Try(198:199,2) = Try(198:199,2)+1000;
for i=1:199
    Try(i,3) = (i-1)*5;
end
    