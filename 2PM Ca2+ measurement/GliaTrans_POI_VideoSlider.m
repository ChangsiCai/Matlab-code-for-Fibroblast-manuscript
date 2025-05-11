function varargout = GliaTrans_POI_VideoSlider(varargin)
% GLIATRANS_POI_VIDEOSLIDER MATLAB code for GliaTrans_POI_VideoSlider.fig
%      GLIATRANS_POI_VIDEOSLIDER, by itself, creates a new GLIATRANS_POI_VIDEOSLIDER or raises the existing
%      singleton*.
%
%      H = GLIATRANS_POI_VIDEOSLIDER returns the handle to a new GLIATRANS_POI_VIDEOSLIDER or the handle to
%      the existing singleton*.
%
%      GLIATRANS_POI_VIDEOSLIDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLIATRANS_POI_VIDEOSLIDER.M with the given input arguments.
%
%      GLIATRANS_POI_VIDEOSLIDER('Property','Value',...) creates a new GLIATRANS_POI_VIDEOSLIDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GliaTrans_POI_VideoSlider_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GliaTrans_POI_VideoSlider_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GliaTrans_POI_VideoSlider

% Last Modified by GUIDE v2.5 23-Feb-2016 23:05:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GliaTrans_POI_VideoSlider_OpeningFcn, ...
                   'gui_OutputFcn',  @GliaTrans_POI_VideoSlider_OutputFcn, ...
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


% --- Executes just before GliaTrans_POI_VideoSlider is made visible.
function GliaTrans_POI_VideoSlider_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GliaTrans_POI_VideoSlider (see VARARGIN)

% Choose default command line output for GliaTrans_POI_VideoSlider
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global ROIcount presetcolor ChFI FrameHeight FFST FrameNum myVideoGch0 myVideoGchOpt handlesVideoDrag handleshowMovie handlesslidertitle BaseLineFrameNo ROIPosAll RangeCutAll;
global handleshowMovie2 myVideo myVideoR myVideoRch0 myVideoGch0 useNew myVideoR_New myVideo_New;
% for i=1:ROIcount
%     eval(['global AllFrameROI_Range_',num2str(i)]);
%     eval(['global AllFrameROI_Real_',num2str(i)]);
% end


% % %%% get image stack of ChFI of all frames 
% mymin3=min(min(min(myVideoGch0)));
% mymax3=max(max(max(myVideoGch0)));
% myVideoGch0=255*(myVideoGch-mymin3)/(mymax3-mymin3);
% 
% % %%% get image stack of ChFI of all frames 
% mymin3=min(min(min(myVideoRch0)));
% mymax3=max(max(max(myVideoRch0)));
% myVideoRch0=255*(myVideoRch-mymin3)/(mymax3-mymin3);


% handles mark
handlesVideoDrag=handles.VideoDrag;
handleshowMovie=handles.showMovie;
handleshowMovie2=handles.showMovie2;
handlesslidertitle=handles.SliderTitle;

% % adjust the brigthness of the video
% myVideoGch0=myVideoGch;
% ReferenceImg=myVideoGch0(:,:,1);
% myVideoGch0(:,:,1) = imadjust(ReferenceImg);
% for i=2:30
%     myVideoGch0(:,:,i)=imhistmatch(myVideoGch0(:,:,i),ReferenceImg);
%     
% end

%%% green channel
axes(handles.showMovie);hold on;
if useNew
    imagesc(myVideoR_New(:,:,1));
else
    imagesc(myVideoR(:,:,1));
