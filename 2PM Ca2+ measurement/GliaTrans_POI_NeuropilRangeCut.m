function varargout = GliaTrans_POI_NeuropilRangeCut(varargin)
% GLIATRANS_POI_NEUROPILRANGECUT MATLAB code for GliaTrans_POI_NeuropilRangeCut.fig
%      GLIATRANS_POI_NEUROPILRANGECUT, by itself, creates a new GLIATRANS_POI_NEUROPILRANGECUT or raises the existing
%      singleton*.
%
%      H = GLIATRANS_POI_NEUROPILRANGECUT returns the handle to a new GLIATRANS_POI_NEUROPILRANGECUT or the handle to
%      the existing singleton*.
%
%      GLIATRANS_POI_NEUROPILRANGECUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLIATRANS_POI_NEUROPILRANGECUT.M with the given input arguments.
%
%      GLIATRANS_POI_NEUROPILRANGECUT('Property','Value',...) creates a new GLIATRANS_POI_NEUROPILRANGECUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GliaTrans_POI_NeuropilRangeCut_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GliaTrans_POI_NeuropilRangeCut_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GliaTrans_POI_NeuropilRangeCut

% Last Modified by GUIDE v2.5 22-Aug-2022 09:28:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GliaTrans_POI_NeuropilRangeCut_OpeningFcn, ...
                   'gui_OutputFcn',  @GliaTrans_POI_NeuropilRangeCut_OutputFcn, ...
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


% --- Executes just before GliaTrans_POI_NeuropilRangeCut is made visible.
function GliaTrans_POI_NeuropilRangeCut_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GliaTrans_POI_NeuropilRangeCut (see VARARGIN)

% Choose default command line output for GliaTrans_POI_NeuropilRangeCut
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GliaTrans_POI_NeuropilRangeCut wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global FrameNum handlesOGBMovie handlesNeuropilSlidder handlesPOItitle handlesGreenRedTimeCourse ROI_RCh ROI_GCh FFST hFrameMarkLine hThldLine1 hThldLine2;
global ROI_GCh_CaWave ROI_RCh_SR101Wave handlesRedMovie ROI_BW_Mask FrameTime RangeCut1 RangeCut2 mylim NeuropilIndex BaseLineFrameNo ROI_GRImage;
global ROI_GCh_Clean ROI_RCh_Clean GchMean_foreground handlesGChMaskAdjust handlesMaskThld handlesThldSet;

% preset the interface
handlesOGBMovie=handles.OGBMovie;
handlesNeuropilSlidder=handles.NeuropilSlidder;
handlesGreenRedTimeCourse=handles.GreenRedTimeCourse;
handlesPOItitle=handles.POITitle;
handlesRedMovie=handles.RedMovie;
handlesGChMaskAdjust=handles.GChMaskAdjust;
handlesMaskThld=handles.MaskThld;
handlesThldSet=handles.ThldSet;



%% set the green movie for OGB
axes(handles.OGBMovie);hold on;
GreenImgMasked=ROI_GCh(:,:,2).*ROI_BW_Mask;
imagesc(GreenImgMasked);
set(handles.OGBMovie, 'Ydir', 'reverse');
colormap(gray);
axis image;
axis off;
axis ij;

% set the red ch movie 
axes(handles.RedMovie);hold on;
RedImgMasked=ROI_RCh(:,:,2).*ROI_BW_Mask;
imagesc(RedImgMasked);
set(handles.RedMovie, 'Ydir', 'reverse');
colormap(gray);
axis image;
axis off;
axis ij;

% set the slidder
set(handles.NeuropilSlidder,'Min',1);
set(handles.NeuropilSlidder,'Max',FrameNum);
set(handles.NeuropilSlidder,'Value',1);
set(handles.NeuropilSlidder, 'SliderStep', [1/FrameNum , 1/FrameNum]);
set(handles.POITitle,'String',['f',num2str(length(NeuropilIndex)),'_','FrameNo: 1/',num2str(FrameNum),' (',num2str(FFST/1000),'s)']);


