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

% Last Modified by GUIDE v2.5 28-Mar-2020 11:09:08

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

%===========================ȫ�ֱ����趨=====================================
%IMU �����������ļ��� �ļ�·�� 
global IMU_FilePath IMU_FileName
IMU_FilePath = []; IMU_FileName = [];
%ѡ����豸���� 1:First(MPU)(Ĭ��) 2:Second(MTi) 3:Third(ADIS) 
global Choose_Device
Choose_Device = 1;
%ѡ��洢���������� 
%   1:IMUA(MPU_Only)(Ĭ��) 2:IMUB(MPU_Only) 3:IMUB(MTi_Only) 4:IMUB(ADIS_Only) 
%   5:IMUB(ADIS)+IMUA(MPU_Magnetic) 6:IMUB(MPU)+IMUA(MPU)
global Choose_DataKinde
Choose_DataKinde = 1;
%ѡ����Ż��ҽ����� 1:���(��UWB)(Ĭ��) 2:���(����UWB) 3:�ҽ�(����UWB)
global Choose_Foot_LeftorRight
Choose_Foot_LeftorRight = 1;
%�Ƿ�����ŵ�ѹ�������� 1:������(Ĭ��) 2:����
global Choose_FootPressure
Choose_FootPressure = 1;

%��̬ʶ�𷽷�ѡ��  1 ѹ����ʼ�ж� 2 ѹ�������ж� 3 �Ӽ����ݴ�ͳ�ж�
global Choose_ZeroDetect
Choose_ZeroDetect = 1;

%ѡ��ʱ��ͬ������ 1:�ڲ�GPSʱ��(Ĭ��)(����Ч��λUTCʱ�������뿪ʼ) 2:�ڲ�ʱ��(��0�뿪ʼ��ʱ)
global Choose_Time
Choose_Time = 1;
%�ⲿ�߾��ȶ�λ����(��������) 0:�� 1:��  
%   txt���ݸ�ʽΪ hhmmss.sss ddmm.mmmmmmm dddmm.mmmmmmm ˮƽ����(��) �߳�(��)
%   �������Ϊ: ������ γ�� ���� �߳� ˮƽ����
global Choose_HighGPSData
Choose_HighGPSData = 0;
%�ⲿ�߾��ȶ�λ����(��������) �����������ļ��� �ļ�·�� 
global GPS_FilePath GPS_FileName 
GPS_FilePath = [];  GPS_FileName = [];
%Ԥ������ɺ󣬴�ŵ�·��������
global tDataSavePath tPath
tDataSavePath = []; tPath = [];
%ʱ���ȡ�� ��ʼ�ͽ���ʱ�� ��λS
global Time_Start Time_End
Time_Start = 0.0;   Time_End = 0.0;
disp('*/\/\/\/\/\/\/\/\/\/\��������/\/\/\/\/\/\/\/\/\/\*');
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


% --- Executes on button press in pushbutton_OpenData.
function pushbutton_OpenData_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OpenData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% global IMU_FileName;  %�����������ļ��� 
% global IMU_FilePath;  %�����������ļ�·��
% [IMU_FileName,IMU_FilePath] = uigetfile("*.dat","ѡ��ҪԤ�����ԭʼ����");

global IMU_FileName IMU_FilePath tDataSavePath tPath
[IMU_FileName,IMU_FilePath] = uigetfile('*.dat');
if isequal(IMU_FileName,0)
   
else  
   set(handles.edit1,'string',strcat(IMU_FilePath,IMU_FileName));
   % 1. ��ȡ�ļ�·��
    tIndex = strfind(IMU_FileName,'.');
    tName = IMU_FileName(1:tIndex-1);  %Ԥ���������mat �洢������
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


%------------------------ ��ȡIMU �� �ⲿ ��ص���������-----------------------------
% --- Executes on button press in pushbutton_DataSave.
function pushbutton_DataSave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_DataSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 0. ȫ�ֱ�������
global IMU_FilePath IMU_FileName Choose_Device Choose_DataKinde Choose_Time
global Choose_Foot_LeftorRight Choose_FootPressure tDataSavePath tPath

if isempty(tDataSavePath) == 1
    disp('���棺****δ���ñ�������·���������򿪰�ť��*****');
    return;
end

disp('*****************************************************');
disp('*-------------------���ݶ�ȡ��ʼ---------------------*');
%% 1. ��ȡIMU�������
if isempty(IMU_FilePath) == 1
    disp('���棺******δ����IMU����·����******');
