%% ------------------------------------------
% This program is for semi-manual detection of glial transients from
% two-photon imaging in Femtonics microscope
% This program is created for Jonas Fordsmann, Stefan, Reena in INF, University of
% Copenhagen. If you have any question, please contact with Changsi Cai at
% ccai@sund.ku.dk   or   icecreamspace@gmail.com

%---------------------------------------------
% log : 
% 13/12/2105 first version POI_UI_5. 
% 08/01/2016 second version POI_UI_6.
%            the following problems are fixed: 1. changeable SD/mean definition in the scrolling window for cutting.
%                                              2. delete the individual points in the mask of SR101.
%                                              3. editable window for smoothing the curve.
%                                              4. switch between green and blue channel for OGB.
%                                              5. add area under the curve for glial transients.
%                                              6. peak amplitude of detected transient is readjusted by normalizing it to the running baseline.
% 19/01/2016 third version POI_UI_7
%            the following changes are made:   1. Add thresholding options for detected transient peak.
%                                              2. Add 'save ROI' and 'load ROI' function.
%                                              3. Add right click buttons for moving ROIs and redo the cut in time range.
%                                              4. 'Fix' the problem of active cursor following the slider.
% 29/01/2016 fourth version POI_UI_8
%            the following changes are made:   1. Add buttons 'New Neuropil','New Neuron'.
%                                              2. Activate 'Delete' button in the right click menu.
%                                              3. Add 'Exclude ROIs' to the 'Save' and 'Load' functions.
%                                              4. Correct the freqency calculation of transient by un-counting the baseline period.
%                                              5. Change the y axis label to the real ROI names, and add the second y axis label on the right.
%                                              6. If the ROI size is 0, dump the roi and give a warning dialog.


%% ---------------------------------------------


function varargout = GliaTrans_POI_GUI_MAIN(varargin)
% GLIATRANS_POI_GUI_MAIN MATLAB code for GliaTrans_POI_GUI_MAIN.fig
%      GLIATRANS_POI_GUI_MAIN, by itself, creates a new GLIATRANS_POI_GUI_MAIN or raises the existing
%      singleton*.
%
%      H = GLIATRANS_POI_GUI_MAIN returns the handle to a new GLIATRANS_POI_GUI_MAIN or the handle to
%      the existing singleton*.
%
%      GLIATRANS_POI_GUI_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLIATRANS_POI_GUI_MAIN.M with the given input arguments.
%
%      GLIATRANS_POI_GUI_MAIN('Property','Value',...) creates a new GLIATRANS_POI_GUI_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GliaTrans_POI_GUI_MAIN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GliaTrans_POI_GUI_MAIN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GliaTrans_POI_GUI_MAIN

% Last Modified by GUIDE v2.5 05-Apr-2023 15:51:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GliaTrans_POI_GUI_MAIN_OpeningFcn, ...
                   'gui_OutputFcn',  @GliaTrans_POI_GUI_MAIN_OutputFcn, ...
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


% --- Executes just before GliaTrans_POI_GUI_MAIN is made visible.
function GliaTrans_POI_GUI_MAIN_OpeningFcn(hObject, ~, handles, varargin)

% Choose default command line output for GliaTrans_POI_GUI_MAIN
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% read in %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global variables
global presetcolor ROIs ROIcount RedImg GreenImg BlueImg ROIPosAll FrameHeight FrameNum ROIHandles fig2_hds ROI_RCh_SR101Wave_All myTimeTicks fig3_hds;
global ROI_GCh_CaWave_All fig4_hds ROI_GCh_CaDivdeRed_All text_hds FiletoStudy STITimeTicks BaseLineFrameNo FrameTime FFST hdl_11 hdl_12 hdl_21 hdl_22 hdl_31 hdl_32 hdl_STI1 hdl_STI2 hdl_STI3 NoiseAllow myVideoGchOpt;
global ResStT2 ResStLoc2 ResStT3 ResStLoc3 ResStT4 ResStLoc4 HeightStep RangeCutAll ROI_GandR_CaWave_All ROI_GandR_nonCaWave_All avgFrame_3Ch;
global AstrocyteIndex NeuropilIndex NeuronIndex LegendAll hExcludeROIs ExcludeROIsPos POIThld ROI_GCh_CaDivdeRed ROI_GCh_Clean ROI_RCh_Clean;
global PlanePerStack HeightPixNum WidthPixNum WidthStep myVideoGch myVideoRch myVideo myDIs FrameNo1 FrameNo2 myVideoGch0 myVideoRch0;
global hSTIpatch1 hSTIpatch2 hSTIpatch3 ROI_BW_All ROIPosAllRec pathname filename myVideoR CutTime1 CutTime2 CutFrameNum1 CutFrameNum2 PuffTimeNo1 PuffTimeNo2;
global Raw4DVideoG Raw4DVideoR useNew ROI_RCh_SR101Wave_All_raw ROI_GCh_CaWave_All_raw ROI_GCh_CaDivdeRed_All_raw BK_GCh BK_RCh ROI_GRImage GchMean_foreground PlanePerStackNew PixelSize;

% read in the info of MES file
FiletoStudy='F1';


if ~isempty('ROIcount') && length(ROIcount)~=0
    if ROIcount>0
    for i=1:ROIcount
        eval(['global ROI_masks_all_',num2str(i)]);
        if exist(eval([char(39),'ROI_masks_all_',num2str(i),char(39)]))
            eval(['clear ROI_masks_all_',num2str(i),';']);
        end
    end
    end
end

presetcolor='rbgycmkrbgycmkrbgycmkrbgycmkrbgycmkrbgycmkrbgycmkrbgycmkrbgycmkrbgycmkrbgycmkrbgycmk';

AstrocyteIndex=[];
BK_GCh=[];
BK_RCh=[];
CutTime1=0;
CutTime2=0;
CutFrameNum1=0;
CutFrameNum2=0;
ExcludeROIsPos=[];
FrameNo1='0';
FrameNo2='0';
fig2_hds=[];
fig3_hds=[];
fig4_hds=[];
filename=[];
GchMean_foreground=[];
hdl_11=[];
hdl_12=[];
hdl_21=[];
hdl_22=[];
hdl_31=[];
hdl_32=[];
hdl_STI1=[];
hdl_STI2=[];
hdl_STI3=[];
hSTIpatch1=[];
hSTIpatch2=[];
hSTIpatch3=[];
hExcludeROIs=[];
LegendAll=cell(1,length(presetcolor));
NeuropilIndex=[];
NeuronIndex=[];
POIThld=[];
PuffTimeNo1=0;
PuffTimeNo2=0;
PlanePerStackNew=0;
PlanePerStack=0;
PixelSize=0;
pathname=[];
ROIcount=0;
ROIHandles=zeros(10,0);
ROI_RCh_SR101Wave_All=[];
ROI_RCh_SR101Wave_All_raw=[];
ROI_GCh_CaWave_All=[];
ROI_GCh_CaWave_All_raw=[];
ROI_GCh_CaDivdeRed_All=[];
ROI_GCh_CaDivdeRed_All_raw=[];
RangeCutAll=[];
ROI_GandR_CaWave_All=[];
ROI_GandR_nonCaWave_All=[];
ROI_GCh_CaDivdeRed=[];
ROIs=[];
ROIPosAll={};
ResStT2=[];
ResStLoc2=[];
ResStT3=[];
ResStLoc3=[];
ResStT4=[];
ResStLoc4=[];
ROI_GRImage=[];
ROI_GCh_Clean=[];
ROI_RCh_Clean=[];
STITimeTicks=[];
text_hds=[];
ROI_BW_All=[];
ROIPosAllRec=[];
Raw4DVideoG=[];
Raw4DVideoR=[];
useNew=0;


clc;
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);
set(handles.NoiseAllowPOI,'String',0.5);

% make the handles global
global handlesaxes1 handlesaxes2 handlesaxes3 handlesaxes4 handlesNoiseAllowPOI handlesOGBChannel;
handlesaxes1=handles.axes1;
handlesaxes2=handles.axes2;
handlesaxes3=handles.axes3;
handlesaxes4=handles.axes4;
handlesNoiseAllowPOI=handles.NoiseAllowPOI;
handlesOGBChannel=handles.OGBChannel;




function varargout = GliaTrans_POI_GUI_MAIN_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;



function Newastrocyte_Callback(~, ~, handles)


set(handles.Newastrocyte,'Enable','inactive');
pause(0.5);
set(handles.Newastrocyte,'Enable','on');


global GreenImg RedImg BlueImg presetcolor ROIcount ROIs ROIPosAll FrameHeight FrameNum fig2_hds ROI_RCh_SR101Wave_All myTimeTicks fig3_hds ROI_GCh_CaWave_All fig4_hds ROI_GCh_nonCaWave_All text_hds COI_MaskFrameTime;
global ROI_RCh ROI_GCh ROI_masks_all RangeCut1 RangeCut2 RangeCutAll ROI_GCh_CaWave ROI_GCh_nonCaWave ROI_GandR_CaWave_All ROI_GandR_nonCaWave_All NoiseAllowPOI;
global AstrocyteIndex LegendAll AorN POIThld ROI_masks_all_2GCh;
global STITimeTicks hdl_STI1 hdl_STI2 hdl_STI3 hdl_11 hdl_12 hdl_21 hdl_22 hdl_31 hdl_32 FrameTime FFST FrameNo1 FrameNo2;
global ROI_BW_All ROIPosAllRec ROI_BW_Mask myVideo myVideoR PuffTimeNo1 PuffTimeNo2;



% draw ROI
axes(handles.axes1);
h=imfreehand;
setColor(h,presetcolor(ROIcount+1));
% COI_Mask = createMask(h).';   % cell of interest
ROIpos = getPosition(h);
% ROIpos = round(ROIpos);    % make sure the index is integer


ROIcount=ROIcount+1;
ROI_BW = createMask(h).';
if ROIcount==1
    ROI_BW_All=[ROI_BW_All;ROI_BW];
else
    ROI_BW_All(:,:,ROIcount)=ROI_BW;
end

% redraw the curve
delete(h);
ROIpos=[ROIpos;ROIpos(1,:)];


if length(ROIpos)<=2
    warndlg('ROI size CANNOT be zero!','!! Warning !!');
    
