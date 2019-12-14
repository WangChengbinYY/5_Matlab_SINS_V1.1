function varargout = PedestrianNavigation(varargin)
% PEDESTRIANNAVIGATION MATLAB code for PedestrianNavigation.fig
%      PEDESTRIANNAVIGATION, by itself, creates a new PEDESTRIANNAVIGATION or raises the existing
%      singleton*.
%
%      H = PEDESTRIANNAVIGATION returns the handle to a new PEDESTRIANNAVIGATION or the handle to
%      the existing singleton*.
%
%      PEDESTRIANNAVIGATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PEDESTRIANNAVIGATION.M with the given input arguments.
%
%      PEDESTRIANNAVIGATION('Property','Value',...) creates a new PEDESTRIANNAVIGATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PedestrianNavigation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PedestrianNavigation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PedestrianNavigation

% Last Modified by GUIDE v2.5 10-Dec-2019 20:32:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PedestrianNavigation_OpeningFcn, ...
                   'gui_OutputFcn',  @PedestrianNavigation_OutputFcn, ...
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


% --- Executes just before PedestrianNavigation is made visible.
function PedestrianNavigation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PedestrianNavigation (see VARARGIN)

% Choose default command line output for PedestrianNavigation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PedestrianNavigation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PedestrianNavigation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
