function varargout = IndividualNavigation_DataPrepare(varargin)
% IndividualNavigation_DataPrepare MATLAB code for IndividualNavigation_DataPrepare.fig
%      IndividualNavigation_DataPrepare, by itself, creates a new IndividualNavigation_DataPrepare or raises the existing
%      singleton*.
%
%      H = IndividualNavigation_DataPrepare returns the handle to a new IndividualNavigation_DataPrepare or the handle to
%      the existing singleton*.
%
%      IndividualNavigation_DataPrepare('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IndividualNavigation_DataPrepare.M with the given input arguments.
%
%      IndividualNavigation_DataPrepare('Property','Value',...) creates a new IndividualNavigation_DataPrepare or raises the
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

% Last Modified by GUIDE v2.5 10-Dec-2019 20:45:22

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
    % 第一种情况：First IMUA_MPU_Only 
    if Choose_Device == 1 && Choose_DataKinde == 2  
        Path_IMU = [tPath,'_UA_IMU_MPU.txt'];  %包含磁强计 
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

function NewData = Data_Insert_From_Start_End(First,Second,Number)
%根据起点和终点，进行 Number个数据插值 线性插值
%第一列为时间  其余为数据 最后一列为时间状态
[L,m] = size(First);
NewData = zeros(Number,m);
%插值的范围是 从第3列 到 倒数第2列
%1.计算时间间隔
DistanceTime = Second(1,1) - First(1,1);
DistanceData = Second(1,2:m-1) - First(1,2:m-1);
for i = 1:Number
    %时间更新
    NewTime = First(1,1)+DistanceTime*i/(Number+1);
    NewData(i,1) = NewTime;
    %数据更新
    NewData(i,2:m-1) = First(1,2:m-1) + DistanceData.*(i/(Number+1));
end
    

function InsertData = Data_Insert_From_Time(First,Second,Time)
%第一列是时间，后面是数据 最后一列为时间标
InserData = [];
if abs(Time-First(1,1))<0.00001   %0.01ms
    InserData = First;
    InserData(1,1) = Time;
    return;
end
if abs(Time-Second(1,1))<0.00001   %0.01ms
    InserData = Second;
    InserData(1,1) = Time;
    return;
end
if (First(1,1) < Time) && (Time < Second(1,1))
    [L,m] = size(First);
    InsertData = zeros(1,m);
    InsertData(1,1) = Time;
    InsertData(1,2:m) = (Second(1,2:m)-First(1,2:m)).*((Time-First(1,1))/(Second(1,1)-First(1,1)))+First(1,2:m);
else
    return;
end


function [Second,SerialNum] = DataPrepare_IMUData_FindSecondSerial(mData,mSecond)
% 查找数据中对应整秒的起始位置，注意这里使用的还是两列时间数据
[L,m] = size(mData);

for i = 1:L
       %没找到输入的有效整秒数
       if ( mData(i,1) > mSecond)
           mSecond = mSecond + 1;
       end
       if  (mData(i,1) == mSecond)&&(mData(i,m)==1)
           %找到整秒的起点了
           Second = mSecond;
           SerialNum = i;
           return;
       end
end

%整个数据都没找到有效的整秒起点
SerialNum = 0;
Second = 0;


function NewData = DataPrepare_IMUData_LoseCheck_And_Insert(mData,Hz)
%对输入的数据按照其自身采样记录时间进行丢包判断，并进行插值处理,最后一个点不能是授时点
% 不能有时间回跳的突变！
% 第一列为时间信息 
DeltaT_ms = 1/Hz;
[L,m] = size(mData);

% 1.先判断数据是否丢数  
% 因为 选取了两个授时点之间的数据，因此，时间序列应该是递增的
j = 1;    
mLoseRecord=[0,0];
mLoseTime = 0;
for i=1:L-1
    IntervalTime = mData(i+1,1)-mData(i,1);  %两个数据之间的时间差   
    if IntervalTime < 0
        disp("警告：整秒内数据丢包判断中，发现有跳点！") 
    end
    tNumber = round(IntervalTime/DeltaT_ms)-1;
    if tNumber > 0            
        mLoseRecord(j,1) = i+1;        %在序号 i+1之前要插数
        mLoseRecord(j,2) = tNumber;
        j = j+1;
        mLoseTime = mLoseTime+1;
        if tNumber > Hz/2
           disp("额滴神，丢数超过半秒了！！！！") 
           return;
        end
    end
end    

% 2. 根据是否丢数，进行新数据的空间声明
if mLoseTime == 0
    %没有丢数 不用差值，直接返回
    NewData = mData;
    return;
else
    %有丢数的，需要进行插值
    L1 = sum(mLoseRecord(:,2));  %需要插值的个数
    NewData = zeros(L+L1,m);
    j = 1;
    mAddNumber = 0;
    for i=1:L        
        if i == mLoseRecord(j,1)
            %第i个数前面需要插值，按照缺的个数插值！ 
            InsertData = Data_Insert_From_Start_End(mData(i-1,:),mData(i,:),mLoseRecord(j,2));
            NewData(i+mAddNumber:i+mAddNumber+mLoseRecord(j,2)-1,:) = InsertData;            
            mAddNumber = mAddNumber+mLoseRecord(j,2);  %记录已经插值的个数
            %插完后，正常赋值                
            NewData(i+mAddNumber,:) = mData(i,:);              
            if j < mLoseTime
                j=j+1;
            end
        else
           % 正常赋值               
           NewData(i+mAddNumber,:) = mData(i,:);
        end             
    end  
end

function DataPrepare_PlotData_Original(mData,mChoose)
% 对读取的数据进行绘制，便于查看图形状态
% 输入：mData 数据；mChoose 数据种类(1=IMU,2=Magnetic,3=FootPress,
%   4=UWB,5=GPS,6=HighGPS,)；


switch mChoose
    case 1
        %绘制IMU数据 时间 加计 陀螺 时间状态
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,3),'k');  %加计x
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,4),'r');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,5),'g');
        xlabel('\it t \rm / s');
        ylabel('\it m \rm / s2');
        title('加计输出');
        legend('x','y','z');
        grid on;
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,6),'k');  %陀螺x
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,7),'r');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,8),'g');
        xlabel('\it t \rm / s');
        ylabel('\it 弧度 \rm / s');
        title('陀螺输出');
        legend('x','y','z');
        grid on;     
    case 2
        %磁强计输出
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,3),'k');  %磁强计x
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,4),'r');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,5),'g');
        xlabel('\it t \rm / s');
        ylabel('\it uT');
        title('磁强计输出');
        legend('x','y','z');
        grid on;
    case 3
        %压力传感器输出
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,3),'k');  %足底压力x
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,4),'r');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,5),'g');
        hold on; plot(mData(:,1)+mData(:,2)./1000.0,mData(:,6),'b');
        xlabel('\it t \rm / s');       
        title('脚底压力输出');
        legend('脚跟内侧','脚跟外侧','脚掌内侧','脚掌外侧');
        grid on;        
    case 4
        %UWB输出
        figure;
        plot(mData(:,1)+mData(:,2)./1000.0,mData(:,3),'k');  %UWB
        xlabel('\it t \rm / s');
        ylabel('\it m');        
        title('UWB测距');
        legend('UWB');
        grid on;
    case 5
        %GPS输出
        %原始数据GPS经纬度是 角度，要转换为弧度
        G_CONST = CONST_Init();
        Rmh = Earth_get_Rmh(G_CONST,mData(1,2),mData(1,4));
        Rnh = Earth_get_Rnh(G_CONST,mData(1,2),mData(1,4));
        figure;  
        set(gcf,'position',[250,250,1200,480]);
        %水平轨迹
        subplot(1,3,1);
        plot(0, 0, 'rp');     %在起始位置画一个 五角星
        hold on;    
        plot((mData(:,3)-mData(1,3))*Rnh,(mData(:,2)-mData(1,2))*Rmh*cos(mData(1,2)));        
        xlabel('\it 东向 \rm / m');
        ylabel('\it 北向 \rm / m');
        title('行驶路线');
        grid on;
        %高程
        subplot(1,3,2);
        plot(mData(:,1),mData(:,4));
        xlabel('\it t \rm / s');
        ylabel('\it m'); 
        title('高程');
        grid on;
        %水平精度
        subplot(1,3,3);
        plot(mData(:,1),mData(:,5));
        xlabel('\it t \rm / s');
        ylabel('\it HDop \rm m'); 
        title('定位精度');
        grid on;   
     case 6   
        %高精度GPS输出
        G_CONST = CONST_Init();
        Rmh = Earth_get_Rmh(G_CONST,mData(1,2),mData(1,4));
        Rnh = Earth_get_Rnh(G_CONST,mData(1,2),mData(1,4));
        figure;  
        set(gcf,'position',[50,50,680,680]);
        %水平轨迹
        subplot(2,2,1);
        plot(0, 0, 'rp');     %在起始位置画一个 五角星
        hold on;    
        plot((mData(:,3)-mData(1,3))*Rnh,(mData(:,2)-mData(1,2))*Rmh*cos(mData(1,2)));        
        xlabel('\it 东向 \rm / m');
        ylabel('\it 北向 \rm / m');
        title('行驶路线');
        grid on;
        %高程
        subplot(2,2,2);
        plot(mData(:,1),mData(:,4));
        xlabel('\it t \rm / s');
        ylabel('\it m'); 
        title('高程');
        grid on;
        %水平精度
        subplot(2,2,3);
        plot(mData(:,1),mData(:,5));
        xlabel('\it t \rm / s');
        ylabel('\it HDop \rm m'); 
        title('定位精度');
        grid on;       
        %定位方式
        subplot(2,2,4);
        plot(mData(:,1),mData(:,6));
        xlabel('\it t \rm / s');
        ylabel('\it 定位方式'); 
        title('定位模式');
        legend('0无效 1单点 4RTK浮点 5RTK固定 6惯导')
        grid on;          