else

    % square drawing of newastrocyte the contour of ROI
    AstrocyteIndex=[AstrocyteIndex ROIcount];
    LegendAll{ROIcount}=['a',num2str(length(AstrocyteIndex))];

    axes(handles.axes1);hold on;
    hh=plot(ROIpos(:,1),ROIpos(:,2),presetcolor(ROIcount),'LineWidth',2);
    ROIs=[ROIs hh];


    % Mark the index of the ROI in the image
    MposX=mean(ROIpos(:,1));
    MposY=mean(ROIpos(:,2));
    thd=text(MposX,MposY,['a',int2str(ROIcount)],'color',presetcolor(ROIcount),'Fontsize',12);
    text_hds=[text_hds thd];

    % 
    % Save the ROI position for later use
    ROIPosAll(ROIcount)=num2cell(ROIpos,[1 2]); 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % create a right click menu for this ROIs
    uic = uicontextmenu;
    uimenu ( uic, 'Label','Delete','Callback',@DeleteROINew);
    uimenu ( uic, 'Label','Recut in time','Callback',@RecallCutRangeFun);
    set ( hh, 'uicontextmenu',uic);
    
    % find the x.y limit of ROIs
    x_rec=[floor(min(ROIpos(:,1))),ceil(max(ROIpos(:,1)))];
    y_rec=[floor(min(ROIpos(:,2))),ceil(max(ROIpos(:,2)))];
    ROIPosAllRec=[ROIPosAllRec;[x_rec y_rec]];
    
    % prepare for Ca detection
    m=x_rec(2)-x_rec(1)+1;
    n=y_rec(2)-y_rec(1)+1;
    
    ROI_BW_Mask=ROI_BW(x_rec(1):x_rec(2),y_rec(1):y_rec(2));
    


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% POI method
    % preset parameters
    ROI_GCh=zeros(m,n,FrameNum); 
    ROI_RCh=zeros(m,n,FrameNum); 
    NoiseAllowPOI=str2num(get(handles.NoiseAllowPOI,'String'));
    POIThld=[POIThld NoiseAllowPOI];


    ROI_masks_all=zeros(m,n,FrameNum);
    ROI_masks_all_2GCh=zeros(m,n,FrameNum);
    ROI_GCh_CaWave=zeros(1,FrameNum);
    ROI_GCh_nonCaWave=zeros(1,FrameNum);
    ROI_RCh_SR101Wave=zeros(1,FrameNum);
    ROI_RCh_nonSR101Wave=zeros(1,FrameNum);
    
    
    ROI_GCh=myVideo(x_rec(1):x_rec(2),y_rec(1):y_rec(2),:);
    ROI_RCh=myVideoR(x_rec(1):x_rec(2),y_rec(1):y_rec(2),:);


    %%% if you want to stop in the middle of running window
    ShowRunWin=1;

    %%%%%%%%%%%%%%%%%%%%%%%% find the mask of real rois
    for j=1:FrameNum
        % get the voxel of the ROI
        eachFrameG=ROI_GCh(:,:,j);    
        eachFrameR=ROI_RCh(:,:,j);
    
        % thresholding each frame in the ROI
        ROImean=mean2(eachFrameR(find(eachFrameR.*ROI_BW_Mask)));
        ROIstd=std2(eachFrameR(find(eachFrameR.*ROI_BW_Mask)));
        ROItemp=eachFrameR.*ROI_BW_Mask;
        ROItemp=(ROItemp-ROImean)/ROIstd;

        [row,col]=find(ROItemp>NoiseAllowPOI);
        for i=1:length(row)
            ROI_masks_all(row(i),col(i),j)=1;
        end
    
        % delete individual pixel and fill the hole
        NowImg=ROI_masks_all(:,:,j);
        
        
        % fill the holes
        Mask_filled = imfill(NowImg,'holes');
        holes = Mask_filled & ~NowImg;
        bigholes = bwareaopen(holes, 100);
        smallholes = holes & ~bigholes;
        Mask_filled = NowImg | smallholes;
        NowImg=double(Mask_filled);
        
        
        
        % delete individual pixel and fill the hole
        ImgTemplate=[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
        NowImg2=conv2(NowImg,ImgTemplate,'same').*NowImg;
        NowImg2(find((NowImg2<2/9)))=0;
        NowImg2(find((NowImg2>=2/9)))=1;
%         NowImg2=imfill(NowImg2);    



        ROI_masks_all(:,:,j)=NowImg2;
        
    
    
        % extract the signal out
        if length(row)
            ROI_GCh_CaWave(j)=sum(sum(ROI_GCh(:,:,j).*ROI_masks_all(:,:,j)))/length(row);
            ROI_RCh_SR101Wave(j)=sum(sum(ROI_RCh(:,:,j).*ROI_masks_all(:,:,j)))/length(row);
            ROI_GCh_nonCaWave(j)=sum(sum(ROI_GCh(:,:,j).*(1-ROI_masks_all(:,:,j))))/length(row);
            ROI_RCh_nonSR101Wave(j)=sum(sum(ROI_RCh(:,:,j).*(1-ROI_masks_all(:,:,j))))/length(row); 
        
        else
            ROI_GCh_CaWave(j)=0;
            ROI_RCh_SR101Wave(j)=0;
            ROI_GCh_nonCaWave(j)=1;
            ROI_RCh_nonSR101Wave(j)=1;
        end
        
        % thresholding each frame in the ROI
        ROImean=mean2(eachFrameG(find(eachFrameG.*ROI_BW_Mask)));
        ROIstd=std2(eachFrameG(find(eachFrameG.*ROI_BW_Mask)));
        ROItemp=eachFrameG.*ROI_BW_Mask;
        ROItemp=(ROItemp-ROImean)/ROIstd;

        [row,col]=find(ROItemp>NoiseAllowPOI);
        for i=1:length(row)
            ROI_masks_all_2GCh(row(i),col(i),j)=1;
        end
    
        % delete individual pixel and fill the hole
        NowImg=ROI_masks_all_2GCh(:,:,j);
                % fill the holes
        Mask_filled = imfill(NowImg,'holes');
        holes = Mask_filled & ~NowImg;
        bigholes = bwareaopen(holes, 100);
        smallholes = holes & ~bigholes;
        Mask_filled = NowImg | smallholes;
        NowImg=double(Mask_filled);
        
        
        
        % delete individual pixel and fill the hole
        ImgTemplate=[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
        NowImg2=conv2(NowImg,ImgTemplate,'same').*NowImg;
        NowImg2(find((NowImg2<2/9)))=0;
        NowImg2(find((NowImg2>=2/9)))=1;
%         NowImg2=imfill(NowImg2);    



        ROI_masks_all_2GCh(:,:,j)=NowImg2;
    
    
    end
    try close(h_frame);end

    % % delete the individual pixel in the mask stack
    eval(['global ROI_masks_all_a',num2str(length(AstrocyteIndex))]);
    eval(['ROI_masks_all_a',num2str(length(AstrocyteIndex)),'=ROI_masks_all;']);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% show the window with mask and scroll bar
    RangeCut1=2;
    RangeCut2=FrameNum;
    AorN=1;   % set a marker to distinguish astrocyte and neuron

    hPOIcheckup=GliaTrans_POI_postPOIcheckup;


    while ishandle(hPOIcheckup)
        pause(0.1);
    end

    RangeCutAll=[RangeCutAll;[RangeCut1 RangeCut2]];


    %%%%%% newastrocyte the upper right figure
    %normalize
    BaselineLength = 30;   % 30 frames as baseline for normalization
    % ROI_RCh_SR101Wave(RangeCut1:RangeCut2)=smooth(ROI_RCh_SR101Wave(RangeCut1:RangeCut2),7);
    ROI_RCh_SR101Wave = ROI_RCh_SR101Wave./mean(ROI_RCh_SR101Wave(RangeCut1:RangeCut1+BaselineLength-1));
    %newastrocyte
    axes(handles.axes2);
    hold on;
    hd2=plot(myTimeTicks(RangeCut1:RangeCut2),ROI_RCh_SR101Wave(RangeCut1:RangeCut2)+0.2*(ROIcount-1),presetcolor(ROIcount));
    title('\fontsize{12}SR101 (inside astrocytes/neuropils/neurons)');
    xlim([0 myTimeTicks(end)]);
    fig2_hds=[fig2_hds hd2];
    ROI_RCh_SR101Wave_All=[ROI_RCh_SR101Wave_All;ROI_RCh_SR101Wave];
    if length(STITimeTicks)
        try
            delete(hdl_STI1);
        end
        mylim=get(gca,'ylim');
        hdl_STI1=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
    end
    
    % newastrocyte the middle right figure
    % normalize
    % ROI_GCh_CaWave(RangeCut1:RangeCut2)=smooth(ROI_GCh_CaWave(RangeCut1:RangeCut2),7);
    ROI_GCh_CaWave = ROI_GCh_CaWave./mean(ROI_GCh_CaWave(RangeCut1:RangeCut1+BaselineLength-1));
    %newastrocyte
    axes(handles.axes3);
    hold on;
    hd3=plot(myTimeTicks(RangeCut1:RangeCut2),ROI_GCh_CaWave(RangeCut1:RangeCut2)+0.2*(ROIcount-1),presetcolor(ROIcount),'LineWidth',1);
    title('\fontsize{12}OGB (inside astrocytes/neuropils/neurons)');
    xlim([0 myTimeTicks(end)]);
    fig3_hds=[fig3_hds hd3];
    ROI_GCh_CaWave_All=[ROI_GCh_CaWave_All;ROI_GCh_CaWave];
    if length(STITimeTicks)
        try
            delete(hdl_STI2);
        end
        mylim=get(gca,'ylim');
        hdl_STI2=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
    end


    % newastrocyte the lower right figure
    % normalize
    % ROI_GCh_nonCaWave(RangeCut1:RangeCut2)=smooth(ROI_GCh_nonCaWave(RangeCut1:RangeCut2),7);
    ROI_GCh_nonCaWave = ROI_GCh_nonCaWave./mean(ROI_GCh_nonCaWave(RangeCut1:RangeCut1+BaselineLength-1));
    %newastrocyte
    axes(handles.axes4);
    hold on;
    hd4=plot(myTimeTicks(RangeCut1:RangeCut2),ROI_GCh_nonCaWave(RangeCut1:RangeCut2)+0.2*(ROIcount-1),presetcolor(ROIcount),'LineWidth',1);
    title('\fontsize{12}OGB (outside astrocytes/neurons)');
    xlim([0 myTimeTicks(end)]);
    xlabel('\fontsize{12}Time (s)');
    fig4_hds=[fig4_hds hd4];
    ROI_GCh_nonCaWave_All=[ROI_GCh_nonCaWave_All;ROI_GCh_nonCaWave];
    if length(STITimeTicks)
        try
            delete(hdl_STI3);
        end
        mylim=get(gca,'ylim');
        hdl_STI3=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
    end
    
    
    %%% plot the puff time mark if any
    if str2num(PuffTimeNo1)*str2num(PuffTimeNo2)
        try delete(hdl_11);end
        try delete(hdl_12);end
        try delete(hdl_21);end
        try delete(hdl_22);end
        try delete(hdl_31);end
        try delete(hdl_32);end
        
        PuffStartTime=PuffTimeNo1;
        PuffEndTime=PuffTimeNo2;
        axes(handles.axes2);mylim=get(gca,'ylim');
        hdl_11=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_12=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        axes(handles.axes3);mylim=get(gca,'ylim');
        hdl_21=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_22=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        axes(handles.axes4);mylim=get(gca,'ylim');
        hdl_31=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_32=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');

        
    end

    % divide the Green Ch by Red Ch and save
    % ROI_RCh_nonSR101Wave(RangeCut1:RangeCut2)=smooth(ROI_RCh_nonSR101Wave(RangeCut1:RangeCut2),7);
    ROI_RCh_nonSR101Wave = ROI_RCh_nonSR101Wave./mean(ROI_RCh_nonSR101Wave(RangeCut1:RangeCut1+BaselineLength-1));


    ROI_GandR_CaWave_All=[ROI_GandR_CaWave_All;ROI_GCh_CaWave./ROI_RCh_SR101Wave];
    ROI_GandR_nonCaWave_All=[ROI_GandR_nonCaWave_All;ROI_GCh_nonCaWave./ROI_RCh_nonSR101Wave];


end




% this function is to recut the ROI in time
function RecallCutRangeFun(~, ~)
global ROIPosAll ROIs fig2_hds fig3_hds fig4_hds handlesaxes2 handlesaxes3 handlesaxes4 presetcolor;
global LegendAll POIThld STITimeTicks hdl_STI1 hdl_STI2 hdl_STI3 PuffTimeNo1 PuffTimeNo2;
global hdl_11 hdl_12 hdl_21 hdl_22 hdl_31 hdl_32 FrameTime FFST FrameNo1 FrameNo2 ROI_BW_All ROI_BW_Mask ROI_masks_all_2GCh;
% find which ROI does the mouse click
ROItag = gco;
ROIindx=find(ROIs==ROItag);

ThisROIname=LegendAll{ROIindx};

ROIpos=ROIPosAll{ROIindx};

ROI_BW=ROI_BW_All(:,:,ROIindx);

eval(['global ROI_masks_all_',LegendAll{ROIindx},';']);
eval(['clear ROI_masks_all_',LegendAll{ROIindx},';']);
delete(fig2_hds(ROIindx));
delete(fig3_hds(ROIindx));
try delete(fig4_hds(ROIindx));end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% call the PostPOIcheckup interface
% preset parameters
global ROI_GCh ROI_RCh BlueImg NoiseAllowPOI handlesNoiseAllowPOI ROI_masks_all ROI_GCh_CaWave ROI_GCh_nonCaWave FrameNum GreenImg RedImg FrameHeight RangeCut1 RangeCut2 RangeCutAll;
global myTimeTicks ROI_RCh_SR101Wave_All ROI_GCh_CaWave_All ROI_GCh_nonCaWave_All ROI_GandR_CaWave_All ROI_GandR_nonCaWave_All handlesOGBChannel AorN;
global myVideo myVideoR ROI_RCh_SR101Wave;

if ThisROIname(1)=='a'

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% call the PostPOIcheckup interface
    % preset parameters
    x_rec=[floor(min(ROIpos(:,1))),ceil(max(ROIpos(:,1)))];
    y_rec=[floor(min(ROIpos(:,2))),ceil(max(ROIpos(:,2)))];
    
    % prepare for Ca detection
    m=x_rec(2)-x_rec(1)+1;
    n=y_rec(2)-y_rec(1)+1;
    
    ROI_BW_Mask=ROI_BW(x_rec(1):x_rec(2),y_rec(1):y_rec(2));
    
   % preset parameters

    ROI_GCh=zeros(m,n,FrameNum); 
    ROI_RCh=zeros(m,n,FrameNum);  
    
    ROI_GCh=myVideo(x_rec(1):x_rec(2),y_rec(1):y_rec(2),:);
    ROI_RCh=myVideoR(x_rec(1):x_rec(2),y_rec(1):y_rec(2),:);
    
    NoiseAllowPOI=POIThld(ROIindx);
    

    ROI_masks_all=zeros(m,n,FrameNum);
    ROI_masks_all_2GCh=zeros(m,n,FrameNum);
    ROI_GCh_CaWave=zeros(1,FrameNum);
    ROI_GCh_nonCaWave=zeros(1,FrameNum);
    ROI_RCh_SR101Wave=zeros(1,FrameNum);
    ROI_RCh_nonSR101Wave=zeros(1,FrameNum);

    %%%%% find the mask of real rois
    for j=1:FrameNum
        
        % get the voxel of the ROI
        eachFrameG=ROI_GCh(:,:,j);    
        eachFrameR=ROI_RCh(:,:,j);        
    
        % thresholding each frame in the ROI
        ROImean=mean2(eachFrameR(find(eachFrameR.*ROI_BW_Mask)));
        ROIstd=std2(eachFrameR(find(eachFrameR.*ROI_BW_Mask)));
        ROItemp=eachFrameR.*ROI_BW_Mask;
        ROItemp=(ROItemp-ROImean)/ROIstd;

        [row,col]=find(ROItemp>NoiseAllowPOI);
        for i=1:length(row)
            ROI_masks_all(row(i),col(i),j)=1;
        end
        
        % delete individual pixel and fill the hole
        NowImg=ROI_masks_all(:,:,j);
        % fill the holes
        Mask_filled = imfill(NowImg,'holes');
        holes = Mask_filled & ~NowImg;
        bigholes = bwareaopen(holes, 100);
        smallholes = holes & ~bigholes;
        Mask_filled = NowImg | smallholes;
        NowImg=double(Mask_filled);
        
        
        
        % delete individual pixel and fill the hole
        ImgTemplate=[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
        NowImg2=conv2(NowImg,ImgTemplate,'same').*NowImg;
        NowImg2(find((NowImg2<2/9)))=0;
        NowImg2(find((NowImg2>=2/9)))=1;
%         NowImg2=imfill(NowImg2);    

        ROI_masks_all(:,:,j)=NowImg2;
        
        
    
        % extract the signal out
        if length(row)
            ROI_GCh_CaWave(j)=sum(sum(ROI_GCh(:,:,j).*ROI_masks_all(:,:,j)))/length(row);
            ROI_RCh_SR101Wave(j)=sum(sum(ROI_RCh(:,:,j).*ROI_masks_all(:,:,j)))/length(row);
            ROI_GCh_nonCaWave(j)=sum(sum(ROI_GCh(:,:,j).*(1-ROI_masks_all(:,:,j))))/length(row);
            ROI_RCh_nonSR101Wave(j)=sum(sum(ROI_RCh(:,:,j).*(1-ROI_masks_all(:,:,j))))/length(row); 
        
        else
            ROI_GCh_CaWave(j)=0;
            ROI_RCh_SR101Wave(j)=0;
            ROI_GCh_nonCaWave(j)=1;
            ROI_RCh_nonSR101Wave(j)=1;
        end
        
        % thresholding each frame in the ROI
        ROImean=mean2(eachFrameG(find(eachFrameG.*ROI_BW_Mask)));
        ROIstd=std2(eachFrameG(find(eachFrameG.*ROI_BW_Mask)));
        ROItemp=eachFrameG.*ROI_BW_Mask;
        ROItemp=(ROItemp-ROImean)/ROIstd;

        [row,col]=find(ROItemp>NoiseAllowPOI);
        for i=1:length(row)
            ROI_masks_all_2GCh(row(i),col(i),j)=1;
        end
    
        % delete individual pixel and fill the hole
        NowImg=ROI_masks_all_2GCh(:,:,j);
        % fill the holes
        Mask_filled = imfill(NowImg,'holes');
        holes = Mask_filled & ~NowImg;
        bigholes = bwareaopen(holes, 100);
        smallholes = holes & ~bigholes;
        Mask_filled = NowImg | smallholes;
        NowImg=double(Mask_filled);
        
        
        
        % delete individual pixel and fill the hole
        ImgTemplate=[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
        NowImg2=conv2(NowImg,ImgTemplate,'same').*NowImg;
        NowImg2(find((NowImg2<2/9)))=0;
        NowImg2(find((NowImg2>=2/9)))=1;
%         NowImg2=imfill(NowImg2);    

        ROI_masks_all_2GCh(:,:,j)=NowImg2;
    
    end
 
    %%% delete the individual pixel in the mask stack
    % ROI_masks_all=DeleteSinglePixel(ROI_masks_all);
    eval(['global ROI_masks_all_',ThisROIname]);
    eval(['ROI_masks_all_',ThisROIname,'=ROI_masks_all;']);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% show the window with mask and scroll bar
    RangeCut1=RangeCutAll(ROIindx,1);
    RangeCut2=RangeCutAll(ROIindx,2);
    AorN=1;   % set a marker to distinguish astrocyte and neuron

    hPOIcheckup=GliaTrans_POI_postPOIcheckup;

    while ishandle(hPOIcheckup)
        pause(0.1);
    end

    RangeCutAll(ROIindx,:)=[RangeCut1 RangeCut2];
    
elseif ThisROIname(1)=='n'
    % preset parameters
    x_rec=[floor(min(ROIpos(:,1))),ceil(max(ROIpos(:,1)))];
    y_rec=[floor(min(ROIpos(:,2))),ceil(max(ROIpos(:,2)))];
    
    % prepare for Ca detection
    m=x_rec(2)-x_rec(1)+1;
    n=y_rec(2)-y_rec(1)+1;
    
    ROI_BW_Mask=ROI_BW(x_rec(1):x_rec(2),y_rec(1):y_rec(2));

    %%% POI method
    % preset parameters
    ROI_GCh=zeros(m,n,FrameNum); 
    ROI_RCh=zeros(m,n,FrameNum); 
    
    ROI_GCh=myVideo(x_rec(1):x_rec(2),y_rec(1):y_rec(2),:);
    ROI_RCh=myVideoR(x_rec(1):x_rec(2),y_rec(1):y_rec(2),:);
    
    NoiseAllowPOI=POIThld(ROIindx);

    ROI_masks_all=zeros(m,n,FrameNum);
    ROI_masks_all_2GCh=zeros(m,n,FrameNum);
    ROI_GCh_CaWave=zeros(1,FrameNum);
    ROI_GCh_nonCaWave=zeros(1,FrameNum);
    ROI_RCh_SR101Wave=zeros(1,FrameNum);
    ROI_RCh_nonSR101Wave=zeros(1,FrameNum);
    
    %%%%%%%%%%%%%%%%%%%%%%%% find the mask of real rois
    for j=1:FrameNum
        % get the voxel of the ROI
        eachFrameG=ROI_GCh(:,:,j);    
        eachFrameR=ROI_RCh(:,:,j);
    
        % thresholding each frame in the ROI
        ROImean=mean2(eachFrameG(find(eachFrameG.*ROI_BW_Mask)));
        ROIstd=std2(eachFrameG(find(eachFrameG.*ROI_BW_Mask)));
        ROItemp=eachFrameG.*ROI_BW_Mask;
        ROItemp=(ROItemp-ROImean)/ROIstd;

        [row,col]=find(ROItemp>NoiseAllowPOI);
        for i=1:length(row)
            ROI_masks_all(row(i),col(i),j)=1;
        end
    
        % delete individual pixel and fill the hole
        NowImg=ROI_masks_all(:,:,j);
        % fill the holes
        Mask_filled = imfill(NowImg,'holes');
        holes = Mask_filled & ~NowImg;
        bigholes = bwareaopen(holes, 100);
        smallholes = holes & ~bigholes;
        Mask_filled = NowImg | smallholes;
        NowImg=double(Mask_filled);
        
        
        
        % delete individual pixel and fill the hole
        ImgTemplate=[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
        NowImg2=conv2(NowImg,ImgTemplate,'same').*NowImg;
        NowImg2(find((NowImg2<2/9)))=0;
        NowImg2(find((NowImg2>=2/9)))=1;
%         NowImg2=imfill(NowImg2);    
    
        ROI_masks_all(:,:,j)=NowImg2;
    
        % extract the signal out
        if length(row)
            ROI_GCh_CaWave(j)=sum(sum(ROI_GCh(:,:,j).*ROI_masks_all(:,:,j)))/length(row);
            ROI_RCh_SR101Wave(j)=sum(sum(ROI_RCh(:,:,j).*ROI_masks_all(:,:,j)))/length(row);
            ROI_GCh_nonCaWave(j)=sum(sum(ROI_GCh(:,:,j).*(1-ROI_masks_all(:,:,j))))/length(row);
            ROI_RCh_nonSR101Wave(j)=sum(sum(ROI_RCh(:,:,j).*(1-ROI_masks_all(:,:,j))))/length(row); 
        
        else
            ROI_GCh_CaWave(j)=0;
            ROI_RCh_SR101Wave(j)=0;
            ROI_GCh_nonCaWave(j)=1;
            ROI_RCh_nonSR101Wave(j)=1;
        end
    
    end

    % % delete the individual pixel in the mask stack
    eval(['global ROI_masks_all_',ThisROIname]);
    eval(['ROI_masks_all_',ThisROIname,'=ROI_masks_all;']);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% show the window with mask and scroll bar
    RangeCut1=RangeCutAll(ROIindx,1);
    RangeCut2=RangeCutAll(ROIindx,2);
    AorN=2;   % set a marker to distinguish astrocyte and neuron


    hPOIcheckup=GliaTrans_POI_postPOIcheckup;

    while ishandle(hPOIcheckup)
        pause(0.1);
    end

    RangeCutAll(ROIindx,:)=[RangeCut1 RangeCut2];
    
elseif ThisROIname(1)=='p'
    x_rec=[floor(min(ROIpos(:,1))),ceil(max(ROIpos(:,1)))];
    y_rec=[floor(min(ROIpos(:,2))),ceil(max(ROIpos(:,2)))];
    
    % prepare for Ca detection
    m=x_rec(2)-x_rec(1)+1;
    n=y_rec(2)-y_rec(1)+1;
    
    ROI_BW_Mask=ROI_BW(x_rec(1):x_rec(2),y_rec(1):y_rec(2));

    % preset parameters
    ROI_GCh=zeros(m,n,FrameNum); 
    ROI_RCh=zeros(m,n,FrameNum);  
    
    ROI_GCh=myVideo(x_rec(1):x_rec(2),y_rec(1):y_rec(2),:);
    ROI_RCh=myVideoR(x_rec(1):x_rec(2),y_rec(1):y_rec(2),:);
    
    ROI_GCh_CaWave=zeros(1,FrameNum);
    ROI_RCh_SR101Wave=zeros(1,FrameNum);

    % get the neuropil signals
    for j=1:FrameNum
        % get the voxel of the ROI
        eachFrameG=ROI_GCh(:,:,j);    
        eachFrameR=ROI_RCh(:,:,j);
        
        % get the voxel of the ROI    
        ROI_GCh_CaWave(j)=mean2(eachFrameG(find(eachFrameG.*ROI_BW_Mask)));

        ROI_RCh_SR101Wave(j)=mean2(eachFrameR(find(eachFrameR.*ROI_BW_Mask)));
   
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% show the window with mask and scroll bar
    RangeCut1=RangeCutAll(ROIindx,1);
    RangeCut2=RangeCutAll(ROIindx,2);

    hNeuropilRC=GliaTrans_POI_NeuropilRangeCut;


    while ishandle(hNeuropilRC)
        pause(0.1);
    end

    RangeCutAll(ROIindx,:)=[RangeCut1 RangeCut2];
    
    ROI_GCh_nonCaWave = zeros(size(ROI_GCh_CaWave));


end

%%%%%% newastrocyte the upper right figure
%normalize
BaselineLength = 30;   % 30 frames as baseline for normalization
ROI_RCh_SR101Wave = ROI_RCh_SR101Wave./mean(ROI_RCh_SR101Wave(RangeCut1:RangeCut1+BaselineLength-1));
%newastrocyte
axes(handlesaxes2);
hold on;
hd2=plot(myTimeTicks(RangeCut1:RangeCut2),ROI_RCh_SR101Wave(RangeCut1:RangeCut2)+0.2*(ROIindx-1),presetcolor(ROIindx));
title('\fontsize{12}SR101 (inside astrocytes/neuropils/neurons)');
xlim([0 myTimeTicks(end)]);
fig2_hds(ROIindx)=hd2;
ROI_RCh_SR101Wave_All(ROIindx,:)=ROI_RCh_SR101Wave;
if length(STITimeTicks)
        try
            delete(hdl_STI1);
        end
        mylim=get(gca,'ylim');
        hdl_STI1=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
end


% newastrocyte the middle right figure
% normalize
ROI_GCh_CaWave = ROI_GCh_CaWave./mean(ROI_GCh_CaWave(RangeCut1:RangeCut1+BaselineLength-1));
%newastrocyte
axes(handlesaxes3);
hold on;
hd3=plot(myTimeTicks(RangeCut1:RangeCut2),ROI_GCh_CaWave(RangeCut1:RangeCut2)+0.2*(ROIindx-1),presetcolor(ROIindx),'LineWidth',1);
title('\fontsize{12}OGB (inside astrocytes/neuropils/neurons)');
xlim([0 myTimeTicks(end)]);
fig3_hds(ROIindx)=hd3;
ROI_GCh_CaWave_All(ROIindx,:)=ROI_GCh_CaWave;
if length(STITimeTicks)
        try
            delete(hdl_STI2);
        end
        mylim=get(gca,'ylim');
        hdl_STI2=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
end

% newastrocyte the lower right figure
% normalize
if sum(ROI_GCh_nonCaWave)
    ROI_GCh_nonCaWave = ROI_GCh_nonCaWave./mean(ROI_GCh_nonCaWave(RangeCut1:RangeCut1+BaselineLength-1));
    %newastrocyte
    axes(handlesaxes4);
    hold on;
    hd4=plot(myTimeTicks(RangeCut1:RangeCut2),ROI_GCh_nonCaWave(RangeCut1:RangeCut2)+0.2*(ROIindx-1),presetcolor(ROIindx),'LineWidth',1);
    title('\fontsize{12}OGB (outside astrocytes/neurons)');
    xlim([0 myTimeTicks(end)]);
    xlabel('\fontsize{12}Time (s)');
    fig4_hds(ROIindx)=hd4;
    ROI_GCh_nonCaWave_All(ROIindx,:)=ROI_GCh_nonCaWave;
else
    fig4_hds(ROIindx)=0;
    ROI_GCh_nonCaWave_All(ROIindx,:)=ROI_GCh_nonCaWave;
end
if length(STITimeTicks)
        try
            delete(hdl_STI3);
        end
        mylim=get(gca,'ylim');
        hdl_STI3=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
end

 %%% plot the puff time mark if any
if str2num(PuffTimeNo1)*str2num(PuffTimeNo2)
        try delete(hdl_11);end
        try delete(hdl_12);end
        try delete(hdl_21);end
        try delete(hdl_22);end
        try delete(hdl_31);end
        try delete(hdl_32);end
        
        PuffStartTime=PuffTimeNo1;
        PuffEndTime=PuffTimeNo2;
        axes(handles.axes2);mylim=get(gca,'ylim');
        hdl_11=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_12=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        axes(handles.axes3);mylim=get(gca,'ylim');
        hdl_21=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_22=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        axes(handles.axes4);mylim=get(gca,'ylim');
        hdl_31=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_32=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');

        
end



% divide the Green Ch by Red Ch and save
if sum(ROI_GCh_nonCaWave)
    ROI_RCh_nonSR101Wave = ROI_RCh_nonSR101Wave./mean(ROI_RCh_nonSR101Wave(RangeCut1:RangeCut1+BaselineLength-1));
    ROI_GandR_CaWave_All(ROIindx,:)=ROI_GCh_CaWave./ROI_RCh_SR101Wave;
    ROI_GandR_nonCaWave_All(ROIindx,:)=ROI_GCh_nonCaWave./ROI_RCh_nonSR101Wave;
else
    ROI_GandR_CaWave_All(ROIindx,:)=ROI_GCh_CaWave./ROI_RCh_SR101Wave;
    ROI_GandR_nonCaWave_All(ROIindx,:)=zeros(size(ROI_GCh_CaWave));
end


function DeleteROINew(~, ~)
%
global ROIcount ROIs ROIPosAll fig2_hds ROI_RCh_SR101Wave_All fig3_hds ROI_GCh_CaWave_All fig4_hds ROI_GCh_nonCaWave_All text_hds;
global ROI_GandR_CaWave_All ROI_GandR_nonCaWave_All RangeCutAll AstrocyteIndex NeuropilIndex NeuronIndex LegendAll presetcolor;
global handlesaxes1 handlesaxes2 handlesaxes3 handlesaxes4 myTimeTicks hExcludeROIs ExcludeROIsPos POIThld;
global ROI_BW_All ROIPosAllRec;

% find which ROI does the mouse click
ROItag = gco;
if ismember(ROItag,hExcludeROIs)
    ExDoth=find(hExcludeROIs==ROItag);
    delete(hExcludeROIs(ExDoth));
    hExcludeROIs(ExDoth)=[];
    ExcludeROIsPos(ExDoth,:)=[];
elseif ismember(ROItag,ROIs)
    ROIindx_all=find(ROIs==ROItag);
    % delete the changed curves
    for i=ROIindx_all:length(ROIs)
        delete(ROIs(i));
        delete(text_hds(i));
        delete(fig2_hds(i));
        delete(fig3_hds(i));
        if fig4_hds(i)
            delete(fig4_hds(i));
        end
    end
    ROIs(ROIindx_all)=[];
    text_hds(ROIindx_all)=[];
    LegendAll{ROIindx_all}=[];
    ROIPosAll(ROIindx_all)=[];
    RangeCutAll(ROIindx_all,:)=[];
    fig2_hds(ROIindx_all)=[];
    fig3_hds(ROIindx_all)=[];
    fig4_hds(ROIindx_all)=[];
    POIThld(ROIindx_all)=[];
    ROI_RCh_SR101Wave_All(ROIindx_all,:)=[];
    ROI_GCh_CaWave_All(ROIindx_all,:)=[];
    ROI_GCh_nonCaWave_All(ROIindx_all,:)=[];
    ROI_GandR_CaWave_All(ROIindx_all,:)=[];
    ROI_GandR_nonCaWave_All(ROIindx_all,:)=[];
    ROI_BW_All(:,:,ROIindx_all)=[];
    ROIPosAllRec(ROIindx_all,:)=[];
    
    if ROIindx_all<ROIcount
        for jj=ROIindx_all:ROIcount-1
            LegendAll{jj}=LegendAll{jj+1};
        end
        LegendAll{ROIcount}=[];
        
    elseif ROIindx_all==ROIcount
        LegendAll{ROIindx_all}=[];
    end


    if ismember(ROIindx_all,AstrocyteIndex)
        ROIindx_cellspfc=find(AstrocyteIndex==ROIindx_all);    
        % modify the mask file
        for j=ROIindx_cellspfc:length(AstrocyteIndex)
            eval(['global ROI_masks_all_a',num2str(j)]);
        end
        for j=ROIindx_cellspfc+1:length(AstrocyteIndex)
            eval(['ROI_masks_all_a',num2str(j-1),'=','ROI_masks_all_a',num2str(j),';']);    
        end
        eval(['clear ROI_masks_all_a',num2str(length(AstrocyteIndex)),';']);
        % delete the index
        AstrocyteIndex(ROIindx_cellspfc)=[];
    
    elseif ismember(ROIindx_all,NeuropilIndex)
        ROIindx_cellspfc=find(NeuropilIndex==ROIindx_all);    
        % delete the index
        NeuropilIndex(ROIindx_cellspfc)=[];
    
    elseif ismember(ROIindx_all,NeuronIndex)
        ROIindx_cellspfc=find(NeuronIndex==ROIindx_all);    
        % modify the mask file
        for j=ROIindx_cellspfc:length(NeuronIndex)
            eval(['global ROI_masks_all_n',num2str(j)]);
        end
        for j=ROIindx_cellspfc+1:length(NeuronIndex)
            eval(['ROI_masks_all_n',num2str(j-1),'=','ROI_masks_all_n',num2str(j),';']);    
        end
        eval(['clear ROI_masks_all_n',num2str(length(NeuronIndex)),';']);
        % delete the index
        NeuronIndex(ROIindx_cellspfc)=[];
    
    else
        warndlg('CANNOT find this ROI info in the ROI list','!! Warning !!');
        quit;
    end

    % delete the index
    AstrocyteIndex(AstrocyteIndex>ROIindx_all)=AstrocyteIndex(AstrocyteIndex>ROIindx_all)-1;
    NeuropilIndex(NeuropilIndex>ROIindx_all)=NeuropilIndex(NeuropilIndex>ROIindx_all)-1;
    NeuronIndex(NeuronIndex>ROIindx_all)=NeuronIndex(NeuronIndex>ROIindx_all)-1;
    
    % replot the changed curves
    
    for i=ROIindx_all:length(ROIs)
        % replot axes1
        axes(handlesaxes1);hold on;
        ROIpos=ROIPosAll{i};
        hh=plot(ROIpos(:,1),ROIpos(:,2),presetcolor(i),'LineWidth',2);
        ROIs(i)=hh;
        % Mark the index of the ROI in the image
        MposX=mean(ROIpos(:,1));
        MposY=mean(ROIpos(:,2));
        if ismember(i,AstrocyteIndex)
            thd=text(MposX,MposY,['a',int2str(find(AstrocyteIndex==i))],'color',presetcolor(i),'Fontsize',12);
            LegendAll{i}=['a',int2str(find(AstrocyteIndex==i))];
        elseif ismember(i,NeuropilIndex)
            thd=text(MposX,MposY,['p',int2str(find(NeuropilIndex==i))],'color',presetcolor(i),'Fontsize',12);
            LegendAll{i}=['p',int2str(find(NeuropilIndex==i))];
        elseif ismember(i,NeuronIndex)
            thd=text(MposX,MposY,['n',int2str(find(NeuronIndex==i))],'color',presetcolor(i),'Fontsize',12);  
            LegendAll{i}=['n',int2str(find(NeuronIndex==i))];
        end
        text_hds(i)=thd;   
        % create a right click menu for this ROIs
        uic = uicontextmenu;
        uimenu ( uic, 'Label','Delete','Callback',@DeleteROINew);
        uimenu ( uic, 'Label','Recut in time','Callback',@RecallCutRangeFun);
        set ( hh, 'uicontextmenu',uic);
    
        % replot axes2
        RangeCut1=RangeCutAll(i,1);RangeCut2=RangeCutAll(i,2);
        ROI_RCh_SR101Wave=ROI_RCh_SR101Wave_All(i,:);
        axes(handlesaxes2); hold on;
        hd2=plot(myTimeTicks(RangeCut1:RangeCut2),ROI_RCh_SR101Wave(RangeCut1:RangeCut2)+0.2*(i-1),presetcolor(i));
        title('\fontsize{12}SR101 (inside astrocytes/neuropil/neurons)');
        xlim([0 myTimeTicks(end)]);
        fig2_hds(i)=hd2;
    
        % replot axes3
        ROI_GCh_CaWave=ROI_GCh_CaWave_All(i,:);
        axes(handlesaxes3);hold on;
        hd3=plot(myTimeTicks(RangeCut1:RangeCut2),ROI_GCh_CaWave(RangeCut1:RangeCut2)+0.2*(i-1),presetcolor(i),'LineWidth',1);
        title('\fontsize{12}OGB (inside astrocytes/neuropil/neurons)');
        xlim([0 myTimeTicks(end)]);
        fig3_hds(i)=hd3;
    
        %replot axes4
        ROI_GCh_nonCaWave=ROI_GCh_nonCaWave_All(i,:);
        if sum(ROI_GCh_nonCaWave)
            axes(handlesaxes4);hold on;
            hd4=plot(myTimeTicks(RangeCut1:RangeCut2),ROI_GCh_nonCaWave(RangeCut1:RangeCut2)+0.2*(i-1),presetcolor(i),'LineWidth',1);
            title('\fontsize{12}OGB (outside astrocytes/neurons)');
            xlim([0 myTimeTicks(end)]);
            xlabel('\fontsize{12}Time (s)');
            fig4_hds(i)=hd4;
        else
            fig4_hds(i)=0;
        end
    
    end

    ROIcount=ROIcount-1;
    
    if ROIcount==0
        ROI_BW_All=[];
    end
else
    warndlg('CANNOT find this ROI info in the ROI_all list','!! Warning !!');
    quit;
end




% --- Executes during object creation, after setting all properties.
function mesfilename_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in popout2.
function popout2_Callback(hObject, eventdata, handles)
global FrameTime FFST presetcolor;
global myTimeTicks PuffTimeNo1 PuffTimeNo2 BaseLineFrameNo;
global ROI_RCh_SR101Wave_All ROI_GCh_CaWave_All ROI_GCh_CaDivdeRed_All ROIcount CutFrameNum1 CutFrameNum2;

hd12=figure(12);
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






% --- Executes on button press in popout3.
function popout3_Callback(hObject, eventdata, handles)

global FrameTime FFST presetcolor;
global myTimeTicks PuffTimeNo1 PuffTimeNo2 BaseLineFrameNo;
global ROI_RCh_SR101Wave_All ROI_GCh_CaWave_All ROI_GCh_CaDivdeRed_All ROIcount CutFrameNum1 CutFrameNum2;

Xcorr_All = zeros(size(ROI_GCh_CaWave_All,1),size(ROI_GCh_CaWave_All,1));

for ii = 1:size(ROI_GCh_CaWave_All,1)
    for jj = 1:size(ROI_GCh_CaWave_All,1)
        Curve1 = ROI_GCh_CaWave_All(ii,:);
        Curve2 = ROI_GCh_CaWave_All(jj,:);
        [R_xy,lags] = xcorr(Curve1-1, Curve2-1,'coeff');
        Xcorr_All(ii,jj)=max(max(R_xy));

    end
end

figure;imagesc(Xcorr_All);colormap('jet');axis ij;


ROI_GCh_CaWave_All_newOrd = zeros(size(ROI_GCh_CaWave_All));
ROI_GCh_CaWave_All_newOrd(1,:) = ROI_GCh_CaWave_All(2,:);
ROI_GCh_CaWave_All_newOrd(2,:) = ROI_GCh_CaWave_All(1,:);
ROI_GCh_CaWave_All_newOrd(3,:) = ROI_GCh_CaWave_All(6,:);
ROI_GCh_CaWave_All_newOrd(4,:) = ROI_GCh_CaWave_All(7,:);
ROI_GCh_CaWave_All_newOrd(5,:) = ROI_GCh_CaWave_All(8,:);
ROI_GCh_CaWave_All_newOrd(6,:) = ROI_GCh_CaWave_All(12,:);
ROI_GCh_CaWave_All_newOrd(7,:) = ROI_GCh_CaWave_All(3,:);
ROI_GCh_CaWave_All_newOrd(8,:) = ROI_GCh_CaWave_All(4,:);
ROI_GCh_CaWave_All_newOrd(9,:) = ROI_GCh_CaWave_All(5,:);
ROI_GCh_CaWave_All_newOrd(10,:) = ROI_GCh_CaWave_All(9,:);
ROI_GCh_CaWave_All_newOrd(11,:) = ROI_GCh_CaWave_All(10,:);
ROI_GCh_CaWave_All_newOrd(12,:) = ROI_GCh_CaWave_All(11,:);
ROI_GCh_CaWave_All_newOrd(13,:) = ROI_GCh_CaWave_All(13,:);


correlationMatrix = corr(ROI_GCh_CaWave_All_newOrd.');
figure;imagesc(correlationMatrix);colormap('jet');axis ij;


hd13=figure(13);
hold on;
correctBaseline = 1;
for i=1:ROIcount
    if CutFrameNum1<=BaseLineFrameNo
        if correctBaseline
            Ca_tmp = ROI_GCh_CaWave_All(i,CutFrameNum1:CutFrameNum2);
            % Ca_tmp = Ca_tmp2
            baseline2 = asLS_baseline_v1(Ca_tmp);
            Ca_tmp2 = Ca_tmp-baseline2.'+1;
            plot(myTimeTicks(CutFrameNum1:CutFrameNum2),Ca_tmp2,presetcolor(i),'LineWidth',2,'LineStyle','-');

        end
        % plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaWave_All(i,CutFrameNum1:CutFrameNum2),presetcolor(i),'LineWidth',2);
    else
        plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaWave_All(i,CutFrameNum1:CutFrameNum2),presetcolor(i),'LineWidth',2);
    end
end
title('\fontsize{12}Ca^{2+} inside the defined EC');
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



% --- Executes on button press in popout4.
function popout4_Callback(hObject, eventdata, handles)
global FrameTime FFST presetcolor;
global myTimeTicks PuffTimeNo1 PuffTimeNo2 BaseLineFrameNo;
global ROI_RCh_SR101Wave_All ROI_GCh_CaWave_All ROI_GCh_CaDivdeRed_All ROIcount CutFrameNum1 CutFrameNum2;


hd14=figure(14);
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




% --- Executes on button press in GliaTransDetect.
function GliaTransDetect_Callback(hObject, eventdata, handles)
global FrameNum presetcolor ROIcount FrameTime FFST RangeCutAll ROI_GCh_CaWave_All ROI_GCh_nonCaWave_All ROI_RCh_SR101Wave_All;
global ROI_GandR_CaWave_All ROI_GandR_nonCaWave_All myTimeTicks GliaTrans_GCh_inside GliaTrans_GCh_outside GliaTrans_GandR_inside GliaTrans_GandR_outside;
global BaselinePeriod TransDuration_min TransDuration_max NoiseAllowTransDet CorrectBLdriftOrNot SplitRoiWavesOrNot PeakAmpThld LegendAll;
global STITimeTicks FrameNo1 FrameNo2;

% preset parameters
GliaTrans_GCh_inside=zeros(200,8);
GliaTrans_GCh_outside=zeros(200,8); 
GliaTrans_GandR_inside=zeros(200,8); 
GliaTrans_GandR_outside=zeros(200,8);
GTNum_GCh_inside=1;   % count the glia transient's number
GTNum_GCh_outside=1;
GTNum_GandR_inside=1;
GTNum_GandR_outside=1;

% read in the parameters from interface
SmoothWinSize = str2num(get(handles.SmoothWinSizeNew,'String')); 
BaselinePeriod = str2num(get(handles.BaselinePeriod_BTD,'String'));    % Use the 30s wave as the baseline, i.e. length of running window
TransDuration_min = str2num(get(handles.TransDurationMin_GTD,'String'));      % The transient should last at least 2 sec
TransDuration_max = str2num(get(handles.TransDurationMax_GTD,'String'));  % The transient duration should not be over this time.
NoiseAllowTransDet = str2num(get(handles.NoiseAllow_GTD,'String'));         % >= mean + standarddeviation * NoiseAllow       by default, it's 2.
PeakAmpThld=str2num(get(handles.PeakAmpThld,'String'))*0.01;                % use this parameter to delete the very small peak that is detected in the traces.

% convert to frames for transient detection             
BaselinePeriod_FN = round(BaselinePeriod/FrameTime*1000);   % convert time to number of frame
TransDuration_min_FN = round(TransDuration_min/FrameTime*1000);     % convert time to number of frame
TransDuration_max_FN = round(TransDuration_max/FrameTime*1000);


% do correction of baseline drift
ROI_GCh_CaWave_All0=ROI_GCh_CaWave_All;         % I don't want to change the global variables and can't change it back
ROI_GCh_nonCaWave_All0=ROI_GCh_nonCaWave_All;
ROI_GandR_CaWave_All0=ROI_GandR_CaWave_All;
ROI_GandR_nonCaWave_All0=ROI_GandR_nonCaWave_All;
ROI_RCh_SR101Wave_All0=ROI_RCh_SR101Wave_All;

% smooth the waveforms
for i=1:ROIcount
     ROI_RCh_SR101Wave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))=smooth(ROI_RCh_SR101Wave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)),SmoothWinSize,'lowess');
     ROI_GCh_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))=smooth(ROI_GCh_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)),SmoothWinSize,'lowess');
     ROI_GCh_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))=smooth(ROI_GCh_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)),SmoothWinSize,'lowess');
     ROI_GandR_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))=smooth(ROI_GandR_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)),SmoothWinSize,'lowess');
     ROI_GandR_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))=smooth(ROI_GandR_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)),SmoothWinSize,'lowess');
