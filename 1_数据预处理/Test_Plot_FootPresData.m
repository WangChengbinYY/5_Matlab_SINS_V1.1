%% 时间对齐后，绘制足底压力传感器和陀螺 加计数据，对照显示
%  压力传感器顺序'脚跟内侧6','脚跟外侧7','脚掌内侧5','脚掌外侧2'

%原始压力信息的比较，此时压力数值代表的还是电压
figure;
plot(FootPres(:,1),FootPres(:,2),'k');  %足底压力x
hold on; plot(FootPres(:,1),FootPres(:,3),'r');
hold on; plot(FootPres(:,1),FootPres(:,4),'g');
hold on; plot(FootPres(:,1),FootPres(:,5),'b');
xlabel('\it t \rm / s');       
title('脚底压力+陀螺X+加速度计Z');
legend('脚跟内侧','脚跟外侧','脚掌内侧','脚掌外侧');
grid on;

hold on;plot(IMU(:,1),IMU(:,4)*10+990,'-.');  %加计

hold on;plot(IMU(:,1),IMU(:,5)*50+1000,'-.');  %陀螺




