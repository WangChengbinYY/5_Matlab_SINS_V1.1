function varargout = IndividualNavigation_DataPrepare(varargin)
% INDIVIDUALNAVIGATION_DATAPREPARE MATLAB code for IndividualNavigation_DataPrepare.fig
%      INDIVIDUALNAVIGATION_DATAPREPARE, by itself, creates a new INDIVIDUALNAVIGATION_DATAPREPARE or raises the existing
%      singleton*.
%
%      H = INDIVIDUALNAVIGATION_DATAPREPARE returns the handle to a new INDIVIDUALNAVIGATION_DATAPREPARE or the handle to
%      the existing singleton*.
%
%      INDIVIDUALNAVIGATION_DATAPREPARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INDIVIDUALNAVIGATION_DATAPREPARE.M with the given input arguments.
%
%      INDIVIDUALNAVIGATION_DATAPREPARE('Property','Value',...) creates a new INDIVIDUALNAVIGATION_DATAPREPARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IndividualNavigation_DataPrepare_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IndividualNavigation_DataPrepare_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IndividualNavigation_DataPrepare

% Last Modified by GUIDE v2.5 03-Dec-2019 00:11:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IndividualNavigation_DataPrepare_OpeningFcn, ...
                   'gui_OutputFcn',  @IndividualNavigation_DataPrepare_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before IndividualNavigation_DataPrepare is made visible.
function IndividualNavigation_DataPrepare_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IndividualNavigation_DataPrepare (see VARARGIN)

% Choose default command line output for IndividualNavigation_DataPrepare
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%===========================全局变量设定=====================================
%IMU 待处理数据文件名 文件路径 
global IMU_FilePath IMU_FileName
IMU_FilePath = []; IMU_FileName = [];
%选择的设备种类 1:First(MPU)(默认) 2:Second(MTi) 3:Third(ADIS) 
global Choose_Device
Choose_Device = 1;
%选择存储的数据类型 
%   1:IMUA(MPU_Only)(默认) 2:IMUB(MPU_Only) 3:IMUB(MTi_Only) 4:IMUB(ADIS_Only) 
%   5:IMUB(ADIS)+IMUA(MPU_Magnetic) 6:IMUB(MPU)+IMUA(MPU)
global Choose_DataKinde
Choose_DataKinde = 1;
%选择左脚或右脚数据 1:左脚(含UWB)(默认) 2:左脚(不含UWB) 3:右脚(不含UWB)
global Choose_Foot_LeftorRight
Choose_Foot_LeftorRight = 1;
%是否包含脚底压力传感器 1:不包含(默认) 2:包含
global Choose_FootPressure
Choose_FootPressure = 1;

%选择时间同步输入 1:内部GPS时间(默认)(从有效定位UTC时间天内秒开始) 2:内部时钟(从0秒开始计时)
global Choose_Time
Choose_Time = 1;
%外部高精度定位数据(北斗伴侣) 0:无 1:有  
%   txt数据格式为 hhmmss.sss ddmm.mmmmmmm dddmm.mmmmmmm 水平精度(米) 高程(米)
%   整理输出为: 天内秒 纬度 经度 高程 水平精度
global Choose_HighGPSData
Choose_HighGPSData = 0;
%外部高精度定位数据(北斗伴侣) 待处理数据文件名 文件路径 
global GPS_FilePath GPS_FileName 
GPS_FilePath = [];  GPS_FileName = [];
%预处理完成后，存放的路径及名称
global tDataSavePath tPath
tDataSavePath = []; tPath = [];
%时间截取的 起始和结束时间 单位S
global Time_Start Time_End
Time_Start = 0.0;   Time_End = 0.0;
% UIWAIT makes IndividualNavigation_DataPrepare wait for user response (see UIRESUME)
% uiwait(handles.figure1);

disp('*/\/\/\/\/\/\/\/\/\/\程序启动/\/\/\/\/\/\/\/\/\/\*');

% --- Outputs from this function are returned to the command line.
function varargout = IndividualNavigation_DataPrepare_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global IMU_FileName;  %待处理数据文件名 
% global IMU_FilePath;  %待处理数据文件路径
% [IMU_FileName,IMU_FilePath] = uigetfile("*.dat","选择要预处理的原始数据");

global IMU_FileName IMU_FilePath tDataSavePath tPath
[IMU_FileName,IMU_FilePath] = uigetfile('*.dat');
if isequal(IMU_FileName,0)
   
else  
   set(handles.edit1,'string',strcat(IMU_FilePath,IMU_FileName));
   % 1. 获取文件路径
    tIndex = strfind(IMU_FileName,'.');
    tName = IMU_FileName(1:tIndex-1);  %预处理后数据mat 存储的名称
    tPath = [IMU_FilePath,tName];
    tDataSavePath = [IMU_FilePath,tName,'.mat'];
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String','');
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%------------------------ 读取IMU 及 外部 相关的所有数据-----------------------------
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 0. 全局变量声明
global IMU_FilePath IMU_FileName Choose_Device Choose_DataKinde Choose_Time
global Choose_Foot_LeftorRight Choose_FootPressure tDataSavePath tPath