end




function DataPrepare_PlotData_TimeCuted_Compare(mData,mData_Old,mChoose)
% 对时间截取后的数据进行绘制，便于查看图形状态
% 输入：mData 数据；mChoose 数据种类(1=IMU,2=Magnetic,3=FootPress,
%   4=UWB,5=GPS,6=HighGPS,)；

switch mChoose
    case 1
        %绘制IMU数据 时间 加计 陀螺 时间状态
        figure;
        plot(mData(:,1),mData(:,2),'k');  %加计x
        hold on; plot(mData(:,1),mData(:,3),'r');
        hold on; plot(mData(:,1),mData(:,4),'g');
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,3),'k-.');  %加计x
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,4),'r-.');
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,5),'g-.');
        xlabel('\it t \rm / s');
        ylabel('\it m \rm / s2');
        title('加计输出');
        legend('x','y','z');
        grid on;
        
        figure;
        plot(mData(:,1),mData(:,5),'k');  %陀螺x
        hold on; plot(mData(:,1),mData(:,6),'r');
        hold on; plot(mData(:,1),mData(:,7),'g');
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,6),'k-.');  %陀螺x
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,7),'r-.');
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,8),'g-.');
        xlabel('\it t \rm / s');
        ylabel('\it 弧度 \rm / s');
        title('陀螺输出');
        legend('x','y','z');
        grid on;     
    case 2
        %磁强计输出
        figure;
        plot(mData(:,1),mData(:,2),'k');  %磁强计x
        hold on; plot(mData(:,1),mData(:,3),'r');
        hold on; plot(mData(:,1),mData(:,4),'g');
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,3),'k-.');  %磁强计x
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,4),'r-.');
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,5),'g-.');
        xlabel('\it t \rm / s');
        ylabel('\it uT');
        title('磁强计输出');
        legend('x','y','z');
        grid on;
    case 3
        %压力传感器输出
        figure;
        plot(mData(:,1),mData(:,2),'k');  %足底压力x
        hold on; plot(mData(:,1),mData(:,3),'r');
        hold on; plot(mData(:,1),mData(:,4),'g');
        hold on; plot(mData(:,1),mData(:,5),'b');
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,3),'k-.');  %足底压力x
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,4),'r-.');
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,5),'g-.');
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,6),'b-.');
        xlabel('\it t \rm / s');       
        title('脚底压力输出');
        legend('脚跟内侧','脚跟外侧','脚掌内侧','脚掌外侧');
        grid on;        
    case 4
        %UWB输出
        figure;
        plot(mData(:,1),mData(:,2),'k');  %UWB
        hold on; plot(mData_Old(:,1)+mData_Old(:,2)./1000,mData_Old(:,3),'k-.');  %UWB
        xlabel('\it t \rm / s');
        ylabel('\it m');        
        title('UWB测距');
        legend('UWB');
        grid on;
    case 5
        %GPS输出
        %原始数据GPS经纬度是 角度，要转换为弧度
        G_CONST = CONST_Init();
        Rmh = Earth_get_Rmh(G_CONST,mData(1,2),mData(1,4));
        Rnh = Earth_get_Rnh(G_CONST,mData(1,2),mData(1,4));
        figure;  
        set(gcf,'position',[250,250,1200,480]);
        %水平轨迹
        subplot(1,3,1);
        plot(0, 0, 'rp');     %在起始位置画一个 五角星
        hold on;    
        plot((mData(:,3)-mData(1,3))*Rnh,(mData(:,2)-mData(1,2))*Rmh*cos(mData(1,2)));        
        xlabel('\it 东向 \rm / m');
        ylabel('\it 北向 \rm / m');
        title('行驶路线');
        grid on;
        %高程
        subplot(1,3,2);
        plot(mData(:,1),mData(:,4));
        xlabel('\it t \rm / s');
        ylabel('\it m'); 
        title('高程');
        grid on;
        %水平精度
        subplot(1,3,3);
        plot(mData(:,1),mData(:,5));
        xlabel('\it t \rm / s');
        ylabel('\it HDop \rm m'); 
        title('定位精度');
        grid on;   
     case 6   
        %高精度GPS输出
        G_CONST = CONST_Init();
        Rmh = Earth_get_Rmh(G_CONST,mData(1,2),mData(1,4));
        Rnh = Earth_get_Rnh(G_CONST,mData(1,2),mData(1,4));
        figure;  
        set(gcf,'position',[50,50,680,680]);
        %水平轨迹
        subplot(2,2,1);
        plot(0, 0, 'rp');     %在起始位置画一个 五角星
        hold on;    
        plot((mData(:,3)-mData(1,3))*Rnh,(mData(:,2)-mData(1,2))*Rmh*cos(mData(1,2)));        
        xlabel('\it 东向 \rm / m');
        ylabel('\it 北向 \rm / m');
        title('行驶路线');
        grid on;
        %高程
        subplot(2,2,2);
        plot(mData(:,1),mData(:,4));
        xlabel('\it t \rm / s');
        ylabel('\it m'); 
        title('高程');
        grid on;
        %水平精度
        subplot(2,2,3);
        plot(mData(:,1),mData(:,5));
        xlabel('\it t \rm / s');
        ylabel('\it HDop \rm m'); 
        title('定位精度');
        grid on;       
        %定位方式
        subplot(2,2,4);
        plot(mData(:,1),mData(:,6));
        xlabel('\it t \rm / s');
        ylabel('\it 定位方式'); 
        title('定位模式');
        legend('0无效 1单点 4RTK浮点 5RTK固定 6惯导')
        grid on;          