end
% imagesc(myVideoGch0(:,:,2).');
set(handles.showMovie, 'Xdir', 'reverse');
colormap(gray);
axis equal;
axis off;
axis ij;
set(handles.VideoDrag,'Min',1);
set(handles.VideoDrag,'Max',FrameNum);
set(handles.VideoDrag,'Value',1);
set(handles.VideoDrag, 'SliderStep', [1/FrameNum , 1/FrameNum]);
set(handles.SliderTitle,'String',['FrameNo: 1/',num2str(FrameNum),' (',num2str(FFST/1000),'s)']);


if ~isempty(ROIPosAll)
    for i=1:ROIcount
        ROIpos=ROIPosAll{i};
        if 2>=RangeCutAll(i,1) && 2<=RangeCutAll(i,2)
            plot(ROIpos(:,1),ROIpos(:,2),presetcolor(i),'LineWidth',2,'Parent',handleshowMovie);
%             rectangle('Position',ROIPosAll{i},'EdgeColor',presetcolor(i),'LineWidth',2,'Parent',handleshowMovie);
        else
            plot(ROIpos(:,1),ROIpos(:,2),presetcolor(i),'LineWidth',2,'LineStyle','--','Parent',handleshowMovie);
%             rectangle('Position',ROIPosAll{i},'EdgeColor',presetcolor(i),'LineWidth',1,'LineStyle','--','Parent',handleshowMovie);
        end
    end
end

%%% red channel
axes(handles.showMovie2);hold on;
if useNew
    imagesc(myVideo_New(:,:,2));
else
    imagesc(myVideo(:,:,2));
end
% imagesc(myVideoRch0(:,:,2).');
set(handles.showMovie2, 'Ydir', 'reverse');
colormap(gray);
axis equal;
axis off;
axis ij;
if ~isempty(ROIPosAll)
    for i=1:ROIcount
        ROIpos=ROIPosAll{i};
        if 2>=RangeCutAll(i,1) && 2<=RangeCutAll(i,2)
            plot(ROIpos(:,1),ROIpos(:,2),presetcolor(i),'LineWidth',2,'Parent',handleshowMovie2);
%             rectangle('Position',ROIPosAll{i},'EdgeColor',presetcolor(i),'LineWidth',2,'Parent',handleshowMovie2);
        else
            plot(ROIpos(:,1),ROIpos(:,2),presetcolor(i),'LineWidth',2,'LineStyle','--','Parent',handleshowMovie2);
%             rectangle('Position',ROIPosAll{i},'EdgeColor',presetcolor(i),'LineWidth',1,'LineStyle','--','Parent',handleshowMovie2);
        end
    end
end


% once the slider moves, it will call function UpdateImg
addlistener(handles.VideoDrag,'Value','PostSet',@UpdateImg);



function UpdateImg(~,~)
% This function is to update the showMovie during the dragging of slider
global ROIcount myVideo myVideoGch0 myVideoR_New useNew myVideo_New handlesVideoDrag handleshowMovie handlesslidertitle handlesshowSTI presetcolor FFST FrameTime FrameNum STITimeTicks ROIPosAll RangeCutAll myVideoR handleshowMovie2 myVideoRch0;

% GREEN CHANNEL
cla(handleshowMovie);

SPos=get(handlesVideoDrag,'Value');
if useNew
    imagesc(myVideoR_New(:,:,round(SPos)),'Parent',handleshowMovie);
else
    imagesc(myVideoR(:,:,round(SPos)),'Parent',handleshowMovie);
end
% imagesc(myVideoGch0(:,:,round(SPos)).','Parent',handleshowMovie);

if ~isempty(ROIPosAll)
    for i=1:ROIcount
        ROIpos=ROIPosAll{i};
        if round(SPos)>=RangeCutAll(i,1) && round(SPos)<=RangeCutAll(i,2)
            plot(ROIpos(:,1),ROIpos(:,2),presetcolor(i),'LineWidth',2,'Parent',handleshowMovie);
        else
            plot(ROIpos(:,1),ROIpos(:,2),presetcolor(i),'LineWidth',2,'LineStyle','--','Parent',handleshowMovie);
        end
    end
end

% RED CHANNEL
cla(handleshowMovie2);
if useNew
    imagesc(myVideo_New(:,:,round(SPos)),'Parent',handleshowMovie2);
else
    imagesc(myVideo(:,:,round(SPos)),'Parent',handleshowMovie2);
end
% imagesc(myVideoRch0(:,:,round(SPos)).','Parent',handleshowMovie2);

if ~isempty(ROIPosAll)
    for i=1:ROIcount
        ROIpos=ROIPosAll{i};
        if round(SPos)>=RangeCutAll(i,1) && round(SPos)<=RangeCutAll(i,2)
            plot(ROIpos(:,1),ROIpos(:,2),presetcolor(i),'LineWidth',2,'Parent',handleshowMovie2);
        else
            plot(ROIpos(:,1),ROIpos(:,2),presetcolor(i),'LineWidth',2,'LineStyle','--','Parent',handleshowMovie2);
        end
    end
end

set(handlesslidertitle,'String',['FrameNo: ',num2str(round(SPos)),'/',num2str(FrameNum),' (',num2str((FFST+round(SPos)*FrameTime)/1000),'s)']);



% --- Outputs from this function are returned to the command line.
function varargout = GliaTrans_POI_VideoSlider_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function VideoDrag_Callback(hObject, eventdata, handles)
% global FrameNum myVideo ROIcount presetcolor;
% for i=1:ROIcount
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
