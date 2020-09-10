function varargout = PedestrainNavigation_Calibration(varargin)
% PEDESTRAINNAVIGATION_CALIBRATION MATLAB code for PedestrainNavigation_Calibration.fig
%      PEDESTRAINNAVIGATION_CALIBRATION, by itself, creates a new PEDESTRAINNAVIGATION_CALIBRATION or raises the existing
%      singleton*.
%
%      H = PEDESTRAINNAVIGATION_CALIBRATION returns the handle to a new PEDESTRAINNAVIGATION_CALIBRATION or the handle to
%      the existing singleton*.
%
%      PEDESTRAINNAVIGATION_CALIBRATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PEDESTRAINNAVIGATION_CALIBRATION.M with the given input arguments.
%
%      PEDESTRAINNAVIGATION_CALIBRATION('Property','Value',...) creates a new PEDESTRAINNAVIGATION_CALIBRATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PedestrainNavigation_Calibration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PedestrainNavigation_Calibration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PedestrainNavigation_Calibration

% Last Modified by GUIDE v2.5 14-Jan-2020 20:29:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PedestrainNavigation_Calibration_OpeningFcn, ...
                   'gui_OutputFcn',  @PedestrainNavigation_Calibration_OutputFcn, ...
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


% --- Executes just before PedestrainNavigation_Calibration is made visible.
function PedestrainNavigation_Calibration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PedestrainNavigation_Calibration (see VARARGIN)

% Choose default command line output for PedestrainNavigation_Calibration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%===========================全局变量设定=====================================
%================器件特性参数分析相关 
global DataPath_Allon 
DataPath_Allon = []; 
global Hz Allon_Group_Interval
Hz = 200; Allon_Group_Interval = 10;   %为避免Allon计算时间太长，将采样评率平均

global Allon_Analy_StartMinute Allon_Analy_UsedMinute
Allon_Analy_StartMinute = 0; Allon_Analy_UsedMinute = 0;
%================6位置法安装误差分析数据存放路径 
global DataPath_Calibration_6 
DataPath_Calibration_6 = []; 
%================6位置法 位置参数 
global Pos_Lat Pos_Lon Pos_High 
Pos_Lat=0; Pos_Lon=0; Pos_High=0; 
%================6位置法 时间切割设置参数
global NumSet_X_Up_Start NumSet_X_Up_End NumSet_X_Down_Start NumSet_X_Down_End
global NumSet_Y_Up_Start NumSet_Y_Up_End NumSet_Y_Down_Start NumSet_Y_Down_End
global NumSet_Z_Up_Start NumSet_Z_Up_End NumSet_Z_Down_Start NumSet_Z_Down_End
NumSet_X_Up_Start=0; NumSet_X_Up_End=0; NumSet_X_Down_Start=0; NumSet_X_Down_End=0;
NumSet_Y_Up_Start=0; NumSet_Y_Up_End=0; NumSet_Y_Down_Start=0; NumSet_Y_Down_End=0;
NumSet_Z_Up_Start=0; NumSet_Z_Up_End=0; NumSet_Z_Down_Start=0; NumSet_Z_Down_End=0;

% UIWAIT makes PedestrainNavigation_Calibration wait for user response (see UIRESUME)
% uiwait(handles.figure1);





% --- Outputs from this function are returned to the command line.
function varargout = PedestrainNavigation_Calibration_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_OpenData_Allon.
function pushbutton_OpenData_Allon_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OpenData_Allon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataPath_Allon 
[FileName,FilePath] = uigetfile('*.mat');
if isequal(FileName,0)
   msgbox('请输入Allon分析采集数据路径！');
else
    DataPath_Allon = strcat(FilePath,FileName);
    set(handles.edit_DataPath_Allon,'string',DataPath_Allon);
end


function edit_DataPath_Allon_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DataPath_Allon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DataPath_Allon as text
%        str2double(get(hObject,'String')) returns contents of edit_DataPath_Allon as a double