else
%���ݲ������趨����ȡģ���Ӧ������
%   ��ͬģ���ʹ�ã����� IMU �� Magnetic �ϵ�������
    %% 1.1 IMU �� Magnetic ��һ������
    % ��һ�������First IMUB_MPU_Only 
    if Choose_Device == 1 && Choose_DataKinde == 1  
        Path_IMU = [tPath,'_UB_IMU_MPU.txt'];  %������ǿ�� 
        [IMU,Magnetic] = DataPrepare_LoadData_IMU_Include_Magnetic(Path_IMU);
        if isempty(IMU) == 1 
            disp('1.*****IMU����Ϊ��*****');
        else
            save(tDataSavePath,'IMU');                  %�洢
            disp('1. IMU���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(IMU,1);       %����
            save(tDataSavePath,'Magnetic','-append');   %�洢
            disp('2. Magnetic���ݴ洢�ɹ���');              
            DataPrepare_PlotData_Original(Magnetic,2);  %����
        end
    end
    % ��һ�������First IMUA_MPU_Only 
    if Choose_Device == 1 && Choose_DataKinde == 2  
        Path_IMU = [tPath,'_UA_IMU_MPU.txt'];  %������ǿ�� 
        [IMU,Magnetic] = DataPrepare_LoadData_IMU_Include_Magnetic(Path_IMU);
        if isempty(IMU) == 1 
            disp('1.*****IMU����Ϊ��*****');
        else
            save(tDataSavePath,'IMU');                  %�洢
            disp('1. IMU���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(IMU,1);       %����
            save(tDataSavePath,'Magnetic','-append');   %�洢
            disp('2. Magnetic���ݴ洢�ɹ���');              
            DataPrepare_PlotData_Original(Magnetic,2);  %����
        end
    end    
    % �ڶ��������Third IMUB_ADIS + IMUA_MPU_Magnetic
    if Choose_Device == 3 && Choose_DataKinde == 5 
        Path_IMU = [tPath,'_UB_IMU_ADIS.txt']; 
        IMU = DataPrepare_LoadData_IMU_Only(Path_IMU);
        if isempty(IMU) == 1 
            disp('1.*****IMU����Ϊ��*****');
        else
            save(tDataSavePath,'IMU');                  %�洢
            disp('1. IMU���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(IMU,1);       %����
        end
        %��ȡIMUA_MPU�Ĵ�ǿ������ ���洢
        Path_Magnetic = [tPath,'_UA_Magnetic_MPU.txt']; 
        Magnetic = DataPrepare_LoadData_Magnetic_Only(Path_Magnetic);
        if isempty(Magnetic) == 1
            disp('2.******��ǿ�����ݶ�ȡʧ�ܣ�******');
        else
            save(tDataSavePath,'Magnetic','-append');
            disp('2. Magnetic���ݴ洢�ɹ���'); 
            DataPrepare_PlotData_Original(Magnetic,2);
        end        
    end
    %% 1.2 ��ȡ���ѹ������
    if Choose_FootPressure == 1
        Path_FootPres = [tPath,'_FootPressure.txt'];  
        FootPres = DataPrepare_LoadData_FootPres(Path_FootPres);
        if isempty(FootPres) == 1
            disp('3.*****FootPress���ݶ�ȡʧ��******');
        else
            save(tDataSavePath,'FootPres','-append');
            disp('3. FootPress���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(FootPres,3);
        end            
    end

    %% 1.3 ��ȡUWB�������
    if Choose_Foot_LeftorRight == 1       %��ź�UWB����
        Path_UWB = [tPath,'_UWB.txt'];  
        UWB = DataPrepare_LoadData_UWB(Path_UWB);
        if isempty(UWB) == 1
            disp('3.*****UWB���ݶ�ȡʧ��******');
        else
            save(tDataSavePath,'UWB','-append');
            disp('4. UWB���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(UWB,4);
        end              
    end

    %% 1.4 ��ȡGPS����
    if Choose_Time == 1       %ʹ��GPSʱ�䣬��ζ����GPS����
        Path_GPS = [tPath,'_GPS.txt'];  
        GPS = load(Path_GPS);
        if isempty(GPS) == 1
            disp('5.******GPS���ݶ�ȡʧ��******');
        else
            %��λת��
            GPS(:,2:3) = GPS(:,2:3).*(pi/180.0);
            save(tDataSavePath,'GPS','-append');
            disp('5. GPS���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(GPS,5);
        end                
    end    
end
 
%% 2. ��ȡ�ⲿ�������µĸ߾���GPS����
%�ⲿ�߾��ȶ�λ����(��������) 0:�� 1:��  
%   txt���ݸ�ʽΪ hhmmss.sss ddmm.mmmmmmm dddmm.mmmmmmm ˮƽ����(��) �߳�(��)
%   �������Ϊ: ������ γ�� ���� �߳� ˮƽ����
global Choose_HighGPSData
%�ⲿ�߾��ȶ�λ����(��������) �����������ļ��� �ļ�·�� 
global GPS_FilePath GPS_FileName 

if isempty(GPS_FilePath) == 1
    disp('���棺******δ���ø߾���GPS����·����******');
else
    if Choose_HighGPSData == 1 
        Path_HighGPS = [GPS_FilePath,GPS_FileName];     
        Temp = load(Path_HighGPS);
        if isempty(Temp) == 1
            disp('5.******High GPS���ݶ�ȡʧ��******');
        else 
            L = length(Temp);
            HighGPS = zeros(L,6);
            for i=1:L
                %ʱ�����
                Second = fix(mod(Temp(i,1),100));   %�е�ʱ�򱱶���������Ǵ�ms��
                Minute = fix(fix(mod(Temp(i,1),10000))/100);
                Hour = fix(Temp(i,1)/10000);
                HighGPS(i,1) = Hour*3600+Minute*60+Second;
                %γ�ȼ���
                Degree = fix(Temp(i,2)/100);
                DMinute = mod(Temp(i,2),100);
                HighGPS(i,2) = Degree+DMinute/60.0;
                %���ȼ���
                Degree = fix(Temp(i,3)/100);
                DMinute = mod(Temp(i,3),100);
                HighGPS(i,3) = Degree+DMinute/60.0;
                %�߳�
                HighGPS(i,4) = Temp(i,6);
                %ˮƽ��λ����
                HighGPS(i,5) = Temp(i,5);
                %��λģʽ 0 ��Ч 1���� 4RTK���� 5RTK�̶� 6�ߵ�
                HighGPS(i,6) = Temp(i,4);
            end
            HighGPS(:,2:3) = HighGPS(:,2:3).*(pi/180.0);
            save(tDataSavePath,'HighGPS','-append');
            disp('5.High GPS���ݴ洢�ɹ���');
            DataPrepare_PlotData_Original(HighGPS,6);
        end      
    end
end

disp('*-------------------���ݶ�ȡ���--------------------*��');
disp('*****************************************************');

% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%ѡ����豸���� 1:First(MPU)(Ĭ��) 2:Second(MTi) 3:Third(ADIS) 
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
%   1:IMUA(MPU_Only)(Ĭ��) 2:IMUB(MPU_Only) 3:IMUB(MTi_Only) 4:IMUB(ADIS_Only) 
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
%ѡ����Ż��ҽ����� 1:���(��UWB)(Ĭ��) 2:���(����UWB) 3:�ҽ�(����UWB)
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

% --- Executes on button press in pushbutton_TimeSynchro.
function pushbutton_TimeSynchro_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_TimeSynchro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%ѡ��ʱ��ͬ������ 1:�ڲ�GPSʱ��(Ĭ��)(����Ч��λUTCʱ�������뿪ʼ) 2:�ڲ�ʱ��(��0�뿪ʼ��ʱ)
%% 0. �Ȼ�ȡ��Ҫ��ȡʱ��ε� ��ʼ�ͽ��� ʱ��
global Time_Start Time_End tDataSavePath
Time_Start = str2double(get(handles.edit2,'String'));
Time_End = str2double(get(handles.edit4,'String'));
global Choose_Time
disp('----------------------------------------------------');
disp('*------------------��ʼʱ��ͬ������-----------------*');
if isempty(tDataSavePath) == 1
    disp('*-----------����·��Ϊ�գ��޷���ȡ���ݣ�------------*');    
    disp('****************************************************');
    msgbox('����·��Ϊ�գ�');
    return;
end

%% 1. ʹ��GPSʱ��ͬ��
if Choose_Time == 1          
    DataPrepare_IMUData_TimeAlignmentUTC(tDataSavePath,200,100,Time_Start,Time_End);  
    disp('*---------------ʹ��GPSʱ��ͬ����ɣ�---------------*');    
    disp('****************************************************');
end

%% 2. ʹ���ڲ�ʱ��
if Choose_Time == 2
    DataPrepare_IMUData_TimeAlignmentSelf(tDataSavePath,200,100,Time_Start,Time_End); 
    disp('*--------------ʹ���ڲ�ʱ�ӣ�������ɣ�--------------*');
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
%ѡ��ʱ��ͬ������ 1:�ڲ�ʱ��(Ĭ��)(��0�뿪ʼ��ʱ) 2:�ڲ�GPSʱ��(����Ч��λUTCʱ�������뿪ʼ)
global Choose_Time
str = get(hObject,'tag');
switch str
    case 'radiobutton13'
        Choose_Time = 1;
        set(handles.text6,'string','��ʼʱ��:');
        set(handles.text9,'string','����ʱ��:');
    case 'radiobutton14'
        Choose_Time = 2;
        set(handles.text6,'string','��ʼ���:');
        set(handles.text9,'string','�������:');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
%�ⲿ�߾��ȶ�λ����(��������) 0:�� 1:��  
%   txt���ݸ�ʽΪ hhmmss.sss ddmm.mmmmmmm dddmm.mmmmmmm ˮƽ����(��) �߳�(��)
%   �������Ϊ: ������ γ�� ���� �߳� ˮƽ����
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
disp('*/\/\/\/\/\/\/\/\/\/\�����˳�/\/\/\/\/\/\/\/\/\/\*');

% --- Executes when selected object is changed in uibuttongroup7.
function uibuttongroup7_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup7 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%�Ƿ�����ŵ�ѹ�������� 1:������(Ĭ��) 2:����
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
%����·����ȡ���ѹ�����ݵ�txt
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
% %����·����ȡ������ǿ�����ݵ� IMU ���� ��txt�ļ�
% ע�⣺Ŀǰʹ�õ���MPU9250 IMU����Ƶ����200Hz����ǿ����100Hz������䶯��������Ҫ���иı�
IMU = [];
Magnetic = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %���ݵ�λ�Ƕ�/s  �Ӽ� m/s2 ��ǿ�� uT
    %IMU = zeros(L,10);   %�����¶���Ϣ
    IMU = zeros(L,9);
    IMU(1:L,1:5) = Temp(1:L,1:5);  
    IMU(1:L,6:8) = Temp(1:L,6:8)./(180.0/pi);   
    IMU(1:L,9) = Temp(1:L,13);  %ʱ��״̬
    %IMU(1:L,10) = Temp(1:L,12);  %�¶�
    %��ִ�ǿ������ 
    TMagnetic = zeros(fix(L/2),6);
    for i=1:fix(L/2)
        TMagnetic(i,1:2) = IMU(1+(i-1)*2,1:2); %ʱ��        
        TMagnetic(i,3:5) = Temp(1+(i-1)*2,9:11);
        TMagnetic(i,6) = Temp(1+(i-1)*2,13); %ʱ��״̬
    end      
    Magnetic = TMagnetic;
    Magnetic(:,3) = TMagnetic(:,4);
    Magnetic(:,4) = TMagnetic(:,3);
    Magnetic(:,5) = -TMagnetic(:,5);
end


function IMU = DataPrepare_LoadData_IMU_Only(mLoadPath)
% ��ȡ��������ǿ�����ݵ� IMU ���� (ADIS)
IMU = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %���ݵ�λ�Ƕ�/s  �Ӽ� m/s2 ��ǿ�� uT
    %IMU = zeros(L,10);       %���һ�д�ʱ���
    IMU = zeros(L,9);       %���һ�д�ʱ���
    IMU(1:L,1:5) = Temp(1:L,1:5);
    IMU(1:L,6:8) = Temp(1:L,6:8)./(180.0/pi);   
    IMU(1:L,9) = Temp(1:L,11);
    %IMU(1:L,10) = Temp(1:L,9);   %�¶�����
end


function Magnetic = DataPrepare_LoadData_Magnetic_Only(mLoadPath)
% ��ȡ��ǿ������  ��IMUA_MPU9250�ɼ�   ��ǿ�Ʋɼ�Ƶ��100Hz
Magnetic = [];
Temp = load(mLoadPath);

if isempty(Temp) == 1
    return;
else
    L = length(Temp)-1;    %��ǿ�Ƶ�λ uT
    TMagnetic = zeros(L,6);
    TMagnetic(1:L,1:6) = Temp(1:L,1:6);    %����ʱ��״̬
end
Magnetic = TMagnetic;
Magnetic(:,3) = TMagnetic(:,4);
Magnetic(:,4) = TMagnetic(:,3);
Magnetic(:,5) = -TMagnetic(:,5);

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
%���������յ㣬���� Number�����ݲ�ֵ ���Բ�ֵ
%��һ��Ϊʱ��  ����Ϊ���� ���һ��Ϊʱ��״̬
[L,m] = size(First);
NewData = zeros(Number,m);
%��ֵ�ķ�Χ�� �ӵ�3�� �� ������2��
%1.����ʱ����
DistanceTime = Second(1,1) - First(1,1);
DistanceData = Second(1,2:m-1) - First(1,2:m-1);
for i = 1:Number
    %ʱ�����
    NewTime = First(1,1)+DistanceTime*i/(Number+1);
    NewData(i,1) = NewTime;
    %���ݸ���
    NewData(i,2:m-1) = First(1,2:m-1) + DistanceData.*(i/(Number+1));
end
    

function InsertData = Data_Insert_From_Time(First,Second,Time)
%��һ����ʱ�䣬���������� ���һ��Ϊʱ���
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
% ���������ж�Ӧ�������ʼλ�ã�ע������ʹ�õĻ�������ʱ������
[L,m] = size(mData);

for i = 1:L
       %û�ҵ��������Ч������
       if ( mData(i,1) > mSecond)
           mSecond = mSecond + 1;
       end
       if  (mData(i,1) == mSecond)&&(mData(i,m)==1)
           %�ҵ�����������
           Second = mSecond;
           SerialNum = i;
           return;
       end
end

%�������ݶ�û�ҵ���Ч���������
SerialNum = 0;
Second = 0;


function NewData = DataPrepare_IMUData_LoseCheck_And_Insert(mData,Hz)
%����������ݰ��������������¼ʱ����ж����жϣ������в�ֵ����,���һ���㲻������ʱ��
% ������ʱ�������ͻ�䣡
% ��һ��Ϊʱ����Ϣ 
DeltaT_ms = 1/Hz;
[L,m] = size(mData);

% 1.���ж������Ƿ���  
% ��Ϊ ѡȡ��������ʱ��֮������ݣ���ˣ�ʱ������Ӧ���ǵ�����
j = 1;    
mLoseRecord=[0,0];
mLoseTime = 0;
for i=1:L-1
    IntervalTime = mData(i+1,1)-mData(i,1);  %��������֮���ʱ���   
    if IntervalTime < 0
        disp("���棺���������ݶ����ж��У����������㣡") 
    end
    tNumber = round(IntervalTime/DeltaT_ms)-1;
    if tNumber > 0            
        mLoseRecord(j,1) = i+1;        %����� i+1֮ǰҪ����
        mLoseRecord(j,2) = tNumber;
        j = j+1;
        mLoseTime = mLoseTime+1;
        if tNumber > Hz/2
           disp("����񣬶������������ˣ�������") 
           return;
        end
    end
end    

% 2. �����Ƿ��������������ݵĿռ�����
if mLoseTime == 0
    %û�ж��� ���ò�ֵ��ֱ�ӷ���
    NewData = mData;
    return;
else
    %�ж����ģ���Ҫ���в�ֵ
    L1 = sum(mLoseRecord(:,2));  %��Ҫ��ֵ�ĸ���
    NewData = zeros(L+L1,m);
    j = 1;
    mAddNumber = 0;
    for i=1:L        
        if i == mLoseRecord(j,1)
            %��i����ǰ����Ҫ��ֵ������ȱ�ĸ�����ֵ�� 
            InsertData = Data_Insert_From_Start_End(mData(i-1,:),mData(i,:),mLoseRecord(j,2));
            NewData(i+mAddNumber:i+mAddNumber+mLoseRecord(j,2)-1,:) = InsertData;            
            mAddNumber = mAddNumber+mLoseRecord(j,2);  %��¼�Ѿ���ֵ�ĸ���
            %�����������ֵ                
            NewData(i+mAddNumber,:) = mData(i,:);              
            if j < mLoseTime
                j=j+1;
            end
        else
           % ������ֵ               
           NewData(i+mAddNumber,:) = mData(i,:);
        end             
    end  
end

function   NewData = DataPrepare_IMUData_TimeAlignmentUTC_SecondAlign(mData,Hz)
%����������ݰ��� ��һ���� �����һ���� ��ʱ�䣬���м�����ݽ��ж���
% ����ĵ�һ��Ϊʱ�� 

%1.�жϵ�һ�����Ƿ�Ҫ���������
DeltaT = 1/Hz;
[L,m] = size(mData);

if mod(mData(1,1),DeltaT)==0 
    %����ĵ�һ����Ϊ ʱ�̵�
    Time = mData(1,1);
    StartTime = Time;
else
    Time = (fix(mData(1,1)/DeltaT)+1)*DeltaT;
    StartTime = Time;
end

%2. ��������׼ȷʱ��֮�䣬�ܰ������ٸ� ʱ�̵�
N = 0;  
while Time < mData(L,1)
    N = N+1;
    Time = Time+DeltaT;
end

%3. ��ʱ����ڵ������Ѿ����������䰴��ʱ��ν���ƽ��
AverageTime = (mData(L,1)-mData(1,1))/(L-1);
TempData = mData;
%��TempData�е�ʱ�䣬������β�⣬����ʱ�����ƽ��
for i = 2:L-1
    TempData(i,1) = TempData(i-1,1)+AverageTime;    
end

%4. �����µ�ʱ�����У����в�ֵ������ȡÿ��ʱ�̵������
NewData = zeros(N,m);
for i =1:N
    %��i������ ��׼ʱ��ʱ��
    NewData(i,1) = StartTime+(i-1)*DeltaT;
    %���в�ֵ����
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
% 0.�ú�������ǰ��ȷ�� �������ʼ�ͽ���ʱ��������Ч��Χ�ڵ�
% 1.�����������ݰ��������յ���нض�
% 2.�����ղ���Ƶ�ʽ��ж���
% 3.�����в�ֵ����
% ���ݵĸ�ʽ��һ���� �� ���� ����.... ʱ��״̬
CutData = [];
%% 0. ���ȶ������ ��ʼʱ��ͽ���ʱ�䣬����GPS��ʱ��Ч�Ե��ж�
Second_StartSerial = 0; Second_NextStartSerial = 0;
Second_StartTime = 0;   Second_NextStartTime = 0;
% ���ʱ�����Ч���ж�
[Second_StartTime,Second_StartSerial] = DataPrepare_IMUData_FindSecondSerial(mData,mStartT);
if Second_StartSerial == 0
    %����ʧ��
    fprintf('����:GPS��Ч��Χ�����и������Чʱ���趨���� %d!\n',mStartT);
    return;
end 
if Second_StartTime ~= mStartT
    fprintf('����:GPS��Чʱ��������Ϊ %d!\n',Second_StartTime);
    mStartT = Second_StartTime;
end 
% �յ�ʱ�����Ч���ж�
for s=mEndT:-1:mStartT
    [Second_NextStartTime,Second_NextStartSerial] = DataPrepare_IMUData_FindSecondSerial(mData,s);
    if Second_NextStartSerial ~= 0
        break;
    end
end
if Second_NextStartSerial == 0
    %����ʧ��
    fprintf('����:GPS��Ч��Χ�����и������Чʱ���趨���� %d!\n',mEndT);
    return;
end     
if Second_NextStartTime ~= mEndT
    fprintf('����:GPS��Чʱ��������Ϊ %d!\n',Second_NextStartTime);
    mEndT = Second_NextStartTime-1;
end 
% ʱ�䷶Χ����Ч���ж�
if mEndT <= mStartT
    fprintf('����:GPSʱ���иΧ��Ч��%d %d\n',mStartT,mEndT);
    return;  
end

%% һ������Ч����ʱ��ʼ���յ㷶Χ֮�䣬�������ݴ���
[L,m] = size(mData);
DeltaT = fix((1/Hz)*1000);  %ms��Ӧ���ݵڶ���
CutData = zeros((mEndT-mStartT+1)*Hz,m-2);
CutData_SavedNum = 0;
% ���޶������ʼʱ�䣬��ʼ������ÿһ����GPS��ʱ������
Second_NextStartTime = Second_StartTime; 
Second_NextStartSerial = Second_StartSerial;
Second_StartTime = 0;       Second_StartSerial = 0;
s = mStartT;

while s <= mEndT
    %1.�ҵ���ʱ����ʼ��
    Second_StartTime = Second_NextStartTime;
    Second_StartSerial = Second_NextStartSerial;
    %2.�ҵ���һ����ʱ����ʼ��    
    [Second_NextStartTime,Second_NextStartSerial]=DataPrepare_IMUData_FindSecondSerial(mData,Second_StartTime+1);
    s = Second_NextStartTime;
    
    if Second_NextStartSerial == 0
        break;
    end
    
    %3.��ȡ���ǰ������ʱ��ʱ�� >= 1s 
    %   ��һ�� �� ���һ��(��ʱ��) ʱ����׼ȷ�ģ��м� ���ڲ�ʱ��˳���ۼӣ�û�����㣬�п����ж�������Ҫ��ֵ
    Temp_Data = zeros(Second_NextStartSerial-Second_StartSerial+1,m-1);   %����ת��ʱ��
    Temp_Data(:,1) = mData(Second_StartSerial:Second_NextStartSerial,1)+mData(Second_StartSerial:Second_NextStartSerial,2)./1000.0;
    Temp_Data(:,2:m-1) = mData(Second_StartSerial:Second_NextStartSerial,3:m);
    Last_Data = Temp_Data(Second_NextStartSerial-Second_StartSerial+1,:);
    %4.���������ݣ����ж������,����ֵ���϶�������(ֻ�е�һ��������ʱ�㣬���һ����ʱ�㲻Ҫ����)
    Temp_Data = DataPrepare_IMUData_LoseCheck_And_Insert(Temp_Data(1:Second_NextStartSerial-Second_StartSerial,:),Hz);
    %5.�����󣬼��ϵ�ǰ�ε����һ��(��Чʱ��)������ʱ�����Ĳ�ֵ
    %(��������Чʱ��֮�䣬����ʱ����룬������һ���㣬�����������һ���㣬�Է��ظ�)
    Temp_Data=[Temp_Data;Last_Data];
    Temp_Data = DataPrepare_IMUData_TimeAlignmentUTC_SecondAlign(Temp_Data,Hz);
    %6.���������ݣ����д洢
    [L1,m1] = size(Temp_Data);
    if CutData_SavedNum == 0
            CutData(CutData_SavedNum+1:CutData_SavedNum+L1,:) = Temp_Data(:,1:m-2);    
            CutData_SavedNum = CutData_SavedNum+L1;        
    else        
        if abs(CutData(CutData_SavedNum,1) - Temp_Data(1,1)) < 0.000001
            CutData(CutData_SavedNum+1:CutData_SavedNum+L1-1,:) = Temp_Data(2:L1,1:m-2);    
            CutData_SavedNum = CutData_SavedNum+L1-1;        
        else
            CutData(CutData_SavedNum+1:CutData_SavedNum+L1,:) = Temp_Data(:,1:m-2);    
            CutData_SavedNum = CutData_SavedNum+L1;
        end
    end
end    


function DataPrepare_IMUData_TimeAlignmentUTC(mDataPath,HzIMU,HzMag,mTimeStart,mTimeEnd)
% ����GPS��UTC(������)����ʱ����룬ʹ�����¹���
%1.���趨����ʼ�ͽ���ʱ�䣬����ǰ��1�����չ��
%2.����û���趨��ʼ�ͽ���ʱ�䣬��Ĭ�������������һ�е�ʱ��״̬Ϊ��ʼ��Ĭ�϶�1S
%3.����ʱ�����󣬽��в�ֵ����
%����Ƶ��

%% һ�� ׼�������׶�
% 0.�����Ų�
if (mTimeStart<0)||(mTimeEnd<0)||((mTimeEnd>0)&&(mTimeStart>=mTimeEnd))
    disp('����:ʱ�������յ����ô���')
    return;
end

% 1. ��ȡ����
load(mDataPath);
if ~exist('IMU','var')   %���Ƿ����IMU�ж��Ƿ��������
    disp('����:δ��ȡ��IMU���ݣ�')
    return;
end
[L,m] = size(IMU);
% 2. �������ݵ���Ч��ʼʱ��ͽ���ʱ��
% 2.1 ������Ч��ʼʱ��
Temp_Start = 0; Temp_End = 0;
TimeState = 0;  Temp_StartIsFind = 0;
for i = 1:L
    %�״�GPSʱ����Ч
    if(TimeState == 0)&&(IMU(i,m) == 1 )            
        Temp_Start = IMU(i,1)+2; %��ʼ��λʱ�����1s���ӳ�
        TimeState = 1;
    end
    %�ж��趨����ʼʱ���Ƿ���Ч
    if(Temp_Start==IMU(i,1))&&(IMU(i,m) == 1)
        Temp_StartIsFind = 1;
        break;
    end
end
if Temp_StartIsFind == 0
    disp('����:û��GPS��ʼʱ�䣡')
    return;
end
% 2.2 ������Ч����ʱ��
for i = L:-1:1
    if IMU(i,m) == 1 
        Temp_End = IMU(i,1);
        break;
    end    
end
if Temp_Start>=Temp_End
    disp('����:GPS����ʱ����������')
    return;
end

TimeStart = 0; TimeEnd = 0;
% 3. ȷ����Ҫ��ȡ���ݵ���ʼ���յ�
if (mTimeStart == 0)
    TimeStart = Temp_Start;
else
    if Temp_Start>=mTimeStart
        TimeStart = Temp_Start;
    else
        TimeStart = mTimeStart;
    end
end
%��Ϊ���1s ʱ�䲻������ȥ��
if (mTimeEnd == 0)
    TimeEnd = Temp_End-1;
else
    if Temp_End>mTimeEnd
        TimeEnd = mTimeEnd;
    else
        TimeEnd = Temp_End-1;
    end
end

%��ȡ����ʵ��Ч��GPSʱ�䣬
    fprintf('��ȡ��ʵ��Ч��GPS��ȡʱ��Ϊ��%d  %d \n',TimeStart,TimeEnd);

%% ���� �������ݽ�ȡ�׶Σ�����ȱ����ֵ
%��ȫ����ȡ�꣬Ȼ����ƣ������Ƕ�GPS �͸߾���GPS�����ݽ��н�ȡ��
tIndex = strfind(mDataPath,'.');
NewPath = mDataPath(1:tIndex-1);
NewPath = [NewPath,sprintf('_%d_%d',TimeStart,TimeEnd),'.mat'];
%1.�Ƚ�ȡIMU ���洢
IMU_Old = IMU;
IMU = DataPrepare_IMUData_TimeAlignmentUTC_Cut(IMU,200,TimeStart,TimeEnd);
if isempty(IMU) == 1
    disp('1.**** IMU����ʱ���ȡʧ�ܣ�****')
else
    disp('1.IMU����ʱ���ȡ��ɣ�')
    IMU(end,:) = [];
    save(NewPath,'IMU');                        %�洢��ȡ���������
%     DataPrepare_PlotData_TimeCuted(IMU,IMU_Old,1);       %����
    DataPrepare_PlotData_TimeCuted(IMU,1);       %����
end    
%2. ��ǿ������
if exist('Magnetic','var') 
    Magnetic_Old = Magnetic;
    Magnetic = DataPrepare_IMUData_TimeAlignmentUTC_Cut(Magnetic,100,TimeStart,TimeEnd);
    if isempty(Magnetic) == 1
        disp('2.**** Magnetic����ʱ���ȡʧ�ܣ�****')
    else
        disp('2.Magnetic����ʱ���ȡ��ɣ�')
        save(NewPath,'Magnetic','-append');                  %�洢
        %DataPrepare_PlotData_TimeCuted(Magnetic,Magnetic_Old,2);       %����
        DataPrepare_PlotData_TimeCuted(Magnetic,2);       %����
    end
end   
%3. ���ѹ������    
if exist('FootPres','var')   
    FootPres_Old = FootPres;
    FootPres = DataPrepare_IMUData_TimeAlignmentUTC_Cut(FootPres,200,TimeStart,TimeEnd);
    if isempty(FootPres) == 1
        disp('3.**** FootPres����ʱ���ȡʧ�ܣ�****')
    else
        disp('3.FootPres����ʱ���ȡ��ɣ�')
        FootPres(end,:) = [];
        save(NewPath,'FootPres','-append');                  %�洢
        %DataPrepare_PlotData_TimeCuted(FootPres,FootPres_Old,3);          %����
        DataPrepare_PlotData_TimeCuted(FootPres,3);          %����
    end
end    
%4. UWB����
 if exist('UWB','var')   
    UWB_Old = UWB;
    UWB = DataPrepare_IMUData_TimeAlignmentUTC_Cut(UWB,200,TimeStart,TimeEnd);
    if isempty(UWB) == 1
        disp('4.**** UWB����ʱ���ȡʧ�ܣ�****')
    else
        disp('4.UWB����ʱ���ȡ��ɣ�')
        UWB(end,:) = [];
        save(NewPath,'UWB','-append');                  %�洢
        %DataPrepare_PlotData_TimeCuted(UWB,UWB_Old,4);          %����
        DataPrepare_PlotData_TimeCuted(UWB,4);          %����
    end
end 
%5. ģ����GPS����
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
    disp('5.GPS����ʱ���ȡ��ɣ�')
    save(NewPath,'GPS','-append');                  %�洢
    DataPrepare_PlotData_TimeCuted(GPS,5);          %����
end
%6. �ⲿ�߾���GPS����
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
    disp('6.HighGPS����ʱ���ȡ��ɣ�')
    save(NewPath,'HighGPS','-append');                  %�洢
    DataPrepare_PlotData_TimeCuted(HighGPS,6);          %����
end    
    
    
function DataPrepare_IMUData_TimeAlignmentSelf(mDataPath,HzIMU,HzMag,mTimeStart,mTimeEnd)
% ��û��GPSʱ�������£������ǵ��ŵ�������ʱ����ʱ����Զ����������£�
% ��1��UWB�����ݲ�����������ʱ��������ϣ���Ϊû������
% ��2��IMU �� FootPres������ʱ����ȫһ�£����ʼ���ղ���������ƣ�Ĭ�ϲ�����
% ��3����ǿ�Ƶ�������Ϊ�ɼ������һ�£�����IMU���ݵ�ʱ����ж��䣬��������Ҫ���в�ֵ

%1.�ж�����·���Ƿ���ȷ ��һ�㺯�����ж�
% if isempty(mDataPath) == 1
%     msgbox('����·��Ϊ�գ�');
%     return;
% end    

%2.��ȡ����
load(mDataPath);
DT_IMU = 1/HzIMU;  %IMU�������
% �趨�µĴ洢�ļ�
tIndex = strfind(mDataPath,'.');
NewPath = mDataPath(1:tIndex-1);

%3.�򵥴���UWB����  û��GPSʱ�� һ�㲻����UWB���
% if exist('UWB','var')    
%     [L,n] = size(UWB);
%     UWB_New = zeros(L,2);
%     UWB_New(:,1) = UWB(:,1) + UWB(:,2)./1000;
%     UWB_New(:,2) = UWB(:,3);
%     %�洢����������
%     UWB = UWB_New;
%     save(NewPath,'UWB','-append');
% end

%4.��������
if exist('IMU','var')    %��IMUΪ�������ȱʧֱ���˳�
    [L,n] = size(IMU);
    %�ж��Ƿ���Ҫ�ض�
    %(1) ���ض�
    if (mTimeStart==0 && mTimeEnd==0)    
        mNumStart = 1;
        mNumEnd = L;
    else
        if(mTimeEnd <= mTimeStart)
            mNumStart = mTimeStart;
            mNumEnd = L;
        else
            mNumStart = mTimeStart;
            mNumEnd = mTimeEnd;            
        end            
    end
    NewPath = [NewPath,sprintf('_%d_%d',mNumStart,mNumEnd),'.mat'];

    IMU_New = zeros(L,7);
    IMU_New(1,1) = IMU(1,1) + floor(IMU(1,2)/(1000/HzIMU));
    for i = 2:L
        IMU_New(i,1) = IMU_New(i-1,1) + DT_IMU;
    end
    IMU_New(:,2:7) = IMU(:,3:8);
    TimeRecord_Old_IMU = IMU(:,1) + IMU(:,2)./1000;  %��¼IMU �ϵ�ʱ�� ����ʱ�䣬���ڴ�ǿ�ƶ��� ��ֵ
    %�洢����������
    IMU = IMU_New(mNumStart:mNumEnd,:);
    save(NewPath,'IMU');            
    DataPrepare_PlotData_SelfNumber(IMU,1);
    IMU = IMU_New;      
    
    %����ѹ������������
    if exist('FootPres','var')    
        FootPres_New = zeros(L,5);
        FootPres_New(:,1) = IMU(:,1);
        FootPres_New(:,2:5) = FootPres(:,3:6);
        %�洢����������      
        FootPres = FootPres_New(mNumStart:mNumEnd,:);
        save(NewPath,'FootPres','-append');      
        DataPrepare_PlotData_SelfNumber(FootPres,3);
        FootPres = FootPres_New;
         
    end
        
    %�����ǿ������
    if exist('Magnetic','var')     
        TimeRecord_Mag = Magnetic(:,1) + Magnetic(:,2)./1000; 
        %��ȷ�� Mag ���ݵ�ʱ����IMU��Χ֮��
        mStart = 1;
        while (TimeRecord_Mag(mStart,1) < TimeRecord_Old_IMU(1,1))
           mStart = mStart+1; 
        end
        mEnd = length(TimeRecord_Mag);
        while (TimeRecord_Mag(mEnd,1) > TimeRecord_Old_IMU(end,1))
           mEnd = mEnd - 1; 
        end
        
        %��ȡ��Χ�ڵ�����
        Magnetic_New = zeros(mEnd-mStart+1 ,4);
        Magnetic_New(:,1) = Magnetic(mStart:mEnd,1) + Magnetic(mStart:mEnd,2)./1000; 
        Magnetic_New(:,2:4) = Magnetic(mStart:mEnd,3:5);
        
        %����ʱ����� �� TimeRecord_IMU Ѱ�Ҷ�Ӧ����ţ�Ȼ��ֵ IMU ��Ӧ��ʱ��
        L = mEnd-mStart+1;
        j = 1;  %jΪIMUʱ����� һ��һ������
        %iΪMagʱ����� һ��һ������
        for i = 1:L  
            while(abs(Magnetic_New(i,1)- TimeRecord_Old_IMU(j,1))>=(DT_IMU*0.6))
                j = j+1;
            end
            Magnetic_New(i,1) = IMU(j,1);  %������ʱ��
            j = j+1;
        end        
        %�洢����������
        Magnetic = Magnetic_New(ceil(mNumStart/2):ceil(mNumEnd/2)-1,:);
        save(NewPath,'Magnetic','-append');      
        DataPrepare_PlotData_SelfNumber(Magnetic,2);
        Magnetic = Magnetic_New;         
    end
else
    msgbox('IMU���ݲ����ڣ�ʱ��ͬ��ʧ�ܣ�');
    return;    
end

function DataPrepare_FootState_PressStart(mDataPath)
% ���ڶԳ�ʼ��׼�����еĲ�̬�����ж�
%   Ŀǰ���ü򵥰취����Ϊ������ԭ��̧�Ⱥ�תȦ�˶���
%   ��ΪֻҪǰ��ŵ�ѹ������100�������Ϊ�Ǿ�ֹ
%% һ����ȡ����
%   �ž�ֹ����ѹ��������С����ѹС
%   ���˶�����ѹ��������󣬵�ѹ��
% 1. FootPres_Limit ��ȥ��ë�� 
%    ԭʼ��������������ѹ���ֵ�����˶�״̬��
%    880 ��Ӧ3.0938V ��Ӧ61Kŷ ��Ӧ 24g  ȥ��ԭʼ�����������ë�̺����ݻ���
load(mDataPath);      
[n,m] = size(FootPres);
FootPres_Limit = FootPres;
for j = 2:5
    for i = 1:n
        if FootPres_Limit(i,j) > 900
            FootPres_Limit(i,j) = 900;
        end   
    end
end
% ��ת  ��������ѹ��
for j = 2:5
    for i = 1:n
        FootPres_Limit(i,j) = (-1)*FootPres_Limit(i,j)+900;   
    end
end


%% ��������ѹ���ж�
%   FootPres_Limit  2 �Ÿ��ڲ� 3 �Ÿ���� 4 �����ڲ� 5 �������
%   �ŵ�ѹ�����    
FootPres_PaLimit = 100;     %�ŵ�ѹ����ֵ
FootPres_Pa = zeros(n,2);
FootPres_Pa(:,1) = FootPres_Limit(:,1);
for i = 1:n
    FootPres_Pa(i,2) = sum(FootPres_Limit(i,2:5));
end
figure;
plot(FootPres_Pa(:,1),FootPres_Pa(:,2),'k');  %���ѹ��x
hold on;plot(IMU(:,1),IMU(:,4)*100,'-.','LineWidth',2);  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5)*50,'r-.','LineWidth',2);  %����
grid on;
legend('�ŵ�ѹ��','�Ӽ�Z*10','����X*50');
xlabel('\it t \rm / s');       
title('ѹ��������ԭʼ����');


% �ŵ�״̬�ж�
FootPres_State = zeros(n,2);
FootPres_State(:,1) = FootPres_Limit(:,1);
for i = 1:n
   if(FootPres_Pa(i,2) > 100)
       FootPres_State(i,2) = 1;
   end
end
figure;
plot(FootPres_State(:,1),FootPres_State(:,2).*20,'k');  %���ѹ��x
hold on;plot(IMU(:,1),IMU(:,4)*10,'-.');  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5)*50,'r-.');  %����
grid on;
legend('�ŵ�ѹ��״̬*20','�Ӽ�Z*10','����X*50');
xlabel('\it t \rm / s');       
title('ѹ��������ԭʼ����');

StateCorrect = 30;    %С��30��������� ״̬�仯 ��Ϊ�ǵ���  һ��������5ms
% �Դ��������о�ƫ ��������
TStartSerial = 2;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if FootPres_State(i,2) ~= FootPres_State(i-1,2)
        if StateNum >= StateCorrect
            %�����任
            TStartSerial = i;
            StateNum = 1;
        else
            %������
            FootPres_State(TStartSerial:i-1,2) = FootPres_State(TStartSerial-1,2);
            StateNum = StateNum+StateCorrect;
        end
    else
        StateNum = StateNum + 1;
    end
end

figure;
plot(FootPres_State(:,1),FootPres_State(:,2).*20,'r-');        
hold on;plot(IMU(:,1),IMU(:,4).*10,'-.');  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5).*50,'b-.');  %����
legend('��̬*20','�Ӽ�Z*10','����X*50');
xlabel('\it t \rm / s');       
title('���߲�̬�ж�(1��ֹ��0�˶�)');
grid on;