end

function DataPrepare_PlotData_TimeCuted(mData,mChoose)
% 对时间截取后的数据进行绘制，便于查看图形状态
% 输入：mData 数据；mChoose 数据种类(1=IMU,2=Magnetic,3=FootPress,
%   4=UWB,5=GPS,6=HighGPS,)；

switch mChoose
    case 1
        %绘制IMU数据 时间 加计 陀螺 时间状态
        figure;
        plot(mData(:,1),mData(:,2),'k');  %加计x
        hold on; plot(mData(:,1),mData(:,3),'r');
        hold on; plot(mData(:,1),mData(:,4),'g');
        xlabel('\it t \rm / s');
        ylabel('\it m \rm / s2');
        title('加计输出');
        legend('x','y','z');
        grid on;
        
        figure;
        plot(mData(:,1),mData(:,5),'k');  %陀螺x
        hold on; plot(mData(:,1),mData(:,6),'r');
        hold on; plot(mData(:,1),mData(:,7),'g');
        xlabel('\it t \rm / s');
        ylabel('\it 弧度 \rm / s');
        title('陀螺输出');
        legend('x','y','z');
        grid on;     
    case 2
        %磁强计输出
        figure;
        plot(mData(:,1),mData(:,2),'k');  %磁强计x
        hold on; plot(mData(:,1),mData(:,3),'r');
        hold on; plot(mData(:,1),mData(:,4),'g');
        xlabel('\it t \rm / s');
        ylabel('\it uT');
        title('磁强计输出');
        legend('x','y','z');
        grid on;
    case 3
        %压力传感器输出
        figure;
        plot(mData(:,1),mData(:,2),'k');  %足底压力x
        hold on; plot(mData(:,1),mData(:,3),'r');
        hold on; plot(mData(:,1),mData(:,4),'g');
        hold on; plot(mData(:,1),mData(:,5),'b');
        xlabel('\it t \rm / s');       
        title('脚底压力输出');
        legend('脚跟内侧','脚跟外侧','脚掌内侧','脚掌外侧');
        grid on;        
    case 4
        %UWB输出
        figure;
        plot(mData(:,1),mData(:,2),'k');  %UWB
        xlabel('\it t \rm / s');
        ylabel('\it m');        
        title('UWB测距');
        legend('UWB');
        grid on;
    case 5
        %GPS输出
        %原始数据GPS经纬度是 角度，要转换为弧度
        G_CONST = CONST_Init();
        Rmh = Earth_get_Rmh(G_CONST,mData(1,2),mData(1,4));
        Rnh = Earth_get_Rnh(G_CONST,mData(1,2),mData(1,4));
        figure;  
        set(gcf,'position',[250,250,1200,480]);
        %水平轨迹
        subplot(1,3,1);
        plot(0, 0, 'rp');     %在起始位置画一个 五角星
        hold on;    
        plot((mData(:,3)-mData(1,3))*Rnh,(mData(:,2)-mData(1,2))*Rmh*cos(mData(1,2)));        
        xlabel('\it 东向 \rm / m');
        ylabel('\it 北向 \rm / m');
        title('行驶路线');
        grid on;
        %高程
        subplot(1,3,2);
        plot(mData(:,1),mData(:,4));
        xlabel('\it t \rm / s');
        ylabel('\it m'); 
        title('高程');
        grid on;
        %水平精度
        subplot(1,3,3);
        plot(mData(:,1),mData(:,5));
        xlabel('\it t \rm / s');
        ylabel('\it HDop \rm m'); 
        title('定位精度');
        grid on;   
     case 6   
        %高精度GPS输出
        G_CONST = CONST_Init();
        Rmh = Earth_get_Rmh(G_CONST,mData(1,2),mData(1,4));
        Rnh = Earth_get_Rnh(G_CONST,mData(1,2),mData(1,4));
        figure;  
        set(gcf,'position',[50,50,680,680]);
        %水平轨迹
        subplot(2,2,1);
        plot(0, 0, 'rp');     %在起始位置画一个 五角星
        hold on;    
        plot((mData(:,3)-mData(1,3))*Rnh,(mData(:,2)-mData(1,2))*Rmh*cos(mData(1,2)));        
        xlabel('\it 东向 \rm / m');
        ylabel('\it 北向 \rm / m');
        title('行驶路线');
        grid on;
        %高程
        subplot(2,2,2);
        plot(mData(:,1),mData(:,4));
        xlabel('\it t \rm / s');
        ylabel('\it m'); 
        title('高程');
        grid on;
        %水平精度
        subplot(2,2,3);
        plot(mData(:,1),mData(:,5));
        xlabel('\it t \rm / s');
        ylabel('\it HDop \rm m'); 
        title('定位精度');
        grid on;       
        %定位方式
        subplot(2,2,4);
        plot(mData(:,1),mData(:,6));
        xlabel('\it t \rm / s');
        ylabel('\it 定位方式'); 
        title('定位模式');
        legend('0无效 1单点 4RTK浮点 5RTK固定 6惯导')
        grid on;          
