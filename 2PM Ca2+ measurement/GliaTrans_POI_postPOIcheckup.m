function varargout = GliaTrans_POI_postPOIcheckup(varargin)
% GLIATRANS_POI_POSTPOICHECKUP MATLAB code for GliaTrans_POI_postPOIcheckup.fig
%      GLIATRANS_POI_POSTPOICHECKUP, by itself, creates a new GLIATRANS_POI_POSTPOICHECKUP or raises the existing
%      singleton*.
%
%      H = GLIATRANS_POI_POSTPOICHECKUP returns the handle to a new GLIATRANS_POI_POSTPOICHECKUP or the handle to
%      the existing singleton*.
%
%      GLIATRANS_POI_POSTPOICHECKUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLIATRANS_POI_POSTPOICHECKUP.M with the given input arguments.
%
%      GLIATRANS_POI_POSTPOICHECKUP('Property','Value',...) creates a new GLIATRANS_POI_POSTPOICHECKUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GliaTrans_POI_postPOIcheckup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GliaTrans_POI_postPOIcheckup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GliaTrans_POI_postPOIcheckup

% Last Modified by GUIDE v2.5 23-Feb-2016 23:04:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GliaTrans_POI_postPOIcheckup_OpeningFcn, ...
                   'gui_OutputFcn',  @GliaTrans_POI_postPOIcheckup_OutputFcn, ...
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


% --- Executes just before GliaTrans_POI_postPOIcheckup is made visible.
function GliaTrans_POI_postPOIcheckup_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GliaTrans_POI_postPOIcheckup (see VARARGIN)

% Choose default command line output for GliaTrans_POI_postPOIcheckup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GliaTrans_POI_postPOIcheckup wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global FrameNum handlesPOImovie handlesPOIslidder handlesPOItitle handlesPOITimeCourse ROI_RCh ROI_GCh ROI_masks_all FFST hFrameMarkLine hThldLine1 hThldLine2;
global ROI_GCh_CaWave ROI_GCh_nonCaWave hFrameMarkLine_GCh handlesCaInOutside handlesGreenMovie FrameTime RangeCut1 RangeCut2 AorN;
global NeuronIndex AstrocyteIndex ROI_masks_all_2GCh ROI_BW_Mask;

% preset the interface
handlesPOImovie=handles.POImovie;
handlesPOIslidder=handles.POIslidder;
handlesPOITimeCourse=handles.POITimeCourse;
handlesPOItitle=handles.POITitle;
handlesGreenMovie=handles.GreenMovie;
handlesCaInOutside=handles.CaInOutside;


% set the poi movie for sr101
axes(handles.POImovie);hold on;
RedImgMasked=ROI_RCh(:,:,2).*ROI_BW_Mask;
imagesc(RedImgMasked);
[row,col]=find(ROI_masks_all(:,:,2));
if AorN==1
    plot(col,row,'r.');
elseif AorN==2
    plot(col,row,'g.');
end
set(handles.POImovie, 'Ydir', 'reverse');
colormap(gray);
axis image;
axis off;
axis ij;

% set the green ch movie for ca
axes(handles.GreenMovie);hold on;
GreenImgMasked=ROI_GCh(:,:,2).*ROI_BW_Mask;
imagesc(GreenImgMasked);
if AorN==1
    plot(col,row,'r.');
    
%     [row1,col1]=find(ROI_masks_all_2GCh(:,:,2));
%     plot(row1,col1,'g.');
%  
%     [row2,col2]=find(ROI_masks_all_2GCh(:,:,2).*ROI_masks_all(:,:,2));
%     plot(row2,col2,'y.');  
elseif AorN==2
    plot(col,row,'g.');
end
% [row0,col0]=find(ROI_masks_all(:,:,2)==0);
% plot(row0,col0,'k.');
set(handles.GreenMovie, 'Ydir', 'reverse');
colormap(gray);
axis image;
axis off;
axis ij;


