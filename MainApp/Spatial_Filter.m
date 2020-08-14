function varargout = Spatial_Filter(varargin)
% SPATIAL_FILTER MATLAB code for Spatial_Filter.fig
%      SPATIAL_FILTER, by itself, creates a new SPATIAL_FILTER or raises the existing
%      singleton*.
%
%      H = SPATIAL_FILTER returns the handle to a new SPATIAL_FILTER or the handle to
%      the existing singleton*.
%
%      SPATIAL_FILTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPATIAL_FILTER.M with the given input arguments.
%
%      SPATIAL_FILTER('Property','Value',...) creates a new SPATIAL_FILTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Spatial_Filter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Spatial_Filter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Spatial_Filter

% Last Modified by GUIDE v2.5 14-Aug-2020 21:46:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Spatial_Filter_OpeningFcn, ...
                   'gui_OutputFcn',  @Spatial_Filter_OutputFcn, ...
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


% --- Executes just before Spatial_Filter is made visible.
function Spatial_Filter_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

clc;
clearStr = 'clear all';
evalin('base',clearStr);

global v
assignin('base','vid',videoinput('winvideo'));
v= evalin('base','vid');

% UIWAIT makes Spatial_Filter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Spatial_Filter_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_ACTX.
function pushbutton_ACTX_Callback(hObject, eventdata, handles)
    global xpiezo ypiezo zpiezo
    
    xpiezo = actxcontrol('MGPIEZO.MGPiezoCtrl.1', [400 520 350 210]);
    ypiezo = actxcontrol('MGPIEZO.MGPiezoCtrl.1', [400 270 350 210]);
    zpiezo = actxcontrol('MGPIEZO.MGPiezoCtrl.1', [400 20 350 210]);
    
    xpiezo.StartCtrl;
    ypiezo.StartCtrl;
    zpiezo.StartCtrl;
    
    SNy = 81834941;
    SNz = 81835244;
    SNx = 81835248;
    
    set(xpiezo,'HWSerialNum', SNx);
    set(ypiezo,'HWSerialNum', SNy);
    set(zpiezo,'HWSerialNum', SNz);
    
    xpiezo.Identify;
    ypiezo.Identify;
    zpiezo.Identify;
    
    % SETS piezos to Position Zero
    xpiezo.SetVoltOutput(0,0);
    ypiezo.SetVoltOutput(0,0);
    zpiezo.SetVoltOutput(0,0);

    % SETS piezos' Jog step size to 5 V
    xpiezo.SetJogStepSize(0,5);
    ypiezo.SetJogStepSize(0,5);
    zpiezo.SetJogStepSize(0,5);
    
    pause(1);
    set(handles.textXaxis,'Enable','On');
    set(handles.textYaxis,'Enable','On');
    set(handles.textZaxis,'Enable','On');
    set(handles.pushbutton_POSITION,'Enable','On');
    set(handles.text_POSITION,'Enable','On');


% --- Executes on button press in pushbutton_POSITION.
function pushbutton_POSITION_Callback(hObject, eventdata, handles)
    global xpiezo ypiezo zpiezo
    % SETS piezos to Mid-range Position
    xpiezo.SetVoltOutput(0,75);
    ypiezo.SetVoltOutput(0,75);
    zpiezo.SetVoltOutput(0,60);
    set(handles.pushbutton_ACTX,'Enable','Off');
    set(handles.pushbutton_FOLDER,'Enable','On');
    set(handles.text_FOLDER,'Enable','On');


