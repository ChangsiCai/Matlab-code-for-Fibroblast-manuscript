function varargout = VesselDiameter_ByArea_GUI_MAIN(varargin)
% VESSELDIAMETER_BYAREA_GUI_MAIN MATLAB code for VesselDiameter_ByArea_GUI_MAIN.fig
%      VESSELDIAMETER_BYAREA_GUI_MAIN, by itself, creates a new VESSELDIAMETER_BYAREA_GUI_MAIN or raises the existing
%      singleton*.
%
%      H = VESSELDIAMETER_BYAREA_GUI_MAIN returns the handle to a new VESSELDIAMETER_BYAREA_GUI_MAIN or the handle to
%      the existing singleton*.
%
%      VESSELDIAMETER_BYAREA_GUI_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VESSELDIAMETER_BYAREA_GUI_MAIN.M with the given input arguments.
%
%      VESSELDIAMETER_BYAREA_GUI_MAIN('Property','Value',...) creates a new VESSELDIAMETER_BYAREA_GUI_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VesselDiameter_ByArea_GUI_MAIN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VesselDiameter_ByArea_GUI_MAIN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VesselDiameter_ByArea_GUI_MAIN

% Last Modified by GUIDE v2.5 04-Apr-2023 23:42:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VesselDiameter_ByArea_GUI_MAIN_OpeningFcn, ...
                   'gui_OutputFcn',  @VesselDiameter_ByArea_GUI_MAIN_OutputFcn, ...
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


% --- Executes just before VesselDiameter_ByArea_GUI_MAIN is made visible.
function VesselDiameter_ByArea_GUI_MAIN_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for VesselDiameter_ByArea_GUI_MAIN
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% read in %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global variables
global myDIs presetcolor vesselcount ChChoose RedImg GreenImg BlueImg ROIPosAll avgFrame_3Ch_new;
global FrameHeight FrameNum fig2_hds fig2_waves myTimeTicks fig3_hds fig3_waves fig4_hds;
global fig4_waves fig5_hds fig5_waves ROIs text_hds FiletoStudy STITimeTicks BaseLineFrameNo FrameNo1 FrameNo2; 
global FrameTime FFST hdl_11 hdl_12 hdl_21 hdl_22 hdl_31 hdl_32 hdl_STI1 hdl_STI2 hdl_STI3 NoiseAllow myVideo;
global ResStT2 ResStLoc2 ResStT3 ResStLoc3 ResStT4 ResStLoc4 HeightStep LegendAll hROIsRect;
global LocNumAll LocColorAll LocNameAll SkeletonExist HeightPixNum WidthPixNum PlanePerStack avgFrame_3Ch;
global useNew CutTime1 CutTime2 CutFrameNum1 CutFrameNum2 ROI_Geo_Distance ROIWidthAll ColorCollection;
global RestitchCord CutImageCord1 CutImageCord2 hdl_STI4 hdl_41 hdl_42 ROINoPerCap PuffStartTime PuffEndTime Wave_Measure;
global PuffTimeNo1 PuffTimeNo2 Raw4DVideoG Raw4DVideoR fig2_waves_raw myVideoR myVideo_New myVideoR_New PlanePerStackNew PixelSize BK_GCh BK_RCh;

if ~isempty('vesselcount') && length(vesselcount)~=0
    if vesselcount>0
    for i=1:vesselcount
        eval(['global AllFrameROI_',num2str(i)]);
        if exist(eval([char(39),'AllFrameROI_',num2str(i),char(39)]))
            eval(['clear AllFrameROI_',num2str(i),';']);
        end
    end
    end
end


% mesfilename='F4';
%%% set the presetcolor
ColorCollection='rbgymck';
ColorValCollection=[1 0 0;0 0 1;0 1 0;1 1 0;1 0 1;0 1 1;0.6 0.6 0.6];

LocNumAll=[str2num(get(handles.Loc1Num,'String')) str2num(get(handles.Loc2Num,'String')) str2num(get(handles.Loc3Num,'String'))...
    str2num(get(handles.Loc4Num,'String')) str2num(get(handles.Loc5Num,'String')) str2num(get(handles.Loc6Num,'String'))...
    str2num(get(handles.Loc7Num,'String'))];
 
LocColorAll=[get(handles.Loc1Color,'String') get(handles.Loc2Color,'String') get(handles.Loc3Color,'String')...
    get(handles.Loc4Color,'String') get(handles.Loc5Color,'String') get(handles.Loc6Color,'String')...
    get(handles.Loc7Color,'String')];

LocNameAll={get(handles.Loc1,'String') get(handles.Loc2,'String') get(handles.Loc3,'String')...
    get(handles.Loc4,'String') get(handles.Loc5,'String') get(handles.Loc6,'String')...
    get(handles.Loc7,'String')};

presetcolor=cell(1,sum(LocNumAll));
LegendAll=cell(1,sum(LocNumAll));
ColorIndextemp=1;
for i=1:7
    if LocNumAll(i)        
        for j=1:LocNumAll(i)
            if i>1
                ColorIndextemp=sum(LocNumAll(1:i-1))+j;
            else
                ColorIndextemp=j;
            end
            presetcolor{ColorIndextemp}=ColorValCollection(i,:)*j/LocNumAll(i);
            LegendAll{ColorIndextemp}=[LocNameAll{i},'_',num2str(j)];
        end
    end    
end
clear ColorIndextemp;


%%%% initilization

avgFrame_3Ch=[];
avgFrame_3Ch_new=[];
BK_GCh=[];
BK_RCh=[];
CutImageCord1=0;
CutImageCord2=0;
CutTime1=0;
CutTime2=0;
CutFrameNum1=0;
CutFrameNum2=0;
fig2_hds=[];
fig2_waves=[];
fig2_waves_raw=[];
fig3_hds=[];
fig3_waves=[];
fig4_hds=[];
fig4_waves=[];
fig5_hds=[];
fig5_waves=[];
FrameNo1='0';
FrameNo2='0';
hROIsRect=[];
hdl_11=[];
hdl_12=[];
hdl_21=[];
hdl_22=[];
hdl_31=[];
hdl_32=[];
hdl_41=[];
hdl_42=[];
hdl_STI1=[];
hdl_STI2=[];
hdl_STI3=[];
hdl_STI4=[];
myVideo=[];
myVideoR=[];
myVideo_New=[];
myVideoR_New=[];
NoiseAllow=2;    % used for detecting the start time of response after STI, it must be >avg+std*NoiseAllow
PuffTimeNo1=0;
PuffTimeNo2=0;
ROIPosAll={};
Raw4DVideoG=[];
Raw4DVideoR=[];
ResStT2=[];
ResStLoc2=[];
ResStT3=[];
ResStLoc3=[];
ResStT4=[];
ResStLoc4=[];
ROIs=[];
ROI_Geo_Distance=[];
ROIWidthAll=[];
RestitchCord=0;
ROINoPerCap=zeros(length(LocNumAll),2);
SkeletonExist=0;
text_hds=[];
PixelSize=0;
PlanePerStackNew=0;
PuffStartTime=0;
PuffEndTime=0;
useNew=0;
vesselcount=0;
Wave_Measure=[];

clc;
cla(handles.axes1);
cla(handles.axes2);
cla(handles.axes3);
cla(handles.axes4);
cla(handles.axes5);
% set(handles.HalfWinSize,'String',5);

% make the handles global
global handlesaxes1 handlesaxes2 handlesaxes3 handlesaxes4 handlesaxes5 avgFrame WidthStep;
handlesaxes1=handles.axes1;
handlesaxes2=handles.axes2;
handlesaxes3=handles.axes3;
handlesaxes4=handles.axes4;
handlesaxes5=handles.axes5;


function varargout = VesselDiameter_ByArea_GUI_MAIN_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function Plot_Callback(hObject, eventdata, handles)
global presetcolor myDIs vesselcount ROIs ROIPosAll FrameHeight FrameNum fig2_hds fig2_waves myTimeTicks fig3_hds fig3_waves fig4_hds fig4_waves text_hds STITimeTicks BaseLineFrameNo COI_Mask FrameNo1 hdl_STI1 hdl_STI2 hdl_STI3;
global myVideo myVideo_New LineProfile hCV currentVesselNo hROIsRect useNew CellIOT handlesaxes2 handlesaxes3 handlesaxes4 handlesaxes5 CutFrameNum1 CutFrameNum2 ROIWidthAll fig5_hds fig5_waves hdl_STI4;
global LocNumAll LocColorAll LocNameAll LegendAll ROINoPerCap FrameNo2 FrameTime FFST hdl_31 hdl_32 PuffStartTime PuffEndTime Wave_Measure fig2_waves_raw;
global myVideoR myVideoR_New BK_GCh BK_RCh avgFrame_3Ch avgFrame_3Ch_new;



%% Freehand plot the contour of ROI
vesselcount=vesselcount+1;
axes(handles.axes1);
h=imline;
setColor(h,presetcolor{vesselcount});
COI_Mask = createMask(h).';   % cell of interest
ROIpos = getPosition(h);

% register ROINoPerCap
ColorIndextemp=0;
ROINoPerCap=zeros(7,2);
for i=1:7
    for j=1:LocNumAll(i)
        ColorIndextemp=ColorIndextemp+1;
        if ColorIndextemp<=vesselcount
            if j==1
                ROINoPerCap(i,1)=ColorIndextemp;
                ROINoPerCap(i,2)=ColorIndextemp;
            else
                ROINoPerCap(i,2)=ColorIndextemp;
            end
        else
            break;
         end
    end
end

% redraw the curve
delete(h);
axes(handles.axes1);hold on;
hh=line(ROIpos(:,1),ROIpos(:,2),'Color',presetcolor{vesselcount},'LineWidth',2);
ROIs=[ROIs hh];

% find the four corner points of the square
ROIWidthAll=[ROIWidthAll str2num(get(handles.HalfWinSize,'String'))];
SquareCornerMarks=FindSquareCorner(ROIpos(1,:),ROIpos(2,:),str2num(get(handles.HalfWinSize,'String')));
hRecTemp=zeros(1,4);
hRecTemp(1)=line(SquareCornerMarks(1:2,1),SquareCornerMarks(1:2,2),'Color',presetcolor{vesselcount},'LineWidth',1);
hRecTemp(2)=line(SquareCornerMarks(2:3,1),SquareCornerMarks(2:3,2),'Color',presetcolor{vesselcount},'LineWidth',1);
hRecTemp(3)=line(SquareCornerMarks(3:4,1),SquareCornerMarks(3:4,2),'Color',presetcolor{vesselcount},'LineWidth',1);
hRecTemp(4)=line([SquareCornerMarks(1,1) SquareCornerMarks(4,1)],[SquareCornerMarks(1,2) SquareCornerMarks(4,2)],'Color',presetcolor{vesselcount},'LineWidth',1);
hROIsRect=[hROIsRect;hRecTemp];


% Mark the index of the ROI in the image
[m,ii]=min(ROIpos(:,2));
MposX=ROIpos(ii,1);
MposY=ROIpos(ii,2);
% MposY=mean(ROIpos(:,2));
thd=text(MposX,MposY,['r',int2str(vesselcount)],'color',presetcolor{vesselcount},'Fontsize',12);
text_hds=[text_hds thd];
clear m ii;
% 
% Save the ROI position for later use
ROIPosAll{vesselcount}=ROIpos;    % [X1 Y1; X2 Y2]


% Create AllFrameROI_'vesselcount'
[m,n]=size(ROIPosAll{vesselcount});
eval(['global AllFrameROI_',num2str(vesselcount)]);
eval(['AllFrameROI_',num2str(vesselcount),'=zeros(m,n,FrameNum);']);

for j=1:FrameNum
    eval(['AllFrameROI_',num2str(vesselcount),'(:,:,',num2str(j),')','=ROIPosAll{',num2str(vesselcount),'};']);
end

% get parameters prepared
HalfWinSize=str2num(get(handles.HalfWinSize,'String'));
LineProfile=[];

% read in the 2D image and do Chan-Vese analysis
currentVesselNo=vesselcount;
        
try
     delete(20);
end
        
% ask the user to be patinet
hm = msgbox(['Please wait for loading r',num2str(currentVesselNo)]);
        
%
LineProfile=[];
CurrentROI=ROIPosAll{currentVesselNo};
        
        
% how much should move the parallel line in 1 pixel distance
deltaX=sqrt(1/(1+((CurrentROI(1,1)-CurrentROI(2,1))/(CurrentROI(1,2)-CurrentROI(2,2))).^2));
deltaY=sqrt(1/(1+((CurrentROI(1,2)-CurrentROI(2,2))/(CurrentROI(1,1)-CurrentROI(2,1))).^2));
        
% plot out the lineprofile
if useNew
    for j=1:FrameNum
        LineP0=improfile(myVideo_New(:,:,j),CurrentROI(:,1),CurrentROI(:,2));
        for k=1:HalfWinSize
            LineP0=LineP0+improfile(myVideo_New(:,:,j),CurrentROI(:,1)+deltaX*k,CurrentROI(:,2)+deltaY*k)+improfile(myVideo_New(:,:,j),CurrentROI(:,1)-deltaX*k,CurrentROI(:,2)-deltaY*k);
        end
        LineP0=LineP0/(2*HalfWinSize+1);
        LineProfile=[LineProfile;LineP0.'];
    end  
else
    for j=1:FrameNum
        LineP0=improfile(myVideo(:,:,j),CurrentROI(:,1),CurrentROI(:,2));
        for k=1:HalfWinSize
            LineP0=LineP0+improfile(myVideo(:,:,j),CurrentROI(:,1)+deltaX*k,CurrentROI(:,2)+deltaY*k)+improfile(myVideo(:,:,j),CurrentROI(:,1)-deltaX*k,CurrentROI(:,2)-deltaY*k);
        end
        LineP0=LineP0/(2*HalfWinSize+1);
        LineProfile=[LineProfile;LineP0.'];
    end  
end

% close the message window
try 
    close(hm);
end


%%% call  for a new window
hCV=VesselDiameter_ChanVesse_New;

while ishandle(hCV)
    pause(0.1);
end


%%%%%%% plot it back to axes 2,3,4
%% figure 2: absolute diamter plot
% recorrect the absolute diameter by tilted angle
EnlongInd=1;  % restretch index
x1=ROIpos(1,1);x2=ROIpos(2,1);
y1=ROIpos(1,2);y2=ROIpos(2,2);
if abs(x1-x2)>=abs(y1-y2)
    EnlongInd=sqrt((x2-x1)^2+(y2-y1)^2)/abs(x1-x2);
else
    EnlongInd=sqrt((x2-x1)^2+(y2-y1)^2)/abs(y1-y2);
end
CellIOT=CellIOT.*EnlongInd;
SmoothWinSize=str2num(get(handles.SmoothWinSizeNew,'String'));
CellIOT=smooth(CellIOT,SmoothWinSize);


% plot
axes(handlesaxes2);
hold on;
hd2=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),CellIOT(CutFrameNum1:CutFrameNum2),'Color',presetcolor{currentVesselNo});
title('\fontsize{10}Raw Diameter');
ylabel('\fontsize{10}Diameter(um)');
mylim=get(gca,'ylim');
if length(STITimeTicks)
    try
        delete(hdl_STI1);
    end
    
    hdl_STI1=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
end
fig2_hds=[fig2_hds hd2];
fig2_waves=[fig2_waves;CellIOT.'];
fig2_waves_raw=fig2_waves;
if str2num(FrameNo1)*str2num(FrameNo2)
    hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
    hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
end

% Plot normalized (1) intensity over time in middle right subplot 
V3=CellIOT./mean(CellIOT(CutFrameNum1:BaseLineFrameNo));    % first frame is not good because of warm up
axes(handlesaxes3);
hold on;
hd3=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),V3(CutFrameNum1:CutFrameNum2),'Color',presetcolor{currentVesselNo},'LineWidth',2);
title('\fontsize{10}Normalized Diameter Change');
xlabel('\fontsize{10}Time(s)');
ylim('auto');
mylim=get(gca,'ylim');
if length(STITimeTicks)
    try
        delete(hdl_STI2);
    end
    
    hdl_STI2=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
