% ��� ��Ӧ�Ⱥ�����һ���趨Ϊ ��Ҫ��ȡ�ļ�ֵ����
function J = fun_DE(x,y)
    J =  20*exp(-0.2*sqrt(x^2+y^2/2))+exp(cos((2*pi*x)+cos(2*pi*y))/2)+exp(1);
end