save(mDataPath,'FootPres_State','-append');

disp('*----------------��̬ʶ������ɣ�-----------------*');
disp('----------------------------------------------------');

function DataPrepare_FootState_PressWalk(mDataPath)
%% һ����ѹ��ԭʼ���ݽ��д��� 
%   �ž�ֹ����ѹ��������С����ѹС
%   ���˶�����ѹ��������󣬵�ѹ��
% 1. FootPres_Limit ��ȥ��ë��   880 ��Ӧ3.0938V ��Ӧ61Kŷ ��Ӧ 24g  ȥ��ԭʼ�����������ë�̺����ݻ���
load(mDataPath);      
[n,m] = size(FootPres);
FootPres_Limit = FootPres;
for j = 2:5
    for i = 1:n
        if FootPres_Limit(i,j) > 900
            FootPres_Limit(i,j) = 900;
        end   
    end
end
% ��ת  ��������ѹ��
for j = 2:5
    for i = 1:n
        FootPres_Limit(i,j) = (-1)*FootPres_Limit(i,j)+900;   
    end
end

figure;
plot(FootPres_Limit(:,1),FootPres_Limit(:,2),'k');  %���ѹ��x
hold on; plot(FootPres_Limit(:,1),FootPres_Limit(:,3),'r');  
hold on; plot(FootPres_Limit(:,1),FootPres_Limit(:,4),'g');
hold on; plot(FootPres_Limit(:,1),FootPres_Limit(:,5),'b');
hold on;plot(IMU(:,1),IMU(:,4)*100,'-.','LineWidth',2);  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5)*50,'r-.','LineWidth',2);  %����
grid on;
legend('�Ÿ��ڲ�','�Ÿ����','�����ڲ�','�������','�Ӽ�Z*10','����X*50');
xlabel('\it t \rm / s');       
title('ѹ��������ԭʼ����');