end
ylim(mylim);
fig3_hds=[fig3_hds hd3];
fig3_waves=[fig3_waves;V3.'];
if str2num(FrameNo1)*str2num(FrameNo2)
    hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
    hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
end


    

%%%%% Determine how many bars should be in the following two bar plots
ROINoCaptemp=mean(ROINoPerCap,2);
BarNum=0;
for j=1:length(ROINoCaptemp)
    if ROINoCaptemp(j) 
        BarNum=BarNum+1;
    end
end


% Plot mean waveforms at each order capillary
axes(handlesaxes4);hold on;
cla;

Mean_Waves=zeros(BarNum,length(V3));
ColorCollection='rbgymck';

for j=1:BarNum
    Mean_Waves(j,:)=mean(fig3_waves(ROINoPerCap(j,1):ROINoPerCap(j,2),:),1);
    plot(myTimeTicks(CutFrameNum1:CutFrameNum2),Mean_Waves(j,CutFrameNum1:CutFrameNum2),ColorCollection(j),'LineWidth',2);
end
title('\fontsize{10}Mean curves at each order');
xlabel('\fontsize{10}Time (s)');
ylim('auto');
mylim=get(gca,'ylim');
if length(STITimeTicks)
  
    hdl_STI3=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
end
if str2num(FrameNo1)*str2num(FrameNo2)
    hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
    hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
end

ylim(mylim);

fig4_waves=Mean_Waves;

%%%%%%%%%%%% figure 5 plot
% Plot amplitude and mean area under curve at each order capillary
Wave_Measure=zeros(BarNum,2); % 1st row is dilation peak amp, 2nd row is constriction peak amp


if length(STITimeTicks)
    for j=1:BarNum
        [~,~,~,Wave_Measure(j,1),~,~,~,~,~,~,~, Wave_Measure(j,2)]=ResponseStartTime50P_5(fig4_waves(j,:));  %response start time

    end
end

if str2num(FrameNo1)*str2num(FrameNo2)
    for jj=1:BarNum
        [~, ~, ~, Wave_Measure(jj,1), ~, ~, ~, ~, ~, Wave_Measure(jj,2), ~]=AirPuffPeakFinder(fig4_waves(jj,:),FrameNo1,FrameNo2);
    end
end

Wave_Measure=(Wave_Measure-1)*100;

%%%%%%%%%% plot 
axes(handlesaxes5);
cla;
hold on;
hbar=bar(Wave_Measure(:,1:2).');
for j=1:BarNum
    set(hbar(j),'FaceColor',ColorCollection(j));
    set(hbar(j),'EdgeColor',ColorCollection(j));
end
set(hbar,'BarWidth',1);    % The bars will now touch each other
set(gca,'GridLineStyle','-');
set(gca,'XTick',[1 2]);
xticklabels({'Dilation Peak','Constriction Peak'});
title('\fontsize{10}Dilation and constriction peak at each order');
set(get(gca,'YLabel'),'String','Diameter change (%)','FontSize',10);
set(gca,'FontSize',10);
q = char(39);legendcommand=['lh=legend(',q];
for j=1:BarNum
    if j<BarNum
        legendcommand=[legendcommand,LocNameAll{j},q,',',q];
    else
        legendcommand=[legendcommand,LocNameAll{j},q,');'];
    end
end
eval(legendcommand);
set(lh,'Location','NorthEast');
hold on;
box off;
fig5_waves=Wave_Measure;




function SquareCornerMarks = FindSquareCorner(Dot1,Dot2,HalfWinSize)
% This function can calculate the four rectangular corner
X1=Dot1(1);Y1=Dot1(2);
X2=Dot2(1);Y2=Dot2(2);

SquareCornerMarks=zeros(4,2);

vectorN1=[(Y2-Y1) (X1-X2)]./sqrt((X1-X2).^2+(Y1-Y2).^2);
vectorN2=[(Y1-Y2) (X2-X1)]./sqrt((X1-X2).^2+(Y1-Y2).^2);

SquareCornerMarks(1,:)=[X1 Y1]+vectorN1.*HalfWinSize;
SquareCornerMarks(2,:)=[X1 Y1]+vectorN2.*HalfWinSize;
SquareCornerMarks(3,:)=[X2 Y2]+vectorN2.*HalfWinSize;
SquareCornerMarks(4,:)=[X2 Y2]+vectorN1.*HalfWinSize;




function Delete_Callback(hObject, eventdata, handles)
global vesselcount ROIs ROIPosAll fig2_hds fig2_waves fig3_hds fig3_waves fig4_hds fig4_waves text_hds;
global hdl_11 hdl_12 hdl_21 hdl_22 hdl_31 hdl_32 hdl_41 hdl_42 hdl_STI1 hdl_STI2 hdl_STI3 hdl_STI4 hROIsRect ROIWidthAll PuffStartTime PuffEndTime;
global fig5_hds fig5_waves ROINoPerCap handlesaxes4 myTimeTicks CutFrameNum1 CutFrameNum2 STITimeTicks FrameNo1 FrameNo2 BaseLineFrameNo handlesaxes5 LocNameAll
global Wave_Measure fig2_waves_raw;
eval(['global AllFrameROI_',num2str(vesselcount)]);

if vesselcount>=1
    delete(ROIs(vesselcount));
    ROIs(vesselcount)=[];
    ROIPosAll(vesselcount)=[];
    ROIWidthAll(vesselcount)=[];
    
    % update ROINoPerCap
    for j=size(ROINoPerCap,1):-1:1
        if ROINoPerCap(j,2)
            if ROINoPerCap(j,2)-ROINoPerCap(j,1)
                ROINoPerCap(j,2)=ROINoPerCap(j,2)-1;
            else
                ROINoPerCap(j,:)=zeros(1,2);
            end
            break;

        end
    end
    
    
    
    ROINoCaptemp=mean(ROINoPerCap,2);
    BarNum=0;
    for j=1:length(ROINoCaptemp)
        if ROINoCaptemp(j) 
            BarNum=BarNum+1;
        end
    end
    
    % figure 4
    axes(handlesaxes4);hold on;
    cla;
    if vesselcount>1
        Mean_Waves=zeros(BarNum,size(fig3_waves,2));
        ColorCollection='rbgymck';
        for j=1:BarNum
            Mean_Waves(j,:)=mean(fig3_waves(ROINoPerCap(j,1):ROINoPerCap(j,2),:),1);
            plot(myTimeTicks(CutFrameNum1:CutFrameNum2),Mean_Waves(j,CutFrameNum1:CutFrameNum2),ColorCollection(j),'LineWidth',2);
        end
        title('\fontsize{10}Mean curves at each order');
        xlabel('\fontsize{10}Time (s)');
        ylim auto;
        mylim=get(gca,'ylim');
        if length(STITimeTicks)
            hdl_STI3=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
        end
        if str2num(FrameNo1)*str2num(FrameNo2)
            hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
            hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
        end
    
        ylim(mylim);
        fig4_waves=Mean_Waves;
    else
        fig4_waves=[];
    end
    
    
    % figure 5
    Wave_Measure=zeros(BarNum,2); % 1st row is mean amp, 2nd row is mean auc
    if length(STITimeTicks)
            for j=1:BarNum
                [~,~,~,Wave_Measure(j,1),~,~,~,~,~,~,~, Wave_Measure(j,2)]=ResponseStartTime50P_5(fig4_waves(j,:));  %response start time

            end
    end

    if str2num(FrameNo1)*str2num(FrameNo2)
        for jj=1:BarNum
            [~, ~, ~, Wave_Measure(jj,1), ~, ~, ~, ~, ~, Wave_Measure(jj,2), ~]=AirPuffPeakFinder(fig4_waves(jj,:),FrameNo1,FrameNo2);
        end
    end
            
    Wave_Measure=(Wave_Measure-1)*100;
    
    axes(handlesaxes5);
    cla;
    hold on;
    ColorCollection='rbgymck';
    if vesselcount>1
        hbar=bar(Wave_Measure(:,1:2).');
        for j=1:BarNum
                set(hbar(j),'FaceColor',ColorCollection(j));
                set(hbar(j),'EdgeColor',ColorCollection(j));
%               hbar(j).FaceColor = ColorCollection(j);
%               hbar(j).EdgeColor = ColorCollection(j);
        end
        set(hbar,'BarWidth',1);    % The bars will now touch each other
        set(gca,'GridLineStyle','-');
        set(gca,'XTick',[1 2])
        xticklabels({'Dilation Peak','Constriction Peak'});
        title('\fontsize{10}Dilation and constriction peak at each order');
        set(get(gca,'YLabel'),'String','Diameter change (%)','FontSize',10);
        set(gca,'FontSize',10);
        q = char(39);legendcommand=strcat('lh = legend(',q);
        for j=1:BarNum
            if j<BarNum
                legendcommand=strcat(legendcommand,LocNameAll{j},q,',',q);
            else
                legendcommand=strcat(legendcommand,LocNameAll{j},q,');');
            end
        end
        eval(legendcommand);
        set(lh,'Location','NorthEast');
        ylim auto;
        hold on;
        box off;
        fig5_waves=Wave_Measure;
    else
        fig5_waves=[];
    end
    
    
    if ~isempty(fig2_hds)
    
        try delete(fig2_hds(vesselcount));end
        try fig2_hds(vesselcount)=[];end
        try fig2_waves(vesselcount,:)=[];end
        try fig2_waves_raw(vesselcount,:)=[];end
    
        try delete(fig3_hds(vesselcount));end
        try fig3_hds(vesselcount)=[];end
        try fig3_waves(vesselcount,:)=[];end
    
    end
    
    
    delete(text_hds(vesselcount));
    delete(hROIsRect(vesselcount,:));
    text_hds(vesselcount)=[];
    hROIsRect(vesselcount,:)=[];
    
    eval(['clear AllFrameROI_',num2str(vesselcount),';']);
    
    vesselcount=vesselcount-1;
    
end

if vesselcount==0 && ~isempty(hdl_11) && ishandle(hdl_11)
    set(hdl_11,'Visible','off');
    set(hdl_12,'Visible','off');
    set(hdl_21,'Visible','off');
    set(hdl_22,'Visible','off');
    set(hdl_31,'Visible','off');
    set(hdl_32,'Visible','off');
end

if vesselcount==0 && ~isempty(hdl_STI1) && ishandle(hdl_STI1)
    set(hdl_STI1,'Visible','off');
    set(hdl_STI2,'Visible','off');
    try set(hdl_STI3,'Visible','off');end
end





function Save_Callback(hObject, eventdata, handles)
global Faxes1;
Faxes1=getframe(handles.axes1);  %select axes in GUI
GUI_2_handle = VesselDiameter_SavingOptions;




% --- Executes on button press in popout2.
function popout2_Callback(hObject, eventdata, handles)
global STITimeTicks vesselcount presetcolor fig2_waves FrameTime FFST FrameNo1 FrameNo2 myTimeTicks ResStT2 ResStLoc2 CutFrameNum1 CutFrameNum2;

figure(12);
hold on;
for i=1:size(fig2_waves,1)
    hd12=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),fig2_waves(i,CutFrameNum1:CutFrameNum2),'Color',presetcolor{i},'LineWidth',2);
    if length(STITimeTicks)~=0
        [ResStT2(i),ResStLoc2(i)]=ResponseStartTime50P_2(fig2_waves(i,:));  %response start time   
    end    
end
title('\fontsize{18}Raw Diameter');
xlabel('\fontsize{16}Time (s)');
ylabel('\fontsize{16}Diameters (um)');
set(gca,'Fontsize',15);

% plot STI
mylim=get(gca,'ylim');
STITicksLoc=[mylim(2)-0.03*(mylim(2)-mylim(1)) mylim(2)];
if length(STITimeTicks)>=1
    for i=1:length(STITimeTicks)
        line([STITimeTicks(i) STITimeTicks(i)],STITicksLoc,'Color','k');
    end
    line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k','LineStyle','--');
end

% plot puff
if str2num(FrameNo1)*str2num(FrameNo2)
    PuffStartTime=str2num(FrameNo1);
    PuffEndTime=str2num(FrameNo2);
        
    myX=[PuffStartTime PuffStartTime PuffEndTime PuffEndTime];
    myY=[mylim(1) mylim(2) mylim(2) mylim(1)];
    p=patch(myX,myY,'m');
    set(p,'FaceAlpha',0.5);   
end



% --- Executes on button press in popout3.
function popout3_Callback(hObject, eventdata, handles)
global STITimeTicks vesselcount presetcolor fig3_waves  FrameTime FFST FrameNo1 FrameNo2 myTimeTicks ResStT3 ResStLoc3;
global CutFrameNum1 CutFrameNum2 LegendAll;

%%% STI RESPONSE VARIABLES
    ResStT50=zeros(1,vesselcount);
    ResStLoc50=zeros(1,vesselcount);
    ResPeakTime=zeros(1,vesselcount);
    ResPeakLoc=zeros(1,vesselcount);
    
    ResConsTimePN50=zeros(1,vesselcount);
    ResConsLocPN50=zeros(1,vesselcount);
    ResConsTimeP50=zeros(1,vesselcount);
    ResConsLocP50=zeros(1,vesselcount);
    ResNegPeakTime=zeros(1,vesselcount);
    ResNegPeakLoc=zeros(1,vesselcount);
    ResBackToBaselineTime=zeros(1,vesselcount);
    AUCLast1min_STI=zeros(1,vesselcount);
    
%%% PUFF RESPONSE VARIABLES   
    NegPeakTime=zeros(1,vesselcount); 
    NegPeakAmp=zeros(1,vesselcount);   
    NegHalfPeakTime=zeros(1,vesselcount);  
    HalfPeakLoc=zeros(1,vesselcount);  
    NegStartTime=zeros(1,vesselcount);    
    NegSlope=zeros(1,vesselcount);
    xx_cf=zeros(5,vesselcount);
    yy_cf=zeros(5,vesselcount);
    AUCLast1min=zeros(1,vesselcount);


hd13=figure(13);
hold on;
for i=1:vesselcount
    wavetemp=fig3_waves(i,CutFrameNum1:CutFrameNum2);
%     wavetemp=smooth(wavetemp,3);
%     wavetemp=smooth(wavetemp,7);
%     wavetemp=smooth(wavetemp,9);
    plot(myTimeTicks(CutFrameNum1:CutFrameNum2),wavetemp,'Color',presetcolor{i},'LineWidth',2);
%     if length(STITimeTicks)~=0
%         [ResStT50(i),ResStLoc50(i),ResPeakTime(i),ResPeakLoc(i),ResConsTimePN50(i), ResConsLocPN50(i), ResConsTimeP50(i), ResConsLocP50(i), ResNegPeakTime(i), ResNegPeakLoc(i) ResBackToBaselineTime(i) AUCLast1min_STI(i)]=ResponseStartTime50P_5(fig3_waves(i,:));  %response start time
%     end
%     if str2num(FrameNo1)~=0
%         [NegPeakTime(i) NegPeakAmp(i) NegHalfPeakTime(i) NegStartTime(i) HalfPeakLoc(i) NegSlope(i) xx_cf(:,i) yy_cf(:,i) AUCLast1min(i)]=ET1PuffPeakFinder2(fig3_waves(i,:),FrameNo1,FrameNo2);
%     end
    
end
title('\fontsize{18}Normalized individual ROI responses');
xlabel('\fontsize{16}Time (s)');
ylabel('\fontsize{16}Relative diameter change');
set(gca,'Fontsize',15);

mylim=get(gca,'ylim');
STITicksLoc=[mylim(2)-0.03*(mylim(2)-mylim(1)) mylim(2)];
if length(STITimeTicks)>=1
    for i=1:length(STITimeTicks)
        line([STITimeTicks(i) STITimeTicks(i)],STITicksLoc,'Color','k');
    end
    line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k','LineStyle','--');
end

% plot puff
if str2num(FrameNo1)*str2num(FrameNo2)
    PuffStartTime=str2num(FrameNo1);
    PuffEndTime=str2num(FrameNo2);
        
    myX=[PuffStartTime PuffStartTime PuffEndTime PuffEndTime];
    myY=[mylim(1) mylim(2) mylim(2) mylim(1)];
    p=patch(myX,myY,'m');
    set(p,'FaceAlpha',0.5);   
end

% % plot the response start time
% for i=1:vesselcount
%     if ResStT50(i)
%         line([ResStT50(i) ResStT50(i)],[ResStLoc50(i)-0.1*(mylim(2)-mylim(1)) ResStLoc50(i)+0.1*(mylim(2)-mylim(1))],'Color',presetcolor{i},'LineWidth',2);
%     end
%     if ResConsTimePN50(i)
%         line([ResConsTimePN50(i) ResConsTimePN50(i)],[ResConsLocPN50(i)-0.1*(mylim(2)-mylim(1)) ResConsLocPN50(i)+0.1*(mylim(2)-mylim(1))],'Color',presetcolor{i},'LineWidth',2,'LineStyle','-.');
%     end
%     if ResConsTimeP50(i)
%         line([ResConsTimeP50(i) ResConsTimeP50(i)],[ResConsLocP50(i)-0.1*(mylim(2)-mylim(1)) ResConsLocP50(i)+0.1*(mylim(2)-mylim(1))],'Color',presetcolor{i},'LineWidth',2,'LineStyle','--');
%     end
%     end
%     
%     % plot puff related peak
% if str2num(FrameNo1)*str2num(FrameNo2)
%     for i=1:vesselcount
%         plot([NegPeakTime(i) NegPeakTime(i)],[NegPeakAmp(i) NegPeakAmp(i)],'Color',presetcolor{i},'Marker','*','MarkerSize',8);
%         plot([NegHalfPeakTime(i) NegHalfPeakTime(i)],[HalfPeakLoc(i)-0.2 HalfPeakLoc(i)+0.2],'Color',presetcolor{i},'LineStyle','--');
%         plot(xx_cf(:,i),yy_cf(:,i),'Color',presetcolor{i},'LineStyle','-');  
%     end
% end
    
ROIfilenames=LegendAll(1:vesselcount); 
legend(ROIfilenames);


% --- Executes on button press in popout4.
function popout4_Callback(hObject, eventdata, handles)
global STITimeTicks presetcolor vesselcount fig4_waves FrameTime FFST FrameNo1 FrameNo2 myTimeTicks ResStT4 ResStLoc4 NoiseAllow CutFrameNum1 CutFrameNum2 LocNameAll ROINoPerCap;

ROINoCaptemp=mean(ROINoPerCap,2);
BarNum=0;
for jj=1:length(ROINoCaptemp)
    if ROINoCaptemp(jj) 
        BarNum=BarNum+1;
    end
end
    
%%%%%%%%%%%%%%%%
%%% STI RESPONSE VARIABLES
    ResStT50_CapOrder=zeros(1,BarNum);
    ResStLoc50_CapOrder=zeros(1,BarNum);
    ResPeakTime_CapOrder=zeros(1,BarNum);
    ResPeakLoc_CapOrder=zeros(1,BarNum); 
    
    ResConsTimePN50_CapOrder=zeros(1,BarNum);
    ResConsLocPN50_CapOrder=zeros(1,BarNum);
    ResConsTimeP50_CapOrder=zeros(1,BarNum);
    ResConsLocP50_CapOrder=zeros(1,BarNum);
    ResNegPeakTime_CapOrder=zeros(1,BarNum);
    ResNegPeakLoc_CapOrder=zeros(1,BarNum);
    ResBackToBaselineTime_CapOrder=zeros(1,BarNum);
    AUCLast1min_STI_CapOrder=zeros(1,BarNum);
    
%%% PUFF RESPONSE VARIABLES   
    NegPeakTime_CapOrder=zeros(1,BarNum); 
    NegPeakAmp_CapOrder=zeros(1,BarNum);   
    NegHalfPeakTime_CapOrder=zeros(1,BarNum);  
    HalfPeakLoc_CapOrder=zeros(1,BarNum);  
    NegStartTime_CapOrder=zeros(1,BarNum);    
    NegSlope_CapOrder=zeros(1,BarNum);
    xx_cf_CapOrder=zeros(5,BarNum);
    yy_cf_CapOrder=zeros(5,BarNum);
    AUCLast1min_CapOrder=zeros(1,BarNum);


figure(14);
hold on;

ColorCollection='rbgymck';


for jj=1:BarNum
    plot(myTimeTicks(CutFrameNum1:CutFrameNum2),fig4_waves(jj,CutFrameNum1:CutFrameNum2),ColorCollection(jj),'LineWidth',2);
%     if length(STITimeTicks)~=0
%         [ResStT50_CapOrder(jj),ResStLoc50_CapOrder(jj),ResPeakTime_CapOrder(jj),ResPeakLoc_CapOrder(jj),ResConsTimePN50_CapOrder(jj), ResConsLocPN50_CapOrder(jj), ResConsTimeP50_CapOrder(jj), ResConsLocP50_CapOrder(jj), ResNegPeakTime_CapOrder(jj), ResNegPeakLoc_CapOrder(jj) ResBackToBaselineTime_CapOrder(jj) AUCLast1min_STI_CapOrder(jj)]=ResponseStartTime50P_5(fig3_waves(jj,:));  %response start time
%     end
%     if str2num(FrameNo1)~=0
%         [NegPeakTime_CapOrder(jj) NegPeakAmp_CapOrder(jj) NegHalfPeakTime_CapOrder(jj) NegStartTime_CapOrder(jj) HalfPeakLoc_CapOrder(jj) NegSlope_CapOrder(jj) xx_cf_CapOrder(:,jj) yy_cf_CapOrder(:,jj) AUCLast1min_CapOrder(jj)]=ET1PuffPeakFinder2(fig3_waves(jj,:),FrameNo1,FrameNo2);
%     end
end
title('\fontsize{18}Each cap order response');
xlabel('\fontsize{16}Time (s)');
ylabel('\fontsize{16}Relative diameter change');
set(gca,'Fontsize',15);
    
ylim('auto');
mylim=get(gca,'ylim');

if length(STITimeTicks)
  
    hdl_STI3=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
end
if str2num(FrameNo1)*str2num(FrameNo2)
    PuffStartTime=str2num(FrameNo1);
    PuffEndTime=str2num(FrameNo2);
    hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
    hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
end
ylim(mylim);
    

% plot the response start time
    for i=1:BarNum
%         if ResStT50(i)
%             line([ResStT50_CapOrder(i) ResStT50_CapOrder(i)],[ResStLoc50_CapOrder(i)-0.1*(mylim(2)-mylim(1)) ResStLoc50_CapOrder(i)+0.1*(mylim(2)-mylim(1))],'Color',ColorCollection(i),'LineWidth',2);
%         end
%         if ResConsTimePN50(i)
%             line([ResConsTimePN50_CapOrder(i) ResConsTimePN50_CapOrder(i)],[ResConsLocPN50_CapOrder(i)-0.1*(mylim(2)-mylim(1)) ResConsLocPN50_CapOrder(i)+0.1*(mylim(2)-mylim(1))],'Color',ColorCollection(i),'LineWidth',2,'LineStyle','-.');
%         end
%         if ResConsTimeP50(i)
%             line([ResConsTimeP50_CapOrder(i) ResConsTimeP50_CapOrder(i)],[ResConsLocP50_CapOrder(i)-0.1*(mylim(2)-mylim(1)) ResConsLocP50_CapOrder(i)+0.1*(mylim(2)-mylim(1))],'Color',ColorCollection(i),'LineWidth',2,'LineStyle','--');
%         end
    end
    
% plot puff related peak
%     if str2num(FrameNo1)*str2num(FrameNo2)
%         for i=1:BarNum
%             plot([NegPeakTime_CapOrder(i) NegPeakTime_CapOrder(i)],[NegPeakAmp_CapOrder(i) NegPeakAmp_CapOrder(i)],'Color',ColorCollection(i),'Marker','*','MarkerSize',8);
%             plot([NegHalfPeakTime_CapOrder(i) NegHalfPeakTime_CapOrder(i)],[HalfPeakLoc_CapOrder(i)-0.2 HalfPeakLoc_CapOrder(i)+0.2],'Color',ColorCollection(i),'LineStyle','--');
%             plot(xx_cf_CapOrder(:,i),yy_cf_CapOrder(:,i),'Color',ColorCollection(i),'LineStyle','-');  
%         end
%     end
    
    ROIfilenames=LocNameAll(1:BarNum); 
    legend(ROIfilenames);
    
    
% --- Executes on button press in popout5.
function popout5_Callback(hObject, eventdata, handles)
global Wave_Measure LocNameAll ColorCollection fig4_waves;

figure(15);
hold on;

BarNum=size(fig4_waves,1);

hbar=bar(Wave_Measure(:,1:2).');
for j=1:BarNum
    set(hbar(j),'FaceColor',ColorCollection(j));
    set(hbar(j),'EdgeColor',ColorCollection(j));
end
set(hbar,'BarWidth',1);    % The bars will now touch each other
set(gca,'GridLineStyle','-');
set(gca,'XTick',[1 2]);
xticklabels({'Dilation Peak','Constriction Peak'});
title('\fontsize{10}Dilation and constriction peak at each order');
set(get(gca,'YLabel'),'String','Diameter change (%)','FontSize',10);
set(gca,'FontSize',10);
q = char(39);legendcommand=['lh=legend(',q];
for j=1:BarNum
    if j<BarNum
        legendcommand=[legendcommand,LocNameAll{j},q,',',q];
    else
        legendcommand=[legendcommand,LocNameAll{j},q,');'];
    end
end
eval(legendcommand);
set(lh,'Location','NorthEast');
hold on;
box off;



function ForPuffing_SelectionChangeFcn(hObject, eventdata, handles)
global FrameNo1 FrameNo2 hdl_11 hdl_12 hdl_21 hdl_22 hdl_31 hdl_32 hdl_41 hdl_42;
% get the selection for the button group
puffhd =  get(handles.ForPuffing,'SelectedObject');
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
            set(hdl_41,'Visible','off');
            set(hdl_42,'Visible','off');
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
            set(hdl_41,'Visible','on');
            set(hdl_42,'Visible','on');
        end
        
end

        


function updatepuff_Callback(hObject, eventdata, handles)
global BaseLineFrameNo myDIs FrameTime FFST fig2_waves fig3_hds fig3_waves fig4_hds fig4_waves fig5_hds fig5_waves 
global vesselcount myTimeTicks presetcolor STITimeTicks hdl_11 hdl_12 hdl_21 hdl_22 hdl_31 hdl_32 hdl_41 hdl_42;
global FrameNo1 FrameNo2 CutFrameNum1 CutFrameNum2 handlesaxes4 ROINoPerCap hdl_STI3 handlesaxes5 LocNameAll PuffStartTime PuffEndTime;
global Wave_Measure PuffTimeNo1 PuffTimeNo2 fig2_waves_raw;


% Update BaseLineFrameNo if there's only a puff
PuffTimeNo1=str2num(get(handles.FrameNo1,'String'));
PuffTimeNo2=str2num(get(handles.FrameNo2,'String'));

tI=find(myTimeTicks<PuffTimeNo1);
FrameNo1=num2str(tI(end));

tI=find(myTimeTicks<PuffTimeNo2);
FrameNo2=num2str(tI(end));


BaseLineFrameNo=str2num(FrameNo1);



% Update the axes3 and axes4 if there's only puffing, and BaseLineFrameNo
% is changed
if str2num(FrameNo1)*size(fig2_waves)
    
  
    
    if ~isempty(fig3_hds)
        for i=1:vesselcount
            eval(['try delete(fig3_hds(',num2str(i),'));end']);
        end
    end
    fig3_hds=[];
    fig3_waves=[];
    fig4_waves=[];
    fig5_waves=[];
    
    
    if str2num(FrameNo1)*str2num(FrameNo2)
        PuffStartTime=PuffTimeNo1;
        PuffEndTime=PuffTimeNo2;
    end
    
    if vesselcount>=1 && ~isempty(fig2_waves)
        
        axes(handles.axes2);
        mylim=get(gca,'ylim');
        hdl_21=line([PuffStartTime PuffStartTime],mylim,'Color','m');
        hdl_22=line([PuffEndTime PuffEndTime],mylim,'Color','m');
    
        axes(handles.axes3);cla;
        for i=1:vesselcount
          
            CellIOT=fig2_waves(i,:);hold on;
        
            % Plot normalized (1) intensity over time in middle right subplot 
            V3=CellIOT./mean(CellIOT(CutFrameNum1:BaseLineFrameNo));    % first frame is not good because of warm up
            
            hd3=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),V3(CutFrameNum1:CutFrameNum2),'Color',presetcolor{i},'LineWidth',2);
            title('\fontsize{12}Normalized Diameter Change');
            ylim('auto');
            mylim=get(gca,'ylim');
            if length(STITimeTicks)
                
                hdl_STI2=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
            end
            if str2num(FrameNo1)*str2num(FrameNo2)
                hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
                hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
            end
            fig3_hds=[fig3_hds hd3];
            fig3_waves=[fig3_waves;V3];
            
          
            
        end
        
            ROINoCaptemp=mean(ROINoPerCap,2);
            BarNum=0;
            for j=1:length(ROINoCaptemp)
                if ROINoCaptemp(j) 
                    BarNum=BarNum+1;
                end
            end
            % figure 4
            axes(handlesaxes4);hold on;
            cla;
            Mean_Waves=zeros(BarNum,size(fig3_waves,2));
            ColorCollection='rbgymck';
            for j=1:BarNum
                Mean_Waves(j,:)=mean(fig3_waves(ROINoPerCap(j,1):ROINoPerCap(j,2),:),1);
                plot(myTimeTicks(CutFrameNum1:CutFrameNum2),Mean_Waves(j,CutFrameNum1:CutFrameNum2),ColorCollection(j),'LineWidth',2);
            end
            title('\fontsize{10}Mean curves at each order');
            xlabel('\fontsize{10}Time (s)');
            ylim('auto');
            mylim=get(gca,'ylim');
            if length(STITimeTicks)
                hdl_STI3=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
            end
            if str2num(FrameNo1)*str2num(FrameNo2)
                hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
                hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
            end
    
            ylim(mylim);
            fig4_waves=Mean_Waves;
    
    
            % Plot amplitude and mean area under curve at each order capillary
            Wave_Measure=zeros(BarNum,2); % 1st row is peak amp, 2nd row is AUC of the last 1 minutes
            
            % if length(STITimeTicks)
            %     for j=1:BarNum
            %         [~,~,~,Wave_Measure(j,1),~,~,~,~,~,~,~, Wave_Measure(j,2)]=ResponseStartTime50P_5(fig4_waves(j,:));  %response start time
            % 
            %     end
            % end
            % 
            % if str2num(FrameNo1)*str2num(FrameNo2)
            %     for jj=1:BarNum
            %         [~, ~, ~, Wave_Measure(jj,1), ~, ~, ~, ~, ~, Wave_Measure(jj,2), ~]=AirPuffPeakFinder(fig4_waves(jj,:),FrameNo1,FrameNo2);
            %     end
            % end
            
            Wave_Measure=(Wave_Measure-1)*100;

            %%%%% plot
            axes(handlesaxes5);
            cla;
            hbar=bar(Wave_Measure(:,1:2).');
            for j=1:BarNum
                set(hbar(j),'FaceColor',ColorCollection(j));
                set(hbar(j),'EdgeColor',ColorCollection(j));
%               hbar(j).FaceColor = ColorCollection(j);
%               hbar(j).EdgeColor = ColorCollection(j);
            end
            set(hbar,'BarWidth',1);    % The bars will now touch each other
            set(gca,'GridLineStyle','-');
            set(gca,'XTick',[1 2]);
            xticklabels({'Dilation Peak','Constriction Peak'});
            title('\fontsize{10}Dilation and constriction peak at each order');
            set(get(gca,'YLabel'),'String','Diameter change (%)','FontSize',10);
            set(gca,'FontSize',10);
            q = char(39);legendcommand=strcat('lh = legend(',q);
            for j=1:BarNum
                if j<BarNum
                    legendcommand=strcat(legendcommand,LocNameAll{j},q,',',q);
                else
                    legendcommand=strcat(legendcommand,LocNameAll{j},q,');');
                end
            end
            eval(legendcommand);
            set(lh,'Location','NorthEast');
            hold on;
            box off;
            ylim auto;
            fig5_waves=Wave_Measure;
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
if str2num(FrameNo1)*str2num(FrameNo2)
        axes(handles.axes2);mylim=get(gca,'ylim');
        hdl_11=line([PuffStartTime PuffStartTime],mylim,'Color','m');
        hdl_12=line([PuffEndTime PuffEndTime],mylim,'Color','m');
        axes(handles.axes3);mylim=get(gca,'ylim');
        hdl_21=line([PuffStartTime PuffStartTime],mylim,'Color','m');
        hdl_22=line([PuffEndTime PuffEndTime],mylim,'Color','m');
        axes(handles.axes4);mylim=get(gca,'ylim');
        hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
        hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes during object creation, after setting all properties.
function FrameNo1_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function FrameNo1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FrameNo2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function FrameNo2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ReferCh.
function ReferCh_Callback(hObject, eventdata, handles)
% hObject    handle to ReferCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ReferCh contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ReferCh


% --- Executes during object creation, after setting all properties.
function ReferCh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReferCh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WinSize_Callback(hObject, eventdata, handles)
% hObject    handle to WinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WinSize as text
%        str2double(get(hObject,'String')) returns contents of WinSize as a double


% --- Executes during object creation, after setting all properties.
function WinSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OpenSlider.
function OpenSlider_Callback(hObject, eventdata, handles)
VesselDiameter_VideoSlider;

function pushbutton10_Callback(hObject, eventdata, handles)



function HalfWinSize_Callback(hObject, eventdata, handles)
% hObject    handle to HalfWinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HalfWinSize as text
%        str2double(get(hObject,'String')) returns contents of HalfWinSize as a double


% --- Executes during object creation, after setting all properties.
function HalfWinSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HalfWinSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in SaveRoi.
function SaveRoi_Callback(hObject, eventdata, handles)
VesselDiameter_SavingROIs;


% --- Executes on button press in LoadRoi.
function LoadRoi_Callback(hObject, eventdata, handles)
global avgFrame fig2_waves fig3_waves fig4_waves fig5_waves fig5_hds ROIPosAll PuffExist;
global ROIs text_hds fig2_hds fig3_hds fig4_hds vesselcount hdl_STI1 hdl_STI2 hdl_STI3 hdl_STI4;
global myTimeTicks FrameNum useNew myVideo_New myVideo hdl_11 hdl_12 hdl_21 hdl_22 hdl_31 hdl_32 hdl_41 hdl_42;
global FrameNo1 FrameNo2  presetcolor LocNumAll LocColorAll LocNameAll LegendAll hROIsRect;
global CutFrameNum1 CutFrameNum2 CutTime1 CutTime2 ROI_Geo_Distance ROIWidthAll FiletoStudy;
global RedImg GreenImg RestitchCord CutImageCord1 CutImageCord2;

[ROIFileName,ROIPathName] = uigetfile('*.mat','Select the ROI info file');
avgFrame_Pre=load([ROIPathName,ROIFileName],'avgFrame');
avgFrame_Pre=avgFrame_Pre.avgFrame;
myTimeTicks_Pre=load([ROIPathName,ROIFileName],'myTimeTicks');
myTimeTicks_Pre=myTimeTicks_Pre.myTimeTicks;


if ~isequal(myTimeTicks_Pre,myTimeTicks)
    warndlg('The data and result are not matched! QUIT the loading!','Warning');
else
    
    if ~isequal(avgFrame_Pre,avgFrame)    
        hd_hd=helpdlg('Re-reading the orignal data','Please wait');
        RedImg=get(mestaghandle(FiletoStudy), 1, 'IMAGE');
        GreenImg=get(mestaghandle(FiletoStudy), 2, 'IMAGE');
        FFI=get(mestaghandle(FiletoStudy), 1, 'FoldedFrameInfo');
        FrameTime=FFI.frameTimeLength;    
        FFST=FFI.firstFrameStartTime;
        FrameHeight=FFI.numFrameLines;
        
        % check if there's any 4D images
        try Info4D=get(mestaghandle(FiletoStudy), 1, 'info_D4scan');end
        if length(Info4D)
            PlaneDistance=Info4D.distance;
            PlanePerStack=Info4D.planes;
    
            FrameTime=FrameTime*PlanePerStack;
    
            HeightPixNum=get(mestaghandle(FiletoStudy), 1, 'TransversePixNum');
            HeightStep=get(mestaghandle(FiletoStudy), 1, 'TransverseStep');
    
            WidthPixNum=get(mestaghandle(FiletoStudy), 1, 'Width');
            WidthStep=get(mestaghandle(FiletoStudy), 1, 'WidthStep');
        else
            
            helpdlg('This is not 4D recordings','Warning');
            pause;
        end
        
        RedImg = imadjust(RedImg(1:WidthPixNum,:));
        GreenImg=imadjust(GreenImg(1:WidthPixNum,:));
        
        %%% get the average image and image stack of ChFI of all frames 
        avgFrame=zeros(WidthPixNum,HeightPixNum);
        myVideo=zeros(WidthPixNum,HeightPixNum,FrameNum);
        
        for i=1:FrameNum
            eachStack=double(GreenImg(:,(i-1)*HeightPixNum*PlanePerStack+1:i*HeightPixNum*PlanePerStack));
            eachStack=reshape(eachStack,[WidthPixNum HeightPixNum PlanePerStack]);
            eachFrame = max(eachStack, [], 3);
            avgFrame=avgFrame+eachFrame;      
            myVideo(:,:,i)=eachFrame;
    
        end
        avgFrame=avgFrame/FrameNum;
        

        if RestitchCord
            XCut=RestitchCord;
            
            temp=avgFrame(1:XCut,:);
            avgFrame(1:end-XCut,:)=avgFrame(XCut+1:end,:);
            avgFrame(end-XCut+1:end,:)=temp;
        
            temp=myVideo(1:XCut,:,:);
            myVideo(1:end-XCut,:,:)=myVideo(XCut+1:end,:,:);
            myVideo(end-XCut+1:end,:,:)=temp;
        
            XCut=round(xp);
            temp=RedImg(1:XCut,:);
            RedImg(1:end-XCut,:)=RedImg(XCut+1:end,:);
            RedImg(end-XCut+1:end,:)=temp;
        
            XCut=round(xp);
            temp=GreenImg(1:XCut,:);
            GreenImg(1:end-XCut,:)=GreenImg(XCut+1:end,:);
            GreenImg(end-XCut+1:end,:)=temp;
        end
        
        if CutImageCord1*CutImageCord2
            xp1=CutImageCord1;
            xp2=CutImageCord2;
            
            avgFrame(round(xp2):end,:)=[];
            avgFrame(1:round(xp1),:)=[];
    
            myVideo(round(xp2):end,:,:)=[];
            myVideo(1:round(xp1),:,:)=[];
    
            RedImg(round(xp2):end,:)=[];
            RedImg(1:round(xp1),:)=[];
    
            GreenImg(round(xp2):end,:)=[];
            GreenImg(1:round(xp1),:)=[];
        end
        
        myVideo_New=myVideo;
        
        cla(handles.axes1);
        axes(handles.axes1);
        h_avgFrame_3Ch=imagesc(avgFrame_Pre.');
        axis image;
        axis off;
               
        
        close(hd_hd);
        
    else
        cla(handles.axes1);
        axes(handles.axes1);
        h_avgFrame_3Ch=imagesc(avgFrame.');
        axis image;
        axis off;
    end
    
    cla(handles.axes2);
    cla(handles.axes3);
    cla(handles.axes4);
    cla(handles.axes5);
    
    %%% load the data
    load([ROIPathName,ROIFileName]);
    ROIs=[];text_hds=[];fig2_hds=[];fig3_hds=[];fig4_hds=[];fig5_hds=[];
    hdl_11=[];hdl_12=[];hdl_21=[];hdl_22=[];hdl_31=[];hdl_32=[];hdl_41=[];hdl_42=[];
    hROIsRect=[];
    
    %%% The followings parameters are not necessary existing because of the
    %%% program version.
    try
        CutFrameNum10=load([ROIPathName,ROIFileName],'CutFrameNum1');
        CutFrameNum1=CutFrameNum10.CutFrameNum1;
        CutFrameNum20=load([ROIPathName,ROIFileName],'CutFrameNum2');
        CutFrameNum2=CutFrameNum20.CutFrameNum2;
        CutTime10=load([ROIPathName,ROIFileName],'CutTime1');
        CutTime1=CutTime10.CutTime1;
        CutTime20=load([ROIPathName,ROIFileName],'CutTime2');
        CutTime2=CutTime20.CutTime2;
    catch
        CutFrameNum1=2;
        CutFrameNum2=length(myTimeTicks);
        CutTime1=round(myTimeTicks(2));
        CutTime2=round(myTimeTicks(end));
    end
    
    %%% reset the ROI naming system
    for jj=1:7
        eval(['set(handles.Loc',num2str(jj),'Num,',char(39),'String',char(39),',num2str(LocNumAll(jj)));']);
        eval(['set(handles.Loc',num2str(jj),'Color,',char(39),'String',char(39),',LocColorAll(jj));']);
        eval(['set(handles.Loc',num2str(jj),',',char(39),'String',char(39),',LocNameAll{jj});']);
    end
    
    %%% update the Time Cutting Range
    set(handles.CutTime01,'String',num2str(CutTime1));
    set(handles.CutTime02,'String',num2str(CutTime2));
    
    %%% check the puff
    if PuffExist==1
        set(handles.fn,'Enable','on');
        set(handles.FrameNo1,'String',FrameNo1);
        set(handles.FrameNo2,'Enable','on');
        set(handles.FrameNo2,'String',FrameNo2);
        set(handles.slash,'Enable','on');
        set(handles.updatepuff,'Enable','on');
        set(handles.FrameNo1,'String',FrameNo1);
        set(handles.FrameNo2,'String',FrameNo2);
        set(handles.ForPuffing,'selectedobject',handles.yespuff);
    else
        set(handles.FrameNo1,'String',FrameNo1);
        set(handles.FrameNo2,'String',FrameNo2);

    end
    
    
    %%% replot the ROIs and curves
    for i=1:vesselcount
        
        ROIpos=ROIPosAll{i};
        
        axes(handles.axes1);hold on;
        hh=line(ROIpos(:,1),ROIpos(:,2),'Color',presetcolor{i},'LineWidth',2);
        ROIs=[ROIs hh];
        
        
        % Mark the index of the ROI in the image
        [m,ii]=min(ROIpos(:,2));
        MposX=ROIpos(ii,1);
        MposY=ROIpos(ii,2);
        thd=text(MposX,MposY,['r',int2str(i)],'color',presetcolor{i},'Fontsize',12);
        text_hds=[text_hds thd];
        clear m ii;
        
        % find the four corner points of the square
        SquareCornerMarks=FindSquareCorner(ROIpos(1,:),ROIpos(2,:),ROIWidthAll(i));
        hRecTemp=zeros(1,4);
        hRecTemp(1)=line(SquareCornerMarks(1:2,1),SquareCornerMarks(1:2,2),'Color',presetcolor{i},'LineWidth',1);
        hRecTemp(2)=line(SquareCornerMarks(2:3,1),SquareCornerMarks(2:3,2),'Color',presetcolor{i},'LineWidth',1);
        hRecTemp(3)=line(SquareCornerMarks(3:4,1),SquareCornerMarks(3:4,2),'Color',presetcolor{i},'LineWidth',1);
        hRecTemp(4)=line([SquareCornerMarks(1,1) SquareCornerMarks(4,1)],[SquareCornerMarks(1,2) SquareCornerMarks(4,2)],'Color',presetcolor{i},'LineWidth',1);
        hROIsRect=[hROIsRect;hRecTemp];
        
        
        
        %%%%%%figure 2
        axes(handles.axes2);hold on;
        hd2=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),fig2_waves(i,CutFrameNum1:CutFrameNum2),'Color',presetcolor{i});
        title('\fontsize{12}Raw Diameter');
        ylabel('\fontsize{10}Diameter(um)');
        fig2_hds=[fig2_hds hd2];
        
        %%%%%% figure3
        axes(handles.axes3);hold on;
        hd3=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),fig3_waves(i,CutFrameNum1:CutFrameNum2),'Color',presetcolor{i},'LineWidth',2);
        title('\fontsize{12}Normalized Diameter Change');
        fig3_hds=[fig3_hds hd3];
        
        %%%%%% figure4
        axes(handles.axes4);hold on;
        hd4=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),fig4_waves(i,CutFrameNum1:CutFrameNum2),'Color',presetcolor{i},'LineWidth',2);
        title('\fontsize{12}Normalized Vessel Resistance');
        fig4_hds=[fig4_hds hd4];
        
        %%%%%% figure5
        axes(handles.axes4);hold on;
        hd5=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),fig5_waves(i,CutFrameNum1:CutFrameNum2),'Color',presetcolor{i},'LineWidth',2);
        title('\fontsize{12}Normalized Vessel Compliance');
        fig5_hds=[fig5_hds hd5];
        
        
    end
    
    % plot the lines for puffing if any
    if str2num(FrameNo1)*str2num(FrameNo2)
        PuffStartTime=((str2num(FrameNo1)-2)*FrameTime+FFST)/1000;
        PuffEndTime=((str2num(FrameNo2)-1)*FrameTime+FFST)/1000;
        axes(handles.axes2);mylim=get(gca,'ylim');
        hdl_11=line([PuffStartTime PuffStartTime],mylim,'Color','m');
        hdl_12=line([PuffEndTime PuffEndTime],mylim,'Color','m');
        axes(handles.axes3);mylim=get(gca,'ylim');
        hdl_21=line([PuffStartTime PuffStartTime],mylim,'Color','m');
        hdl_22=line([PuffEndTime PuffEndTime],mylim,'Color','m');
        axes(handles.axes4);mylim=get(gca,'ylim');
        hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
        hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
        axes(handles.axes5);mylim=get(gca,'ylim');
        hdl_41=line([PuffStartTime PuffStartTime],mylim,'Color','m');
        hdl_42=line([PuffEndTime PuffEndTime],mylim,'Color','m');
    end
    
    % plot the lines for STI if any
    if length(STITimeTicks)
        axes(handles.axes2);hold on;mylim=get(gca,'ylim');
        hdl_STI1=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
        axes(handles.axes3);hold on;mylim=get(gca,'ylim');
        hdl_STI2=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
        axes(handles.axes4);hold on;mylim=get(gca,'ylim');
        hdl_STI3=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
        axes(handles.axes5);hold on;mylim=get(gca,'ylim');
        hdl_STI4=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
    end
    