% --- Executes during object creation, after setting all properties.
function edit_DataPath_Allon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DataPath_Allon (see GCBO)
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



function edit_Gyro_Bias_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Gyro_Bias_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Gyro_Bias_X as text
%        str2double(get(hObject,'String')) returns contents of edit_Gyro_Bias_X as a double


% --- Executes during object creation, after setting all properties.
function edit_Gyro_Bias_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Gyro_Bias_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Gyro_Bias_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Gyro_Bias_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Gyro_Bias_Y as text
%        str2double(get(hObject,'String')) returns contents of edit_Gyro_Bias_Y as a double


% --- Executes during object creation, after setting all properties.
function edit_Gyro_Bias_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Gyro_Bias_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Gyro_Bias_Z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Gyro_Bias_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Gyro_Bias_Z as text
%        str2double(get(hObject,'String')) returns contents of edit_Gyro_Bias_Z as a double


% --- Executes during object creation, after setting all properties.
function edit_Gyro_Bias_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Gyro_Bias_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Gyro_ARW_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Gyro_ARW_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Gyro_ARW_X as text
%        str2double(get(hObject,'String')) returns contents of edit_Gyro_ARW_X as a double


% --- Executes during object creation, after setting all properties.
function edit_Gyro_ARW_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Gyro_ARW_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Gyro_ARW_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Gyro_ARW_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Gyro_ARW_Y as text
%        str2double(get(hObject,'String')) returns contents of edit_Gyro_ARW_Y as a double


% --- Executes during object creation, after setting all properties.
function edit_Gyro_ARW_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Gyro_ARW_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Gyro_ARW_Z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Gyro_ARW_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Gyro_ARW_Z as text
%        str2double(get(hObject,'String')) returns contents of edit_Gyro_ARW_Z as a double


% --- Executes during object creation, after setting all properties.
function edit_Gyro_ARW_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Gyro_ARW_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Acc_Bias_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Acc_Bias_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Acc_Bias_X as text
%        str2double(get(hObject,'String')) returns contents of edit_Acc_Bias_X as a double


% --- Executes during object creation, after setting all properties.
function edit_Acc_Bias_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Acc_Bias_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Acc_Bias_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Acc_Bias_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Acc_Bias_Y as text
%        str2double(get(hObject,'String')) returns contents of edit_Acc_Bias_Y as a double


% --- Executes during object creation, after setting all properties.
function edit_Acc_Bias_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Acc_Bias_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Acc_Bias_Z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Acc_Bias_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Acc_Bias_Z as text
%        str2double(get(hObject,'String')) returns contents of edit_Acc_Bias_Z as a double


% --- Executes during object creation, after setting all properties.
function edit_Acc_Bias_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Acc_Bias_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Acc_VRW_X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Acc_VRW_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Acc_VRW_X as text
%        str2double(get(hObject,'String')) returns contents of edit_Acc_VRW_X as a double


% --- Executes during object creation, after setting all properties.
function edit_Acc_VRW_X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Acc_VRW_X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Acc_VRW_Y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Acc_VRW_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Acc_VRW_Y as text
%        str2double(get(hObject,'String')) returns contents of edit_Acc_VRW_Y as a double


% --- Executes during object creation, after setting all properties.
function edit_Acc_VRW_Y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Acc_VRW_Y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Acc_VRW_Z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Acc_VRW_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Acc_VRW_Z as text
%        str2double(get(hObject,'String')) returns contents of edit_Acc_VRW_Z as a double


% --- Executes during object creation, after setting all properties.
function edit_Acc_VRW_Z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Acc_VRW_Z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_OpenData_Calibration_6.
function pushbutton_OpenData_Calibration_6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OpenData_Calibration_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataPath_Calibration_6 
[FileName,FilePath] = uigetfile('*.mat');
if isequal(FileName,0)
   msgbox('请输入6位置法采集数据路径！');
   return;