if isempty(tDataSavePath) == 1
    disp('警告：****未设置保存数据路径，请点击打开按钮！*****');
    return;
end

disp('*****************************************************');
disp('*-------------------数据读取开始---------------------*');
%% 1. 读取IMU相关数据
if isempty(IMU_FilePath) == 1
    disp('警告：******未设置IMU数据路径！******');
else
%根据参数的设定，读取模块对应的数据
%   不同模块的使用，仅在 IMU 和 Magnetic 上的有区别
    %% 1.1 IMU 和 Magnetic 在一起的情况
    % 第一种情况：First IMUB_MPU_Only 
    if Choose_Device == 1 && Choose_DataKinde == 1  
        Path_IMU = [tPath,'_UB_IMU_MPU.txt'];  %包含磁强计 
        [IMU,Magnetic] = DataPrepare_LoadData_IMU_Include_Magnetic(Path_IMU);
        if isempty(IMU) == 1 
            disp('1.*****IMU数据为空*****');
        else
            save(tDataSavePath,'IMU');                  %存储
            disp('1. IMU数据存储成功！');
            DataPrepare_PlotData_Original(IMU,1);       %绘制
            save(tDataSavePath,'Magnetic','-append');   %存储
            disp('2. Magnetic数据存储成功！');              
            DataPrepare_PlotData_Original(Magnetic,2);  %绘制
        end
    end
    % 第二种情况：Third IMUB_ADIS + IMUA_MPU_Magnetic
    if Choose_Device == 3 && Choose_DataKinde == 5 
        Path_IMU = [tPath,'_UB_IMU_ADIS.txt']; 
        IMU = DataPrepare_LoadData_IMU_Only(Path_IMU);
        if isempty(IMU) == 1 
            disp('1.*****IMU数据为空*****');
        else
            save(tDataSavePath,'IMU');                  %存储
            disp('1. IMU数据存储成功！');
            DataPrepare_PlotData_Original(IMU,1);       %绘制
        end
        %读取IMUA_MPU的磁强计数据 并存储
        Path_Magnetic = [tPath,'_UA_Magnetic_MPU.txt']; 
        Magnetic = DataPrepare_LoadData_Magnetic_Only(Path_Magnetic);
        if isempty(Magnetic) == 1
            disp('2.******磁强计数据读取失败！******');
        else
            save(tDataSavePath,'Magnetic','-append');
            disp('2. Magnetic数据存储成功！'); 
            DataPrepare_PlotData_Original(Magnetic,2);
        end        
    end
    %% 1.2 读取足底压力数据
    if Choose_FootPressure == 1
        Path_FootPres = [tPath,'_FootPressure.txt'];  
        FootPres = DataPrepare_LoadData_FootPres(Path_FootPres);
        if isempty(FootPres) == 1
            disp('3.*****FootPress数据读取失败******');
        else
            save(tDataSavePath,'FootPres','-append');
            disp('3. FootPress数据存储成功！');
            DataPrepare_PlotData_Original(FootPres,3);
        end            
    end

    %% 1.3 读取UWB测距数据
    if Choose_Foot_LeftorRight == 1       %左脚含UWB数据
        Path_UWB = [tPath,'_UWB.txt'];  
        UWB = DataPrepare_LoadData_UWB(Path_UWB);
        if isempty(UWB) == 1
            disp('3.*****FootPress数据读取失败******');
        else
            save(tDataSavePath,'UWB','-append');
            disp('4. UWB数据存储成功！');
            DataPrepare_PlotData_Original(UWB,4);
        end              
    end

    %% 1.4 读取GPS数据
    if Choose_Time == 1       %使用GPS时间，意味着有GPS数据
        Path_GPS = [tPath,'_GPS.txt'];  
        GPS = load(Path_GPS);
        if isempty(GPS) == 1
            disp('5.******GPS数据读取失败******');
        else
            %单位转换
            GPS(:,2:3) = GPS(:,2:3).*(pi/180.0);
            save(tDataSavePath,'GPS','-append');
            disp('5. GPS数据存储成功！');
            DataPrepare_PlotData_Original(GPS,5);
        end                
    end    
end
 
%% 2. 读取外部北斗伴侣的高精度GPS数据
%外部高精度定位数据(北斗伴侣) 0:无 1:有  
%   txt数据格式为 hhmmss.sss ddmm.mmmmmmm dddmm.mmmmmmm 水平精度(米) 高程(米)
%   整理输出为: 天内秒 纬度 经度 高程 水平精度
global Choose_HighGPSData
%外部高精度定位数据(北斗伴侣) 待处理数据文件名 文件路径 
global GPS_FilePath GPS_FileName 

