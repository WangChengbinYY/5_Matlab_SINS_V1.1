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

%===========================ȫ�ֱ����趨=====================================
%================���ݴ��·�� 
global DataPath 
DataPath = []; 

%================�豸ѡ�� 
global SensorChoose_IMU SensorChoose_GPS SensorChoose_Magnetic SensorChoose_RTK
SensorChoose_IMU = 1;   % 1-MPU_L,2-MPU_R,3-ADIS_L,4-ADIS_R,5-MTi_L,6-MTi-R,7-����
SensorChoose_GPS = 0;   % 0-�ޣ�1-��
SensorChoose_Magnetic = 0;   % 0-�ޣ�1-��
SensorChoose_RTK = 0;   % 0-�ޣ�1-��

%================���������趨 Ĭ��Ϊ MPU IMU_A
%���� ��ֵ��ƫ ��/h
global Para_Gyro_BiasConst_X Para_Gyro_BiasConst_Y Para_Gyro_BiasConst_Z
Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
%���� ��ƫ�ȶ��� ��/h
global Para_Gyro_BiasStab_X Para_Gyro_BiasStab_Y Para_Gyro_BiasStab_Z
Para_Gyro_BiasStab_X = 50; Para_Gyro_BiasStab_Y = 80; Para_Gyro_BiasStab_Z = 50; 
%���� �Ƕ�������� ��/h-1/2
global Para_Gyro_ARW_X Para_Gyro_ARW_Y Para_Gyro_ARW_Z
Para_Gyro_ARW_X = 10; Para_Gyro_ARW_Y = 10; Para_Gyro_ARW_Z = 10;

%�Ӽ� ��ֵ��ƫ mg
global Para_Acc_BiasConst_X Para_Acc_BiasConst_Y Para_Acc_BiasConst_Z
% MEMS������ƫ����̫�󣬺���ʵʱ���ư�
%Para_Acc_BiasConst_X = -10; Para_Acc_BiasConst_Y = 31; Para_Acc_BiasConst_Z = -33;
Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0; 
%�Ӽ� ��ƫ�ȶ��� mg
global Para_Acc_BiasStab_X Para_Acc_BiasStab_Y Para_Acc_BiasStab_Z
Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
%�Ӽ� �ٶ�������� 
global Para_Acc_VRW_X Para_Acc_VRW_Y Para_Acc_VRW_Z
Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;

%����������ʾ����
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

%��װ���� �任����  MPU_L ��6λ��У׼����(���������������ӡ���ƫ)
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
        
%��ǿ��У׼������
global Para_Calebrat_Mag_2D_A22 Para_Calebrat_Mag_2D_B21
Para_Calebrat_Mag_2D_A22 = eye(2);
Para_Calebrat_Mag_2D_B21 = zeros(2,1);
%================ϵͳ�趨
%��ʼλ�� ��λ �� �� 
global Start_Lat Start_Lon Start_High
Start_Lat = 34.232698588*pi/180; Start_Lon = 108.959890932*pi/180; Start_High = 400;
%��ʼ��̬ ��λ��
global Start_Pitch Start_Roll Start_Yaw
Start_Pitch = 0*pi/180; Start_Roll = 0*pi/180; Start_Yaw = 0*pi/180;
%����Ƶ��
global Hz
Hz = 200;
%����������ʾ����
set(handles.edit_Start_Lat,'string',num2str(Start_Lat*180/pi,15));
set(handles.edit_Start_Lon,'string',num2str(Start_Lon*180/pi,15));
set(handles.edit_Start_High,'string',num2str(Start_High));
set(handles.edit_Start_Pitch,'string',num2str(Start_Pitch*180/pi));
set(handles.edit_Start_Roll,'string',num2str(Start_Roll*180/pi));
set(handles.edit_Start_Yaw,'string',num2str(Start_Yaw*180/pi));
set(handles.edit_Hz,'string',num2str(Hz));

%================��������
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
    %��GPS ��ʼλ�ð�ťʹ��
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
   %·��Ϊ��
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

% ��GPS�����л�ȡ��ʼλ����Ϣ
%   ������������в�̬��Ϣ�������ݿ�ʼ�ľ�ֹ�׶ν��� GPS��λƽ��
%         ����ȡǰTn������ݣ���ƽ��
global DataPath 
if isempty(DataPath)
    msgbox('����������·����');
    return;
end
%��ȡ����
load(DataPath);
%�ж��Ƿ���ڲ�̬��Ϣ����
if exist('FootPres_State','var')
    Tn = 1;
    i = 1;
    StartTime = fix(FootPres_State(i,1));
    while FootPres_State(i,2)
        i = i+1;
    end
    EndTime = fix(FootPres_State(i,1));
    Tn = EndTime-StartTime+1;
    msgbox(strcat('ȡǰ�漸��λ��ƽ����',num2str(Tn)));