else
    DataPath_Calibration_6 = strcat(FilePath,FileName);
    set(handles.edit_DataPath_Calibration_6,'string',DataPath_Calibration_6);
    load(DataPath_Calibration_6); 
    if exist('IMU','var')   %有IMU数据，则使用
        %绘制原始数据
        figure; plot(IMU(:,3),'k');  %加计x
        hold on; plot(IMU(:,4),'r');
        hold on; plot(IMU(:,5),'g');
        legend('X轴','Y轴','Z轴');
        xlabel('\it t \rm / s');  ylabel('\it m \rm / s2');
        title('三轴加计输出');   grid on; 
    else
        msgbox('IMU 数据不存在！');
        return;
    end
end


function edit_DataPath_Calibration_6_Callback(hObject, eventdata, handles)
% hObject    handle to edit_DataPath_Calibration_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_DataPath_Calibration_6 as text
%        str2double(get(hObject,'String')) returns contents of edit_DataPath_Calibration_6 as a double


% --- Executes during object creation, after setting all properties.
function edit_DataPath_Calibration_6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_DataPath_Calibration_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NumSet_X_Up_Start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_X_Up_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NumSet_X_Up_Start as text
%        str2double(get(hObject,'String')) returns contents of edit_NumSet_X_Up_Start as a double
global NumSet_X_Up_Start
NumSet_X_Up_Start = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_NumSet_X_Up_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_X_Up_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NumSet_X_Up_End_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_X_Up_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NumSet_X_Up_End as text
%        str2double(get(hObject,'String')) returns contents of edit_NumSet_X_Up_End as a double
global NumSet_X_Up_End
NumSet_X_Up_End = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_NumSet_X_Up_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_X_Up_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NumSet_X_Down_Start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_X_Down_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NumSet_X_Down_Start as text
%        str2double(get(hObject,'String')) returns contents of edit_NumSet_X_Down_Start as a double
global NumSet_X_Down_Start
NumSet_X_Down_Start = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_NumSet_X_Down_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_X_Down_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NumSet_X_Down_End_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_X_Down_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NumSet_X_Down_End as text
%        str2double(get(hObject,'String')) returns contents of edit_NumSet_X_Down_End as a double
global NumSet_X_Down_End
NumSet_X_Down_End = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_NumSet_X_Down_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_X_Down_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NumSet_Y_Up_Start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Y_Up_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NumSet_Y_Up_Start as text
%        str2double(get(hObject,'String')) returns contents of edit_NumSet_Y_Up_Start as a double
global NumSet_Y_Up_Start
NumSet_Y_Up_Start = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_NumSet_Y_Up_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Y_Up_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NumSet_Y_Up_End_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Y_Up_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NumSet_Y_Up_End as text
%        str2double(get(hObject,'String')) returns contents of edit_NumSet_Y_Up_End as a double
global NumSet_Y_Up_End
NumSet_Y_Up_End = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_NumSet_Y_Up_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Y_Up_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NumSet_Y_Down_Start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Y_Down_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NumSet_Y_Down_Start as text
%        str2double(get(hObject,'String')) returns contents of edit_NumSet_Y_Down_Start as a double
global NumSet_Y_Down_Start
NumSet_Y_Down_Start = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_NumSet_Y_Down_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Y_Down_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NumSet_Y_Down_End_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Y_Down_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NumSet_Y_Down_End as text
%        str2double(get(hObject,'String')) returns contents of edit_NumSet_Y_Down_End as a double
global NumSet_Y_Down_End
NumSet_Y_Down_End = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_NumSet_Y_Down_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Y_Down_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NumSet_Z_Up_Start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Z_Up_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NumSet_Z_Up_Start as text
%        str2double(get(hObject,'String')) returns contents of edit_NumSet_Z_Up_Start as a double
global NumSet_Z_Up_Start
NumSet_Z_Up_Start = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_NumSet_Z_Up_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Z_Up_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NumSet_Z_Up_End_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Z_Up_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NumSet_Z_Up_End as text
%        str2double(get(hObject,'String')) returns contents of edit_NumSet_Z_Up_End as a double
global NumSet_Z_Up_End
NumSet_Z_Up_End = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_NumSet_Z_Up_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Z_Up_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NumSet_Z_Down_Start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Z_Down_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NumSet_Z_Down_Start as text
%        str2double(get(hObject,'String')) returns contents of edit_NumSet_Z_Down_Start as a double
global NumSet_Z_Down_Start
NumSet_Z_Down_Start = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_NumSet_Z_Down_Start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Z_Down_Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NumSet_Z_Down_End_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Z_Down_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NumSet_Z_Down_End as text
%        str2double(get(hObject,'String')) returns contents of edit_NumSet_Z_Down_End as a double
global NumSet_Z_Down_End
NumSet_Z_Down_End = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_NumSet_Z_Down_End_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NumSet_Z_Down_End (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Calibration_6.
function pushbutton_Calibration_6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Calibration_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataPath_Calibration_6 
%读取数据

if isempty(DataPath_Calibration_6)
   msgbox('请输入6位置法采集数据路径！');
   return;
else
   load(DataPath_Calibration_6); 
end

%设定数据起始终止位置    
global NumSet_X_Up_Start NumSet_X_Up_End NumSet_X_Down_Start NumSet_X_Down_End
global NumSet_Y_Up_Start NumSet_Y_Up_End NumSet_Y_Down_Start NumSet_Y_Down_End
global NumSet_Z_Up_Start NumSet_Z_Up_End NumSet_Z_Down_Start NumSet_Z_Down_End   

% NumSet_X_Up_Start=14000; NumSet_X_Up_End=160000; NumSet_X_Down_Start=180000; NumSet_X_Down_End=322400;
% NumSet_Y_Up_Start=340000; NumSet_Y_Up_End=515100; NumSet_Y_Down_Start=533000; NumSet_Y_Down_End=698200;
% NumSet_Z_Up_Start=720000; NumSet_Z_Up_End=887200; NumSet_Z_Down_Start=900500; NumSet_Z_Down_End=1080400;

if ((NumSet_X_Up_Start==0)||(NumSet_X_Up_End==0)||(NumSet_X_Down_Start==0)||(NumSet_X_Down_End==0)||...
        (NumSet_Y_Up_Start==0)||(NumSet_Y_Up_End==0)||(NumSet_Y_Down_Start==0)||(NumSet_Y_Down_End==0)||...
        (NumSet_Z_Up_Start==0)||(NumSet_Z_Up_End==0)||(NumSet_Z_Down_Start==0)||(NumSet_Z_Down_End==0))
    msgbox('数据序号设定错误，不能为0！');
    return;
end
global Pos_Lat Pos_Lon Pos_High 
Pos_Lat=40.003575; Pos_Lon=116.337489; Pos_High=20; 
if ((Pos_Lat==0)||(Pos_Lon==0))
    msgbox('请输入位置信息！');
    return;
end

%6位置法 标定解算
%Temp_Pos = [40.003575*pi/180;116.337489*pi/180;20]; 
Temp_Pos = [Pos_Lat*pi/180;Pos_Lon*pi/180;Pos_High]; 
% 计算当地重力数值
G_Const = CONST_Init();
g_n = Earth_get_g_n(G_Const,Temp_Pos(1,1),Temp_Pos(3,1));
gn = -g_n(3,1);

%构造6次观测的观测量  gn 取 1，因为采集的原始数据单位换算为g
% a1=[gn;0;0;1];  a2=[-gn;0;0;1];
% a3=[0;gn;0;1];  a4=[0;-gn;0;1];
% a5=[0;0;gn;1];  a6=[0;0;-gn;1];
a1=[1;0;0;1];  a2=[-1;0;0;1];
a3=[0;1;0;1];  a4=[0;-1;0;1];
a5=[0;0;1;1];  a6=[0;0;-1;1];
A = [a1,a2,a3,a4,a5,a6];

%构造6次测量量
u1=[mean(IMU(NumSet_X_Up_Start:NumSet_X_Up_End,3));
    mean(IMU(NumSet_X_Up_Start:NumSet_X_Up_End,4));
    mean(IMU(NumSet_X_Up_Start:NumSet_X_Up_End,5))];
u2=[mean(IMU(NumSet_X_Down_Start:NumSet_X_Down_End,3));
    mean(IMU(NumSet_X_Down_Start:NumSet_X_Down_End,4));
    mean(IMU(NumSet_X_Down_Start:NumSet_X_Down_End,5))];
u3=[mean(IMU(NumSet_Y_Up_Start:NumSet_Y_Up_End,3));
    mean(IMU(NumSet_Y_Up_Start:NumSet_Y_Up_End,4));
    mean(IMU(NumSet_Y_Up_Start:NumSet_Y_Up_End,5))];
u4=[mean(IMU(NumSet_Y_Down_Start:NumSet_Y_Down_End,3));
    mean(IMU(NumSet_Y_Down_Start:NumSet_Y_Down_End,4));
    mean(IMU(NumSet_Y_Down_Start:NumSet_Y_Down_End,5))];
u5=[mean(IMU(NumSet_Z_Up_Start:NumSet_Z_Up_End,3));
    mean(IMU(NumSet_Z_Up_Start:NumSet_Z_Up_End,4));
    mean(IMU(NumSet_Z_Up_Start:NumSet_Z_Up_End,5))];
u6=[mean(IMU(NumSet_Z_Down_Start:NumSet_Z_Down_End,3));
    mean(IMU(NumSet_Z_Down_Start:NumSet_Z_Down_End,4));
    mean(IMU(NumSet_Z_Down_Start:NumSet_Z_Down_End,5))];
U = [u1,u2,u3,u4,u5,u6];

%求解加速度计校准参数
M = U*A'*(A*A')^-1;