end




% --- Executes on button press in UpdateColormaps.
function UpdateColormaps_Callback(hObject, eventdata, handles)
global presetcolor fig2_hds fig3_hds fig4_waves fig5_hds vesselcount ROIs text_hds LegendAll hROIsRect LocNumAll LocColorAll LocNameAll ROINoPerCap;
global STITimeTicks hdl_STI3 hdl_31 hdl_32 handlesaxes4 handlesaxes5 fig3_waves fig5_waves myTimeTicks CutFrameNum1 CutFrameNum2 FrameNo1 FrameNo2 BaseLineFrameNo;
global PuffEndTime PuffStartTime Wave_Measure;

%%%%%%%% reset the presetcolor
ColorCollection='rbgymck';
ColorValCollection=[1 0 0;0 0 1;0 1 0;1 1 0;1 0 1;0 1 1;0.6 0.6 0.6];

LocNumAll=[];
for i=1:7
    eval(['LocNumtemp=get(handles.Loc',int2str(i),'Num,',char(39),'String',char(39),');']);
    if ~isempty(LocNumtemp)
        LocNumAll=[LocNumAll str2num(LocNumtemp)];
    else
        LocNumAll=[LocNumAll 0];
    end
end

LocColorAll=[];
ColorValNew=[];
for i=1:7
    eval(['LocColortemp=get(handles.Loc',int2str(i),'Color,',char(39),'String',char(39),');']);
    if ~isempty(LocColortemp)
        LocColorAll=[LocColorAll LocColortemp];
        I=find(ColorCollection==LocColortemp);
        ColorValNew=[ColorValNew;ColorValCollection(I,:)];
    else
        LocColorAll=[LocColorAll '0'];
        ColorValNew=[ColorValNew;[1 1 1]];
    end