else
    Tn = 5;
end

if exist('GPS','var')
%     msgbox('GPS���ݴ��ڣ�');
else
    msgbox('GPS���ݲ����ڣ�');
    return;
end
%��ȡǰTn��GPS��ƽ��ʱ��
global Start_Lat Start_Lon Start_High
if exist('HighGPS','var')   %��RTK���ݣ���ʹ��
    Start_Lat = mean(HighGPS(1:Tn,2));
    Start_Lon = mean(HighGPS(1:Tn,3));
    Start_High = mean(HighGPS(1:Tn,4));    
else    
    Start_Lat = mean(GPS(1:Tn,2));
    Start_Lon = mean(GPS(1:Tn,3));
    Start_High = mean(GPS(1:Tn,4));
end
Lat = Start_Lat*180/pi; Lon = Start_Lon*180/pi;
%���� ������ʾ
set(handles.edit_Start_Lat,'String',num2str(Lat,15));
set(handles.edit_Start_Lon,'String',num2str(Lon,15));
set(handles.edit_Start_High,'String',num2str(Start_High));


% --- Executes on button press in pushbutton_GetInitAtt_2.
function pushbutton_GetInitAtt_2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_GetInitAtt_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%���ó�ʼ��ֹ״̬�µļ��ٶ� ��� ˮƽ��̬��  ����ʹ��ֱ���趨
global Start_Pitch Start_Roll
%�ж�ʹ�þ�ֹ״̬��ʱ�䳤��
global DataPath 
global Hz
if isempty(DataPath)
    msgbox('����������·����');
    return;
end
%��ȡ����
load(DataPath);
%�ж��Ƿ���ڲ�̬��Ϣ����
if exist('FootPres_State','var')
    Num = 1;
    while FootPres_State(Num,2)
        Num = Num+1;
    end
    Num = Num-1;
    if Num > 0
        msgbox(strcat('ȡǰ�漸��λ��ƽ����',num2str(ceil(Num/Hz))));
    else
        msgbox('��ʼ״̬Ϊ��̬���޷�ˮƽ����׼��');
        return;        
    end
else
    msgbox('ȱ�ٲ�̬��Ϣ');
    return;
end

%ȡǰ��ֹ״̬���ݽ��г�ʼˮƽ��̬����ȡ
%�Ӽ� ��ֵ��ƫ mg
global Para_Acc_BiasConst_X Para_Acc_BiasConst_Y Para_Acc_BiasConst_Z
global Para_Acc_Calibration_6Local

f = [mean(IMU(1:Num,2))-Para_Acc_BiasConst_X;
    mean(IMU(1:Num,3))-Para_Acc_BiasConst_Y;
    mean(IMU(1:Num,4))-Para_Acc_BiasConst_Z;];   %��λg
f = Para_Acc_Calibration_6Local * [f;1];  %��װ���У��
[Start_Pitch,Start_Roll] = Att_Accel2Att(f(1,1),f(2,1),f(3,1));
Pitch = Start_Pitch*180/pi;
Roll = Start_Roll*180/pi;
%��ʾ�趨
set(handles.edit_Start_Pitch,'String',num2str(Pitch,8));
set(handles.edit_Start_Roll,'String',num2str(Roll,8));


% --- Executes on button press in pushbutton_GetInitAtt_3.
function pushbutton_GetInitAtt_3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_GetInitAtt_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%���ó�ʼ��ֹ״̬�µļ��ٶ� �� ��ǿ����⺽���
global Start_Yaw
%�ж�ʹ�þ�ֹ״̬��ʱ�䳤��
global DataPath 
global Hz
if isempty(DataPath)
    msgbox('����������·����');
    return;
end
%��ȡ����
load(DataPath);
%�ж��Ƿ���ڲ�̬��Ϣ����
if exist('FootPres_State','var')
    Num = 1;
    while FootPres_State(Num,2)
        Num = Num+1;
    end
    Num = Num-1;
    if Num > 0
        msgbox(strcat('ȡǰ�漸��λ��ƽ����',num2str(ceil(Num/Hz))));
    else
        msgbox('��ʼ״̬Ϊ��̬���޷�ˮƽ����׼��');
        return;        
    end
else
    msgbox('ȱ�ٲ�̬��Ϣ');
    return;
end

%ȡǰ��ֹ״̬���ݽ��г�ʼˮƽ��̬����ȡ
%�Ӽ� ��ֵ��ƫ mg
global Para_Acc_BiasConst_X Para_Acc_BiasConst_Y Para_Acc_BiasConst_Z
global Para_Acc_Calibration_6Local

f = [mean(IMU(1:Num,2))-Para_Acc_BiasConst_X;
    mean(IMU(1:Num,3))-Para_Acc_BiasConst_Y;
    mean(IMU(1:Num,4))-Para_Acc_BiasConst_Z;];   %��λg
