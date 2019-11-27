n = length(GPS1);
GPS1_Decode = zeros(n,5);
for i=1:n
    %时间
    second = mod(GPS1(i,1),100);
    minute = (mod(GPS1(i,1),10000) - second)/100;
    hour = (GPS1(i,1) - minute*100 - second)/10000;
    GPS1_Decode(i,1) = hour*3600+minute*60+second;
    %纬度 3959.776805
    Degree =fix(GPS1(i,2)/100);
    Dminute = GPS1(i,2) - Degree*100;
    GPS1_Decode(i,2) = Degree + Dminute/60;
    %经度 11619.57679910000
    Degree =fix(GPS1(i,3)/100);
    Dminute = GPS1(i,3) - Degree*100;
    GPS1_Decode(i,3) = Degree + Dminute/60;    
    %高程
    GPS1_Decode(i,4) = GPS1(i,5);
    %水平定位精度
    GPS1_Decode(i,5) = GPS1(i,4);
end



figure;
plot(GPS1_Decode(:,3),GPS1_Decode(:,2));

figure;
plot(Second_Decode(:,3),Second_Decode(:,2),'r');