figure;
plot(FootPres_Limit(:,1),FootPres_Limit(:,2)+FootPres_Limit(:,3),'k');  %���ѹ��x
hold on; plot(FootPres_Limit(:,1),FootPres_Limit(:,4)+FootPres_Limit(:,5),'g');
hold on;plot(IMU(:,1),IMU(:,4)*10,'-.');  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5)*50,'r-.');  %����
grid on;
legend('�Ÿ�ѹ��','����ѹ��','�Ӽ�Z*10','����X*50');
xlabel('\it t \rm / s');       
title('ѹ��������ԭʼ����');


%% ������ת�����ѹ�� FootPres_Pa ���в�̬�ж� 
% 1. �Ȼ�ȡǰ���ƺͺ�Ÿ���ѹ������ �ֱ�ǰ �� ���������������
% �����趨 ��̬��������ʼʱ��ͽ���ʱ��  Ҳ����IMU�ߵ��������ʼʱ��ͽ���ʱ��
% ���������Ƴ�����������һ��������ʱ�䣬һ���Ǿ�ֹ����ʱ�䣬һ���ǵ�������ʱ��
FootPres_Pa = FootPres_Limit;
[n,m] = size(FootPres_Pa);
FootPres_Pa_front = zeros(n,2);  
FootPres_Pa_back = zeros(n,2);  
FootPres_Pa_back(:,1) = FootPres_Pa(:,1);
FootPres_Pa_front(:,1) = FootPres_Pa(:,1);
FootPres_Pa_back(:,2) = FootPres_Pa(:,2)+FootPres_Pa(:,3);
FootPres_Pa_front(:,2) = FootPres_Pa(:,4)+FootPres_Pa(:,5);