f = Para_Acc_Calibration_6Local * [f;1];  %��װ���У��
[Pitch,Roll] = Att_Accel2Att(f(1,1),f(2,1),f(3,1));

%��ȡ ��ǿ�Ƶľ�ֵ����������ԲУ׼
if (ceil(Num/2)-1) <= 0
    msgbox('ȱ�پ�̬��ǿ�����ݣ�');
    return;
end
Mag = [mean(Magnetic(1:ceil(Num/2)-1,2));mean(Magnetic(1:ceil(Num/2)-1,3));mean(Magnetic(1:ceil(Num/2)-1,4))]; 
Att = [Pitch;Roll;0];
C_b_n = Att_Euler2DCM(Att);
Mag = C_b_n*Mag;
global Para_Calebrat_Mag_2D_A22 Para_Calebrat_Mag_2D_B21
if Para_Calebrat_Mag_2D_A22(1,1)==1 && Para_Calebrat_Mag_2D_A22(1,2)==0
    msgbox('��ǿ��δУ׼��');
end
Mag_Calibrate = Para_Calebrat_Mag_2D_A22*Mag(1:2,1) + Para_Calebrat_Mag_2D_B21;
Start_Yaw = Att_Mag2Yaw(0,0,Mag_Calibrate(1,1),Mag_Calibrate(2,1),0);

%��ʾ�趨
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

%���� ��ֵ��ƫ ��/h
global Para_Gyro_BiasConst_X Para_Gyro_BiasConst_Y Para_Gyro_BiasConst_Z
%���� ��ƫ�ȶ��� ��/h
global Para_Gyro_BiasStab_X Para_Gyro_BiasStab_Y Para_Gyro_BiasStab_Z
%���� �Ƕ�������� ��/h-1/2
global Para_Gyro_ARW_X Para_Gyro_ARW_Y Para_Gyro_ARW_Z
%�Ӽ� ��ֵ��ƫ mg
global Para_Acc_BiasConst_X Para_Acc_BiasConst_Y Para_Acc_BiasConst_Z
%�Ӽ� ��ƫ�ȶ��� mg
global Para_Acc_BiasStab_X Para_Acc_BiasStab_Y Para_Acc_BiasStab_Z
%�Ӽ� �ٶ�������� 
global Para_Acc_VRW_X Para_Acc_VRW_Y Para_Acc_VRW_Z
%�Ӽư�װ���� �任����
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
        % ��װ���
        Para_Acc_Calibration_6Local = [1.000264037	-0.00004585	-0.006794537 -0.010055843;
                                        -0.0051893  0.99927623	0.01848056  0.03118094;
                                        0.024396733	-0.00342088	0.998533567	-0.033433563];
        %����������ʾ����
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
        % ��װ���
        Para_Acc_Calibration_6Local = [1.0000878	-0.00043916	-0.024920843 -0.034663453;
                                        0.001574943	1.00120647 	-0.004760667 0.020979463;
                                        0.047300417	0.00194185 	0.998779413 -0.012164637];   
        %����������ʾ����
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
        % �������Բ���
        Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
        Para_Gyro_BiasStab_X = 0; Para_Gyro_BiasStab_Y = 0; Para_Gyro_BiasStab_Z = 0; 
        Para_Gyro_ARW_X = 0; Para_Gyro_ARW_Y = 0; Para_Gyro_ARW_Z = 0;
        Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0;
        Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
        Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;     
        % ��װ���
        Para_Acc_Calibration_6Local = zeros(3,3);   
        %����������ʾ����
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
         % �������Բ���
        Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
        Para_Gyro_BiasStab_X = 0; Para_Gyro_BiasStab_Y = 0; Para_Gyro_BiasStab_Z = 0; 
        Para_Gyro_ARW_X = 0; Para_Gyro_ARW_Y = 0; Para_Gyro_ARW_Z = 0;
        Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0;
        Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
        Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;     
        % ��װ���
        Para_Acc_Calibration_6Local = zeros(3,3);   
        %����������ʾ����
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
         % �������Բ���
        Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
        Para_Gyro_BiasStab_X = 0; Para_Gyro_BiasStab_Y = 0; Para_Gyro_BiasStab_Z = 0; 
        Para_Gyro_ARW_X = 0; Para_Gyro_ARW_Y = 0; Para_Gyro_ARW_Z = 0;
        Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0;
        Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
        Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;     
        % ��װ���
        Para_Acc_Calibration_6Local = zeros(3,3);   
        %����������ʾ����
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
        % �������Բ���
        Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
        Para_Gyro_BiasStab_X = 0; Para_Gyro_BiasStab_Y = 0; Para_Gyro_BiasStab_Z = 0; 
        Para_Gyro_ARW_X = 0; Para_Gyro_ARW_Y = 0; Para_Gyro_ARW_Z = 0;
        Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0;
        Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
        Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;     
        % ��װ���
        Para_Acc_Calibration_6Local = zeros(3,3);   
        %����������ʾ����
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
        % �������Բ���
        Para_Gyro_BiasConst_X = 0; Para_Gyro_BiasConst_Y = 0; Para_Gyro_BiasConst_Z = 0; 
        Para_Gyro_BiasStab_X = 0; Para_Gyro_BiasStab_Y = 0; Para_Gyro_BiasStab_Z = 0; 
        Para_Gyro_ARW_X = 0; Para_Gyro_ARW_Y = 0; Para_Gyro_ARW_Z = 0;
        Para_Acc_BiasConst_X = 0; Para_Acc_BiasConst_Y = 0; Para_Acc_BiasConst_Z = 0;
        Para_Acc_BiasStab_X = 0; Para_Acc_BiasStab_Y = 0; Para_Acc_BiasStab_Z = 0;
        Para_Acc_VRW_X = 0; Para_Acc_VRW_Y = 0; Para_Acc_VRW_Z = 0;     
        % ��װ���
        Para_Acc_Calibration_6Local = zeros(3,3);   
        %����������ʾ����
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
   %·��Ϊ��
   disp('���棺****δѡ���ǿ����ԲУ׼����*****');
   return;
