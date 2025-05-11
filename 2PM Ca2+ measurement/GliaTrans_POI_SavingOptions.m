function varargout = GliaTrans_POI_SavingOptions(varargin)
% GLIATRANS_POI_SAVINGOPTIONS MATLAB code for GliaTrans_POI_SavingOptions.fig
%      GLIATRANS_POI_SAVINGOPTIONS, by itself, creates a new GLIATRANS_POI_SAVINGOPTIONS or raises the existing
%      singleton*.
%
%      H = GLIATRANS_POI_SAVINGOPTIONS returns the handle to a new GLIATRANS_POI_SAVINGOPTIONS or the handle to
%      the existing singleton*.
%
%      GLIATRANS_POI_SAVINGOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLIATRANS_POI_SAVINGOPTIONS.M with the given input arguments.
%
%      GLIATRANS_POI_SAVINGOPTIONS('Property','Value',...) creates a new GLIATRANS_POI_SAVINGOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GliaTrans_POI_SavingOptions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GliaTrans_POI_SavingOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GliaTrans_POI_SavingOptions

% Last Modified by GUIDE v2.5 23-Feb-2016 23:04:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GliaTrans_POI_SavingOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @GliaTrans_POI_SavingOptions_OutputFcn, ...
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


% --- Executes just before GliaTrans_POI_SavingOptions is made visible.
function GliaTrans_POI_SavingOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GliaTrans_POI_SavingOptions (see VARARGIN)

% Choose default command line output for GliaTrans_POI_SavingOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GliaTrans_POI_SavingOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% global FrameNum GliaTrans_GCh_inside GliaTrans_GCh_outside GliaTrans_GandR_inside GliaTrans_GandR_outside;


global FiletoStudy;

FilePathAll=pwd;

allfilesep=find(FilePathAll==filesep);
mysavingfolder=FilePathAll(1:allfilesep(end)-1);
mysavingname=FilePathAll(allfilesep(end)+1:end-4);
mysavingname(isspace(mysavingname))=[];       % delete the space in the file name, for the sake of MATLAB

cd(mysavingfolder);     % set the current folder in MATLAB for mysaving folder

set(handles.savingfolder,'String',mysavingfolder);
set(handles.videofilename,'String',mysavingname);


% --- Outputs from this function are returned to the command line.
function varargout = GliaTrans_POI_SavingOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in Finish.
function Finish_Callback(hObject, ~, handles)
global myTimeTicks Faxes1 FrameTime GliaTrans_GCh_inside GliaTrans_GCh_outside GliaTrans_GandR_inside GliaTrans_GandR_outside RangeCutAll ROIcount LegendAll BaselinePeriod ROIPosAll CutFrameNum1 CutFrameNum2;
global ROI_RCh_SR101Wave_All ROI_GCh_CaDivdeRed_All useNew myVideo_New myVideoR_New myVideo myVideoR;
global PeakAmpThld avgFrame_3Ch FrameHeight HeightStep NoiseAllowPOI TransDuration_min TransDuration_max NoiseAllowTransDet CorrectBLdriftOrNot SplitRoiWavesOrNot;
global ROI_GCh_CaWave_All ROI_GCh_nonCaWave_All ROI_GandR_CaWave_All ROI_GandR_nonCaWave_All myVideoGchOpt ExcludeROIsPos AstrocyteIndex NeuropilIndex NeuronIndex POIThld;
global ROI_RCh_SR101Wave_All_raw ROI_GCh_CaWave_All_raw ROI_GCh_CaDivdeRed_All_raw;

savingfolder=get(handles.savingfolder,'String');
savingfilename=get(handles.videofilename,'String');

if exist([savingfolder,filesep,savingfilename],'dir')~=7    % if not exist, create the folder
    mkdir([savingfolder,filesep,savingfilename]);
else   % if the folder already exist, delete all the files in the folder
    delete([savingfolder,filesep,savingfilename,filesep,'*.*']);
end