%% set the green channel mask adjustment
axes(handles.GChMaskAdjust);hold on;
ROI_BW_Mask_3ch=repmat(ROI_BW_Mask,[1,1,3]);
GChMask=double(ROI_GRImage).*ROI_BW_Mask_3ch;
GChMask0=uint8(GChMask);
imagesc(GChMask0);
set(handles.GChMaskAdjust, 'Ydir', 'reverse');

axis image;
axis off;
axis ij;

% Use thld for selection
FGThld=str2num(get(handles.ThldSet,'String'));  % foreground threshold
GchMean=double(GChMask(:,:,2)); 
GchMean_foreground=FindForeground(GchMean,FGThld);

[row,col]=find(GchMean_foreground);
plot(col,row,'w.','MarkerSize',2);


axes(handles.OGBMovie);hold on;
plot(col,row,'g.','MarkerSize',2);

axes(handles.RedMovie);hold on;
plot(col,row,'g.','MarkerSize',2);


% the lower GreenRedTimeCourse for both oGB and SR101 channel
%normalize

% get the masked pericyte signals
for j=1:FrameNum
    % get the voxel of the ROI
    eachFrameG=ROI_GCh(:,:,j);
    eachFrameR=ROI_RCh(:,:,j);
    
    % get the voxel of the ROI
    ROI_GCh_CaWave(j)=mean2(eachFrameG(find(eachFrameG.*GchMean_foreground)));
    
    ROI_RCh_SR101Wave(j)=mean2(eachFrameR(find(eachFrameR.*GchMean_foreground)));
    
end

ROI_GCh_CaWave_forcheckup=ROI_GCh_CaWave;
ROI_GCh_CaWave_forcheckup = ROI_GCh_CaWave_forcheckup./mean(ROI_GCh_CaWave_forcheckup(1:BaseLineFrameNo));
ROI_RCh_SR101Wave_forcheckup=ROI_RCh_SR101Wave;
ROI_RCh_SR101Wave_forcheckup = ROI_RCh_SR101Wave_forcheckup./mean(ROI_RCh_SR101Wave_forcheckup(1:BaseLineFrameNo));

axes(handles.GreenRedTimeCourse);hold on;
plot(1:FrameNum,ROI_GCh_CaWave_forcheckup(1:end),'g','LineWidth',1);
plot(1:FrameNum,ROI_RCh_SR101Wave_forcheckup(1:end),'r','LineWidth',1);
xlim([0 FrameNum+1]);
xlabel('\fontsize{12}Frame Num');
ylabel('\fontsize{12}Normalized mean intensity');
mylim=get(gca,'ylim'); 
hFrameMarkLine=line([2 2],mylim,'Color','r','LineStyle','--');


% set the two draggable vertical lines in the lower GreenRedTimeCourse
% set the starting lines
% hThldLine1=line([RangeCut1 RangeCut1],mylim,'Color','b','LineWidth',2);
% hThldLine2=line([RangeCut2 RangeCut2],mylim,'Color','b','LineWidth',2);
% draggable(hThldLine1,'h');
% draggable(hThldLine2,'h');
ylim(gca,mylim);


% once the slider moves, it will call function UpdateImg
addlistener(handles.NeuropilSlidder,'Value','PostSet',@UpdatePOIImg);






function UpdatePOIImg(~,~)
% This function is to update the OGBMovie and TimeCourse during the dragging of slider

global ROI_GCh NeuropilIndex FrameTime FrameNum handlesOGBMovie handlesNeuropilSlidder handlesPOItitle handlesGreenRedTimeCourse ROI_RCh FFST hFrameMarkLine;
global handlesRedMovie ROI_GCh_CaWave mylim ROI_BW_Mask ROI_GCh_Clean ROI_RCh_Clean GchMean_foreground;

[row,col]=find(GchMean_foreground);