end

% 1. ��ȡ����
load([FilePath,FileName]);
if (~exist('IMU','var') || ~exist('Magnetic','var') || ~exist('FootPres_State','var'))   
    disp('����:δ��ȡ��IMU or ��ǿ�� or ѹ��״̬ ���ݣ�')
    return;
end

% 2. ���������жϽ���������ݷֶΣ���ȡ��ͬ��ֹʱ�ε� ��ʼ����ֹ�ڵ�
L = length(FootPres_State);
j = 1;
TStart = 0;  %�ж��Ƿ���뾲ֹ�׶�
for i = 1:L
    %��һ������ж�
    if i == 1
        if FootPres_State(1,2) == 1
            TStart = 1;  %���뾲ֹ�׶�
            StaticRecord(1,1) = 1;
        end
    else
        if FootPres_State(i,2) ~= FootPres_State(i-1,2)
           % ״̬�����仯
           if FootPres_State(i-1,2) == 1
              % ����β��
              StaticRecord(j,2) = i;
              j = j+1;
           else
              % ��ʱ�εĿ�ʼ
              StaticRecord(j,1) = i;
           end
        end
    end  
end
% ���ӽ�β�ж�
if StaticRecord(j,2) == 0
    StaticRecord(j,2) = L;
end

% 3. ���÷ֶξ�ֹ���ݽ��д�ǿ��У׼��������
% 3.1 �ֶλ�ȡ�Ӽƺʹ�ǿ�� ��ֹʱ�����������ľ�ֵ
global Para_Acc_Calibration_6Local
L = length(StaticRecord);
Mean_Acc = zeros(L,3);
Mean_Mag = zeros(L,3);
for i = 1:L
    Mean_Acc(i,:) = mean(IMU(StaticRecord(i,1):StaticRecord(i,2),2:4));
    Mean_Mag(i,:) = mean(Magnetic(ceil(StaticRecord(i,1)/2):ceil(StaticRecord(i,2)/2-1),2:4));
end

