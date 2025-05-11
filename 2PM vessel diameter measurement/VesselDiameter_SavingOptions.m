function varargout = VesselDiameter_SavingOptions(varargin)
% VESSELDIAMETER_SAVINGOPTIONS MATLAB code for VesselDiameter_SavingOptions.fig
%      VESSELDIAMETER_SAVINGOPTIONS, by itself, creates a new VESSELDIAMETER_SAVINGOPTIONS or raises the existing
%      singleton*.
%
%      H = VESSELDIAMETER_SAVINGOPTIONS returns the handle to a new VESSELDIAMETER_SAVINGOPTIONS or the handle to
%      the existing singleton*.
%
%      VESSELDIAMETER_SAVINGOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VESSELDIAMETER_SAVINGOPTIONS.M with the given input arguments.
%
%      VESSELDIAMETER_SAVINGOPTIONS('Property','Value',...) creates a new VESSELDIAMETER_SAVINGOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VesselDiameter_SavingOptions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VesselDiameter_SavingOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VesselDiameter_SavingOptions

% Last Modified by GUIDE v2.5 17-Feb-2016 15:07:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @VesselDiameter_SavingOptions_OpeningFcn, ...
    'gui_OutputFcn',  @VesselDiameter_SavingOptions_OutputFcn, ...
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


% --- Executes just before VesselDiameter_SavingOptions is made visible.
function VesselDiameter_SavingOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VesselDiameter_SavingOptions (see VARARGIN)

% Choose default command line output for VesselDiameter_SavingOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VesselDiameter_SavingOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global vesselcount FiletoStudy;

FilePathAll=pwd;

allfilesep=find(FilePathAll==filesep);
mysavingfolder0=FilePathAll(1:allfilesep(end)-1);
mysavingfolder=strcat(mysavingfolder0,filesep,'ResultsNew');

cd(mysavingfolder0);     % set the current folder in MATLAB for mysaving folder

set(handles.savingfolder,'String',mysavingfolder);
set(handles.videofilename,'String',FiletoStudy);


% --- Outputs from this function are returned to the command line.
function varargout = VesselDiameter_SavingOptions_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in Finish.
function Finish_Callback(hObject, eventdata, handles)
global  vesselcount ROIs fig2_hds fig2_waves fig3_hds fig3_waves fig4_hds fig4_waves fig5_hds fig5_waves myTimeTicks FrameTime FFST FrameNo1 FrameNo2 presetcolor STITimeTicks Faxes1;
global  ResStT4 ResStLoc4 BaseLineFrameNo HeightStep ROIPosAll avgFrame useNew myVideo_New myVideo ROIWidthAll;
global  LocNumAll LocColorAll LocNameAll LegendAll ROI_Geo_Distance PuffPropagationVel STIPropagationVel SkeletonExist hd21 hd31 SkeletonInfo CutFrameNum1 CutFrameNum2 CutTime1 CutTime2;
global  RestitchCord CutImageCord1 CutImageCord2 ROINoPerCap Wave_Measure ColorCollection PuffTimeNo1 PuffTimeNo2;

% Rename
PixelSize=HeightStep;

% if there's any puff, take the info
if str2num(FrameNo1)*str2num(FrameNo2)
    PuffExist=1;
    PuffStartTime=PuffTimeNo1;
    PuffEndTime=PuffTimeNo2;
else
    PuffExist=0;
    PuffStartTime=0;
    PuffEndTime=0;
end

% if there's any STI
if length(STITimeTicks)==0
    STIExist=0;
else
    STIExist=1;
end

% save
if isempty(get(handles.savingfolder,'String'))
    warndlg('No pathway entered','!! Warning !!');