K = M(1:3,1:3);
B0 = M(1:3,4);
K = K^-1;
M = [K,B0];

set(handles.edit_Calibration_M11,'String',num2str(M(1,1),'%.8f'));
set(handles.edit_Calibration_M12,'String',num2str(M(1,2),'%.8f'));
set(handles.edit_Calibration_M13,'String',num2str(M(1,3),'%.8f'));
set(handles.edit_Calibration_M14,'String',num2str(M(1,4),'%.8f'));
set(handles.edit_Calibration_M21,'String',num2str(M(2,1),'%.8f'));
set(handles.edit_Calibration_M22,'String',num2str(M(2,2),'%.8f'));
set(handles.edit_Calibration_M23,'String',num2str(M(2,3),'%.8f'));
set(handles.edit_Calibration_M24,'String',num2str(M(2,4),'%.8f'));
set(handles.edit_Calibration_M31,'String',num2str(M(3,1),'%.8f'));
set(handles.edit_Calibration_M32,'String',num2str(M(3,2),'%.8f'));
set(handles.edit_Calibration_M33,'String',num2str(M(3,3),'%.8f'));
set(handles.edit_Calibration_M34,'String',num2str(M(3,4),'%.8f'));

%测试计算的正确性
% K = M(1:3,1:3);
% B0 = M(1:3,4);
% u1
% K^-1 * (u1-B0)
% 
% u2
% K^-1 * (u2-B0)
% u3
% K^-1 * (u3-B0)
% u4
% K^-1 * (u4-B0)
% u5
% K^-1 * (u5-B0)
% u6
% K^-1 * (u6-B0)