PresLimit = 20;   %ѹ����ֵ
StateCorrect = 30;
% 2. �ȴ����Ÿ������ݣ���Ϊ��Ÿ�����ʱ����أ����ҳ�����
%   һ�㿪�����˶����ھ�ֹ״̬�ģ����Կ������ݳ�ʼ�ĵ�һ��ѹ��ֵ�ж��Ƿ��ھ�ֹ״̬
[n,m] = size(FootPres_Pa_back);
% �����Ÿ���״̬
FootPreState_back = zeros(n,2);
FootPreState_back(:,1) = FootPres_Pa_back(:,1);
i = 0;
while i < n
    i = i+1;
    if i == 1
        %��ʼ�׶� ���ж�
        if FootPres_Pa_back(1,2) >= PresLimit
            %��ʼ��ֹ״̬
            FootPreState_back(1,2) = 1;
            i = i+1;
            while FootPres_Pa_back(i,2) >= PresLimit
                FootPreState_back(i,2) = 1;
                i = i+1;
            end
                FootPreState_back(i,2) = 0;
        else
            %��ʼ�˶�״̬
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
        %���˶� ���� ��ֹ
        FootPreState_back(i,2) = 1;
        continue;
    end        
    if (FootPreState_back(i-1,2) == 1) && (FootPres_Pa_back(i,2) < PresLimit)
        %�Ӿ�ֹ ���� �˶�
        FootPreState_back(i,2) = 0;  
        continue;
    end    
    FootPreState_back(i,2) = FootPreState_back(i-1,2);
