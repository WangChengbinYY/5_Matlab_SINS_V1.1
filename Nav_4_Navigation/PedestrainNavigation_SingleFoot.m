function varargout = PedestrainNavigation_SingleFoot(varargin)
% PEDESTRAINNAVIGATION_SINGLEFOOT MATLAB code for PedestrainNavigation_SingleFoot.fig
%      PEDESTRAINNAVIGATION_SINGLEFOOT, by itself, creates a new PEDESTRAINNAVIGATION_SINGLEFOOT or raises the existing
%      singleton*.
%
%      H = PEDESTRAINNAVIGATION_SINGLEFOOT returns the handle to a new PEDESTRAINNAVIGATION_SINGLEFOOT or the handle to
%      the existing singleton*.
%
%      PEDESTRAINNAVIGATION_SINGLEFOOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PEDESTRAINNAVIGATION_SINGLEFOOT.M with the given input arguments.
%
%      PEDESTRAINNAVIGATION_SINGLEFOOT('Property','Value',...) creates a new PEDESTRAINNAVIGATION_SINGLEFOOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PedestrainNavigation_SingleFoot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PedestrainNavigation_SingleFoot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PedestrainNavigation_SingleFoot

% Last Modified by GUIDE v2.5 02-Apr-2020 20:04:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PedestrainNavigation_SingleFoot_OpeningFcn, ...
                   'gui_OutputFcn',  @PedestrainNavigation_SingleFoot_OutputFcn, ...
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


% --- Executes just before PedestrainNavigation_SingleFoot is made visible.
function PedestrainNavigation_SingleFoot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PedestrainNavigation_SingleFoot (see VARARGIN)

% Choose default command line output for PedestrainNavigation_SingleFoot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%===========================全局变量设定=====================================
%================数据存放路径 
global DataPath 
DataPath = []; 

%================设备选择 
global SensorChoose_IMU SensorChoose_GPS SensorChoose_Magnetic SensorChoose_RTK
SensorChoose_IMU = 1;   % 1-MPU_L,2-MPU_R,3-ADIS_L,4-ADIS_R,5-MTi_L,6-MTi-R,7-其它
SensorChoose_GPS = 0;   % 0-无，1-有
SensorChoose_Magnetic = 0;   % 0-无，1-有
SensorChoose_RTK = 0;   % 0-无，1-有

%================器件参数设定 默认为 MPU IMU_A
%陀螺 常值零偏 度/h
global Para_Gyro_BiasConst_X Para_Gyro_BiasConst_Y Para_Gyro_BiasConst_Z
Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
%陀螺 零偏稳定性 度/h
global Para_Gyro_BiasStab_X Para_Gyro_BiasStab_Y Para_Gyro_BiasStab_Z
Para_Gyro_BiasStab_X = 50; Para_Gyro_BiasStab_Y = 80; Para_Gyro_BiasStab_Z = 50; 
%陀螺 角度随机游走 度/h-1/2
global Para_Gyro_ARW_X Para_Gyro_ARW_Y Para_Gyro_ARW_Z
Para_Gyro_ARW_X = 10; Para_Gyro_ARW_Y = 10; Para_Gyro_ARW_Z = 10;

%加计 常值零偏 mg
global Para_Acc_BiasConst_X Para_Acc_BiasConst_Y Para_Acc_BiasConst_Z
% MEMS器件零偏波动太大，后面实时估计吧
%Para_Acc_BiasConst_X = -10; Para_Acc_BiasConst_Y = 31; Para_Acc_BiasConst_Z = -33;
Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0; 
%加计 零偏稳定性 mg
global Para_Acc_BiasStab_X Para_Acc_BiasStab_Y Para_Acc_BiasStab_Z
Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
%加计 速度随机游走 
global Para_Acc_VRW_X Para_Acc_VRW_Y Para_Acc_VRW_Z
Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;

%器件参数显示更新
set(handles.edit_Parameter_Gyro_BiasConst_X,'string',num2str(Para_Gyro_BiasConst_X));
set(handles.edit_Parameter_Gyro_BiasConst_Y,'string',num2str(Para_Gyro_BiasConst_Y));
set(handles.edit_Parameter_Gyro_BiasConst_Z,'string',num2str(Para_Gyro_BiasConst_Z));
set(handles.edit_Parameter_Gyro_BiasStab_X,'string',num2str(Para_Gyro_BiasStab_X));
set(handles.edit_Parameter_Gyro_BiasStab_Y,'string',num2str(Para_Gyro_BiasStab_Y));
set(handles.edit_Parameter_Gyro_BiasStab_Z,'string',num2str(Para_Gyro_BiasStab_Z));
set(handles.edit_Parameter_Gyro_ARW_X,'string',num2str(Para_Gyro_ARW_X));
set(handles.edit_Parameter_Gyro_ARW_Y,'string',num2str(Para_Gyro_ARW_Y));
set(handles.edit_Parameter_Gyro_ARW_Z,'string',num2str(Para_Gyro_ARW_Z));
set(handles.edit_Parameter_Acc_BiasConst_X,'string',num2str(Para_Acc_BiasConst_X));
set(handles.edit_Parameter_Acc_BiasConst_Y,'string',num2str(Para_Acc_BiasConst_Y));
set(handles.edit_Parameter_Acc_BiasConst_Z,'string',num2str(Para_Acc_BiasConst_Z));
set(handles.edit_Parameter_Acc_BiasStab_X,'string',num2str(Para_Acc_BiasStab_X));
set(handles.edit_Parameter_Acc_BiasStab_Y,'string',num2str(Para_Acc_BiasStab_Y));
set(handles.edit_Parameter_Acc_BiasStab_Z,'string',num2str(Para_Acc_BiasStab_Z));
set(handles.edit_Parameter_Acc_VRW_X,'string',num2str(Para_Acc_VRW_X));
set(handles.edit_Parameter_Acc_VRW_Y,'string',num2str(Para_Acc_VRW_Y));
set(handles.edit_Parameter_Acc_VRW_Z,'string',num2str(Para_Acc_VRW_Z));

%安装参数 变换矩阵  MPU_L 的6位置校准参数(非正交、比例因子、零偏)
global Para_Acc_Calibration_6Local
% Para_Acc_Calibration_6Local = [1.000264037	-0.00004585	-0.006794537 -0.010055843;
%                                 -0.0051893  0.99927623	0.01848056  0.03118094;
%                                 0.024396733	-0.00342088	0.998533567	-0.033433563];
Para_Acc_Calibration_6Local = [1.000264037	-0.00004585	-0.006794537 0;
                                -0.0051893  0.99927623	0.01848056  0;
                                0.024396733	-0.00342088	0.998533567	0];                            
set(handles.edit_Calibration_c11,'string',num2str(Para_Acc_Calibration_6Local(1,1)));
set(handles.edit_Calibration_c12,'string',num2str(Para_Acc_Calibration_6Local(1,2)));
set(handles.edit_Calibration_c13,'string',num2str(Para_Acc_Calibration_6Local(1,3)));
set(handles.edit_Calibration_c21,'string',num2str(Para_Acc_Calibration_6Local(2,1)));
set(handles.edit_Calibration_c22,'string',num2str(Para_Acc_Calibration_6Local(2,2)));
set(handles.edit_Calibration_c23,'string',num2str(Para_Acc_Calibration_6Local(2,3)));
set(handles.edit_Calibration_c31,'string',num2str(Para_Acc_Calibration_6Local(3,1)));
set(handles.edit_Calibration_c32,'string',num2str(Para_Acc_Calibration_6Local(3,2)));
set(handles.edit_Calibration_c33,'string',num2str(Para_Acc_Calibration_6Local(3,3)));
        
%磁强计校准误差参数
global Para_Calebrat_Mag_2D_A22 Para_Calebrat_Mag_2D_B21
Para_Calebrat_Mag_2D_A22 = eye(2);
Para_Calebrat_Mag_2D_B21 = zeros(2,1);
%================系统设定
%初始位置 单位 度 米 
global Start_Lat Start_Lon Start_High
Start_Lat = 34.232698588*pi/180; Start_Lon = 108.959890932*pi/180; Start_High = 400;
%初始姿态 单位度
global Start_Pitch Start_Roll Start_Yaw
Start_Pitch = 0*pi/180; Start_Roll = 0*pi/180; Start_Yaw = 0*pi/180;
%采样频率
global Hz
Hz = 200;
%器件参数显示更新
set(handles.edit_Start_Lat,'string',num2str(Start_Lat*180/pi,15));
set(handles.edit_Start_Lon,'string',num2str(Start_Lon*180/pi,15));
set(handles.edit_Start_High,'string',num2str(Start_High));
set(handles.edit_Start_Pitch,'string',num2str(Start_Pitch*180/pi));
set(handles.edit_Start_Roll,'string',num2str(Start_Roll*180/pi));
set(handles.edit_Start_Yaw,'string',num2str(Start_Yaw*180/pi));
set(handles.edit_Hz,'string',num2str(Hz));

%================导航解算
global NavMethod_Choose
NavMethod_Choose = 1;

% UIWAIT makes PedestrainNavigation_SingleFoot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PedestrainNavigation_SingleFoot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox_SensorChoose_IMU.
function checkbox_SensorChoose_IMU_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_SensorChoose_IMU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_SensorChoose_IMU


% --- Executes on button press in checkbox_SensorChoose_Magnetic.
function checkbox_SensorChoose_Magnetic_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_SensorChoose_Magnetic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_SensorChoose_Magnetic


% --- Executes on button press in checkbox_SensorChoose_GPS.
function checkbox_SensorChoose_GPS_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_SensorChoose_GPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_SensorChoose_GPS
global SensorChoose_GPS
SensorChoose_GPS = get(hObject,'Value');
if SensorChoose_GPS
    %有GPS 初始位置按钮使能
    set(handles.pushbutton_GetInitPos,'Enable','on');
else
    set(handles.pushbutton_GetInitPos,'Enable','off');