% plot the left upper movie
axes(handlesOGBMovie);hold on;
cla(handlesOGBMovie);
SPos=get(handlesNeuropilSlidder,'Value');
GreenImgMasked=ROI_GCh(:,:,round(SPos)).*ROI_BW_Mask;
imagesc(GreenImgMasked,'Parent',handlesOGBMovie);
set(handlesPOItitle,'String',['a',num2str(length(NeuropilIndex)),'_','FrameNo:',num2str(round(SPos)),'/',num2str(FrameNum),' (',num2str((FFST+round(SPos)*FrameTime)/1000),'s)']);
plot(col,row,'g.','MarkerSize',2);

% plot the lower left timecourse
axes(handlesGreenRedTimeCourse);hold on;
delete(hFrameMarkLine);
hFrameMarkLine=line([round(SPos) round(SPos)],mylim,'Color','r','LineStyle','--');
% uistack(hFrameMarkLine,'bottom');  % move the dash line to the bottom, otherwise it's gonna block the movement of draggable lines
ylim(gca,mylim);


% plot the upper right movie
axes(handlesRedMovie);hold on;
cla(handlesRedMovie);
RedImgMasked=ROI_RCh(:,:,round(SPos)).*ROI_BW_Mask;
imagesc(RedImgMasked,'Parent',handlesRedMovie);
plot(col,row,'g.','MarkerSize',2);



% --- Executes on slider movement.
function NeuropilSlidder_Callback(hObject, eventdata, handles)

global ROI_GCh NeuropilIndex FrameTime FrameNum handlesOGBMovie handlesNeuropilSlidder handlesPOItitle handlesGreenRedTimeCourse ROI_RCh FFST hFrameMarkLine;
global handlesRedMovie ROI_GCh_CaWave mylim ROI_BW_Mask ROI_GCh_Clean ROI_RCh_Clean GchMean_foreground;

[row,col]=find(GchMean_foreground);

% plot the left upper movie
axes(handlesOGBMovie);hold on;
cla(handlesOGBMovie);
SPos=get(handlesNeuropilSlidder,'Value');
GreenImgMasked=ROI_GCh(:,:,round(SPos)).*ROI_BW_Mask;
imagesc(GreenImgMasked,'Parent',handlesOGBMovie);
set(handlesPOItitle,'String',['a',num2str(length(NeuropilIndex)),'_','FrameNo:',num2str(round(SPos)),'/',num2str(FrameNum),' (',num2str((FFST+round(SPos)*FrameTime)/1000),'s)']);
plot(col,row,'g.','MarkerSize',2);

% plot the lower left timecourse
axes(handlesGreenRedTimeCourse);hold on;
delete(hFrameMarkLine);
hFrameMarkLine=line([round(SPos) round(SPos)],mylim,'Color','r','LineStyle','--');
% uistack(hFrameMarkLine,'bottom');  % move the dash line to the bottom, otherwise it's gonna block the movement of draggable lines
ylim(gca,mylim);


% plot the upper right movie
axes(handlesRedMovie);hold on;
cla(handlesRedMovie);
RedImgMasked=ROI_RCh(:,:,round(SPos)).*ROI_BW_Mask;
imagesc(RedImgMasked,'Parent',handlesRedMovie);
plot(col,row,'g.','MarkerSize',2);

% % show the value of SD/mean in 30 sec
% FrameNoIn30sec=30/FrameTime*1000;
% FrameNoIn30secHalf=fix(FrameNoIn30sec/2);
% leftcut=0;
% rightcut=0;
% if round(SPos)<=FrameNoIn30secHalf+1
%     leftcut=2;
%     rightcut=FrameNoIn30secHalf*2+1;
% elseif round(SPos)>=FrameNum-FrameNoIn30secHalf-1
%     leftcut=FrameNum-FrameNoIn30secHalf*2;
%     rightcut=FrameNum;
% else
%     leftcut=round(SPos)-FrameNoIn30secHalf;
%     rightcut=round(SPos)+FrameNoIn30secHalf;
% end



