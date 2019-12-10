i = 1;
while i<20
    if i == 1
        while i < 10            
            fprintf(" %d",i);
            i = i+2;
        end
        continue;
    end
    fprintf(" %d",i);
    i = i+1;
end

a = zeros(100,2);
for i = 1:100
    a(i,1) = i;
    a(i,2) = 100-i;
end