end


% correct baseline
CorrectBLdriftOrNot=get(handles.CorrectBLdrift,'Value');
if get(handles.CorrectBLdrift,'Value')
    for i=1:ROIcount
        Wave4AdjustY=ROI_GCh_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2));
        a = polyfit(RangeCutAll(i,1):RangeCutAll(i,2),Wave4AdjustY,1);
        ROI_GCh_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)) = ROI_GCh_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))-(RangeCutAll(i,1):RangeCutAll(i,2))*a(1);
        ROI_GCh_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)) = ROI_GCh_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))./mean(ROI_GCh_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,1)+5));
        
        Wave4AdjustY=ROI_GCh_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2));
        a = polyfit(RangeCutAll(i,1):RangeCutAll(i,2),Wave4AdjustY,1);
        ROI_GCh_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))=ROI_GCh_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))-(RangeCutAll(i,1):RangeCutAll(i,2))*a(1);
        ROI_GCh_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)) = ROI_GCh_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))./mean(ROI_GCh_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,1)+5));
        
        Wave4AdjustY=ROI_GandR_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2));
        a = polyfit(RangeCutAll(i,1):RangeCutAll(i,2),Wave4AdjustY,1);
        ROI_GandR_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))=ROI_GandR_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))-a(1)*(RangeCutAll(i,1):RangeCutAll(i,2));
        ROI_GandR_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)) = ROI_GandR_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))./mean(ROI_GandR_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,1)+5));
        
        Wave4AdjustY=ROI_GandR_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2));
        a = polyfit(RangeCutAll(i,1):RangeCutAll(i,2),Wave4AdjustY,1);
        ROI_GandR_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))=ROI_GandR_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))-a(1)*(RangeCutAll(i,1):RangeCutAll(i,2));
        ROI_GandR_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)) = ROI_GandR_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))./mean(ROI_GandR_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,1)+5));
        
    end
end

% preset the figure
MyScreenSize = get( 0, 'Screensize' );
hd20=figure(20);hold on;
set(hd20,'Position',MyScreenSize);
% clear the figure
clf(hd20);

subplot(2,2,1);
title('\fontsize{16}OGB (inside)');
xlabel('\fontsize{14}Time (s)');
ylabel('\fontsize{14}Normalized Intensity');
set(gca,'Fontsize',13);
xlim([0 myTimeTicks(end)]);

subplot(2,2,2);
title('\fontsize{16}OGB (outside)');
xlabel('\fontsize{14}Time (s)');
ylabel('\fontsize{14}Normalized Intensity');
set(gca,'Fontsize',13);
xlim([0 myTimeTicks(end)]);

subplot(2,2,3);
title('\fontsize{16}OGB/SR101 (inside)');
xlabel('\fontsize{14}Time (s)');
ylabel('\fontsize{14}Normalized Intensity');
set(gca,'Fontsize',13);
xlim([0 myTimeTicks(end)]);

subplot(2,2,4);
title('\fontsize{16}OGB/SR101 (outside)');
xlabel('\fontsize{14}Time (s)');
ylabel('\fontsize{14}Normalized Intensity');
set(gca,'Fontsize',13);
xlim([0 myTimeTicks(end)]);
    
%%%%%%%%%%%%% Detect the glia transient for different Ca signal source and newastrocyte
SplitRoiWavesOrNot=get(handles.SplitRoiWaves,'Value');
%%% split ROIs waves
if SplitRoiWavesOrNot
    MoveUpwardsStep=0.3;
else
    MoveUpwardsStep=0;
end
% change the Y-axis labels correspondingly
myYTicksLoc=zeros(1,ROIcount);