end

% �Դ��������о�ƫ ��������
TStartSerial = 1;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if FootPreState_back(i,2) ~= FootPreState_back(i-1,2)
        if StateNum >= StateCorrect
            %�����任
            TStartSerial = i;
            StateNum = 1;
        else
            %������
            FootPreState_back(TStartSerial:i-1,2) = FootPreState_back(TStartSerial-1,2);
            StateNum = StateNum+StateCorrect;
        end
    else
        StateNum = StateNum + 1;
    end
end

% 3. ͬ�ϴ���ǰ��������
[n,m] = size(FootPres_Pa_front);
% ����ǰ���Ƶ�״̬
FootPreState_front = zeros(n,2);
FootPreState_front(:,1) = FootPres_Pa_front(:,1);
i = 0;
while i < n
    i = i+1;
    if i == 1
        %��ʼ�׶� ���ж�
        if FootPres_Pa_front(1,2) >= PresLimit
            %��ʼ��ֹ״̬
            FootPreState_front(1,2) = 1;
            i = i+1;
            while FootPres_Pa_front(i,2) >= PresLimit
                FootPreState_front(i,2) = 1;
                i = i+1;
            end
                FootPreState_front(i,2) = 0;
        else
            %��ʼ�˶�״̬
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
        %���˶� ���� ��ֹ
        FootPreState_front(i,2) = 1;
        continue;
    end        
    if (FootPreState_front(i-1,2) == 1) && (FootPres_Pa_front(i,2) < PresLimit)
        %�Ӿ�ֹ ���� �˶�
        FootPreState_front(i,2) = 0;  
        continue;
    end    
    FootPreState_front(i,2) = FootPreState_front(i-1,2);