if isempty(GPS_FilePath) == 1
    disp('警告：******未设置高精度GPS数据路径！******');
else
    if Choose_HighGPSData == 1 
        Path_HighGPS = [GPS_FilePath,GPS_FileName];     
        Temp = load(Path_HighGPS);
        if isempty(Temp) == 1
            disp('5.******High GPS数据读取失败******');
        else 
            L = length(Temp);
            HighGPS = zeros(L,6);
            for i=1:L
                %时间计算
                Second = fix(mod(Temp(i,1),100));   %有的时候北斗伴侣输出是带ms了
                Minute = fix(fix(mod(Temp(i,1),10000))/100);
                Hour = fix(Temp(i,1)/10000);
                HighGPS(i,1) = Hour*3600+Minute*60+Second;
                %纬度计算
                Degree = fix(Temp(i,2)/100);
                DMinute = mod(Temp(i,2),100);
                HighGPS(i,2) = Degree+DMinute/60.0;
                %经度计算
                Degree = fix(Temp(i,3)/100);
                DMinute = mod(Temp(i,3),100);
                HighGPS(i,3) = Degree+DMinute/60.0;
                %高程
                HighGPS(i,4) = Temp(i,6);
                %水平定位精度
                HighGPS(i,5) = Temp(i,5);
                %定位模式 0 无效 1单点 4RTK浮点 5RTK固定 6惯导
                HighGPS(i,6) = Temp(i,4);
            end
            HighGPS(:,2:3) = HighGPS(:,2:3).*(pi/180.0);
            save(tDataSavePath,'HighGPS','-append');
            disp('5.High GPS数据存储成功！');
            DataPrepare_PlotData_Original(HighGPS,6);
        end      
    end
end

disp('*-------------------数据读取完成--------------------*！');
disp('*****************************************************');

% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%选择的设备种类 1:First(MPU)(默认) 2:Second(MTi) 3:Third(ADIS) 
global Choose_Device
str = get(hObject,'tag');
switch str
    case 'radiobutton1'
        Choose_Device = 1;
    case 'radiobutton2'
        Choose_Device = 2;     
    case 'radiobutton3'
        Choose_Device = 3;
end


% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%   1:IMUA(MPU_Only)(默认) 2:IMUB(MPU_Only) 3:IMUB(MTi_Only) 4:IMUB(ADIS_Only) 
%   5:IMUB(ADIS)+IMUA(MPU_Magnetic) 6:IMUB(MPU)+IMUA(MPU)
global Choose_DataKinde
str = get(hObject,'tag');
switch str
    case 'radiobutton4'
        Choose_DataKinde = 1;
    case 'radiobutton5'
        Choose_DataKinde = 2;    
    case 'radiobutton6'
        Choose_DataKinde = 3;
    case 'radiobutton7'
        Choose_DataKinde = 4;
    case 'radiobutton8'
        Choose_DataKinde = 5; 
    case 'radiobutton9'
        Choose_DataKinde = 6;    
end


% --- Executes when selected object is changed in uibuttongroup3.
function uibuttongroup3_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup3 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%选择左脚或右脚数据 1:左脚(含UWB)(默认) 2:左脚(不含UWB) 3:右脚(不含UWB)
global Choose_Foot_LeftorRight
str = get(hObject,'tag');
switch str
    case 'radiobutton10'
        Choose_Foot_LeftorRight = 1;
    case 'radiobutton11'
        Choose_Foot_LeftorRight = 2;  
    case 'radiobutton12'
        Choose_Foot_LeftorRight = 3;
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%选择时间同步输入 1:内部GPS时间(默认)(从有效定位UTC时间天内秒开始) 2:内部时钟(从0秒开始计时)
%% 0. 先获取需要截取时间段的 起始和结束 时间
global Time_Start Time_End tDataSavePath
Time_Start = str2double(get(handles.edit2,'String'));
Time_End = str2double(get(handles.edit4,'String'));
global Choose_Time
disp('----------------------------------------------------');
disp('*------------------开始时间同步处理-----------------*');
if isempty(tDataSavePath) == 1
    disp('*-----------数据路径为空，无法读取数据！------------*');    
    disp('****************************************************');
    return;
end

%% 1. 使用GPS时间同步
if Choose_Time == 1          
    DataPrepare_IMUData_TimeAlignmentUTC(tDataSavePath,200,100,Time_Start,Time_End);  
    disp('*---------------使用GPS时钟同步完成！---------------*');    
    disp('****************************************************');
end

%% 2. 使用内部时钟
if Choose_Time == 2
    DataPrepare_IMUData_TimeAlignmentSelf(tDataSavePath,200,100,Time_Start,Time_End); 
    disp('*--------------使用内部时钟，处理完成！--------------*');
    disp('****************************************************');
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% 1. 利用压力传感器和IMU数据进行脚步状态判断