% set the slidder
set(handles.POIslidder,'Min',1);
set(handles.POIslidder,'Max',FrameNum);
set(handles.POIslidder,'Value',1);
set(handles.POIslidder, 'SliderStep', [1/FrameNum , 1/FrameNum]);
if AorN==1   % astrocyte
    set(handles.POITitle,'String',['a',num2str(length(AstrocyteIndex)),'_','FrameNo: 1/',num2str(FrameNum),' (',num2str(FFST/1000),'s)']);
elseif AorN==2  % neuron
    set(handles.POITitle,'String',['n',num2str(length(NeuronIndex)),'_','FrameNo: 1/',num2str(FrameNum),' (',num2str(FFST/1000),'s)']);
end

% the lower POITimeCourse for SR101 channel
SR101pixelnum=zeros(1,FrameNum);
for i=1:FrameNum
    eachMask=ROI_masks_all(:,:,i);
    SR101pixelnum(i)=length(find(eachMask));
end
axes(handles.POITimeCourse);hold on;
plot(1:FrameNum,SR101pixelnum(1:end),'k','LineWidth',1);
xlim([0 FrameNum+1]);
xlabel('\fontsize{12}Frame Num');
ylabel('\fontsize{12}Num of pixels');
mylim=get(gca,'ylim'); 
hFrameMarkLine=line([2 2],mylim,'Color','r','LineStyle','--');


% set the two draggable vertical lines in the lower POITimeCourse
% set the starting lines
hThldLine1=line([RangeCut1 RangeCut1],mylim,'Color','b','LineWidth',2);
hThldLine2=line([RangeCut2 RangeCut2],mylim,'Color','b','LineWidth',2);
draggable(hThldLine1,'h');
draggable(hThldLine2,'h');



% the Ca signal inside and outside the astrocyte in the CaInOutside window
%normalize
BaselineLength = 10;   % 30 frames as baseline for normalization
ROI_GCh_CaWave_forcheckup=ROI_GCh_CaWave;
ROI_GCh_CaWave_forcheckup = ROI_GCh_CaWave_forcheckup./mean(ROI_GCh_CaWave_forcheckup(2:BaselineLength));
ROI_GCh_nonCaWave_forcheckup=ROI_GCh_nonCaWave;
ROI_GCh_nonCaWave_forcheckup = ROI_GCh_nonCaWave_forcheckup./mean(ROI_GCh_nonCaWave_forcheckup(2:BaselineLength));
%plot
axes(handles.CaInOutside);
hold on;
plot(1:FrameNum,ROI_GCh_nonCaWave_forcheckup(1:end),'k','LineWidth',1);
plot(1:FrameNum,ROI_GCh_CaWave_forcheckup(1:end),'g','LineWidth',2);
xlim([0 FrameNum+1]);
xlabel('\fontsize{12}Frame Num');
ylabel('\fontsize{12}Normalized mean intensity');
if AorN==1   % astrocyte
   legend('OutsideGCh','InsideGCh for red dots'); 
elseif AorN==2
    legend('OutsideGCh','InsideGCh for green dots');
end

mylim=get(gca,'ylim'); 
hFrameMarkLine_GCh=line([2 2],mylim,'Color','r','LineStyle','--');







% once the slider moves, it will call function UpdateImg
addlistener(handles.POIslidder,'Value','PostSet',@UpdatePOIImg);



function UpdatePOIImg(~,~)
% This function is to update the POImovie and TimeCourse during the dragging of slider

global ROI_GCh FrameTime FrameNum handlesPOImovie handlesPOIslidder handlesPOItitle handlesPOITimeCourse ROI_RCh ROI_masks_all FFST hFrameMarkLine hFrameMarkLine_GCh;
global handlesCaInOutside handlesGreenMovie ROI_GCh_CaWave AorN AstrocyteIndex NeuronIndex ROI_masks_all_2GCh ROI_BW_Mask;