function edit_Calibration_M11_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_M11 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_M11 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_M11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_M12_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_M12 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_M12 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_M12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_M13_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_M13 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_M13 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_M13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_M14_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_M14 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_M14 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_M14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_M21_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_M21 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_M21 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_M21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_M22_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_M22 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_M22 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_M22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_M23_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_M23 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_M23 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_M23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_M24_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_M24 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_M24 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_M24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_M31_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_M31 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_M31 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_M31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_M32_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_M32 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_M32 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_M32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_M33_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_M33 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_M33 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_M33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Calibration_M34_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Calibration_M34 as text
%        str2double(get(hObject,'String')) returns contents of edit_Calibration_M34 as a double


% --- Executes during object creation, after setting all properties.
function edit_Calibration_M34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Calibration_M34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Pos_Lat_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Pos_Lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Pos_Lat as text
%        str2double(get(hObject,'String')) returns contents of edit_Pos_Lat as a double
global Pos_Lat
Pos_Lat = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Pos_Lat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Pos_Lat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Pos_Lon_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Pos_Lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Pos_Lon as text
%        str2double(get(hObject,'String')) returns contents of edit_Pos_Lon as a double
global Pos_Lon
Pos_Lon = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Pos_Lon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Pos_Lon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Pos_High_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Pos_High (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Pos_High as text
%        str2double(get(hObject,'String')) returns contents of edit_Pos_High as a double
global Pos_High
Pos_High = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Pos_High_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Pos_High (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Analy_Allon.
function pushbutton_Analy_Allon_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Analy_Allon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Allon_Analy_StartMinute Allon_Group_Interval
global DataPath_Allon 
if isempty(DataPath_Allon)
   msgbox('请输入需要Allon方差分析的数据路径！');
   return;
else
   load(DataPath_Allon); 
   if exist('IMU','var')   %有IMU数据，则使用
%         %绘制原始数据
%         figure; plot(IMU(:,3),'k');  %加计x
%         hold on; plot(IMU(:,4),'r');
%         hold on; plot(IMU(:,5),'g');
%         legend('X轴','Y轴','Z轴');
%         xlabel('\it t \rm / s');  ylabel('\it m \rm / s2');
%         title('三轴加计输出');   grid on; 
    else
        msgbox('IMU 数据不存在！');
        return;
    end
end
global Hz Allon_Analy_UsedMinute
% 按照设定，截取IMU数据，并将陀螺原始数据的 弧度/s 转化为 度/小时
if Allon_Analy_StartMinute > 0
	IMU = IMU(Allon_Analy_StartMinute*60*Hz:end-10*Hz,6:8)*(180/pi*3600);
else
    IMU = IMU(1:end-10*Hz,6:8)*(180/pi*3600);
end
if Allon_Analy_UsedMinute > 0
    L = length(IMU);
    if L > (Allon_Analy_UsedMinute*60*Hz)
        IMU = IMU(1:Allon_Analy_UsedMinute*60*Hz,:);
    end
end

% 将陀螺数据采样频率平滑降低
if fix(Allon_Group_Interval) > 1
    Allon_Group_Interval = fix(Allon_Group_Interval);
else 
    Allon_Group_Interval = 1;
end
IMU_tau0 = 1/Hz;
% X轴陀螺 Allon方差分析
IMU_sigma = []; IMU_tau = []; IMU_Err = []; IMU_sigma_NIHE = [];
disp('---------------Allon方差分析开始--------------------');
for k = 1:3
    %[sigma,tau,Err] = AllonVar_Analysis(IMU(:,k),IMU_tau0,5);
    [sigma,tau,Err] = AllonVar_Analysis_Interval(IMU(:,k),IMU_tau0,5,Allon_Group_Interval);
%     sigma = sigma(2:end,1); tau = tau(2:end,1); Err = Err(2:end,1);
    IMU_sigma(:,k) = sigma;
    IMU_tau(:,k) = tau;
    IMU_Err(:,k) = Err;
    
    T = tau;
    n = length(T);
    A = zeros(n,3);
    Y = sigma;
    for i=2:4
        n=i-3;
        A(:,i-1)=T.^n;  %***惯性数据测试p143 式8.3-23
    end
    X = abs((A'*A)^-1 * A'*Y);
    arw_N(k,1) =     sqrt(X(1)) ;                %角度随机游走N
    bias_B(k,1) =    sqrt(X(2)*pi/2/log(2)) ;             %零偏不稳定性B
    rrw_K(k,1) =     sqrt(X(3)*3) ;    %速率随机游走K
    disp(['第',num2str(k),'轴的Allon方差分析辨识参数结果：'])
    disp(['角度随机游走N arw_N: ',num2str(arw_N(k,1))]);
    disp(['零偏不稳定性B bias_B: ',num2str(bias_B(k,1))]);
    disp(['速率随机游走K rrw_K: ',num2str(rrw_K(k,1))]);
    % 参数辨识后的曲线拟合
    [L,m] = size(A);
    sigma_NIHE = zeros(L,1);
    for i = 1:L
        for j = 1:3
            sigma_NIHE(i,1) = sigma_NIHE(i,1) + X(j,1)*A(i,j);
        end
    end
    IMU_sigma_NIHE(:,k) = sigma_NIHE;
end
disp('---------------Allon方差分析结束--------------------');
figure;     loglog(IMU_tau(:,1),sqrt(IMU_sigma(:,1)),'red-*');
hold on;	loglog(IMU_tau(:,1),sqrt(IMU_sigma_NIHE(:,1)),'g'); grid on;
xlabel('相关时间[s]');ylabel('Allan标准差[度/小时]');title('X轴陀螺 Allan方差');

figure;     loglog(IMU_tau(:,2),sqrt(IMU_sigma(:,2)),'red-*');
hold on;	loglog(IMU_tau(:,2),sqrt(IMU_sigma_NIHE(:,2)),'g'); grid on;
xlabel('相关时间[s]');ylabel('Allan标准差[度/小时]');title('Y轴陀螺 Allan方差');

figure;     loglog(IMU_tau(:,3),sqrt(IMU_sigma(:,3)),'red-*');
hold on;	loglog(IMU_tau(:,3),sqrt(IMU_sigma_NIHE(:,3)),'g'); grid on;
xlabel('相关时间[s]');ylabel('Allan标准差[度/小时]');title('Z轴陀螺 Allan方差');

% 结果显示更新
set(handles.edit_Gyro_Bias_X,'String',num2str(bias_B(1,1),'%.3f'));
set(handles.edit_Gyro_Bias_Y,'String',num2str(bias_B(2,1),'%.3f'));
set(handles.edit_Gyro_Bias_Z,'String',num2str(bias_B(3,1),'%.3f'));

set(handles.edit_Gyro_ARW_X,'String',num2str(arw_N(1,1),'%.3f'));
set(handles.edit_Gyro_ARW_Y,'String',num2str(arw_N(2,1),'%.3f'));
set(handles.edit_Gyro_ARW_Z,'String',num2str(arw_N(3,1),'%.3f'));

% --- Executes on button press in pushbutton_Analy_10s.
function pushbutton_Analy_10s_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Analy_10s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global DataPath_Allon Allon_Analy_StartMinute
if isempty(DataPath_Allon)
   msgbox('请输入需要标校分析的数据路径！');
   return;
else
   load(DataPath_Allon); 
   if exist('IMU','var')   %有IMU数据，则使用
%         %绘制原始数据
%         figure; plot(IMU(:,3),'k');  %加计x
%         hold on; plot(IMU(:,4),'r');
%         hold on; plot(IMU(:,5),'g');
%         legend('X轴','Y轴','Z轴');
%         xlabel('\it t \rm / s');  ylabel('\it m \rm / s2');
%         title('三轴加计输出');   grid on; 
    else
        msgbox('IMU 数据不存在！');
        return;
    end
end
global Hz Allon_Analy_UsedMinute

if Allon_Analy_StartMinute > 0
	IMU = IMU(Allon_Analy_StartMinute*60*Hz:end-10*Hz,6:8)*(180/pi*3600);
else
    IMU = IMU(1:end-10*Hz,6:8)*(180/pi*3600);
end

if Allon_Analy_UsedMinute > 0
    L = length(IMU);
    if L > (Allon_Analy_UsedMinute*60*Hz)
        IMU = IMU(1:Allon_Analy_UsedMinute*60*Hz,:);
    end
end

% 10s平滑 方差分析   去掉开始15分钟数据(预热阶段)和结尾10s数据
Gyro_X = IMU(:,1);
Gyro_Y = IMU(:,2);
Gyro_Z = IMU(:,3);
N = length(Gyro_X);
num = fix(N/Hz/10);
Mean_X = zeros(num,1);Mean_Y = zeros(num,1);Mean_Z = zeros(num,1);
for i = 1:num
    Mean_X(i,1) = mean(Gyro_X((i-1)*Hz*10+1:(i-1)*Hz*10+Hz*10));
    Mean_Y(i,1) = mean(Gyro_Y((i-1)*Hz*10+1:(i-1)*Hz*10+Hz*10));
    Mean_Z(i,1) = mean(Gyro_Z((i-1)*Hz*10+1:(i-1)*Hz*10+Hz*10));
end

Gyro_Bias_X = sqrt(var(Mean_X));
Gyro_Bias_Y = sqrt(var(Mean_Y));
Gyro_Bias_Z = sqrt(var(Mean_Z));
%参数显示
set(handles.edit_Gyro_Bias_X,'String',num2str(Gyro_Bias_X));
set(handles.edit_Gyro_Bias_Y,'String',num2str(Gyro_Bias_Y));
set(handles.edit_Gyro_Bias_Z,'String',num2str(Gyro_Bias_Z));

set(handles.edit_Gyro_ARW_X,'String','0');
set(handles.edit_Gyro_ARW_Y,'String','0');
set(handles.edit_Gyro_ARW_Z,'String','0');

disp('---------------10S平滑 零偏--------------------');
    disp(['X轴的零偏稳定性：',num2str(Gyro_Bias_X)]);
    disp(['Y轴的零偏稳定性：',num2str(Gyro_Bias_Y)]);
    disp(['Z轴的零偏稳定性：',num2str(Gyro_Bias_Z)]);
disp('---------------10S平滑方差分析结束--------------------');

% --- Executes on button press in pushbutton_InputData_Defin_Unite.
function pushbutton_InputData_Defin_Unite_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_InputData_Defin_Unite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('IMU原始数输入数据格式:[秒 毫秒 x加计 y z x陀螺 y z];[单位:加计(m/s2) 陀螺(弧度/s)]');



function edit_Analy_Allon_StartMinute_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Analy_Allon_StartMinute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Analy_Allon_StartMinute as text
%        str2double(get(hObject,'String')) returns contents of edit_Analy_Allon_StartMinute as a double
global Allon_Analy_StartMinute
Allon_Analy_StartMinute = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Analy_Allon_StartMinute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Analy_Allon_StartMinute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Slow_Hz_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Slow_Hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Slow_Hz as text
%        str2double(get(hObject,'String')) returns contents of edit_Slow_Hz as a double
global Allon_Group_Interval
Allon_Group_Interval = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Slow_Hz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Slow_Hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_Analy_Allon_UsedMinute_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Analy_Allon_UsedMinute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Analy_Allon_UsedMinute as text
%        str2double(get(hObject,'String')) returns contents of edit_Analy_Allon_UsedMinute as a double
global Allon_Analy_UsedMinute
Allon_Analy_UsedMinute = str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit_Analy_Allon_UsedMinute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Analy_Allon_UsedMinute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