end

% �Դ��������о�ƫ ��������
TStartSerial = 2;
StateNum = 1;
i = 1;
while i < n
    i = i+1;
    if FootPreState_front(i,2) ~= FootPreState_front(i-1,2)
        if StateNum >= StateCorrect
            %�����任
            TStartSerial = i;
            StateNum = 1;
        else
            %������
            FootPreState_front(TStartSerial:i-1,2) = FootPreState_front(TStartSerial-1,2);
            StateNum = StateNum+StateCorrect;
        end
    else
        StateNum = StateNum + 1;
    end
end

figure;
plot(FootPres_Pa_back(:,1),FootPres_Pa_back(:,2),'k');            %���ѹ��x
hold on; plot(FootPres_Pa_front(:,1),FootPres_Pa_front(:,2),'g');
hold on;plot(FootPreState_front(:,1),FootPreState_front(:,2).*100,'b-*');
hold on;plot(FootPreState_back(:,1),FootPreState_back(:,2).*150,'b-*');
title('�Ÿ� ���� ��̬�ж�State');
grid on;
legend('��Ÿ�״̬','ǰ����״̬','ǰ�����ж�','��Ÿ��ж�');
clear i m n StateNum TStartSerial;

%% ���� ����ǰ��ѹ���ж�״̬ ���� �ŵĲ�̬�ж�
% 1.���� ��Ÿ���״̬ FootPreState_back Ѱ�� ÿ���ӵع����е�ѹ����ֵ FootPres_Pa_back
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
            if (mIndex+mBegin_Serial-1+6) < n
                mIndex = mIndex+5;  %����ѹ�����������ӳ٣�����5������
            end
            FootPreState_back(mIndex+mBegin_Serial-1,2) = 2;
        end
        mBegin = 0;
        mEnd = 0;        
    end    