% 3.2 �Ƚ��Ӽƽ���У׼��Ȼ�����ˮƽ��̬����ȡ
Mean_Acc_Calibrat = zeros(L,3);
Mean_Att_Calibrat = zeros(L,3);
for i = 1:L
    Mean_Acc_Calibrat(i,:) = (Para_Acc_Calibration_6Local * [Mean_Acc(i,:),1]')';  
    [Mean_Att_Calibrat(i,1),Mean_Att_Calibrat(i,2)] = Att_Accel2Att(Mean_Acc_Calibrat(i,1),Mean_Acc_Calibrat(i,2),Mean_Acc_Calibrat(i,3));     
end

% 3.3 ����ǿ�Ƶ����ݽ���ˮƽ��ͶӰ
Mean_Mag_Level = zeros(L,3);
for i = 1:L
    C_b_n = Att_Euler2DCM(Mean_Att_Calibrat(i,:)');
    Mag = C_b_n*[Mean_Mag(i,:)'];
    Mean_Mag_Level(i,:) = Mag'; 
end

% 3.4 ��ȡ��ǿ����Բ�����������
[A22,B21] = Calibration_Mag_2D(Mean_Mag_Level);

% 3.5 ����У׼�����ת��ǿ������
Mean_Mag_Calibrat = zeros(L,2);
for i = 1:L
    Mean_Mag_Calibrat(i,1:2) = ((A22*Mean_Mag_Level(i,1:2)') - B21)';
end

% 3.5 ���ƱȽ�ͼ��
figure;
plot(Mean_Mag(:,1),Mean_Mag(:,2),'*-'); grid on; 
hold on; plot(0,0,'ro');
hold on; plot(Mean_Mag_Calibrat(:,1),Mean_Mag_Calibrat(:,2),'r*-');

% 3.6 ������ȡ���Ƚ�
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

% 4. У׼�������漰��ʾ
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
%% ---------����1����ͨ�ߵ�����   ���������� Result_1
%   �洢����ϢΪ ʱ�� ��̬(��) �ٶ�(m/s) λ��(γ�� ���� �߳� /�� /m) 

% 1.��ȡ����
    global DataPath 
    load(DataPath);
    if (~exist('IMU','var') || ~exist('FootPres_State','var'))   
        disp('����:δ��ȡ��IMU or ѹ��״̬ ���ݣ�')
        return;
    end

% 2.�趨��ʼ״̬ ��̬ �ٶ� λ��
    global Start_Pitch Start_Roll Start_Yaw
    Start_Att = [Start_Pitch;Start_Roll;Start_Yaw]; 
    Start_Vel = zeros(3,1);
    global Start_Lat Start_Lon Start_High
    Start_Pos = [Start_Lat;Start_Lon;Start_High];

% 3.�����趨
    % 3.1 ϵͳ���� ��У���� ȫ�ֲ���
        global Hz Para_Acc_Calibration_6Local
        Ts = 1/Hz;
        G_Const = CONST_Init();
        M_a = Para_Acc_Calibration_6Local;
    % 3.2 �����ռ�����
        L = length(IMU);
        AVP = zeros(L,10);
        
    % 3.3 �������� 
        %(1) ���þ�ֹ״̬���ݻ�ȡ���������ƫ��ֵ
            %�ж��Ƿ���ڲ�̬��Ϣ����
            if exist('FootPres_State','var')
                Num = 1;
                while FootPres_State(Num,2)
                    Num = Num+1;
                end
                Num = Num-1;
                if Num > 0
                    msgbox(strcat('ȡǰ�漸��λ��ƽ����',num2str(ceil(Num/Hz))));
                else
                    msgbox('��ʼ״̬Ϊ��̬���޷���ȡ��ʼ������ƫ��');
                    return;        
                end
            else
                msgbox('ȱ�ٲ�̬��Ϣ');
                return;
            end
            %��ȡ���������ƫ
            Gyro_Bias = [mean(IMU(1:Num,5));mean(IMU(1:Num,6));mean(IMU(1:Num,7))];
        %(2) �Ӽ���ƫ���ƻ�δʵ�֣���ʱΪ0
            Acc_Bias = [0;0;0];
            
    % 3.4 �ߵ������ʼ��             
        %(1)�ߵ�����ṹ���ʼ�� 
        INSData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
        INSData_Pre = INSData_Now;        
        
% 4.ѭ����������
    for i = 1:L
        %(1)��ȡIMUԭʼ����
        INSData_Now.time = IMU(i,1);    
        INSData_Now.w_ib_b = IMU(i,5:7)';   %����          
        INSData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %�Ӽ� 
        
        %(2)���ݺͼӼ� ԭʼ��������
        %�Ӽ����� (�˴��������ӼƵģ���Ϊ6λ�÷���У׼�ӼƵķ�����)������������飬ͬʱ�������ݵ��Ƿ���Ч����        
        INSData_Now.f_ib_b = M_a*[INSData_Now.f_ib_b;1];
        %������ƫ����
        INSData_Now.w_ib_b = INSData_Now.w_ib_b - INSData_Now.eb;
        
        %(3)�ߵ�����
        INSData_Now = INS_Update(G_Const,INSData_Pre,INSData_Now,Ts);             
            
        %(4)���浼�����
        AVP(i,1) = INSData_Now.time;      
        AVP(i,2:4) = INSData_Now.att';
        AVP(i,5:7) = INSData_Now.vel';
        AVP(i,8:10) = INSData_Now.pos';     
        
        %(5)���µ�������
        INSData_Pre =  INSData_Now;        
    end

% 5.���浼�����    
    Result_1 = zeros(L,10); 
    Result_1(:,1) = AVP(:,1); %ʱ��
    Result_1(:,2:3) = AVP(:,2:3); %��̬
    Result_1(:,4) = -AVP(:,4); %��̬
    Result_1(:,5:7) = AVP(:,5:7); %�ٶ�
    Result_1(:,8:10) = AVP(:,8:10); %γ�� ���� �߳�    
    Plot_AVP_Group(Result_1);    
    save(DataPath,'Result_1','-append');
  

% --- Executes on button press in pushbutton_Nav_Method_2.
function pushbutton_Nav_Method_2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Nav_Method_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ---------����2��ZUPT���� ��ͨ��0   ���������� Result_2
% 1.��ȡ����
    global DataPath 
    load(DataPath);
    if (~exist('IMU','var') || ~exist('FootPres_State','var'))   
        disp('����:δ��ȡ��IMU or ѹ��״̬ ���ݣ�')
        return;
    end

% 2.�趨��ʼ״̬ ��̬ �ٶ� λ��
    global Start_Pitch Start_Roll Start_Yaw
    Start_Att = [Start_Pitch;Start_Roll;Start_Yaw]; 
    Start_Vel = zeros(3,1);
    global Start_Lat Start_Lon Start_High
    Start_Pos = [Start_Lat;Start_Lon;Start_High];

% 3.�����趨
    % 3.1 ϵͳ���� ��У���� ȫ�ֲ���
        global Hz Para_Acc_Calibration_6Local
        Ts = 1/Hz;
        G_Const = CONST_Init();
        M_a = Para_Acc_Calibration_6Local;
    % 3.2 �����ռ�����
        L = length(IMU);
        AVP = zeros(L,10);
        
    % 3.3 �������� 
        %(1) ���þ�ֹ״̬���ݻ�ȡ���������ƫ��ֵ
            %�ж��Ƿ���ڲ�̬��Ϣ����
            if exist('FootPres_State','var')
                Num = 1;
                while FootPres_State(Num,2)
                    Num = Num+1;
                end
                Num = Num-1;
                if Num > 0
                    msgbox(strcat('ȡǰ�漸��λ��ƽ����',num2str(ceil(Num/Hz))));
                else
                    msgbox('��ʼ״̬Ϊ��̬���޷���ȡ��ʼ������ƫ��');
                    return;        
                end
            else
                msgbox('ȱ�ٲ�̬��Ϣ');
                return;
            end
            %��ȡ���������ƫ
            Gyro_Bias = [mean(IMU(1:Num,5));mean(IMU(1:Num,6));mean(IMU(1:Num,7))];
        %(2) �Ӽ���ƫ���ƻ�δʵ�֣���ʱΪ0
            Acc_Bias = [0;0;0];
            
    % 3.4 �ߵ������ʼ��             
        %(1)�ߵ�����ṹ���ʼ�� 
        INSData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
        INSData_Pre = INSData_Now;        
        
% 4.ѭ����������
    for i = 1:L
        %(1)��ȡIMUԭʼ����
        INSData_Now.time = IMU(i,1);    
        INSData_Now.w_ib_b = IMU(i,5:7)';   %����          
        INSData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %�Ӽ� 
        
        %(2)���ݺͼӼ� ԭʼ��������
        %�Ӽ����� (�˴��������ӼƵģ���Ϊ6λ�÷���У׼�ӼƵķ�����)������������飬ͬʱ�������ݵ��Ƿ���Ч����        
        INSData_Now.f_ib_b = M_a*[INSData_Now.f_ib_b;1];
        %������ƫ����
        INSData_Now.w_ib_b = INSData_Now.w_ib_b - INSData_Now.eb;
        
        %(3)�ߵ�����
        %��������״̬������ͨ��0������̬������һ�̲��䣬�ٶ���0��λ�ñ�����һ�̲���
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
            
        %(4)���浼�����
        AVP(i,1) = INSData_Now.time;      
        AVP(i,2:4) = INSData_Now.att';
        AVP(i,5:7) = INSData_Now.vel';
        AVP(i,8:10) = INSData_Now.pos';     
        
        %(5)���µ�������
        INSData_Pre =  INSData_Now;        
    end

% 5.���浼�����    
    Result_2 = zeros(L,10); 
    Result_2(:,1) = AVP(:,1); %ʱ��
    Result_2(:,2:3) = AVP(:,2:3); %��̬
    Result_2(:,4) = -AVP(:,4); %��̬
    Result_2(:,5:7) = AVP(:,5:7); %�ٶ�
    Result_2(:,8:10) = AVP(:,8:10); %γ�� ���� �߳�    
    Plot_AVP_Group(Result_2);    
    save(DataPath,'Result_2','-append');


% --- Executes on button press in pushbutton_Nav_Method_3.
function pushbutton_Nav_Method_3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Nav_Method_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ---------����3��ZUPT���� ˮƽ��̬����   ���������� Result_3
% 1.��ȡ����
    global DataPath 
    load(DataPath);
    if (~exist('IMU','var') || ~exist('FootPres_State','var'))   
        disp('����:δ��ȡ��IMU or ѹ��״̬ ���ݣ�')
        return;
    end

% 2.�趨��ʼ״̬ ��̬ �ٶ� λ��
    global Start_Pitch Start_Roll Start_Yaw
    Start_Att = [Start_Pitch;Start_Roll;Start_Yaw]; 
    Start_Vel = zeros(3,1);
    global Start_Lat Start_Lon Start_High
    Start_Pos = [Start_Lat;Start_Lon;Start_High];

% 3.�����趨
    % 3.1 ϵͳ���� ��У���� ȫ�ֲ���
        global Hz Para_Acc_Calibration_6Local
        Ts = 1/Hz;
        G_Const = CONST_Init();
        M_a = Para_Acc_Calibration_6Local;
    % 3.2 �����ռ�����
        L = length(IMU);
        AVP = zeros(L,10);
        
    % 3.3 �������� 
        %(1) ���þ�ֹ״̬���ݻ�ȡ���������ƫ��ֵ
            %�ж��Ƿ���ڲ�̬��Ϣ����
            if exist('FootPres_State','var')
                Num = 1;
                while FootPres_State(Num,2)
                    Num = Num+1;
                end
                Num = Num-1;
                if Num > 0
                    msgbox(strcat('ȡǰ�漸��λ��ƽ����',num2str(ceil(Num/Hz))));
                else
                    msgbox('��ʼ״̬Ϊ��̬���޷���ȡ��ʼ������ƫ��');
                    return;        
                end
            else
                msgbox('ȱ�ٲ�̬��Ϣ');
                return;
            end
            %��ȡ���������ƫ
            Gyro_Bias = [mean(IMU(1:Num,5));mean(IMU(1:Num,6));mean(IMU(1:Num,7))];
        %(2) �Ӽ���ƫ���ƻ�δʵ�֣���ʱΪ0
            Acc_Bias = [0;0;0];
            
    % 3.4 �ߵ������ʼ��             
        %(1)�ߵ�����ṹ���ʼ�� 
        INSData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
        INSData_Pre = INSData_Now;        
        
% 4.ѭ����������
Static_State = 0;  %��ʶ�Ƿ���뾲ֹ״̬
    for i = 1:L
        %(1)��ȡIMUԭʼ����
        INSData_Now.time = IMU(i,1);    
        INSData_Now.w_ib_b = IMU(i,5:7)';   %����          
        INSData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %�Ӽ� 
        
        %(2)���ݺͼӼ� ԭʼ��������
        %�Ӽ����� (�˴��������ӼƵģ���Ϊ6λ�÷���У׼�ӼƵķ�����)������������飬ͬʱ�������ݵ��Ƿ���Ч����        
        INSData_Now.f_ib_b = M_a*[INSData_Now.f_ib_b;1];
        %������ƫ����
        INSData_Now.w_ib_b = INSData_Now.w_ib_b - INSData_Now.eb;
        
        %(3)�ߵ�����
        %��������״̬������ͨ��0������̬������һ�̲��䣬�ٶ���0��λ�ñ�����һ�̲���
        if FootPres_State(i,2) == 1
            if Static_State == 0
                %�ս��뾲ֹ״̬
                n = 0;
                Acc_mean = [0;0;0];   
                Static_State = 1;
            end
            %�Ӽ���ȡ�ۼ�ƽ��
            Acc_mean = Acc_mean.*(n/(n+1)) + INSData_Now.f_ib_b./(n+1);
            n = n+1;
            %���üӼ�ƽ��ֵ��ȡˮƽ��̬��
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
            
        %(4)���浼�����
        AVP(i,1) = INSData_Now.time;      
        AVP(i,2:4) = INSData_Now.att';
        AVP(i,5:7) = INSData_Now.vel';
        AVP(i,8:10) = INSData_Now.pos';     
        
        %(5)���µ�������
        INSData_Pre =  INSData_Now;        
    end

% 5.���浼�����    
    Result_3 = zeros(L,10); 
    Result_3(:,1) = AVP(:,1); %ʱ��
    Result_3(:,2:3) = AVP(:,2:3); %��̬
    Result_3(:,4) = -AVP(:,4); %��̬
    Result_3(:,5:7) = AVP(:,5:7); %�ٶ�
    Result_3(:,8:10) = AVP(:,8:10); %γ�� ���� �߳�    
    Plot_AVP_Group(Result_3);    
    save(DataPath,'Result_3','-append');


% --- Executes on button press in pushbutton_Nav_Method_4.
function pushbutton_Nav_Method_4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Nav_Method_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ---------����4��ZUPT���� ˮƽ��̬����+�����ǿ������  ���������� Result_4
% 1.��ȡ����
    global DataPath 
    load(DataPath);
    if (~exist('IMU','var') || ~exist('FootPres_State','var'))   
        disp('����:δ��ȡ��IMU or ѹ��״̬ ���ݣ�')
        return;
    end

% 2.�趨��ʼ״̬ ��̬ �ٶ� λ��
    global Start_Pitch Start_Roll Start_Yaw
    Start_Att = [Start_Pitch;Start_Roll;Start_Yaw]; 
    Start_Vel = zeros(3,1);
    global Start_Lat Start_Lon Start_High
    Start_Pos = [Start_Lat;Start_Lon;Start_High];

% 3.�����趨
    % 3.1 ϵͳ���� ��У���� ȫ�ֲ���
        global Hz Para_Acc_Calibration_6Local
        global Para_Calebrat_Mag_2D_A22 Para_Calebrat_Mag_2D_B21
        Ts = 1/Hz;
        G_Const = CONST_Init();
        M_a = Para_Acc_Calibration_6Local;
    % 3.2 �����ռ�����
        L = length(IMU)-1;
        AVP = zeros(L,10);
        
    % 3.3 �������� 
        %(1) ���þ�ֹ״̬���ݻ�ȡ���������ƫ��ֵ
            %�ж��Ƿ���ڲ�̬��Ϣ����
            if exist('FootPres_State','var')
                Num = 1;
                while FootPres_State(Num,2)
                    Num = Num+1;
                end
                Num = Num-1;
                if Num > 0
                    msgbox(strcat('ȡǰ�漸��λ��ƽ����',num2str(ceil(Num/Hz))));
                else
                    msgbox('��ʼ״̬Ϊ��̬���޷���ȡ��ʼ������ƫ��');
                    return;        
                end
            else
                msgbox('ȱ�ٲ�̬��Ϣ');
                return;
            end
            %��ȡ���������ƫ
            Gyro_Bias = [mean(IMU(1:Num,5));mean(IMU(1:Num,6));mean(IMU(1:Num,7))];
        %(2) �Ӽ���ƫ���ƻ�δʵ�֣���ʱΪ0
            Acc_Bias = [0;0;0];
            
    % 3.4 �ߵ������ʼ��             
        %(1)�ߵ�����ṹ���ʼ�� 
        INSData_Now = INS_DataInit(G_Const,IMU(1,1),Start_Att,Start_Vel,Start_Pos,Gyro_Bias,Acc_Bias,Ts);
        INSData_Pre = INSData_Now;        
        
% 4.ѭ����������
Static_State = 0;  %��ʶ�Ƿ���뾲ֹ״̬
    for i = 1:L
        %(1)��ȡIMUԭʼ����
        INSData_Now.time = IMU(i,1);    
        INSData_Now.w_ib_b = IMU(i,5:7)';   %����          
        INSData_Now.f_ib_b = IMU(i,2:4)'.*(G_Const.g0);   %�Ӽ� 
        
        %(2)���ݺͼӼ� ԭʼ��������
        %�Ӽ����� (�˴��������ӼƵģ���Ϊ6λ�÷���У׼�ӼƵķ�����)������������飬ͬʱ�������ݵ��Ƿ���Ч����        
        INSData_Now.f_ib_b = M_a*[INSData_Now.f_ib_b;1];
        %������ƫ����
        INSData_Now.w_ib_b = INSData_Now.w_ib_b - INSData_Now.eb;
        
        %(3)�ߵ�����
        %��������״̬������ͨ��0������̬������һ�̲��䣬�ٶ���0��λ�ñ�����һ�̲���
        if FootPres_State(i,2) == 1
            if Static_State == 0
                %�ս��뾲ֹ״̬
                n = 0;
                Acc_mean = [0;0;0];   
                Mag_mean = [0;0;0];   
                Static_State = 1;
            end
            %�Ӽ���ȡ�ۼ�ƽ��
            Acc_mean = Acc_mean.*(n/(n+1)) + INSData_Now.f_ib_b./(n+1);
            Mag_mean = Mag_mean.*(n/(n+1)) + (Magnetic(ceil(i/2),2:4))'./(n+1);
            n = n+1;
            %���üӼ�ƽ��ֵ��ȡˮƽ��̬��
            [pitch,roll] = Att_Accel2Att(Acc_mean(1,1),Acc_mean(2,1),Acc_mean(3,1));
            %���ô�ǿ��ƽ��ֵ��ȡ�����            
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
            
        %(4)���浼�����
        AVP(i,1) = INSData_Now.time;      
        AVP(i,2:4) = INSData_Now.att';
        AVP(i,5:7) = INSData_Now.vel';
        AVP(i,8:10) = INSData_Now.pos';     
        
        %(5)���µ�������
        INSData_Pre =  INSData_Now;        
    end

% 5.���浼�����    
    Result_4 = zeros(L,10); 
    Result_4(:,1) = AVP(:,1); %ʱ��
    Result_4(:,2:3) = AVP(:,2:3); %��̬
    Result_4(:,4) = -AVP(:,4); %��̬
    Result_4(:,5:7) = AVP(:,5:7); %�ٶ�
    Result_4(:,8:10) = AVP(:,8:10); %γ�� ���� �߳�    
    Plot_AVP_Group(Result_4);    
    save(DataPath,'Result_4','-append');
