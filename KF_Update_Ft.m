function [Ft,Gt] = KF_Update_Ft(mode,InsData)
% 根据当前时刻的INS数据，进行Ft的计算更新

if(mode == 1)
    lat = InsData.pos(1,1);     %纬度
    tan_lat = tan(lat); sec_lat = sec(lat);
    Rmh = InsData.Rmh;
    Rnh = InsData.Rnh;
    V_E = InsData.vel(1,1);V_N = InsData.vel(2,1);V_U = InsData.vel(3,1);
    w_ie_n = InsData.w_ie_n;
    w_in_n = InsData.w_in_n;
    f_ib_n = InsData.f_ib_n;
    O33 = zeros(3);
    M_1 = O33; 
        M_1(2,1)=-w_ie_n(3,1);M_1(3,1)=w_ie_n(2,1);
    M_2 = O33; 
        M_2(1,3)=V_N/Rmh/Rmh; M_2(2,3)=-V_E/Rnh/Rnh; 
        M_2(3,1)=V_E*sec_lat*sec_lat/Rnh;
        M_2(3,3)=-V_E*tan_lat/Rnh/Rnh;
    M_ap = M_1 + M_2;
    M_aa = -askew(w_in_n);
    M_av = O33; 
        M_av(1,2)=-1/Rmh; M_av(2,1)=1/Rnh;M_av(3,1)=tan_lat/Rnh;
    M_va = askew(f_ib_n);
    M_vv = O33;
        Temp_Vn_askew = askew(InsData.vel);
        Temp = w_ie_n+w_in_n;
        Temp_w_askew = askew(Temp);
        M_vv = Temp_Vn_askew*M_av - Temp_w_askew;
    M_vp = Temp_Vn_askew*(2*M_1+M_2);   %这里考虑 g 重力偏差等误差的影响 非常重要！！！！    
        g0 = 9.7803267714;  slat = sin(lat); clat=cos(lat);    
        M_vp(3,1) = M_vp(1,3)-g0*(5.27094e-3*2*slat*clat+2.32718e-5*4*slat^3*clat); 
        M_vp(3,3) = M_vp(3,3)+3.086e-6;  % 26/05/2014, good!!!
    
    M_pv = O33;
        M_pv(1,2)=1/Rmh; M_pv(2,1)=sec_lat/Rnh; M_pv(3,3)=1;
    M_pp = O33;
        M_pp(1,3)=-V_N/Rmh/Rmh; M_pp(2,1)=V_E*sec_lat*tan_lat/Rnh;
        M_pp(2,3)=-V_E*sec_lat/Rnh/Rnh;
    % 这里仅考虑陀螺加计零偏，没有使用一阶马尔科夫模型    
    Ft = [ M_aa    M_av    M_ap    -InsData.C_b_n   O33 
           M_va    M_vv    M_vp     O33             InsData.C_b_n 
           O33     M_pv    M_pp     O33             O33
           zeros(6,15)]; 
       
    Gt=zeros(15,6);
        Gt(1:3,1:3)=-InsData.C_b_n;
        Gt(4:6,4:6)=InsData.C_b_n;
end