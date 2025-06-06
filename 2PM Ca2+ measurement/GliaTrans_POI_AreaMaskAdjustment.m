function varargout = GliaTrans_POI_AreaMaskAdjustment(varargin)
% GLIATRANS_POI_AREAMASKADJUSTMENT MATLAB code for GliaTrans_POI_AreaMaskAdjustment.fig
%      GLIATRANS_POI_AREAMASKADJUSTMENT, by itself, creates a new GLIATRANS_POI_AREAMASKADJUSTMENT or raises the existing
%      singleton*.
%
%      H = GLIATRANS_POI_AREAMASKADJUSTMENT returns the handle to a new GLIATRANS_POI_AREAMASKADJUSTMENT or the handle to
%      the existing singleton*.
%
%      GLIATRANS_POI_AREAMASKADJUSTMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLIATRANS_POI_AREAMASKADJUSTMENT.M with the given input arguments.
%
%      GLIATRANS_POI_AREAMASKADJUSTMENT('Property','Value',...) creates a new GLIATRANS_POI_AREAMASKADJUSTMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GliaTrans_POI_AreaMaskAdjustment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GliaTrans_POI_AreaMaskAdjustment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GliaTrans_POI_AreaMaskAdjustment

% Last Modified by GUIDE v2.5 21-Aug-2022 22:49:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GliaTrans_POI_AreaMaskAdjustment_OpeningFcn, ...
                   'gui_OutputFcn',  @GliaTrans_POI_AreaMaskAdjustment_OutputFcn, ...
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


% --- Executes just before GliaTrans_POI_AreaMaskAdjustment is made visible.
function GliaTrans_POI_AreaMaskAdjustment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GliaTrans_POI_AreaMaskAdjustment (see VARARGIN)

% Choose default command line output for GliaTrans_POI_AreaMaskAdjustment
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GliaTrans_POI_AreaMaskAdjustment wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GliaTrans_POI_AreaMaskAdjustment_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function MaskThld_Callback(hObject, eventdata, handles)
% hObject    handle to MaskThld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function MaskThld_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaskThld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ThldSet_Callback(hObject, eventdata, handles)
% hObject    handle to ThldSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThldSet as text
%        str2double(get(hObject,'String')) returns contents of ThldSet as a double


% --- Executes during object creation, after setting all properties.
function ThldSet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThldSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