%% 2. UWB 的数据低通滤波  还可以考虑 磁强计的数据低通滤波


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String','0');
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup6.
function uibuttongroup6_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup6 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%选择时间同步输入 1:内部时钟(默认)(从0秒开始计时) 2:内部GPS时间(从有效定位UTC时间天内秒开始)
global Choose_Time
str = get(hObject,'tag');
switch str
    case 'radiobutton13'
        Choose_Time = 1;
    case 'radiobutton14'
        Choose_Time = 2;
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
%外部高精度定位数据(北斗伴侣) 0:无 1:有  
%   txt数据格式为 hhmmss.sss ddmm.mmmmmmm dddmm.mmmmmmm 水平精度(米) 高程(米)
%   整理输出为: 天内秒 纬度 经度 高程 水平精度
global Choose_HighGPSData
global GPS_FilePath GPS_FileName 
Choose_HighGPSData = get(hObject,'Value');
if Choose_HighGPSData == 0
    set(handles.edit3,'string','');
else    
    [GPS_FileName,GPS_FilePath] = uigetfile('*.txt');
    if isequal(GPS_FileName,0)
       set(hObject,'Value',0);
       Choose_HighGPSData = 0;
    else
       Choose_HighGPSData = 1;
       set(hObject,'Value',1);
       set(handles.edit3,'string',strcat(GPS_FilePath,GPS_FileName));
    end
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'String','');
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear global IMU_FilePath IMU_FileName Choose_Device Choose_DataKinde
clear global Choose_Foot_LeftorRight Choose_Time Choose_HighGPSData
clear global GPS_FilePath GPS_FileName 
disp('*/\/\/\/\/\/\/\/\/\/\程序退出/\/\/\/\/\/\/\/\/\/\*');

% --- Executes when selected object is changed in uibuttongroup7.
function uibuttongroup7_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup7 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%是否包含脚底压力传感器 1:不包含(默认) 2:包含
global Choose_FootPressure
str = get(hObject,'tag');
switch str
    case 'radiobutton16'
        Choose_FootPressure = 1;
    case 'radiobutton17'
        Choose_FootPressure = 2;
end






function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FootPres = DataPrepare_LoadData_FootPres(mLoadPath)
%按照路径读取足底压力数据的txt
FootPres = [];
Temp = load(mLoadPath);
if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;
    FootPres = zeros(L,7);
    FootPres(1:L,1:7) = Temp(1:L,1:7);
end         
        

function [IMU,Magnetic] = DataPrepare_LoadData_IMU_Include_Magnetic(mLoadPath)
% %按照路径读取包含磁强计数据的 IMU 数据 的txt文件
% 注意：目前使用的是MPU9250 IMU采样频率是200Hz，磁强计是100Hz，如果变动，这里需要进行改变
IMU = [];
Magnetic = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %陀螺单位是度/s  加计 m/s2 磁强计 uT
    IMU = zeros(L,9);       
    IMU(1:L,1:5) = Temp(1:L,1:5);  
    IMU(1:L,6:8) = Temp(1:L,6:8)./(180.0/pi);   
    IMU(1:L,9) = Temp(1:L,13);  %时间状态
    %拆分磁强计数据 
    Magnetic = zeros(fix(L/2),6);
    for i=1:fix(L/2)
        Magnetic(i,1:2) = IMU(1+(i-1)*2,1:2); %时间        
        Magnetic(i,3:5) = Temp(1+(i-1)*2,9:11);
        Magnetic(i,6) = Temp(1+(i-1)*2,13); %时间状态
    end      
end


function IMU = DataPrepare_LoadData_IMU_Only(mLoadPath)
% 读取不包含磁强计数据的 IMU 数据 (ADIS)
IMU = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %陀螺单位是度/s  加计 m/s2 磁强计 uT
    IMU = zeros(L,9);       %最后一列带时间标
    IMU(1:L,1:5) = Temp(1:L,1:5);
    IMU(1:L,6:8) = Temp(1:L,6:8)./(180.0/pi);   
    IMU(1:L,9) = Temp(1:L,11);
end


function Magnetic = DataPrepare_LoadData_Magnetic_Only(mLoadPath)
% 读取磁强计数据  从IMUA_MPU9250采集   磁强计采集频率100Hz
Magnetic = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %磁强计单位 uT
    Magnetic = zeros(L,6);
    Magnetic(1:L,1:6) = Temp(1:L,1:6);    %包含时间状态
end

function UWB = DataPrepare_LoadData_UWB(mLoadPath)
%
UWB = [];
Temp = load(mLoadPath);
if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;
    UWB = zeros(L,4);
    UWB(1:L,1:4) = Temp(1:L,1:4);
end  