end




function   NewData = DataPrepare_IMUData_TimeAlignmentUTC_SecondAlign(mData,Hz)
%将输入的数据按照 第一个点 和最后一个点 的时间，对中间的数据进行对齐
% 输入的第一列为时间 

%1.判断第一个数是否要保存的数据
DeltaT = 1/Hz;
[L,m] = size(mData);

if mod(mData(1,1),DeltaT)==0 
    %输入的第一个点为 时刻点
    Time = mData(1,1);
    StartTime = Time;
else
    Time = (fix(mData(1,1)/DeltaT)+1)*DeltaT;
    StartTime = Time;
end

%2. 计算两个准确时刻之间，能包含多少个 时刻点
N = 0;  
while Time < mData(L,1)
    N = N+1;
    Time = Time+DeltaT;
end

%3. 该时间段内的数据已经补包，将其按照时间段进行平均
AverageTime = (mData(L,1)-mData(1,1))/(L-1);
TempData = mData;
%将TempData中的时间，除了首尾外，其它时间进行平均
for i = 2:L-1
    TempData(i,1) = TempData(i-1,1)+AverageTime;    
end

%4. 利用新的时间序列，进行插值处理，求取每个时刻点的数据
NewData = zeros(N,m);
for i =1:N
    %第i个数的 标准时刻时间
    NewData(i,1) = StartTime+(i-1)*DeltaT;
    %进行插值计算
    for j = 1:L
        if abs(NewData(i,1)-TempData(j,1))<0.00001
            NewData(i,2:m) = TempData(j,2:m);
            break;
        end
        if TempData(j,1) < NewData(i,1)
            First = j;
            continue;
        else
            Second = j;
            InsertData = Data_Insert_From_Time(TempData(First,:),TempData(Second,:),NewData(i,1));
            NewData(i,:) = InsertData;
            break;
        end    
    end    
end




function CutData = DataPrepare_IMUData_TimeAlignmentUTC_Cut(mData,Hz,mStartT,mEndT)
% 0.该函数调用前，确保 输入的起始和结束时间是在有效范围内的
% 1.针对输入的数据按照起点和终点进行截断
% 2.并按照采样频率进行对齐
% 3.并进行插值处理
% 数据的格式，一般是 秒 毫秒 数据.... 时间状态
CutData = [];
%% 0. 首先对输入的 起始时间和结束时间，进行GPS授时有效性的判断
Second_StartSerial = 0; Second_NextStartSerial = 0;
Second_StartTime = 0;   Second_NextStartTime = 0;
% 起点时间的有效性判断
[Second_StartTime,Second_StartSerial] = DataPrepare_IMUData_FindSecondSerial(mData,mStartT);
if Second_StartSerial == 0
    %查找失败
    fprintf('警告:GPS有效范围数据切割，发现无效时间设定！秒 %d!\n',mStartT);
    return;
end 
if Second_StartTime ~= mStartT
    fprintf('警告:GPS有效时间起点更改为 %d!\n',Second_StartTime);
    mStartT = Second_StartTime;
end 
% 终点时间的有效性判断
for s=mEndT:-1:mStartT
    [Second_NextStartTime,Second_NextStartSerial] = DataPrepare_IMUData_FindSecondSerial(mData,s);
    if Second_NextStartSerial ~= 0
        break;
    end
end
if Second_NextStartSerial == 0
    %查找失败
    fprintf('警告:GPS有效范围数据切割，发现无效时间设定！秒 %d!\n',mEndT);
    return;
end     
if Second_NextStartTime ~= mEndT
    fprintf('警告:GPS有效时间起点更改为 %d!\n',Second_NextStartTime);
    mEndT = Second_NextStartTime-1;
end 
% 时间范围的有效性判断
if mEndT <= mStartT
    fprintf('警告:GPS时间切割范围无效！%d %d\n',mStartT,mEndT);
    return;  
end

%% 一、在有效的授时起始和终点范围之间，进行数据处理
[L,m] = size(mData);
DeltaT = fix((1/Hz)*1000);  %ms对应数据第二列
CutData = zeros((mEndT-mStartT+1)*Hz,m-2);
CutData_SavedNum = 0;
% 从修订后的起始时间，开始，搜索每一段有GPS授时的数据
Second_NextStartTime = Second_StartTime; 
Second_NextStartSerial = Second_StartSerial;
Second_StartTime = 0;       Second_StartSerial = 0;
s = mStartT;

while s <= mEndT
    %1.找到授时的起始点
    Second_StartTime = Second_NextStartTime;
    Second_StartSerial = Second_NextStartSerial;
    %2.找到下一个授时的起始点    
    [Second_NextStartTime,Second_NextStartSerial]=DataPrepare_IMUData_FindSecondSerial(mData,Second_StartTime+1);
    s = Second_NextStartTime;
    
    if Second_NextStartSerial == 0
        break;
    end
    
    %3.获取这段前后有授时的时间 >= 1s 
    %   第一个 和 最后一个(授时点) 时间是准确的，中间 是内部时钟顺序累加，没有跳点，有可能有丢数，需要插值
    Temp_Data = zeros(Second_NextStartSerial-Second_StartSerial+1,m-1);   %这里转换时间
    Temp_Data(:,1) = mData(Second_StartSerial:Second_NextStartSerial,1)+mData(Second_StartSerial:Second_NextStartSerial,2)./1000.0;
    Temp_Data(:,2:m-1) = mData(Second_StartSerial:Second_NextStartSerial,3:m);
    Last_Data = Temp_Data(Second_NextStartSerial-Second_StartSerial+1,:);
    %4.针对这段数据，进行丢包检测,并插值补上丢包数据(只有第一个数是授时点，最后一个授时点不要输入)
    Temp_Data = DataPrepare_IMUData_LoseCheck_And_Insert(Temp_Data(1:Second_NextStartSerial-Second_StartSerial,:),Hz);
    %5.补数后，加上当前段的最后一点(有效时间)，进行时间对齐的插值
    %(在两个有效时间之间，进行时间对齐，包含第一个点，但不包含最后一个点，以防重复)
    Temp_Data=[Temp_Data;Last_Data];
    Temp_Data = DataPrepare_IMUData_TimeAlignmentUTC_SecondAlign(Temp_Data,Hz);
    %6.处理后的数据，进行存储
    [L1,m1] = size(Temp_Data);
    CutData(CutData_SavedNum+1:CutData_SavedNum+L1,:) = Temp_Data(:,1:m-2);    
    CutData_SavedNum = CutData_SavedNum+L1;
