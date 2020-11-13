%四元数相关的运算

    %------------四元数 数学运算-----------
        %  四元数的声明定义 
        quat = quaternion();
        quat = quaternion(A,B,C,D) 
        
        % 求模
        norm(quat)
        % 模归一化处理
        pnormed = normalize(quat)
        % 共轭
        conj(quat)               
        
    %------------四元数 姿态运算-----------------
        % 由欧拉角转到 四元数  这个定义代表了 定坐标系n 向动坐标系b 的转动 
        % n系为 北东地  b系为 前右下
        % 转动顺序为 Z Y X   航向 俯仰 横滚    
        % 对四元数从欧拉角的定义有两种模式，一种是 点的转动，一种是参考框架的转动，
        %      这里我们选择 frame 转动
            quat = quaternion(E,'euler','ZYX','frame')
            quat = quaternion(E,'eulerd','ZYX','frame')        
        
        % 矢量的变换  利用四元数进行矢量坐标投影的变化，如下所示：
        %   代表 将定坐标系n系下的矢量 转换到 动坐标系b系下        
            Vb = rotateframe(quat, Vn)
        %   如果 导航解算中，知道 Vb，求Vn 使用：
            Vn = rotateframe(conj(quat),Vb)
            
        % 由旋转矢量 转到 四元数   这里的旋转矢量对应于 定坐标系n系 到 动坐标b系的 转动 
        %   旋转矢量[X Y Z] 在小角度情况下，不区分 欧拉角的不可交换性误差
            rotationVector = [0.3491,0.6283,0.3491];
            quat = quaternion(rotationVector,'rotvec')  
            quat = quaternion(rotationVector,'rotvecd') 

        % 有四元数 得到 n系 矢量 转到 b系 的旋转矩阵 Cbn 为 
            Cbn = rotmat(q, 'frame')
            % 如果要求 b系 矢量 到 n系的投影，可以有：
            Cnb = Cbn';
            Cnb = rotmat(conj(q),'frame')
        % 从旋转矩阵得到四元数  这里注意，旋转矩阵一定是 定坐标系n 到 动坐标系b 的转动矩阵
            quat = quaternion(Cbn,'rotmat','frame')
            
        % 从四元数中获取欧拉角  注意 得到的顺序
            tmpeuler = euler(q, 'ZYX', 'frame')
            tmpeulerd = eulerd(q, 'ZYX', 'frame')
            4
for 