end

LocNameAll=cell(1,7);
for i=1:7
    eval(['LocNametemp=get(handles.Loc',int2str(i),',',char(39),'String',char(39),');']);
    if ~isempty(LocNametemp)
        LocNameAll{i}=LocNametemp;
    else
        LocNameAll{i}=[];
    end
end


presetcolor=cell(1,sum(LocNumAll));
LegendAll=cell(1,sum(LocNumAll));
ROINoPerCap=zeros(7,2);
ColorIndextemp=0;
for i=1:7
    if LocNumAll(i)>0 && LocColorAll(i)~='0' && ~isempty(LocNameAll{i})
        for j=1:LocNumAll(i)

            ColorIndextemp=ColorIndextemp+1;
            presetcolor{ColorIndextemp}=ColorValNew(i,:)*j/LocNumAll(i);
            LegendAll{ColorIndextemp}=[LocNameAll{i},'_',num2str(j)];
            if ColorIndextemp<=vesselcount
                if j==1
                    ROINoPerCap(i,1)=ColorIndextemp;
                    ROINoPerCap(i,2)=ColorIndextemp;
                else
                    ROINoPerCap(i,2)=ColorIndextemp;
                end
            end
        end
    end    
end
while isempty(presetcolor{end})
    presetcolor(end)=[];
    LegendAll(end)=[];
end
clear ColorIndextemp;

%%%%%%%%%%%%
LocNumAll=[str2num(get(handles.Loc1Num,'String')) str2num(get(handles.Loc2Num,'String')) str2num(get(handles.Loc3Num,'String'))...
    str2num(get(handles.Loc4Num,'String')) str2num(get(handles.Loc5Num,'String')) str2num(get(handles.Loc6Num,'String'))...
    str2num(get(handles.Loc7Num,'String'))];

LocColorAll=[get(handles.Loc1Color,'String') get(handles.Loc2Color,'String') get(handles.Loc3Color,'String')...
    get(handles.Loc4Color,'String') get(handles.Loc5Color,'String') get(handles.Loc6Color,'String')...
    get(handles.Loc7Color,'String')];

LocNameAll={get(handles.Loc1,'String') get(handles.Loc2,'String') get(handles.Loc3,'String')...
    get(handles.Loc4,'String') get(handles.Loc5,'String') get(handles.Loc6,'String')...
    get(handles.Loc7,'String')};


