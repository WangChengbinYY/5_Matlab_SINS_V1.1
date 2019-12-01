function UWB = DataPrepare_LoadData_UWB(mLoadPath)
%

UWB = [];
Temp = load(mLoadPath);
if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;
    UWB = zeros(L,3);
    UWB(1:L,1) = Temp(1:L,1)+Temp(1:L,2)./1000.0;
    UWB(1:L,2) = Temp(1:L,3);
    UWB(1:L,3) = Temp(1:L,4);
end         
      