end    


function DataPrepare_IMUData_TimeAlignmentUTC(mDataPath,HzIMU,HzMag,mTimeStart,mTimeEnd)
% 利用GPS的UTC(天内秒)进行时间对齐，使用以下规则
%1.对设定的起始和结束时间，进行前后1秒的扩展。
%2.若是没有设定起始和结束时间，则默认搜索，以最后一列的时间状态为开始，默认多1S
%3.数据时间对齐后，进行插值处理！
%采样频率

%% 一、 准备工作阶段
% 0.错误排查
if (mTimeStart<0)||(mTimeEnd<0)||((mTimeEnd>0)&&(mTimeStart>=mTimeEnd))
    disp('错误:时间起点和终点设置错误！')
    return;
end

% 1. 读取数据
load(mDataPath);
if ~exist('IMU','var')   %以是否存在IMU判断是否读到数据
    disp('错误:未读取到IMU数据！')
    return;
end
[L,m] = size(IMU);

% 2. 查找数据的有效起始时间和结束时间
% 2.1 搜索有效起始时间
Temp_Start = 0; Temp_End = 0;
TimeState = 0;  Temp_StartIsFind = 0;
for i = 1:L
    %首次GPS时间有效
    if(TimeState == 0)&&(IMU(i,m) == 1 )            
        Temp_Start = IMU(i,1)+2; %开始定位时间会有1s的延迟
        TimeState = 1;
    end
    %判断设定的起始时间是否有效
    if(Temp_Start==IMU(i,1))&&(IMU(i,m) == 1)
        Temp_StartIsFind = 1;
        break;
    end
end
if Temp_StartIsFind == 0
    disp('错误:没有GPS起始时间！')
    return;
end
% 2.2 搜索有效结束时间
for i = L:-1:1
    if IMU(i,m) == 1 
        Temp_End = IMU(i,1);
        break;
    end    
end
if Temp_Start>=Temp_End
    disp('错误:GPS结束时间搜索错误！')
    return;
end

TimeStart = 0; TimeEnd = 0;
% 3. 确定所要截取数据的起始和终点
if (mTimeStart == 0)
    TimeStart = Temp_Start;
else
    if Temp_Start>=mTimeStart
        TimeStart = Temp_Start;
    else
        TimeStart = mTimeStart;
    end
end
%因为最后1s 时间不完整，去掉
if (mTimeEnd == 0)
    TimeEnd = Temp_End-1;
else
    if Temp_End>mTimeEnd
        TimeEnd = mTimeEnd;
    else
        TimeEnd = Temp_End-1;
    end
end

%获取了真实有效的GPS时间，
    fprintf('获取真实有效的GPS截取时间为：%d  %d \n',TimeStart,TimeEnd);

%% 二、 进入数据截取阶段，包含缺数插值
%先全部截取完，然后绘制，并考虑对GPS 和高精度GPS的数据进行截取！
tIndex = strfind(mDataPath,'.');
NewPath = mDataPath(1:tIndex-1);
NewPath = [NewPath,sprintf('_%d_%d',TimeStart,TimeEnd),'.mat'];
%1.先截取IMU 并存储
IMU_Old = IMU;
IMU = DataPrepare_IMUData_TimeAlignmentUTC_Cut(IMU,200,TimeStart,TimeEnd);
if isempty(IMU) == 1
    disp('1.**** IMU数据时间截取失败！****')
else
    disp('1.IMU数据时间截取完成！')
    save(NewPath,'IMU');                        %存储截取后的新数据
%     DataPrepare_PlotData_TimeCuted(IMU,IMU_Old,1);       %绘制
    DataPrepare_PlotData_TimeCuted(IMU,1);       %绘制
end    
%2. 磁强计数据
if exist('Magnetic','var') 
    Magnetic_Old = Magnetic;
    Magnetic = DataPrepare_IMUData_TimeAlignmentUTC_Cut(Magnetic,100,TimeStart,TimeEnd);
    if isempty(Magnetic) == 1
        disp('2.**** Magnetic数据时间截取失败！****')
    else
        disp('2.Magnetic数据时间截取完成！')
        save(NewPath,'Magnetic','-append');                  %存储
        %DataPrepare_PlotData_TimeCuted(Magnetic,Magnetic_Old,2);       %绘制
        DataPrepare_PlotData_TimeCuted(Magnetic,2);       %绘制
    end
end   
%3. 足底压力数据    
if exist('FootPres','var')   
    FootPres_Old = FootPres;
    FootPres = DataPrepare_IMUData_TimeAlignmentUTC_Cut(FootPres,200,TimeStart,TimeEnd);
    if isempty(FootPres) == 1
        disp('3.**** FootPres数据时间截取失败！****')
    else
        disp('3.FootPres数据时间截取完成！')
        save(NewPath,'FootPres','-append');                  %存储
        %DataPrepare_PlotData_TimeCuted(FootPres,FootPres_Old,3);          %绘制
        DataPrepare_PlotData_TimeCuted(FootPres,3);          %绘制
    end
end    
%4. UWB数据
 if exist('UWB','var')   
    UWB_Old = UWB;
    UWB = DataPrepare_IMUData_TimeAlignmentUTC_Cut(UWB,200,TimeStart,TimeEnd);
    if isempty(UWB) == 1
        disp('4.**** UWB数据时间截取失败！****')
    else
        disp('4.UWB数据时间截取完成！')
        save(NewPath,'UWB','-append');                  %存储
        %DataPrepare_PlotData_TimeCuted(UWB,UWB_Old,4);          %绘制
        DataPrepare_PlotData_TimeCuted(UWB,4);          %绘制
    end
end 
%5. 模块内GPS数据
if exist('GPS','var')       
    [L,m] = size(GPS);
    First = 0; Second = L;
    for i=1:L
       if TimeStart <= GPS(i,1)
           First = i;
           break;
       end
    end
    for i=1:L
       if TimeEnd <= GPS(i,1)
           Second = i;
           break;
       end
    end       
    GPS = GPS(First:Second,:);
    disp('5.GPS数据时间截取完成！')
    save(NewPath,'GPS','-append');                  %存储
    DataPrepare_PlotData_TimeCuted(GPS,5);          %绘制