function AcceptRange_Callback(hObject, eventdata, handles)
% close current window
delete(get(hObject, 'parent'));    % close the current window/figure





% --- Outputs from this function are returned to the command line.
function varargout = GliaTrans_POI_NeuropilRangeCut_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






% --- Executes during object creation, after setting all properties.
function NeuropilSlidder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NeuropilSlidder (see GCBO)
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


% --- Executes on slider movement.
function MaskThld_Callback(hObject, eventdata, handles)
global handlesOGBMovie handlesNeuropilSlidder handlesThldSet handlesRedMovie GchMean_foreground handlesGChMaskAdjust;
global ROI_GRImage ROI_BW_Mask ROI_GCh ROI_RCh handlesGreenRedTimeCourse;
global FrameNum ROI_GCh_CaWave ROI_RCh_SR101Wave hFrameMarkLine mylim BaseLineFrameNo;

FGThld=get(handles.MaskThld,'Value');  % foreground threshold

ROI_BW_Mask_3ch=repmat(ROI_BW_Mask,[1,1,3]);
GChMask=double(ROI_GRImage).*ROI_BW_Mask_3ch;
GChMask0=uint8(GChMask);
GchMean=double(GChMask(:,:,2)); 
GchMean_foreground=FindForeground(GchMean,FGThld);
[row,col]=find(GchMean_foreground);


% get the masked pericyte signals
for j=1:FrameNum
    % get the voxel of the ROI
    eachFrameG=ROI_GCh(:,:,j);
    eachFrameR=ROI_RCh(:,:,j);
    
    % get the voxel of the ROI
    ROI_GCh_CaWave(j)=mean2(eachFrameG(find(eachFrameG.*GchMean_foreground)));
    
    ROI_RCh_SR101Wave(j)=mean2(eachFrameR(find(eachFrameR.*GchMean_foreground)));
    
end
ROI_GCh_CaWave_forcheckup=ROI_GCh_CaWave;
ROI_GCh_CaWave_forcheckup = ROI_GCh_CaWave_forcheckup./mean(ROI_GCh_CaWave_forcheckup(2:BaseLineFrameNo));
ROI_RCh_SR101Wave_forcheckup=ROI_RCh_SR101Wave;
ROI_RCh_SR101Wave_forcheckup = ROI_RCh_SR101Wave_forcheckup./mean(ROI_RCh_SR101Wave_forcheckup(2:BaseLineFrameNo));




axes(handlesGChMaskAdjust);hold on;
cla(handlesOGBMovie);
imagesc(GChMask0);
set(handles.GChMaskAdjust, 'Ydir', 'reverse');
axis image;
axis off;
axis ij;
plot(col,row,'w.','MarkerSize',2);

axes(handlesOGBMovie);hold on;
cla(handlesOGBMovie);
SPos=get(handlesNeuropilSlidder,'Value');
GreenImgMasked=ROI_GCh(:,:,round(SPos)).*ROI_BW_Mask;
imagesc(GreenImgMasked,'Parent',handlesOGBMovie);
plot(col,row,'g.','MarkerSize',2);

axes(handlesRedMovie);hold on;
cla(handlesRedMovie);
RedImgMasked=ROI_RCh(:,:,round(SPos)).*ROI_BW_Mask;
imagesc(RedImgMasked,'Parent',handlesRedMovie);
plot(col,row,'g.','MarkerSize',2);


set(handlesThldSet,'String',num2str(FGThld));

axes(handlesGreenRedTimeCourse);hold on;
cla(handlesGreenRedTimeCourse);
plot(1:FrameNum,ROI_GCh_CaWave_forcheckup(1:end),'g','LineWidth',1);
plot(1:FrameNum,ROI_RCh_SR101Wave_forcheckup(1:end),'r','LineWidth',1);
xlim([0 FrameNum+1]);
xlabel('\fontsize{12}Frame Num');
ylabel('\fontsize{12}Normalized mean intensity');
mylim=get(gca,'ylim'); 