% --- Executes on button press in pushbutton_FOLDER.
function pushbutton_FOLDER_Callback(hObject, eventdata, handles)
    selpath = uigetdir('C:\');
    set(handles.text_FOLDER,'foregroundcolor','black',...
        'string', convertCharsToStrings(selpath));
    set(handles.pushbutton_IMAQTOOL,'Enable','On');
    set(handles.pushbutton_CAMERA,'Enable','On');
    set(handles.edit_FORMAT,'Enable','On');
    set(handles.edit_ROI,'Enable','On');
    set(handles.text_FORMAT,'Enable','On');
    set(handles.text_ROI,'Enable','On');


% --- Executes on button press in pushbutton_IMAQTOOL.
function pushbutton_IMAQTOOL_Callback(hObject, eventdata, handles)
    global v
    delete(v);
    pause(0.5);

    imaqtool;


% --- Executes on button press in pushbutton_CAMERA.
function pushbutton_CAMERA_Callback(hObject, eventdata, handles)
    global nn mm imgGray v varStart varStop
    delete(v);

    Format = get(handles.edit_FORMAT,'String');
    ROI = str2num(get(handles.edit_ROI,'String'));
    
% 	vid = videoinput('winvideo', 1, Format);
    assignin('base','vid',videoinput('winvideo', 1, Format));   % Create new variable 'vid' to workspace
    v=evalin('base','vid');
%     vid = videoinput('winvideo', 1, Format,...
%         'returnedcolorspace','grayscale');
	v.FramesPerTrigger = 1;
	v.ROIPosition = ROI;
	himage=image(zeros(ROI(3), ROI(4),1),'parent', handles.axes1);
	preview(v,himage);
    
     set(handles.pushbutton_START,'Enable','On',...
        'backgroundcolor','green');
    


function edit_FORMAT_Callback(hObject, eventdata, handles)
% hObject    handle to edit_FORMAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit_FORMAT_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ROI_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function edit_ROI_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_START.
function pushbutton_START_Callback(hObject, eventdata, handles)
    set(handles.pushbutton_POSITION,'Enable','Off');
    set(handles.text_POSITION,'Enable','Off');
    
    set(handles.pushbutton_FOLDER,'Enable','Off');
    set(handles.text_FOLDER,'Enable','Off');
    
    set(handles.pushbutton_IMAQTOOL,'Enable','Off');
    set(handles.pushbutton_CAMERA,'Enable','Off');
    
    set(handles.edit_FORMAT,'Enable','Off');
    set(handles.text_FORMAT,'Enable','Off');
    
    set(handles.edit_ROI,'Enable','Off');
    set(handles.text_ROI,'Enable','Off');
    
    set(handles.pushbutton_EXIT,'Enable','Off');
    
    pause(1);
    set(handles.pushbutton_START,'Enable','Off',...
        'backgroundcolor', [0.94,0.94,0.94]);
    set(handles.pushbutton_STOP,'Enable','On',...
        'backgroundcolor','red');
    
    global s b
    s=1;
    b=1;
    sequence;


% --- Executes on button press in pushbutton_STOP.
function pushbutton_STOP_Callback(hObject, eventdata, handles)
    global xpiezo ypiezo s b
    b=0;
    sequence;
    s=0;
    
    pause(0.2)
    xpiezo.SetVoltOutput(0,0);
    ypiezo.SetVoltOutput(0,0);

    set(handles.pushbutton_POSITION,'Enable','On');
    set(handles.text_POSITION,'Enable','On');
    
    set(handles.pushbutton_FOLDER,'Enable','On');
    set(handles.text_FOLDER,'Enable','On');
    
    set(handles.pushbutton_IMAQTOOL,'Enable','On');
    set(handles.pushbutton_CAMERA,'Enable','On');
    
    set(handles.edit_FORMAT,'Enable','On');
    set(handles.text_FORMAT,'Enable','On');
    
    set(handles.edit_ROI,'Enable','On');
    set(handles.text_ROI,'Enable','On');
    
%     pause(1);
    set(handles.pushbutton_START,'Enable','On',...
        'backgroundcolor', 'green');
    set(handles.pushbutton_STOP,'Enable','Off',...
        'backgroundcolor',[0.94,0.94,0.94]);
    
    set(handles.pushbutton_EXIT,'Enable','On');


% --- Executes on key press with focus on edit_FORMAT and none of its controls.
function edit_FORMAT_KeyPressFcn(hObject, eventdata, handles)
    stringFormat = get(hObject, 'String');
    if isempty(stringFormat)
        set(handles.text_FORMAT, 'ForegroundColor', [1,0,0]);
    else
        set(handles.text_FORMAT, 'ForegroundColor', [0,0,0]);
    end



% --- Executes on key press with focus on edit_ROI and none of its controls.
function edit_ROI_KeyPressFcn(hObject, eventdata, handles)
    stringROI = get(hObject, 'String');
    if isempty(stringROI)
        set(handles.text_ROI, 'ForegroundColor', [1,0,0]);
    else
        set(handles.text_ROI, 'ForegroundColor', [0,0,0]);
    end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
%     global varStart varStop
%     varStop=1;
%     vid_img(handles);
%     pause(0.5);
%     varStart = 0;


% --- Executes on button press in pushbutton_EXIT.
function pushbutton_EXIT_Callback(hObject, eventdata, handles)
    
% Clear the command window
clc;

% Clear the variables
clearStr = 'clear all';
evalin('base',clearStr);

% Delete the figure
delete(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

% Hint: delete(hObject) closes the figure
% delete(hObject);