end
% --- Executes on button press in checkbox_SensorChoose_RTK.
function checkbox_SensorChoose_RTK_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_SensorChoose_RTK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_SensorChoose_RTK


% --- Executes on button press in pushbutton_OpenData.
function pushbutton_OpenData_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OpenData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataPath 
[FileName,FilePath] = uigetfile('*.mat');
if isequal(FileName,0)
   %路径为空
else
    DataPath = strcat(FilePath,FileName);
    set(handles.edit_DataPath,'string',DataPath);
end


function edit_DataPath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DataPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DataPath as text
%        str2double(get(hObject,'String')) returns contents of edit_DataPath as a double


% --- Executes during object creation, after setting all properties.
function edit_DataPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DataPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_Parameter_Acc_BiasStab_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_BiasStab_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Acc_BiasStab_X as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Acc_BiasStab_X as a double
global Para_Acc_BiasStab_X
Para_Acc_BiasStab_X = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Acc_BiasStab_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_BiasStab_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_Parameter_Acc_BiasStab_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_BiasStab_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Acc_BiasStab_Y as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Acc_BiasStab_Y as a double
global Para_Acc_BiasStab_Y
Para_Acc_BiasStab_Y = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Acc_BiasStab_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_BiasStab_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Acc_BiasStab_Z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_BiasStab_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Acc_BiasStab_Z as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Acc_BiasStab_Z as a double
global Para_Acc_BiasStab_Z
Para_Acc_BiasStab_Z = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Acc_BiasStab_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_BiasStab_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Acc_VRW_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_VRW_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Acc_VRW_X as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Acc_VRW_X as a double
global Para_Acc_VRW_X
Para_Acc_VRW_X = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Acc_VRW_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_VRW_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Acc_VRW_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_VRW_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Acc_VRW_Y as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Acc_VRW_Y as a double
global Para_Acc_VRW_Y
Para_Acc_VRW_Y = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Acc_VRW_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_VRW_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Acc_VRW_Z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_VRW_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Acc_VRW_Z as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Acc_VRW_Z as a double
global Para_Acc_VRW_Z
Para_Acc_VRW_Z = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Acc_VRW_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_VRW_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Gyro_BiasStab_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_BiasStab_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Gyro_BiasStab_X as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Gyro_BiasStab_X as a double
global Para_Gyro_BiasStab_X
Para_Gyro_BiasStab_X = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Gyro_BiasStab_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_BiasStab_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Gyro_BiasStab_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_BiasStab_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Gyro_BiasStab_Y as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Gyro_BiasStab_Y as a double
global Para_Gyro_BiasStab_Y
Para_Gyro_BiasStab_Y = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Gyro_BiasStab_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_BiasStab_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Gyro_BiasStab_Z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_BiasStab_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Gyro_BiasStab_Z as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Gyro_BiasStab_Z as a double
global Para_Gyro_BiasStab_Z
Para_Gyro_BiasStab_Z = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Gyro_BiasStab_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_BiasStab_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Gyro_ARW_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_ARW_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Gyro_ARW_X as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Gyro_ARW_X as a double
global Para_Gyro_ARW_X
Para_Gyro_ARW_X = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Gyro_ARW_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_ARW_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Gyro_ARW_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_ARW_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Gyro_ARW_Y as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Gyro_ARW_Y as a double
global Para_Gyro_ARW_Y
Para_Gyro_ARW_Y = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Gyro_ARW_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_ARW_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Gyro_ARW_Z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_ARW_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Gyro_ARW_Z as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Gyro_ARW_Z as a double
global Para_Gyro_ARW_Z
Para_Gyro_ARW_Z = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Gyro_ARW_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_ARW_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Start_Lat_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Start_Lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Start_Lat as text
%        str2double(get(hObject,'String')) returns contents of edit_Start_Lat as a double
global Start_Lat
Start_Lat = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Start_Lat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Start_Lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Start_Lon_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Start_Lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Start_Lon as text
%        str2double(get(hObject,'String')) returns contents of edit_Start_Lon as a double
global Start_Lon
Start_Lon = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Start_Lon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Start_Lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Start_High_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Start_High (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Start_High as text
%        str2double(get(hObject,'String')) returns contents of edit_Start_High as a double
global Start_High
Start_High = str2double(get(hObject,'String'));



% --- Executes during object creation, after setting all properties.
function edit_Start_High_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Start_High (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Start_Pitch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Start_Pitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Start_Pitch as text
%        str2double(get(hObject,'String')) returns contents of edit_Start_Pitch as a double
global Start_Pitch
Start_Pitch = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Start_Pitch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Start_Pitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Start_Roll_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Start_Roll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Start_Roll as text
%        str2double(get(hObject,'String')) returns contents of edit_Start_Roll as a double
global Start_Roll
Start_Roll = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Start_Roll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Start_Roll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Start_Yaw_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Start_Yaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Start_Yaw as text
%        str2double(get(hObject,'String')) returns contents of edit_Start_Yaw as a double
global Start_Yaw
Start_Yaw = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Start_Yaw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Start_Yaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Hz_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Hz as text
%        str2double(get(hObject,'String')) returns contents of edit_Hz as a double
global Hz
Hz = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Hz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_GetInitAtt_1.
function pushbutton_GetInitAtt_1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_GetInitAtt_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Start_Pitch
Start_Pitch = str2double(get(hObject,'String'));
global Start_Roll
Start_Roll = str2double(get(hObject,'String'));
global Start_Yaw
Start_Yaw = str2double(get(hObject,'String'));

% --- Executes on button press in pushbutton_NavRun.
%function pushbutton_NavRun_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_NavRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton2.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in pushbutton_GetInitPos.
function pushbutton_GetInitPos_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_GetInitPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 从GPS数据中获取初始位置信息
%   方法：如果已有步态信息，则依据开始的静止阶段进行 GPS定位平均
%         否则，取前Tn秒的数据，求平均
global DataPath 
if isempty(DataPath)
    msgbox('请输入数据路径！');
    return;
end
%读取数据
load(DataPath);
%判断是否存在步态信息数据
if exist('FootPres_State','var')
    Tn = 1;
    i = 1;
    StartTime = fix(FootPres_State(i,1));
    while FootPres_State(i,2)
        i = i+1;
    end
    EndTime = fix(FootPres_State(i,1));
    Tn = EndTime-StartTime+1;
    msgbox(strcat('取前面几秒位置平均：',num2str(Tn)));
else
    Tn = 5;
end

if exist('GPS','var')
%     msgbox('GPS数据存在！');
else
    msgbox('GPS数据不存在！');
    return;
end
%求取前Tn秒GPS的平均时间
global Start_Lat Start_Lon Start_High
if exist('HighGPS','var')   %有RTK数据，则使用
    Start_Lat = mean(HighGPS(1:Tn,2));
    Start_Lon = mean(HighGPS(1:Tn,3));
    Start_High = mean(HighGPS(1:Tn,4));    
else    
    Start_Lat = mean(GPS(1:Tn,2));
    Start_Lon = mean(GPS(1:Tn,3));
    Start_High = mean(GPS(1:Tn,4));
end
Lat = Start_Lat*180/pi; Lon = Start_Lon*180/pi;
%用于 界面显示
set(handles.edit_Start_Lat,'String',num2str(Lat,15));
set(handles.edit_Start_Lon,'String',num2str(Lon,15));
set(handles.edit_Start_High,'String',num2str(Start_High));


% --- Executes on button press in pushbutton_GetInitAtt_2.
function pushbutton_GetInitAtt_2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_GetInitAtt_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%利用初始静止状态下的加速度 求解 水平姿态角  航向使用直接设定
global Start_Pitch Start_Roll
%判断使用静止状态的时间长度
global DataPath 
global Hz
if isempty(DataPath)
    msgbox('请输入数据路径！');
    return;
end
%读取数据
load(DataPath);
%判断是否存在步态信息数据
if exist('FootPres_State','var')
    Num = 1;
    while FootPres_State(Num,2)
        Num = Num+1;
    end
    Num = Num-1;
    if Num > 0
        msgbox(strcat('取前面几秒位置平均：',num2str(ceil(Num/Hz))));
    else
        msgbox('初始状态为动态，无法水平静对准！');
        return;        
    end
else
    msgbox('缺少步态信息');
    return;
end

%取前静止状态数据进行初始水平姿态的求取
%加计 常值零偏 mg
global Para_Acc_BiasConst_X Para_Acc_BiasConst_Y Para_Acc_BiasConst_Z
global Para_Acc_Calibration_6Local

f = [mean(IMU(1:Num,2))-Para_Acc_BiasConst_X;
    mean(IMU(1:Num,3))-Para_Acc_BiasConst_Y;
    mean(IMU(1:Num,4))-Para_Acc_BiasConst_Z;];   %单位g
f = Para_Acc_Calibration_6Local * [f;1];  %安装误差校正
[Start_Pitch,Start_Roll] = Att_Accel2Att(f(1,1),f(2,1),f(3,1));
Pitch = Start_Pitch*180/pi;
Roll = Start_Roll*180/pi;
%显示设定
set(handles.edit_Start_Pitch,'String',num2str(Pitch,8));
set(handles.edit_Start_Roll,'String',num2str(Roll,8));


% --- Executes on button press in pushbutton_GetInitAtt_3.
function pushbutton_GetInitAtt_3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_GetInitAtt_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%利用初始静止状态下的加速度 和 磁强计求解航向角
global Start_Yaw
%判断使用静止状态的时间长度
global DataPath 
global Hz
if isempty(DataPath)
    msgbox('请输入数据路径！');
    return;
end
%读取数据
load(DataPath);
%判断是否存在步态信息数据
if exist('FootPres_State','var')
    Num = 1;
    while FootPres_State(Num,2)
        Num = Num+1;
    end
    Num = Num-1;
    if Num > 0
        msgbox(strcat('取前面几秒位置平均：',num2str(ceil(Num/Hz))));
    else
        msgbox('初始状态为动态，无法水平静对准！');
        return;        
    end
else
    msgbox('缺少步态信息');
    return;
end

%取前静止状态数据进行初始水平姿态的求取
%加计 常值零偏 mg
global Para_Acc_BiasConst_X Para_Acc_BiasConst_Y Para_Acc_BiasConst_Z
global Para_Acc_Calibration_6Local

f = [mean(IMU(1:Num,2))-Para_Acc_BiasConst_X;
    mean(IMU(1:Num,3))-Para_Acc_BiasConst_Y;
    mean(IMU(1:Num,4))-Para_Acc_BiasConst_Z;];   %单位g
f = Para_Acc_Calibration_6Local * [f;1];  %安装误差校正
[Pitch,Roll] = Att_Accel2Att(f(1,1),f(2,1),f(3,1));

%求取 磁强计的均值，并进行椭圆校准
if (ceil(Num/2)-1) <= 0
    msgbox('缺少静态磁强计数据！');
    return;
end
Mag = [mean(Magnetic(1:ceil(Num/2)-1,2));mean(Magnetic(1:ceil(Num/2)-1,3));mean(Magnetic(1:ceil(Num/2)-1,4))]; 
Att = [Pitch;Roll;0];
C_b_n = Att_Euler2DCM(Att);
Mag = C_b_n*Mag;
global Para_Calebrat_Mag_2D_A22 Para_Calebrat_Mag_2D_B21
if Para_Calebrat_Mag_2D_A22(1,1)==1 && Para_Calebrat_Mag_2D_A22(1,2)==0
    msgbox('磁强计未校准！');
end
Mag_Calibrate = Para_Calebrat_Mag_2D_A22*Mag(1:2,1) + Para_Calebrat_Mag_2D_B21;
Start_Yaw = Att_Mag2Yaw(0,0,Mag_Calibrate(1,1),Mag_Calibrate(2,1),0);

%显示设定
set(handles.edit_Start_Yaw,'String',num2str(-Start_Yaw*180/pi));


% --- Executes on button press in pushbutton_GetInitAtt_4.
%function pushbutton_GetInitAtt_4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_GetInitAtt_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit_Parameter_Acc_BiasConst_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_BiasConst_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Acc_BiasConst_X as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Acc_BiasConst_X as a double
global Para_Acc_BiasConst_X
Para_Acc_BiasConst_X = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Acc_BiasConst_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_BiasConst_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Acc_BiasConst_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_BiasConst_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Acc_BiasConst_Y as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Acc_BiasConst_Y as a double
global Para_Acc_BiasConst_Y
Para_Acc_BiasConst_Y = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Acc_BiasConst_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_BiasConst_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Acc_BiasConst_Z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_BiasConst_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Acc_BiasConst_Z as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Acc_BiasConst_Z as a double
global Para_Acc_BiasConst_Z
Para_Acc_BiasConst_Z = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Acc_BiasConst_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Acc_BiasConst_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Gyro_BiasConst_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_BiasConst_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Gyro_BiasConst_X as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Gyro_BiasConst_X as a double
global Para_Gyro_BiasConst_X
Para_Gyro_BiasConst_X = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Gyro_BiasConst_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_BiasConst_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Gyro_BiasConst_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_BiasConst_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Gyro_BiasConst_Y as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Gyro_BiasConst_Y as a double
global Para_Gyro_BiasConst_Y
Para_Gyro_BiasConst_Y = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Gyro_BiasConst_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_BiasConst_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Parameter_Gyro_BiasConst_Z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_BiasConst_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Parameter_Gyro_BiasConst_Z as text
%        str2double(get(hObject,'String')) returns contents of edit_Parameter_Gyro_BiasConst_Z as a double
global Para_Gyro_BiasConst_Z
Para_Gyro_BiasConst_Z = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Parameter_Gyro_BiasConst_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Parameter_Gyro_BiasConst_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes when selected object is changed in uibuttongroup_SensorChoose_IMU.
function uibuttongroup_SensorChoose_IMU_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_SensorChoose_IMU 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SensorChoose_IMU
str = get(hObject,'tag');
switch str
    case 'radiobutton1'
        SensorChoose_IMU = 1;
    case 'radiobutton2'
        SensorChoose_IMU = 2;     
    case 'radiobutton3'
        SensorChoose_IMU = 3;
    case 'radiobutton4'
        SensorChoose_IMU = 4;
    case 'radiobutton5'
        SensorChoose_IMU = 5;
    case 'radiobutton6'
        SensorChoose_IMU = 6;
    case 'radiobutton7'
        SensorChoose_IMU = 7;        
end

%陀螺 常值零偏 度/h
global Para_Gyro_BiasConst_X Para_Gyro_BiasConst_Y Para_Gyro_BiasConst_Z
%陀螺 零偏稳定性 度/h
global Para_Gyro_BiasStab_X Para_Gyro_BiasStab_Y Para_Gyro_BiasStab_Z
%陀螺 角度随机游走 度/h-1/2
global Para_Gyro_ARW_X Para_Gyro_ARW_Y Para_Gyro_ARW_Z
%加计 常值零偏 mg
global Para_Acc_BiasConst_X Para_Acc_BiasConst_Y Para_Acc_BiasConst_Z
%加计 零偏稳定性 mg
global Para_Acc_BiasStab_X Para_Acc_BiasStab_Y Para_Acc_BiasStab_Z
%加计 速度随机游走 
global Para_Acc_VRW_X Para_Acc_VRW_Y Para_Acc_VRW_Z
%加计安装参数 变换矩阵
global Para_Acc_Calibration_6Local

switch SensorChoose_IMU    
    case 1
        % MPU_L
        Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
        Para_Gyro_BiasStab_X = 50; Para_Gyro_BiasStab_Y = 80; Para_Gyro_BiasStab_Z = 50; 
        Para_Gyro_ARW_X = 10; Para_Gyro_ARW_Y = 10; Para_Gyro_ARW_Z = 10;
        %Para_Acc_BiasConst_X = -10; Para_Acc_BiasConst_Y = 31; Para_Acc_BiasConst_Z = -33;
        Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0;
        Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
        Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;
        % 安装误差
        Para_Acc_Calibration_6Local = [1.000264037	-0.00004585	-0.006794537 -0.010055843;
                                        -0.0051893  0.99927623	0.01848056  0.03118094;
                                        0.024396733	-0.00342088	0.998533567	-0.033433563];
        %器件参数显示更新
        set(handles.edit_Parameter_Gyro_BiasConst_X,'string',num2str(Para_Gyro_BiasConst_X));
        set(handles.edit_Parameter_Gyro_BiasConst_Y,'string',num2str(Para_Gyro_BiasConst_Y));
        set(handles.edit_Parameter_Gyro_BiasConst_Z,'string',num2str(Para_Gyro_BiasConst_Z));
        set(handles.edit_Parameter_Gyro_BiasStab_X,'string',num2str(Para_Gyro_BiasStab_X));
        set(handles.edit_Parameter_Gyro_BiasStab_Y,'string',num2str(Para_Gyro_BiasStab_Y));
        set(handles.edit_Parameter_Gyro_BiasStab_Z,'string',num2str(Para_Gyro_BiasStab_Z));
        set(handles.edit_Parameter_Gyro_ARW_X,'string',num2str(Para_Gyro_ARW_X));
        set(handles.edit_Parameter_Gyro_ARW_Y,'string',num2str(Para_Gyro_ARW_Y));
        set(handles.edit_Parameter_Gyro_ARW_Z,'string',num2str(Para_Gyro_ARW_Z));
        set(handles.edit_Parameter_Acc_BiasConst_X,'string',num2str(Para_Acc_BiasConst_X));
        set(handles.edit_Parameter_Acc_BiasConst_Y,'string',num2str(Para_Acc_BiasConst_Y));
        set(handles.edit_Parameter_Acc_BiasConst_Z,'string',num2str(Para_Acc_BiasConst_Z));
        set(handles.edit_Parameter_Acc_BiasStab_X,'string',num2str(Para_Acc_BiasStab_X));
        set(handles.edit_Parameter_Acc_BiasStab_Y,'string',num2str(Para_Acc_BiasStab_Y));
        set(handles.edit_Parameter_Acc_BiasStab_Z,'string',num2str(Para_Acc_BiasStab_Z));
        set(handles.edit_Parameter_Acc_VRW_X,'string',num2str(Para_Acc_VRW_X));
        set(handles.edit_Parameter_Acc_VRW_Y,'string',num2str(Para_Acc_VRW_Y));
        set(handles.edit_Parameter_Acc_VRW_Z,'string',num2str(Para_Acc_VRW_Z));
        
        set(handles.edit_Calibration_c11,'string',num2str(Para_Acc_Calibration_6Local(1,1)));
        set(handles.edit_Calibration_c12,'string',num2str(Para_Acc_Calibration_6Local(1,2)));
        set(handles.edit_Calibration_c13,'string',num2str(Para_Acc_Calibration_6Local(1,3)));
        set(handles.edit_Calibration_c21,'string',num2str(Para_Acc_Calibration_6Local(2,1)));
        set(handles.edit_Calibration_c22,'string',num2str(Para_Acc_Calibration_6Local(2,2)));
        set(handles.edit_Calibration_c23,'string',num2str(Para_Acc_Calibration_6Local(2,3)));
        set(handles.edit_Calibration_c31,'string',num2str(Para_Acc_Calibration_6Local(3,1)));
        set(handles.edit_Calibration_c32,'string',num2str(Para_Acc_Calibration_6Local(3,2)));
        set(handles.edit_Calibration_c33,'string',num2str(Para_Acc_Calibration_6Local(3,3)));     
        
    case 2
        % MPU_R
        Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
        Para_Gyro_BiasStab_X = 50; Para_Gyro_BiasStab_Y = 120; Para_Gyro_BiasStab_Z = 85; 
        Para_Gyro_ARW_X = 15; Para_Gyro_ARW_Y = 15; Para_Gyro_ARW_Z = 15;
        %Para_Acc_BiasConst_X = -35; Para_Acc_BiasConst_Y = 21; Para_Acc_BiasConst_Z = -12;
        Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0;
        Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
        Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;
        % 安装误差
        Para_Acc_Calibration_6Local = [1.0000878	-0.00043916	-0.024920843 -0.034663453;
                                        0.001574943	1.00120647 	-0.004760667 0.020979463;
                                        0.047300417	0.00194185 	0.998779413 -0.012164637];   
        %器件参数显示更新
        set(handles.edit_Parameter_Gyro_BiasConst_X,'string',num2str(Para_Gyro_BiasConst_X));
        set(handles.edit_Parameter_Gyro_BiasConst_Y,'string',num2str(Para_Gyro_BiasConst_Y));
        set(handles.edit_Parameter_Gyro_BiasConst_Z,'string',num2str(Para_Gyro_BiasConst_Z));
        set(handles.edit_Parameter_Gyro_BiasStab_X,'string',num2str(Para_Gyro_BiasStab_X));
        set(handles.edit_Parameter_Gyro_BiasStab_Y,'string',num2str(Para_Gyro_BiasStab_Y));
        set(handles.edit_Parameter_Gyro_BiasStab_Z,'string',num2str(Para_Gyro_BiasStab_Z));
        set(handles.edit_Parameter_Gyro_ARW_X,'string',num2str(Para_Gyro_ARW_X));
        set(handles.edit_Parameter_Gyro_ARW_Y,'string',num2str(Para_Gyro_ARW_Y));
        set(handles.edit_Parameter_Gyro_ARW_Z,'string',num2str(Para_Gyro_ARW_Z));
        set(handles.edit_Parameter_Acc_BiasConst_X,'string',num2str(Para_Acc_BiasConst_X));
        set(handles.edit_Parameter_Acc_BiasConst_Y,'string',num2str(Para_Acc_BiasConst_Y));
        set(handles.edit_Parameter_Acc_BiasConst_Z,'string',num2str(Para_Acc_BiasConst_Z));
        set(handles.edit_Parameter_Acc_BiasStab_X,'string',num2str(Para_Acc_BiasStab_X));
        set(handles.edit_Parameter_Acc_BiasStab_Y,'string',num2str(Para_Acc_BiasStab_Y));
        set(handles.edit_Parameter_Acc_BiasStab_Z,'string',num2str(Para_Acc_BiasStab_Z));
        set(handles.edit_Parameter_Acc_VRW_X,'string',num2str(Para_Acc_VRW_X));
        set(handles.edit_Parameter_Acc_VRW_Y,'string',num2str(Para_Acc_VRW_Y));
        set(handles.edit_Parameter_Acc_VRW_Z,'string',num2str(Para_Acc_VRW_Z));
                
        set(handles.edit_Calibration_c11,'string',num2str(Para_Acc_Calibration_6Local(1,1)));
        set(handles.edit_Calibration_c12,'string',num2str(Para_Acc_Calibration_6Local(1,2)));
        set(handles.edit_Calibration_c13,'string',num2str(Para_Acc_Calibration_6Local(1,3)));
        set(handles.edit_Calibration_c21,'string',num2str(Para_Acc_Calibration_6Local(2,1)));
        set(handles.edit_Calibration_c22,'string',num2str(Para_Acc_Calibration_6Local(2,2)));
        set(handles.edit_Calibration_c23,'string',num2str(Para_Acc_Calibration_6Local(2,3)));
        set(handles.edit_Calibration_c31,'string',num2str(Para_Acc_Calibration_6Local(3,1)));
        set(handles.edit_Calibration_c32,'string',num2str(Para_Acc_Calibration_6Local(3,2)));
        set(handles.edit_Calibration_c33,'string',num2str(Para_Acc_Calibration_6Local(3,3)));    
    case 3
        % ADIS_L
        % 器件特性参数
        Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
        Para_Gyro_BiasStab_X = 0; Para_Gyro_BiasStab_Y = 0; Para_Gyro_BiasStab_Z = 0; 
        Para_Gyro_ARW_X = 0; Para_Gyro_ARW_Y = 0; Para_Gyro_ARW_Z = 0;
        Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0;
        Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
        Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;     
        % 安装误差
        Para_Acc_Calibration_6Local = zeros(3,3);   
        %器件参数显示更新
        set(handles.edit_Parameter_Gyro_BiasConst_X,'string',num2str(Para_Gyro_BiasConst_X));
        set(handles.edit_Parameter_Gyro_BiasConst_Y,'string',num2str(Para_Gyro_BiasConst_Y));
        set(handles.edit_Parameter_Gyro_BiasConst_Z,'string',num2str(Para_Gyro_BiasConst_Z));
        set(handles.edit_Parameter_Gyro_BiasStab_X,'string',num2str(Para_Gyro_BiasStab_X));
        set(handles.edit_Parameter_Gyro_BiasStab_Y,'string',num2str(Para_Gyro_BiasStab_Y));
        set(handles.edit_Parameter_Gyro_BiasStab_Z,'string',num2str(Para_Gyro_BiasStab_Z));
        set(handles.edit_Parameter_Gyro_ARW_X,'string',num2str(Para_Gyro_ARW_X));
        set(handles.edit_Parameter_Gyro_ARW_Y,'string',num2str(Para_Gyro_ARW_Y));
        set(handles.edit_Parameter_Gyro_ARW_Z,'string',num2str(Para_Gyro_ARW_Z));
        set(handles.edit_Parameter_Acc_BiasConst_X,'string',num2str(Para_Acc_BiasConst_X));
        set(handles.edit_Parameter_Acc_BiasConst_Y,'string',num2str(Para_Acc_BiasConst_Y));
        set(handles.edit_Parameter_Acc_BiasConst_Z,'string',num2str(Para_Acc_BiasConst_Z));
        set(handles.edit_Parameter_Acc_BiasStab_X,'string',num2str(Para_Acc_BiasStab_X));
        set(handles.edit_Parameter_Acc_BiasStab_Y,'string',num2str(Para_Acc_BiasStab_Y));
        set(handles.edit_Parameter_Acc_BiasStab_Z,'string',num2str(Para_Acc_BiasStab_Z));
        set(handles.edit_Parameter_Acc_VRW_X,'string',num2str(Para_Acc_VRW_X));
        set(handles.edit_Parameter_Acc_VRW_Y,'string',num2str(Para_Acc_VRW_Y));
        set(handles.edit_Parameter_Acc_VRW_Z,'string',num2str(Para_Acc_VRW_Z));
                
        set(handles.edit_Calibration_c11,'string',num2str(Para_Acc_Calibration_6Local(1,1)));
        set(handles.edit_Calibration_c12,'string',num2str(Para_Acc_Calibration_6Local(1,2)));
        set(handles.edit_Calibration_c13,'string',num2str(Para_Acc_Calibration_6Local(1,3)));
        set(handles.edit_Calibration_c21,'string',num2str(Para_Acc_Calibration_6Local(2,1)));
        set(handles.edit_Calibration_c22,'string',num2str(Para_Acc_Calibration_6Local(2,2)));
        set(handles.edit_Calibration_c23,'string',num2str(Para_Acc_Calibration_6Local(2,3)));
        set(handles.edit_Calibration_c31,'string',num2str(Para_Acc_Calibration_6Local(3,1)));
        set(handles.edit_Calibration_c32,'string',num2str(Para_Acc_Calibration_6Local(3,2)));
        set(handles.edit_Calibration_c33,'string',num2str(Para_Acc_Calibration_6Local(3,3)));             
    case 4
        % ADIS_R
         % 器件特性参数
        Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
        Para_Gyro_BiasStab_X = 0; Para_Gyro_BiasStab_Y = 0; Para_Gyro_BiasStab_Z = 0; 
        Para_Gyro_ARW_X = 0; Para_Gyro_ARW_Y = 0; Para_Gyro_ARW_Z = 0;
        Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0;
        Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
        Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;     
        % 安装误差
        Para_Acc_Calibration_6Local = zeros(3,3);   
        %器件参数显示更新
        set(handles.edit_Parameter_Gyro_BiasConst_X,'string',num2str(Para_Gyro_BiasConst_X));
        set(handles.edit_Parameter_Gyro_BiasConst_Y,'string',num2str(Para_Gyro_BiasConst_Y));
        set(handles.edit_Parameter_Gyro_BiasConst_Z,'string',num2str(Para_Gyro_BiasConst_Z));
        set(handles.edit_Parameter_Gyro_BiasStab_X,'string',num2str(Para_Gyro_BiasStab_X));
        set(handles.edit_Parameter_Gyro_BiasStab_Y,'string',num2str(Para_Gyro_BiasStab_Y));
        set(handles.edit_Parameter_Gyro_BiasStab_Z,'string',num2str(Para_Gyro_BiasStab_Z));
        set(handles.edit_Parameter_Gyro_ARW_X,'string',num2str(Para_Gyro_ARW_X));
        set(handles.edit_Parameter_Gyro_ARW_Y,'string',num2str(Para_Gyro_ARW_Y));
        set(handles.edit_Parameter_Gyro_ARW_Z,'string',num2str(Para_Gyro_ARW_Z));
        set(handles.edit_Parameter_Acc_BiasConst_X,'string',num2str(Para_Acc_BiasConst_X));
        set(handles.edit_Parameter_Acc_BiasConst_Y,'string',num2str(Para_Acc_BiasConst_Y));
        set(handles.edit_Parameter_Acc_BiasConst_Z,'string',num2str(Para_Acc_BiasConst_Z));
        set(handles.edit_Parameter_Acc_BiasStab_X,'string',num2str(Para_Acc_BiasStab_X));
        set(handles.edit_Parameter_Acc_BiasStab_Y,'string',num2str(Para_Acc_BiasStab_Y));
        set(handles.edit_Parameter_Acc_BiasStab_Z,'string',num2str(Para_Acc_BiasStab_Z));
        set(handles.edit_Parameter_Acc_VRW_X,'string',num2str(Para_Acc_VRW_X));
        set(handles.edit_Parameter_Acc_VRW_Y,'string',num2str(Para_Acc_VRW_Y));
        set(handles.edit_Parameter_Acc_VRW_Z,'string',num2str(Para_Acc_VRW_Z));
                
        set(handles.edit_Calibration_c11,'string',num2str(Para_Acc_Calibration_6Local(1,1)));
        set(handles.edit_Calibration_c12,'string',num2str(Para_Acc_Calibration_6Local(1,2)));
        set(handles.edit_Calibration_c13,'string',num2str(Para_Acc_Calibration_6Local(1,3)));
        set(handles.edit_Calibration_c21,'string',num2str(Para_Acc_Calibration_6Local(2,1)));
        set(handles.edit_Calibration_c22,'string',num2str(Para_Acc_Calibration_6Local(2,2)));
        set(handles.edit_Calibration_c23,'string',num2str(Para_Acc_Calibration_6Local(2,3)));
        set(handles.edit_Calibration_c31,'string',num2str(Para_Acc_Calibration_6Local(3,1)));
        set(handles.edit_Calibration_c32,'string',num2str(Para_Acc_Calibration_6Local(3,2)));
        set(handles.edit_Calibration_c33,'string',num2str(Para_Acc_Calibration_6Local(3,3)));            
    case 5
        % MTi_L
         % 器件特性参数
        Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
        Para_Gyro_BiasStab_X = 0; Para_Gyro_BiasStab_Y = 0; Para_Gyro_BiasStab_Z = 0; 
        Para_Gyro_ARW_X = 0; Para_Gyro_ARW_Y = 0; Para_Gyro_ARW_Z = 0;
        Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0;
        Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
        Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;     
        % 安装误差
        Para_Acc_Calibration_6Local = zeros(3,3);   
        %器件参数显示更新
        set(handles.edit_Parameter_Gyro_BiasConst_X,'string',num2str(Para_Gyro_BiasConst_X));
        set(handles.edit_Parameter_Gyro_BiasConst_Y,'string',num2str(Para_Gyro_BiasConst_Y));
        set(handles.edit_Parameter_Gyro_BiasConst_Z,'string',num2str(Para_Gyro_BiasConst_Z));
        set(handles.edit_Parameter_Gyro_BiasStab_X,'string',num2str(Para_Gyro_BiasStab_X));
        set(handles.edit_Parameter_Gyro_BiasStab_Y,'string',num2str(Para_Gyro_BiasStab_Y));
        set(handles.edit_Parameter_Gyro_BiasStab_Z,'string',num2str(Para_Gyro_BiasStab_Z));
        set(handles.edit_Parameter_Gyro_ARW_X,'string',num2str(Para_Gyro_ARW_X));
        set(handles.edit_Parameter_Gyro_ARW_Y,'string',num2str(Para_Gyro_ARW_Y));
        set(handles.edit_Parameter_Gyro_ARW_Z,'string',num2str(Para_Gyro_ARW_Z));
        set(handles.edit_Parameter_Acc_BiasConst_X,'string',num2str(Para_Acc_BiasConst_X));
        set(handles.edit_Parameter_Acc_BiasConst_Y,'string',num2str(Para_Acc_BiasConst_Y));
        set(handles.edit_Parameter_Acc_BiasConst_Z,'string',num2str(Para_Acc_BiasConst_Z));
        set(handles.edit_Parameter_Acc_BiasStab_X,'string',num2str(Para_Acc_BiasStab_X));
        set(handles.edit_Parameter_Acc_BiasStab_Y,'string',num2str(Para_Acc_BiasStab_Y));
        set(handles.edit_Parameter_Acc_BiasStab_Z,'string',num2str(Para_Acc_BiasStab_Z));
        set(handles.edit_Parameter_Acc_VRW_X,'string',num2str(Para_Acc_VRW_X));
        set(handles.edit_Parameter_Acc_VRW_Y,'string',num2str(Para_Acc_VRW_Y));
        set(handles.edit_Parameter_Acc_VRW_Z,'string',num2str(Para_Acc_VRW_Z));
                
        set(handles.edit_Calibration_c11,'string',num2str(Para_Acc_Calibration_6Local(1,1)));
        set(handles.edit_Calibration_c12,'string',num2str(Para_Acc_Calibration_6Local(1,2)));
        set(handles.edit_Calibration_c13,'string',num2str(Para_Acc_Calibration_6Local(1,3)));
        set(handles.edit_Calibration_c21,'string',num2str(Para_Acc_Calibration_6Local(2,1)));
        set(handles.edit_Calibration_c22,'string',num2str(Para_Acc_Calibration_6Local(2,2)));
        set(handles.edit_Calibration_c23,'string',num2str(Para_Acc_Calibration_6Local(2,3)));
        set(handles.edit_Calibration_c31,'string',num2str(Para_Acc_Calibration_6Local(3,1)));
        set(handles.edit_Calibration_c32,'string',num2str(Para_Acc_Calibration_6Local(3,2)));
        set(handles.edit_Calibration_c33,'string',num2str(Para_Acc_Calibration_6Local(3,3)));            
    case 6
        % MTi_R
        % 器件特性参数
        Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
        Para_Gyro_BiasStab_X = 0; Para_Gyro_BiasStab_Y = 0; Para_Gyro_BiasStab_Z = 0; 
        Para_Gyro_ARW_X = 0; Para_Gyro_ARW_Y = 0; Para_Gyro_ARW_Z = 0;
        Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0;
        Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
        Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;     
        % 安装误差
        Para_Acc_Calibration_6Local = zeros(3,3);   
        %器件参数显示更新
        set(handles.edit_Parameter_Gyro_BiasConst_X,'string',num2str(Para_Gyro_BiasConst_X));
        set(handles.edit_Parameter_Gyro_BiasConst_Y,'string',num2str(Para_Gyro_BiasConst_Y));
        set(handles.edit_Parameter_Gyro_BiasConst_Z,'string',num2str(Para_Gyro_BiasConst_Z));
        set(handles.edit_Parameter_Gyro_BiasStab_X,'string',num2str(Para_Gyro_BiasStab_X));
        set(handles.edit_Parameter_Gyro_BiasStab_Y,'string',num2str(Para_Gyro_BiasStab_Y));
        set(handles.edit_Parameter_Gyro_BiasStab_Z,'string',num2str(Para_Gyro_BiasStab_Z));
        set(handles.edit_Parameter_Gyro_ARW_X,'string',num2str(Para_Gyro_ARW_X));
        set(handles.edit_Parameter_Gyro_ARW_Y,'string',num2str(Para_Gyro_ARW_Y));
        set(handles.edit_Parameter_Gyro_ARW_Z,'string',num2str(Para_Gyro_ARW_Z));
        set(handles.edit_Parameter_Acc_BiasConst_X,'string',num2str(Para_Acc_BiasConst_X));
        set(handles.edit_Parameter_Acc_BiasConst_Y,'string',num2str(Para_Acc_BiasConst_Y));
        set(handles.edit_Parameter_Acc_BiasConst_Z,'string',num2str(Para_Acc_BiasConst_Z));
        set(handles.edit_Parameter_Acc_BiasStab_X,'string',num2str(Para_Acc_BiasStab_X));
        set(handles.edit_Parameter_Acc_BiasStab_Y,'string',num2str(Para_Acc_BiasStab_Y));
        set(handles.edit_Parameter_Acc_BiasStab_Z,'string',num2str(Para_Acc_BiasStab_Z));
        set(handles.edit_Parameter_Acc_VRW_X,'string',num2str(Para_Acc_VRW_X));
        set(handles.edit_Parameter_Acc_VRW_Y,'string',num2str(Para_Acc_VRW_Y));
        set(handles.edit_Parameter_Acc_VRW_Z,'string',num2str(Para_Acc_VRW_Z));
                
        set(handles.edit_Calibration_c11,'string',num2str(Para_Acc_Calibration_6Local(1,1)));
        set(handles.edit_Calibration_c12,'string',num2str(Para_Acc_Calibration_6Local(1,2)));
        set(handles.edit_Calibration_c13,'string',num2str(Para_Acc_Calibration_6Local(1,3)));
        set(handles.edit_Calibration_c21,'string',num2str(Para_Acc_Calibration_6Local(2,1)));
        set(handles.edit_Calibration_c22,'string',num2str(Para_Acc_Calibration_6Local(2,2)));
        set(handles.edit_Calibration_c23,'string',num2str(Para_Acc_Calibration_6Local(2,3)));
        set(handles.edit_Calibration_c31,'string',num2str(Para_Acc_Calibration_6Local(3,1)));
        set(handles.edit_Calibration_c32,'string',num2str(Para_Acc_Calibration_6Local(3,2)));
        set(handles.edit_Calibration_c33,'string',num2str(Para_Acc_Calibration_6Local(3,3)));             
    case 7
        % Other
        % 器件特性参数
        Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
        Para_Gyro_BiasStab_X = 0; Para_Gyro_BiasStab_Y = 0; Para_Gyro_BiasStab_Z = 0; 
        Para_Gyro_ARW_X = 0; Para_Gyro_ARW_Y = 0; Para_Gyro_ARW_Z = 0;
        Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0;
        Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
        Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;     
        % 安装误差
        Para_Acc_Calibration_6Local = zeros(3,3);   
        %器件参数显示更新
        set(handles.edit_Parameter_Gyro_BiasConst_X,'string',num2str(Para_Gyro_BiasConst_X));
        set(handles.edit_Parameter_Gyro_BiasConst_Y,'string',num2str(Para_Gyro_BiasConst_Y));
        set(handles.edit_Parameter_Gyro_BiasConst_Z,'string',num2str(Para_Gyro_BiasConst_Z));
        set(handles.edit_Parameter_Gyro_BiasStab_X,'string',num2str(Para_Gyro_BiasStab_X));
        set(handles.edit_Parameter_Gyro_BiasStab_Y,'string',num2str(Para_Gyro_BiasStab_Y));
        set(handles.edit_Parameter_Gyro_BiasStab_Z,'string',num2str(Para_Gyro_BiasStab_Z));
        set(handles.edit_Parameter_Gyro_ARW_X,'string',num2str(Para_Gyro_ARW_X));
        set(handles.edit_Parameter_Gyro_ARW_Y,'string',num2str(Para_Gyro_ARW_Y));
        set(handles.edit_Parameter_Gyro_ARW_Z,'string',num2str(Para_Gyro_ARW_Z));
        set(handles.edit_Parameter_Acc_BiasConst_X,'string',num2str(Para_Acc_BiasConst_X));
        set(handles.edit_Parameter_Acc_BiasConst_Y,'string',num2str(Para_Acc_BiasConst_Y));
        set(handles.edit_Parameter_Acc_BiasConst_Z,'string',num2str(Para_Acc_BiasConst_Z));
        set(handles.edit_Parameter_Acc_BiasStab_X,'string',num2str(Para_Acc_BiasStab_X));
        set(handles.edit_Parameter_Acc_BiasStab_Y,'string',num2str(Para_Acc_BiasStab_Y));
        set(handles.edit_Parameter_Acc_BiasStab_Z,'string',num2str(Para_Acc_BiasStab_Z));
        set(handles.edit_Parameter_Acc_VRW_X,'string',num2str(Para_Acc_VRW_X));
        set(handles.edit_Parameter_Acc_VRW_Y,'string',num2str(Para_Acc_VRW_Y));
        set(handles.edit_Parameter_Acc_VRW_Z,'string',num2str(Para_Acc_VRW_Z));
                
        set(handles.edit_Calibration_c11,'string',num2str(Para_Acc_Calibration_6Local(1,1)));
        set(handles.edit_Calibration_c12,'string',num2str(Para_Acc_Calibration_6Local(1,2)));
        set(handles.edit_Calibration_c13,'string',num2str(Para_Acc_Calibration_6Local(1,3)));
        set(handles.edit_Calibration_c21,'string',num2str(Para_Acc_Calibration_6Local(2,1)));
        set(handles.edit_Calibration_c22,'string',num2str(Para_Acc_Calibration_6Local(2,2)));
        set(handles.edit_Calibration_c23,'string',num2str(Para_Acc_Calibration_6Local(2,3)));
        set(handles.edit_Calibration_c31,'string',num2str(Para_Acc_Calibration_6Local(3,1)));
        set(handles.edit_Calibration_c32,'string',num2str(Para_Acc_Calibration_6Local(3,2)));
        set(handles.edit_Calibration_c33,'string',num2str(Para_Acc_Calibration_6Local(3,3)));            
end


% --- Executes on button press in radiobutton_Nav_5.
function radiobutton_Nav_5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Nav_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Nav_5


% --- Executes on button press in radiobutton_Nav_3.
function radiobutton_Nav_3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_Nav_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_Nav_3


% --- Executes when selected object is changed in uibuttongroup_Nav_Choose.
function uibuttongroup_Nav_Choose_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_Nav_Choose 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NavMethod_Choose
str = get(hObject,'tag');
switch str
    case 'radiobutton_Nav_1'
        NavMethod_Choose = 1;
    case 'radiobutton_Nav_2'
        NavMethod_Choose = 2;     
    case 'radiobutton_Nav_3'
        NavMethod_Choose = 3;
    case 'radiobutton_Nav_4'
        NavMethod_Choose = 4;
    case 'radiobutton_Nav_5'
        NavMethod_Choose = 5;
    case 'radiobutton_Nav_6'
        NavMethod_Choose = 6;
    case 'radiobutton_Nav_7'
        NavMethod_Choose = 7;        
end



function edit_Calibration_c11_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_c11 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_c11 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_c11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_c12_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_c12 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_c12 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_c12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_c13_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_c13 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_c13 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_c13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_c21_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_c21 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_c21 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_c21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_c22_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_c22 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_c22 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_c22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_c23_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_c23 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_c23 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_c23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_c31_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_c31 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_c31 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_c31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_c32_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_c32 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_c32 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_c32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_c33_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_c33 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_c33 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_c33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_c33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibrat_Mag_2D_a11_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibrat_Mag_2D_a11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibrat_Mag_2D_a11 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibrat_Mag_2D_a11 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibrat_Mag_2D_a11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibrat_Mag_2D_a11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibrat_Mag_2D_a12_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibrat_Mag_2D_a12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibrat_Mag_2D_a12 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibrat_Mag_2D_a12 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibrat_Mag_2D_a12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibrat_Mag_2D_a12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibrat_Mag_2D_b11_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibrat_Mag_2D_b11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibrat_Mag_2D_b11 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibrat_Mag_2D_b11 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibrat_Mag_2D_b11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibrat_Mag_2D_b11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibrat_Mag_2D_a21_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibrat_Mag_2D_a21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibrat_Mag_2D_a21 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibrat_Mag_2D_a21 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibrat_Mag_2D_a21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibrat_Mag_2D_a21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibrat_Mag_2D_a22_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibrat_Mag_2D_a22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibrat_Mag_2D_a22 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibrat_Mag_2D_a22 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibrat_Mag_2D_a22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibrat_Mag_2D_a22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibrat_Mag_2D_b21_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibrat_Mag_2D_b21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibrat_Mag_2D_b21 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibrat_Mag_2D_b21 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibrat_Mag_2D_b21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibrat_Mag_2D_b21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_MagCalibra_2D.
function pushbutton_MagCalibra_2D_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MagCalibra_2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath] = uigetfile('*.mat');
if isequal(FileName,0)
   %路径为空
   disp('警告：****未选择磁强计椭圆校准数据*****');
   return;
end

% 1. 读取数据
load([FilePath,FileName]);
if (~exist('IMU','var') || ~exist('Magnetic','var') || ~exist('FootPres_State','var'))   
    disp('错误:未读取到IMU or 磁强计 or 压力状态 数据！')
    return;
end

% 2. 按照零速判断结果进行数据分段，求取不同静止时段的 起始和终止节点
L = length(FootPres_State);
j = 1;
TStart = 0;  %判断是否进入静止阶段
for i = 1:L
    %第一个点的判断
    if i == 1
        if FootPres_State(1,2) == 1
            TStart = 1;  %进入静止阶段
            StaticRecord(1,1) = 1;
        end
    else
        if FootPres_State(i,2) ~= FootPres_State(i-1,2)
           % 状态发生变化
           if FootPres_State(i-1,2) == 1
              % 到结尾了
              StaticRecord(j,2) = i;
              j = j+1;
           else
              % 新时段的开始
              StaticRecord(j,1) = i;
           end
        end
    end  
end
% 增加结尾判断
if StaticRecord(j,2) == 0
    StaticRecord(j,2) = L;
end

% 3. 利用分段静止数据进行磁强计校准参数估计
% 3.1 分段获取加计和磁强计 静止时间段器件输出的均值
global Para_Acc_Calibration_6Local
L = length(StaticRecord);
Mean_Acc = zeros(L,3);
Mean_Mag = zeros(L,3);
for i = 1:L
    Mean_Acc(i,:) = mean(IMU(StaticRecord(i,1):StaticRecord(i,2),2:4));
    Mean_Mag(i,:) = mean(Magnetic(ceil(StaticRecord(i,1)/2):ceil(StaticRecord(i,2)/2-1),2:4));
end

% 3.2 先将加计进行校准，然后进行水平姿态的求取
Mean_Acc_Calibrat = zeros(L,3);
Mean_Att_Calibrat = zeros(L,3);
for i = 1:L
    Mean_Acc_Calibrat(i,:) = (Para_Acc_Calibration_6Local * [Mean_Acc(i,:),1]')';  
    [Mean_Att_Calibrat(i,1),Mean_Att_Calibrat(i,2)] = Att_Accel2Att(Mean_Acc_Calibrat(i,1),Mean_Acc_Calibrat(i,2),Mean_Acc_Calibrat(i,3));     
end

% 3.3 将磁强计的数据进行水平面投影
Mean_Mag_Level = zeros(L,3);
for i = 1:L
    C_b_n = Att_Euler2DCM(Mean_Att_Calibrat(i,:)');
    Mag = C_b_n*[Mean_Mag(i,:)'];
    Mean_Mag_Level(i,:) = Mag'; 
end

% 3.4 求取磁强计椭圆误差修正参数
[A22,B21] = Calibration_Mag_2D(Mean_Mag_Level);

% 3.5 利用校准后的旋转磁强计数据
Mean_Mag_Calibrat = zeros(L,2);
for i = 1:L
    Mean_Mag_Calibrat(i,1:2) = ((A22*Mean_Mag_Level(i,1:2)') - B21)';
end

% 3.5 绘制比较图形
figure;
plot(Mean_Mag(:,1),Mean_Mag(:,2),'*-'); grid on; 
hold on; plot(0,0,'ro');
hold on; plot(Mean_Mag_Calibrat(:,1),Mean_Mag_Calibrat(:,2),'r*-');

% 3.6 航向求取及比较
Yaw = zeros(L,1);
Yaw_Calibrat = zeros(L,1);
for i = 1:L
    Yaw(i,1) = Att_Mag2Yaw(0,0,Mean_Mag_Level(i,1),Mean_Mag_Level(i,2),0);
    Yaw_Calibrat(i,1) = Att_Mag2Yaw(0,0,Mean_Mag_Calibrat(i,1),Mean_Mag_Calibrat(i,2),0);
end
Yaw = Yaw .*(-180/pi);
Yaw_Calibrat = Yaw_Calibrat .*(-180/pi);
figure;
plot(Yaw,'*-'); grid on; 
hold on; plot(Yaw_Calibrat,'r*-');

% 4. 校准参数保存及显示
global Para_Calebrat_Mag_2D_A22 Para_Calebrat_Mag_2D_B21
Para_Calebrat_Mag_2D_A22 = A22;
Para_Calebrat_Mag_2D_B21 = B21;
set(handles.edit_Calibrat_Mag_2D_a11,'string',num2str(Para_Calebrat_Mag_2D_A22(1,1)));
set(handles.edit_Calibrat_Mag_2D_a12,'string',num2str(Para_Calebrat_Mag_2D_A22(1,2)));
set(handles.edit_Calibrat_Mag_2D_a21,'string',num2str(Para_Calebrat_Mag_2D_A22(2,1)));
set(handles.edit_Calibrat_Mag_2D_a22,'string',num2str(Para_Calebrat_Mag_2D_A22(2,2)));
set(handles.edit_Calibrat_Mag_2D_b11,'string',num2str(Para_Calebrat_Mag_2D_B21(1,1)));
set(handles.edit_Calibrat_Mag_2D_b21,'string',num2str(Para_Calebrat_Mag_2D_B21(2,1)));


% --- Executes on button press in pushbutton_Nav_Method_1.
function pushbutton_Nav_Method_1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Nav_Method_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ---------方法1：普通惯导解算   解算结果存入 Result_1
%   存储的信息为 时间 姿态(度) 速度(m/s) 位置(纬度 经度 高程 /度 /m) 

% 1.读取数据
    global DataPath 
    load(DataPath);
    if (~exist('IMU','var') || ~exist('FootPres_State','var'))   
        disp('错误:未读取到IMU or 压力状态 数据！')
        return;
    end

% 2.设定初始状态 姿态 速度 位置
    global Start_Pitch Start_Roll Start_Yaw
    Start_Att = [Start_Pitch;Start_Roll;Start_Yaw]; 
    Start_Vel = zeros(3,1);
    global Start_Lat Start_Lon Start_High
    Start_Pos = [Start_Lat;Start_Lon;Start_High];

% 3.参数设定
    % 3.1 系统参数 标校参数 全局参数
        global Hz Para_Acc_Calibration_6Local
        Ts = 1/Hz;
        G_Const = CONST_Init();
        M_a = Para_Acc_Calibration_6Local;
    % 3.2 变量空间声明
        L = length(IMU);
        AVP = zeros(L,10);
        
    % 3.3 器件参数 
        %(1) 利用静止状态数据获取陀螺输出零偏初值
            %判断是否存在步态信息数据
            if exist('FootPres_State','var')
                Num = 1;
                while FootPres_State(Num,2)
                    Num = Num+1;
                end
                Num = Num-1;
                if Num > 0
                    msgbox(strcat('取前面几秒位置平均：',num2str(ceil(Num/Hz))));
                else
                    msgbox('初始状态为动态，无法求取初始陀螺零偏！');
                    return;        
                end
            else
                msgbox('缺少步态信息');
                return;
            end
            %求取陀螺输出零偏
            Gyro_Bias = [mean(IMU(1:Num,5));mean(IMU(1:Num,6));mean(IMU(1:Num,7))];
        %(2) 加计零偏估计还未实现，暂时为0
            Acc_Bias = [0;0;0];
            
    % 3.4 惯导解算初始化             
        %(1)惯导解算结构体初始化 
        INSData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
        INSData_Pre = INSData_Now;        
        
% 4.循环导航解算
    for i = 1:L
        %(1)获取IMU原始数据
        INSData_Now.time = IMU(i,1);    
        INSData_Now.w_ib_b = IMU(i,5:7)';   %陀螺          
        INSData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %加计 
        
        %(2)陀螺和加计 原始数据修正
        %加计修正 (此处仅修正加计的，因为6位置法仅校准加计的非正交)，后面可以试验，同时修正陀螺的是否有效果！        
        INSData_Now.f_ib_b = M_a*[INSData_Now.f_ib_b;1];
        %陀螺零偏修正
        INSData_Now.w_ib_b = INSData_Now.w_ib_b - INSData_Now.eb;
        
        %(3)惯导解算
        INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts);             
            
        %(4)保存导航结果
        AVP(i,1) = INSData_Now.time;      
        AVP(i,2:4) = INSData_Now.att';
        AVP(i,5:7) = INSData_Now.vel';
        AVP(i,8:10) = INSData_Now.pos';     
        
        %(5)更新导航数据
        INSData_Pre =  INSData_Now;        
    end

% 5.保存导航结果    
    Result_1 = zeros(L,10); 
    Result_1(:,1) = AVP(:,1); %时间
    Result_1(:,2:3) = AVP(:,2:3); %姿态
    Result_1(:,4) = -AVP(:,4); %姿态
    Result_1(:,5:7) = AVP(:,5:7); %速度
    Result_1(:,8:10) = AVP(:,8:10); %纬度 经度 高程    
    Plot_AVP_Group(Result_1);    
    save(DataPath,'Result_1','-append');
  

% --- Executes on button press in pushbutton_Nav_Method_2.
function pushbutton_Nav_Method_2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Nav_Method_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ---------方法2：ZUPT解算 普通归0   解算结果存入 Result_2
% 1.读取数据
    global DataPath 
    load(DataPath);
    if (~exist('IMU','var') || ~exist('FootPres_State','var'))   
        disp('错误:未读取到IMU or 压力状态 数据！')
        return;
    end

% 2.设定初始状态 姿态 速度 位置
    global Start_Pitch Start_Roll Start_Yaw
    Start_Att = [Start_Pitch;Start_Roll;Start_Yaw]; 
    Start_Vel = zeros(3,1);
    global Start_Lat Start_Lon Start_High
    Start_Pos = [Start_Lat;Start_Lon;Start_High];

% 3.参数设定
    % 3.1 系统参数 标校参数 全局参数
        global Hz Para_Acc_Calibration_6Local
        Ts = 1/Hz;
        G_Const = CONST_Init();
        M_a = Para_Acc_Calibration_6Local;
    % 3.2 变量空间声明
        L = length(IMU);
        AVP = zeros(L,10);
        
    % 3.3 器件参数 
        %(1) 利用静止状态数据获取陀螺输出零偏初值
            %判断是否存在步态信息数据
            if exist('FootPres_State','var')
                Num = 1;
                while FootPres_State(Num,2)
                    Num = Num+1;
                end
                Num = Num-1;
                if Num > 0
                    msgbox(strcat('取前面几秒位置平均：',num2str(ceil(Num/Hz))));
                else
                    msgbox('初始状态为动态，无法求取初始陀螺零偏！');
                    return;        
                end
            else
                msgbox('缺少步态信息');
                return;
            end
            %求取陀螺输出零偏
            Gyro_Bias = [mean(IMU(1:Num,5));mean(IMU(1:Num,6));mean(IMU(1:Num,7))];
        %(2) 加计零偏估计还未实现，暂时为0
            Acc_Bias = [0;0;0];
            
    % 3.4 惯导解算初始化             
        %(1)惯导解算结构体初始化 
        INSData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
        INSData_Pre = INSData_Now;        
        
% 4.循环导航解算
    for i = 1:L
        %(1)获取IMU原始数据
        INSData_Now.time = IMU(i,1);    
        INSData_Now.w_ib_b = IMU(i,5:7)';   %陀螺          
        INSData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %加计 
        
        %(2)陀螺和加计 原始数据修正
        %加计修正 (此处仅修正加计的，因为6位置法仅校准加计的非正交)，后面可以试验，同时修正陀螺的是否有效果！        
        INSData_Now.f_ib_b = M_a*[INSData_Now.f_ib_b;1];
        %陀螺零偏修正
        INSData_Now.w_ib_b = INSData_Now.w_ib_b - INSData_Now.eb;
        
        %(3)惯导解算
        %根据零速状态进行普通归0处理：姿态保持上一刻不变，速度置0，位置保持上一刻不变
        if FootPres_State(i,2) == 1
            INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts); 
            INSData_Now.att = INSData_Pre.att;
            INSData_Now.C_b_n = Att_Euler2DCM(INSData_Now.att);
            INSData_Now.Q_b_n = Att_DCM2Q(INSData_Now.C_b_n);   
            INSData_Now.vel = [0;0;0];
            INSData_Now.pos = INSData_Pre.pos;
        else
            INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts);        
        end
            
        %(4)保存导航结果
        AVP(i,1) = INSData_Now.time;      
        AVP(i,2:4) = INSData_Now.att';
        AVP(i,5:7) = INSData_Now.vel';
        AVP(i,8:10) = INSData_Now.pos';     
        
        %(5)更新导航数据
        INSData_Pre =  INSData_Now;        
    end

% 5.保存导航结果    
    Result_2 = zeros(L,10); 
    Result_2(:,1) = AVP(:,1); %时间
    Result_2(:,2:3) = AVP(:,2:3); %姿态
    Result_2(:,4) = -AVP(:,4); %姿态
    Result_2(:,5:7) = AVP(:,5:7); %速度
    Result_2(:,8:10) = AVP(:,8:10); %纬度 经度 高程    
    Plot_AVP_Group(Result_2);    
    save(DataPath,'Result_2','-append');


% --- Executes on button press in pushbutton_Nav_Method_3.
function pushbutton_Nav_Method_3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Nav_Method_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ---------方法3：ZUPT解算 水平姿态修正   解算结果存入 Result_3
% 1.读取数据
    global DataPath 
    load(DataPath);
    if (~exist('IMU','var') || ~exist('FootPres_State','var'))   
        disp('错误:未读取到IMU or 压力状态 数据！')
        return;
    end

% 2.设定初始状态 姿态 速度 位置
    global Start_Pitch Start_Roll Start_Yaw
    Start_Att = [Start_Pitch;Start_Roll;Start_Yaw]; 
    Start_Vel = zeros(3,1);
    global Start_Lat Start_Lon Start_High
    Start_Pos = [Start_Lat;Start_Lon;Start_High];

% 3.参数设定
    % 3.1 系统参数 标校参数 全局参数
        global Hz Para_Acc_Calibration_6Local
        Ts = 1/Hz;
        G_Const = CONST_Init();
        M_a = Para_Acc_Calibration_6Local;
    % 3.2 变量空间声明
        L = length(IMU);
        AVP = zeros(L,10);
        
    % 3.3 器件参数 
        %(1) 利用静止状态数据获取陀螺输出零偏初值
            %判断是否存在步态信息数据
            if exist('FootPres_State','var')
                Num = 1;
                while FootPres_State(Num,2)
                    Num = Num+1;
                end
                Num = Num-1;
                if Num > 0
                    msgbox(strcat('取前面几秒位置平均：',num2str(ceil(Num/Hz))));
                else
                    msgbox('初始状态为动态，无法求取初始陀螺零偏！');
                    return;        
                end
            else
                msgbox('缺少步态信息');
                return;
            end
            %求取陀螺输出零偏
            Gyro_Bias = [mean(IMU(1:Num,5));mean(IMU(1:Num,6));mean(IMU(1:Num,7))];
        %(2) 加计零偏估计还未实现，暂时为0
            Acc_Bias = [0;0;0];
            
    % 3.4 惯导解算初始化             
        %(1)惯导解算结构体初始化 
        INSData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
        INSData_Pre = INSData_Now;        
        
% 4.循环导航解算
Static_State = 0;  %标识是否进入静止状态
    for i = 1:L
        %(1)获取IMU原始数据
        INSData_Now.time = IMU(i,1);    
        INSData_Now.w_ib_b = IMU(i,5:7)';   %陀螺          
        INSData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %加计 
        
        %(2)陀螺和加计 原始数据修正
        %加计修正 (此处仅修正加计的，因为6位置法仅校准加计的非正交)，后面可以试验，同时修正陀螺的是否有效果！        
        INSData_Now.f_ib_b = M_a*[INSData_Now.f_ib_b;1];
        %陀螺零偏修正
        INSData_Now.w_ib_b = INSData_Now.w_ib_b - INSData_Now.eb;
        
        %(3)惯导解算
        %根据零速状态进行普通归0处理：姿态保持上一刻不变，速度置0，位置保持上一刻不变
        if FootPres_State(i,2) == 1
            if Static_State == 0
                %刚进入静止状态
                n = 0;
                Acc_mean = [0;0;0];   
                Static_State = 1;
            end
            %加计求取累加平均
            Acc_mean = Acc_mean.*(n/(n+1)) + INSData_Now.f_ib_b./(n+1);
            n = n+1;
            %利用加计平均值求取水平姿态角
            [pitch,roll] = Att_Accel2Att(Acc_mean(1,1),Acc_mean(2,1),Acc_mean(3,1));    
            INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts); 
            INSData_Now.att = INSData_Pre.att;
            INSData_Now.att(1:2,1) = [pitch;roll];
            INSData_Now.C_b_n = Att_Euler2DCM(INSData_Now.att);
            INSData_Now.Q_b_n = Att_DCM2Q(INSData_Now.C_b_n);             
            INSData_Now.vel = [0;0;0];
            INSData_Now.pos = INSData_Pre.pos;
        else
            Static_State = 0;
            INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts);        
        end
            
        %(4)保存导航结果
        AVP(i,1) = INSData_Now.time;      
        AVP(i,2:4) = INSData_Now.att';
        AVP(i,5:7) = INSData_Now.vel';
        AVP(i,8:10) = INSData_Now.pos';     
        
        %(5)更新导航数据
        INSData_Pre =  INSData_Now;        
    end

% 5.保存导航结果    
    Result_3 = zeros(L,10); 
    Result_3(:,1) = AVP(:,1); %时间
    Result_3(:,2:3) = AVP(:,2:3); %姿态
    Result_3(:,4) = -AVP(:,4); %姿态
    Result_3(:,5:7) = AVP(:,5:7); %速度
    Result_3(:,8:10) = AVP(:,8:10); %纬度 经度 高程    
    Plot_AVP_Group(Result_3);    
    save(DataPath,'Result_3','-append');


% --- Executes on button press in pushbutton_Nav_Method_4.
function pushbutton_Nav_Method_4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Nav_Method_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ---------方法4：ZUPT解算 水平姿态修正+航向磁强计修正  解算结果存入 Result_4
% 1.读取数据
    global DataPath 
    load(DataPath);
    if (~exist('IMU','var') || ~exist('FootPres_State','var'))   
        disp('错误:未读取到IMU or 压力状态 数据！')
        return;
    end

% 2.设定初始状态 姿态 速度 位置
    global Start_Pitch Start_Roll Start_Yaw
    Start_Att = [Start_Pitch;Start_Roll;Start_Yaw]; 
    Start_Vel = zeros(3,1);
    global Start_Lat Start_Lon Start_High
    Start_Pos = [Start_Lat;Start_Lon;Start_High];

% 3.参数设定
    % 3.1 系统参数 标校参数 全局参数
        global Hz Para_Acc_Calibration_6Local
        global Para_Calebrat_Mag_2D_A22 Para_Calebrat_Mag_2D_B21
        Ts = 1/Hz;
        G_Const = CONST_Init();
        M_a = Para_Acc_Calibration_6Local;
    % 3.2 变量空间声明
        L = length(IMU)-1;
        AVP = zeros(L,10);
        
    % 3.3 器件参数 
        %(1) 利用静止状态数据获取陀螺输出零偏初值
            %判断是否存在步态信息数据
            if exist('FootPres_State','var')
                Num = 1;
                while FootPres_State(Num,2)
                    Num = Num+1;
                end
                Num = Num-1;
                if Num > 0
                    msgbox(strcat('取前面几秒位置平均：',num2str(ceil(Num/Hz))));
                else
                    msgbox('初始状态为动态，无法求取初始陀螺零偏！');
                    return;        
                end
            else
                msgbox('缺少步态信息');
                return;
            end
            %求取陀螺输出零偏
            Gyro_Bias = [mean(IMU(1:Num,5));mean(IMU(1:Num,6));mean(IMU(1:Num,7))];
        %(2) 加计零偏估计还未实现，暂时为0
            Acc_Bias = [0;0;0];
            
    % 3.4 惯导解算初始化             
        %(1)惯导解算结构体初始化 
        INSData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
        INSData_Pre = INSData_Now;        
        
% 4.循环导航解算
Static_State = 0;  %标识是否进入静止状态
    for i = 1:L
        %(1)获取IMU原始数据
        INSData_Now.time = IMU(i,1);    
        INSData_Now.w_ib_b = IMU(i,5:7)';   %陀螺          
        INSData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %加计 
        
        %(2)陀螺和加计 原始数据修正
        %加计修正 (此处仅修正加计的，因为6位置法仅校准加计的非正交)，后面可以试验，同时修正陀螺的是否有效果！        
        INSData_Now.f_ib_b = M_a*[INSData_Now.f_ib_b;1];
        %陀螺零偏修正
        INSData_Now.w_ib_b = INSData_Now.w_ib_b - INSData_Now.eb;
        
        %(3)惯导解算
        %根据零速状态进行普通归0处理：姿态保持上一刻不变，速度置0，位置保持上一刻不变
        if FootPres_State(i,2) == 1
            if Static_State == 0
                %刚进入静止状态
                n = 0;
                Acc_mean = [0;0;0];   
                Mag_mean = [0;0;0];   
                Static_State = 1;
            end
            %加计求取累加平均
            Acc_mean = Acc_mean.*(n/(n+1)) + INSData_Now.f_ib_b./(n+1);
            Mag_mean = Mag_mean.*(n/(n+1)) + (Magnetic(ceil(i/2),2:4))'./(n+1);
            n = n+1;
            %利用加计平均值求取水平姿态角
            [pitch,roll] = Att_Accel2Att(Acc_mean(1,1),Acc_mean(2,1),Acc_mean(3,1));
            %利用磁强计平均值求取航向角            
            C_b_n = Att_Euler2DCM([pitch;roll;0]);
            Mag_mean_Level = C_b_n*Mag_mean;
            Mag_mean_Level_Calibrat = ((Para_Calebrat_Mag_2D_A22*Mag_mean_Level(1:2,1)) - Para_Calebrat_Mag_2D_B21)';
            yaw = Att_Mag2Yaw(0,0,Mag_mean_Level_Calibrat(1,1),Mag_mean_Level_Calibrat(1,2),0);             
            
            INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts); 
            INSData_Now.att = [pitch;roll;yaw];
            INSData_Now.C_b_n = Att_Euler2DCM(INSData_Now.att);
            INSData_Now.Q_b_n = Att_DCM2Q(INSData_Now.C_b_n);             
            INSData_Now.vel = [0;0;0];
            INSData_Now.pos = INSData_Pre.pos;
        else
            Static_State = 0;
            INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts);        
        end
            
        %(4)保存导航结果
        AVP(i,1) = INSData_Now.time;      
        AVP(i,2:4) = INSData_Now.att';
        AVP(i,5:7) = INSData_Now.vel';
        AVP(i,8:10) = INSData_Now.pos';     
        
        %(5)更新导航数据
        INSData_Pre =  INSData_Now;        
    end

% 5.保存导航结果    
    Result_4 = zeros(L,10); 
    Result_4(:,1) = AVP(:,1); %时间
    Result_4(:,2:3) = AVP(:,2:3); %姿态
    Result_4(:,4) = -AVP(:,4); %姿态
    Result_4(:,5:7) = AVP(:,5:7); %速度
    Result_4(:,8:10) = AVP(:,8:10); %纬度 经度 高程    
    Plot_AVP_Group(Result_4);    
    save(DataPath,'Result_4','-append');
