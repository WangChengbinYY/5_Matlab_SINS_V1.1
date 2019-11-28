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

% Last Modified by GUIDE v2.5 28-Nov-2019 22:59:01

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
%选择时间同步输入 1:内部时钟(默认)(从0秒开始计时) 2:内部GPS时间(从有效定位UTC时间天内秒开始)
global Choose_Time
Choose_Time = 1;
%外部高精度定位数据(北斗伴侣) 0:无 1:有  
%   txt数据格式为 hhmmss.sss ddmm.mmmmmmm dddmm.mmmmmmm 水平精度(米) 高程(米)
%   整理输出为: 天内秒 纬度 经度 高程 水平精度
global Choose_HighGPSData
Choose_HighGPSData = 0;
%外部高精度定位数据(北斗伴侣) 待处理数据文件名 文件路径 
global GPS_FilePath GPS_FileName 



% UIWAIT makes IndividualNavigation_DataPrepare wait for user response (see UIRESUME)
% uiwait(handles.figure1);


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

global IMU_FileName IMU_FilePath 
[IMU_FileName,IMU_FilePath] = uigetfile('*.dat');
if isequal(IMU_FileName,0)
   disp('选择文件取消!');
else
   disp(['选取文件:', fullfile(IMU_FilePath,IMU_FileName)]);
   set(handles.edit1,'string',strcat(IMU_FilePath,IMU_FileName));
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


%------------------------ 读取IMU相关的所有数据-----------------------------
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







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
        disp('设备类型选择：First(MPU)');
    case 'radiobutton2'
        Choose_Device = 2;
        disp('设备类型选择：Second(MTi)');       
    case 'radiobutton3'
        Choose_Device = 3;
        disp('设备类型选择：Third(ADIS)');
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
        disp('选择数据类型：IMUA(MPU_Only)');
    case 'radiobutton5'
        Choose_DataKinde = 2;
        disp('选择数据类型：IMUB(MPU_Only)');       
    case 'radiobutton6'
        Choose_DataKinde = 3;
        disp('选择数据类型：IMUB(MTi_Only)');
    case 'radiobutton7'
        Choose_DataKinde = 4;
        disp('选择数据类型：IMUB(ADIS_Only)');     
    case 'radiobutton8'
        Choose_DataKinde = 5;
        disp('选择数据类型：IMUB(ADIS)+IMUA(MPU_Magnetic)'); 
    case 'radiobutton9'
        Choose_DataKinde = 6;
        disp('选择数据类型：IMUB(MPU)+IMUA(MPU)');         
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
        disp('设备绑定模式：左脚(含UWB)');
    case 'radiobutton11'
        Choose_Foot_LeftorRight = 2;
        disp('设备绑定模式：左脚(不含UWB)');       
    case 'radiobutton12'
        Choose_Foot_LeftorRight = 3;
        disp('设备绑定模式：右脚(不含UWB)');    
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
        disp('时钟选择：内部时钟');
    case 'radiobutton14'
        Choose_Time = 2;
        disp('时钟选择：内部GPS天内秒');     
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
       disp('选择文件取消!');
    else
       Choose_HighGPSData = 1;
       set(hObject,'Value',1);
       disp(['选取文件:', fullfile(GPS_FilePath,GPS_FileName)]);
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
disp('*--------程序退出！-------*');