% for axes1 in the main window, the guiding figures
figure('units','normalized','outerposition',[0 0 1 1]);
image(Faxes1.cdata);  % show selected axes in the new figure
axis equal;
axis off;
pause(1);
saveas(gcf,[savingfolder,filesep,savingfilename,filesep,savingfilename,'_ROIOverview.tif']);
saveas(gcf,[savingfolder,filesep,savingfilename,filesep,savingfilename,'_ROIOverview.fig']);
close(gcf);

% save the transient detection window
global  FFST presetcolor;
global  PuffTimeNo1 PuffTimeNo2 BaseLineFrameNo;

hd20=figure(20);
hold on;
for i=1:ROIcount
    if CutFrameNum1<=BaseLineFrameNo
    plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaWave_All(i,CutFrameNum1:CutFrameNum2),presetcolor(i),'LineWidth',2);
    else
        plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaWave_All(i,CutFrameNum1:CutFrameNum2),presetcolor(i),'LineWidth',2);
    end
end
title('\fontsize{12}Ca^{2+} inside the defined EC');
xlabel('\fontsize{16}Time (s)');
ylabel('\fontsize{16}Normalized Fluorescent Intensity');
set(gca,'Fontsize',15);
xlim([0 myTimeTicks(end)]);
mylim=get(gca,'ylim');
PuffStartTime=PuffTimeNo1;
PuffEndTime=PuffTimeNo2;
line([PuffStartTime PuffStartTime],[mylim(1)+0.001 mylim(2)-0.001],'Color','m','LineWidth',2);
line([PuffEndTime PuffEndTime],[mylim(1)+0.001 mylim(2)-0.001],'Color','m','LineWidth',2);
ylim(mylim);
saveas(hd20,[savingfolder,filesep,savingfilename,filesep,savingfilename,'_Ca2+InsideEC.fig']);
saveas(hd20,[savingfolder,filesep,savingfilename,filesep,savingfilename,'_Ca2+InsideEC.jpg']);
close(hd20);



hd30=figure(30);
hold on;
for i=1:ROIcount
    if CutFrameNum1<=BaseLineFrameNo
    plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_RCh_SR101Wave_All(i,CutFrameNum1:CutFrameNum2),presetcolor(i),'LineWidth',2);
    else
        plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_RCh_SR101Wave_All(i,CutFrameNum1:CutFrameNum2),presetcolor(i),'LineWidth',2);
    end
end
title('\fontsize{12}Red channel intensity inside the defined EC');
xlabel('\fontsize{16}Time (s)');
ylabel('\fontsize{16}Normalized Fluorescent Intensity');
set(gca,'Fontsize',15);
xlim([0 myTimeTicks(end)]);
if PuffTimeNo1*PuffTimeNo2
    mylim=get(gca,'ylim');
    PuffStartTime=PuffTimeNo1;
    PuffEndTime=PuffTimeNo2;
    line([PuffStartTime PuffStartTime],[mylim(1)+0.001 mylim(2)-0.001],'Color','m','LineWidth',2);
    line([PuffEndTime PuffEndTime],[mylim(1)+0.001 mylim(2)-0.001],'Color','m','LineWidth',2);
    ylim(mylim);
end
saveas(hd30,[savingfolder,filesep,savingfilename,filesep,savingfilename,'_RedSignalInsideEC.fig']);
saveas(hd30,[savingfolder,filesep,savingfilename,filesep,savingfilename,'_RedSignalInsideEC.jpg']);
close(hd30);


hd40=figure(40);
hold on;
for i=1:ROIcount
    if CutFrameNum1<=BaseLineFrameNo
    plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaDivdeRed_All(i,CutFrameNum1:CutFrameNum2),presetcolor(i),'LineWidth',2);
    else
        plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaDivdeRed_All(i,CutFrameNum1:CutFrameNum2),presetcolor(i),'LineWidth',2);
    end