else
    savingpathway=get(handles.savingfolder,'String');
    savingfilename=get(handles.videofilename,'String');
    
    % ROI naming
    ROIfilenames=LegendAll(1:vesselcount);
    
    % if the saving folder exist
    if exist([savingpathway,filesep,savingfilename],'dir')~=7    % if not exist, create the folder
        mkdir([savingpathway,filesep,savingfilename]);
    else   % if the folder already exist, delete all the files in the folder
        delete([savingpathway,filesep,savingfilename,filesep,'*.*']);
    end
    
    %%%%%%%%%%%%%%%%%%% for axes1 in the main window, the guiding figures
    figure('units','normalized','outerposition',[0 0 1 1]);
    image(Faxes1.cdata);  % show selected axes in the new figure
    axis equal;
    axis off;
    pause(1);
    saveas(gcf,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_ROIOverview.tif']);
    saveas(gcf,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_ROIOverview.fig']);
    close(gcf);
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%% individual vessels %%%%%%%%%%%%%%%%%%%%%%%
    
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
    AUCFirst1min=zeros(1,vesselcount);
    AUCLast1min=zeros(1,vesselcount);
    
    %
    hd24=figure(24);hold on;
    for i=1:vesselcount
        plot(myTimeTicks(CutFrameNum1:CutFrameNum2),fig3_waves(i,CutFrameNum1:CutFrameNum2),'Color',presetcolor{i},'LineWidth',2);
        %         if length(STITimeTicks)~=0
        %             [ResStT50(i),ResStLoc50(i),ResPeakTime(i),ResPeakLoc(i),ResConsTimePN50(i), ResConsLocPN50(i), ResConsTimeP50(i), ResConsLocP50(i), ResNegPeakTime(i), ResNegPeakLoc(i) ResBackToBaselineTime(i) AUCLast1min_STI(i)]=ResponseStartTime50P_5(fig3_waves(i,:));  %response start time
        %         end
        % if str2num(FrameNo1)~=0
        %     [ResStT50(i), ResStLoc50(i), ResPeakTime(i), ResPeakLoc(i), ResConsTimePN50(i), ResConsLocPN50(i), ResConsTimeP50(i), ResConsLocP50(i), ResNegPeakTime(i), ResNegPeakLoc(i), ResBackToBaselineTime(i)]=AirPuffPeakFinder(fig3_waves(i,:),FrameNo1,FrameNo2);
        % 
        % end
        
    end
    title('\fontsize{18}Individual ROI responses');
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
        PuffStartTime=PuffTimeNo1;
        PuffEndTime=PuffTimeNo2;
        
        myX=[PuffStartTime PuffStartTime PuffEndTime PuffEndTime];
        myY=[mylim(1) mylim(2) mylim(2) mylim(1)];
        p=patch(myX,myY,'m');
        set(p,'FaceAlpha',0.5);
    end
    
    %     % plot the response start time
%         for i=1:vesselcount
%             if ResStT50(i)
%                 line([ResStT50(i) ResStT50(i)],[ResStLoc50(i)-0.1*(mylim(2)-mylim(1)) ResStLoc50(i)+0.1*(mylim(2)-mylim(1))],'Color',presetcolor{i},'LineWidth',2);
%             end
%             if ResConsTimePN50(i)
%                 line([ResConsTimePN50(i) ResConsTimePN50(i)],[ResConsLocPN50(i)-0.1*(mylim(2)-mylim(1)) ResConsLocPN50(i)+0.1*(mylim(2)-mylim(1))],'Color',presetcolor{i},'LineWidth',2,'LineStyle','-.');
%             end
%             if ResConsTimeP50(i)
%                 line([ResConsTimeP50(i) ResConsTimeP50(i)],[ResConsLocP50(i)-0.1*(mylim(2)-mylim(1)) ResConsLocP50(i)+0.1*(mylim(2)-mylim(1))],'Color',presetcolor{i},'LineWidth',2,'LineStyle','--');
%             end
%         end
    
    %     % plot puff related peak
    %     if str2num(FrameNo1)*str2num(FrameNo2)
    %         for i=1:vesselcount
    %             plot([NegPeakTime(i) NegPeakTime(i)],[NegPeakAmp(i) NegPeakAmp(i)],'Color',presetcolor{i},'Marker','*','MarkerSize',8);
    %             plot([NegHalfPeakTime(i) NegHalfPeakTime(i)],[HalfPeakLoc(i)-0.2 HalfPeakLoc(i)+0.2],'Color',presetcolor{i},'LineStyle','--');
    %             plot(xx_cf(:,i),yy_cf(:,i),'Color',presetcolor{i},'LineStyle','-');
    %         end
    %     end
    
    ROIfilenames=LegendAll(1:vesselcount);
    legend(ROIfilenames);
    
    saveas(hd24,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_EachROICurve.fig']);
    saveas(hd24,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_EachROICurve.jpg']);
    close(hd24);
    
    Responses_EachROI = struct ('ResStT50',{ResStT50},'ResStLoc50',{ResStLoc50},'ResPeakTime',{ResPeakTime},...
        'ResPeakLoc',{ResPeakLoc},'ResConsTimePN50',{ResConsTimePN50},'ResConsLocPN50',{ResConsLocPN50},...
        'ResConsTimeP50',{ResConsTimeP50},'ResConsLocP50',{ResConsLocP50},'ResNegPeakTime',{ResNegPeakTime},...
        'ResNegPeakLoc',{ResNegPeakLoc},'ResBackToBaselineTime',{ResBackToBaselineTime});
    
    %     ETPuffResponses_EachROI = struct('NegPeakTime',{NegPeakTime},'NegPeakAmp',{NegPeakAmp},'NegHalfPeakTime',{NegHalfPeakTime},...
    %         'HalfPeakLoc',{HalfPeakLoc},'NegStartTime',{NegStartTime},'NegSlope',{NegSlope},'xx_cf',{xx_cf},...
    %         'yy_cf',{yy_cf},'LastOneMinAUC',{AUCLast1min},'FirstOneMinAUC',{AUCFirst1min});
    
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%% by capillary order %%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%% Determine how many bars should be in the following two bar plots
    ROINoCaptemp=mean(ROINoPerCap,2);
    BarNum=0;
    for jj=1:length(ROINoCaptemp)
        if ROINoCaptemp(jj)
            BarNum=BarNum+1;
        end
    end
    
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
    
    %%% PUFF RESPONSE VARIABLES
    NegPeakTime_CapOrder=zeros(1,BarNum);
    NegPeakAmp_CapOrder=zeros(1,BarNum);
    NegHalfPeakTime_CapOrder=zeros(1,BarNum);
    HalfPeakLoc_CapOrder=zeros(1,BarNum);
    NegStartTime_CapOrder=zeros(1,BarNum);
    NegSlope_CapOrder=zeros(1,BarNum);
    xx_cf_CapOrder=zeros(5,BarNum);
    yy_cf_CapOrder=zeros(5,BarNum);
    AUCFirst1min_CapOrder=zeros(1,BarNum);
    AUCLast1min_CapOrder=zeros(1,BarNum);
    
    hd25=figure(25);hold on;
    for jj=1:BarNum
        plot(myTimeTicks(CutFrameNum1:CutFrameNum2),fig4_waves(jj,CutFrameNum1:CutFrameNum2),ColorCollection(jj),'LineWidth',2);
        %         if length(STITimeTicks)~=0
        %             [ResStT50_CapOrder(jj),ResStLoc50_CapOrder(jj),ResPeakTime_CapOrder(jj),ResPeakLoc_CapOrder(jj),ResConsTimePN50_CapOrder(jj), ResConsLocPN50_CapOrder(jj), ResConsTimeP50_CapOrder(jj), ResConsLocP50_CapOrder(jj), ResNegPeakTime_CapOrder(jj), ResNegPeakLoc_CapOrder(jj) ResBackToBaselineTime_CapOrder(jj) AUCLast1min_STI_CapOrder(jj)]=ResponseStartTime50P_5(fig4_waves(jj,:));  %response start time
        %         end
        % if str2num(FrameNo1)~=0
        %     [ResStT50_CapOrder(jj), ResStLoc50_CapOrder(jj), ResPeakTime_CapOrder(jj), ResPeakLoc_CapOrder(jj), ResConsTimePN50_CapOrder(jj), ResConsLocPN50_CapOrder(jj), ResConsTimeP50_CapOrder(jj), ResConsLocP50_CapOrder(jj), ResNegPeakTime_CapOrder(jj), ResNegPeakLoc_CapOrder(jj), ResBackToBaselineTime_CapOrder(jj)]=AirPuffPeakFinder(fig4_waves(jj,:),FrameNo1,FrameNo2);
        % 
        % end
        
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
        hdl_31=line([PuffStartTime PuffStartTime],mylim,'Color','m');
        hdl_32=line([PuffEndTime PuffEndTime],mylim,'Color','m');
    end
    ylim(mylim);
    
    % plot the response start time
%         for i=1:BarNum
%             if ResStT50(i)
%                 line([ResStT50_CapOrder(i) ResStT50_CapOrder(i)],[ResStLoc50_CapOrder(i)-0.1*(mylim(2)-mylim(1)) ResStLoc50_CapOrder(i)+0.1*(mylim(2)-mylim(1))],'Color',ColorCollection(i),'LineWidth',2);
%             end
%             if ResConsTimePN50(i)
%                 line([ResConsTimePN50_CapOrder(i) ResConsTimePN50_CapOrder(i)],[ResConsLocPN50_CapOrder(i)-0.1*(mylim(2)-mylim(1)) ResConsLocPN50_CapOrder(i)+0.1*(mylim(2)-mylim(1))],'Color',ColorCollection(i),'LineWidth',2,'LineStyle','-.');
%             end
%             if ResConsTimeP50(i)
%                 line([ResConsTimeP50_CapOrder(i) ResConsTimeP50_CapOrder(i)],[ResConsLocP50_CapOrder(i)-0.1*(mylim(2)-mylim(1)) ResConsLocP50_CapOrder(i)+0.1*(mylim(2)-mylim(1))],'Color',ColorCollection(i),'LineWidth',2,'LineStyle','--');
%             end
%         end
%     
    %     % plot puff related peak
    %     if str2num(FrameNo1)*str2num(FrameNo2)
    %         for i=1:BarNum
    %             plot([NegPeakTime_CapOrder(i) NegPeakTime_CapOrder(i)],[NegPeakAmp_CapOrder(i) NegPeakAmp_CapOrder(i)],'Color',ColorCollection(i),'Marker','*','MarkerSize',8);
    %             plot([NegHalfPeakTime_CapOrder(i) NegHalfPeakTime_CapOrder(i)],[HalfPeakLoc_CapOrder(i)-0.2 HalfPeakLoc_CapOrder(i)+0.2],'Color',ColorCollection(i),'LineStyle','--');
    %             plot(xx_cf_CapOrder(:,i),yy_cf_CapOrder(:,i),'Color',ColorCollection(i),'LineStyle','-');
    %         end
    %     end
    
    ROIfilenames=LocNameAll(1:BarNum);
    legend(ROIfilenames);
    
    saveas(hd25,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_EachOrderCurve.fig']);
    saveas(hd25,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_EachOrderCurve.jpg']);
    close(hd25);
    
    %%%%%%%%%
    q = char(39);legendcommand=['lh=legend(',q];
    for jj=1:BarNum
        if jj<BarNum
            legendcommand=[legendcommand,LocNameAll{jj},q,',',q];
        else
            legendcommand=[legendcommand,LocNameAll{jj},q,');'];
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots for AMP
    hd26=figure(26);hold on;
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
    set(get(gca,'YLabel'),'String','Diameter change (%)','FontSize',12);
    set(gca,'FontSize',12);
    eval(legendcommand);
    set(lh,'Location','NorthEast');
    hold on;
    box off;
    
    %%%% save the waveforms
    saveas(hd26,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_PeakAucAmpBarPlot.fig']);
    saveas(hd26,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_PeakAucAmpBarPlot.jpg']);
    close(hd26);
    
    
    Responses_EachOrder = struct ('ResStT50',{ResStT50_CapOrder},'ResStLoc50',{ResStLoc50_CapOrder},'ResPeakTime',{ResPeakTime_CapOrder},...
        'ResPeakLoc',{ResPeakLoc_CapOrder},'ResConsTimePN50',{ResConsTimePN50_CapOrder},'ResConsLocPN50',{ResConsLocPN50_CapOrder},...
        'ResConsTimeP50',{ResConsTimeP50_CapOrder},'ResConsLocP50',{ResConsLocP50_CapOrder},'ResNegPeakTime',{ResNegPeakTime_CapOrder},...
        'ResNegPeakLoc',{ResNegPeakLoc_CapOrder},'ResBackToBaselineTime',{ResBackToBaselineTime_CapOrder});
    
    %     ETPuffResponses_EachOrder = struct('NegPeakTime',{NegPeakTime_CapOrder},'NegPeakAmp',{NegPeakAmp_CapOrder},'NegHalfPeakTime',{NegHalfPeakTime_CapOrder},...
    %         'HalfPeakLoc',{HalfPeakLoc_CapOrder},'NegStartTime',{NegStartTime_CapOrder},'NegSlope',{NegSlope_CapOrder},'xx_cf',{xx_cf_CapOrder},...
    %         'yy_cf',{yy_cf_CapOrder},'LastOneMinAUC',{AUCLast1min_CapOrder},'FirstOneMinAUC',{AUCFirst1min_CapOrder});
    %
    
    %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots for latency
    %     hd27=figure(27);hold on;
    %     hbar=bar(Wave_Measure(:,3));
    %     set(hbar,'BarWidth',0.6);    % The bars will now touch each other
    %     set(gca,'GridLineStyle','-');
    %     set(gca,'XTick',1:BarNum);
    %     myXTL=cell(1,BarNum);
    %     for jj=1:BarNum
    %          myXTL{jj}=LocNameAll{jj};
    %     end
    %     xticklabels(myXTL);
    %     title('\fontsize{14}Latency at each order');
    %     set(get(gca,'YLabel'),'String','Latency(s)','FontSize',12);
    %     set(gca,'FontSize',12);
    %     hold on;
    %     box off;
    %
    %     %%%% save the waveforms
    %     saveas(hd27,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_Latency.fig']);
    %     saveas(hd27,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_Latency.jpg']);
    %     close(hd27);
    
    
    
    %%%%%%%%%%%%%%%%%% save the data in the excel file %%%%%%%%%%%%%%%%%%%%%
    h3=msgbox('Saving to excel file...');
    
    %%%%%%%%%%%%%%%% Whisker stimulation by each ROI
    col_header_STI={'CapOrderName','BaselineDiam(um)','DilAmp(%)','AbsDiamChange(um)','UprisingLtc(s)','ConstAmp(%)','FallingLtcP(s)','FallingLtcNP(s)','Back2BslLtc(s)'};
    row_header_STI=LegendAll(1:vesselcount)';
    Wave_Measure_STI=zeros(vesselcount,8);
    if str2num(FrameNo1)*str2num(FrameNo2)
        for ii=1:vesselcount
            %%%%% mean diameter at each ROI
            CutArray=fig2_waves(ii,CutFrameNum1:BaseLineFrameNo);
            Wave_Measure_STI(ii,1)=mean(mean(CutArray));
            
            %%%% fill in the rest of the column
            Wave_Measure_STI(ii,2)=(ResPeakLoc(ii)-1)*100;
            Wave_Measure_STI(ii,3)=Wave_Measure_STI(ii,1)*Wave_Measure_STI(ii,2)/100;
            Wave_Measure_STI(ii,4)=ResStT50(ii)-myTimeTicks(BaseLineFrameNo);
            Wave_Measure_STI(ii,5)=(ResNegPeakLoc(ii)-1)*100;
            Wave_Measure_STI(ii,6)=ResConsTimeP50(ii)-myTimeTicks(BaseLineFrameNo);
            Wave_Measure_STI(ii,7)=ResConsTimePN50(ii)-myTimeTicks(BaseLineFrameNo);
            Wave_Measure_STI(ii,8)=ResBackToBaselineTime(ii)-myTimeTicks(BaseLineFrameNo);
%             Wave_Measure_STI(ii,9)=(AUCLast1min_STI(ii)-1)*100;
        end
    end
    
    
    
    Wave_Measure_STI=round(Wave_Measure_STI*10000)/10000;
    
    
    %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%% Whisker stimulation by each order
    col_header_STI={'CapOrderName','BaselineDiam(um)','DilAmp(%)','AbsDiamChange(um)','UprisingLtc(s)','ConstAmp(%)','FallingLtcP(s)','FallingLtcNP(s)','Back2BslLtc(s)'};
    row_header_STI_ORD=LocNameAll(1:BarNum)';
    Wave_Measure_STI_ORD=zeros(BarNum,8);
    if str2num(FrameNo1)*str2num(FrameNo2)
        for ii=1:BarNum
            %%%%% mean diameter at each order
            if ii~=1
                Num1=sum(LocNumAll(1:ii-1))+1;
            else
                Num1=1;
            end
            Num2=sum(LocNumAll(1:ii));
            CutArray=fig2_waves(Num1:Num2,CutFrameNum1:BaseLineFrameNo);
            Wave_Measure_STI_ORD(ii,1)=mean(mean(CutArray));
            
            %%%% fill in the rest of the column
            Wave_Measure_STI_ORD(ii,2)=(ResPeakLoc_CapOrder(ii)-1)*100;
            Wave_Measure_STI_ORD(ii,3)=Wave_Measure_STI_ORD(ii,1)*Wave_Measure_STI_ORD(ii,2)/100;
            Wave_Measure_STI_ORD(ii,4)=ResStT50_CapOrder(ii)-myTimeTicks(BaseLineFrameNo);
            Wave_Measure_STI_ORD(ii,5)=(ResNegPeakLoc_CapOrder(ii)-1)*100;
            Wave_Measure_STI_ORD(ii,6)=ResConsTimeP50_CapOrder(ii)-myTimeTicks(BaseLineFrameNo);
            Wave_Measure_STI_ORD(ii,7)=ResConsTimePN50_CapOrder(ii)-myTimeTicks(BaseLineFrameNo);
            Wave_Measure_STI_ORD(ii,8)=ResBackToBaselineTime_CapOrder(ii)-myTimeTicks(BaseLineFrameNo);
%             Wave_Measure_STI_ORD(ii,9)=(AUCLast1min_STI_CapOrder(ii)-1)*100;
        end
    end
    
%     %%%%%%%%%%%%%%%% ET1 puff by each order
%     col_header_ET1={'CapOrderName','BaselineDiam(um)','ConsAmp(%)','AbsDiamChange(um)','FallingLtcP(s)','NegStartTime(s)','NegSlope','AUCFirst1min','AUCLast1min'};
%     row_header_ET1_ORD=LocNameAll(1:BarNum)';
%     Wave_Measure_ET1_ORD=zeros(BarNum,8);
%     
%     if str2num(FrameNo1)*str2num(FrameNo2)
%         for ii=1:BarNum
%             %%%%% mean diameter at each order
%             if ii~=1
%                 Num1=sum(LocNumAll(1:ii-1))+1;
%             else
%                 Num1=1;
%             end
%             Num2=sum(LocNumAll(1:ii));
%             CutArray=fig2_waves(Num1:Num2,CutFrameNum1:BaseLineFrameNo);
%             Wave_Measure_ET1_ORD(ii,1)=mean(mean(CutArray));
%             
%             %%%% fill in the rest of the column
%             Wave_Measure_ET1_ORD(ii,2)=(NegPeakAmp_CapOrder(ii)-1)*100;
%             Wave_Measure_ET1_ORD(ii,3)=Wave_Measure_ET1_ORD(ii,1)*Wave_Measure_ET1_ORD(ii,2)/100;
%             Wave_Measure_ET1_ORD(ii,4)=NegHalfPeakTime_CapOrder(ii)-myTimeTicks(BaseLineFrameNo);
%             Wave_Measure_ET1_ORD(ii,5)=NegStartTime_CapOrder(ii)-myTimeTicks(BaseLineFrameNo);
%             Wave_Measure_ET1_ORD(ii,6)=NegSlope_CapOrder(ii);
%             Wave_Measure_ET1_ORD(ii,7)=(AUCFirst1min_CapOrder(ii)-1)*100;
%             Wave_Measure_ET1_ORD(ii,8)=(AUCLast1min_CapOrder(ii)-1)*100;    % unit: percentage*100 per min, equal to mean amp in the last one minute
%             
%         end
%     end
    
    Wave_Measure_STI_ORD=round(Wave_Measure_STI_ORD*10000)/10000;
    
    
    %%%%%%%%%%%%%% save into spreadsheet
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],col_header_STI,1,'A1');
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],row_header_STI,1,'A2');      %Write row header
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],Wave_Measure_STI,1,'B2');
    
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],col_header_STI,2,'A1');
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],row_header_STI_ORD,2,'A2');      %Write row header
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],Wave_Measure_STI_ORD,2,'B2');
    
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],{'Time(s)'},3,'A1');
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],row_header_STI.',3,'B1');      %Write row header
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],myTimeTicks.',3,'A2');
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],fig2_waves.',3,'B2');    
    
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],{'Time(s)'},4,'A1');
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],row_header_STI.',4,'B1');      %Write row header
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],myTimeTicks.',4,'A2');
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],fig3_waves.',4,'B2');
    
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],{'Time(s)'},5,'A1');
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],row_header_STI_ORD.',5,'B1');      %Write row header
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],myTimeTicks.',5,'A2');
    xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx'],fig4_waves.',5,'B2');

    
    
    % change the sheet name
    mysheetnames={'WP_Roi','WP_CapOrder','Abs_Diam_Roi','RltDiam_Roi','RltDiam_CapOrder'};
    xlsheets(mysheetnames,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_WaveInfo.xlsx']);
    try close(h3);end
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% save the propagation file
    if SkeletonExist
        
        if str2num(FrameNo1)*str2num(FrameNo2)
            if ishandle(31)
                %%% save the figures
                saveas(hd31,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_STIPropagation.fig']);
                saveas(hd31,[savingpathway,filesep,savingfilename,filesep,savingfilename,'_STIPropagation.jpg']);
                close(hd31);
                
            else
                warndlg('Figure with propagation does NOT exist!');
            end
            
            %%% save in excel file
            
            col_header11={'Uprising Latency (um/s)','Uprising Amp(%/um)','Falling Phase Latency - P (um/s)','Falling Phase AMP -N (%/um)','Falling Phase Latency - PN (um/s)','Falling Phase AMP -PN (%/um)'};
            
            row_header11={'Left Part';'Right Part'};
            
            xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_STIPropagation_Sum.xlsx'],col_header11,1,'B1');
            xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_STIPropagation_Sum.xlsx'],row_header11,1,'A2');      %Write row header
            xlswrite([savingpathway,filesep,savingfilename,filesep,savingfilename,'_STIPropagation_Sum.xlsx'],STIPropagationVel,1,'B2');
        end
        
    end
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% save AllParameters
    save([savingpathway,filesep,savingfilename,filesep,savingfilename,'_AllParameters','.mat'],'fig2_waves','fig3_waves','fig4_waves',...
        'fig5_waves','myTimeTicks','RestitchCord','CutImageCord1','CutImageCord2','ROINoPerCap','Wave_Measure_STI',...
        'STITimeTicks','STIExist','PuffStartTime','PuffEndTime','PuffExist','FrameTime','BaseLineFrameNo','FrameNo1','FrameNo2',...
        'PixelSize','ROIPosAll','avgFrame','vesselcount','LocNumAll','LocColorAll','LocNameAll','LegendAll','presetcolor',...
        'CutFrameNum1','CutFrameNum2','CutTime1','CutTime2','useNew','myVideo_New','myVideo','ROI_Geo_Distance','ROIWidthAll',...
        'Responses_EachROI','Responses_EachOrder','ROIfilenames',...
        'FFST','col_header_STI','PuffPropagationVel','STIPropagationVel','SkeletonInfo','ROINoPerCap','CutImageCord1','CutImageCord2');
    
    
    
    
    
    % close current window
    delete(get(hObject, 'parent'));    % close the current window/figure
    
    h4=msgbox('Finished!');
    pause(0.5);
    close(h4);
    try close(20);end
    
    
end









function savingfolder_Callback(hObject, eventdata, handles)


function savingfolder_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function openfolder_Callback(hObject, eventdata, handles)
folder_name = uigetdir;
set(handles.savingfolder,'String',folder_name);


function text2_CreateFcn(hObject, eventdata, handles)



function videofilename_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function videofilename_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