for i=1:ROIcount
    
    myYTicksLoc(i)=1+MoveUpwardsStep*(i-1);
    
    
    %%% Gch_inside
    temp0=GliaTransDetector(ROI_GCh_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)),BaselinePeriod_FN,TransDuration_min_FN,TransDuration_max_FN,NoiseAllowTransDet,PeakAmpThld,'GIn',i); 
    temp1=horzcat(temp0,ones(size(temp0,1),1)*i);
    GliaTrans_GCh_inside(GTNum_GCh_inside:(GTNum_GCh_inside+size(temp0,1)-1),:)=temp1;
    GTNum_GCh_inside=GTNum_GCh_inside+size(temp1,1);
    %newastrocyte
    subplot(2,2,1);hold on;
    hdl=plot(myTimeTicks(RangeCutAll(i,1):RangeCutAll(i,2)),ROI_GCh_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))+MoveUpwardsStep*(i-1),presetcolor(i),'LineWidth',1,'LineStyle','-');  
    for j=1:size(temp0,1)
        TheGliaTrans=ROI_GCh_CaWave_All0(i,RangeCutAll(i,1)+round(temp0(j,1))-1:RangeCutAll(i,1)+round(temp0(j,1))+round(temp0(j,2))-2)+MoveUpwardsStep*(i-1);
        plot(myTimeTicks(RangeCutAll(i,1)+round(temp0(j,1))-1:RangeCutAll(i,1)+round(temp0(j,1))+round(temp0(j,2))-2),TheGliaTrans,presetcolor(i),'LineWidth',2);  
        rectangle('Position',[myTimeTicks(RangeCutAll(i,1)+round(temp0(j,1))-1) min(TheGliaTrans)-0.05 myTimeTicks(round(temp0(j,1))+round(temp0(j,2)))-myTimeTicks(round(temp0(j,1))) max(TheGliaTrans)-min(TheGliaTrans)+0.1],'EdgeColor',presetcolor(i),'LineStyle','--');
    end


    %%% Gch_outside
    temp0=GliaTransDetector(ROI_GCh_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)),BaselinePeriod_FN,TransDuration_min_FN,TransDuration_max_FN,NoiseAllowTransDet,PeakAmpThld,'GOut',i); 
    temp1=horzcat(temp0,ones(size(temp0,1),1)*i);
    GliaTrans_GCh_outside(GTNum_GCh_outside:(GTNum_GCh_outside+size(temp0,1)-1),:)=temp1;
    GTNum_GCh_outside=GTNum_GCh_outside+size(temp1,1);
    %newastrocyte
    subplot(2,2,2);hold on;
    hdl=plot(myTimeTicks(RangeCutAll(i,1):RangeCutAll(i,2)),ROI_GCh_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))+MoveUpwardsStep*(i-1),presetcolor(i),'LineWidth',1,'LineStyle','-');  
    for j=1:size(temp0,1)
        TheGliaTrans=ROI_GCh_nonCaWave_All0(i,RangeCutAll(i,1)+round(temp0(j,1))-1:RangeCutAll(i,1)+round(temp0(j,1))+round(temp0(j,2))-2)+MoveUpwardsStep*(i-1);
        plot(myTimeTicks(RangeCutAll(i,1)+round(temp0(j,1))-1:RangeCutAll(i,1)+round(temp0(j,1))+round(temp0(j,2))-2),TheGliaTrans,presetcolor(i),'LineWidth',2);  
        rectangle('Position',[myTimeTicks(RangeCutAll(i,1)+round(round(temp0(j,1)))-1) min(TheGliaTrans)-0.05 myTimeTicks(round(temp0(j,1))+round(temp0(j,2)))-myTimeTicks(round(temp0(j,1))) max(TheGliaTrans)-min(TheGliaTrans)+0.1],'EdgeColor',presetcolor(i),'LineStyle','--');
        
    end
    
    
    %%% G and R ch_inside
    temp0=GliaTransDetector(ROI_GandR_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)),BaselinePeriod_FN,TransDuration_min_FN,TransDuration_max_FN,NoiseAllowTransDet,PeakAmpThld,'GRin',i); 
    temp1=horzcat(temp0,ones(size(temp0,1),1)*i);
    GliaTrans_GandR_inside(GTNum_GandR_inside:(GTNum_GandR_inside+size(temp0,1)-1),:)=temp1;
    GTNum_GandR_inside=GTNum_GandR_inside+size(temp1,1);
    %newastrocyte
    subplot(2,2,3);hold on;
    hdl=plot(myTimeTicks(RangeCutAll(i,1):RangeCutAll(i,2)),ROI_GandR_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))+MoveUpwardsStep*(i-1),presetcolor(i),'LineWidth',1,'LineStyle','-');  
    for j=1:size(temp0,1)
        TheGliaTrans=ROI_GandR_CaWave_All0(i,RangeCutAll(i,1)+round(temp0(j,1))-1:RangeCutAll(i,1)+round(temp0(j,1))+round(temp0(j,2))-2)+MoveUpwardsStep*(i-1);
        plot(myTimeTicks(RangeCutAll(i,1)+round(temp0(j,1))-1:RangeCutAll(i,1)+round(temp0(j,1))+round(temp0(j,2))-2),TheGliaTrans,presetcolor(i),'LineWidth',2);  
        rectangle('Position',[myTimeTicks(RangeCutAll(i,1)+round(temp0(j,1))-1) min(TheGliaTrans)-0.05 myTimeTicks(round(temp0(j,1))+round(temp0(j,2)))-myTimeTicks(round(temp0(j,1))) max(TheGliaTrans)-min(TheGliaTrans)+0.1],'EdgeColor',presetcolor(i),'LineStyle','--');
        
    end
    
    
    %%% G and R ch_outside
    temp0=GliaTransDetector(ROI_GandR_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)),BaselinePeriod_FN,TransDuration_min_FN,TransDuration_max_FN,NoiseAllowTransDet,PeakAmpThld,'GROut',i); 
    temp1=horzcat(temp0,ones(size(temp0,1),1)*i);
    GliaTrans_GandR_outside(GTNum_GandR_outside:(GTNum_GandR_outside+size(temp0,1)-1),:)=temp1;
    GTNum_GandR_outside=GTNum_GandR_outside+size(temp1,1);
    %newastrocyte
    subplot(2,2,4);hold on;
    hdl=plot(myTimeTicks(RangeCutAll(i,1):RangeCutAll(i,2)),ROI_GandR_nonCaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))+MoveUpwardsStep*(i-1),presetcolor(i),'LineWidth',1,'LineStyle','-');  
    for j=1:size(temp0,1)
        TheGliaTrans=ROI_GandR_nonCaWave_All0(i,RangeCutAll(i,1)+round(temp0(j,1))-1:RangeCutAll(i,1)+round(temp0(j,1))+round(temp0(j,2))-2)+MoveUpwardsStep*(i-1);
        plot(myTimeTicks(RangeCutAll(i,1)+round(temp0(j,1))-1:RangeCutAll(i,1)+round(temp0(j,1))+round(temp0(j,2))-2),TheGliaTrans,presetcolor(i),'LineWidth',2);  
        rectangle('Position',[myTimeTicks(RangeCutAll(i,1)+round(temp0(j,1))-1) min(TheGliaTrans)-0.05 myTimeTicks(round(temp0(j,1))+round(temp0(j,2)))-myTimeTicks(round(temp0(j,1))) max(TheGliaTrans)-min(TheGliaTrans)+0.1],'EdgeColor',presetcolor(i),'LineStyle','--');
        
    end

end



%%% generate YTicks
if SplitRoiWavesOrNot
    sp1=subplot(2,2,1);
    ax = gca;
    set(ax,'YTick',myYTicksLoc);
    set(ax,'YTickLabel',LegendAll);
    ylim(ax,[0.8 myYTicksLoc(end)+0.3]);
    mylim=get(gca,'ylim');
    if length(STITimeTicks)        
        line([STITimeTicks(1) STITimeTicks(1)],[mylim(1)+0.01 mylim(2)-0.01],'Color','k');
        line([STITimeTicks(end) STITimeTicks(end)],[mylim(1)+0.01 mylim(2)-0.01],'Color','k');
    end
    if str2num(FrameNo1)*str2num(FrameNo2)
        PuffStartTime=((str2num(FrameNo1)-2)*FrameTime+FFST)/1000;
        PuffEndTime=((str2num(FrameNo2)-1)*FrameTime+FFST)/1000;
        line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
    end
    % Create second Y axes on the right.
    ax2 = axes('Position',get(sp1,'Position'),...
       'XAxisLocation','bottom',...
       'YAxisLocation','right',...
       'Color','none',...
       'XColor','k','YColor','k',...
       'YLim',[0.8 myYTicksLoc(end)+0.3],...
       'XTick',[]);
    uistack(ax2,'bottom');
    linkaxes([ax ax2],'xy');
    
    
    sp2=subplot(2,2,2);
    ax = gca;
    set(ax,'YTick',myYTicksLoc);
    set(ax,'YTickLabel',LegendAll);
    ylim(ax,[0.8 myYTicksLoc(end)+0.3]);
    if length(STITimeTicks)
        mylim=get(gca,'ylim');
        line([STITimeTicks(1) STITimeTicks(1)],[mylim(1)+0.01 mylim(2)-0.01],'Color','k');
        line([STITimeTicks(end) STITimeTicks(end)],[mylim(1)+0.01 mylim(2)-0.01],'Color','k');
    end   
    if str2num(FrameNo1)*str2num(FrameNo2)
        PuffStartTime=((str2num(FrameNo1)-2)*FrameTime+FFST)/1000;
        PuffEndTime=((str2num(FrameNo2)-1)*FrameTime+FFST)/1000;
        line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
    end
    % Create second Y axes on the right.
    ax2 = axes('Position',get(sp2,'Position'),...
       'XAxisLocation','bottom',...
       'YAxisLocation','right',...
       'Color','none',...
       'XColor','k','YColor','k',...
       'YLim',[0.8 myYTicksLoc(end)+0.3],...
       'XTick',[]);
    uistack(ax2,'bottom');
    linkaxes([ax ax2],'xy');
    
    sp3=subplot(2,2,3);
    ax = gca;
    set(ax,'YTick',myYTicksLoc);
    set(ax,'YTickLabel',LegendAll);
    ylim(ax,[0.8 myYTicksLoc(end)+0.3]);
    if length(STITimeTicks)
        mylim=get(gca,'ylim');
        line([STITimeTicks(1) STITimeTicks(1)],[mylim(1)+0.01 mylim(2)-0.01],'Color','k');
        line([STITimeTicks(end) STITimeTicks(end)],[mylim(1)+0.01 mylim(2)-0.01],'Color','k');
    end    
    if str2num(FrameNo1)*str2num(FrameNo2)
        PuffStartTime=((str2num(FrameNo1)-2)*FrameTime+FFST)/1000;
        PuffEndTime=((str2num(FrameNo2)-1)*FrameTime+FFST)/1000;
        line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
    end
    % Create second Y axes on the right.
    ax2 = axes('Position',get(sp3,'Position'),...
       'XAxisLocation','bottom',...
       'YAxisLocation','right',...
       'Color','none',...
       'XColor','k','YColor','k',...
       'YLim',[0.8 myYTicksLoc(end)+0.3],...
       'XTick',[]);
    uistack(ax2,'bottom');
    linkaxes([ax ax2],'xy');
    
    sp4=subplot(2,2,4);
    ax = gca;
    set(ax,'YTick',myYTicksLoc);
    set(ax,'YTickLabel',LegendAll);
    ylim(ax,[0.8 myYTicksLoc(end)+0.3]);
    if length(STITimeTicks)
        mylim=get(gca,'ylim');
        line([STITimeTicks(1) STITimeTicks(1)],[mylim(1)+0.01 mylim(2)-0.01],'Color','k');
        line([STITimeTicks(end) STITimeTicks(end)],[mylim(1)+0.01 mylim(2)-0.01],'Color','k');
    end  
    if str2num(FrameNo1)*str2num(FrameNo2)
        PuffStartTime=((str2num(FrameNo1)-2)*FrameTime+FFST)/1000;
        PuffEndTime=((str2num(FrameNo2)-1)*FrameTime+FFST)/1000;
        line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
    end
    % Create second Y axes on the right.
    ax2 = axes('Position',get(sp4,'Position'),...
       'XAxisLocation','bottom',...
       'YAxisLocation','right',...
       'Color','none',...
       'XColor','k','YColor','k',...
       'YLim',[0.8 myYTicksLoc(end)+0.3],...
       'XTick',[]);
    uistack(ax2,'bottom');
    linkaxes([ax ax2],'xy');
end


hd101=figure(101);hold on;
for i=1:ROIcount
    
    myYTicksLoc(i)=1+MoveUpwardsStep*(i-1);
    
    
    %%% Gch_inside
    temp0=GliaTransDetector(ROI_GCh_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2)),BaselinePeriod_FN,TransDuration_min_FN,TransDuration_max_FN,NoiseAllowTransDet,PeakAmpThld,'GIn',i); 
    temp1=horzcat(temp0,ones(size(temp0,1),1)*i);    
    
    plot(myTimeTicks(RangeCutAll(i,1):RangeCutAll(i,2)),ROI_GCh_CaWave_All0(i,RangeCutAll(i,1):RangeCutAll(i,2))+MoveUpwardsStep*(i-1),presetcolor(i),'LineWidth',1,'LineStyle','-');  
    for j=1:size(temp0,1)
        TheGliaTrans=ROI_GCh_CaWave_All0(i,RangeCutAll(i,1)+round(temp0(j,1))-1:RangeCutAll(i,1)+round(temp0(j,1))+round(temp0(j,2))-2)+MoveUpwardsStep*(i-1);
        plot(myTimeTicks(RangeCutAll(i,1)+round(temp0(j,1))-1:RangeCutAll(i,1)+round(temp0(j,1))+round(temp0(j,2))-2),TheGliaTrans,presetcolor(i),'LineWidth',2);  
        rectangle('Position',[myTimeTicks(RangeCutAll(i,1)+round(temp0(j,1))-1) min(TheGliaTrans)-0.05 myTimeTicks(round(temp0(j,1))+round(temp0(j,2)))-myTimeTicks(round(temp0(j,1))) max(TheGliaTrans)-min(TheGliaTrans)+0.1],'EdgeColor',presetcolor(i),'LineStyle','--');
    end
end
if length(STITimeTicks)        
    line([STITimeTicks(1) STITimeTicks(1)],[mylim(1)+0.01 mylim(2)-0.01],'Color','k');
    line([STITimeTicks(end) STITimeTicks(end)],[mylim(1)+0.01 mylim(2)-0.01],'Color','k');
end
if str2num(FrameNo1)*str2num(FrameNo2)
    PuffStartTime=((str2num(FrameNo1)-2)*FrameTime+FFST)/1000;
    PuffEndTime=((str2num(FrameNo2)-1)*FrameTime+FFST)/1000;
    line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
    line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
end
xlabel('\fontsize{16}Time (s)');
ylabel('\fontsize{16}Normalized Intensity');
title('\fontsize{18}OGB (Inside)');





function TransReg=GliaTransDetector(Waveform,BaselinePeriod,TransDuration_min,TransDuration_max,NoiseAllow,PeakAmpThld,DataName,ROINum)

global FrameTime LegendAll myTimeTicks;

WF=Waveform;
BP=BaselinePeriod;
TDmin=TransDuration_min;
TDmax=TransDuration_max;
NA=NoiseAllow;
PAT=PeakAmpThld;


% BLMark=1;       % whether the running window will update the mean and std or not
DetectMask=zeros(size(WF));
TransReg=[];    % register the list of transient, first row is start frame, the second row is length of frames for this transient
i=BP+1;         % The first BP number of frames is neglected for transiend detection
while i<=length(WF)  
    
%     disp(['i=',num2str(i)]);

%     if BLMark==1
        BLWin=WF(i-BP:i-1);  % Baseline Window
        BLmean=mean(BLWin);
        BLstd=std(BLWin);
%     end
    
    if WF(i)>=BLmean+NA*BLstd   % the point above the threshold
        PotTransInd=find(WF>=(BLmean+NA*BLstd));  % pontential transient index        
        DetectMask(PotTransInd)=1;             % Mask the 1D curve
        
        % start to judge the length of the train of 1's
        j=i;
        TDlength=0;
        while j<=length(WF)     % length of the 1's train
            if DetectMask(j)==1
                TDlength=TDlength+1;
                j=j+1;
            else 
                break;      % break the loop 'while'
            end
        end
        if TDlength>=TDmin && TDlength<=TDmax && i+TDlength-1<length(WF)
            % get the info of the trace and save to output
            StartFrame=i;
            EndFrame=i+TDlength-1;
            Duration=TDlength;
            CurrentSegment=WF(StartFrame:EndFrame);
            [PeakY,PeakX]=max(CurrentSegment);
            Amplitude=PeakY/BLmean-1;
            TimeToPeak=PeakX;
            PeakToBl=Duration-PeakX;
            AreaUnderCurve=sum(CurrentSegment/BLmean-1)*FrameTime/1000; 
            
            % save to output
            if Amplitude>=PAT
                TransReg=[TransReg;[StartFrame Duration EndFrame Amplitude TimeToPeak PeakToBl AreaUnderCurve]];   % register as a real transient
                i=i+TDlength;                       % update the i to the end of the transient
            end
            %%%%%%%%%%%%%%%%%%
            % After discussion with Jonas, it's possible to have two
            % consecutive transient, with interval <= BaselinePeriod
            % This part of code is to check if there's a second transient
            TDlength2=0;
            if j+BP<=length(WF)
                k=j+1;
                while k<=j+BP      % just need to check the length <=BP
                    if DetectMask(k)==1
                        tt=k;
                        while tt<=length(WF)
                            if DetectMask(tt)==1
                                TDlength2=TDlength2+1;
                                tt=tt+1;
                            else
                                break;    % break the loop 'while'
                            end                        
                        end                    
                        if TDlength2>=TDmin && TDlength2<=TDmax && k+TDlength2-1<length(WF)
                           % get the info of the trace and save to output
                           StartFrame=k;
                           EndFrame=k+TDlength2-1;
                           Duration=TDlength2;
                           CurrentSegment=WF(StartFrame:EndFrame);
                           [PeakY,PeakX]=max(CurrentSegment);
                           Amplitude=PeakY/BLmean-1;                           
                           TimeToPeak=PeakX;
                           PeakToBl=Duration-PeakX; 
                           AreaUnderCurve=sum(CurrentSegment/BLmean-1)*FrameTime/1000; 
                           if Amplitude>=PAT                       
                               TransReg=[TransReg;[StartFrame Duration EndFrame Amplitude TimeToPeak PeakToBl AreaUnderCurve]];   % register as a real transient
                               i=k+TDlength2;
                           end
                           break;
                        elseif TDlength2>TDmax                     
%                            disp([DataName,'_',LegendAll{ROINum},'_E2:[',num2str(myTimeTicks(k)),'s  ',num2str(myTimeTicks(k+TDlength2-1)),'s] (Super long glia transient is detected!)']);
%                            TransRegSL = SuperLongGliaTrans(WF(k:k+TDlength2-1),BP,TDmin,TDmax,NA,PAT);
                           k=k+1;
                        else
                            k=k+1;
                        end
                        TDlength2=0;
                    else
                        k=k+1;
                    end
                end
            end
            i=i+1;  
        elseif TDlength>TDmax
%             disp([DataName,'_',LegendAll{ROINum},'_E1:[',num2str(myTimeTicks(i)),'s  ',num2str(myTimeTicks(i+TDlength-1)),'s] (Super long glia transient is detected!)']);
%             TransRegSL = SuperLongGliaTrans(WF(i:i+TDlength-1),BP,TDmin,TDmax,NA,PAT);
            i=i+1; 
        else
            i=i+1;
        end
        DetectMask=zeros(size(WF));
    else
        i=i+1;
    end
    
end

% % to save the transient from super long segment
% function TransRegSL = SuperLongGliaTrans(WFsl,BP,TDmin,TDmax,NA,PAT)
% 
% global FrameTime;
% 
% 
% FS=1000/FrameTime;
% NFFT=2^nextpow2(length(WFsl));
% Y=fft(WFsl,NFFT)/length(WFsl);
% f=FS/2*linspace(0,1,NFFT/2+1);
% figure;
% YY=2*abs(Y(1:NFFT/2+1));
% bar(f,YY);
% 
% 
% Thld=1/(length(WFsl)/FS*2);
% 
% myfilter=designfilt('highpassiir', 'StopbandFrequency', Thld, 'PassbandFrequency', Thld*1.1, 'StopbandAttenuation', 60, 'PassbandRipple', 1, 'SampleRate', FS);
% 
% YY2=filter(myfilter,YY);
% figure;hold on;
% plot(f,YY,'r');
% plot(f,YY2,'b');


% --- Executes on button press in SaveResults.
function SaveResults_Callback(~, ~, handles)
global Faxes1;
Faxes1=getframe(handles.axes1);  %select axes in GUI
GliaTrans_POI_SavingOptions;



% --- Executes on button press in ExcludeROIs.
function ExcludeROIs_Callback(~, ~, handles)
global hExcludeROIs ExcludeROIsPos;
axes(handles.axes1); hold on;
hh=imrect;
setColor(hh,'r');
exROIpos = round(getPosition(hh));
delete(hh);
hDot=plot([exROIpos(1)+exROIpos(3)/2 exROIpos(1)+exROIpos(3)/2],[exROIpos(2)+exROIpos(4)/2 exROIpos(2)+exROIpos(4)/2],'rx','MarkerSize',(exROIpos(3)+exROIpos(4))/1.5,'LineWidth',2);

hExcludeROIs=[hExcludeROIs hDot];
ExcludeROIsPos=[ExcludeROIsPos;[exROIpos(1)+exROIpos(3)/2 exROIpos(2)+exROIpos(4)/2 (exROIpos(3)+exROIpos(4))/1.5]];

uic = uicontextmenu;
uimenu ( uic, 'Label','Delete','Callback',@DeleteROINew);
set ( hDot, 'uicontextmenu',uic);

% line([exROIpos(1) exROIpos(1)+exROIpos(3)],[exROIpos(2) exROIpos(2)+exROIpos(4)],'LineWidth',2,'Color','r');
% line([exROIpos(1) exROIpos(1)+exROIpos(3)],[exROIpos(2)+exROIpos(4) exROIpos(2)],'LineWidth',2,'Color','r');



% --- Executes on button press in OpenSlider.
function OpenSlider_Callback(hObject, eventdata, handles)
GliaTrans_POI_VideoSlider;




% --- Executes on selection change in OGBChannel.
function OGBChannel_Callback(hObject, eventdata, handles)
% Hints: contents = cellstr(get(hObject,'String')) returns OGBChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OGBChannel
global RedImg GreenImg BlueImg ROIcount ROIs ROIPosAll RangeCutAll fig2_hds ROI_RCh_SR101Wave_All;
global fig3_hds ROI_GCh_CaWave_All fig4_hds ROI_GCh_nonCaWave_All ROI_GandR_CaWave_All ROI_GandR_nonCaWave_All text_hds;
global FrameHeight FrameNum avgFrame_3Ch myVideoGchOpt;

if get(handles.OGBChannel,'Value')==1 && isempty(GreenImg)
    warndlg('No data in Green Channel','!! Warning !!');
    set(handles.OGBChannel,'Value',2);
    return;
elseif get(handles.OGBChannel,'Value')==2 && isempty(BlueImg)
    warndlg('No data in Blue Channel','!! Warning !!');
    set(handles.OGBChannel,'Value',1);
    return;
end
    

% clear all the existing results or semi-results
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);
ROIcount=0;
ROIs=[];
ROIPosAll=[];
RangeCutAll=[];
fig2_hds=[];
ROI_RCh_SR101Wave_All=[];
fig3_hds=[];
ROI_GCh_CaWave_All=[];
fig4_hds=[];
ROI_GCh_nonCaWave_All=[];
ROI_GandR_CaWave_All=[];
ROI_GandR_nonCaWave_All=[];
text_hds=[];

%%%%%%%%%%%%%%%%%%%5 update image in axes1
%%% get the average image and image stack of Three channels of all frames 
avgFrame_3Ch=zeros(FrameHeight,FrameHeight,3);
for i=1:FrameNum
    % Red Ch
    eachFrame=double(RedImg(:,(i-1)*FrameHeight+1:i*FrameHeight)).';
    avgFrame_3Ch(:,:,1)=avgFrame_3Ch(:,:,1)+eachFrame;
    if get(handles.OGBChannel,'Value')==1
        % Green Ch
        eachFrame=double(GreenImg(:,(i-1)*FrameHeight+1:i*FrameHeight)).';
        avgFrame_3Ch(:,:,2)=avgFrame_3Ch(:,:,2)+eachFrame;
        myVideoGchOpt=1;
    elseif get(handles.OGBChannel,'Value')==2
    % Blue Ch
        eachFrame=double(BlueImg(:,(i-1)*FrameHeight+1:i*FrameHeight)).';
        avgFrame_3Ch(:,:,2)=avgFrame_3Ch(:,:,2)+eachFrame;
        myVideoGchOpt=2;
    end