end
title('\fontsize{12}Calcium intensity / Red channel intensity inside defined EC');
xlabel('\fontsize{16}Time (s)');
ylabel('\fontsize{16}Normalized Fluorescent Intensity');
set(gca,'Fontsize',15);
xlim([0 myTimeTicks(end)]);
if PuffTimeNo1*PuffTimeNo2
    mylim=get(gca,'ylim');
    PuffStartTime=PuffTimeNo1;
    PuffEndTime=PuffTimeNo2;
    line([PuffStartTime PuffStartTime],[mylim(1)+0.001 mylim(2)-0.001],'Color','m','LineWidth',2);
    line([PuffEndTime PuffEndTime],[mylim(1)+0.001 mylim(2)-0.001],'Color','m','LineWidth',2);
    ylim(mylim);
end
saveas(hd40,[savingfolder,filesep,savingfilename,filesep,savingfilename,'_GreenByRedInsideEC.fig']);
saveas(hd40,[savingfolder,filesep,savingfilename,filesep,savingfilename,'_GreenByInsideEC.jpg']);
close(hd40);





%%%%%%%%%%%%%%%%%% save the data in the excel file %%%%%%%%%%%%%%%%%%%%%
% delete the previous one if there's any
h3=msgbox('Saving to excel file...');
try delete([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx']);end

col_header_STI=LegendAll(1:ROIcount);

%%%%%%%%%%%%%% save into spreadsheet
xlswrite([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx'],{'Time(s)'},1,'A1');
xlswrite([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx'],col_header_STI,1,'B1');      %Write row header
xlswrite([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx'],myTimeTicks.',1,'A2');
xlswrite([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx'],ROI_RCh_SR101Wave_All.',1,'B2');

xlswrite([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx'],{'Time(s)'},2,'A1');
xlswrite([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx'],col_header_STI,2,'B1');      %Write row header
xlswrite([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx'],myTimeTicks.',2,'A2');
xlswrite([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx'],ROI_GCh_CaWave_All.',2,'B2');

xlswrite([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx'],{'Time(s)'},3,'A1');
xlswrite([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx'],col_header_STI,3,'B1');      %Write row header
xlswrite([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx'],myTimeTicks.',3,'A2');
xlswrite([savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx'],ROI_GCh_CaDivdeRed_All.',3,'B2');


% change the sheet name
mysheetnames={'RedInEC','CalciumInEC','GreenByRedInEC'};
xlsheets(mysheetnames,[savingfolder,filesep,savingfilename,filesep,savingfilename,'_Curves.xlsx']);
try close(h3);end
    
    
% save to mat file for reload in the future
save([savingfolder,filesep,savingfilename,filesep,savingfilename,'_AnalysisParameters.mat'],'savingfolder','savingfilename','myTimeTicks','FrameTime','ROIcount',...
    'RangeCutAll','col_header_STI','avgFrame_3Ch','presetcolor','ROIPosAll',...
    'FrameHeight','HeightStep','NoiseAllowPOI','BaselinePeriod','TransDuration_min','TransDuration_max','NoiseAllowTransDet','CorrectBLdriftOrNot',...
    'SplitRoiWavesOrNot','PeakAmpThld','ROI_RCh_SR101Wave_All','ROI_GCh_CaWave_All','ROI_GCh_nonCaWave_All','ROI_GandR_CaWave_All',...
    'ROI_GandR_nonCaWave_All','myVideoGchOpt','ExcludeROIsPos','AstrocyteIndex','NeuropilIndex','NeuronIndex','LegendAll','POIThld',...
    'ROI_GCh_CaDivdeRed_All','useNew','myVideo_New','myVideoR_New','myVideo','myVideoR','ROI_RCh_SR101Wave_All_raw','ROI_GCh_CaWave_All_raw','ROI_GCh_CaDivdeRed_All_raw');
    
% append/save all the ROI infos into the same file 
for i=1:ROIcount
    eval(['global ROI_masks_all_',LegendAll{i}]);
    save([savingfolder,filesep,savingfilename,filesep,savingfilename,'_AnalysisParameters.mat'],['ROI_masks_all_',LegendAll{i}],'-append');
end    


% close current window
delete(get(hObject, 'parent'));    % close the current window/figure
 


%         
%         % generate legend
%         if isempty(linkvesselname)
%             linkvesselname=[char(39),vesselname,char(39)];
%         else
%             linkvesselname=[linkvesselname,',',char(39),vesselname,char(39)];
%         end
%      
%     end
%     









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