end

% 2.���� ǰ���Ƶ�״̬ FootPreState_front Ѱ�� ÿ���ӵع����е�ѹ����ֵ FootPres_Pa_front
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
%             if (mIndex+mBegin_Serial-1+6) < n
%                 mIndex = mIndex+6;  %����ѹ�����������ӳ٣�����6������
%             end
            FootPreState_front(mIndex+mBegin_Serial-1,2) = 2;
        end
        mBegin = 0;
        mEnd = 0;        
    end    
end

figure;
plot(FootPres_Pa_back(:,1),FootPres_Pa_back(:,2),'k');            %���ѹ��x
hold on; plot(FootPres_Pa_front(:,1),FootPres_Pa_front(:,2),'g');
hold on;plot(FootPreState_back(:,1),FootPreState_back(:,2)*1000,'b.-');
hold on;plot(FootPreState_front(:,1),FootPreState_front(:,2)*1500,'b.-');
title('�ŵ�ѹ��״̬ State');
grid on;
hold on;plot(IMU(:,1),IMU(:,4)*100,'-.');  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5)*500,'r-.');  %����
legend('��Ÿ�','ǰ����','��Ÿ��ж�*1000','ǰ�����ж�*1500');

% 3.��̬�ۺ��ж�
[n,m] = size(FootPreState_back);
FootPres_State = zeros(n,2);
FootPres_State(:,1) = FootPres(:,1);
mBegin = 0; mBegin_Serial = 0; 
mEnd = 0;   mEnd_Serial = 0; 
i = 0;
while i<n
    i = i+1;
    %��ͷ
    if i == 1
        %while (FootPreState_back(i,2)+FootPreState_front(i,2))>0
        while FootPreState_back(i,2)>0  %���ҽŸ���� ֮ǰΪ��̬
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
    % ��β����
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
plot(FootPres_State(:,1),FootPres_State(:,2).*3,'r-');        
hold on;plot(IMU(:,1),IMU(:,4),'-.');  %�Ӽ�
hold on;plot(IMU(:,1),IMU(:,5),'b-.');  %����
legend('��̬*3','�Ӽ�Z','����X');
xlabel('\it t \rm / s');       
title('���߲�̬�ж�(1��ֹ��0�˶�)');
grid on;

save(mDataPath,'FootPres_State','-append');

% ����һ����ֹʱ��εļ�¼
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
save(mDataPath,'StaticRecord','-append');


disp('*----------------��̬ʶ������ɣ�-----------------*');
disp('----------------------------------------------------');

% --- Executes on button press in pushbutton_FootState.
function pushbutton_FootState_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FootState (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%��̬ʶ�𷽷�ѡ��
global Choose_ZeroDetect

disp('----------------------------------------------------');
disp('*------------------��̬ʶ��ʼ����-----------------*');
[FootFileName,FootFilePath] = uigetfile('*.mat');
if isequal(FootFileName,0)
    disp('*-----------����·��Ϊ�գ��޷���ȡ���ݣ�------------*');    
    disp('----------------------------------------------------');
    return;
else  
    % ѹ�� ��ʼ�ж�
    if Choose_ZeroDetect == 1
        DataPrepare_FootState_PressStart([FootFilePath,FootFileName]);
        return;
    end
    
    % ѹ�� �����ж�
    if Choose_ZeroDetect == 2
        DataPrepare_FootState_PressWalk([FootFilePath,FootFileName]);
        return;
    end    
    
    % ��ͳ�����ж�
    if Choose_ZeroDetect == 3
        
        return;
    end          
end


% --- Executes just before IndividualNavigation_DataPrepare is made visible.
function figure1_CreateFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IndividualNavigation_DataPrepare (see VARARGIN)


% --- Executes when selected object is changed in uibuttongroup_ZeroDetecChoose.
function uibuttongroup_ZeroDetecChoose_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_ZeroDetecChoose 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%��̬ʶ�𷽷�ѡ��
global Choose_ZeroDetect
str = get(hObject,'tag');
switch str
    case 'radiobutton_FootStart'
        Choose_ZeroDetect = 1;
    case 'radiobutton_FootWalk'
        Choose_ZeroDetect = 2;     
    case 'radiobutton_FootIMU'
        Choose_ZeroDetect = 3;
end


