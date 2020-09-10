n = length(GPS);
GPS_Decode = zeros(n,5);
for i=1:n
    %时间
    second = mod(GPS(i,1),100);
    minute = (mod(GPS(i,1),10000) - second)/100;
    hour = (GPS(i,1) - minute*100 - second)/10000;
    GPS_Decode(i,1) = hour*3600+minute*60+second;
    %纬度 3959.776805
    Degree =fix(GPS(i,2)/100);
    Dminute = GPS(i,2) - Degree*100;
    GPS_Decode(i,2) = Degree + Dminute/60;
    %经度 11619.57679910000
    Degree =fix(GPS(i,3)/100);
    Dminute = GPS(i,3) - Degree*100;
    GPS_Decode(i,3) = Degree + Dminute/60;    
    %高程
    GPS_Decode(i,4) = GPS(i,5);
    %水平定位精度
    GPS_Decode(i,5) = GPS(i,4);
end

clear Degree Dminute hour i minute n second;


figure;
plot(GPS_Decode(:,3),GPS_Decode(:,2));

figure;
plot(Second_Decode(:,3),Second_Decode(:,2),'r');

figure;
plot(GPS1_Decode(:,3),GPS1_Decode(:,2));
hold on; plot(GPS2_Decode(:,3),GPS2_Decode(:,2),'r');