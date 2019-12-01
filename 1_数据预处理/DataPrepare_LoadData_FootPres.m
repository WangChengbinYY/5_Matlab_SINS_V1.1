function FootPres = DataPrepare_LoadData_FootPres(mLoadPath)
%

FootPres = [];
Temp = load(mLoadPath);
if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;
    FootPres = zeros(L,6);
    FootPres(1:L,1) = Temp(1:L,1)+Temp(1:L,2)./1000.0;
    FootPres(1:L,2:5) = Temp(1:L,3:6);
    FootPres(1:L,6) = Temp(1:L,7);
end         
        
       
     