% plot the left upper movie
axes(handlesPOImovie);hold on;
cla(handlesPOImovie);
SPos=get(handlesPOIslidder,'Value');
RedImgMasked=ROI_RCh(:,:,round(SPos)).*ROI_BW_Mask;
imagesc(RedImgMasked,'Parent',handlesPOImovie);
[row,col]=find(ROI_masks_all(:,:,round(SPos)));
if AorN==1
    plot(col,row,'r.');
elseif AorN==2
    plot(col,row,'g.');
end
if AorN==1   % astrocyte
    set(handlesPOItitle,'String',['a',num2str(length(AstrocyteIndex)),'_','FrameNo: ',num2str(round(SPos)),'/',num2str(FrameNum),' (',num2str((FFST+round(SPos)*FrameTime/1000)),'s)']);
elseif AorN==2  % neuron
    set(handlesPOItitle,'String',['n',num2str(length(NeuronIndex)),'_','FrameNo: ',num2str(round(SPos)),'/',num2str(FrameNum),' (',num2str((FFST+round(SPos)*FrameTime/1000)),'s)']);
end
% plot the lower left timecourse
axes(handlesPOITimeCourse);hold on;
% set(hFrameMarkLine,'XData',[round(SPos) round(SPos)]);
% refreshdata;
delete(hFrameMarkLine);
mylim=get(gca,'ylim');
hFrameMarkLine=line([round(SPos) round(SPos)],mylim,'Color','r','LineStyle','--');
uistack(hFrameMarkLine,'bottom');  % move the dash line to the bottom, otherwise it's gonna block the movement of draggable lines

% plot the upper right movie
axes(handlesGreenMovie);hold on;
cla(handlesGreenMovie);
GreenImgMasked=ROI_GCh(:,:,round(SPos)).*ROI_BW_Mask;
imagesc(GreenImgMasked,'Parent',handlesGreenMovie);
[row,col]=find(ROI_masks_all(:,:,round(SPos)));
if AorN==1
    plot(col,row,'r.');
    
%     [row1,col1]=find(ROI_masks_all_2GCh(:,:,round(SPos)));
%     plot(row1,col1,'g.');
%         
%     [row2,col2]=find(ROI_masks_all_2GCh(:,:,round(SPos)).*ROI_masks_all(:,:,round(SPos)));
%     plot(row2,col2,'y.'); 
elseif AorN==2
    plot(col,row,'g.');
end

% plot the lower right timecourse
axes(handlesCaInOutside);hold on;
% set(hFrameMarkLine_GCh,'XData',[round(SPos) round(SPos)]);
% refreshdata;
delete(hFrameMarkLine_GCh);
mylim=get(gca,'ylim');
hFrameMarkLine_GCh=line([round(SPos) round(SPos)],mylim,'Color','r','LineStyle','--');
ylim([mylim]);
uistack(hFrameMarkLine_GCh,'bottom');  % move the dash line to the bottom, otherwise it's gonna block the movement of draggable lines



% --- Executes on slider movement.
function POIslidder_Callback(hObject, eventdata, handles)

global ROI_GCh AorN FrameTime FrameNum handlesPOImovie handlesPOIslidder handlesPOItitle handlesPOITimeCourse ROI_RCh ROI_masks_all FFST hFrameMarkLine hFrameMarkLine_GCh;
global handlesCaInOutside handlesGreenMovie ROI_GCh_CaWave AstrocyteIndex NeuronIndex ROI_masks_all_2GCh ROI_BW_Mask;

% plot the left upper movie
axes(handlesPOImovie);hold on;
cla(handlesPOImovie);
SPos=get(handlesPOIslidder,'Value');
RedImgMasked=ROI_RCh(:,:,round(SPos)).*ROI_BW_Mask;
imagesc(RedImgMasked,'Parent',handlesPOImovie);
[row,col]=find(ROI_masks_all(:,:,round(SPos)));
if AorN==1
    plot(col,row,'r.');