end
for j=1:2
    % average
    avgFrame_3Ch(:,:,j)=avgFrame_3Ch(:,:,j)/FrameNum;
    % adjust LUT
    mymin=min(min(avgFrame_3Ch(:,:,j)));
    mymax=max(max(avgFrame_3Ch(:,:,j)));
    avgFrame_3Ch(:,:,j)=255*(avgFrame_3Ch(:,:,j)-mymin)/(mymax-mymin);
end
avgFrame_3Ch=uint8(avgFrame_3Ch);
axes(handles.axes1);
% set(gcf,'units','normalized','outerposition',[0 0 1 1]);
imagesc(avgFrame_3Ch);
axis equal;
axis off;








% --- Executes on button press in SaveROIs.
function SaveROIs_Callback(hObject, eventdata, handles)
GliaTrans_POI_SavingROIs;


% --- Executes on button press in LoadROIs.
function LoadROIs_Callback(hObject, eventdata, handles)
global ROIcount LegendAll;
for i=1:ROIcount
    eval(['global ROI_masks_all_',LegendAll{i}]);
    eval(['clear ROI_masks_all_',LegendAll{i}]);
end

[ROIFileName,ROIPathName] = uigetfile('*.mat','Select the ROI info file');
avgFrame_3Ch_Pre=load([ROIPathName,ROIFileName],'avgFrame_3Ch');
avgFrame_3Ch_Pre=avgFrame_3Ch_Pre.avgFrame_3Ch;
global avgFrame_3Ch;
if isequal(avgFrame_3Ch_Pre,avgFrame_3Ch)
    % refresh images and memory
    cla(handles.axes1);
    cla(handles.axes2);
    cla(handles.axes3);
    cla(handles.axes4);
    
    axes(handles.axes1);
    h_avgFrame_3Ch=imagesc(avgFrame_3Ch);
    axis equal;
    axis off;
    
    % prepare the axes1 for right click popup menu
    % please refer to http://we15hang.blogspot.dk/2012/04/reason-why-uicontextmenu-is-not-working.html
    set(h_avgFrame_3Ch,'HitTest','off');
    set(handles.axes1,'XTick',[]);
    set(handles.axes1,'YTick',[]);
    set(handles.axes1,'Visible','on');
    
 
    
    % load the ROIs info
    global myTimeTicks FrameTime RangeCutAll myVideoGchOpt presetcolor ROIPosAll FrameHeight HeightStep NoiseAllowPOI;
    global ROI_RCh_SR101Wave_All ROI_GCh_CaWave_All ROI_GCh_nonCaWave_All ROI_GandR_CaWave_All ROI_GandR_nonCaWave_All;    
    global ExcludeROIsPos AstrocyteIndex NeuropilIndex NeuronIndex POIThld;
    
    % load the ROIs info
    load([ROIPathName,ROIFileName]);
    for i=1:ROIcount
        eval(['global ROI_masks_all_',LegendAll{i}]);
    end
    
    global ROIs text_hds fig2_hds fig3_hds fig4_hds hExcludeROIs;
    ROIs=[]; text_hds=[];fig2_hds=[];fig3_hds=[];fig4_hds=[];hExcludeROIs=[];
    % display with the ROIs in axes1
    for i=1:ROIcount
        
        % draw rectangle in axes1
        axes(handles.axes1);hold on;
        ROIpos=ROIPosAll{i};
        hh=rectangle('Position',ROIpos,'EdgeColor',presetcolor(i),'LineWidth',2);
        ROIs=[ROIs hh];
        % Mark the index of the ROI in the image
        MposX=ROIpos(1)+ROIpos(3)/2-1;
        MposY=ROIpos(2)+ROIpos(4)/2-1;
        thd=text(MposX,MposY,LegendAll{i},'color',presetcolor(i),'Fontsize',12);
        text_hds=[text_hds thd];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % create a right click menu for this ROIs
        uic = uicontextmenu;
        uimenu ( uic, 'Label','Delete','Callback',@DeleteROINew);
        uimenu ( uic, 'Label','Resize and move','Callback',@ResizeMoveROI);
        uimenu ( uic, 'Label','Recut in time','Callback',@RecallCutRangeFun);
        set ( hh, 'uicontextmenu',uic);
        
        % axes2
        RangeCut1=RangeCutAll(i,1);RangeCut2=RangeCutAll(i,2);
        ROI_RCh_SR101Wave=ROI_RCh_SR101Wave_All(i,:);
        axes(handles.axes2); hold on;
        hd2=plot(myTimeTicks(RangeCut1:RangeCut2),ROI_RCh_SR101Wave(RangeCut1:RangeCut2)+0.2*(i-1),presetcolor(i));
        title('\fontsize{12}SR101 (astrocytes/neuropil/neurons)');
        xlim([0 myTimeTicks(end)]);
        fig2_hds=[fig2_hds hd2];
        
        % axes3
        ROI_GCh_CaWave=ROI_GCh_CaWave_All(i,:);
        axes(handles.axes3);hold on;
        hd3=plot(myTimeTicks(RangeCut1:RangeCut2),ROI_GCh_CaWave(RangeCut1:RangeCut2)+0.2*(i-1),presetcolor(i),'LineWidth',1);
        title('\fontsize{12}OGB (inside astrocytes/neuropil/neurons)');
        xlim([0 myTimeTicks(end)]);
        fig3_hds=[fig3_hds hd3];
        
        %axes4
        ROI_GCh_nonCaWave=ROI_GCh_nonCaWave_All(i,:);
        if sum(ROI_GCh_nonCaWave)
            axes(handles.axes4);hold on;
            hd4=plot(myTimeTicks(RangeCut1:RangeCut2),ROI_GCh_nonCaWave(RangeCut1:RangeCut2)+0.2*(i-1),presetcolor(i),'LineWidth',1);
            title('\fontsize{12}OGB (outside astrocytes/neurons)');
            xlim([0 myTimeTicks(end)]);
            xlabel('\fontsize{12}Time (s)');
            fig4_hds=[fig4_hds hd4];
        else
            fig4_hds=[fig4_hds 0];
        end

    end
    
    for j=1:size(ExcludeROIsPos,1)
        axes(handles.axes1); hold on;
        hDot=plot([ExcludeROIsPos(j,1) ExcludeROIsPos(j,1)],[ExcludeROIsPos(j,2) ExcludeROIsPos(j,2)],'rx','MarkerSize',ExcludeROIsPos(j,3),'LineWidth',2);
        hExcludeROIs=[hExcludeROIs hDot];
        
        uic = uicontextmenu;
        uimenu ( uic, 'Label','Delete','Callback',@DeleteROINew);
        set ( hDot, 'uicontextmenu',uic);
    end
    
    

else
    warndlg('Raw data and ROIs are not matched, but still gonna be loaded...','!! Warning !!');
%     
%     
%     % refresh images and memory
%     cla(handles.axes1);
%     cla(handles.axes2);
%     cla(handles.axes3);
%     cla(handles.axes4);
%     
%     axes(handles.axes1);
%     h_avgFrame_3Ch=imagesc(avgFrame_3Ch);
%     axis equal;
%     axis off;
%     
%     % prepare the axes1 for right click popup menu
%     % please refer to http://we15hang.blogspot.dk/2012/04/reason-why-uicontextmenu-is-not-working.html
%     set(h_avgFrame_3Ch,'HitTest','off');
%     set(handles.axes1,'XTick',[]);
%     set(handles.axes1,'YTick',[]);
%     set(handles.axes1,'Visible','on');
%     
%     % load the ROIs info
%     global myTimeTicks FrameTime RangeCutAll myVideoGchOpt presetcolor ROIPosAll FrameHeight HeightStep NoiseAllowPOI;
%     global ROI_RCh_SR101Wave_All ROI_GCh_CaWave_All ROI_GCh_nonCaWave_All ROI_GandR_CaWave_All ROI_GandR_nonCaWave_All;    
%     global ExcludeROIsPos AstrocyteIndex NeuropilIndex NeuronIndex POIThld;
%     
%     % load the ROIs info
%     load([ROIPathName,ROIFileName]);
%     for i=1:ROIcount
%         eval(['global ROI_masks_all_',LegendAll{i}]);
%     end
%     
%     global ROIs text_hds fig2_hds fig3_hds fig4_hds hExcludeROIs;
%     ROIs=[]; text_hds=[];fig2_hds=[];fig3_hds=[];fig4_hds=[];hExcludeROIs=[];
%     
%     % display with the ROIs in axes1
%     for i=1:ROIcount
%         
%     end
end


% --- Executes on button press in NewMaskedArea.
function NewMaskedArea_Callback(~, eventdata, handles)

set(handles.NewMaskedArea,'Enable','inactive');
pause(0.5);
set(handles.NewMaskedArea,'Enable','on');

global ROIcount presetcolor ROIs text_hds ROIPosAll FrameNum myVideo myVideoR useNew ROI_GCh_CaDivdeRed BaseLineFrameNo;
global NeuropilIndex LegendAll ROI_GCh ROI_RCh ROI_GCh_CaWave ROI_RCh_SR101Wave myVideo_New myVideoR_New ROI_masks_all;
global RangeCut1 RangeCut2 RangeCutAll myTimeTicks fig2_hds ROI_RCh_SR101Wave_All CutFrameNum1 CutFrameNum2;
global fig3_hds ROI_GCh_CaWave_All ROI_GCh_nonCaWave fig4_hds ROI_GCh_CaDivdeRed_All ROI_BW_All ROI_RCh_SR101Wave_All_raw;
global ROI_GandR_CaWave_All ROI_GandR_nonCaWave_All POIThld STITimeTicks hdl_STI1 hdl_STI2 hdl_STI3 ROI_GCh_CaDivdeRed_All_raw;
global hdl_11 hdl_12 hdl_21 hdl_22 hdl_31 hdl_32 FrameTime FFST FrameNo1 FrameNo2 ROIPosAllRec ROI_BW_Mask ROI_GCh_CaWave_All_raw avgFrame_3Ch;
global avgFrame_3Ch_new ROI_GRImage;



axes(handles.axes1);
h=imfreehand;
setColor(h,presetcolor(ROIcount+1));
% COI_Mask = createMask(h).';   % cell of interest
ROIpos = getPosition(h);


ImageHeight=size(myVideoR,2);
ImageWidth=size(myVideoR,1);
ROIpos1=ROIpos(:,1);
ROIpos1(find(ROIpos1>=ImageHeight))=ImageHeight;
% ROIpos(:,1)=ROIpos1;
ROIpos2=ROIpos(:,2);
ROIpos2(find(ROIpos2>=ImageWidth))=ImageWidth;
ROIpos(:,2)=ROIpos2;
ROIpos(find(ROIpos<=1))=1;


ROIcount=ROIcount+1;
ROI_BW = createMask(h);
if ROIcount==1
    ROI_BW_All=[];
    ROI_BW_All=[ROI_BW_All;ROI_BW];
else
    ROI_BW_All(:,:,ROIcount)=ROI_BW;
end

% redraw the curve
delete(h);
ROIpos=[ROIpos;ROIpos(1,:)];

if length(ROIpos)<=2
    warndlg('ROI size CANNOT be zero!','!! Warning !!');
    
else

    % Freehand new neuropil the contour of ROI
    
    NeuropilIndex=[NeuropilIndex ROIcount];
    LegendAll{ROIcount}=['f',num2str(length(NeuropilIndex))];

    axes(handles.axes1);hold on;
    hh=plot(ROIpos(:,1),ROIpos(:,2),presetcolor(ROIcount),'LineWidth',2);
    ROIs=[ROIs hh];

    % Mark the index of the ROI in the image
    MposX=mean(ROIpos(:,1));
    MposY=mean(ROIpos(:,2));
    thd=text(MposX,MposY,['f',int2str(ROIcount)],'color',presetcolor(ROIcount),'Fontsize',12);
    text_hds=[text_hds thd];

    % Save the ROI position for later use
    ROIPosAll(ROIcount)=num2cell(ROIpos,[1 2]); 


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % create a right click menu for this ROIs
    uic = uicontextmenu;
    uimenu ( uic, 'Label','Delete','Callback',@DeleteROINew);
    uimenu ( uic, 'Label','Recut in time','Callback',@RecallCutRangeFun);
    set ( hh, 'uicontextmenu',uic);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % find the x.y limit of ROIs
    x_rec=[floor(min(ROIpos(:,1))),ceil(max(ROIpos(:,1)))];
    y_rec=[floor(min(ROIpos(:,2))),ceil(max(ROIpos(:,2)))];
    ROIPosAllRec=[ROIPosAllRec;[x_rec y_rec]];
    
    % prepare for Ca detection
    m=x_rec(2)-x_rec(1)+1;
    n=y_rec(2)-y_rec(1)+1;
    
    ROI_BW_Mask=ROI_BW(y_rec(1):y_rec(2),x_rec(1):x_rec(2));
    
    %%% 
    ROI_masks_all=zeros(n,m);
    
    
    %%
    % preset parameters
    ROI_GCh=zeros(n,m,FrameNum); 
    ROI_RCh=zeros(n,m,FrameNum); 
    NoiseAllowPOI=str2num(get(handles.NoiseAllowPOI,'String'));
    POIThld=[POIThld 0];
    
    
    ROI_GCh_CaWave=zeros(1,FrameNum);
    ROI_GCh_nonCaWave=zeros(1,FrameNum);
    ROI_RCh_SR101Wave=zeros(1,FrameNum);
    ROI_RCh_nonSR101Wave=zeros(1,FrameNum);
    ROI_GCh_CaDivdeRed=zeros(1,FrameNum);
    
    
    if useNew
        ROI_GCh=myVideo_New(y_rec(1):y_rec(2),x_rec(1):x_rec(2),:);
        ROI_RCh=myVideoR_New(y_rec(1):y_rec(2),x_rec(1):x_rec(2),:);
        ROI_GRImage=avgFrame_3Ch_new(y_rec(1):y_rec(2),x_rec(1):x_rec(2),:);
    else
        ROI_GCh=myVideo(y_rec(1):y_rec(2),x_rec(1):x_rec(2),:);
        ROI_RCh=myVideoR(y_rec(1):y_rec(2),x_rec(1):x_rec(2),:);
        ROI_GRImage=avgFrame_3Ch(y_rec(1):y_rec(2),x_rec(1):x_rec(2),:);
    end

    % get the neuropil signals
    for j=1:FrameNum
        % get the voxel of the ROI
        eachFrameG=ROI_GCh(:,:,j);    
        eachFrameR=ROI_RCh(:,:,j);
        
        % get the voxel of the ROI    
        ROI_GCh_CaWave(j)=mean2(eachFrameG(find(eachFrameG.*ROI_BW_Mask)));

        ROI_RCh_SR101Wave(j)=mean2(eachFrameR(find(eachFrameR.*ROI_BW_Mask)));
   
    end

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% show the window with mask and scroll bar
    RangeCut1=1;
    RangeCut2=FrameNum;
    
    hNeuropilRC=GliaTrans_POI_NeuropilRangeCut;


    while ishandle(hNeuropilRC)
        pause(0.1);
    end

    RangeCutAll=[RangeCutAll;[RangeCut1 RangeCut2]];
    
    
    CutTime1=str2num(get(handles.CutTime01,'String'));
    CutTime2=str2num(get(handles.CutTime02,'String'));

    CutFrameNum1=fix((CutTime1*1000)/FrameTime);
    CutFrameNum2=fix((CutTime2*1000)/FrameTime);
    
    
    SmoothWinSize=str2num(get(handles.SmoothWinSizeNew,'String'));
    


    %% %%%%  the upper right figure
    %normalize
    
    ROI_RCh_SR101Wave_All_raw=[ROI_RCh_SR101Wave_All_raw;ROI_RCh_SR101Wave];
    ROI_RCh_SR101Wave=smooth(ROI_RCh_SR101Wave,SmoothWinSize);
    ROI_RCh_SR101Wave=ROI_RCh_SR101Wave.';
    ROI_RCh_SR101Wave = ROI_RCh_SR101Wave./mean(ROI_RCh_SR101Wave(RangeCut1:RangeCut1+BaseLineFrameNo));
    %
    axes(handles.axes2);
    hold on;
    hd2=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_RCh_SR101Wave(CutFrameNum1:CutFrameNum2)+0.1*(ROIcount-1),presetcolor(ROIcount));
    title('\fontsize{12}Red channel intensity inside the defined EC');
    xlim([0 myTimeTicks(end)]);
    fig2_hds=[fig2_hds hd2];
    ROI_RCh_SR101Wave_All=[ROI_RCh_SR101Wave_All;ROI_RCh_SR101Wave];
    if length(STITimeTicks)
        try
            delete(hdl_STI1);
        end
        mylim=get(gca,'ylim');
        hdl_STI1=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
    end
    
    %%  the middle right figure
    % normalize
    ROI_GCh_CaWave_All_raw=[ROI_GCh_CaWave_All_raw;ROI_GCh_CaWave];
    ROI_GCh_CaWave=smooth(ROI_GCh_CaWave,SmoothWinSize);
    ROI_GCh_CaWave=ROI_GCh_CaWave.';    
    ROI_GCh_CaWave = ROI_GCh_CaWave./mean(ROI_GCh_CaWave(RangeCut1:RangeCut1+BaseLineFrameNo));
    %
    axes(handles.axes3);
    hold on;
    hd3=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaWave(CutFrameNum1:CutFrameNum2)+0.1*(ROIcount-1),presetcolor(ROIcount),'LineWidth',1);
    title('\fontsize{12}Ca^{2+} inside the defined EC');
    xlim([0 myTimeTicks(end)]);
    fig3_hds=[fig3_hds hd3];
    ROI_GCh_CaWave_All=[ROI_GCh_CaWave_All;ROI_GCh_CaWave];
    if length(STITimeTicks)
        try
            delete(hdl_STI2);
        end
        mylim=get(gca,'ylim');
        hdl_STI2=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
    end
    
    %% the lower right figure
    % normalize
    ROI_GCh_CaDivdeRed = ROI_GCh_CaWave./ROI_RCh_SR101Wave;
    ROI_GCh_CaDivdeRed_All_raw=[ROI_GCh_CaDivdeRed_All_raw;ROI_GCh_CaDivdeRed];
%     ROI_GCh_CaDivdeRed=smooth(ROI_GCh_CaDivdeRed,SmoothWinSize);
%     ROI_GCh_CaDivdeRed=ROI_GCh_CaDivdeRed.';
    %
    axes(handles.axes4);
    hold on;
    hd4=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaDivdeRed(CutFrameNum1:CutFrameNum2)+0.1*(ROIcount-1),presetcolor(ROIcount),'LineWidth',1);
    title('\fontsize{12}Calcium intensity / Red channel intensity inside defined EC');
    xlim([0 myTimeTicks(end)]);
    xlabel('\fontsize{12}Time (s)');
    fig4_hds=[fig4_hds hd4];
    ROI_GCh_CaDivdeRed_All=[ROI_GCh_CaDivdeRed_All;ROI_GCh_CaDivdeRed];
    if length(STITimeTicks)
        try
            delete(hdl_STI3);
        end
        mylim=get(gca,'ylim');
        hdl_STI3=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
    end
    
    %%% plot the puff time mark if any
    if str2num(FrameNo1)*str2num(FrameNo2)
        try delete(hdl_11);end
        try delete(hdl_12);end
        try delete(hdl_21);end
        try delete(hdl_22);end
        try delete(hdl_31);end
        try delete(hdl_32);end
        
        PuffStartTime=((str2num(FrameNo1)-2)*FrameTime)/1000;
        PuffEndTime=((str2num(FrameNo2)-1)*FrameTime)/1000;
        axes(handles.axes2);mylim=get(gca,'ylim');
        hdl_11=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_12=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        axes(handles.axes3);mylim=get(gca,'ylim');
        hdl_21=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_22=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        axes(handles.axes4);mylim=get(gca,'ylim');
        hdl_31=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_32=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');

        
    end
    
    
    % divide the Green Ch by Red Ch and save
    % ROI_RCh_nonSR101Wave(RangeCut1:RangeCut2)=smooth(ROI_RCh_nonSR101Wave(RangeCut1:RangeCut2),7);
    
    ROI_GandR_CaWave_All=[ROI_GandR_CaWave_All;ROI_GCh_CaWave./ROI_RCh_SR101Wave];
    ROI_GandR_nonCaWave_All=[ROI_GandR_nonCaWave_All;zeros(size(ROI_GCh_CaWave))];
    
end




% --- Executes on button press in NewPericyte.
function NewPericyte_Callback(hObject, eventdata, handles)

set(handles.NewPericyte,'Enable','inactive');
pause(0.5);
set(handles.NewPericyte,'Enable','on');

global ROIcount presetcolor ROIs text_hds ROIPosAll FrameNum ROIPosAllRec myVideo myVideoR ROI_BW_Mask;
global NeuronIndex LegendAll ROI_GCh ROI_RCh ROI_GCh_CaWave ROI_RCh_SR101Wave ROI_GCh_CaDivdeRed;
global RangeCut1 RangeCut2 RangeCutAll myTimeTicks fig2_hds ROI_RCh_SR101Wave_All BaseLineFrameNo;
global fig3_hds ROI_GCh_CaWave_All ROI_GCh_nonCaWave fig4_hds ROI_GCh_nonCaWave_All;
global ROI_GandR_CaWave_All ROI_GCh_CaDivdeRed_All NoiseAllowPOI ROI_masks_all AorN POIThld STITimeTicks hdl_STI1 hdl_STI2 hdl_STI3;
global hdl_11 hdl_12 hdl_21 hdl_22 hdl_31 hdl_32 FrameTime FFST FrameNo1 FrameNo2 ROI_masks_all_2GCh ROI_BW_All;
global PuffTimeNo1 PuffTimeNo2 CutFrameNum1 CutFrameNum2 useNew myVideo_New myVideoR_New;
global ROI_RCh_SR101Wave_All_raw ROI_GCh_CaWave_All_raw ROI_GCh_CaDivdeRed_All_raw;

