L=length(Data_IMUB_L);
%�����ж�
Data_Foot_L_State_Sum = zeros(L,2);
Data_Foot_L_State = zeros(L,2);
Temp_sum = 5;  %ʹ��5�����ݽ����ж�  ��������
Temp_State = 0;
Temp_GyroX_Max =  
for i = 1:L
    Data_Foot_L_State_Sum(i,1) = Data_Foot_L_Ex(i,1);
    Data_Foot_L_State(i,1) = Data_Foot_L_Ex(i,1);
    if ((Data_Foot_L_Ex(i,2)+Data_Foot_L_Ex(i,4)+Data_Foot_L_Ex(i,5))>10) 
        Data_Foot_L_State_Sum(i,2) = 1;
        if(Temp_State == 0)   %�ɶ�̬���뵽��̬
            %�жϺ���5�������Ƿ�ϸ�
            if(i+Temp_sum-1 <= L)
                %����������ƽ��ֵ�ͷ���
                if (1)%��������
                   Data_Foot_L_State(i,2) = 1;
                   Temp_State = 1;    %�˿̲��϶����뾲̬
                end
            end
        end                  
        if(Temp_State == 1)  %�����Ѿ����뾲̬��
            Data_Foot_L_State(i,2) = 1;
        end
    else        
        Data_Foot_L_State_Sum(i,2) = 0;
        Data_Foot_L_State(i,2) = 0;
        if(Temp_State==1)
            Temp_State = 0;
            %��ǰ׷�� �жϾ�ֹ״̬
            
        end        
    end
end

%�ٴγ����ж�
%���ٶȼƵ�ʸ���� �� ���� �� ��ֵ
Temp_sum = 5;  %ʹ��5�����ݽ����ж�  ��������
for i = 2:L-1
   %��ͷ
   if(Data_Foot_L_State_Sum(i-1,2)==0 && Data_Foot_L_State_Sum(i,2)==1)
       if(i+Temp_sum-1 <= L)
           
       end
   end
   %ȥβ
   if(Data_Foot_L_State_Sum(i,2)==1 && Data_Foot_L_State_Sum(i+1,2)==0)
       
   end   
end

for j = 1:10
   j 
end

