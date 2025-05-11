function varargout = GliaTrans_POI_SavingROIs(varargin)
% GLIATRANS_POI_SAVINGROIS MATLAB code for GliaTrans_POI_SavingROIs.fig
%      GLIATRANS_POI_SAVINGROIS, by itself, creates a new GLIATRANS_POI_SAVINGROIS or raises the existing
%      singleton*.
%
%      H = GLIATRANS_POI_SAVINGROIS returns the handle to a new GLIATRANS_POI_SAVINGROIS or the handle to
%      the existing singleton*.
%
%      GLIATRANS_POI_SAVINGROIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLIATRANS_POI_SAVINGROIS.M with the given input arguments.
%
%      GLIATRANS_POI_SAVINGROIS('Property','Value',...) creates a new GLIATRANS_POI_SAVINGROIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GliaTrans_POI_SavingROIs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GliaTrans_POI_SavingROIs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GliaTrans_POI_SavingROIs

% Last Modified by GUIDE v2.5 23-Feb-2016 23:05:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GliaTrans_POI_SavingROIs_OpeningFcn, ...
                   'gui_OutputFcn',  @GliaTrans_POI_SavingROIs_OutputFcn, ...
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


% --- Executes just before GliaTrans_POI_SavingROIs is made visible.
function GliaTrans_POI_SavingROIs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GliaTrans_POI_SavingROIs (see VARARGIN)

% Choose default command line output for GliaTrans_POI_SavingROIs
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GliaTrans_POI_SavingROIs wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% global FrameNum GliaTrans_GCh_inside GliaTrans_GCh_outside GliaTrans_GandR_inside GliaTrans_GandR_outside;


global FiletoStudy;

FilePathAll=get(mestaghandle(FiletoStudy), 1, 'FileName');

allfilesep=find(FilePathAll==filesep);
mysavingfolder=FilePathAll(1:allfilesep(end)-1);
mysavingname=FilePathAll(allfilesep(end)+1:end-4);
mysavingname(isspace(mysavingname))=[];       % delete the space in the file name, for the sake of MATLAB

cd(mysavingfolder);     % set the current folder in MATLAB for mysaving folder

set(handles.savingfolder,'String',mysavingfolder);
set(handles.videofilename,'String',['RoiInfo_',mysavingname,]);


% --- Outputs from this function are returned to the command line.
function varargout = GliaTrans_POI_SavingROIs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in SaveROIs.
function SaveROIs_Callback(hObject, eventdata, handles)
global myTimeTicks FrameTime RangeCutAll ROIcount myVideoGchOpt;

savingfolder=get(handles.savingfolder,'String');
savingfilename=get(handles.videofilename,'String');

   
% save to mat file for reload in the future
global avgFrame_3Ch presetcolor ROIPosAll FrameHeight HeightStep NoiseAllowPOI;
global ROI_RCh_SR101Wave_All ROI_GCh_CaWave_All ROI_GCh_nonCaWave_All ROI_GandR_CaWave_All ROI_GandR_nonCaWave_All;
global ExcludeROIsPos AstrocyteIndex NeuropilIndex NeuronIndex LegendAll POIThld;

save([savingfolder,filesep,savingfilename,'.mat'],'savingfolder','savingfilename','myTimeTicks','FrameTime','ROIcount',...
    'RangeCutAll','avgFrame_3Ch','presetcolor','ROIPosAll','FrameHeight','HeightStep','ROI_RCh_SR101Wave_All',...
    'ROI_GCh_CaWave_All','ROI_GCh_nonCaWave_All','ROI_GandR_CaWave_All','ROI_GandR_nonCaWave_All','NoiseAllowPOI',...
    'myVideoGchOpt','ExcludeROIsPos','AstrocyteIndex','NeuropilIndex','NeuronIndex','LegendAll','POIThld');

% append/save all the ROI infos into the same file
for i=1:ROIcount
    eval(['global ROI_masks_all_',LegendAll{i}]);
    save([savingfolder,filesep,savingfilename,'.mat'],['ROI_masks_all_',LegendAll{i}],'-append');
end    

% close current window
delete(get(hObject, 'parent'));    % close the current window/figure







function savingfolder_Callback(hObject, eventdata, handles)
% hObject    handle to savingfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savingfolder as text
%        str2double(get(hObject,'String')) returns contents of savingfolder as a double


% --- Executes during object creation, after setting all properties.
function savingfolder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savingfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function openfolder_Callback(hObject, eventdata, handles)
folder_name = uigetdir;
set(handles.savingfolder,'String',folder_name);


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% global ChFI presetcolor ROIcount ROIs FrameHeight FrameNum fig2_hds fig2_waves myTimeTicks fig3_hds fig3_waves fig4_hds fig4_waves text_hds;
        
  

function videofilename_Callback(hObject, eventdata, handles)
% hObject    handle to videofilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of videofilename as text
%        str2double(get(hObject,'String')) returns contents of videofilename as a double


% --- Executes during object creation, after setting all properties.
function videofilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to videofilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
