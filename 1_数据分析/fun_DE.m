% 设计 适应度函数，一般设定为 所要求取的极值函数
function J = fun_DE(x,y)
    J =  20*exp(-0.2*sqrt(x^2+y^2/2))+exp(cos((2*pi*x)+cos(2*pi*y))/2)+exp(1);
end