% draw ROI
axes(handles.axes1);
h=imfreehand;
setColor(h,presetcolor(ROIcount+1));
% COI_Mask = createMask(h).';   % cell of interest
ROIpos = getPosition(h);

ImageHeight=size(myVideo,2);
ImageWidth=size(myVideo,1);
ROIpos1=ROIpos(:,1);
ROIpos1(find(ROIpos1>=ImageHeight))=ImageHeight;
ROIpos(:,1)=ROIpos1;
ROIpos2=ROIpos(:,2);
ROIpos2(find(ROIpos2>=ImageWidth))=ImageWidth;
ROIpos(:,2)=ROIpos2;
ROIpos(find(ROIpos<=1))=1;

ROIcount=ROIcount+1;
ROI_BW = createMask(h);
if ROIcount==1
%     ROI_BW=double(ROI_BW);
    ROI_BW_All=[];
    ROI_BW_All=[ROI_BW_All;ROI_BW];
else
    ROI_BW_All(:,:,ROIcount)=ROI_BW;
end

% redraw the curve
delete(h);
ROIpos=[ROIpos;ROIpos(1,:)];


if length(ROIpos)<=2
    warndlg('ROI size CANNOT be zero!','!! Warning !!');
    
else


    % Freehand new neuropil the contour of ROI
    NeuronIndex=[NeuronIndex ROIcount];
    LegendAll{ROIcount}=['p',num2str(length(NeuronIndex))];



    axes(handles.axes1);hold on;
    hh=plot(ROIpos(:,1),ROIpos(:,2),presetcolor(ROIcount),'LineWidth',2);
    ROIs=[ROIs hh];

    % Mark the index of the ROI in the image
    MposX=mean(ROIpos(:,1));
    MposY=mean(ROIpos(:,2));
    thd=text(MposX,MposY,['p',int2str(ROIcount)],'color',presetcolor(ROIcount),'Fontsize',12);
    text_hds=[text_hds thd];

    % Save the ROI position for later use
    ROIPosAll(ROIcount)=num2cell(ROIpos,[1 2]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % create a right click menu for this ROIs
    uic = uicontextmenu;
    uimenu ( uic, 'Label','Delete','Callback',@DeleteROINew);
    uimenu ( uic, 'Label','Recut in time','Callback',@RecallCutRangeFun);
    set ( hh, 'uicontextmenu',uic);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % create a right click menu for this ROIs
    uic = uicontextmenu;
    uimenu ( uic, 'Label','Delete','Callback',@DeleteROINew);
    uimenu ( uic, 'Label','Recut in time','Callback',@RecallCutRangeFun);
    set ( hh, 'uicontextmenu',uic);
    
    % find the x.y limit of ROIs
    x_rec=[floor(min(ROIpos(:,1))),ceil(max(ROIpos(:,1)))];
    y_rec=[floor(min(ROIpos(:,2))),ceil(max(ROIpos(:,2)))];
    ROIPosAllRec=[ROIPosAllRec;[x_rec y_rec]];
    
    % prepare for Ca detection
    m=x_rec(2)-x_rec(1)+1;
    n=y_rec(2)-y_rec(1)+1;
    
    ROI_BW_Mask=ROI_BW(y_rec(1):y_rec(2),x_rec(1):x_rec(2));

    %%% POI method
    % preset parameters
    ROI_GCh=zeros(n,m,FrameNum); 
    ROI_RCh=zeros(n,m,FrameNum); 
    NoiseAllowPOI=str2num(get(handles.NoiseAllowPOI,'String'));
    POIThld=[POIThld NoiseAllowPOI];

    ROI_masks_all=zeros(n,m,FrameNum);
    ROI_masks_all_2GCh=zeros(n,m,FrameNum);
    ROI_GCh_CaWave=zeros(1,FrameNum);
    ROI_GCh_nonCaWave=zeros(1,FrameNum);
    ROI_RCh_SR101Wave=zeros(1,FrameNum);
    ROI_RCh_nonSR101Wave=zeros(1,FrameNum);
    ROI_GCh_CaDivdeRed=zeros(1,FrameNum);
    
    if useNew
        ROI_GCh=myVideo_New(y_rec(1):y_rec(2),x_rec(1):x_rec(2),:);
        ROI_RCh=myVideoR_New(y_rec(1):y_rec(2),x_rec(1):x_rec(2),:);
    else
        ROI_GCh=myVideo(y_rec(1):y_rec(2),x_rec(1):x_rec(2),:);
        ROI_RCh=myVideoR(y_rec(1):y_rec(2),x_rec(1):x_rec(2),:);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%% find the mask of real rois
    for j=1:FrameNum
        % get the voxel of the ROI
        eachFrameG=ROI_GCh(:,:,j);    
        eachFrameR=ROI_RCh(:,:,j);
    
        % thresholding each frame in the ROI
        ROImean=mean2(eachFrameG(find(eachFrameG.*ROI_BW_Mask)));
        ROIstd=std2(eachFrameG(find(eachFrameG.*ROI_BW_Mask)));
        ROItemp=eachFrameG.*ROI_BW_Mask;
        ROItemp=(ROItemp-ROImean)/ROIstd;

        [row,col]=find(ROItemp>NoiseAllowPOI);
        for i=1:length(row)
            ROI_masks_all(row(i),col(i),j)=1;
        end
    
        % delete individual pixel and fill the hole
        NowImg=ROI_masks_all(:,:,j);
        % fill the holes
        Mask_filled = imfill(NowImg,'holes');
        holes = Mask_filled & ~NowImg;
        bigholes = bwareaopen(holes, 100);
        smallholes = holes & ~bigholes;
        Mask_filled = NowImg | smallholes;
        NowImg=double(Mask_filled);
        
        
        
        % delete individual pixel and fill the hole
        ImgTemplate=[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
        NowImg2=conv2(NowImg,ImgTemplate,'same').*NowImg;
        NowImg2(find((NowImg2<2/9)))=0;
        NowImg2(find((NowImg2>=2/9)))=1;
%         NowImg2=imfill(NowImg2);    
   
        ROI_masks_all(:,:,j)=NowImg2;
    
        % extract the signal out
        if length(row)
            ROI_GCh_CaWave(j)=sum(sum(ROI_GCh(:,:,j).*ROI_masks_all(:,:,j)))/length(row);
            ROI_RCh_SR101Wave(j)=sum(sum(ROI_RCh(:,:,j).*ROI_masks_all(:,:,j)))/length(row);
            ROI_GCh_nonCaWave(j)=sum(sum(ROI_GCh(:,:,j).*(1-ROI_masks_all(:,:,j))))/length(row);
            ROI_RCh_nonSR101Wave(j)=sum(sum(ROI_RCh(:,:,j).*(1-ROI_masks_all(:,:,j))))/length(row); 
    
        else
            ROI_GCh_CaWave(j)=0;
            ROI_RCh_SR101Wave(j)=0;
            ROI_GCh_nonCaWave(j)=1;
            ROI_RCh_nonSR101Wave(j)=1;
        end
    
    end

    % % delete the individual pixel in the mask stack
    eval(['global ROI_masks_all_n',num2str(length(NeuronIndex))]);
    eval(['ROI_masks_all_n',num2str(length(NeuronIndex)),'=ROI_masks_all;']);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% show the window with mask and scroll bar
    RangeCut1=1;
    RangeCut2=FrameNum;
    AorN=2;   % set a marker to distinguish astrocyte and neuron


    hPOIcheckup=GliaTrans_POI_postPOIcheckup;

    while ishandle(hPOIcheckup)
        pause(0.1);
    end

    RangeCutAll=[RangeCutAll;[RangeCut1 RangeCut2]];
    
    CutTime1=str2num(get(handles.CutTime01,'String'));
    CutTime2=str2num(get(handles.CutTime02,'String'));

    CutFrameNum1=fix((CutTime1*1000)/FrameTime);
    CutFrameNum2=fix((CutTime2*1000)/FrameTime);
    
    
    SmoothWinSize=str2num(get(handles.SmoothWinSizeNew,'String'));
    

    %%%%%% new the upper right figure
    %normalize
%     BaselineLength = 10;   % 30 frames as baseline for normalization
    ROI_RCh_SR101Wave_All_raw=[ROI_RCh_SR101Wave_All_raw;ROI_RCh_SR101Wave];
    ROI_RCh_SR101Wave=smooth(ROI_RCh_SR101Wave,SmoothWinSize);
    ROI_RCh_SR101Wave=ROI_RCh_SR101Wave.';
    ROI_RCh_SR101Wave = ROI_RCh_SR101Wave./mean(ROI_RCh_SR101Wave(RangeCut1:RangeCut1+BaseLineFrameNo));
    %
    axes(handles.axes2);
    hold on;
    hd2=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_RCh_SR101Wave(CutFrameNum1:CutFrameNum2)+0.1*(ROIcount-1),presetcolor(ROIcount));
    title('\fontsize{12}Red channel intensity inside the defined EC');
    xlim([0 myTimeTicks(end)]);
    fig2_hds=[fig2_hds hd2];
    ROI_RCh_SR101Wave_All=[ROI_RCh_SR101Wave_All;ROI_RCh_SR101Wave];
    if length(STITimeTicks)
        try
            delete(hdl_STI1);
        end
        mylim=get(gca,'ylim');
        hdl_STI1=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
    end


    % new the middle right figure
    % normalize
    ROI_GCh_CaWave_All_raw=[ROI_GCh_CaWave_All_raw;ROI_GCh_CaWave];
    ROI_GCh_CaWave=smooth(ROI_GCh_CaWave,SmoothWinSize);
    ROI_GCh_CaWave=ROI_GCh_CaWave.';
    ROI_GCh_CaWave = ROI_GCh_CaWave./mean(ROI_GCh_CaWave(RangeCut1:RangeCut1+BaseLineFrameNo));
    %
    axes(handles.axes3);
    hold on;
    hd3=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaWave(CutFrameNum1:CutFrameNum2)+0.1*(ROIcount-1),presetcolor(ROIcount),'LineWidth',1);
    title('\fontsize{12}Ca^{2+} inside the defined EC');
    xlim([0 myTimeTicks(end)]);
    fig3_hds=[fig3_hds hd3];
    ROI_GCh_CaWave_All=[ROI_GCh_CaWave_All;ROI_GCh_CaWave];
    if length(STITimeTicks)
        try
            delete(hdl_STI2);
        end
        mylim=get(gca,'ylim');
        hdl_STI2=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
    end

    % newastrocyte the lower right figure
    % normalize    
    ROI_GCh_CaDivdeRed = ROI_GCh_CaWave./ROI_RCh_SR101Wave;    
    ROI_GCh_CaDivdeRed_All_raw=[ROI_GCh_CaDivdeRed_All_raw;ROI_GCh_CaDivdeRed];
%     ROI_GCh_CaDivdeRed=smooth(ROI_GCh_CaDivdeRed,SmoothWinSize);
%     ROI_GCh_CaDivdeRed=ROI_GCh_CaDivdeRed.';    
    %newastrocyte
    axes(handles.axes4);
    hold on;
    hd4=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaDivdeRed(CutFrameNum1:CutFrameNum2)+0.1*(ROIcount-1),presetcolor(ROIcount),'LineWidth',1);
    title('\fontsize{12}Calcium intensity / Red channel intensity inside defined EC');
    xlim([0 myTimeTicks(end)]);
    xlabel('\fontsize{12}Time (s)');
    fig4_hds=[fig4_hds hd4];
    ROI_GCh_CaDivdeRed_All=[ROI_GCh_CaDivdeRed_All;ROI_GCh_CaDivdeRed];
    if length(STITimeTicks)
        try
            delete(hdl_STI3);
        end
        mylim=get(gca,'ylim');
        hdl_STI3=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
    end
    
    %%% plot the puff time mark if any
    if PuffTimeNo1*PuffTimeNo2
        try delete(hdl_11);end
        try delete(hdl_12);end
        try delete(hdl_21);end
        try delete(hdl_22);end
        try delete(hdl_31);end
        try delete(hdl_32);end
        
        PuffStartTime=PuffTimeNo1;
        PuffEndTime=PuffTimeNo2;
        axes(handles.axes2);mylim=get(gca,'ylim');
        hdl_11=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_12=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        axes(handles.axes3);mylim=get(gca,'ylim');
        hdl_21=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_22=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        axes(handles.axes4);mylim=get(gca,'ylim');
        hdl_31=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_32=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');

        
    end
% 
%     % divide the Green Ch by Red Ch and save
%     ROI_RCh_SR101Wave_All = [ROI_RCh_SR101Wave_All;ROI_RCh_SR101Wave];
% 
%     ROI_GCh_CaWave_All=[ROI_GCh_CaWave_All;ROI_GCh_CaWave];
%     ROI_GCh_CaDivdeRed_All=[ROI_GCh_CaDivdeRed_All;ROI_GCh_CaDivdeRed];

end





% --- Executes on button press in stackdowndelete.
function stackdowndelete_Callback(hObject, eventdata, handles)
global ROIcount ROIs ROIPosAll fig2_hds ROI_RCh_SR101Wave_All fig3_hds ROI_GCh_CaWave_All fig4_hds ROI_GCh_nonCaWave_All text_hds;
global ROI_GandR_CaWave_All ROI_GandR_nonCaWave_All RangeCutAll AstrocyteIndex NeuropilIndex NeuronIndex LegendAll presetcolor;
global handlesaxes1 handlesaxes2 handlesaxes3 handlesaxes4 myTimeTicks ROI_GCh_CaDivdeRed_All POIThld ROI_BW_All ROIPosAllRec;
global ROI_RCh_SR101Wave_All_raw ROI_GCh_CaWave_All_raw ROI_GCh_CaDivdeRed_All_raw;

MaxAll=zeros(1,17);
MaxAll(1)=ROIcount;
MaxAll(2)=length(ROIs);
MaxAll(3)=length(ROIPosAll);
MaxAll(4)=length(fig2_hds);
MaxAll(5)=length(fig3_hds);
MaxAll(6)=length(fig4_hds);
MaxAll(7)=length(text_hds);
MaxAll(8)=size(ROI_RCh_SR101Wave_All,1);
MaxAll(9)=size(ROI_GCh_CaWave_All,1);
MaxAll(10)=size(ROI_GCh_CaDivdeRed_All,1);
% MaxAll(11)=size(ROI_GandR_CaWave_All,1);
% MaxAll(12)=size(ROI_GandR_nonCaWave_All,1);
MaxAll(13)=size(RangeCutAll,1);
emptyCells = cellfun(@isempty,LegendAll);
MaxAll(14)=length(find(1-emptyCells));
MaxAll(15)=length(POIThld);
MaxAll(16)=size(ROI_BW_All,3);
MaxAll(17)=size(ROIPosAllRec,1);

MaxROINum=max(MaxAll);   % the max recorded roi numbers

if MaxROINum>=1
    try delete(ROIs(MaxROINum));end
    try ROIs(MaxROINum)=[];end
    try delete(text_hds(MaxROINum));end
    try text_hds(MaxROINum)=[];end
    try delete(fig2_hds(MaxROINum));end
    try fig2_hds(MaxROINum)=[];end
    try delete(fig3_hds(MaxROINum));end
    try fig3_hds(MaxROINum)=[];end
    try delete(fig4_hds(MaxROINum));end
    try fig4_hds(MaxROINum)=[];end
    try LegendAll{MaxROINum}=[];end
    try ROIPosAll(MaxROINum)=[];end
    try RangeCutAll(MaxROINum,:)=[];end
    try POIThld(MaxROINum)=[];end
    try ROI_BW_All(:,:,MaxROINum)=[]; end
    try ROIPosAllRec(MaxROINum,:)=[];end
    try ROI_RCh_SR101Wave_All(MaxROINum,:)=[];end
    try ROI_GCh_CaWave_All(MaxROINum,:)=[];end
    try ROI_GCh_CaDivdeRed_All(MaxROINum,:)=[];end
    try ROI_RCh_SR101Wave_All_raw(MaxROINum,:)=[];end
    try ROI_GCh_CaWave_All_raw(MaxROINum,:)=[];end
    try ROI_GCh_CaDivdeRed_All_raw(MaxROINum,:)=[];end
%     try ROI_GandR_CaWave_All(MaxROINum,:)=[];end
%     try ROI_GandR_nonCaWave_All(MaxROINum,:)=[];end
    try ROIcount=MaxROINum-1;end
        
    if ismember(MaxROINum,AstrocyteIndex)
        ROIindx_cellspfc=find(AstrocyteIndex==MaxROINum);    
        % modify the mask file
        eval(['global ROI_masks_all_a',num2str(ROIindx_cellspfc),';']);
        eval(['clear ROI_masks_all_a',num2str(ROIindx_cellspfc),';']);
        % delete the index
        AstrocyteIndex(ROIindx_cellspfc)=[];
    
    elseif ismember(MaxROINum,NeuropilIndex)
        ROIindx_cellspfc=find(NeuropilIndex==MaxROINum);    
        % delete the index
        NeuropilIndex(ROIindx_cellspfc)=[];
    
    elseif ismember(MaxROINum,NeuronIndex)
        ROIindx_cellspfc=find(NeuronIndex==MaxROINum);    
        % modify the mask file
        eval(['global ROI_masks_all_n',num2str(MaxROINum)]);
        eval(['clear ROI_masks_all_n',num2str(MaxROINum),';']);
        % delete the index
        NeuronIndex(ROIindx_cellspfc)=[];
    
    else
        warndlg('CANNOT find this ROI info in the ROI list','!! Warning !!');
    end
    
end




% --- Executes on button press in updatepuff.
function updatepuff_Callback(hObject, eventdata, handles)
global FrameTime FFST hdl_11 hdl_12 hdl_21 hdl_22 hdl_31 hdl_32 RangeCutAll presetcolor;
global FrameNo1 FrameNo2 myTimeTicks PuffTimeNo1 PuffTimeNo2 BaseLineFrameNo;
global ROI_RCh_SR101Wave_All ROI_GCh_CaWave_All ROI_GCh_CaDivdeRed_All fig3_hds ROIcount fig2_hds fig4_hds CutFrameNum1 CutFrameNum2;

% Update BaseLineFrameNo if there's only a puff
PuffTimeNo1=str2num(get(handles.FrameNo1,'String'));
PuffTimeNo2=str2num(get(handles.FrameNo2,'String'));

tI=find(myTimeTicks<PuffTimeNo1);
FrameNo1=num2str(tI(end));

tI=find(myTimeTicks<PuffTimeNo2);
FrameNo2=num2str(tI(end));


BaseLineFrameNo=str2num(FrameNo1);

% Update teh axes3 and axes4 if there's only puffing, and BaseLineFrameNo
% is changed
if str2num(FrameNo1)*size(ROI_RCh_SR101Wave_All,1)
     
    
    
    if ~isempty(fig3_hds)
        for i=1:ROIcount
            eval(['delete(fig2_hds(',num2str(i),'));']);
            eval(['delete(fig3_hds(',num2str(i),'));']);
            eval(['delete(fig4_hds(',num2str(i),'));']);
        end
    end
    fig2_hds=[];
    fig3_hds=[];
    fig4_hds=[];
    
    CutTime1=str2num(get(handles.CutTime01,'String'));
    CutTime2=str2num(get(handles.CutTime02,'String'));

    CutFrameNum1=fix((CutTime1*1000)/FrameTime);
    CutFrameNum2=fix((CutTime2*1000)/FrameTime);

    
    if ROIcount>=1 && ~isempty(ROI_RCh_SR101Wave_All)
    
        for i=1:ROIcount
            
            RangeCut=RangeCutAll(i,:);
            
            if CutFrameNum1<=BaseLineFrameNo
                
                %%%%%%%% fig 2
                ROI_RCh_SR101Wave_All(i,:) = ROI_RCh_SR101Wave_All(i,:)./mean(ROI_RCh_SR101Wave_All(i,CutFrameNum1:BaseLineFrameNo));
                axes(handles.axes2);
                hold on;
                hd2=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_RCh_SR101Wave_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
                title('\fontsize{12}Red channel intensity inside the defined EC');
                xlim([0 myTimeTicks(end)]);
                fig2_hds=[fig2_hds hd2];
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fig 3
                ROI_GCh_CaWave_All(i,:) = ROI_GCh_CaWave_All(i,:)./mean(ROI_GCh_CaWave_All(i,CutFrameNum1:BaseLineFrameNo));
                axes(handles.axes3);
                hold on;
                hd3=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaWave_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
                title('\fontsize{12}Ca^{2+} inside the defined EC');
                xlim([0 myTimeTicks(end)]);
                fig3_hds=[fig3_hds hd3];
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fig 4
                ROI_GCh_CaDivdeRed_All(i,:) = ROI_GCh_CaDivdeRed_All(i,:)./mean(ROI_GCh_CaDivdeRed_All(i,CutFrameNum1:BaseLineFrameNo));
                axes(handles.axes4);
                hold on;
                hd4=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaDivdeRed_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
                title('\fontsize{12}Calcium intensity / Red channel intensity inside defined EC')
                xlim([0 myTimeTicks(end)]);
                fig4_hds=[fig4_hds hd4];
                
            else
                
                %%%%%%%% fig 2
                ROI_RCh_SR101Wave_All(i,:) = ROI_RCh_SR101Wave_All(i,:)./mean(ROI_RCh_SR101Wave_All(i,CutFrameNum1));
                axes(handles.axes2);
                hold on;
                hd2=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_RCh_SR101Wave_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
                title('\fontsize{12}Red channel intensity inside the defined EC');
                xlim([0 myTimeTicks(end)]);
                fig2_hds=[fig2_hds hd2];
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fig 3
                ROI_GCh_CaWave_All(i,:) = ROI_GCh_CaWave_All(i,:)./mean(ROI_GCh_CaWave_All(i,CutFrameNum1));
                axes(handles.axes3);
                hold on;
                hd3=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaWave_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
                title('\fontsize{12}Ca^{2+} inside the defined EC');
                xlim([0 myTimeTicks(end)]);
                fig3_hds=[fig3_hds hd3];
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fig 4
                ROI_GCh_CaDivdeRed_All(i,:) = ROI_GCh_CaDivdeRed_All(i,:)./mean(ROI_GCh_CaDivdeRed_All(i,CutFrameNum1));
                axes(handles.axes4);
                hold on;
                hd4=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaDivdeRed_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
                title('\fontsize{12}Calcium intensity / Red channel intensity inside defined EC')
                xlim([0 myTimeTicks(end)]);
                fig4_hds=[fig4_hds hd4];
                
            end
        end
    end

