function varargout = VesselDiameter_VideoSlider(varargin)
% VESSELDIAMETER_VIDEOSLIDER MATLAB code for VesselDiameter_VideoSlider.fig
%      VESSELDIAMETER_VIDEOSLIDER, by itself, creates a new VESSELDIAMETER_VIDEOSLIDER or raises the existing
%      singleton*.
%
%      H = VESSELDIAMETER_VIDEOSLIDER returns the handle to a new VESSELDIAMETER_VIDEOSLIDER or the handle to
%      the existing singleton*.
%
%      VESSELDIAMETER_VIDEOSLIDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VESSELDIAMETER_VIDEOSLIDER.M with the given input arguments.
%
%      VESSELDIAMETER_VIDEOSLIDER('Property','Value',...) creates a new VESSELDIAMETER_VIDEOSLIDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VesselDiameter_VideoSlider_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VesselDiameter_VideoSlider_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VesselDiameter_VideoSlider

% Last Modified by GUIDE v2.5 17-Feb-2016 15:07:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VesselDiameter_VideoSlider_OpeningFcn, ...
                   'gui_OutputFcn',  @VesselDiameter_VideoSlider_OutputFcn, ...
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


% --- Executes just before VesselDiameter_VideoSlider is made visible.
function VesselDiameter_VideoSlider_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VesselDiameter_VideoSlider (see VARARGIN)

% Choose default command line output for VesselDiameter_VideoSlider
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global useNew vesselcount presetcolor ChFI FrameHeight FFST FrameNum myVideo myVideo_New handlesVideoDrag handleshowMovie handlesslidertitle handlesshowSTI BaseLineFrameNo;
for i=1:vesselcount
    eval(['global AllFrameROI_',num2str(i)]);
end


handlesVideoDrag=handles.VideoDrag;
handleshowMovie=handles.showMovie;
handlesslidertitle=handles.SliderTitle;
handlesshowSTI=handles.showSTI;




axes(handles.showMovie);hold on;
% set(gcf,'units','normalized','outerposition',[0 0 1 1]);
% if useNew
%     imagesc(myVideo_New(:,:,2));
% else
%     imagesc(myVideo(:,:,2));
% end
if useNew
    imagesc(myVideo_New(:,:,2));
else
    imagesc(myVideo(:,:,2));
end
set(handles.showMovie, 'Ydir', 'reverse');
colormap(gray);
axis equal;
axis off;
axis ij;
set(handles.VideoDrag,'Min',1);
set(handles.VideoDrag,'Max',FrameNum);
set(handles.VideoDrag,'Value',1);
set(handles.VideoDrag, 'SliderStep', [1/FrameNum , 1/FrameNum]);
set(handles.SliderTitle,'String',['Stack No:1/',num2str(FrameNum),' (',num2str(FFST/1000),'s)']);
set(handles.showSTI,'Visible','off');

if exist('AllFrameROI_1') && ~isempty(AllFrameROI_1)
    for i=1:vesselcount
        eval(['ROIposc=AllFrameROI_',num2str(i),'(:,:,1);']);
        plot(ROIposc(:,1),ROIposc(:,2),'Color',presetcolor{i},'Parent',handleshowMovie,'LineWidth',1.5);
    end
end


% once the slider moves, it will call function UpdateImg
addlistener(handles.VideoDrag,'Value','PostSet',@UpdateImg);



function UpdateImg(~,~)
% This function is to update the showMovie during the dragging of slider
global useNew vesselcount myVideo myVideo_New handlesVideoDrag handleshowMovie handlesslidertitle handlesshowSTI presetcolor FFST FrameTime FrameNum STITimeTicks;
for i=1:vesselcount
    eval(['global AllFrameROI_',num2str(i)]);
end

cla(handleshowMovie);

SPos=get(handlesVideoDrag,'Value');
if useNew
    imagesc(myVideo_New(:,:,round(SPos)),'Parent',handleshowMovie);
else
    imagesc(myVideo(:,:,round(SPos)),'Parent',handleshowMovie);
end
% axis('equal','Parent',handleshowMovie);
% axis('off','Parent',handleshowMovie);

if exist('AllFrameROI_1') && ~isempty(AllFrameROI_1)
    for i=1:vesselcount
        eval(['ROIposc=AllFrameROI_',num2str(i),'(:,:,round(SPos));']);
        plot(ROIposc(:,1),ROIposc(:,2),'Color',presetcolor{i},'Parent',handleshowMovie,'LineWidth',1.5);
    end
end

set(handlesslidertitle,'String',['Stack No:',num2str(round(SPos)),'/',num2str(FrameNum),' (',num2str((FFST+round(SPos)*FrameTime)/1000),'s)']);

if length(STITimeTicks)~=0
    if round(SPos)*FrameTime/1000>=STITimeTicks(1) && round(SPos)*FrameTime/1000<=STITimeTicks(end)
        set(handlesshowSTI,'Visible','on');
    else
        set(handlesshowSTI,'Visible','off');
    end
else
    set(handlesshowSTI,'Visible','off');
end



% --- Outputs from this function are returned to the command line.
function varargout = VesselDiameter_VideoSlider_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function VideoDrag_Callback(hObject, eventdata, handles)
% global FrameNum myVideo vesselcount presetcolor;
% for i=1:vesselcount
%     eval(['global AllFrameROI_',num2str(i)]);
% end
% 
% 
% SliderPos=get(handles.VideoDrag,'Value');
% 
% axes(handles.showMovie);
% % set(gcf,'units','normalized','outerposition',[0 0 1 1]);
% imagesc(myVideo(:,:,round(SliderPos)).');
% axis equal;
% axis off;
% colormap(gray);



% --- Executes during object creation, after setting all properties.
function VideoDrag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoDrag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