SPos=get(handlesNeuropilSlidder,'Value');
hFrameMarkLine=line([round(SPos) round(SPos)],mylim,'Color','r','LineStyle','--');
ylim(gca,mylim);




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
global handlesOGBMovie handlesNeuropilSlidder handlesMaskThld handlesRedMovie GchMean_foreground handlesGChMaskAdjust;
global ROI_GRImage ROI_BW_Mask ROI_GCh ROI_RCh BaseLineFrameNo;
global FrameNum ROI_GCh_CaWave ROI_RCh_SR101Wave hFrameMarkLine mylim handlesGreenRedTimeCourse;

FGThld=str2num(get(handles.ThldSet,'String'));  % foreground threshold

ROI_BW_Mask_3ch=repmat(ROI_BW_Mask.',[1,1,3]);
GChMask=double(ROI_GRImage).*ROI_BW_Mask_3ch;
GChMask0=uint8(GChMask);
GchMean=double(GChMask(:,:,2)); 
GchMean_foreground=FindForeground(GchMean,FGThld);
[row,col]=find(GchMean_foreground);


% get the masked pericyte signals
for j=1:FrameNum
    % get the voxel of the ROI
    eachFrameG=ROI_GCh(:,:,j);
    eachFrameR=ROI_RCh(:,:,j);
    
    % get the voxel of the ROI
    ROI_GCh_CaWave(j)=mean2(eachFrameG(find(eachFrameG.*GchMean_foreground.')));
    
    ROI_RCh_SR101Wave(j)=mean2(eachFrameR(find(eachFrameR.*GchMean_foreground.')));
    
end
ROI_GCh_CaWave_forcheckup=ROI_GCh_CaWave;
ROI_GCh_CaWave_forcheckup = ROI_GCh_CaWave_forcheckup./mean(ROI_GCh_CaWave_forcheckup(1:BaseLineFrameNo));
ROI_RCh_SR101Wave_forcheckup=ROI_RCh_SR101Wave;
ROI_RCh_SR101Wave_forcheckup = ROI_RCh_SR101Wave_forcheckup./mean(ROI_RCh_SR101Wave_forcheckup(1:BaseLineFrameNo));



axes(handlesGChMaskAdjust);hold on;
cla(handlesOGBMovie);
imagesc(GChMask0);
set(handles.GChMaskAdjust, 'Ydir', 'reverse');
axis image;
axis off;
axis ij;
plot(col,row,'w.','MarkerSize',2);

axes(handlesOGBMovie);hold on;
cla(handlesOGBMovie);
SPos=get(handlesNeuropilSlidder,'Value');
GreenImgMasked=ROI_GCh(:,:,round(SPos)).*ROI_BW_Mask;
imagesc(GreenImgMasked.','Parent',handlesOGBMovie);
plot(col,row,'g.','MarkerSize',2);

axes(handlesRedMovie);hold on;
cla(handlesRedMovie);
RedImgMasked=ROI_RCh(:,:,round(SPos)).*ROI_BW_Mask;
imagesc(RedImgMasked.','Parent',handlesRedMovie);
plot(col,row,'g.','MarkerSize',2);


set(handlesMaskThld,'Value',FGThld);


axes(handlesGreenRedTimeCourse);hold on;
cla(handlesGreenRedTimeCourse);
plot(1:FrameNum,ROI_GCh_CaWave_forcheckup(1:end),'g','LineWidth',1);
plot(1:FrameNum,ROI_RCh_SR101Wave_forcheckup(1:end),'r','LineWidth',1);
xlim([0 FrameNum+1]);
xlabel('\fontsize{12}Frame Num');
ylabel('\fontsize{12}Normalized mean intensity');
mylim=get(gca,'ylim'); 

SPos=get(handlesNeuropilSlidder,'Value');
hFrameMarkLine=line([round(SPos) round(SPos)],mylim,'Color','r','LineStyle','--');
ylim(gca,mylim);





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
function GChMaskAdjust_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GChMaskAdjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate GChMaskAdjust