elseif AorN==2
    plot(col,row,'g.');
end
if AorN==1   % astrocyte
    set(handlesPOItitle,'String',['a',num2str(length(AstrocyteIndex)),'_','FrameNo: ',num2str(round(SPos)),'/',num2str(FrameNum),' (',num2str((FFST+round(SPos)*FrameTime/1000)),'s)']);
elseif AorN==2  % neuron
    set(handlesPOItitle,'String',['n',num2str(length(NeuronIndex)),'_','FrameNo: ',num2str(round(SPos)),'/',num2str(FrameNum),' (',num2str((FFST+round(SPos)*FrameTime/1000)),'s)']);
end
% plot the lower left timecourse
axes(handlesPOITimeCourse);hold on;
% set(hFrameMarkLine,'XData',[round(SPos) round(SPos)]);
% refreshdata;
delete(hFrameMarkLine);
mylim=get(gca,'ylim');
hFrameMarkLine=line([round(SPos) round(SPos)],mylim,'Color','r','LineStyle','--');
uistack(hFrameMarkLine,'bottom');  % move the dash line to the bottom, otherwise it's gonna block the movement of draggable lines

% plot the upper right movie
axes(handlesGreenMovie);hold on;
cla(handlesGreenMovie);
GreenImgMasked=ROI_GCh(:,:,round(SPos)).*ROI_BW_Mask;
imagesc(GreenImgMasked,'Parent',handlesGreenMovie);
[row,col]=find(ROI_masks_all(:,:,round(SPos)));
if AorN==1
    plot(col,row,'r.');
%     [row1,col1]=find(ROI_masks_all_2GCh(:,:,round(SPos)));
%     plot(row1,col1,'g.');
%         
%     [row2,col2]=find(ROI_masks_all_2GCh(:,:,round(SPos)).*ROI_masks_all(:,:,round(SPos)));
%     plot(row2,col2,'y.');   
elseif AorN==2
    plot(col,row,'g.');
end


% plot the lower right timecourse
axes(handlesCaInOutside);hold on;
% set(hFrameMarkLine_GCh,'XData',[round(SPos) round(SPos)]);
% refreshdata;
delete(hFrameMarkLine_GCh);
mylim=get(gca,'ylim');
hFrameMarkLine_GCh=line([round(SPos) round(SPos)],mylim,'Color','r','LineStyle','--');
ylim([mylim]);
uistack(hFrameMarkLine_GCh,'bottom');  % move the dash line to the bottom, otherwise it's gonna block the movement of draggable lines


function AcceptRange_Callback(hObject, eventdata, handles)
global hThldLine1 hThldLine2 RangeCut1 RangeCut2 FrameNum;

% get the location of two threshold line
tt1=get(hThldLine1);
RangeCut1=round(tt1.XData(1));
tt2=get(hThldLine2);
RangeCut2=round(tt2.XData(2));
if RangeCut1>RangeCut2
    temp=RangeCut1;
    RangeCut1=RangeCut2;
    RangeCut2=temp;
end

if RangeCut1<2
    RangeCut1=2;
end

if RangeCut2>FrameNum
    RangeCut2=FrameNum;
end



clear tt1 tt2 temp;


% close current window
delete(get(hObject, 'parent'));    % close the current window/figure





% --- Outputs from this function are returned to the command line.
function varargout = GliaTrans_POI_postPOIcheckup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






% --- Executes during object creation, after setting all properties.
function POIslidder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to POIslidder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function SDmeanRfIndex_Callback(hObject, eventdata, handles)
% hObject    handle to SDmeanRfIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SDmeanRfIndex as text
%        str2double(get(hObject,'String')) returns contents of SDmeanRfIndex as a double


% --- Executes during object creation, after setting all properties.
function SDmeanRfIndex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SDmeanRfIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