end
%6. 外部高精度GPS数据
if exist('HighGPS','var')       
    [L,m] = size(HighGPS);
    First = 0; Second = L;
    for i=1:L
       if TimeStart <= HighGPS(i,1)
           First = i;
           break;
       end
    end
    for i=1:L
       if TimeEnd <= HighGPS(i,1)
           Second = i;
           break;
       end
    end       
    HighGPS = HighGPS(First:Second,:);
    disp('6.HighGPS数据时间截取完成！')
    save(NewPath,'HighGPS','-append');                  %存储
    DataPrepare_PlotData_TimeCuted(HighGPS,6);          %绘制
end    
    
    
  function DataPrepare_IMUData_TimeAlignmentSelf(mDataPath,HzIMU,HzMag,mTimeStart,mTimeEnd)
% 数据时间的自对整包括以下内容
%1.将输入的数据，先按照内部时钟(从0开始)，进行采样间隔对整，IMU和Mag的采样间隔不一样
%2.将UWB的数据进行插值对齐
%3.然后再按照设定的时间段，进行数据截取 

HzIMU = 200;
HzMag = 100;
%% 1.时间对整处理
%采样间隔
DeltaT_IMU = 1/HzIMU;
DeltaT_Mag = 1/HzMag;

%读取数据
load(mDataPath);
% 1.1 处理IMU数据
if exist('IMU','var')
    [L,n] = size(IMU);
    %先判断IMU是否丢数
    j = 1;    
    mLoseRecord=[0,0];
    mLoseTime = 0;
    for i=1:L-1
        tNumber = round((IMU(i+1,1)-IMU(i,1))/DeltaT_IMU)-1;
        if tNumber > 0            
            mLoseRecord(j,1) = i+1;
            mLoseRecord(j,2) = tNumber;
            j = j+1;
            mLoseTime = mLoseTime+1;
        end
    end    
    
    %丢数，进行插值
    mStartTime = round(IMU(1,1)/DeltaT_IMU)*DeltaT_IMU;
    if mLoseTime > 0
        IMUNew = zeros(L+sum(mLoseRecord(:,2)),n);
        if exist('FootPres','var')
            [k,m] = size(FootPres);
            FootPresNew = zeros(L+sum(mLoseRecord(:,2)),m);
        end
        j=1;
        mAddNumber = 0;
        for i=1:L
            if i == mLoseRecord(j,1)
                % 按照缺的个数插值！
                for k=1:mLoseRecord(j,2)
                   %插值！ 
                   % IMUNew(i+mAddNumber,:) 
                   IMUNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                   if exist('FootPres','var')
                        %插值！ 
                        % FootPresNew(i+mAddNumber,:) 
                        FootPresNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                    end
                   mAddNumber = mAddNumber+1;
                end                
                %插完后，正常赋值                
                IMUNew(i+mAddNumber,:) = IMU(i,:);
                IMUNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                if exist('FootPres','var')
                    FootPresNew(i+mAddNumber,:) = FootPres(i,:);
                    FootPresNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                end                
                if j < mLoseTime
                    j=j+1;
                end
            else
               % 正常赋值               
               IMUNew(i+mAddNumber,:) = IMU(i,:);
               IMUNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
               if exist('FootPres','var')
                    FootPresNew(i+mAddNumber,:) = FootPres(i,:);
                    FootPresNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
               end 
            end        
        end
    else
    %否则，从开始时间按照等间隔进行时间对齐
        IMUNew = zeros(L,n);
        for i = 1:L
            IMUNew(i,:) = IMU(i,:);
            IMUNew(i,1) = mStartTime + (i-1)*DeltaT_IMU;            
        end  
        if exist('FootPres','var') 
            [k,m] = size(FootPres);
            FootPresNew = zeros(k,m);
            for i = 1:k
                FootPresNew(i,:) = FootPres(i,:);
                FootPresNew(i,1) = mStartTime + (i-1)*DeltaT_IMU;            
            end             
        end
    end
    IMU = IMUNew; 
    save(mDataPath,'IMU','-append');
    if exist('FootPres','var')     
        FootPres = FootPresNew;
        save(mDataPath,'FootPres','-append');
    end
end

% 1.2 处理UWB数据  按照IMU的采样频率对整   
if exist('UWB','var')
    [L,n] = size(UWB);
    %先判断IMU是否丢数
    j = 1;    
    mLoseRecord=[0,0];
    mLoseTime = 0;
    for i=1:L-1
        tNumber = round((UWB(i+1,1)-UWB(i,1))/DeltaT_IMU)-1;
        if tNumber > 0            
            mLoseRecord(j,1) = i+1;
            mLoseRecord(j,2) = tNumber;
            j = j+1;
            mLoseTime = mLoseTime+1;
        end
    end    
    
    %丢数，进行插值
    mStartTime = round(UWB(1,1)/DeltaT_IMU)*DeltaT_IMU;
    if mLoseTime > 0
        UWBNew = zeros(L+sum(mLoseRecord(:,2)),n);
        j=1;
        mAddNumber = 0;
        for i=1:L
            if i == mLoseRecord(j,1)
                % 按照缺的个数插值！
                for k=1:mLoseRecord(j,2)
                   %插值！ 
                   % UWBNew(i+mAddNumber,:) 
                   UWBNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
                   mAddNumber = mAddNumber+1;
                end                
                %插完后，正常赋值                
                UWBNew(i+mAddNumber,:) = UWB(i,:);
                UWBNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;             
                if j < mLoseTime
                    j=j+1;
                end
            else
               % 正常赋值               
               UWBNew(i+mAddNumber,:) = UWB(i,:);
               UWBNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_IMU;
            end        
        end
    else
    %否则，从开始时间按照等间隔进行时间对齐
        UWBNew = zeros(L,n);
        for i = 1:L
            UWBNew(i,:) = UWB(i,:);
            UWBNew(i,1) = mStartTime + (i-1)*DeltaT_IMU;            
        end  
    end
    UWB = UWBNew; 
    save(mDataPath,'UWB','-append');
end