%%%%% update the waves
if vesselcount>=1
    for i=1:vesselcount
        try set(fig2_hds(i),'Color',presetcolor{i});end
        try set(fig3_hds(i),'Color',presetcolor{i});end
        
        set(ROIs(i),'Color',presetcolor{i});
        set(text_hds(i),'Color',presetcolor{i});
        for j=1:4
            set(hROIsRect(i,j),'Color',presetcolor{i});
        end
    end
    
    
    ROINoCaptemp=mean(ROINoPerCap,2);
    BarNum=0;
    for j=1:length(ROINoCaptemp)
        if ROINoCaptemp(j) 
            BarNum=BarNum+1;
        end
    end
    
    % figure 4
    axes(handlesaxes4);hold on;
    cla;
    Mean_Waves=zeros(BarNum,size(fig3_waves,2));
    for j=1:BarNum
        Mean_Waves(j,:)=mean(fig3_waves(ROINoPerCap(j,1):ROINoPerCap(j,2),:),1);
        plot(myTimeTicks(CutFrameNum1:CutFrameNum2),Mean_Waves(j,CutFrameNum1:CutFrameNum2),LocColorAll(j),'LineWidth',2);
    end
    title('\fontsize{10}Mean curves at each order');
    xlabel('\fontsize{10}Time (s)');
    ylim('auto');
    mylim=get(gca,'ylim');
    if length(STITimeTicks)
        hdl_STI3=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
    end
    if str2num(FrameNo1)*str2num(FrameNo2)
        hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
        hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
    end
    
    ylim(mylim);
    fig4_waves=Mean_Waves;
    
    
    % figure 5
    Wave_Measure=zeros(BarNum,2); % 1st row is mean amp, 2nd row is mean auc
        
    if length(STITimeTicks)
         for j=1:BarNum
             [~,~,~,Wave_Measure(j,1),~,~,~,~,~,~,~, Wave_Measure(j,2)]=ResponseStartTime50P_5(fig4_waves(j,:));  %response start time

         end
    end

    if str2num(FrameNo1)*str2num(FrameNo2)
        for jj=1:BarNum
            [~, ~, ~, Wave_Measure(jj,1), ~, ~, ~, ~, ~, Wave_Measure(jj,2), ~]=AirPuffPeakFinder(fig4_waves(jj,:),FrameNo1,FrameNo2);
        end
    end
            
    Wave_Measure=(Wave_Measure-1)*100;
 
    axes(handlesaxes5);
    cla;
    hold on;
    hbar=bar(Wave_Measure(:,1:2).');
    for j=1:BarNum
          set(hbar(j),'FaceColor',LocColorAll(j));
          set(hbar(j),'EdgeColor',LocColorAll(j));
    end
    set(hbar,'BarWidth',1);    % The bars will now touch each other
    set(gca,'GridLineStyle','-');
    set(gca,'XTick',[1 2])
    xticklabels({'Dilation Peak','Constriction Peak'});
    title('\fontsize{10}Dilation and constriction peak at each order');
    set(get(gca,'YLabel'),'String','Diameter change (%)','FontSize',10);
    set(gca,'FontSize',10);
    q = char(39);legendcommand=strcat('lh = legend(',q);
    for j=1:BarNum
        if j<BarNum
            legendcommand=strcat(legendcommand,LocNameAll{j},q,',',q);
        else
            legendcommand=strcat(legendcommand,LocNameAll{j},q,');');
        end
    end
    eval(legendcommand);
    set(lh,'Location','NorthEast');
    hold on;
    box off;
    fig5_waves=Wave_Measure;
end






% --- Executes on button press in DrawSkeleton.
function DrawSkeleton_Callback(hObject, eventdata, handles)
global RedImg GreenImg FrameNum  ROIPosAll hd100 SkeletonNum SkeletonLoc SkeletonInfo hSkeleton;
global avgFrame4skl presetcolor HeightPixNum WidthPixNum PlanePerStack avgFrame avgFrame_3Ch avgFrame_3Ch_new useNew;

SkeletonNum=0;
SkeletonLoc=cell(2,10);  % the real location of each point along the skeleton, first column:x, second column:y
SkeletonInfo=cell(2,10);  % the first column is which upper level vessel is connected with the current vessel
                          % the second column is which point in the upper level vessel is connected.
hSkeleton=[];


if get(handles.Ch2Choose, 'Value')==1
%     avgFrame4skl=zeros(size(GreenImg,1),HeightPixNum);
%     for i=2:FrameNum
%         eachStack=double(GreenImg(:,(i-1)*HeightPixNum*PlanePerStack+1:i*HeightPixNum*PlanePerStack));
%         eachStack=reshape(eachStack,[size(eachStack,1) HeightPixNum PlanePerStack]);
%     
%         eachFrame = max(eachStack, [], 3);
%         avgFrame4skl=avgFrame4skl+eachFrame;   
%     
%     end
%     clear eachFrame;
else
%     avgFrame4skl=zeros(size(RedImg,1),HeightPixNum);
%     for i=2:FrameNum
%         eachStack=double(RedImg(:,(i-1)*HeightPixNum*PlanePerStack+1:i*HeightPixNum*PlanePerStack));
%         eachStack=reshape(eachStack,[size(eachStack,1) HeightPixNum PlanePerStack]);
%     
%         eachFrame = max(eachStack, [], 3);
%         avgFrame4skl=avgFrame4skl+eachFrame;   
%     
%     end
%     avgFrame4skl=avgFrame4skl/(FrameNum-1);
%     clear eachFrame;
end

hd100=figure;hold on;
% set(gcf,'units','normalized','outerposition',[0 0 1 1]);
if useNew
    h_avgFrame2_4Ske=imagesc(avgFrame_3Ch_new(:,:,2));
else
    h_avgFrame2_4Ske=imagesc(avgFrame_3Ch(:,:,2));
end
if get(handles.Ch2Choose, 'Value')==1
    title('Mean of GREEN frames');
else
    title('Mean of RED frames');
end
colormap(gray);
axis image;
axis off;
axis ij;
 
%%% draw the ROIs as well
for i=1:length(ROIPosAll)
    ROIpos=ROIPosAll{i};
    line(ROIpos(:,1),ROIpos(:,2),'Color',presetcolor{i},'LineWidth',2);
end


% prepare the show the axes for mouse click
set(h_avgFrame2_4Ske,'HitTest','off');
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'Visible','on');
hold on;

% set buttons inside
hp=get(hd100,'Position');
% hb1 = uicontrol('String', 'Add', 'Position', [hp(1)-0.2*hp(3) hp(2)-0.9*hp(4) 180 60],'Callback',{@AddSkeleton},'FontSize',16);
% hb2 = uicontrol('String', 'Clear', 'Position', [hp(1)+0.2*hp(3) hp(2)-0.9*hp(4) 180 60],'Callback',{@ClearSkeleton},'FontSize',16);
% hb3 = uicontrol('String', 'Accept!', 'Position', [hp(1)+0.6*hp(3) hp(2)-0.9*hp(4) 180 60],'Callback',{@AcceptSkeleton},'FontSize',16);

hb1 = uicontrol('String', 'Add', 'Position', [160 50 80 40],'Callback',{@AddSkeleton},'FontSize',16);
hb2 = uicontrol('String', 'Clear', 'Position', [260 50 80 40],'Callback',{@ClearSkeleton},'FontSize',16);
hb3 = uicontrol('String', 'Accept!', 'Position', [360 50 80 40],'Callback',{@AcceptSkeleton},'FontSize',16);
        
set(gcf,'units','normalized','outerposition',[0 0 1 1]);       


function AddSkeleton(hObject, eventdata, handles)
global SkeletonNum SkeletonLoc SkeletonInfo hSkeleton;

SkeletonNum=SkeletonNum+1;

%%%%%% input mouse positions
myx=[];
myy=[];
while 1==1
    [tmyx, tmyy, button]=ginput(1);
    if isempty(tmyx) || isempty(button) || button>1
        break
    end
    if ~isempty(myx)
        h=plot([myx(end) tmyx],[myy(end) tmyy],'w','Marker','o','LineWidth',2,'MarkerSize',8);
    else
        h=plot(tmyx,tmyy,'w','Marker','o','MarkerSize',8);
    end
    myx=[myx; tmyx];
    myy=[myy; tmyy];
    hSkeleton=[hSkeleton h];
end



if SkeletonNum==1
    SkeletonLoc{1,1}=myx;
    SkeletonLoc{2,1}=myy;
    SkeletonInfo{1,1}=0;
    SkeletonInfo{2,1}=0;
else
    SkeletonLoc{1,SkeletonNum}=myx;
    SkeletonLoc{2,SkeletonNum}=myy;
    
    %%%
    DisAll=zeros(2,SkeletonNum-1);
    for i=1:SkeletonNum-1
        Loctempx=SkeletonLoc{1,i};
        Loctempy=SkeletonLoc{2,i};
        tempdis=sqrt((Loctempx-myx(1)).^2+(Loctempy-myy(1)).^2);
        [C,I]=min(tempdis);        
        DisAll(1,i)=C;
        DisAll(2,i)=I;
    end
    [C2,I2]=min(DisAll(1,:));
    SkeletonInfo{1,SkeletonNum}=I2;
    SkeletonInfo{2,SkeletonNum}=DisAll(2,I2);
    

end

function ClearSkeleton(hObject, eventdata, handles)
global SkeletonNum SkeletonLoc SkeletonInfo hSkeleton;

SkeletonNum=0;
SkeletonLoc=cell(2,10);  % the real location of each point along the skeleton, first column:x, second column:y
SkeletonInfo=cell(2,10);  % the first column is which upper level vessel is connected with the current vessel
                          % the second column is which point in the upper level vessel is connected.
                          
for i=1:length(hSkeleton)
    delete(hSkeleton(i));
end
hSkeleton=[];

function AcceptSkeleton(hObject, eventdata, handles)
global SkeletonNum hd100 SkeletonExist hSkeleton;

if length(hSkeleton)>=2
    SkeletonExist=2;    % real Skeleton
elseif length(hSkeleton)==1
    SkeletonExist=1;    % If there's only one point, I assumpt it's for plotting the latency/amplitude vs. distance to pipette tip
else
    SkeletonExist=0;
end

try close(hd100);end


% --- Executes on button press in AnalyzeSkeleton.
function AnalyzeSkeleton_Callback(hObject, eventdata, handles)
global ROIPosAll SkeletonNum SkeletonLoc SkeletonInfo HeightStep WidthStep ROI_Geo_Distance PuffPropagationVel SkeletonExist STIPropagationVel CutFrameNum1 CutFrameNum2;

ROI_at_Skeleton=zeros(4,length(ROIPosAll));      % 1st line is which level of skeleton does the ROI locate
                                                 % 2nd line is which number of dots does the ROI locate;
                                                 % 3rd and 4th lines are the center location of ROI;
ROI_Geo_Distance=zeros(1,length(ROIPosAll));    
PuffPropagationVel=zeros(2,6);      % first row: left part of peak, second row: right part of the peak;
                                % first column: PosPeak HalfAmp Latency, unit: um/sec;
                                % second column: NegPeak HalfAmp Latency,unit: um/sec;
                                % third column: Pure NegPeak Latency without PosPeak,unit: um/sec;
                                % forth column: PosPeak FullPeak Amplitude,unit: %/um;
                                % fifth column: NegPeak FullPeak Amplitude with PosPeak,unit: %/um;
                                % sixth column: NegPeak FullPeak Amplitude without PosPeak,unit: %/um;
                             
STIPropagationVel=zeros(2,6);  % first row: left part of peak, second row: right part of the peak
                               % first column: STI half peak latency
                               % second column: STI full peak amplitude
                               % thrid column: Pure Positive peak, falling phase latency;
                               % forth column: Pure negative peak, falling phase amplitude;
                               % fifth column: Positive plus negative peak, falling phase lantecy;
                               % six column: Positive plus negative peak, falling phase amplitude;
                               
                                

if SkeletonExist==2
    for i=1:length(ROIPosAll) 
        % get the individual position out for ROI
        PosNow=ROIPosAll{i};
        Xavg=mean(PosNow(:,1));                                                 % ROIPosAll  [X1 Y1; X2 Y2]
        Yavg=mean(PosNow(:,2));                                                 % ROIPosAll  [X1 Y1; X2 Y2]
        ROI_at_Skeleton(3,i)=Xavg;
        ROI_at_Skeleton(4,i)=Yavg;
    
        %%% find where is the location of ROI in the skeleton
        DisAll=zeros(2,SkeletonNum);
        for j=1:SkeletonNum
            Loctempx=SkeletonLoc{1,j};
            Loctempy=SkeletonLoc{2,j};
            tempdis=sqrt(((Loctempx-Xavg)*HeightStep).^2+((Loctempy-Yavg)*WidthStep).^2);
            [C,I]=min(tempdis);        
            DisAll(1,j)=C;
            DisAll(2,j)=I;
        end
        [C2,I2]=min(DisAll(1,:));
        ROI_at_Skeleton(1,i)=I2;
        ROI_at_Skeleton(2,i)=DisAll(2,I2);
    
        %%% calculate the distance from p.a.
        ROIDisPA_1=0;   % adding up distance
        NowInd_VesselLevel=I2;    % vessellevel in the skeleton
        NowInd_VesselDot=DisAll(2,I2);  % which dot in the local skeleton line

            while NowInd_VesselLevel>=1
                xx0=SkeletonLoc{1,NowInd_VesselLevel};
                yy0=SkeletonLoc{2,NowInd_VesselLevel};
                xx=xx0(1:NowInd_VesselDot);
                yy=yy0(1:NowInd_VesselDot);
                if NowInd_VesselDot>1
                    for j=1:NowInd_VesselDot-1                   
                        ROIDisPA_1 = ROIDisPA_1 + sqrt(((xx(j)-xx(j+1))*HeightStep)^2+(((yy(j)-yy(j+1))*WidthStep)^2));
                    end
                end
            
                x1=xx(1);y1=yy(1);
            
                NowInd_VesselDot=SkeletonInfo{2,NowInd_VesselLevel};
                NowInd_VesselLevel=SkeletonInfo{1,NowInd_VesselLevel};
            
            
                if NowInd_VesselLevel>=1
                    xx0=SkeletonLoc{1,NowInd_VesselLevel};
                    yy0=SkeletonLoc{2,NowInd_VesselLevel};
                    x2=xx0(NowInd_VesselDot);
                    y2=yy0(NowInd_VesselDot);
                    ROIDisPA_1 = ROIDisPA_1 + sqrt(((x2-x1)*HeightStep)^2+(((y2-y1)*WidthStep)^2));
                end
            
            

            end

        ROI_Geo_Distance(i)=ROIDisPA_1;
    
    end  
elseif SkeletonExist==1
    for i=1:length(ROIPosAll) 
        % get the individual position out for ROI
        PosNow=ROIPosAll{i};
        Xavg=mean(PosNow(:,1));                                                 % ROIPosAll  [X1 Y1; X2 Y2]
        Yavg=mean(PosNow(:,2));                                                 % ROIPosAll  [X1 Y1; X2 Y2]
        
        PPLocx=SkeletonLoc{1,1};
        PPLocy=SkeletonLoc{2,1};
        
        ROI_Geo_Distance(i)=sqrt(((Xavg-PPLocx)*HeightStep)^2+((Yavg-PPLocy)*WidthStep)^2);
    end
else
    warndlg('The skeleton of vasculature does not exist','!! Warning !!');
end

%%% sometimes the objective settting in TPM is wrongly set to 5x instead of 25x;
if HeightStep>=0.65     
    ROI_Geo_Distance=ROI_Geo_Distance/5;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% show it in the figures
global FrameNo1 FrameNo2 vesselcount fig3_waves myTimeTicks presetcolor STITimeTicks LegendAll FrameTime FFST hd21 hd31 CutTime2;


%%%% sort the ROI_Geo_Distance in sequence
% [ROI_Geo_DistanceN,NewSeq]=sort(ROI_Geo_Distance);
% fig3_wavesN=fig3_waves(NewSeq,:);
% presetcolorN=presetcolor(NewSeq);

fig3_wavesN=fig3_waves;
presetcolorN=presetcolor;
ROI_Geo_DistanceN=ROI_Geo_Distance;


%%% figure_1: waveforms


