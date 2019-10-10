n = 339505;
Vector = zeros(n,3);
for i=1:n
   Vector(i,1) = Data_IMUB_R(i,1);
   Vector(i,2) = sqrt(Data_IMUB_R(i,2)^2+Data_IMUB_R(i,3)^2+Data_IMUB_R(i,4)^2);
   Vector(i,3) = sqrt(Data_IMUB_R(i,5)^2+Data_IMUB_R(i,6)^2+Data_IMUB_R(i,7)^2);
end