% 1.3 处理Magnetic数据   
if exist('Magnetic','var')
    [L,n] = size(Magnetic);
    %先判断IMU是否丢数
    j = 1;    
    mLoseRecord=[0,0];
    mLoseTime = 0;
    for i=1:L-1
        tNumber = round((Magnetic(i+1,1)-Magnetic(i,1))/DeltaT_Mag)-1;
        if tNumber > 0            
            mLoseRecord(j,1) = i+1;
            mLoseRecord(j,2) = tNumber;
            j = j+1;
            mLoseTime = mLoseTime+1;
        end
    end    
    
    %丢数，进行插值
    mStartTime = round(Magnetic(1,1)/DeltaT_Mag)*DeltaT_Mag;
    if mLoseTime > 0
        MagneticNew = zeros(L+sum(mLoseRecord(:,2)),n);
        j=1;
        mAddNumber = 0;
        for i=1:L
            if i == mLoseRecord(j,1)
                % 按照缺的个数插值！
                for k=1:mLoseRecord(j,2)
                   %插值！ 
                   % MagneticNew(i+mAddNumber,:) 
                   MagneticNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_Mag;
                   mAddNumber = mAddNumber+1;
                end                
                %插完后，正常赋值                
                MagneticNew(i+mAddNumber,:) = Magnetic(i,:);
                MagneticNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_Mag;             
                if j < mLoseTime
                    j=j+1;
                end
            else
               % 正常赋值               
               MagneticNew(i+mAddNumber,:) = Magnetic(i,:);
               MagneticNew(i+mAddNumber,1) = mStartTime + (i+mAddNumber-1)*DeltaT_Mag;
            end        
        end
    else
    %否则，从开始时间按照等间隔进行时间对齐
        MagneticNew = zeros(L,n);
        for i = 1:L
            MagneticNew(i,:) = Magnetic(i,:);
            MagneticNew(i,1) = mStartTime + (i-1)*DeltaT_Mag;            
        end  
    end
    Magnetic = MagneticNew; 
    save(mDataPath,'Magnetic','-append');
end




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('----------------------------------------------------');
disp('*------------------步态识别开始处理-----------------*');
[FootFileName,FootFilePath] = uigetfile('*.mat');
if isequal(FootFileName,0)
    disp('*-----------数据路径为空，无法读取数据！------------*');    
    disp('----------------------------------------------------');
    return;
else  
    load([FootFilePath,FootFileName]);    
end
    
%% 一、对压力原始数据进行处理 
%   脚静止，有压力，电阻小，电压小
%   脚运动，无压力，电阻大，电压大
% 1. FootPres_Limit 先去掉毛刺   880 对应3.0938V 对应61K欧 对应 24g  去掉原始数据最上面的毛刺和数据回跳
[n,m] = size(FootPres);
FootPres_Limit = FootPres;
for j = 2:5
    for i = 1:n
        if FootPres_Limit(i,j) > 900
            FootPres_Limit(i,j) = 900;
        end   
    end
end
% 翻转  波动代表压力
for j = 2:5
    for i = 1:n
        FootPres_Limit(i,j) = (-1)*FootPres_Limit(i,j)+900;   
    end
end
figure;
plot(FootPres_Limit(:,1),FootPres_Limit(:,2)+FootPres_Limit(:,3),'k');  %足底压力x
hold on; plot(FootPres_Limit(:,1),FootPres_Limit(:,4)+FootPres_Limit(:,5),'g');
hold on;plot(IMU(:,1),IMU(:,4)*10,'-.');  %加计
hold on;plot(IMU(:,1),IMU(:,5)*50,'r-.');  %陀螺
grid on;
legend('脚跟压力','脚掌压力','加计Z*10','陀螺X*50');
xlabel('\it t \rm / s');       
title('压力传感器原始数据');


%% 二、对转化后的压力 FootPres_Pa 进行步态判断 
% 1. 先获取前脚掌和后脚跟的压力数据 分别将前 后 的两个点数据求和
% 这里设定 步态分析的起始时间和结束时间  也就是IMU惯导解算的起始时间和结束时间
% 这里可以设计成三个参数，一个是启动时间，一个是静止结束时间，一个是导航结束时间
FootPres_Pa = FootPres_Limit;
[n,m] = size(FootPres_Pa);
FootPres_Pa_front = zeros(n,2);  
FootPres_Pa_back = zeros(n,2);  
FootPres_Pa_back(:,1) = FootPres_Pa(:,1);
FootPres_Pa_front(:,1) = FootPres_Pa(:,1);
FootPres_Pa_back(:,2) = FootPres_Pa(:,2)+FootPres_Pa(:,3);
FootPres_Pa_front(:,2) = FootPres_Pa(:,4)+FootPres_Pa(:,5);

PresLimit = 200;   %压力阈值
StateCorrect = 30;
% 2. 先处理后脚跟的数据，因为后脚跟行走时先落地，并且冲击最大
%   一般开机，人都是在静止状态的，所以可以依据初始的第一个压力值判断是否在静止状态
[n,m] = size(FootPres_Pa_back);
% 处理后脚跟的状态
FootPreState_back = zeros(n,2);
FootPreState_back(:,1) = FootPres_Pa_back(:,1);
i = 0;
while i < n
    i = i+1;
    if i == 1
        %起始阶段 的判断
        if FootPres_Pa_back(1,2) >= PresLimit
            %起始静止状态
            FootPreState_back(1,2) = 1;
            i = i+1;
            while FootPres_Pa_back(i,2) >= PresLimit
                FootPreState_back(i,2) = 1;
                i = i+1;
            end
                FootPreState_back(i,2) = 0;
        else
            %起始运动状态
            FootPreState_back(1,2) = 0;
             i = i+1;
            while FootPres_Pa_back(i,2) < PresLimit
                FootPreState_back(i,2) = 0;
                i = i+1;
            end
                FootPreState_back(i,2) = 1;         
        end
    end
    if (FootPreState_back(i-1,2) == 0) && (FootPres_Pa_back(i,2) > PresLimit)
        %从运动 进入 静止
        FootPreState_back(i,2) = 1;
        continue;
    end        
    if (FootPreState_back(i-1,2) == 1) && (FootPres_Pa_back(i,2) < PresLimit)
        %从静止 进入 运动
        FootPreState_back(i,2) = 0;  
        continue;
    end    
    FootPreState_back(i,2) = FootPreState_back(i-1,2);
end

% 对处理结果进行纠偏 纠正跳点
TStartSerial = 1;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if FootPreState_back(i,2) ~= FootPreState_back(i-1,2)
        if StateNum >= StateCorrect
            %正常变换
            TStartSerial = i;
            StateNum = 1;
        else
            %有跳点
            FootPreState_back(TStartSerial:i-1,2) = FootPreState_back(TStartSerial-1,2);
            StateNum = StateNum+StateCorrect;
        end
    else
        StateNum = StateNum + 1;
    end
end

% 3. 同上处理前脚掌数据
[n,m] = size(FootPres_Pa_front);
% 处理前脚掌的状态
FootPreState_front = zeros(n,2);
FootPreState_front(:,1) = FootPres_Pa_front(:,1);
i = 0;
while i < n
    i = i+1;
    if i == 1
        %起始阶段 的判断
        if FootPres_Pa_front(1,2) >= PresLimit
            %起始静止状态
            FootPreState_front(1,2) = 1;
            i = i+1;
            while FootPres_Pa_front(i,2) >= PresLimit
                FootPreState_front(i,2) = 1;
                i = i+1;
            end
                FootPreState_front(i,2) = 0;
        else
            %起始运动状态
            FootPreState_front(1,2) = 0;
             i = i+1;
            while FootPres_Pa_front(i,2) < PresLimit
                FootPreState_front(i,2) = 0;
                i = i+1;
            end
                FootPreState_front(i,2) = 1;          
        end
    end
    if (FootPreState_front(i-1,2) == 0) && (FootPres_Pa_front(i,2) > PresLimit)
        %从运动 进入 静止
        FootPreState_front(i,2) = 1;
        continue;
    end        
    if (FootPreState_front(i-1,2) == 1) && (FootPres_Pa_front(i,2) < PresLimit)
        %从静止 进入 运动
        FootPreState_front(i,2) = 0;  
        continue;
    end    
    FootPreState_front(i,2) = FootPreState_front(i-1,2);
