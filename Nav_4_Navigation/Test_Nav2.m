L = length(StaticRecord);
n = 0;figure;
for i=1:L
    hold on;
    num = StaticRecord(i,2) - StaticRecord(i,1) + 1;
    plot((n+1:n+num),IMU(StaticRecord(i,1):StaticRecord(i,2),2));
    hold on;
    plot((n+num),mean(IMU(StaticRecord(i,1):StaticRecord(i,2),2)),'*');
    n = n+num;
end





L = length(StaticRecord);
n = 0;figure;
for i=1:L-1
    hold on;
    num = ceil(StaticRecord(i,2)/2) - ceil(StaticRecord(i,1)/2) + 1;
    plot((n+1:n+num),Magnetic(ceil(StaticRecord(i,1)/2):ceil(StaticRecord(i,2)/2),4));
    n = n+num;
end