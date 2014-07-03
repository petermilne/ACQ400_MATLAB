function varargout = DTACQ_Test_GUI(varargin)
% DTACQ_Test_GUI MATLAB code for DTACQ_Test_GUI.fig
%      DTACQ_Test_GUI, by itself, creates a new DTACQ_Test_GUI or raises the existing
%      singleton*.
%
%      H = DTACQ_Test_GUI returns the handle to a new DTACQ_Test_GUI or the handle to
%      the existing singleton*.
%
%      DTACQ_Test_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DTACQ_Test_GUI.M with the given input arguments.
%
%      DTACQ_Test_GUI('Property','Value',...) creates a new DTACQ_Test_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DTACQ_Test_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DTACQ_Test_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DTACQ_Test_GUI

% Last Modified by GUIDE v2.5 05-Feb-2014 16:15:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DTACQ_Test_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DTACQ_Test_GUI_OutputFcn, ...
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


% --- Executes just before DTACQ_Test_GUI is made visible.
function DTACQ_Test_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DTACQ_Test_GUI (see VARARGIN)

% Choose default command line output for DTACQ_Test_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DTACQ_Test_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DTACQ_Test_GUI_OutputFcn(hObject, eventdata, handles) 
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

disable_controls;
run3;
enable_controls;

% --- Executes on key press with focus on pushbutton1 and none of its controls.
function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

disable_controls;
run3;
enable_controls;


% --- Executes during object creation, after setting all properties.
function masterIP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to masterIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (evalin('base','exist(''UUTS1'',''var'')'))
    UUTS1 = evalin('base','UUTS1');
    set(hObject,'String',UUTS1);
else
    set(hObject,'String','Enter IP Address');
end


% --- Executes during object creation, after setting all properties.
function slave1_IP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slave1_IP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (evalin('base','exist(''UUTS2'',''var'')'))
    UUTS2 = evalin('base','UUTS2');
    set(hObject,'String',UUTS2);
else
    set(hObject,'String','Enter IP Address');
end


% --- Executes during object creation, after setting all properties.
function slave2_IP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slave2_IP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (evalin('base','exist(''UUTS3'',''var'')'))
    UUTS3 = evalin('base','UUTS3');
    set(hObject,'String',UUTS3);
else
    set(hObject,'String','Enter IP Address');
end


% --- Executes during object creation, after setting all properties.
function num_samp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_samp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (evalin('base','exist(''num_samp'',''var'')'))
    num_samp = evalin('base','num_samp');
    set(hObject,'String',num_samp);
else
    set(hObject,'String','Number of Samples');
end


% --- Executes during object creation, after setting all properties.
function clk_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

if (evalin('base','exist(''clk'',''var'')'))
    clk = evalin('base','clk');
    set(hObject,'String',clk);
else
    set(hObject,'String','''0'' for External Clk');
end


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
dtacq = imread('dtacq_logo.png');
image(dtacq);
axis off;


% --- Executes during object creation, after setting all properties.
function text7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%set(hObject,'BackgroundColor','red')

% --- Executes on button press in trigger.
function trigger_Callback(hObject, eventdata, handles)
% hObject    handle to trigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.trigger,'Visible','off');

% --- Executes on key press with focus on trigger and none of its controls.
function trigger_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to trigger (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(handles.trigger,'Visible','off');


% --- Executes during object creation, after setting all properties.
function text12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function masterIP_Callback(hObject, eventdata, handles)
% hObject    handle to masterIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of masterIP as text
%        str2double(get(hObject,'String')) returns contents of masterIP as a double



function slave1_IP_Callback(hObject, eventdata, handles)
% hObject    handle to slave1_IP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slave1_IP as text
%        str2double(get(hObject,'String')) returns contents of slave1_IP as a double



function slave2_IP_Callback(hObject, eventdata, handles)
% hObject    handle to slave2_IP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slave2_IP as text
%        str2double(get(hObject,'String')) returns contents of slave2_IP as a double



function num_samp_Callback(hObject, eventdata, handles)
% hObject    handle to num_samp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_samp as text
%        str2double(get(hObject,'String')) returns contents of num_samp as a double



function clk_Callback(hObject, eventdata, handles)
% hObject    handle to clk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clk as text
%        str2double(get(hObject,'String')) returns contents of clk as a double