%%% STI RESPONSE VARIABLES
    ResStT50=zeros(1,vesselcount);
    ResStLoc50=zeros(1,vesselcount);
    ResPeakTime=zeros(1,vesselcount);
    ResPeakLoc=zeros(1,vesselcount);
    
    ResConsTimePN50=zeros(1,vesselcount);
    ResConsLocPN50=zeros(1,vesselcount);
    ResConsTimeP50=zeros(1,vesselcount);
    ResConsLocP50=zeros(1,vesselcount);
    ResNegPeakTime=zeros(1,vesselcount);
    ResNegPeakLoc=zeros(1,vesselcount);
    ResBackToBaselineTime=zeros(1,vesselcount);
    
    
    
    
    
    
 %%% PUFF RESPONSE VARIABLES   
    NegPeakTime=zeros(1,vesselcount); 
    NegPeakAmp=zeros(1,vesselcount);   
    NegHalfPeakTime=zeros(1,vesselcount);  
    HalfPeakLoc=zeros(1,vesselcount);  
    NegStartTime=zeros(1,vesselcount);    
    NegSlope=zeros(1,vesselcount);
    xx_cf=zeros(5,vesselcount);
    yy_cf=zeros(5,vesselcount);

    
    hd20=figure(20);hold on;
    for i=1:size(fig3_wavesN,1)
        plot(myTimeTicks(CutFrameNum1:CutFrameNum2),fig3_wavesN(i,CutFrameNum1:CutFrameNum2),'Color',presetcolorN{i},'LineWidth',2);
        if length(STITimeTicks)~=0
            [ResStT50(i),ResStLoc50(i),ResPeakTime(i),ResPeakLoc(i),ResConsTimePN50(i), ResConsLocPN50(i), ResConsTimeP50(i), ResConsLocP50(i), ResNegPeakTime(i), ResNegPeakLoc(i), ResBackToBaselineTime(i)]=ResponseStartTime50P_4(fig3_wavesN(i,:));  %response start time   
        
        end
        if str2num(FrameNo1)~=0
            [ResStT50(i), ResStLoc50(i), ResPeakTime(i), ResPeakLoc(i), ResConsTimePN50(i), ResConsLocPN50(i), ResConsTimeP50(i), ResConsLocP50(i), ResNegPeakTime(i), ResNegPeakLoc(i), ResBackToBaselineTime(i)]=AirPuffPeakFinder(fig3_waves(i,:),FrameNo1,FrameNo2);
        end
    
    end
    title('\fontsize{18}Normalized by 1 at baseline');
    xlabel('\fontsize{16}Time (s)');
    ylabel('\fontsize{16}Relative diameter change');
    set(gca,'Fontsize',15);
    
    mylim=get(gca,'ylim');
    STITicksLoc=[mylim(2)-0.03*(mylim(2)-mylim(1)) mylim(2)];
    if length(STITimeTicks)
        for i=1:length(STITimeTicks)
            line([STITimeTicks(i) STITimeTicks(i)],STITicksLoc,'Color','k');
        end
        line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k','LineStyle','--');
    end
    
    % plot puff
    if str2num(FrameNo1)*str2num(FrameNo2)
        PuffStartTime=str2num(FrameNo1);
        PuffEndTime=str2num(FrameNo2);
        
        myX=[PuffStartTime PuffStartTime PuffEndTime PuffEndTime];
        myY=[mylim(1) mylim(2) mylim(2) mylim(1)];
        p=patch(myX,myY,'m');
        set(p,'FaceAlpha',0.5);   
    end
    
    % plot the response start time
    for i=1:vesselcount
        if ResStT50(i)
            line([ResStT50(i) ResStT50(i)],[ResStLoc50(i)-0.1*(mylim(2)-mylim(1)) ResStLoc50(i)+0.1*(mylim(2)-mylim(1))],'Color',presetcolorN{i},'LineWidth',2);
        end
        if ResConsTimePN50(i)
            line([ResConsTimePN50(i) ResConsTimePN50(i)],[ResConsLocPN50(i)-0.1*(mylim(2)-mylim(1)) ResConsLocPN50(i)+0.1*(mylim(2)-mylim(1))],'Color',presetcolorN{i},'LineWidth',2,'LineStyle','-.');
        end
        if ResConsTimeP50(i)
            line([ResConsTimeP50(i) ResConsTimeP50(i)],[ResConsLocP50(i)-0.1*(mylim(2)-mylim(1)) ResConsLocP50(i)+0.1*(mylim(2)-mylim(1))],'Color',presetcolorN{i},'LineWidth',2,'LineStyle','--');
        end
    end
    
%     % plot puff related peak
%     if str2num(FrameNo1)*str2num(FrameNo2)
%         for i=1:vesselcount
%             plot([NegPeakTime(i) NegPeakTime(i)],[NegPeakAmp(i) NegPeakAmp(i)],'Color',presetcolorN{i},'Marker','*','MarkerSize',8);
%             plot([NegHalfPeakTime(i) NegHalfPeakTime(i)],[HalfPeakLoc(i)-0.2 HalfPeakLoc(i)+0.2],'Color',presetcolorN{i},'LineStyle','--');
%             plot(xx_cf(:,i),yy_cf(:,i),'Color',presetcolorN{i},'LineStyle','-');  
%         end
%     end
    
    ROIfilenames=LegendAll(1:vesselcount); 
    legend(ROIfilenames);
    

%%    %%%%%%%%%%%%%%%%%%%%%%%%%%%% figure_2: STI related distribution
if str2num(FrameNo1)*str2num(FrameNo2)
    % plot the parameters related to the distance from p.a.
    hd31=figure(31);hold on;
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    
    for i=1:vesselcount
        if ResStT50(i)
            subplot(2,3,1);hold on;
            plot([ROI_Geo_DistanceN(i) ROI_Geo_DistanceN(i)],[ResStT50(i)-str2num(FrameNo1) ResStT50(i)-str2num(FrameNo1)],...
                'Marker','s',...
                'MarkerSize',10,...
                'LineWidth',2,...
                'MarkerEdgeColor',presetcolorN{i},...
                'MarkerFaceColor',presetcolorN{i});
        end
    end
    set(gca,'FontSize',16);
    xlabel('\fontsize{16}STI Distance from pa (\mum)');
    ylabel('\fontsize{16}Latency (s)');
    title('\fontsize{16}STIPeak HalfAmp Latency');
        % do the curve fitting
        
    % find the neg peak
    [C0,I0]=find((ResStT50-str2num(FrameNo1))>0);
    Full_X=ROI_Geo_DistanceN(I0);
    [Full_X2,II]=sort(Full_X);
    Full_Y=ResStT50(I0)-str2num(FrameNo1);
    Full_Y2=Full_Y(II);
    [MinV,MinI]=min(Full_Y2);
    % left part
    if MinI>1
        LeftPart_Y=Full_Y2(1:MinI);
        LeftPart_X=Full_X2(1:MinI);
        p=polyfit(LeftPart_X,LeftPart_Y,1);
        f = polyval(p,LeftPart_X);
        plot(LeftPart_X,f,'--');
        midX=mean([LeftPart_X(1) LeftPart_X(end)]);
        midY=mean([f(1) f(end)]);
        Velocity=round(abs(1/p(1))*100)/100;
        text(midX,midY,[num2str(Velocity),'\mum/s']);
        STIPropagationVel(1,1)=Velocity;
    end
    % Right part
    if MinI<length(Full_Y2)
        RightPart_Y=Full_Y2(MinI:end);
        RightPart_X=Full_X2(MinI:end);
        p=polyfit(RightPart_X,RightPart_Y,1);
        f = polyval(p,RightPart_X);
        plot(RightPart_X,f,'--');
        midX=mean([RightPart_X(1) RightPart_X(end)]);
        midY=mean([f(1) f(end)]);
        Velocity=round(abs(1/p(1))*100)/100;
        text(midX+1,midY,[num2str(Velocity),'\mum/s']);
        STIPropagationVel(2,1)=Velocity;
    end
    
    
    
%     hd32=figure(32);hold on;
    for i=1:vesselcount
        if ResPeakLoc(i)
            subplot(2,3,4);hold on;
            plot([ROI_Geo_DistanceN(i) ROI_Geo_DistanceN(i)],[(ResPeakLoc(i)-1)*100 (ResPeakLoc(i)-1)*100],...
                'Marker','s',...
                'MarkerSize',10,...
                'LineWidth',2,...
                'MarkerEdgeColor',presetcolorN{i},...
                'MarkerFaceColor',presetcolorN{i});
        end
    end
    set(gca,'FontSize',16);
    xlabel('\fontsize{16}STI Distance from pa (\mum)');
    ylabel('\fontsize{16}Diameter Change (%)');
    title('\fontsize{16}STIPeak FullPeak Amplitude');
    % do the curve fitting
    % find the pos peak
    [C0,I0]=find(ResPeakLoc-1>0);
    Full_X=ROI_Geo_DistanceN(I0);
    [Full_X2,II]=sort(Full_X);
    Full_Y=(ResPeakLoc(I0)-1)*100;
    Full_Y2=Full_Y(II);
    [MaxV,MaxI]=max(Full_Y2);
    % left part
    if MaxI>1
        LeftPart_Y=Full_Y2(1:MaxI);
        LeftPart_X=Full_X2(1:MaxI);
        p=polyfit(LeftPart_X,LeftPart_Y,1);
        f = polyval(p,LeftPart_X);
        plot(LeftPart_X,f,'--');
        midX=mean([LeftPart_X(1) LeftPart_X(end)]);
        midY=mean([f(1) f(end)]);
        Velocity=round(abs(p(1))*100)/100;
        text(midX,midY,[num2str(Velocity),'%/\mum']);
        STIPropagationVel(1,2)=Velocity;
    end
    % Right part
    if MaxI<length(Full_Y2)
        RightPart_Y=Full_Y2(MaxI:end);
        RightPart_X=Full_X2(MaxI:end);
        p=polyfit(RightPart_X,RightPart_Y,1);
        f = polyval(p,RightPart_X);
        plot(RightPart_X,f,'--');
        midX=mean([RightPart_X(1) RightPart_X(end)]);
        midY=mean([f(1) f(end)]);
        Velocity=round(abs(p(1))*100)/100;
        text(midX+1,midY,[num2str(Velocity),'%/\mum']);
        STIPropagationVel(2,2)=Velocity;
    end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:vesselcount
        if ResConsTimeP50(i)
            subplot(2,3,2);hold on;
            plot([ROI_Geo_DistanceN(i) ROI_Geo_DistanceN(i)],[ResConsTimeP50(i)-str2num(FrameNo1) ResConsTimeP50(i)-str2num(FrameNo1)],...
                'Marker','s',...
                'MarkerSize',10,...
                'LineWidth',2,...
                'MarkerEdgeColor',presetcolorN{i},...
                'MarkerFaceColor',presetcolorN{i});
        end
    end
    set(gca,'FontSize',16);
    xlabel('\fontsize{16}STI Distance from pa (\mum)');
    ylabel('\fontsize{16}Latency (s)');
    title('\fontsize{14}STI Falling Phase Latency - P');
    
    % find the neg peak
    [C0,I0]=find((ResConsTimeP50-str2num(FrameNo1))>0);
    Full_X=ROI_Geo_DistanceN(I0);
    [Full_X2,II]=sort(Full_X);
    Full_Y=ResConsTimeP50(I0)-str2num(FrameNo1);
    Full_Y2=Full_Y(II);
    [MinV,MinI]=min(Full_Y2);
    % left part
    if MinI>1
        LeftPart_Y=Full_Y2(1:MinI);
        LeftPart_X=Full_X2(1:MinI);
        p=polyfit(LeftPart_X,LeftPart_Y,1);
        f = polyval(p,LeftPart_X);
        plot(LeftPart_X,f,'--');
        midX=mean([LeftPart_X(1) LeftPart_X(end)]);
        midY=mean([f(1) f(end)]);
        Velocity=round(abs(1/p(1))*100)/100;
        text(midX,midY,[num2str(Velocity),'\mum/s']);
        STIPropagationVel(1,3)=Velocity;
    end
    % Right part
    if MinI<length(Full_Y2)
        RightPart_Y=Full_Y2(MinI:end);
        RightPart_X=Full_X2(MinI:end);
        p=polyfit(RightPart_X,RightPart_Y,1);
        f = polyval(p,RightPart_X);
        plot(RightPart_X,f,'--');
        midX=mean([RightPart_X(1) RightPart_X(end)]);
        midY=mean([f(1) f(end)]);
        Velocity=round(abs(1/p(1))*100)/100;
        text(midX+1,midY,[num2str(Velocity),'\mum/s']);
        STIPropagationVel(2,3)=Velocity;
    end
    
    
    for i=1:vesselcount
        if ResNegPeakLoc(i)
            subplot(2,3,5);hold on;
            plot([ROI_Geo_DistanceN(i) ROI_Geo_DistanceN(i)],[(ResNegPeakLoc(i)-1)*100 (ResNegPeakLoc(i)-1)*100],...
                'Marker','s',...
                'MarkerSize',10,...
                'LineWidth',2,...
                'MarkerEdgeColor',presetcolorN{i},...
                'MarkerFaceColor',presetcolorN{i});
        end
    end
    set(gca,'FontSize',16);
    xlabel('\fontsize{16}STI Distance from pa (\mum)');
    ylabel('\fontsize{16}Diameter Change (%)');
    title('\fontsize{14}STI Pure Neg Peak Amplitude');
    % do the curve fitting
    % find the pos peak
    [C0,I0]=find(ResNegPeakLoc-1>0);
    Full_X=ROI_Geo_DistanceN(I0);
    [Full_X2,II]=sort(Full_X);
    Full_Y=(ResNegPeakLoc(I0)-1)*100;
    Full_Y2=Full_Y(II);
    [MaxV,MaxI]=max(Full_Y2);
    % left part
    if MaxI>1
        LeftPart_Y=Full_Y2(1:MaxI);
        LeftPart_X=Full_X2(1:MaxI);
        p=polyfit(LeftPart_X,LeftPart_Y,1);
        f = polyval(p,LeftPart_X);
        plot(LeftPart_X,f,'--');
        midX=mean([LeftPart_X(1) LeftPart_X(end)]);
        midY=mean([f(1) f(end)]);
        Velocity=round(abs(p(1))*100)/100;
        text(midX,midY,[num2str(Velocity),'%/\mum']);
        STIPropagationVel(1,4)=Velocity;
    end
    % Right part
    if MaxI<length(Full_Y2)
        RightPart_Y=Full_Y2(MaxI:end);
        RightPart_X=Full_X2(MaxI:end);
        p=polyfit(RightPart_X,RightPart_Y,1);
        f = polyval(p,RightPart_X);
        plot(RightPart_X,f,'--');
        midX=mean([RightPart_X(1) RightPart_X(end)]);
        midY=mean([f(1) f(end)]);
        Velocity=round(abs(p(1))*100)/100;
        text(midX+1,midY,[num2str(Velocity),'%/\mum']);
        STIPropagationVel(2,4)=Velocity;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:vesselcount
        if ResConsTimePN50(i)
            subplot(2,3,3);hold on;
            plot([ROI_Geo_DistanceN(i) ROI_Geo_DistanceN(i)],[ResConsTimePN50(i)-str2num(FrameNo1) ResConsTimePN50(i)-str2num(FrameNo1)],...
                'Marker','s',...
                'MarkerSize',10,...
                'LineWidth',2,...
                'MarkerEdgeColor',presetcolorN{i},...
                'MarkerFaceColor',presetcolorN{i});
        end
    end
    set(gca,'FontSize',16);
    xlabel('\fontsize{16}STI Distance from pa (\mum)');
    ylabel('\fontsize{16}Latency (s)');
    title('\fontsize{14}STI Falling Phase Latency - PN');
    
    % find the neg peak
    [C0,I0]=find((ResConsTimePN50-str2num(FrameNo1))>0);
    Full_X=ROI_Geo_DistanceN(I0);
    [Full_X2,II]=sort(Full_X);
    Full_Y=ResConsTimePN50(I0)-str2num(FrameNo1);
    Full_Y2=Full_Y(II);
    [MinV,MinI]=min(Full_Y2);
    % left part
    if MinI>1
        LeftPart_Y=Full_Y2(1:MinI);
        LeftPart_X=Full_X2(1:MinI);
        p=polyfit(LeftPart_X,LeftPart_Y,1);
        f = polyval(p,LeftPart_X);
        plot(LeftPart_X,f,'--');
        midX=mean([LeftPart_X(1) LeftPart_X(end)]);
        midY=mean([f(1) f(end)]);
        Velocity=round(abs(1/p(1))*100)/100;
        text(midX,midY,[num2str(Velocity),'\mum/s']);
        STIPropagationVel(1,5)=Velocity;
    end
    % Right part
    if MinI<length(Full_Y2)
        RightPart_Y=Full_Y2(MinI:end);
        RightPart_X=Full_X2(MinI:end);
        p=polyfit(RightPart_X,RightPart_Y,1);
        f = polyval(p,RightPart_X);
        plot(RightPart_X,f,'--');
        midX=mean([RightPart_X(1) RightPart_X(end)]);
        midY=mean([f(1) f(end)]);
        Velocity=round(abs(1/p(1))*100)/100;
        text(midX+1,midY,[num2str(Velocity),'\mum/s']);
        STIPropagationVel(2,5)=Velocity;
    end
    
    
    for i=1:vesselcount
        if ResNegPeakLoc(i)
            subplot(2,3,6);hold on;
            plot([ROI_Geo_DistanceN(i) ROI_Geo_DistanceN(i)],[(ResPeakLoc(i)-ResNegPeakLoc(i))*100 ((ResPeakLoc(i)-ResNegPeakLoc(i)))*100],...
                'Marker','s',...
                'MarkerSize',10,...
                'LineWidth',2,...
                'MarkerEdgeColor',presetcolorN{i},...
                'MarkerFaceColor',presetcolorN{i});
        end
    end
    set(gca,'FontSize',16);
    xlabel('\fontsize{16}STI Distance from pa (\mum)');
    ylabel('\fontsize{16}Diameter Change (%)');
    title('\fontsize{14}STI PosNeg Peak Amplitude');
    % do the curve fitting
    % find the pos peak
    ResPosNegPeakLoc=ResPeakLoc-ResNegPeakLoc;
    [C0,I0]=find(ResPosNegPeakLoc-1>0);
    Full_X=ROI_Geo_DistanceN(I0);
    [Full_X2,II]=sort(Full_X);
    Full_Y=(ResPosNegPeakLoc(I0)-1)*100;
    Full_Y2=Full_Y(II);
    [MaxV,MaxI]=max(Full_Y2);
    % left part
    if MaxI>1
        LeftPart_Y=Full_Y2(1:MaxI);
        LeftPart_X=Full_X2(1:MaxI);
        p=polyfit(LeftPart_X,LeftPart_Y,1);
        f = polyval(p,LeftPart_X);
        plot(LeftPart_X,f,'--');
        midX=mean([LeftPart_X(1) LeftPart_X(end)]);
        midY=mean([f(1) f(end)]);
        Velocity=round(abs(p(1))*100)/100;
        text(midX,midY,[num2str(Velocity),'%/\mum']);
        STIPropagationVel(1,6)=Velocity;
    end
    % Right part
    if MaxI<length(Full_Y2)
        RightPart_Y=Full_Y2(MaxI:end);
        RightPart_X=Full_X2(MaxI:end);
        p=polyfit(RightPart_X,RightPart_Y,1);
        f = polyval(p,RightPart_X);
        plot(RightPart_X,f,'--');
        midX=mean([RightPart_X(1) RightPart_X(end)]);
        midY=mean([f(1) f(end)]);
        Velocity=round(abs(p(1))*100)/100;
        text(midX+1,midY,[num2str(Velocity),'%/\mum']);
        STIPropagationVel(2,6)=Velocity;
    end
    
    
    