end

if  exist('hdl_11')
        try delete(hdl_11);end
        try delete(hdl_12);end
        try delete(hdl_21);end
        try delete(hdl_22);end
        try delete(hdl_31);end
        try delete(hdl_32);end
end
    
% plot the lines for puffing
if PuffTimeNo1*PuffTimeNo2
        PuffStartTime=PuffTimeNo1;
        PuffEndTime=PuffTimeNo2;
        axes(handles.axes2);mylim=get(gca,'ylim');
        hdl_11=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_12=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        axes(handles.axes3);mylim=get(gca,'ylim');
        hdl_21=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_22=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        axes(handles.axes4);mylim=get(gca,'ylim');
        hdl_31=line([PuffStartTime PuffStartTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
        hdl_32=line([PuffEndTime PuffEndTime],[mylim(1)+0.01 mylim(2)-0.01],'Color','m');
end







% --- Executes when selected object is changed in IfPuffing.
function IfPuffing_SelectionChangeFcn(hObject, eventdata, handles)
global FrameNo1 FrameNo2 hdl_11 hdl_12 hdl_21 hdl_22 hdl_31 hdl_32;
% get the selection for the button group
puffhd =  get(handles.IfPuffing,'SelectedObject');
anypuff = get(puffhd,'String');

switch anypuff
    case 'No'
        set(handles.fn,'Enable','off');
        set(handles.FrameNo1,'Enable','off');
        set(handles.FrameNo1,'String','');
        set(handles.FrameNo2,'Enable','off');
        set(handles.FrameNo2,'String','');
        set(handles.slash,'Enable','off');
        set(handles.updatepuff,'Enable','off');
        
        if ~isempty(hdl_11) && ishandle(hdl_11)
            set(hdl_11,'Visible','off');
            set(hdl_12,'Visible','off');
            set(hdl_21,'Visible','off');
            set(hdl_22,'Visible','off');
            set(hdl_31,'Visible','off');
            set(hdl_32,'Visible','off');
        end
        
        FrameNo1='0';
        FrameNo2='0';
        
        
    case 'Yes'
        set(handles.fn,'Enable','on');
        set(handles.FrameNo1,'Enable','on');
        set(handles.FrameNo1,'String',FrameNo1);
        set(handles.FrameNo2,'Enable','on');
        set(handles.FrameNo2,'String',FrameNo2);
        set(handles.slash,'Enable','on');
        set(handles.updatepuff,'Enable','on');

        if ~isempty(hdl_11) && ishandle(hdl_11)
            set(hdl_11,'Visible','on');
            set(hdl_12,'Visible','on');
            set(hdl_21,'Visible','on');
            set(hdl_22,'Visible','on');
            set(hdl_31,'Visible','on');
            set(hdl_32,'Visible','on');
        end
        
        FrameNo1=get(handles.FrameNo1,'String');
        FrameNo2=get(handles.FrameNo2,'String');
        
end




% --- Executes on button press in UpdateCutTime.
function UpdateCutTime_Callback(hObject, eventdata, handles)
global ROIcount presetcolor FrameTime FFST;
global RangeCutAll myTimeTicks fig2_hds ROI_RCh_SR101Wave_All BaseLineFrameNo;
global fig3_hds ROI_GCh_CaWave_All fig4_hds;
global ROI_GCh_CaDivdeRed_All CutFrameNum1 CutFrameNum2;

CutTime1=str2num(get(handles.CutTime01,'String'));
CutTime2=str2num(get(handles.CutTime02,'String'));

CutFrameNum1=fix((CutTime1*1000)/FrameTime);
CutFrameNum2=fix((CutTime2*1000)/FrameTime);

if CutTime1~=0 && CutTime2~=0
    
    if ~isempty(fig3_hds)
        for i=1:ROIcount
            eval(['try delete(fig2_hds(',num2str(i),'));end']);
            eval(['try delete(fig3_hds(',num2str(i),'));end']);
            eval(['try delete(fig4_hds(',num2str(i),'));end']);
        end
    end
    fig2_hds=[];    
    fig3_hds=[];
    fig4_hds=[];
    
    if CutFrameNum1>BaseLineFrameNo
        BaseLineFrameNo=CutFrameNum1;
    end
    
    
    if ROIcount>=1 && ~isempty(ROI_RCh_SR101Wave_All)
        for i=1:ROIcount
            
            RangeCut=RangeCutAll(i,:);
            
            if CutFrameNum1<=BaseLineFrameNo
                
                %%%%%%%% fig 2
                ROI_RCh_SR101Wave_All(i,:) = ROI_RCh_SR101Wave_All(i,:)./mean(ROI_RCh_SR101Wave_All(i,CutFrameNum1:BaseLineFrameNo));
                axes(handles.axes2);
                hold on;
                hd2=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_RCh_SR101Wave_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
                title('\fontsize{12}Red channel intensity inside the defined EC');
                xlim([0 myTimeTicks(end)]);
                fig2_hds=[fig2_hds hd2];
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fig 3
                ROI_GCh_CaWave_All(i,:) = ROI_GCh_CaWave_All(i,:)./mean(ROI_GCh_CaWave_All(i,CutFrameNum1:BaseLineFrameNo));
                axes(handles.axes3);
                hold on;
                hd3=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaWave_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
                title('\fontsize{12}Ca^{2+} inside the defined EC');
                xlim([0 myTimeTicks(end)]);
                fig3_hds=[fig3_hds hd3];
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fig 4
                ROI_GCh_CaDivdeRed_All(i,:) = ROI_GCh_CaDivdeRed_All(i,:)./mean(ROI_GCh_CaDivdeRed_All(i,CutFrameNum1:BaseLineFrameNo));
                axes(handles.axes4);
                hold on;
                hd4=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaDivdeRed_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
                title('\fontsize{12}Calcium intensity / Red channel intensity inside defined EC')
                xlim([0 myTimeTicks(end)]);
                fig4_hds=[fig4_hds hd4];
                
            else
                
                %%%%%%%% fig 2
                ROI_RCh_SR101Wave_All(i,:) = ROI_RCh_SR101Wave_All(i,:)./mean(ROI_RCh_SR101Wave_All(i,CutFrameNum1));
                axes(handles.axes2);
                hold on;
                hd2=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_RCh_SR101Wave_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
                title('\fontsize{12}Red channel intensity inside the defined EC');
                xlim([0 myTimeTicks(end)]);
                fig2_hds=[fig2_hds hd2];
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fig 3
                ROI_GCh_CaWave_All(i,:) = ROI_GCh_CaWave_All(i,:)./mean(ROI_GCh_CaWave_All(i,CutFrameNum1));
                axes(handles.axes3);
                hold on;
                hd3=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaWave_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
                title('\fontsize{12}Ca^{2+} inside the defined EC');
                xlim([0 myTimeTicks(end)]);
                fig3_hds=[fig3_hds hd3];
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fig 4
                ROI_GCh_CaDivdeRed_All(i,:) = ROI_GCh_CaDivdeRed_All(i,:)./mean(ROI_GCh_CaDivdeRed_All(i,CutFrameNum1));
                axes(handles.axes4);
                hold on;
                hd4=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaDivdeRed_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
                title('\fontsize{12}Calcium intensity / Red channel intensity inside defined EC')
                xlim([0 myTimeTicks(end)]);
                fig4_hds=[fig4_hds hd4];
                
            end
        end
            
            
           
    end
    
end




% --- Executes on button press in VideoOptim.
function VideoOptim_Callback(hObject, eventdata, handles)
global myVideo myVideo_New useNew WidthPixNum HeightPixNum PlanePerStack FrameNum avgFrame_3Ch avgFrame_3Ch_new Raw4DVideoG Raw4DVideoR myVideoR_New myVideoR PlanePerStackNew;

myVideo_New=myVideo;
myVideoR_New=myVideoR;


% if conduct zstack vertical alignment
if get(handles.ImgStblFcn,'Value')==1
    ImgZstackAlign=1;
else
    ImgZstackAlign=0;
end

% if image time stabliziation
if get(handles.TimeStablization,'Value')==1
    TimeStablization=1;
else
    TimeStablization=0;
end


% if conduct image smoothing
if get(handles.ImgSmthFcn,'Value')==1
    ImgSmthDone=1;
else
    ImgSmthDone=0;
end

% if conduct image background subtraction
if get(handles.BGsubtract,'Value')==1
    ImgBGSubtract=1;
else
    ImgBGSubtract=0;
end



%%%%%%%%%%%%%%%%%%%%%%%%% option 1: zstack vertical alignment

if ImgZstackAlign==1
    h = waitbar(0,'Please wait for zstack vertical alignment');
    
    %% %%%%%%%%%%%%% estimate the contour 
    avgStack=zeros(WidthPixNum,HeightPixNum,PlanePerStackNew);
    IMbw=zeros(WidthPixNum,HeightPixNum,PlanePerStackNew);
    
    for i=2:10   % we assume that the video will have at least 30 s baseline
        eachStack=double(Raw4DVideoR(:,:,:,i));
        avgStack=avgStack+(eachStack./9);    
    end
    
    hd11=figure;
    for iii=1:PlanePerStackNew
        subplot(3,4,iii),imagesc(avgStack(:,:,iii).');
    end
    
%     figure;
    THLD=mean2(mean(avgStack,3))/max(max(max(avgStack)));
    avgStack=avgStack./max(max(max(avgStack)));
%     for iii=1:PlanePerStack
%         IMbw(:,:,iii)=im2bw(avgStack(:,:,iii),THLD);
% %         subplot(3,4,iii),imagesc(IM);
%         subplot(3,4,iii),imcontour(IMbw(:,:,iii).');
%     end
    
    
    hd22=figure;hold on;
    for iii=1:PlanePerStackNew
        IMbw(:,:,iii)=im2bw(avgStack(:,:,iii),THLD);
        imcontour(IMbw(:,:,iii).');
    end
    axis ij;
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% cross-correlation
    xdrift=zeros(1,PlanePerStackNew-1);
    ydrift=zeros(1,PlanePerStackNew-1);
    
    for i=1:PlanePerStackNew-1
        Frame1=IMbw(:,:,i);
        Frame2=IMbw(:,:,i+1);
        
        cc = xcorr2(Frame2,Frame1);
        [max_cc, imax] = max(abs(cc(:)));
        [ypeak, xpeak] = ind2sub(size(cc),imax(1));
        ydrift(i)=(ypeak-size(Frame1,1));
        xdrift(i)=(xpeak-size(Frame1,2)); 
    end
    
    xdriftNew=GetOffOutlier(xdrift,1.5);
    ydriftNew=GetOffOutlier(ydrift,1.5);
    
    XdriftMean=mean(xdriftNew); 
    if abs(XdriftMean)>=0.8 
        XdriftMean=round(XdriftMean);
    else
        XdriftMean=0;
    end
%     XMeanCoef=(sum(abs(xdrift-XdriftMean)))/sqrt(sum((xdrift-XdriftMean).^2));
    
    YdriftMean=mean(ydriftNew); 
    if abs(YdriftMean)>=0.8 
        YdriftMean=round(YdriftMean);
    else
        YdriftMean=0;
    end
%     YMeanCoef=(sum(abs(ydrift-YdriftMean)))/sqrt(sum((ydrift-YdriftMean).^2));
    
    hh=warndlg(['zstack Xdrift=',num2str(XdriftMean),' zstack Ydrift=',num2str(YdriftMean)],'Result');
    htext = findobj(hh, 'Type', 'Text');  %find text control in dialog
    htext.FontSize = 10;     %set fontsize to whatever you want
    pause(1);
    
%     hh2=warndlg(['Ydrift=',num2str(YdriftMean),' Yceof=',num2str(YMeanCoef)],'Result');
%     htext = findobj(hh2, 'Type', 'Text');  %find text control in dialog
%     htext.FontSize = 15;     %set fontsize to whatever you want


    
    xdriftNew
    ydriftNew
   
    close(hd11);close(hd22);close(hh);

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% correct the movie
    avgFrameG=zeros(WidthPixNum,HeightPixNum);
    avgFrameR=zeros(WidthPixNum,HeightPixNum);
    
    for i=1:FrameNum
        eachStackG=double(Raw4DVideoG(:,:,:,i));
        
        eachStackR=double(Raw4DVideoR(:,:,:,i));
        
        eachStackG_new=eachStackG;
        eachStackR_new=eachStackR;
        
        if XdriftMean>0
            
            %%%%%% green channel
            for j=2:PlanePerStack
                eachStackG_new(:,1:end-XdriftMean*(j-1),j)=eachStackG(:,1+XdriftMean*(j-1):end,j);
                eachStackG_new(:,end-XdriftMean*(j-1)+1:end,j)=repmat(eachStackG(:,end,j),1,XdriftMean*(j-1));
            end
            eachFrameG = max(eachStackG_new, [], 3);
            avgFrameG=avgFrameG+eachFrameG/FrameNum; 
            myVideo_New(:,:,i)=eachFrameG;
            
            %%%%%% red channel
            for j=2:PlanePerStack
                eachStackR_new(:,1:end-XdriftMean*(j-1),j)=eachStackR(:,1+XdriftMean*(j-1):end,j);
                eachStackR_new(:,end-XdriftMean*(j-1)+1:end,j)=repmat(eachStackR(:,end,j),1,XdriftMean*(j-1));
            end
            eachFrameR = max(eachStackR_new, [], 3);
            avgFrameR=avgFrameR+eachFrameR/FrameNum; 
            myVideoR_New(:,:,i)=eachFrameR;
            
        elseif XdriftMean<0
            
            %%%%%% green channel
            for j=2:PlanePerStack
                eachStackG_new(:,1-XdriftMean*(j-1):end,j)=eachStackG(:,1:end+XdriftMean*(j-1),j);
                eachStackG_new(:,1:-XdriftMean*(j-1),j)=repmat(eachStackG(:,1,j),1,-XdriftMean*(j-1));
            end
            eachFrameG = max(eachStackG_new, [], 3);
            avgFrameG=avgFrameG+eachFrameG/FrameNum; 
            myVideo_New(:,:,i)=eachFrameG;
            
            %%%%%% red channel
            for j=2:PlanePerStack
                eachStackR_new(:,1-XdriftMean*(j-1):end,j)=eachStackR(:,1:end+XdriftMean*(j-1),j);
                eachStackR_new(:,1:-XdriftMean*(j-1),j)=repmat(eachStackR(:,1,j),1,-XdriftMean*(j-1));
            end
            eachFrameR = max(eachStackR_new, [], 3);
            avgFrameR=avgFrameR+eachFrameR/FrameNum; 
            myVideoR_New(:,:,i)=eachFrameR;

        end
        
        eachStackG_tmp=eachStackG_new;
        eachStackR_tmp=eachStackR_new;
        
        if YdriftMean>0
            
            avgFrameR=zeros(size(avgFrameR));
            avgFrameG=zeros(size(avgFrameG));
            
            %%%%%% green channel
            for j=2:PlanePerStack
                eachStackG_new(1:end-YdriftMean*(j-1),:,j)=eachStackG_tmp(1+YdriftMean*(j-1):end,:,j);
                eachStackG_new(end-YdriftMean*(j-1)+1:end,:,j)=repmat(eachStackG_tmp(end,:,j),YdriftMean*(j-1),1);
            end
            eachFrameG = max(eachStackG_new, [], 3);
            avgFrameG=avgFrameG+eachFrameG/FrameNum; 
            myVideo_New(:,:,i)=eachFrameG;
            
            %%%%%% red channel
            for j=2:PlanePerStack
                eachStackR_new(1:end-YdriftMean*(j-1),:,j)=eachStackR_tmp(1+YdriftMean*(j-1):end,:,j);
                eachStackR_new(end-YdriftMean*(j-1)+1:end,:,j)=repmat(eachStackR_tmp(end,:,j),YdriftMean*(j-1),1);
            end
            eachFrameR = max(eachStackR_new, [], 3);
            avgFrameR=avgFrameR+eachFrameR/FrameNum; 
            myVideoR_New(:,:,i)=eachFrameR;
            
        elseif YdriftMean<0
            
            avgFrameR=zeros(size(avgFrameR));
            avgFrameG=zeros(size(avgFrameG));
            
            %%%%%% green channel
            for j=2:PlanePerStack
                eachStackG_new(1-YdriftMean*(j-1):end,:,j)=eachStackG_tmp(1:end+YdriftMean*(j-1),:,j);
                eachStackG_new(1:-YdriftMean*(j-1),:,j)=repmat(eachStackG_tmp(end,:,j),-YdriftMean*(j-1),1);
            end
            eachFrameG = max(eachStackG_new, [], 3);
            avgFrameG=avgFrameG+eachFrameG/FrameNum; 
            myVideo_New(:,:,i)=eachFrameG;
            
            %%%%%% red channel
            for j=2:PlanePerStack
                eachStackR_new(1-YdriftMean*(j-1):end,:,j)=eachStackR_tmp(1:end+YdriftMean*(j-1),:,j);
                eachStackR_new(1:-YdriftMean*(j-1),:,j)=repmat(eachStackR_tmp(end,:,j),-YdriftMean*(j-1),1);
            end
            eachFrameR = max(eachStackR_new, [], 3);
            avgFrameR=avgFrameR+eachFrameR/FrameNum; 
            myVideoR_New(:,:,i)=eachFrameR;
        end
        
       
        
        
    end
    
    
    
    %%%%%%%%% plot again
    avgFrame_3Ch_new=zeros(size(avgFrameG,1),size(avgFrameG,2),3);
    avgFrame_3Ch_new(:,:,1)=avgFrameR;
    avgFrame_3Ch_new(:,:,2)=avgFrameG;
    
    if ~YdriftMean & ~XdriftMean
        avgFrame_3Ch_new=avgFrame_3Ch;
        
    else
           
        for j=1:2
            % adjust LUT
            ThisFrame=avgFrame_3Ch_new(:,:,j);
            ThisFrame_min=min(min(ThisFrame));
            ThisFrame_max=max(max(ThisFrame));
            ThisFrame_norm=(ThisFrame-ThisFrame_min)/(ThisFrame_max-ThisFrame_min);
            ThisFrame_new = imadjust(ThisFrame_norm);
            mymin=min(min(ThisFrame_new));
            mymax=max(max(ThisFrame_new));
            avgFrame_3Ch_new(:,:,j)=255*(ThisFrame_new-mymin)/(mymax-mymin);
        end
    end
    avgFrame_3Ch_new=uint8(avgFrame_3Ch_new);
    
    hd33=figure; hold on;
    imagesc(avgFrame_3Ch_new);
    axis image;
    axis off;
    axis ij;
    
    
    pause(0.5);
    axes(handles.axes1);hold on; cla;
    h_avgFrame_3Ch=imagesc(avgFrame_3Ch_new);
    axis image;
    axis off;
    
    
    useNew=1;
    close(h);
    close(hd33);
    
    
end




%% %%%%%%%%%%%%%%%%%%%%%%% option 2: time stabilization

if TimeStablization==1
    dist_xy = [];   % distribution of averaged shift between candidate frame and other frames
    
    disp('Start to analyze frames......');
    for iframe_ref = 1:size(myVideoR_New,3)  % run each frame as a reference frame
        ref_frame = [];
        ref_frame = myVideoR_New(:,:,iframe_ref);   % reference/template frame, e.g., choose the frame when animals is not moving, or stable frame
        
        shiftxy_all = [];
        
        for iframe = 1:size(myVideoR_New,3)
            current_frame = myVideoR_New(:,:,iframe);  % frame that needs to be corrected
            
            [shiftX,shiftY] = run_fftxcorr_get_shift(current_frame,ref_frame);
            
            shiftxy_all = [shiftxy_all (abs(shiftX)+abs(shiftY))./2];  % get averaged shift of x and y direction
            
        end
        dist_xy = [dist_xy mean(shiftxy_all)];
        
        disp([num2str(iframe_ref),'th stack out of ', num2str(size(myVideo_New,3)),' total stacks is done']);
    end
    
    % select least 20% of the frames showing the least shift against other comparing frames
    Table_frame(:,1) = 1:size(myVideoR_New,3);  % frame number
    Table_frame(:,2) = dist_xy;
    Table_frame2 = sortrows(Table_frame,2);
    
    least20_percent = size(myVideoR_New,3)*0.2;
    ref_frame_indice = Table_frame2(1:least20_percent,1);
    REF_frame = mean(myVideoR_New(:,:,ref_frame_indice),3);
    
    %% Now correct all frames in video using the reference frame 'REF_frame'
    avgFrameG=zeros(WidthPixNum,HeightPixNum);
    avgFrameR=zeros(WidthPixNum,HeightPixNum);
    corrected_frame_all_R = [];
    corrected_frame_all_G = [];
    disp('Start to correct frames......');
    for iframe = 1:size(myVideoR_New,3)
        current_frame = [];
        current_frame = myVideoR_New(:,:,iframe);  % frame that needs to be corrected       
        [shiftX,shiftY] = run_fftxcorr_get_shift(current_frame,REF_frame);    
        corrected_frame = circshift(current_frame,[shiftY,shiftX]);       
        corrected_frame_all_R(:,:,iframe) = corrected_frame;     
        avgFrameR=avgFrameR+corrected_frame/FrameNum; 
        
        current_frame_Gch = myVideo_New(:,:,iframe);        
        corrected_frame_Gch = circshift(current_frame_Gch,[shiftY,shiftX]);         
        corrected_frame_all_G(:,:,iframe) = corrected_frame_Gch;      
        avgFrameG=avgFrameG+corrected_frame_Gch/FrameNum; 
        
        
        clear corrected_frame current_frame_Gch corrected_frame_Gch;
        
        disp([num2str(iframe),'th frame is corrected']);
    end
    
    
    myVideoR_New=corrected_frame_all_R;
    myVideo_New=corrected_frame_all_G;
    useNew=1;
    
    %%%%%%%%% plot again
    avgFrame_3Ch_new=zeros(size(avgFrameG,1),size(avgFrameG,2),3);
    avgFrame_3Ch_new(:,:,1)=avgFrameR;
    avgFrame_3Ch_new(:,:,2)=avgFrameG;
    
    for j=1:2
        % adjust LUT
        ThisFrame=avgFrame_3Ch_new(:,:,j);
        ThisFrame_min=min(min(ThisFrame));
        ThisFrame_max=max(max(ThisFrame));
        ThisFrame_norm=(ThisFrame-ThisFrame_min)/(ThisFrame_max-ThisFrame_min);
        ThisFrame_new = imadjust(ThisFrame_norm);
        mymin=min(min(ThisFrame_new));
        mymax=max(max(ThisFrame_new));
        avgFrame_3Ch_new(:,:,j)=255*(ThisFrame_new-mymin)/(mymax-mymin);
    end
    
    avgFrame_3Ch_new=uint8(avgFrame_3Ch_new);
    axes(handles.axes1);hold on; cla;
    h_avgFrame_3Ch=imagesc(avgFrame_3Ch_new);
    axis image;
    axis off;
    
    
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% option 3:  image denoising
if ImgSmthDone==1
    
    SigmaValue=str2num(get(handles.SigmaGF,'String'));
    
    avgFrameG=zeros(WidthPixNum,HeightPixNum);
    avgFrameR=zeros(WidthPixNum,HeightPixNum);
    
    for i=1:size(myVideo_New,3)
        myVideo_New(:,:,i) = imgaussfilt(myVideo_New(:,:,i),SigmaValue);
        avgFrameG=avgFrameG+myVideo_New(:,:,i)/FrameNum; 
        
        myVideoR_New(:,:,i) = imgaussfilt(myVideoR_New(:,:,i),SigmaValue);
        avgFrameR=avgFrameR+myVideoR_New(:,:,i)/FrameNum; 
        
    end
    
    
    %%%%%%%%% plot again
    avgFrame_3Ch_new=zeros(size(avgFrameG,1),size(avgFrameG,2),3);
    avgFrame_3Ch_new(:,:,1)=avgFrameR;
    avgFrame_3Ch_new(:,:,2)=avgFrameG;
    
    for j=1:2
        % adjust LUT
        ThisFrame=avgFrame_3Ch_new(:,:,j);
        ThisFrame_min=min(min(ThisFrame));
        ThisFrame_max=max(max(ThisFrame));
        ThisFrame_norm=(ThisFrame-ThisFrame_min)/(ThisFrame_max-ThisFrame_min);
        ThisFrame_new = imadjust(ThisFrame_norm,[0 1],[]);
        mymin=min(min(ThisFrame_new));
        mymax=max(max(ThisFrame_new));
        avgFrame_3Ch_new(:,:,j)=255*(ThisFrame_new-mymin)/(mymax-mymin);
    end
    
    avgFrame_3Ch_new=uint8(avgFrame_3Ch_new);
    axes(handles.axes1);hold on; cla;
    h_avgFrame_3Ch=imagesc(avgFrame_3Ch_new);
    axis image;
    axis off;
    
    useNew=1;
    
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%% option 4:  Background subtraction
if ImgBGSubtract==1
    
    avgFrameG=zeros(WidthPixNum,HeightPixNum);
    avgFrameR=zeros(WidthPixNum,HeightPixNum);
 
    hd00=figure(100);
    if useNew
        imagesc(avgFrame_3Ch_new);
    else
        imagesc(avgFrame_3Ch);
    end
    title('\fontsize{16}Draw a background area');
    axis image;
    axis off;
    h00=imfreehand;
    setColor(h00,'w');
    ROI_BW_00 = createMask(h00);
    BK_GCh = zeros(1,FrameNum);
    BK_RCh = zeros(1,FrameNum);
    for i=1:FrameNum
%         disp(['i=1',num2str(i)]);
        if useNew
            GreenImgTmp=myVideo_New(:,:,i);
            BK_GCh(i)=mean2(GreenImgTmp.*ROI_BW_00);
            GreenImgTmp=GreenImgTmp-BK_GCh(i);
            GreenImgTmp(find(GreenImgTmp<0))=0;
            myVideo_New(:,:,i)=GreenImgTmp;            
            avgFrameG=avgFrameG+myVideo_New(:,:,i)/FrameNum; 
            
            RedImgTmp=myVideoR_New(:,:,i);
            BK_RCh(i)=mean2(RedImgTmp.*ROI_BW_00);
            RedImgTmp=RedImgTmp-BK_RCh(i);
            RedImgTmp(find(RedImgTmp<0))=0;
            myVideoR_New(:,:,i)=RedImgTmp;
            avgFrameR=avgFrameR+myVideoR_New(:,:,i)/FrameNum; 
            
        else         
            GreenImgTmp=myVideo(:,:,i);
            BK_GCh(i)=mean2(GreenImgTmp.*ROI_BW_00);
            GreenImgTmp=GreenImgTmp-BK_GCh(i);
            GreenImgTmp(find(GreenImgTmp<0))=0;
            myVideo(:,:,i)=GreenImgTmp;
            avgFrameG=avgFrameG+myVideo(:,:,i)/FrameNum; 
            
            RedImgTmp=myVideoR(:,:,i);
            BK_RCh(i)=mean2(RedImgTmp.*ROI_BW_00);
            RedImgTmp=RedImgTmp-BK_RCh(i);
            RedImgTmp(find(RedImgTmp<0))=0;
            myVideoR(:,:,i)=RedImgTmp;
            avgFrameR=avgFrameR+myVideoR(:,:,i)/FrameNum; 
        end
    end
    close(hd00);
    
    useNew=1;
    
    %%%%%%%%% plot again
    avgFrame_3Ch_new=zeros(size(avgFrameG,1),size(avgFrameG,2),3);
    avgFrame_3Ch_new(:,:,1)=avgFrameR;
    avgFrame_3Ch_new(:,:,2)=avgFrameG;
    
    for j=1:2
        % adjust LUT
        ThisFrame=avgFrame_3Ch_new(:,:,j);
        ThisFrame_min=min(min(ThisFrame));
        ThisFrame_max=max(max(ThisFrame));
        ThisFrame_norm=(ThisFrame-ThisFrame_min)/(ThisFrame_max-ThisFrame_min);
        ThisFrame_new = imadjust(ThisFrame_norm,[0 1],[]);
        mymin=min(min(ThisFrame_new));
        mymax=max(max(ThisFrame_new));
        avgFrame_3Ch_new(:,:,j)=255*(ThisFrame_new-mymin)/(mymax-mymin);
    end
    
    avgFrame_3Ch_new=uint8(avgFrame_3Ch_new);
    axes(handles.axes1);hold on; cla;
    h_avgFrame_3Ch=imagesc(avgFrame_3Ch_new);
    axis image;
    axis off;
    
    
%     avgFrame_3Ch_new1=[avgFrame_3Ch_new1 avgFrame_3Ch_new];
%     figure;imagesc(avgFrame_3Ch_new1);
%     axis image;
%     axis off; axis equal;
    
end




% --- Executes on button press in SmoothUpdate.
function SmoothUpdate_Callback(hObject, eventdata, handles)
global ROIcount presetcolor FrameTime FFST;
global RangeCutAll myTimeTicks fig2_hds ROI_RCh_SR101Wave_All BaseLineFrameNo;
global fig3_hds ROI_GCh_CaWave_All fig4_hds;
global ROI_GCh_CaDivdeRed_All CutFrameNum1 CutFrameNum2;
global ROI_RCh_SR101Wave_All_raw ROI_GCh_CaWave_All_raw ROI_GCh_CaDivdeRed_All_raw;


SmoothWinSize=str2num(get(handles.SmoothWinSizeNew,'String'));

if SmoothWinSize>0
    
    if ~isempty(fig3_hds)
        for i=1:ROIcount
            eval(['try delete(fig2_hds(',num2str(i),'));end']);
            eval(['try delete(fig3_hds(',num2str(i),'));end']);
            eval(['try delete(fig4_hds(',num2str(i),'));end']);
        end
    end
    fig2_hds=[];    
    fig3_hds=[];
    fig4_hds=[];
    
    
    
%     ROI_RCh_SR101Wave_All=smooth(ROI_RCh_SR101Wave_All_raw,SmoothWinSize);
%     ROI_GCh_CaDivdeRed_All=smooth(ROI_GCh_CaDivdeRed_All_raw,SmoothWinSize);
%     ROI_GCh_CaWave_All=smooth(ROI_GCh_CaWave_All_raw,SmoothWinSize);
    
    if ROIcount>=1 && ~isempty(ROI_RCh_SR101Wave_All)
        for i=1:ROIcount
            
            RangeCut=RangeCutAll(i,:);
            
            ROI_RCh_SR101Wave_All(i,:)=smooth(ROI_RCh_SR101Wave_All_raw(i,:),SmoothWinSize);
            ROI_GCh_CaDivdeRed_All(i,:)=smooth(ROI_GCh_CaDivdeRed_All_raw(i,:),SmoothWinSize);
            ROI_GCh_CaWave_All(i,:)=smooth(ROI_GCh_CaWave_All_raw(i,:),SmoothWinSize);
            
            %%%%%%%% fig 2
            ROI_RCh_SR101Wave_All(i,:) = ROI_RCh_SR101Wave_All(i,:)./mean(ROI_RCh_SR101Wave_All(i,CutFrameNum1:BaseLineFrameNo));
            axes(handles.axes2);
            hold on;
            hd2=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_RCh_SR101Wave_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
            title('\fontsize{12}Red channel intensity inside the defined EC');
            xlim([0 myTimeTicks(end)]);
            fig2_hds=[fig2_hds hd2];
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fig 3
            ROI_GCh_CaWave_All(i,:) = ROI_GCh_CaWave_All(i,:)./mean(ROI_GCh_CaWave_All(i,CutFrameNum1:BaseLineFrameNo));
            axes(handles.axes3);
            hold on;
            hd3=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaWave_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
            title('\fontsize{12}Ca^{2+} inside the defined EC');
            xlim([0 myTimeTicks(end)]);
            fig3_hds=[fig3_hds hd3];
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% fig 4
            ROI_GCh_CaDivdeRed_All(i,:) = ROI_GCh_CaDivdeRed_All(i,:)./mean(ROI_GCh_CaDivdeRed_All(i,CutFrameNum1:BaseLineFrameNo));
            axes(handles.axes4);
            hold on;
            hd4=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),ROI_GCh_CaDivdeRed_All(i,CutFrameNum1:CutFrameNum2)+0.1*(i-1),presetcolor(i));
            title('\fontsize{12}Calcium intensity / Red channel intensity inside defined EC')
            xlim([0 myTimeTicks(end)]);
            fig4_hds=[fig4_hds hd4];
            
            
        end
        
    end
    
    
    
end






% --- Executes on button press in OpenTiffFile.
function OpenTiffFile_Callback(hObject, eventdata, handles)

global FrameNum FrameTime GreenImg avgFrame myVideoGch myVideoRch PlanePerStack WidthPixNum HeightPixNum RedImg;
global myVideoGch0 myVideoRch0 avgFrame_3Ch myVideo myVideoR PuffTimeNo1 PuffTimeNo2 FrameNo1 FrameNo2 myTimeTicks BaseLineFrameNo;
global Raw4DVideoR Raw4DVideoG CutFrameNum1 CutFrameNum2 CutTime1 CutTime2 HeightStep WidthStep PlanePerStackNew PixelSize;


[filename,pathname] = uigetfile('*.tif','Select the tif file');
set(handles.TiffPath,'String',[pathname,filename]);
cd(pathname);

%%%%% -------
StartPlaneNo=str2num(get(handles.StartFrameNo,'String'));
EndPlaneNo=str2num(get(handles.EndFrameNo,'String'));


%%%%%------
hh=msgbox('Reading the images from the tif file...');

fname = [pathname,filename];
info = imfinfo(fname);
DiamImgs=[];
CaImgs=[];
BoundaryAll=[];
DiamMaskAll=[];
VesselAreaChange=[];
VesselDiamChange=[];

%%%%-------
config.rAreaSFilter=[2,2]; 
config.rAreaMin=100; %defines the smallest number of connected "responding" pixels to be considered a responding region.
config.rMorphClean=1;
config.rImOpenStrel=strel('disk',5); %defines the neighbourhood size for morphological image opening
config.rImCloseStrel=strel('disk',10); %defines the neighbourhood size for morphological image closing


%% %---- read from txt file with the same name
fid = fopen([fname(1:end-4),'.txt'],'r');
TxtAll = textscan(fid,'%s','Delimiter','\n');
fclose(fid);
InfoAll=TxtAll{1};


TimeInfo = InfoAll{13};
k1=findstr(TimeInfo,'-');
k2=findstr(TimeInfo,'[s]');
k3=findstr(TimeInfo,'"');
k4=findstr(TimeInfo,',');
TotalTime = str2num(TimeInfo(k1+1:k2-1));
TotalStack = str2num(TimeInfo(k3(3)+1:k4(1)-1));
FrameTime = TotalTime/TotalStack*1000;


myTimeTicks = FrameTime/1000:FrameTime/1000:FrameTime*TotalStack/1000;
CutTime1=round(myTimeTicks(1));
CutTime2=round(myTimeTicks(end));
CutFrameNum1=1;
CutFrameNum2=FrameNum;
set(handles.CutTime01,'String',num2str(CutTime1));
set(handles.CutTime02,'String',num2str(CutTime2));

XInfo=InfoAll{10};
k1=findstr(XInfo,',');
k2=findstr(XInfo,'[um/pixel]');
XPixelSize=str2num(XInfo(k1(end)+1:k2-1));


ChInfo=InfoAll{11};
k1=findstr(ChInfo,'"');
ChNum=str2num(ChInfo(k1(3)+1:k1(3)+2));

PlanePerStack=1;
FrameNum=TotalStack;

%% re-scale the image
for k = 1:TotalStack
    % disp(['k=',num2str(k)]);
    CaImgs(:,:,k) = imread(fname, (k-1)*2+1, 'Info', info);
    DiamImgs(:,:,k) = imread(fname, k*2, 'Info', info);
end 

ZInfo=InfoAll{12};
k1=findstr(ZInfo,',');
k2=findstr(ZInfo,'[um/Slice]');
k3=findstr(ZInfo,'"');
k4=findstr(ZInfo,',');
TotalSliceNoOriginal=str2num(ZInfo(k3(3)+1:k4(1)-1));
ZPixelSize=str2num(ZInfo(k1(end)+1:k2-1))./(size(DiamImgs,1)/TotalSliceNoOriginal);

if XPixelSize~=ZPixelSize
    zNoPxl = size(DiamImgs,1);
    xNoPxl = size(DiamImgs,2);
    zNoPxl_desired = round(zNoPxl*ZPixelSize/XPixelSize);

    DiamImgs_New = zeros([zNoPxl_desired xNoPxl TotalStack]);
    CaImgs_New = zeros([zNoPxl_desired xNoPxl TotalStack]);
    
    for i=1:TotalStack
        DiamImgs_New(:,:,i) = imresize(DiamImgs(:,:,i),[zNoPxl_desired xNoPxl]);
        CaImgs_New(:,:,i) = imresize(CaImgs(:,:,i),[zNoPxl_desired xNoPxl]);
    end

    clear DiamImgs CaImgs;
    DiamImgs = DiamImgs_New;
    CaImgs = CaImgs_New;
    ZPixelSize = XPixelSize;    
end

YPixelSize = ZPixelSize;

WidthPixNum = size(CaImgs,1);
HeightPixNum = size(CaImgs,2);
PixelSize=XPixelSize;

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 1st round extraction of diameter and calcium

DiamMean = mean(DiamImgs,3);
CaMean = mean(CaImgs,3);

%%% get the average image and image stack of Three channels of all frames 
avgFrame_3Ch=zeros(size(DiamImgs,1),size(DiamImgs,2),3);
avgFrame_3Ch(:,:,1)=CaMean;
avgFrame_3Ch(:,:,2)=DiamMean;

for j=1:2
    % adjust LUT
    mymin=min(min(avgFrame_3Ch(:,:,j)));
    mymax=max(max(avgFrame_3Ch(:,:,j)));
    avgFrame_3Ch(:,:,j)=255*(avgFrame_3Ch(:,:,j)-mymin)/(mymax-mymin);
end
avgFrame_3Ch_unit8=uint8(avgFrame_3Ch);
axes(handles.axes1);
% set(gcf,'units','normalized','outerposition',[0 0 1 1]);
h_avgFrame_3Ch=imagesc(avgFrame_3Ch_unit8);
axis image;
axis off;
axis ij;


%% 

% myVideoGch0=CaImgs;
% myVideoRch0=DiamImgs;
% myVideoGch=CaImgs;
% myVideoRch=DiamImgs;
% myVideo=myVideoGch;
% myVideoR=myVideoRch;

myVideoGch0=DiamImgs;
myVideoRch0=CaImgs;
myVideoGch=DiamImgs;
myVideoRch=CaImgs;
myVideo=myVideoGch;
myVideoR=myVideoRch;


PuffTimeNo1=str2num(get(handles.FrameNo1,'String'));
PuffTimeNo2=str2num(get(handles.FrameNo2,'String'));

if str2num(FrameNo1)*str2num(FrameNo2)
    tI=find(myTimeTicks<PuffTimeNo1);
    FrameNo1=num2str(tI(end));
    
    tI=find(myTimeTicks<PuffTimeNo2);
    FrameNo2=num2str(tI(end));
end


BaseLineFrameNo=10;
if str2num(FrameNo1)>BaseLineFrameNo 
    BaseLineFrameNo=str2num(FrameNo1);
end



close(hh);






function StartFrameNo_Callback(hObject, eventdata, handles)

function StartFrameNo_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function EndFrameNo_Callback(hObject, eventdata, handles)

function EndFrameNo_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function SigmaGF_Callback(hObject, eventdata, handles)

function SigmaGF_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function BGsubtract_Callback(hObject, eventdata, handles)

function TiffPath_Callback(hObject, eventdata, handles)

function TiffPath_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function VideoReset_Callback(hObject, eventdata, handles)

function TimeStablization_Callback(hObject, eventdata, handles)

function edit20_Callback(hObject, eventdata, handles)

function edit20_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function SmoothWinSize_CreateFcn(hObject, eventdata, handles)

function CutTime01_Callback(hObject, eventdata, handles)

function CutTime01_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ImgStblFcn_Callback(hObject, eventdata, handles)

function ImgSmthFcn_Callback(hObject, eventdata, handles)


function CutTime02_Callback(hObject, eventdata, handles)

function CutTime02_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function FrameNo2_Callback(hObject, eventdata, handles)

function FrameNo2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function FrameNo1_Callback(hObject, eventdata, handles)

function FrameNo1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ForPuffing_SelectionChangeFcn(hObject, eventdata, handles)

function OGBChannel_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit13_Callback(hObject, eventdata, handles)

function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function PeakAmpThld_Callback(hObject, eventdata, handles)

function PeakAmpThld_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton10_Callback(~, eventdata, handles)

function NoiseAllowPOI_Callback(hObject, eventdata, handles)

function NoiseAllowPOI_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function loaddata_Callback(hObject, eventdata, handles)

function Runningwindow_Callback(hObject, eventdata, handles)

function NoiseAllow_GTD_Callback(hObject, eventdata, handles)

function NoiseAllow_GTD_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function BaselinePeriod_BTD_Callback(hObject, eventdata, handles)

function BaselinePeriod_BTD_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TransDurationMin_GTD_Callback(hObject, eventdata, handles)

function TransDurationMin_GTD_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function TransDurationMax_GTD_Callback(~, eventdata, ~)

function TransDurationMax_GTD_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CorrectBLdrift_Callback(~, eventdata, handles)

function SplitRoiWaves_Callback(hObject, eventdata, handles)

function pushbutton14_Callback(hObject, eventdata, handles)

function SmoothWinSizeNew_Callback(hObject, eventdata, handles)

function SmoothWinSizeNew_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ReferCh_Callback(hObject, eventdata, handles)

function ReferCh_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function WinSize_Callback(hObject, eventdata, handles)

function WinSize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function UpdatePOIROIs_Callback(hObject, eventdata, handles)