end

% 对处理结果进行纠偏 纠正跳点
TStartSerial = 1;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if FootPreState_front(i,2) ~= FootPreState_front(i-1,2)
        if StateNum >= StateCorrect
            %正常变换
            TStartSerial = i;
            StateNum = 1;
        else
            %有跳点
            FootPreState_front(TStartSerial:i-1,2) = FootPreState_front(TStartSerial-1,2);
            StateNum = StateNum+StateCorrect;
        end
    else
        StateNum = StateNum + 1;
    end
end

figure;
plot(FootPres_Pa_back(:,1),FootPres_Pa_back(:,2),'k');            %足底压力x
hold on; plot(FootPres_Pa_front(:,1),FootPres_Pa_front(:,2),'g');
hold on;plot(FootPreState_front(:,1),FootPreState_front(:,2).*100,'b*');
hold on;plot(FootPreState_back(:,1),FootPreState_back(:,2).*150,'b*-');
title('脚跟 脚掌 步态判断State');
grid on;
legend('后脚跟状态','前脚掌状态','前脚掌判断','后脚跟判断');
clear i m n StateNum TStartSerial;

%% 三、 利用前后压力判断状态 进行 脚的步态判断
% 1.利用 后脚跟的状态 FootPreState_back 寻找 每个接地过程中的压力极值 FootPres_Pa_back
[n,m] = size(FootPreState_back);
mBegin = 0; mBegin_Serial = 0; 
mEnd = 0;   mEnd_Serial = 0; 
for i = 2:n
    if (FootPreState_back(i-1,2) == 0)&&(FootPreState_back(i,2) == 1)
        mBegin = 1;
        mBegin_Serial = i;
    end
    if (mBegin == 1)&&(FootPreState_back(i-1,2) == 1)&&(FootPreState_back(i,2) == 0)
        mEnd = 1;
        mEnd_Serial = i;
    end    
    if (mBegin == 1)&&(mEnd == 1)   
        if mEnd_Serial > mBegin_Serial
            [mMax,mIndex] = max(FootPres_Pa_back(mBegin_Serial:mEnd_Serial,2));
            FootPreState_back(mIndex+mBegin_Serial-1,2) = 2;
        end
        mBegin = 0;
        mEnd = 0;        
    end    
end

% 2.利用 前脚掌的状态 FootPreState_front 寻找 每个接地过程中的压力极值 FootPres_Pa_front
[n,m] = size(FootPreState_front);
mBegin = 0; mBegin_Serial = 0; 
mEnd = 0;   mEnd_Serial = 0; 
for i = 2:n
    if (FootPreState_front(i-1,2) == 0)&&(FootPreState_front(i,2) == 1)
        mBegin = 1;
        mBegin_Serial = i;
    end
    if (mBegin == 1)&&(FootPreState_front(i-1,2) == 1)&&(FootPreState_front(i,2) == 0)
        mEnd = 1;
        mEnd_Serial = i;
    end    
    if (mBegin == 1)&&(mEnd == 1)   
        if mEnd_Serial > mBegin_Serial
            [mMax,mIndex] = max(FootPres_Pa_front(mBegin_Serial:mEnd_Serial,2));
            FootPreState_front(mIndex+mBegin_Serial-1,2) = 2;
        end
        mBegin = 0;
        mEnd = 0;        
    end    
end

% figure;
% plot(FootPres_Pa_back(:,1),FootPres_Pa_back(:,2),'k');            %足底压力x
% hold on; plot(FootPres_Pa_front(:,1),FootPres_Pa_front(:,2),'g');
% hold on;plot(FootPreState_back(:,1),FootPreState_back(:,2)*1000,'b.-');
% hold on;plot(FootPreState_front(:,1),FootPreState_front(:,2)*1500,'b.-');
% title('脚底压力状态 State');
% grid on;
% hold on;plot(IMU(:,1),IMU(:,4)*100,'-.');  %加计
% hold on;plot(IMU(:,1),IMU(:,5)*500,'r-.');  %陀螺
% legend('后脚跟','前脚掌','前脚掌判断','后脚跟判断');

% 3.步态综合判断
[n,m] = size(FootPreState_back);
FootPres_State = zeros(n,2);
FootPres_State(:,1) = FootPres(:,1);
mBegin = 0; mBegin_Serial = 0; 
mEnd = 0;   mEnd_Serial = 0; 
i = 0;
while i<n
    i = i+1;
    %开头
    if i == 1
        while (FootPreState_back(i,2)+FootPreState_front(i,2))>0
            FootPres_State(i,2) = 1;
            i = i+1;
        end
    end
    if FootPreState_back(i,2) == 2
        mBegin = 1;
        mBegin_Serial = i;
    end
    
    if (FootPreState_front(i,2) == 2)&&(mBegin == 1)
        FootPres_State(mBegin_Serial:i,2) = 1;
        mBegin = 0;
        mBegin_Serial = 0;
    end       
    % 收尾工作
    if (i == n)&&(FootPres_State(i,2) == 0)
        j = n;
        while ((FootPreState_back(j,2)+FootPreState_front(j,2))>0) && (FootPres_State(j,2) == 0)            
            j = j -1;
        end
        if (n-j>100)
            FootPres_State(j+100:n,2) = 1;
        end
    end    
end

figure;
plot(FootPres_State(:,1),FootPres_State(:,2).*20,'r');        
hold on;plot(IMU(:,1),IMU(:,4),'-.');  %加计
%hold on;plot(IMU(:,1),IMU(:,5),'r-.');  %陀螺
% legend('步态*20','加计Z','陀螺X');
legend('步态*20','加计Z');
xlabel('\it t \rm / s');       
title('行走步态判断(1静止，0运动)');
grid on;

save([FootFilePath,FootFileName],'FootPres_State','-append');

disp('*----------------步态识别处理完成！-----------------*');
disp('----------------------------------------------------');

% --- Executes just before IndividualNavigation_DataPrepare is made visible.
function figure1_CreateFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IndividualNavigation_DataPrepare (see VARARGIN)