end





% --- Executes on selection change in Ch2Choose.
function Ch2Choose_Callback(hObject, eventdata, handles)





function CVforceIN_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CVforceIN_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CVforceOUT_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CVforceOUT_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CorrectBaseline.
function CorrectBaseline_Callback(hObject, eventdata, handles)


function Loc1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc4_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc5_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc6_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc7_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc1Color_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc1Color_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc2Color_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc2Color_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc3Color_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc3Color_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc4Color_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc4Color_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc5Color_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc5Color_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc6Color_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Loc6Color_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc7Color_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Loc7Color_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc1Num_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Loc1Num_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc2Num_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Loc2Num_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc3Num_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Loc3Num_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc4Num_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc4Num_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc5Num_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc5Num_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc6Num_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc6Num_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Loc7Num_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Loc7Num_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in VideoOptim.
function VideoOptim_Callback(hObject, eventdata, handles)
global myVideo myVideoR myVideo_New myVideoR_New useNew WidthPixNum HeightPixNum PlanePerStack FrameNum avgFrame_3Ch avgFrame_3Ch_new Raw4DVideoG Raw4DVideoR PlanePerStackNew;

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
    
    for i=2:10   % we assume that the video will have at least 10 s baseline
        eachStack=double(Raw4DVideoG(:,:,:,i));
        avgStack=avgStack+(eachStack./9);    
    end
    
    hd11=figure;
    for iii=1:PlanePerStackNew
        subplot(3,4,iii),imagesc(avgStack(:,:,iii).');axis off;
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
            for j=2:PlanePerStackNew
                eachStackG_new(:,1:end-XdriftMean*(j-1),j)=eachStackG(:,1+XdriftMean*(j-1):end,j);
                eachStackG_new(:,end-XdriftMean*(j-1)+1:end,j)=repmat(eachStackG(:,end,j),1,XdriftMean*(j-1));
            end
            eachFrameG = max(eachStackG_new, [], 3);
            avgFrameG=avgFrameG+eachFrameG/FrameNum; 
            myVideo_New(:,:,i)=eachFrameG;
            
            %%%%%% red channel
            for j=2:PlanePerStackNew
                eachStackR_new(:,1:end-XdriftMean*(j-1),j)=eachStackR(:,1+XdriftMean*(j-1):end,j);
                eachStackR_new(:,end-XdriftMean*(j-1)+1:end,j)=repmat(eachStackR(:,end,j),1,XdriftMean*(j-1));
            end
            eachFrameR = max(eachStackR_new, [], 3);
            avgFrameR=avgFrameR+eachFrameR/FrameNum; 
            myVideoR_New(:,:,i)=eachFrameR;
            
        elseif XdriftMean<0
            
            %%%%%% green channel
            for j=2:PlanePerStackNew
                eachStackG_new(:,1-XdriftMean*(j-1):end,j)=eachStackG(:,1:end+XdriftMean*(j-1),j);
                eachStackG_new(:,1:-XdriftMean*(j-1),j)=repmat(eachStackG(:,1,j),1,-XdriftMean*(j-1));
            end
            eachFrameG = max(eachStackG_new, [], 3);
            avgFrameG=avgFrameG+eachFrameG/FrameNum; 
            myVideo_New(:,:,i)=eachFrameG;
            
            %%%%%% red channel
            for j=2:PlanePerStackNew
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
            for j=2:PlanePerStackNew
                eachStackG_new(1:end-YdriftMean*(j-1),:,j)=eachStackG_tmp(1+YdriftMean*(j-1):end,:,j);
                eachStackG_new(end-YdriftMean*(j-1)+1:end,:,j)=repmat(eachStackG_tmp(end,:,j),YdriftMean*(j-1),1);
            end
            eachFrameG = max(eachStackG_new, [], 3);
            avgFrameG=avgFrameG+eachFrameG/FrameNum; 
            myVideo_New(:,:,i)=eachFrameG;
            
            %%%%%% red channel
            for j=2:PlanePerStackNew
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
            for j=2:PlanePerStackNew
                eachStackG_new(1-YdriftMean*(j-1):end,:,j)=eachStackG_tmp(1:end+YdriftMean*(j-1),:,j);
                eachStackG_new(1:-YdriftMean*(j-1),:,j)=repmat(eachStackG_tmp(end,:,j),-YdriftMean*(j-1),1);
            end
            eachFrameG = max(eachStackG_new, [], 3);
            avgFrameG=avgFrameG+eachFrameG/FrameNum; 
            myVideo_New(:,:,i)=eachFrameG;
            
            %%%%%% red channel
            for j=2:PlanePerStackNew
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
            mymin=min(min(avgFrame_3Ch_new(:,:,j)));
            mymax=max(max(avgFrame_3Ch_new(:,:,j)));
            avgFrame_3Ch_new(:,:,j)=255*(avgFrame_3Ch_new(:,:,j)-mymin)/(mymax-mymin);
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
    for iframe_ref = 1:size(myVideo_New,3)  % run each frame as a reference frame
        ref_frame = [];
        ref_frame = myVideo_New(:,:,iframe_ref);   % reference/template frame, e.g., choose the frame when animals is not moving, or stable frame
        
        shiftxy_all = [];
        
        for iframe = 1:size(myVideo_New,3)
%             disp(['n=',num2str(iframe)]);
            current_frame = myVideo_New(:,:,iframe);  % frame that needs to be corrected
            
            [shiftX,shiftY] = run_fftxcorr_get_shift(current_frame,ref_frame);
            
            shiftxy_all = [shiftxy_all (abs(shiftX)+abs(shiftY))./2];  % get averaged shift of x and y direction
            
        end
        dist_xy = [dist_xy mean(shiftxy_all)];
        
        disp([num2str(iframe_ref),'th stack out of ', num2str(size(myVideo_New,3)),' total stacks is done']);
    end
    
    % select least 20% of the frames showing the least shift against other comparing frames
    Table_frame(:,1) = 1:size(myVideo_New,3);  % frame number
    Table_frame(:,2) = dist_xy;
    Table_frame2 = sortrows(Table_frame,2);
    
    least20_percent = size(myVideo_New,3)*0.2;
    ref_frame_indice = Table_frame2(1:least20_percent,1);
    REF_frame = mean(myVideo_New(:,:,ref_frame_indice),3);
    
    %% Now correct all frames in video using the reference frame 'REF_frame'
    avgFrameG=zeros(WidthPixNum,HeightPixNum);
    avgFrameR=zeros(WidthPixNum,HeightPixNum);
    corrected_frame_all = [];
    corrected_frame_all_Rch = [];
    disp('Start to correct frames......');
    for iframe = 1:size(myVideo_New,3)
        current_frame = [];
        current_frame = myVideo_New(:,:,iframe);  % frame that needs to be corrected        
        [shiftX,shiftY] = run_fftxcorr_get_shift(current_frame,REF_frame);        
        corrected_frame = circshift(current_frame,[shiftY,shiftX]);    
        corrected_frame_all(:,:,iframe) = corrected_frame;
        avgFrameG=avgFrameG+corrected_frame/FrameNum; 
        
        %%%%%%%%%%%%%%% Red channel       
        current_frame_Rch = [];
        current_frame_Rch = myVideoR_New(:,:,iframe);  % frame that needs to be corrected
        corrected_frame_Rch = circshift(current_frame_Rch,[shiftY,shiftX]);  
        corrected_frame_all_Rch(:,:,iframe) = corrected_frame_Rch;
        
        avgFrameR=avgFrameR+corrected_frame_Rch/FrameNum; 
        
        
        clear corrected_frame current_frame_Rch current_zstack_Rch corrected_frame_Rch;
        
        disp([num2str(iframe),'th frame is corrected']);
    end
    
    
    myVideo_New=corrected_frame_all;
    myVideoR_New=corrected_frame_all_Rch;
    useNew=1;
    
    %%%%%%%%% plot again
    avgFrame_3Ch_new=zeros(size(avgFrameG,1),size(avgFrameG,2),3);
    avgFrame_3Ch_new(:,:,1)=avgFrameR;
    avgFrame_3Ch_new(:,:,2)=avgFrameG;
    
    for j=1:2
        % adjust LUT
        mymin=min(min(avgFrame_3Ch_new(:,:,j)));
        mymax=max(max(avgFrame_3Ch_new(:,:,j)));
        avgFrame_3Ch_new(:,:,j)=(avgFrame_3Ch_new(:,:,j)-mymin)/(mymax-mymin);
        avgFrame_3Ch_new(:,:,j)=imadjust(avgFrame_3Ch_new(:,:,j))*255;
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
    
%     avgFrame_3Ch_new1=avgFrame_3Ch_new;
    
    
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
    % ROI_BW_00 = createMask(h00).';
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





% --- Executes on button press in UpdateCutTime.
function UpdateCutTime_Callback(hObject, eventdata, handles)
global BaseLineFrameNo myDIs FrameTime FFST fig2_hds fig2_waves fig3_hds fig3_waves fig4_hds fig4_waves fig5_hds fig5_waves;
global vesselcount myTimeTicks presetcolor STITimeTicks handlesaxes4 ROINoPerCap hdl_STI3 hdl_31 hdl_32 handlesaxes5 LocNameAll;
global FrameNo1 FrameNo2 CutFrameNum1 CutFrameNum2 CutTime1 CutTime2 PuffStartTime PuffEndTime Wave_Measure PuffTimeNo1 PuffTimeNo2;

CutTime1=str2num(get(handles.CutTime01,'String'));
CutTime2=str2num(get(handles.CutTime02,'String'));

CutFrameNum1=fix((CutTime1)/FrameTime);
CutFrameNum2=fix((CutTime2)/FrameTime);

if CutTime1~=0 && CutTime2~=0
    
    if ~isempty(fig3_hds)
        for i=1:vesselcount
            eval(['try delete(fig2_hds(',num2str(i),'));end']);
            eval(['try delete(fig3_hds(',num2str(i),'));end']);
        end
    end
    fig2_hds=[];

    fig3_hds=[];
    fig3_waves=[];
    fig4_hds=[];
    fig4_waves=[];
    fig5_hds=[];
    fig5_waves=[];
    
    if CutFrameNum1>BaseLineFrameNo
        BaseLineFrameNo=CutFrameNum1;
    end
    
    if vesselcount>=1 && ~isempty(fig2_waves)
        for i=1:vesselcount
            CellIOT=fig2_waves(i,:);
            
            
            %%%%%%%%%%%%%%%%%% figure 2
            axes(handles.axes2);
            hold on;
            hd2=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),CellIOT(CutFrameNum1:CutFrameNum2),'Color',presetcolor{i},'LineWidth',2);
            title('\fontsize{12}Raw Diameter');
            ylabel('\fontsize{12}Diameter(\mum)');
            ylim auto;
            mylim=get(gca,'ylim');
            if length(STITimeTicks)                
                hdl_STI2=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
            end
            if str2num(FrameNo1)*str2num(FrameNo2)
                hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
                hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
            end
            fig2_hds=[fig2_hds hd2];

            
            %%%%%%%%%%%%%%%%% figure 3
            % Plot normalized (1) intensity over time in middle right subplot 
            V3=CellIOT./mean(CellIOT(CutFrameNum1:BaseLineFrameNo));    % first frame is not good because of warm up
            axes(handles.axes3);
            hold on;
            hd3=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),V3(CutFrameNum1:CutFrameNum2),'Color',presetcolor{i},'LineWidth',2);
            title('\fontsize{12}Normalized Diameter Change');
            ylim auto;
            mylim=get(gca,'ylim');
            if length(STITimeTicks)
                
                hdl_STI2=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
            end
            if str2num(FrameNo1)*str2num(FrameNo2)
                hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
                hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
            end
            fig3_hds=[fig3_hds hd3];
            fig3_waves=[fig3_waves;V3];
           
        end
        
            ROINoCaptemp=mean(ROINoPerCap,2);
            BarNum=0;
            for j=1:length(ROINoCaptemp)
                if ROINoCaptemp(j) 
                    BarNum=BarNum+1;
                end
            end
            
            % figure 4
            axes(handlesaxes4);hold on;
            cla;
            Mean_Waves=zeros(BarNum,size(fig3_waves,2));
            ColorCollection='rbgymck';
            for j=1:BarNum
                Mean_Waves(j,:)=mean(fig3_waves(ROINoPerCap(j,1):ROINoPerCap(j,2),:),1);
                plot(myTimeTicks(CutFrameNum1:CutFrameNum2),Mean_Waves(j,CutFrameNum1:CutFrameNum2),ColorCollection(j),'LineWidth',2);
            end
            title('\fontsize{10}Mean curves at each order');
            xlabel('\fontsize{10}Time (s)');
            ylim('auto');
            mylim=get(gca,'ylim');
            if length(STITimeTicks)
                hdl_STI3=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
            end
            if str2num(FrameNo1)*str2num(FrameNo2)
                hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
                hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
            end
    
            ylim(mylim);
            fig4_waves=Mean_Waves;
    
    
            % Plot amplitude and mean area under curve at each order capillary
            Wave_Measure=zeros(BarNum,2); % 1st row is peak amp, 2nd row is AUC of the last 1 minutes
            % 
            % if length(STITimeTicks)
            %     for j=1:BarNum
            %         [~,~,~,Wave_Measure(j,1),~,~,~,~,~,~,~, Wave_Measure(j,2)]=ResponseStartTime50P_5(fig4_waves(j,:));  %response start time
            % 
            %     end
            % end
            % 
            % if str2num(FrameNo1)*str2num(FrameNo2)
            %     for jj=1:BarNum
            %         [~, ~, ~, Wave_Measure(jj,1), ~, ~, ~, ~, ~, Wave_Measure(jj,2), ~]=AirPuffPeakFinder(fig4_waves(jj,:),FrameNo1,FrameNo2);
            %     end
            % end
            
            Wave_Measure=(Wave_Measure-1)*100;
            
            %%% plot

            axes(handlesaxes5);
            cla;
            hold on;
            hbar=bar(Wave_Measure(:,1:2).');
            for j=1:BarNum
                set(hbar(j),'FaceColor',ColorCollection(j));
                set(hbar(j),'EdgeColor',ColorCollection(j));
            end
            set(hbar,'BarWidth',1);    % The bars will now touch each other
            set(gca,'GridLineStyle','-');
            set(gca,'XTick',[1 2])
            xticklabels({'Dilation Peak','Constriction Peak'});
            title('\fontsize{10}Dilation and constriction peak at each order');
            set(get(gca,'YLabel'),'String','Diameter change (%)','FontSize',10);
            set(gca,'FontSize',10);
            q = char(39);legendcommand=strcat('lh = legend(',q);
            for j=1:BarNum
                if j<BarNum
                    legendcommand=strcat(legendcommand,LocNameAll{j},q,',',q);
                else
                    legendcommand=strcat(legendcommand,LocNameAll{j},q,');');
                end
            end
            eval(legendcommand);
            set(lh,'Location','NorthEast');
            ylim auto;
            hold on;
            box off;
            fig5_waves=Wave_Measure;
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


%%%%-------
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


%% % --   read from txt file with the same name
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
FrameTime = TotalTime/TotalStack;


myTimeTicks = FrameTime:FrameTime:FrameTime*TotalStack;
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


% GreenImg = imageStack;
ChInfo=InfoAll{11};
k1=findstr(ChInfo,'"');
ChNum=str2num(ChInfo(k1(3)+1:k1(3)+2));

PlanePerStack=1;
FrameNum=TotalStack;

%% re-scale the image
for k = 1:TotalStack
    DiamImgs(:,:,k) = imread(fname, (k-1)*2+1, 'Info', info);
    CaImgs(:,:,k) = imread(fname, k*2, 'Info', info);
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



% 
% 
% 
% 
% 
% avgFrameG=zeros(WidthPixNum,HeightPixNum);
% avgFrameR=zeros(WidthPixNum,HeightPixNum);
% myVideoGch=zeros(WidthPixNum,HeightPixNum,FrameNum);
% myVideoRch=zeros(WidthPixNum,HeightPixNum,FrameNum);
% myVideoStim=zeros(WidthPixNum,HeightPixNum,FrameNum);
% 
% 
% if ChNum==2
%     GreenImg=imageStack(:,:,1:1:PlanePerStack*FrameNum);  
%     GreenImg0=reshape(GreenImg,WidthPixNum,[]);
%     Img_min=min(min(GreenImg0));
%     Img_max=max(max(GreenImg0));
%     GreenImg0=(GreenImg0-Img_min)/(Img_max-Img_min);
%     GreenImg0=imadjust(GreenImg0);
%     GreenImg0=reshape(GreenImg0,WidthPixNum,HeightPixNum,FrameNum*PlanePerStack);
% 
%     %RedImg=imageStack(:,:,PlanePerStack*FrameNum*2+1:1:PlanePerStack*FrameNum*3)-imageStack(:,:,PlanePerStack*FrameNum*3+1:1:PlanePerStack*FrameNum*4);    
%     RedImg=imageStack(:,:,PlanePerStack*FrameNum+1:1:PlanePerStack*FrameNum*2);
%     RedImg0=reshape(RedImg,WidthPixNum,[]);
%     Img_min=min(min(RedImg0));
%     Img_max=max(max(RedImg0));
%     RedImg0=(RedImg0-Img_min)/(Img_max-Img_min);
%     RedImg0=imadjust(RedImg0);
%     RedImg0=reshape(RedImg0,WidthPixNum,HeightPixNum,FrameNum*PlanePerStack);
% 
%     avgFrameG0=zeros(WidthPixNum,HeightPixNum);
%     avgFrameR0=zeros(WidthPixNum,HeightPixNum);
%     myVideoGch0=zeros(WidthPixNum,HeightPixNum,FrameNum);
%     myVideoRch0=zeros(WidthPixNum,HeightPixNum,FrameNum);
% 
% elseif ChNum==4 || ChNum==5
%     GreenImg=imageStack(:,:,1:1:PlanePerStack*FrameNum)-imageStack(:,:,PlanePerStack*FrameNum+1:1:PlanePerStack*FrameNum*2);
%     GreenImg0=reshape(GreenImg,WidthPixNum,[]);
%     Img_min=min(min(GreenImg0));
%     Img_max=max(max(GreenImg0));
%     GreenImg0=(GreenImg0-Img_min)/(Img_max-Img_min);
%     GreenImg0=imadjust(GreenImg0);
%     GreenImg0=reshape(GreenImg0,WidthPixNum,HeightPixNum,FrameNum*PlanePerStack);
% 
%     RedImg=imageStack(:,:,PlanePerStack*FrameNum*2+1:1:PlanePerStack*FrameNum*3)-imageStack(:,:,PlanePerStack*FrameNum*3+1:1:PlanePerStack*FrameNum*4);    
%     RedImg0=reshape(RedImg,WidthPixNum,[]);
%     Img_min=min(min(RedImg0));
%     Img_max=max(max(RedImg0));
%     RedImg0=(RedImg0-Img_min)/(Img_max-Img_min);
%     RedImg0=imadjust(RedImg0);
%     RedImg0=reshape(RedImg0,WidthPixNum,HeightPixNum,FrameNum*PlanePerStack);
% 
%     avgFrameG0=zeros(WidthPixNum,HeightPixNum);
%     avgFrameR0=zeros(WidthPixNum,HeightPixNum);
%     myVideoGch0=zeros(WidthPixNum,HeightPixNum,FrameNum);
%     myVideoRch0=zeros(WidthPixNum,HeightPixNum,FrameNum);
% 
% else
%     pause;
%     warndlg('There are unexpected number of channels','Warning');    
% end
% 
% Raw4DmyVideoStim=[];
% 
% %%%% --------------
% if EndPlaneNo==0
%     EndPlaneNo=PlanePerStack;
% end
% 
% PlanePerStackNew=EndPlaneNo-StartPlaneNo+1;
% 
% 
% for i=1:FrameNum
%     eachStackG = double(GreenImg(:,:,PlanePerStack*(i-1)+StartPlaneNo:1:PlanePerStack*(i-1)+EndPlaneNo)); %
%     eachFrameG = max(eachStackG, [], 3);
%     eachFrameG=double(eachFrameG);
%     avgFrameG=avgFrameG+eachFrameG;
%     myVideoGch(:,:,i)=eachFrameG;
%     Raw4DVideoG(:,:,:,i)=eachStackG;
% 
%     eachStackG0 = double(GreenImg0(:,:,PlanePerStack*(i-1)+StartPlaneNo:1:PlanePerStack*(i-1)+EndPlaneNo)); %
%     eachFrameG0 = max(eachStackG0, [], 3);
%     eachFrameG0=double(eachFrameG0);
%     avgFrameG0=avgFrameG0+eachFrameG0;
%     myVideoGch0(:,:,i)=eachFrameG0;
% 
% 
% 
%     eachStackR = double(RedImg(:,:,PlanePerStack*(i-1)+StartPlaneNo:1:PlanePerStack*(i-1)+EndPlaneNo)); %
%     eachFrameR = max(eachStackR, [], 3);
%     eachFrameR=double(eachFrameR);
%     avgFrameR=avgFrameR+eachFrameR;
%     myVideoRch(:,:,i)=eachFrameR;
%     Raw4DVideoR(:,:,:,i)=eachStackR;
% 
% 
%     eachStackR0 = double(RedImg0(:,:,PlanePerStack*(i-1)+StartPlaneNo:1:PlanePerStack*(i-1)+EndPlaneNo));
%     eachFrameR0 = max(eachStackR0, [], 3);
%     eachFrameR0=double(eachFrameR0);
%     avgFrameR0=avgFrameR+eachFrameR0;
%     myVideoRch0(:,:,i)=eachFrameR0;
% 
% 
% %     eachStackStim = double(imageStack(:,:,PlanePerStack*FrameNum*2+PlanePerStack*(i-1)+1:1:PlanePerStack*FrameNum*2+PlanePerStack*i));
% %     eachFrameStim = max(eachStackStim, [], 3);
% %     eachFrameStim=double(eachFrameStim);
% %     myVideoStim(:,:,i)=eachFrameStim;
% %     Raw4DmyVideoStim(:,:,:,i)=eachStackStim;
% 
% 
% 
% 
% end
% avgFrameG=avgFrameG/FrameNum;
% avgFrameR=avgFrameR/FrameNum;
% 
% avgFrameG0=avgFrameG0/FrameNum;
% avgFrameR0=avgFrameR0/FrameNum;
% 
% clear eachFrameR eachFrameG;
% 
% 
% %%% get the average image and image stack of Three channels of all frames 
% avgFrame_3Ch=zeros(size(avgFrameR0,2),size(avgFrameR0,1),3);
% % avgFrame_3Ch(:,:,1)=avgFrameR0;
% % avgFrame_3Ch(:,:,2)=avgFrameG0;
% avgFrame_3Ch(:,:,1)=avgFrameR0.';
% avgFrame_3Ch(:,:,2)=avgFrameG0.';
% 
% for j=1:2
%     % adjust LUT
%     mymin=min(min(avgFrame_3Ch(:,:,j)));
%     mymax=max(max(avgFrame_3Ch(:,:,j)));
%     avgFrame_3Ch(:,:,j)=255*(avgFrame_3Ch(:,:,j)-mymin)/(mymax-mymin);
% end
% avgFrame_3Ch=uint8(avgFrame_3Ch);
% axes(handles.axes1);
% % set(gcf,'units','normalized','outerposition',[0 0 1 1]);
% h_avgFrame_3Ch=imagesc(avgFrame_3Ch);
% axis image;
% axis off;
% 
% 
% myVideo=myVideoGch;
% myVideoR=myVideoRch;
% 
% 
% %%%--- read the other info
% myTimeTicks=FrameTime/1000:FrameTime/1000:TotalTime;
% CutTime1=round(myTimeTicks(1));
% CutTime2=round(myTimeTicks(end));
% CutFrameNum1=1;
% CutFrameNum2=FrameNum;
% set(handles.CutTime01,'String',num2str(CutTime1));
% set(handles.CutTime02,'String',num2str(CutTime2));
% 
% Xinfo=InfoAll{10};
% k1=findstr(Xinfo,',');
% k2=findstr(Xinfo,'[um/pixel]');
% XPixelSize = str2num(Xinfo(k1(end)+1:k2-1));  % unit: um/pixel
% 
% 
% Yinfo=InfoAll{10};
% k1=findstr(Yinfo,',');
% k2=findstr(Yinfo,'[um/pixel]');
% YPixelSize = str2num(Yinfo(k1(end)+1:k2-1));  % unit: um/pixel
% 
% 
% if XPixelSize==YPixelSize
%     PixelSize=XPixelSize;
%     FrameHeight=XPixelSize;
%     HeightStep=HeightPixNum;
%     WidthStep=WidthPixNum;
% else
%     warndlg('X and Y axis have different pixel size!');
% end
% 
% 
% 
% 
% PuffTimeNo1=str2num(get(handles.FrameNo1,'String'));
% PuffTimeNo2=str2num(get(handles.FrameNo2,'String'));
% 
% if str2num(FrameNo1)*str2num(FrameNo2)
%     tI=find(myTimeTicks<PuffTimeNo1);
%     FrameNo1=num2str(tI(end));
% 
%     tI=find(myTimeTicks<PuffTimeNo2);
%     FrameNo2=num2str(tI(end));
% end
% 
% 
% BaseLineFrameNo=10;
% if str2num(FrameNo1)>BaseLineFrameNo 
%     BaseLineFrameNo=str2num(FrameNo1);
% end
% 
% 
% 
% close(hh);
% 
% 


% --- Executes on button press in SmoothUpdate.
function SmoothUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to SmoothUpdate (see GCBO)
global BaseLineFrameNo myDIs FrameTime FFST fig2_hds fig2_waves fig3_hds fig3_waves fig4_hds fig4_waves fig5_hds fig5_waves;
global vesselcount myTimeTicks presetcolor STITimeTicks handlesaxes4 ROINoPerCap hdl_STI3 hdl_31 hdl_32 handlesaxes5 LocNameAll;
global FrameNo1 FrameNo2 CutFrameNum1 CutFrameNum2 CutTime1 CutTime2 PuffStartTime PuffEndTime Wave_Measure PuffTimeNo1 PuffTimeNo2 fig2_waves_raw;

SmoothWinSize=str2num(get(handles.SmoothWinSizeNew,'String'));


if SmoothWinSize>0
    
    if ~isempty(fig3_hds)
        for i=1:vesselcount
            eval(['try delete(fig2_hds(',num2str(i),'));end']);
            eval(['try delete(fig3_hds(',num2str(i),'));end']);
        end
    end
    fig2_hds=[];

    fig3_hds=[];
    fig3_waves=[];
    fig4_hds=[];
    fig4_waves=[];
    fig5_hds=[];
    fig5_waves=[];
    
    if CutFrameNum1>BaseLineFrameNo
        BaseLineFrameNo=CutFrameNum1;
    end
    
    if vesselcount>=1 && ~isempty(fig2_waves)
        for i=1:vesselcount
            
            fig2_waves(i,:)=smooth(fig2_waves_raw(i,:),SmoothWinSize);
            
            CellIOT=fig2_waves(i,:);
            
            
            
            
            %%%%%%%%%%%%%%%%%% figure 2
            axes(handles.axes2);
            hold on;
            hd2=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),CellIOT(CutFrameNum1:CutFrameNum2),'Color',presetcolor{i},'LineWidth',2);
            title('\fontsize{12}Raw Diameter');
            ylabel('\fontsize{12}Diameter(\mum)');
            ylim auto;
            mylim=get(gca,'ylim');
            if length(STITimeTicks)                
                hdl_STI2=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
            end
            if str2num(FrameNo1)*str2num(FrameNo2)
                hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
                hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
            end
            fig2_hds=[fig2_hds hd2];

            
            %%%%%%%%%%%%%%%%% figure 3
            % Plot normalized (1) intensity over time in middle right subplot 
            V3=CellIOT./mean(CellIOT(CutFrameNum1:BaseLineFrameNo));    % first frame is not good because of warm up
            axes(handles.axes3);
            hold on;
            hd3=plot(myTimeTicks(CutFrameNum1:CutFrameNum2),V3(CutFrameNum1:CutFrameNum2),'Color',presetcolor{i},'LineWidth',2);
            title('\fontsize{12}Normalized Diameter Change');
            ylim auto;
            mylim=get(gca,'ylim');
            if length(STITimeTicks)
                
                hdl_STI2=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
            end
            if str2num(FrameNo1)*str2num(FrameNo2)
                hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
                hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
            end
            fig3_hds=[fig3_hds hd3];
            fig3_waves=[fig3_waves;V3];
           
        end
        
            ROINoCaptemp=mean(ROINoPerCap,2);
            BarNum=0;
            for j=1:length(ROINoCaptemp)
                if ROINoCaptemp(j) 
                    BarNum=BarNum+1;
                end
            end
            
            % figure 4
            axes(handlesaxes4);hold on;
            cla;
            Mean_Waves=zeros(BarNum,size(fig3_waves,2));
            ColorCollection='rbgymck';
            for j=1:BarNum
                Mean_Waves(j,:)=mean(fig3_waves(ROINoPerCap(j,1):ROINoPerCap(j,2),:),1);
                plot(myTimeTicks(CutFrameNum1:CutFrameNum2),Mean_Waves(j,CutFrameNum1:CutFrameNum2),ColorCollection(j),'LineWidth',2);
            end
            title('\fontsize{10}Mean curves at each order');
            xlabel('\fontsize{10}Time (s)');
            ylim('auto');
            mylim=get(gca,'ylim');
            if length(STITimeTicks)
                hdl_STI3=line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k');
            end
            if str2num(FrameNo1)*str2num(FrameNo2)
                hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
                hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
            end
    
            ylim(mylim);
            fig4_waves=Mean_Waves;
    
    
            % Plot amplitude and mean area under curve at each order capillary
            Wave_Measure=zeros(BarNum,2); % 1st row is peak amp, 2nd row is AUC of the last 1 minutes
            
            % if length(STITimeTicks)
            %     for j=1:BarNum
            %         [~,~,~,Wave_Measure(j,1),~,~,~,~,~,~,~, Wave_Measure(j,2)]=ResponseStartTime50P_5(fig4_waves(j,:));  %response start time
            % 
            %     end
            % end
            % 
            % if str2num(FrameNo1)*str2num(FrameNo2)
            %     for jj=1:BarNum
            %         [~, ~, ~, Wave_Measure(jj,1), ~, ~, ~, ~, ~, Wave_Measure(jj,2), ~]=AirPuffPeakFinder(fig4_waves(jj,:),FrameNo1,FrameNo2);
            %     end
            % end
            
            Wave_Measure=(Wave_Measure-1)*100;
            
            %%% plot

            axes(handlesaxes5);
            cla;
            hold on;
            hbar=bar(Wave_Measure(:,1:2).');
            for j=1:BarNum
                set(hbar(j),'FaceColor',ColorCollection(j));
                set(hbar(j),'EdgeColor',ColorCollection(j));
            end
            set(hbar,'BarWidth',1);    % The bars will now touch each other
            set(gca,'GridLineStyle','-');
            set(gca,'XTick',[1 2])
            xticklabels({'Dilation Peak','Constriction Peak'});
            title('\fontsize{10}Dilation and constriction peak at each order');
            set(get(gca,'YLabel'),'String','Diameter change (%)','FontSize',10);
            set(gca,'FontSize',10);
            q = char(39);legendcommand=strcat('lh = legend(',q);
            for j=1:BarNum
                if j<BarNum
                    legendcommand=strcat(legendcommand,LocNameAll{j},q,',',q);
                else
                    legendcommand=strcat(legendcommand,LocNameAll{j},q,');');
                end
            end
            eval(legendcommand);
            set(lh,'Location','NorthEast');
            ylim auto;
            hold on;
            box off;
            fig5_waves=Wave_Measure;
    end
    
end



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

function ImgStblFcn_Callback(hObject, eventdata, handles)

function ImgSmthFcn_Callback(hObject, eventdata, handles)

function edit35_Callback(hObject, eventdata, handles)

function edit35_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CutTime02_Callback(hObject, eventdata, handles)

function CutTime02_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function SmoothWinSizeNew_Callback(hObject, eventdata, handles)


function SmoothWinSizeNew_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CutTime01_Callback(hObject, eventdata, handles)


function CutTime01_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function VideoReset_Callback(hObject, eventdata, handles)

function Nopuff_Callback(hObject, eventdata, handles)

function yespuff_Callback(hObject, eventdata, handles)

function TimeStablization_Callback(hObject, eventdata, handles)

function Plot_CreateFcn(hObject, eventdata, handles)

function TiffPath_Callback(hObject, eventdata, handles)


function TiffPath_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
