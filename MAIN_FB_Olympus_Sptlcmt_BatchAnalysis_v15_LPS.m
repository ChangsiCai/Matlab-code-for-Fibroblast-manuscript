%% any locomotion between 30s and 35s which is higher than 1cm distance are defined as active locomotion. Less than 1cm is definied as without locomotion
clear all;clc;close all;

%% %% Parameter Settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Celltype='FB Locomotion New_NoAverage_LPS';

CurrentFolderName='D:\ChangsiCai\Chen He\1Chens projects';
SavingFolderName=[CurrentFolderName,filesep,'Results',filesep,Celltype];
if exist(SavingFolderName,'dir')~=7    % if not exist, create the folder
    mkdir(SavingFolderName);
end


SavingFolderName2=[SavingFolderName,filesep,'Individual Traces'];
if exist(SavingFolderName2,'dir')~=7    % if not exist, create the folder
    mkdir(SavingFolderName2);
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Filepath{1} = 'D:\ChangsiCai\Chen He\1Chens projects\Fibroblasts\Locomotion\OneWeekAfterLPS\Arachnoid FBS';
Filepath{2} = 'D:\ChangsiCai\Chen He\1Chens projects\Fibroblasts\Locomotion\OneWeekAfterLPS\BFB1b FBs';
Filepath{3} = 'D:\ChangsiCai\Chen He\1Chens projects\Fibroblasts\Locomotion\OneWeekAfterLPS\Endfeet of perivascular FBs';



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Premark the time range of locomotion
AFBSLcmtRangeMarks.DataNames{1} = 'Mouse15_Locb_20250117_no6';
AFBSLcmtRangeMarks.LcmtReg{1} =[40 60];
AFBSLcmtRangeMarks.BL{1} = [60 80];
AFBSLcmtRangeMarks.DataNames{2} = 'Mouse15_Locc_20250117_no14';
AFBSLcmtRangeMarks.LcmtReg{2} =[1 22];
AFBSLcmtRangeMarks.BL{2} = [35 90];
AFBSLcmtRangeMarks.DataNames{3} = 'Mouse39_Locb_20250117_no4';
AFBSLcmtRangeMarks.LcmtReg{3} =[55 70];
AFBSLcmtRangeMarks.BL{3} = [10 50];
AFBSLcmtRangeMarks.DataNames{4} = 'Mouse39_Locd_20250117_no8';
AFBSLcmtRangeMarks.LcmtReg{4} = [20 25];
AFBSLcmtRangeMarks.BL{4} = [1 20];
AFBSLcmtRangeMarks.DataNames{5} = 'Mouse214_Loca_20250114_no2';
AFBSLcmtRangeMarks.LcmtReg{5} = [18 50];
AFBSLcmtRangeMarks.BL{5} = [1 18];
AFBSLcmtRangeMarks.DataNames{6} = 'Mouse214_Locb_20250114_no7';
AFBSLcmtRangeMarks.LcmtReg{6} = [58 70];
AFBSLcmtRangeMarks.BL{6} = [10 55];
AFBSLcmtRangeMarks.DataNames{7} = 'Mouse214_Locd_20250114_no21';
AFBSLcmtRangeMarks.LcmtReg{7} = [20 50;68 NaN];
AFBSLcmtRangeMarks.BL{7} = [1 22];




BFB1b_sasLcmtRangeMarks.DataNames{1} = 'Mouse15_Locb_20250117_no6';
BFB1b_sasLcmtRangeMarks.LcmtReg{1} =[40 60];
BFB1b_sasLcmtRangeMarks.BL{1} = [20 40];
BFB1b_sasLcmtRangeMarks.DataNames{2} = 'Mouse15_Locc_20250117_no14';
BFB1b_sasLcmtRangeMarks.LcmtReg{2} =[1 22];
BFB1b_sasLcmtRangeMarks.BL{2} = [35 90];
BFB1b_sasLcmtRangeMarks.DataNames{3} = 'Mouse39_Locb_20250117_no4';
BFB1b_sasLcmtRangeMarks.LcmtReg{3} =[55 70];
BFB1b_sasLcmtRangeMarks.BL{3} = [10 50];
BFB1b_sasLcmtRangeMarks.DataNames{4} = 'Mouse39_Locd_20250117_no8';
BFB1b_sasLcmtRangeMarks.LcmtReg{4} =[20 25];
BFB1b_sasLcmtRangeMarks.BL{4} = [1 20];
BFB1b_sasLcmtRangeMarks.DataNames{5} = 'Mouse214_Loca_20250114_no2_left';
BFB1b_sasLcmtRangeMarks.LcmtReg{5} =[18 50];
BFB1b_sasLcmtRangeMarks.BL{5} = [1 18];
BFB1b_sasLcmtRangeMarks.DataNames{6} = 'Mouse214_Loca_20250114_no2_right';
BFB1b_sasLcmtRangeMarks.LcmtReg{6} =[18 50];
BFB1b_sasLcmtRangeMarks.BL{6} = [1 18];
BFB1b_sasLcmtRangeMarks.DataNames{7} = 'Mouse214_Locb_20250114_no7_left';
BFB1b_sasLcmtRangeMarks.LcmtReg{7} =[58 70];
BFB1b_sasLcmtRangeMarks.BL{7} = [30 50];
BFB1b_sasLcmtRangeMarks.DataNames{8} = 'Mouse214_Locd_20250114_no21_left';
BFB1b_sasLcmtRangeMarks.LcmtReg{8} =[20 50;68 NaN];
BFB1b_sasLcmtRangeMarks.BL{8} = [1 20];
BFB1b_sasLcmtRangeMarks.DataNames{9} = 'Mouse214_Locd_20250114_no21_right';
BFB1b_sasLcmtRangeMarks.LcmtReg{9} =[20 50;68 NaN];
BFB1b_sasLcmtRangeMarks.BL{9} = [1 20];



BFB1b_psLcmtRangeMarks.DataNames{1} = 'Mouse15_Locb_20250117_no6';
BFB1b_psLcmtRangeMarks.LcmtReg{1} =[40 60];
BFB1b_psLcmtRangeMarks.BL{1} = [20 40];
BFB1b_psLcmtRangeMarks.DataNames{2} = 'Mouse15_Locc_20250117_no14';
BFB1b_psLcmtRangeMarks.LcmtReg{2} =[1 22];
BFB1b_psLcmtRangeMarks.BL{2} = [20 40];
BFB1b_psLcmtRangeMarks.DataNames{3} = 'Mouse39_Locb_20250117_no4';
BFB1b_psLcmtRangeMarks.LcmtReg{3} =[55 70];
BFB1b_psLcmtRangeMarks.BL{3} = [30 50];
BFB1b_psLcmtRangeMarks.DataNames{4} = 'Mouse39_Locd_20250117_no8';
BFB1b_psLcmtRangeMarks.LcmtReg{4} =[20 25];
BFB1b_psLcmtRangeMarks.BL{4} = [1 20];
BFB1b_psLcmtRangeMarks.DataNames{5} = 'Mouse214_Loca_20250114_no2_left';
BFB1b_psLcmtRangeMarks.LcmtReg{5} =[18 50];
BFB1b_psLcmtRangeMarks.BL{5} = [1 18];
BFB1b_psLcmtRangeMarks.DataNames{6} = 'Mouse214_Loca_20250114_no2_right';
BFB1b_psLcmtRangeMarks.LcmtReg{6} =[18 50];
BFB1b_psLcmtRangeMarks.BL{6} = [1 18];
BFB1b_psLcmtRangeMarks.DataNames{7} = 'Mouse214_Locb_20250114_no7';
BFB1b_psLcmtRangeMarks.LcmtReg{7} =[58 70];
BFB1b_psLcmtRangeMarks.BL{7} = [30 50];
BFB1b_psLcmtRangeMarks.DataNames{8} = 'Mouse214_Locd_20250114_no21_left';
BFB1b_psLcmtRangeMarks.LcmtReg{8} =[20 50;68 NaN];
BFB1b_psLcmtRangeMarks.BL{8} = [1 20];
BFB1b_psLcmtRangeMarks.DataNames{9} = 'Mouse214_Locd_20250114_no21_right';
BFB1b_psLcmtRangeMarks.LcmtReg{9} =[20 50;68 NaN];
BFB1b_psLcmtRangeMarks.BL{9} = [1 20];






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PreDurt = -10;   %%%%%%% the perios used as baseline
ExaminedDurt = 49;    %%%%%% examine the period of 20s post whisking event
AirPuffEventDurt = 20;    %%%%%% i believe that the Ca, Diam back to baseline after air puff, and treat as spontaneous after that

TimeStampInterval = 0.05;

AirPuffTime = 40;

LcmtBin_Time = PreDurt:TimeStampInterval:ExaminedDurt;

Lcmt_shift_onset = 2;    % shift 2s towards left as onset of locomotion

MyMeanStdThld = 2.5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MouseInfo = struct();

MouseInfo.MouseID=[];
MouseInfo.LocID=[];
MouseInfo.ExpDate=[];
MouseInfo.RepNum=[];
MouseInfo.FrameTime=[];
MouseInfo.FullName=[];

AFBS.LcmtCountNum = 1;
AFBS.CaTraceCountNum = 1;
AFBS.LcmtTraceAll = NaN(100,length(LcmtBin_Time));
AFBS.DiamTraceAll = NaN(100,length(LcmtBin_Time));
AFBS.CaTraceAll = NaN(100,length(LcmtBin_Time));
AFBS.WhiskTraceAll = NaN(100,length(LcmtBin_Time));
AFBS.LcmtTraceDist = NaN(1,100);    % distance
AFBS.LcmtTraceDurt = NaN(1,100);    % duration

AFBS.DiamPeakAmp = NaN(1,100);
AFBS.CaPeakAmp = NaN(1,100);

AFBS.DiamAUC = NaN(1,100);
AFBS.CaAUC = NaN(1,100);

AFBS.WhiskDurt = NaN(1,100);

AFBS.DiamOnset = NaN(1,100);
AFBS.CaOnset = NaN(1,100);

AFBS.DiamDuration = NaN(1,100);  %%
AFBS.CaDuration = NaN(1,100);    %%

AFBS.DiamPeakTime = NaN(1,100);
AFBS.CaPeakTime = NaN(1,100);

AFBS.DiamRisingSlope = NaN(1,100);
AFBS.CaRisingSlope = NaN(1,100);

AFBS.DataName=[];

AFBS.CaTransReg = [];
AFBS.CaTransPeakX = [];
AFBS.CaTransPeakY = [];
AFBS.CaTransAUC = [];
AFBS.CaTransDurt = [];
AFBS.CaTransMask = NaN(100,length(LcmtBin_Time));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BFB1b_sas.LcmtCountNum = 1;
BFB1b_sas.CaTraceCountNum = 1;
BFB1b_sas.LcmtTraceAll = NaN(100,length(LcmtBin_Time));
BFB1b_sas.DiamTraceAll = NaN(100,length(LcmtBin_Time));
BFB1b_sas.CaTraceAll = NaN(100,length(LcmtBin_Time));
BFB1b_sas.WhiskTraceAll = NaN(100,length(LcmtBin_Time));
BFB1b_sas.LcmtTraceDist = NaN(1,100);    % distance
BFB1b_sas.LcmtTraceDurt = NaN(1,100);    % duration

BFB1b_sas.DiamPeakAmp = NaN(1,100);  %%
BFB1b_sas.CaPeakAmp = NaN(1,100);    %%

BFB1b_sas.DiamAUC = NaN(1,100);
BFB1b_sas.CaAUC = NaN(1,100);

BFB1b_sas.DiamAUC = NaN(1,100);
BFB1b_sas.WhiskDurt = NaN(1,100);

BFB1b_sas.DiamOnset = NaN(1,100);  %%
BFB1b_sas.CaOnset = NaN(1,100);    %%

BFB1b_sas.DiamDuration = NaN(1,100);  %%
BFB1b_sas.CaDuration = NaN(1,100);    %%

BFB1b_sas.DiamPeakTime = NaN(1,100);
BFB1b_sas.CaPeakTime = NaN(1,100);

BFB1b_sas.DiamRisingSlope = NaN(1,100);
BFB1b_sas.CaRisingSlope = NaN(1,100);

BFB1b_sas.DataName=[];

BFB1b_sas.CaTransReg = [];
BFB1b_sas.CaTransPeakX = [];
BFB1b_sas.CaTransPeakY = [];
BFB1b_sas.CaTransAUC = [];
BFB1b_sas.CaTransDurt = [];
BFB1b_sas.CaTransMask = NaN(100,length(LcmtBin_Time));


%%%%%%%%%%%%%%%%%%%%%%

BFB1b_ps.LcmtCountNum = 1;
BFB1b_ps.CaTraceCountNum = 1;
BFB1b_ps.LcmtTraceAll = NaN(100,length(LcmtBin_Time));
BFB1b_ps.DiamTraceAll = NaN(100,length(LcmtBin_Time));
BFB1b_ps.CaTraceAll = NaN(100,length(LcmtBin_Time));
BFB1b_ps.WhiskTraceAll = NaN(100,length(LcmtBin_Time));
BFB1b_ps.LcmtTraceDist = NaN(1,100);    % distance
BFB1b_ps.LcmtTraceDurt = NaN(1,100);    % duration

BFB1b_ps.DiamPeakAmp = NaN(1,100);
BFB1b_ps.CaPeakAmp = NaN(1,100);

BFB1b_ps.DiamAUC = NaN(1,100);
BFB1b_ps.CaAUC = NaN(1,100);

BFB1b_ps.WhiskDurt = NaN(1,100);

BFB1b_ps.DiamOnset = NaN(1,100);
BFB1b_ps.CaOnset = NaN(1,100);

BFB1b_ps.DiamDuration = NaN(1,100);  %%
BFB1b_ps.CaDuration = NaN(1,100);    %%

BFB1b_ps.DiamPeakTime = NaN(1,100);
BFB1b_ps.CaPeakTime = NaN(1,100);

BFB1b_ps.DiamRisingSlope = NaN(1,100);
BFB1b_ps.CaRisingSlope = NaN(1,100);

BFB1b_ps.DataName=[];


BFB1b_ps.CaTransReg = [];
BFB1b_ps.CaTransPeakX = [];
BFB1b_ps.CaTransPeakY = [];
BFB1b_ps.CaTransAUC = [];
BFB1b_ps.CaTransDurt = [];
BFB1b_ps.CaTransMask = NaN(100,length(LcmtBin_Time));

%%%%%%%%%%%%%%%%%%%%%%%%%

All_LcmtTraceStartTime = NaN(1,100);
All_LcmtTraceEndTime = NaN(1,100);
All_LcmtTraceName = cell(1,100);
All_LcmtTraceAgeGroup = cell(1,100);
All_LcmtCountNum = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%

PreDurt_PN = round(PreDurt/TimeStampInterval);   % point number (PN)
ExaminedDurt_PN = round(ExaminedDurt/TimeStampInterval);
AirPuffEventDurt_PN = round(AirPuffEventDurt/TimeStampInterval);

%%% sort the ROI legend

DataNumCount = 0;
DataNumCount_AllLoc = [0 0 0]; % the 5 numbers are the ROI number for each ROIrealname

ROILegendLut = {'AFBS','BFB1b_sas','BFB1b_ps'};
ROIRealName = {'AFBS','BFB1b_sas','BFB1b_ps'};
ROILegendColInd=[1 2 3];
ColorCollection='rbgymkc';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% excel file setting

ColName = {'MouseID','LocID','Date','CapOrder','DataType','PeakAmp','PeakTime','OnsetTime','Duration','FallingTime','AUC','RisingSlope'};
RowCount = 1;

DiamSummaryExcel=cell(100,12);
CaSummaryExcel=cell(100,12);
DiamCaDiffExcel=cell(100,12);



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hd10=figure(10);hold on;
subplot(5,2,1),hold on; title('Diameter overlay');
subplot(5,2,2),hold on; title('Calcium overlay');

for i = 1:length(Filepath)
    Allfiles = dir(Filepath{i});
    for j = 3:length(Allfiles)
        disp(['Working progress: folder ',num2str(i),' , file ',num2str(j-2),'/',num2str(length(Allfiles)-2)]);
        DataNumCount = DataNumCount + 1;
        LcmtBin_Time = PreDurt:TimeStampInterval:ExaminedDurt;

        %%%% CurrentDataInfo
        CurrentDataName = char(Allfiles(j).name);
        I1 = strfind(CurrentDataName,'_');
        MouseInfo.FullName{DataNumCount} = CurrentDataName;
        MouseInfo.MouseID{DataNumCount} = CurrentDataName(1:I1(1)-1);
        MouseInfo.LocID{DataNumCount}  = CurrentDataName(I1(1)+1:I1(2)-1);
        if length(I1==2)
            MouseInfo.ExpDate{DataNumCount}  = CurrentDataName(I1(2)+1:end);
        else
            MouseInfo.ExpDate{DataNumCount}  = CurrentDataName(I1(2)+1:I1(3)-1);
        end
        I2 = strfind(CurrentDataName,'Rep');
        if length(I2)
            MouseInfo.RepNum{DataNumCount}  = CurrentDataName(I2(1):I2(1)+3);
        else
            MouseInfo.RepNum{DataNumCount}  = 'Rep0';
        end

        CurrentDataName_figtitle = CurrentDataName;
        CurrentDataName_figtitle(I1) = '-';
        ThisDataName = CurrentDataName_figtitle;

        ThisData = [Allfiles(j).folder,filesep,Allfiles(j).name];

        hd1 = figure(1); clf(hd1);


        CurrentDataPath = [Allfiles(j).folder,filesep,Allfiles(j).name];
        filePattern_diam = dir([CurrentDataPath,filesep,'TPM',filesep,'*Dia_AllParameters.mat']);
        fullname_diam = [filePattern_diam.folder,filesep,filePattern_diam.name];
        load(fullname_diam);

        Diam_time = myTimeTicks;
        DiamWaves = fig4_waves;


        %%%% Read in EC Calcium
        filePattern_Ca = dir([CurrentDataPath,filesep,'TPM',filesep,'*_AnalysisParameters.mat']);
        fullname_Ca = [filePattern_Ca.folder,filesep,filePattern_Ca.name];
        LoadedCaData = load(fullname_Ca);

        if i==1
            DiamROINames = 'AFBS';
            CaROINames = 'AFBS';

            Ca_time = LoadedCaData.myTimeTicks;
            CaWaves = LoadedCaData.ROI_GCh_CaWave_All;
        elseif i==2
            DiamROINames = 'BFB1b_sas';
            CaROINames = 'BFB1b_sas';

            Ca_time = LoadedCaData.myTimeTicks;
            CaWaves = LoadedCaData.ROI_GCh_CaWave_All;
        elseif i==3
            DiamROINames = 'BFB1b_ps';
            CaROINames = 'BFB1b_ps';

            Ca_time = LoadedCaData.myTimeTag;
            CaWaves = LoadedCaData.EC_Ca_Signal_norm;
        end

        if isequal(length(Diam_time),length(Ca_time))
            myTime_TPM = Ca_time;
        else
            disp('Error 6: The two pial artery times are not identical');
            pause;
        end

        if size(DiamWaves,1)==1
            % CaWaves = mean(CaWaves,1);
            ;
        else
            disp('Error 0: multiple Diam curves.');
            pause;
        end

        %%%%%%%%%%%%%% read in locomotion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        filePattern_lcmt = dir([ThisData,filesep,'locomotion',filesep,'*AnalysisParameters.mat']);
        fullname_lcmt = [filePattern_lcmt.folder,filesep,filePattern_lcmt.name];
        if strcmp(fullname_lcmt,filesep)~=1
            load(fullname_lcmt);

            myTime_lcmt = LocomotionResults.Time;
            Speed_lcmt = LocomotionResults.SmoothSpeed;
            Speed_lcmt = smooth(Speed_lcmt,10);
            Speed_lcmt = smooth(Speed_lcmt,20);
            Mask_lcmt = zeros(size(Speed_lcmt));
            Mask_lcmt(find(Speed_lcmt>1))=1;
            % Mask_lcmt = LocomotionResults.BinnedSpeed;
        end

        %%%%%%%% interpolate the data to equalize the time stamp
        if strcmp(fullname_lcmt,filesep)~=1
            TimeLength = min([myTime_TPM(end) myTime_lcmt(end)]);
        else
            TimeLength = myTime_TPM(end);
        end
        TimeStampInterp = 0:TimeStampInterval:TimeLength;

        % if size(CaWaves,1)>1 && size(CaWaves,2)>1
        %     pause;
        % end

        Ca_waveNew_interp = zeros(size(CaWaves,1),length(TimeStampInterp));
        Diam_waveNew_interp = zeros(size(DiamWaves,1),length(TimeStampInterp));
        for k=1:size(CaWaves,1)
            Ca_tmp = CaWaves(k,:);

            %%%%%%%%%%% smooth
            Ca_tmp = smooth(Ca_tmp,3);
            Ca_tmp = smooth(Ca_tmp,5);

            %%%%%%%%%%% correct drifting baseline
            baseline2 = asLS_baseline_v1(Ca_tmp);
            Ca_tmp2 = Ca_tmp-baseline2+1;
            showMidImg = 0;
            if showMidImg
                hdTmp = figure;hold on;
                plot(Ca_tmp,'b');
                plot(baseline2,'b--');
                plot(Ca_tmp2,'r');

                pause;
                close(hdTmp);

            end
            %%%%%%%%%%%%%%%%%%


            Ca_tmp_interp = interp1(myTime_TPM,Ca_tmp,TimeStampInterp);
            Ca_waveNew_interp(k,:) = Ca_tmp_interp;

            Diam_tmp = DiamWaves;
            if length(myTime_TPM)-length(Diam_tmp)==1
                Diam_tmp = [NaN Diam_tmp];
            end

            %%%%%%%%%%% smooth
            Diam_tmp = smooth(Diam_tmp,3);
            Diam_tmp = smooth(Diam_tmp,5);
            %%%%%%%%%%%%%%%%%%

            Diam_tmp_interp = interp1(myTime_TPM,Diam_tmp(1:length(myTime_TPM)),TimeStampInterp);
            Diam_waveNew_interp(k,:) = Diam_tmp_interp;
        end

        if strcmp(fullname_lcmt,filesep)~=1
            Speed_lcmt_interp = interp1(myTime_lcmt,Speed_lcmt,TimeStampInterp);
            Mask_lcmt_interp = interp1(myTime_lcmt,double(Mask_lcmt),TimeStampInterp);
        end

        %%%%%%%%%%%% read in the baseline and normalize the baseline
        if i==1
            for kk = 1:length(AFBSLcmtRangeMarks.DataNames)
                ThisNameTmp = AFBSLcmtRangeMarks.DataNames{kk};
                if strcmp(ThisNameTmp,CurrentDataName)
                    ThisLcmtReg = AFBSLcmtRangeMarks.LcmtReg{kk};
                    ThisBL = AFBSLcmtRangeMarks.BL{kk};
                    continue;
                end
            end            

        elseif i==2
            for kk = 1:length(BFB1b_sasLcmtRangeMarks.DataNames)
                ThisNameTmp = BFB1b_sasLcmtRangeMarks.DataNames{kk};
                if strcmp(ThisNameTmp,CurrentDataName)
                    ThisLcmtReg = BFB1b_sasLcmtRangeMarks.LcmtReg{kk};
                    ThisBL = BFB1b_sasLcmtRangeMarks.BL{kk};
                    continue;
                end
            end 

        elseif i==3
            for kk = 1:length(BFB1b_psLcmtRangeMarks.DataNames)
                ThisNameTmp = BFB1b_psLcmtRangeMarks.DataNames{kk};
                if strcmp(ThisNameTmp,CurrentDataName)
                    ThisLcmtReg = BFB1b_psLcmtRangeMarks.LcmtReg{kk};
                    ThisBL = BFB1b_psLcmtRangeMarks.BL{kk};
                    continue;
                end
            end

        end

        %%%% normalize to the baseline
        II=[];

        for ttt = 1:size(ThisBL,1)
            
            IItemp = find(TimeStampInterp>=ThisBL(ttt,1) & TimeStampInterp<=ThisBL(ttt,2));
            II = [II IItemp];
        end

        if size(ThisBL,1)>=3
            xtemp = TimeStampInterp(II);
            ytemp = Ca_waveNew_interp(II);
            p = polyfit(xtemp,ytemp,1);
            Ca_BL_temp = polyval(p,TimeStampInterp);   % linear drift of the baseline, we gonna remove it
            Ca_waveNew_interp = Ca_waveNew_interp - Ca_BL_temp+1;
        end


        for k=1:size(Ca_waveNew_interp,1)
            Diam_waveNew_interp(k,:) = Diam_waveNew_interp(k,:)./mean(Diam_waveNew_interp(k,II));
            Ca_waveNew_interp(k,:) = Ca_waveNew_interp(k,:)./mean(Ca_waveNew_interp(k,II));
        end



        %%%%%%%%%%%%%%%%%%%%% plot
        hd1=figure(1);
        clf(hd1);

        hd1 = figure(1); hold on;
        subplot(3,1,1);hold on;
        ROIInd = find(strcmp(DiamROINames,ROIRealName));
        for k=1:size(Diam_waveNew_interp,1)
            plot(TimeStampInterp,Diam_waveNew_interp(k,:),'k');
            % legend(ROIRealName{ROIInd});
            plot(TimeStampInterp(II),Diam_waveNew_interp(k,II),'y-');
        end

        title([CurrentDataName_figtitle, '      Diameter',' (i=',num2str(i),' j=',num2str(j),')']);

        subplot(3,1,2);hold on;
        ROIInd = find(strcmp(CaROINames,ROIRealName));
        for k=1:size(Ca_waveNew_interp,1) 
            plot(TimeStampInterp,Ca_waveNew_interp(k,:),ColorCollection(k));
            plot(TimeStampInterp(II),Ca_waveNew_interp(k,II),'y-');
        end
        % legend(ROIRealName{ROIInd});
        
        title('Calcium');

        if strcmp(fullname_lcmt,filesep)~=1
            subplot(3,1,3);hold on;
            plot(TimeStampInterp,Speed_lcmt_interp,'k');
            mylim=ylim;
            area(TimeStampInterp,Mask_lcmt_interp*mylim(2)*0.99,'FaceAlpha',0.2,'FaceColor','g','EdgeColor','none');
            title('Locomotion');
            ylabel('Speed (cm/s)');
            xlabel('Time (s)');
        end

        CaBLcurves = Ca_waveNew_interp(II);


        %%%%%% equalize all three subplots
        % subplot(3,1,1);mylim=ylim;plot([AirPuffTime AirPuffTime],mylim*0.99,'m--');
        % subplot(3,1,2);mylim=ylim;plot([AirPuffTime AirPuffTime],mylim*0.99,'m--');
        % subplot(3,1,3);mylim=ylim;plot([AirPuffTime AirPuffTime],mylim*0.99,'m--');


        subplot(3,1,1);hold on;xlim([0 TimeLength]);
        subplot(3,1,2);hold on;xlim([0 TimeLength]);
        subplot(3,1,3);hold on;xlim([0 TimeLength]);



        %%%%%%%%% start to analyze the spontaneous %%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% locomotion %%%%%%%%%%%%%%%%%%%
        for k2 = 1:size(ThisLcmtReg,1)

            LcmtBin_Time = PreDurt:TimeStampInterval:ExaminedDurt;

            x1 = ThisLcmtReg(k2,1);
            x2 = ThisLcmtReg(k2,2);

            if isnan(x2)
                x2 = TimeStampInterp(end);
            end

            [C,I] = find(TimeStampInterp>x1 & TimeStampInterp<x2);
            LcmtCut = Speed_lcmt_interp(I);
            LcmtMaskCut0 = Mask_lcmt_interp(I);
            [C2,I2] = find(LcmtMaskCut0);

            LcmtStartTime = TimeStampInterp(I(1)+I2(1)-1)-Lcmt_shift_onset;
            if LcmtStartTime<=0
                LcmtStartTime = 0;
            end
            LcmtEndTime = TimeStampInterp(I(1)+I2(end)-1);

            subplot(3,1,1);
            ylim_right1 = get(gca, 'YLim');
            plot([LcmtStartTime LcmtStartTime],ylim_right1,'k-');
            subplot(3,1,2);
            ylim_right2 = get(gca, 'YLim');
            plot([LcmtStartTime LcmtStartTime],ylim_right2,'k-');
            subplot(3,1,3);
            ylim_right3 = get(gca, 'YLim');
            plot([LcmtStartTime LcmtStartTime],ylim_right3,'k-');

            subplot(3,1,2),plot([LcmtEndTime LcmtEndTime],ylim_right2,'k--');
            subplot(3,1,1),plot([LcmtEndTime LcmtEndTime],ylim_right1,'k--');
            subplot(3,1,3),plot([LcmtEndTime LcmtEndTime],ylim_right3,'k--');

            LcmtMaskCut00 = Mask_lcmt_interp(I(1)+I2(1)-1:I(1)+I2(end)-1);
            LcmtDurt = LcmtEndTime - LcmtStartTime;
            LcmtCutT1 = LcmtStartTime+PreDurt;
            LcmtCutT2 = LcmtStartTime+ExaminedDurt;

            if LcmtCutT2>TimeStampInterp(end)
                LcmtCutT2 = TimeStampInterp(end);
            end

            % cut the curves out
            [C4,I4] = find(TimeStampInterp>=LcmtCutT1 & TimeStampInterp<=LcmtCutT2);
            [C5,I5] = find(TimeStampInterp>=LcmtCutT1 & TimeStampInterp<=LcmtStartTime);
            [C6,I6] = find(TimeStampInterp>=LcmtStartTime & TimeStampInterp<=LcmtCutT2);
            LcmtCutTrace = Speed_lcmt_interp(I4);
            LcmtMaskCut = Mask_lcmt_interp(I4);

            DiamCutTrace = Diam_waveNew_interp(:,I4);
            CaCutTrace = Ca_waveNew_interp(:,I4);

            if length(isnan(DiamCutTrace))~=0  && isnan(DiamCutTrace(1))
                LcmtBin_Time = LcmtBin_Time - LcmtCutT1;
            end

            ThisOrderName_Ca=CaROINames;
            ThisOrderName_Diam=DiamROINames;

            

            if strcmp(ThisOrderName_Ca,'BFB1b_sas')
                
                if BFB1b_sas.LcmtCountNum==1
                    hd10=figure(10);hold on;
                    subplot(3,2,3), hold on;
                    plot(LcmtBin_Time(1:size(DiamCutTrace,2)),DiamCutTrace,'b-');
                    title('BFB1b-sas Diam');
                    subplot(3,2,4), hold on;
                    plot(LcmtBin_Time(1:length(CaCutTrace)),CaCutTrace,'b-');
                    title('BFB1b-sas Ca');
                    DiamLastTrace_pa = DiamCutTrace;
                    CaLastTrace_pa = CaCutTrace;
                else
                    hd10=figure(10);hold on;
                    subplot(3,2,3), hold on;
                    plot(LcmtBin_Time(1:size(DiamLastTrace_pa,2)),DiamLastTrace_pa,'Color',[0.8 0.8 0.8]);
                    subplot(3,2,4),hold on;
                    plot(LcmtBin_Time(1:size(CaLastTrace_pa,2)),CaLastTrace_pa,'Color',[0.8 0.8 0.8]);
                    subplot(3,2,3), hold on;
                    plot(LcmtBin_Time(1:size(DiamCutTrace,2)),DiamCutTrace,'b-');
                    title('BFB1b-sas Diam');
                    subplot(3,2,4),hold on;
                    plot(LcmtBin_Time(1:size(CaCutTrace,2)),CaCutTrace,'b-');
                    title('BFB1b-sas Ca');

                    DiamLastTrace_pa = DiamCutTrace;
                    CaLastTrace_pa = CaCutTrace;
                end

                BFB1b_sas.LcmtTraceAll(BFB1b_sas.LcmtCountNum,1:length(LcmtCutTrace)) = LcmtCutTrace;
                BFB1b_sas.DiamTraceAll(BFB1b_sas.CaTraceCountNum:BFB1b_sas.CaTraceCountNum+size(CaCutTrace,1)-1,1:length(LcmtCutTrace)) = DiamCutTrace;
                BFB1b_sas.CaTraceAll(BFB1b_sas.CaTraceCountNum:BFB1b_sas.CaTraceCountNum+size(CaCutTrace,1)-1,1:length(LcmtCutTrace)) = CaCutTrace;
                % BFB1b_sas.WhiskTraceAll(BFB1b_sas.LcmtCountNum,1:length(LcmtCutTrace)) = WhiskingCutTrace;
                BFB1b_sas.LcmtTraceDist(BFB1b_sas.LcmtCountNum) = sum(LcmtMaskCut0.*LcmtCut).*TimeStampInterval;
                BFB1b_sas.LcmtTraceDurt(BFB1b_sas.LcmtCountNum) = sum(LcmtMaskCut0).*TimeStampInterval;

                for k = 1:size(CaCutTrace,1)
                    %%%% find onset
                    Diamtmp = DiamCutTrace(k,:);
                    Catmp = CaCutTrace(k,:);
                    Timetmp = LcmtBin_Time(1:size(DiamCutTrace,2));

                    %%%% diam
                    [PeakAmp,PeakTime,OnsetTime,Duration,AUC,RisingSlope] = AnalysisPeaks_Cdh5_Lcmt_precise_ThldAvg2Std(Timetmp,Diamtmp,0,LcmtDurt+10,'BFB1b-sas Diam',PreDurt);
                    BFB1b_sas.DiamOnset(BFB1b_sas.CaTraceCountNum+k-1) = OnsetTime;
                    BFB1b_sas.DiamPeakAmp(BFB1b_sas.CaTraceCountNum+k-1) = PeakAmp;
                    BFB1b_sas.DiamDuration(BFB1b_sas.CaTraceCountNum+k-1) = Duration;
                    BFB1b_sas.DiamAUC(BFB1b_sas.CaTraceCountNum+k-1) = AUC;
                    BFB1b_sas.DiamPeakTime(BFB1b_sas.CaTraceCountNum+k-1) = PeakTime;
                    BFB1b_sas.DiamRisingSlope(BFB1b_sas.CaTraceCountNum+k-1) = RisingSlope;

                    hd1=figure(1);
                    subplot(3,1,1), hold on;
                    mylim=ylim; yll=mylim(2)-mylim(1);
                    fill([LcmtStartTime+OnsetTime, LcmtStartTime+OnsetTime+Duration, LcmtStartTime+OnsetTime+Duration, LcmtStartTime+OnsetTime],[0.35*yll+mylim(1) 0.35*yll+mylim(1) 0.65*yll+mylim(1) 0.65*yll+mylim(1)],'cyan','FaceAlpha',0.2);

                    %%%% register in excel
                    DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,1} = CurrentDataName(1:I1(1)-1);
                    DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,2} = CurrentDataName(I1(1)+1:I1(2)-1);
                    DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,3} = MouseInfo.ExpDate{DataNumCount};
                    DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,4} = 'BFB1b_sas';
                    DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,5} = 'Diam';
                    DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,6} = PeakAmp;
                    DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,7} = PeakTime;
                    DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,8} = OnsetTime;
                    DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,9} = Duration;
                    DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,10} = OnsetTime+Duration;
                    DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,11} = AUC;
                    DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,12} = RisingSlope;

                    %%%% ca
                    [PeakAmp,PeakTime,OnsetTime,Duration,AUC,RisingSlope,CaTransReg,CaTransPeakX,CaTransPeakY,CaTransAUC,CaTransDurt,CaTransMask] = AnalysisPeaks_Lcmt_ThldAvg2Std_4FBCa_AllTime_v9(Timetmp,Catmp,0,OnsetTime+Duration+10,'BFB1b-sas Ca',PreDurt,CaBLcurves);
                    BFB1b_sas.CaOnset(BFB1b_sas.CaTraceCountNum+k-1) = OnsetTime;
                    BFB1b_sas.CaPeakAmp(BFB1b_sas.CaTraceCountNum+k-1) = PeakAmp;
                    BFB1b_sas.CaDuration(BFB1b_sas.CaTraceCountNum+k-1) = Duration;
                    BFB1b_sas.CaAUC(BFB1b_sas.CaTraceCountNum+k-1) = AUC;
                    BFB1b_sas.CaPeakTime(BFB1b_sas.CaTraceCountNum+k-1) = PeakTime;
                    BFB1b_sas.CaRisingSlope(BFB1b_sas.CaTraceCountNum+k-1) = RisingSlope;
                    BFB1b_sas.CaTransReg{BFB1b_sas.CaTraceCountNum+k-1} = CaTransReg;
                    BFB1b_sas.CaTransPeakX{BFB1b_sas.CaTraceCountNum+k-1} = CaTransPeakX;
                    BFB1b_sas.CaTransPeakY{BFB1b_sas.CaTraceCountNum+k-1} = CaTransPeakY;

                    BFB1b_sas.CaTransAUC{BFB1b_sas.CaTraceCountNum+k-1} = CaTransAUC;
                    BFB1b_sas.CaTransDurt{BFB1b_sas.CaTraceCountNum+k-1} = CaTransDurt;
                    BFB1b_sas.CaTransMask(BFB1b_sas.CaTraceCountNum+k-1,1:length(LcmtCutTrace)) = CaTransMask;

                    hd1=figure(1);
                    subplot(3,1,2);mylim=ylim; yll=mylim(2)-mylim(1);
                    CaTransReg = CaTransReg + LcmtStartTime;
                    if ~isnan(CaTransReg)
                        for kkk=1:size(CaTransReg,1)
                            fill([CaTransReg(kkk,1), CaTransReg(kkk,2), CaTransReg(kkk,2), CaTransReg(kkk,1)],[0.35*yll+mylim(1) 0.35*yll+mylim(1) 0.65*yll+mylim(1) 0.65*yll+mylim(1)],'magenta','FaceAlpha',0.2);
                        end
                        if kkk>=2
                            pause(0.1);
                        end
                    end

                    %%%% register in excel
                    CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,1} = CurrentDataName(1:I1(1)-1);
                    CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,2} = CurrentDataName(I1(1)+1:I1(2)-1);
                    CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,3} = MouseInfo.ExpDate{DataNumCount};
                    CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,4} = 'BFB1b_sas';
                    CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,5} = 'Ca';
                    CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,6} = PeakAmp;
                    CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,7} = PeakTime;
                    CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,8} = OnsetTime;
                    CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,9} = Duration;
                    CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,10} = OnsetTime+Duration;
                    CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,11} = AUC;
                    CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,12} = RisingSlope;
                    DiamCaDiffExcel{BFB1b_sas.CaTraceCountNum+k-1,1} = CurrentDataName(1:I1(1)-1);
                    DiamCaDiffExcel{BFB1b_sas.CaTraceCountNum+k-1,2} = CurrentDataName(I1(1)+1:I1(2)-1);
                    DiamCaDiffExcel{BFB1b_sas.CaTraceCountNum+k-1,3} = MouseInfo.ExpDate{DataNumCount};
                    DiamCaDiffExcel{BFB1b_sas.CaTraceCountNum+k-1,4} = 'BFB1b_sas';
                    DiamCaDiffExcel{BFB1b_sas.CaTraceCountNum+k-1,5} = 'DiamCa';
                    DiamCaDiffExcel{BFB1b_sas.CaTraceCountNum+k-1,6} = DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,6} - CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,6};
                    DiamCaDiffExcel{BFB1b_sas.CaTraceCountNum+k-1,7} = DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,7} - CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,7};
                    DiamCaDiffExcel{BFB1b_sas.CaTraceCountNum+k-1,8} = DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,8} - CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,8};
                    DiamCaDiffExcel{BFB1b_sas.CaTraceCountNum+k-1,9} = DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,9} - CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,9};
                    DiamCaDiffExcel{BFB1b_sas.CaTraceCountNum+k-1,10} = DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,10} - CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,10};
                    DiamCaDiffExcel{BFB1b_sas.CaTraceCountNum+k-1,11} = DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,11} - CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,11};
                    DiamCaDiffExcel{BFB1b_sas.CaTraceCountNum+k-1,12} = DiamSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,12} - CaSummaryExcel{BFB1b_sas.CaTraceCountNum+k-1,12};

                    BFB1b_sas.DataName{BFB1b_sas.CaTraceCountNum+k-1} = CurrentDataName;
                end

                % BFB1b_sas.DataName{BFB1b_sas.LcmtCountNum} = CurrentDataName;
                BFB1b_sas.LcmtCountNum = BFB1b_sas.LcmtCountNum+1;
                BFB1b_sas.CaTraceCountNum = BFB1b_sas.CaTraceCountNum + size(CaCutTrace,1);



            elseif strcmp(ThisOrderName_Ca,'BFB1b_ps')
                
                if BFB1b_ps.LcmtCountNum==1
                    hd10=figure(10);hold on;
                    subplot(3,2,5), hold on;
                    plot(LcmtBin_Time(1:size(DiamCutTrace,2)),DiamCutTrace,'g-');
                    title('BFB1b-pialsheath Diam');
                    subplot(3,2,6), hold on;
                    plot(LcmtBin_Time(1:length(CaCutTrace)),CaCutTrace,'g-');
                    title('BFB1b-pialsheath Ca');
                    DiamLastTrace_BFB1b_ps = DiamCutTrace;
                    CaLastTrace_BFB1b_ps = CaCutTrace;
                else
                    hd10=figure(10);hold on;
                    subplot(3,2,5), hold on;
                    plot(LcmtBin_Time(1:size(DiamLastTrace_BFB1b_ps,2)),DiamLastTrace_BFB1b_ps,'Color',[0.8 0.8 0.8]);
                    subplot(3,2,6), hold on;
                    plot(LcmtBin_Time(1:size(CaLastTrace_BFB1b_ps,2)),CaLastTrace_BFB1b_ps,'Color',[0.8 0.8 0.8]);
                    subplot(3,2,5), hold on;
                    plot(LcmtBin_Time(1:size(DiamCutTrace,2)),DiamCutTrace,'g-');
                    title('BFB1b-pialsheath Diam');
                    subplot(3,2,6), hold on;
                    plot(LcmtBin_Time(1:size(CaCutTrace,2)),CaCutTrace,'g-');
                    title('BFB1b-pialsheath Ca');

                    DiamLastTrace_BFB1b_ps = DiamCutTrace;
                    CaLastTrace_BFB1b_ps = CaCutTrace;
                end


                BFB1b_ps.LcmtTraceAll(BFB1b_ps.LcmtCountNum,1:length(LcmtCutTrace)) = LcmtCutTrace;
                BFB1b_ps.DiamTraceAll(BFB1b_ps.CaTraceCountNum:BFB1b_ps.CaTraceCountNum+size(CaCutTrace,1)-1,1:length(LcmtCutTrace)) = DiamCutTrace;
                BFB1b_ps.CaTraceAll(BFB1b_ps.CaTraceCountNum:BFB1b_ps.CaTraceCountNum+size(CaCutTrace,1)-1,1:length(LcmtCutTrace)) = CaCutTrace;
                % BFB1b_ps.WhiskTraceAll(BFB1b_ps.LcmtCountNum,1:length(LcmtCutTrace)) = WhiskingCutTrace;
                BFB1b_ps.LcmtTraceDist(BFB1b_ps.LcmtCountNum) = sum(LcmtMaskCut0.*LcmtCut).*TimeStampInterval;
                BFB1b_ps.LcmtTraceDurt(BFB1b_ps.LcmtCountNum) = sum(LcmtMaskCut0).*TimeStampInterval;

                for k = 1:size(CaCutTrace,1)

                    %%%% find onset
                    Diamtmp = DiamCutTrace(k,:);
                    Catmp = CaCutTrace(k,:);
                    Timetmp = LcmtBin_Time(1:size(DiamCutTrace,2));

                    %%%% diam
                    [PeakAmp,PeakTime,OnsetTime,Duration,AUC,RisingSlope] = AnalysisPeaks_Cdh5_Lcmt_precise_ThldAvg2Std(Timetmp,Diamtmp,0,LcmtDurt+10,'BFB1b-pialsheath Diam',PreDurt);
                    BFB1b_ps.DiamOnset(BFB1b_ps.LcmtCountNum) = OnsetTime;
                    BFB1b_ps.DiamPeakAmp(BFB1b_ps.LcmtCountNum) = PeakAmp;
                    BFB1b_ps.DiamDuration(BFB1b_ps.LcmtCountNum) = Duration;
                    BFB1b_ps.DiamAUC(BFB1b_ps.LcmtCountNum) = AUC;
                    BFB1b_ps.DiamPeakTime(BFB1b_ps.LcmtCountNum) = PeakTime;
                    BFB1b_ps.DiamRisingSlope(BFB1b_ps.LcmtCountNum) = RisingSlope;

                    hd1=figure(1);
                    subplot(3,1,1), hold on;
                    mylim=ylim; yll=mylim(2)-mylim(1);
                    fill([LcmtStartTime+OnsetTime, LcmtStartTime+OnsetTime+Duration, LcmtStartTime+OnsetTime+Duration, LcmtStartTime+OnsetTime],[0.35*yll+mylim(1) 0.35*yll+mylim(1) 0.65*yll+mylim(1) 0.65*yll+mylim(1)],'cyan','FaceAlpha',0.2);

                    %%%% register in excel
                    DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,1} = CurrentDataName(1:I1(1)-1);
                    DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,2} = CurrentDataName(I1(1)+1:I1(2)-1);
                    DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,3} = MouseInfo.ExpDate{DataNumCount};
                    DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,4} = 'BFB1b_ps';
                    DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,5} = 'Diam';
                    DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,6} = PeakAmp;
                    DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,7} = PeakTime;
                    DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,8} = OnsetTime;
                    DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,9} = Duration;
                    DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,10} = OnsetTime+Duration;
                    DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,11} = AUC;
                    DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,12} = RisingSlope;


                    %%%% ca
                    [PeakAmp,PeakTime,OnsetTime,Duration,AUC,RisingSlope,CaTransReg,CaTransPeakX,CaTransPeakY,CaTransAUC,CaTransDurt,CaTransMask] = AnalysisPeaks_Lcmt_ThldAvg2Std_4FBCa_AllTime_v9(Timetmp,Catmp,0,OnsetTime+Duration+10,'BFB1b-pialsheath Ca',PreDurt,CaBLcurves);
                    BFB1b_ps.CaOnset(BFB1b_ps.CaTraceCountNum+k-1) = OnsetTime;
                    BFB1b_ps.CaPeakAmp(BFB1b_ps.CaTraceCountNum+k-1) = PeakAmp;
                    BFB1b_ps.CaDuration(BFB1b_ps.CaTraceCountNum+k-1) = Duration;
                    BFB1b_ps.CaAUC(BFB1b_ps.CaTraceCountNum+k-1) = AUC;
                    BFB1b_ps.CaPeakTime(BFB1b_ps.CaTraceCountNum+k-1) = PeakTime;
                    BFB1b_ps.CaRisingSlope(BFB1b_ps.CaTraceCountNum+k-1) = RisingSlope;
                    BFB1b_ps.CaTransReg{BFB1b_ps.CaTraceCountNum+k-1} = CaTransReg;
                    BFB1b_ps.CaTransPeakX{BFB1b_ps.CaTraceCountNum+k-1} = CaTransPeakX;
                    BFB1b_ps.CaTransPeakY{BFB1b_ps.CaTraceCountNum+k-1} = CaTransPeakY;

                    BFB1b_ps.CaTransAUC{BFB1b_ps.CaTraceCountNum+k-1} = CaTransAUC;
                    BFB1b_ps.CaTransDurt{BFB1b_ps.CaTraceCountNum+k-1} = CaTransDurt;
                    BFB1b_ps.CaTransMask(BFB1b_ps.CaTraceCountNum+k-1,1:length(LcmtCutTrace)) = CaTransMask;

                    hd1=figure(1);
                    subplot(3,1,2);mylim=ylim; yll=mylim(2)-mylim(1);
                    CaTransReg = CaTransReg + LcmtStartTime;
                    if ~isnan(CaTransReg)
                        for kkk=1:size(CaTransReg,1)
                            fill([CaTransReg(kkk,1), CaTransReg(kkk,2), CaTransReg(kkk,2), CaTransReg(kkk,1)],[0.35*yll+mylim(1) 0.35*yll+mylim(1) 0.65*yll+mylim(1) 0.65*yll+mylim(1)],'magenta','FaceAlpha',0.2);
                        end
                        if kkk>=2
                            pause(0.1);
                        end
                    end

                    %%%% register in excel
                    CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,1} = CurrentDataName(1:I1(1)-1);
                    CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,2} = CurrentDataName(I1(1)+1:I1(2)-1);
                    CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,3} = MouseInfo.ExpDate{DataNumCount};
                    CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,4} = 'BFB1b_ps';
                    CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,5} = 'Ca';
                    CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,6} = PeakAmp;
                    CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,7} = PeakTime;
                    CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,8} = OnsetTime;
                    CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,9} = Duration;
                    CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,10} = OnsetTime+Duration;
                    CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,11} = AUC;
                    CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,12} = RisingSlope;
                    DiamCaDiffExcel{BFB1b_ps.CaTraceCountNum+k-1,1} = CurrentDataName(1:I1(1)-1);
                    DiamCaDiffExcel{BFB1b_ps.CaTraceCountNum+k-1,2} = CurrentDataName(I1(1)+1:I1(2)-1);
                    DiamCaDiffExcel{BFB1b_ps.CaTraceCountNum+k-1,3} = MouseInfo.ExpDate{DataNumCount};
                    DiamCaDiffExcel{BFB1b_ps.CaTraceCountNum+k-1,4} = 'BFB1b_ps';
                    DiamCaDiffExcel{BFB1b_ps.CaTraceCountNum+k-1,5} = 'DiamCa';
                    DiamCaDiffExcel{BFB1b_ps.CaTraceCountNum+k-1,6} = DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,6} - CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,6};
                    DiamCaDiffExcel{BFB1b_ps.CaTraceCountNum+k-1,7} = DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,7} - CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,7};
                    DiamCaDiffExcel{BFB1b_ps.CaTraceCountNum+k-1,8} = DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,8} - CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,8};
                    DiamCaDiffExcel{BFB1b_ps.CaTraceCountNum+k-1,9} = DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,9} - CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,9};
                    DiamCaDiffExcel{BFB1b_ps.CaTraceCountNum+k-1,10} = DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,10} - CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,10};
                    DiamCaDiffExcel{BFB1b_ps.CaTraceCountNum+k-1,11} = DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,11} - CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,11};
                    DiamCaDiffExcel{BFB1b_ps.CaTraceCountNum+k-1,12} = DiamSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,12} - CaSummaryExcel{BFB1b_ps.CaTraceCountNum+k-1,12};

                    BFB1b_ps.DataName{BFB1b_ps.CaTraceCountNum+k-1} = CurrentDataName;

                end

                % BFB1b_ps.DataName{BFB1b_ps.LcmtCountNum} = CurrentDataName;
                BFB1b_ps.LcmtCountNum = BFB1b_ps.LcmtCountNum+1;
                BFB1b_ps.CaTraceCountNum = BFB1b_ps.CaTraceCountNum + size(CaCutTrace,1);




            elseif strcmp(ThisOrderName_Ca,'AFBS')
                
                if AFBS.LcmtCountNum==1
                    hd10=figure(10);hold on;
                    subplot(3,2,1), hold on;
                    plot(LcmtBin_Time(1:size(DiamCutTrace,2)),DiamCutTrace,'r-');
                    title('AFBS Diam');
                    subplot(3,2,2), hold on;
                    plot(LcmtBin_Time(1:length(CaCutTrace)),CaCutTrace,'r-');
                    title('AFBS Ca');
                    DiamLastTrace_pial = DiamCutTrace;
                    CaLastTrace_pial = CaCutTrace;
                else
                    hd10=figure(10);hold on;
                    subplot(3,2,1), hold on;
                    plot(LcmtBin_Time(1:size(DiamLastTrace_pial,2)),DiamLastTrace_pial,'Color',[0.8 0.8 0.8]);
                    subplot(3,2,2),hold on;
                    plot(LcmtBin_Time(1:size(CaLastTrace_pial,2)),CaLastTrace_pial,'Color',[0.8 0.8 0.8]);
                    subplot(3,2,1), hold on;
                    plot(LcmtBin_Time(1:size(DiamCutTrace,2)),DiamCutTrace,'r-');
                    title('AFBS Diam');
                    subplot(3,2,2),hold on;
                    plot(LcmtBin_Time(1:size(CaCutTrace,2)),CaCutTrace,'r-');
                    title('AFBS Ca');

                    DiamLastTrace_pial = DiamCutTrace;
                    CaLastTrace_pial = CaCutTrace;
                end


                AFBS.LcmtTraceAll(AFBS.LcmtCountNum,1:length(LcmtCutTrace)) = LcmtCutTrace;
                AFBS.DiamTraceAll(AFBS.CaTraceCountNum:AFBS.CaTraceCountNum+size(CaCutTrace,1)-1,1:length(LcmtCutTrace)) = DiamCutTrace;
                AFBS.CaTraceAll(AFBS.CaTraceCountNum:AFBS.CaTraceCountNum+size(CaCutTrace,1)-1,1:length(LcmtCutTrace)) = CaCutTrace;
                % AFBS.WhiskTraceAll(AFBS.LcmtCountNum,1:length(LcmtCutTrace)) = WhiskingCutTrace;
                AFBS.LcmtTraceDist(AFBS.LcmtCountNum) = sum(LcmtMaskCut0.*LcmtCut).*TimeStampInterval;
                AFBS.LcmtTraceDurt(AFBS.LcmtCountNum) = sum(LcmtMaskCut0).*TimeStampInterval;


                for k = 1:size(CaCutTrace,1)
                    %%%% find onset
                    Diamtmp = DiamCutTrace(k,:);
                    Catmp = CaCutTrace(k,:);
                    Timetmp = LcmtBin_Time(1:size(DiamCutTrace,2));

                    %%%% diam
                    [PeakAmp,PeakTime,OnsetTime,Duration,AUC,RisingSlope] = AnalysisPeaks_Cdh5_Lcmt_precise_ThldAvg2Std(Timetmp,Diamtmp,0,LcmtDurt+10,'AFBS Diam',PreDurt);
                    AFBS.DiamOnset(AFBS.CaTraceCountNum+k-1) = OnsetTime;
                    AFBS.DiamPeakAmp(AFBS.CaTraceCountNum+k-1) = PeakAmp;
                    AFBS.DiamDuration(AFBS.CaTraceCountNum+k-1) = Duration;
                    AFBS.DiamAUC(AFBS.CaTraceCountNum+k-1) = AUC;
                    AFBS.DiamPeakTime(AFBS.CaTraceCountNum+k-1) = PeakTime;
                    AFBS.DiamRisingSlope(AFBS.CaTraceCountNum+k-1) = RisingSlope;

                    hd1=figure(1);
                    subplot(3,1,1), hold on;
                    mylim=ylim; yll=mylim(2)-mylim(1);
                    fill([LcmtStartTime+OnsetTime, LcmtStartTime+OnsetTime+Duration, LcmtStartTime+OnsetTime+Duration, LcmtStartTime+OnsetTime],[0.35*yll+mylim(1) 0.35*yll+mylim(1) 0.65*yll+mylim(1) 0.65*yll+mylim(1)],'cyan','FaceAlpha',0.2);


                    %%%% register in excel
                    DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,1} = CurrentDataName(1:I1(1)-1);
                    DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,2} = CurrentDataName(I1(1)+1:I1(2)-1);
                    DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,3} = MouseInfo.ExpDate{DataNumCount};
                    DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,4} = 'AFBS';
                    DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,5} = 'Diam';
                    DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,6} = PeakAmp;
                    DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,7} = PeakTime;
                    DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,8} = OnsetTime;
                    DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,9} = Duration;
                    DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,10} = OnsetTime+Duration;
                    DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,11} = AUC;
                    DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,12} = RisingSlope;


                    %%%% ca
                    [PeakAmp,PeakTime,OnsetTime,Duration,AUC,RisingSlope,CaTransReg,CaTransPeakX,CaTransPeakY,CaTransAUC,CaTransDurt,CaTransMask] = AnalysisPeaks_Lcmt_ThldAvg2Std_4FBCa_AllTime_v9(Timetmp,Catmp,0,OnsetTime+Duration+10,'AFBS Ca',PreDurt,CaBLcurves);
                    AFBS.CaOnset(AFBS.CaTraceCountNum+k-1) = OnsetTime;
                    AFBS.CaPeakAmp(AFBS.CaTraceCountNum+k-1) = PeakAmp;
                    AFBS.CaDuration(AFBS.CaTraceCountNum+k-1) = Duration;
                    AFBS.CaAUC(AFBS.CaTraceCountNum+k-1) = AUC;
                    AFBS.CaPeakTime(AFBS.CaTraceCountNum+k-1) = PeakTime;
                    AFBS.CaRisingSlope(AFBS.CaTraceCountNum+k-1) = RisingSlope;
                    AFBS.CaTransReg{AFBS.CaTraceCountNum+k-1} = CaTransReg;
                    AFBS.CaTransPeakX{AFBS.CaTraceCountNum+k-1} = CaTransPeakX;
                    AFBS.CaTransPeakY{AFBS.CaTraceCountNum+k-1} = CaTransPeakY;
                    AFBS.CaTransAUC{AFBS.CaTraceCountNum+k-1} = CaTransAUC;
                    AFBS.CaTransDurt{AFBS.CaTraceCountNum+k-1} = CaTransDurt;
                    AFBS.CaTransMask(AFBS.CaTraceCountNum+k-1,1:length(LcmtCutTrace)) = CaTransMask;
                    %
                    % hd1=figure(1);
                    % subplot(3,1,2);mylim=ylim; yll=mylim(2)-mylim(1);
                    % CaOnIndex = CaOnIndex + LcmtStartTime;
                    % if ~isnan(CaOnIndex)
                    %     for kkk=1:size(CaOnIndex,1)
                    %         fill([CaOnIndex(kkk,1), CaOnIndex(kkk,2), CaOnIndex(kkk,2), CaOnIndex(kkk,1)],[0.35*yll+mylim(1) 0.35*yll+mylim(1) 0.65*yll+mylim(1) 0.65*yll+mylim(1)],'magenta','FaceAlpha',0.2);
                    %     end
                    %     if kkk>=2
                    %         pause(0.1);
                    %     end
                    % end

                    hd1=figure(1);
                    subplot(3,1,2);mylim=ylim; yll=mylim(2)-mylim(1);
                    CaTransReg = CaTransReg + LcmtStartTime;
                    if ~isnan(CaTransReg)
                        for kkk=1:size(CaTransReg,1)
                            fill([CaTransReg(kkk,1), CaTransReg(kkk,2), CaTransReg(kkk,2), CaTransReg(kkk,1)],[0.35*yll+mylim(1) 0.35*yll+mylim(1) 0.65*yll+mylim(1) 0.65*yll+mylim(1)],'magenta','FaceAlpha',0.2);
                        end
                        if kkk>=2
                            pause(0.1);
                        end
                    end

                    %%%% register in excel
                    CaSummaryExcel{AFBS.CaTraceCountNum+k-1,1} = CurrentDataName(1:I1(1)-1);
                    CaSummaryExcel{AFBS.CaTraceCountNum+k-1,2} = CurrentDataName(I1(1)+1:I1(2)-1);
                    CaSummaryExcel{AFBS.CaTraceCountNum+k-1,3} = MouseInfo.ExpDate{DataNumCount};
                    CaSummaryExcel{AFBS.CaTraceCountNum+k-1,4} = 'AFBS';
                    CaSummaryExcel{AFBS.CaTraceCountNum+k-1,5} = 'Ca';
                    CaSummaryExcel{AFBS.CaTraceCountNum+k-1,6} = PeakAmp;
                    CaSummaryExcel{AFBS.CaTraceCountNum+k-1,7} = PeakTime;
                    CaSummaryExcel{AFBS.CaTraceCountNum+k-1,8} = OnsetTime;
                    CaSummaryExcel{AFBS.CaTraceCountNum+k-1,9} = Duration;
                    CaSummaryExcel{AFBS.CaTraceCountNum+k-1,10} = OnsetTime+Duration;
                    CaSummaryExcel{AFBS.CaTraceCountNum+k-1,11} = AUC;
                    CaSummaryExcel{AFBS.CaTraceCountNum+k-1,12} = RisingSlope;
                    DiamCaDiffExcel{AFBS.CaTraceCountNum+k-1,1} = CurrentDataName(1:I1(1)-1);
                    DiamCaDiffExcel{AFBS.CaTraceCountNum+k-1,2} = CurrentDataName(I1(1)+1:I1(2)-1);
                    DiamCaDiffExcel{AFBS.CaTraceCountNum+k-1,3} = MouseInfo.ExpDate{DataNumCount};
                    DiamCaDiffExcel{AFBS.CaTraceCountNum+k-1,4} = 'AFBS';
                    DiamCaDiffExcel{AFBS.CaTraceCountNum+k-1,5} = 'DiamCa';
                    DiamCaDiffExcel{AFBS.CaTraceCountNum+k-1,6} = DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,6} - CaSummaryExcel{AFBS.CaTraceCountNum+k-1,6};
                    DiamCaDiffExcel{AFBS.CaTraceCountNum+k-1,7} = DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,7} - CaSummaryExcel{AFBS.CaTraceCountNum+k-1,7};
                    DiamCaDiffExcel{AFBS.CaTraceCountNum+k-1,8} = DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,8} - CaSummaryExcel{AFBS.CaTraceCountNum+k-1,8};
                    DiamCaDiffExcel{AFBS.CaTraceCountNum+k-1,9} = DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,9} - CaSummaryExcel{AFBS.CaTraceCountNum+k-1,9};
                    DiamCaDiffExcel{AFBS.CaTraceCountNum+k-1,10} = DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,10} - CaSummaryExcel{AFBS.CaTraceCountNum+k-1,10};
                    DiamCaDiffExcel{AFBS.CaTraceCountNum+k-1,11} = DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,11} - CaSummaryExcel{AFBS.CaTraceCountNum+k-1,11};
                    DiamCaDiffExcel{AFBS.CaTraceCountNum+k-1,12} = DiamSummaryExcel{AFBS.CaTraceCountNum+k-1,12} - CaSummaryExcel{AFBS.CaTraceCountNum+k-1,12};

                    AFBS.DataName{AFBS.CaTraceCountNum+k-1} = CurrentDataName;

                end


                
                AFBS.LcmtCountNum = AFBS.LcmtCountNum+1;
                AFBS.CaTraceCountNum = AFBS.CaTraceCountNum + size(CaCutTrace,1);

                
            end



        end

        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

        saveas(hd1,[SavingFolderName2,filesep,DiamROINames,'-',CurrentDataName,'.jpg']);
        saveas(hd1,[SavingFolderName2,filesep,DiamROINames,'-',CurrentDataName,'.fig']);


    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% overlay the traces
hd2=figure(2);hold on;
DiamColor='rrrrr';
CaColor='gggg';

subplot(1,3,1),hold on;
yyaxis left
stdshade_changsi_v2(AFBS.DiamTraceAll(1:BFB1b_sas.LcmtCountNum,:),0.5,DiamColor(1),LcmtBin_Time);
stdshade_changsi_v2(AFBS.CaTraceAll(1:BFB1b_sas.LcmtCountNum,:),0.5,CaColor(1),LcmtBin_Time);
ylabel('TPM');ylim([0.9 1.6]);
title('AFBS (green-calcium, red-diameter, y-locomotion)');
yyaxis right
stdshade_changsi_v2(BFB1b_sas.LcmtTraceAll,0.5,'y',LcmtBin_Time);
ylabel('Lcmt speed (cm/s)');
ylim([-2 12])

subplot(1,3,2),hold on;
yyaxis left
stdshade_changsi_v2(BFB1b_sas.DiamTraceAll([1:7,9:BFB1b_sas.LcmtCountNum],:),0.5,DiamColor(1),LcmtBin_Time);
% stdshade_changsi_v2(BFB1b_sas.CaTraceAll(1:BFB1b_sas.LcmtCountNum,:),0.5,CaColor(1),LcmtBin_Time);
% stdshade_changsi_v2(BFB1b_sas.CaTraceAll([1:6,9:11,13:19,20:26],:),0.5,CaColor(1),LcmtBin_Time);
stdshade_changsi_v2(BFB1b_sas.CaTraceAll([1:7,9:BFB1b_sas.LcmtCountNum],:),0.5,CaColor(1),LcmtBin_Time);
ylabel('TPM');ylim([0.9 1.6]);
title('BFB1b-sas (green-calcium, red-diameter, y-locomotion)');
yyaxis right
stdshade_changsi_v2(BFB1b_sas.LcmtTraceAll,0.5,'y',LcmtBin_Time);
ylabel('Lcmt speed (cm/s)');
ylim([-2 12])

subplot(1,3,3),hold on;
yyaxis left
stdshade_changsi_v2(BFB1b_ps.DiamTraceAll(1:BFB1b_ps.LcmtCountNum,:),0.5,DiamColor(2),LcmtBin_Time);
stdshade_changsi_v2(BFB1b_ps.CaTraceAll(1:BFB1b_ps.LcmtCountNum,:),0.5,CaColor(2),LcmtBin_Time);
ylabel('TPM');ylim([0.9 1.6]);
title('BFB1b-Pial sheath (green-calcium, red-diameter, y-locomotion)');
yyaxis right
stdshade_changsi_v2(BFB1b_sas.LcmtTraceAll,0.5,'y',LcmtBin_Time);
ylabel('Lcmt speed (cm/s)');
ylim([-2 12])

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

saveas(hd2,[SavingFolderName,filesep,'FB_OverlayByBFLoc.jpg']);
saveas(hd2,[SavingFolderName,filesep,'FB_OverlayByBFLoc.fig']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% overlay the traces
hd3=figure(3);hold on;

subplot(1,2,1),hold on;
yyaxis right
stdshade_changsi_v2(BFB1b_sas.LcmtTraceAll,0.5,'y',LcmtBin_Time);
ylabel('Locomotion (cm/s)');
ylim([-2 12]);
yyaxis left
plot(LcmtBin_Time,mean(AFBS.DiamTraceAll(1:BFB1b_sas.LcmtCountNum,:)),'r-');
plot(LcmtBin_Time,mean(BFB1b_sas.DiamTraceAll([1:7,9:BFB1b_sas.LcmtCountNum],:)),'b-');
plot(LcmtBin_Time,mean(BFB1b_ps.DiamTraceAll(1:BFB1b_ps.LcmtCountNum,:)),'g-');
stdshade_changsi_v2(AFBS.DiamTraceAll(1:BFB1b_sas.LcmtCountNum,:),0.5,'r',LcmtBin_Time);
stdshade_changsi_v2(BFB1b_sas.DiamTraceAll([1:7,9:BFB1b_sas.LcmtCountNum],:),0.5,'b',LcmtBin_Time);
stdshade_changsi_v2(BFB1b_ps.DiamTraceAll(1:BFB1b_ps.LcmtCountNum,:),0.5,'g',LcmtBin_Time);
legend({'AFBS','BFB1b-sas','BFB1b-Pialsheath'});
ylabel('TPM');
title('Diameter');
ylim([0.9 1.6]);


subplot(1,2,2),hold on;
yyaxis right
stdshade_changsi_v2(BFB1b_sas.LcmtTraceAll,0.5,'y',LcmtBin_Time);
ylabel('Locomotion (cm/s)');
ylim([-2 12]);
yyaxis left
plot(LcmtBin_Time,mean(AFBS.CaTraceAll(1:BFB1b_sas.LcmtCountNum,:)),'r-');
plot(LcmtBin_Time,mean(BFB1b_sas.CaTraceAll([1:7,9:BFB1b_sas.LcmtCountNum],:)),'b-');
plot(LcmtBin_Time,mean(BFB1b_ps.CaTraceAll(1:BFB1b_ps.LcmtCountNum,:)),'g-');
stdshade_changsi_v2(AFBS.CaTraceAll(1:BFB1b_sas.LcmtCountNum,:),0.5,'r',LcmtBin_Time);
stdshade_changsi_v2(BFB1b_sas.CaTraceAll([1:7,9:BFB1b_sas.LcmtCountNum],:),0.5,'b',LcmtBin_Time);
stdshade_changsi_v2(BFB1b_ps.CaTraceAll(1:BFB1b_ps.LcmtCountNum,:),0.5,'g',LcmtBin_Time);
legend({'AFBS','BFB1b-sas','BFB1b-Pialsheath'});
ylabel('TPM');
title('Ca2+');
ylim([0.9 1.6]);

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

saveas(hd3,[SavingFolderName,filesep,'FB_OverlayByDiamCa.jpg']);
saveas(hd3,[SavingFolderName,filesep,'FB_OverlayByDiamCa.fig']);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % FB Diam curves 2D imagesc

hd31 = figure(31);hold on;

ThisStartTime = 0;
ThisEndTime = 50;  % unit:sec

ThisPreDurt = 0-PreDurt;
PlotLength = ThisEndTime./TimeStampInterval;

Icount = (0-PreDurt)/(LcmtBin_Time(3)-LcmtBin_Time(2));

This2DimageTime = TimeStampInterp;

TimeTagDesign = PreDurt:5:(ThisEndTime-ThisPreDurt);
TimeTagDesign_str = cell(size(TimeTagDesign));
TimeTagDesigntick = zeros(size(TimeTagDesign));

for kk = 1:length(TimeTagDesign)
    Itemp = find(This2DimageTime>TimeTagDesign(kk)+ThisPreDurt-1);
    TimeTagDesigntick(kk) = Itemp(1);

    TimeTagDesign_str{kk} = num2str(TimeTagDesign(kk));

end



subplot(3,1,1); hold on;
AFBSDiamCurves = AFBS.DiamTraceAll(1:AFBS.LcmtCountNum-1,:);
AFBSDiamCurvesCut = AFBSDiamCurves(:,1:PlotLength);
AFBSDiamCurvesCut_sort = SortPeakTime_lcmt(AFBSDiamCurvesCut,LcmtBin_Time(:,1:PlotLength),0);
imagesc(AFBSDiamCurvesCut_sort,[0.9 1.4]); title('AFBS Diam');
plot([Icount,Icount],[0.5 size(AFBSDiamCurvesCut,1)+0.5],'w--','LineWidth',2);
box off;colorbar;
ylabel('Trace No.');
xticks(TimeTagDesigntick);
xticklabels(TimeTagDesign_str);
xlim([TimeTagDesigntick(1)+15 TimeTagDesigntick(end)]);
ylim([0 15]);


subplot(3,1,2); hold on;
BFB1b_sasDiamCurves = BFB1b_sas.DiamTraceAll(1:BFB1b_sas.LcmtCountNum-1,:);
BFB1b_sasDiamCurvesCut = BFB1b_sasDiamCurves(:,1:PlotLength);
BFB1b_sasDiamCurvesCut_sort = SortPeakTime_lcmt(BFB1b_sasDiamCurvesCut,LcmtBin_Time(:,1:PlotLength),0);
imagesc(BFB1b_sasDiamCurvesCut_sort,[0.9 1.4]); title('BFB1b-sas Diam');
plot([Icount,Icount],[0.5 size(BFB1b_sasDiamCurvesCut,1)+0.5],'w--','LineWidth',2);
box off;colorbar;
ylabel('Trace No.');
xticks(TimeTagDesigntick);
xticklabels(TimeTagDesign_str);
xlim([TimeTagDesigntick(1)+15 TimeTagDesigntick(end)]);
ylim([0 15]);

subplot(3,1,3); hold on;
BFB1b_psDiamCurves = BFB1b_ps.DiamTraceAll(1:BFB1b_ps.LcmtCountNum-1,:);
BFB1b_psDiamCurvesCut = BFB1b_psDiamCurves(:,1:PlotLength);
BFB1b_psDiamCurvesCut_sort = SortPeakTime_lcmt(BFB1b_psDiamCurvesCut,LcmtBin_Time(:,1:PlotLength),0);
imagesc(BFB1b_psDiamCurvesCut_sort,[0.9 1.4]); title('BFB1b-ps Diam');
plot([Icount,Icount],[0.5 size(BFB1b_psDiamCurvesCut,1)+0.5],'w--','LineWidth',2);
box off;colorbar;
ylabel('Trace No.');
xticks(TimeTagDesigntick);
xticklabels(TimeTagDesign_str);
xlim([TimeTagDesigntick(1)+15 TimeTagDesigntick(end)]);
ylim([0 15]);
xlabel('Time (s)');

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

saveas(hd31,[SavingFolderName,filesep,'FB_Diam_2Dimage.jpg']);
saveas(hd31,[SavingFolderName,filesep,'FB_Diam_2Dimage.fig']);


%% % FB Ca curves 2D imagesc

hd32 = figure(32);hold on;

subplot(3,1,1); hold on;
AFBSCaCurves = AFBS.CaTraceAll(1:AFBS.LcmtCountNum-1,:);
AFBSCaCurvesCut = AFBSCaCurves(:,1:PlotLength);
AFBSCaCurvesCut_sort = SortPeakTime_lcmt(AFBSCaCurvesCut,LcmtBin_Time(:,1:PlotLength),0);
imagesc(AFBSCaCurvesCut_sort,[0.9 2]); title('AFBS Ca');
plot([Icount,Icount],[0.5 size(AFBSCaCurvesCut,1)+0.5],'w--','LineWidth',2);
box off;colorbar;
ylabel('Trace No.');
xticks(TimeTagDesigntick);
xticklabels(TimeTagDesign_str);
xlim([TimeTagDesigntick(1)+15 TimeTagDesigntick(end)]);
ylim([0 15]);


subplot(3,1,2); hold on;
BFB1b_sasCaCurves = BFB1b_sas.CaTraceAll(1:BFB1b_sas.LcmtCountNum-1,:);
BFB1b_sasCaCurvesCut = BFB1b_sasCaCurves([1:7,9:end],1:PlotLength);
BFB1b_sasCaCurvesCut_sort = SortPeakTime_lcmt(BFB1b_sasCaCurvesCut,LcmtBin_Time(:,1:PlotLength),0);
imagesc(BFB1b_sasCaCurvesCut_sort,[0.9 2]); title('BFB1b-sas Ca');
plot([Icount,Icount],[0.5 size(BFB1b_sasCaCurvesCut,1)+0.5],'w--','LineWidth',2);
box off;colorbar;
ylabel('Trace No.');
xticks(TimeTagDesigntick);
xticklabels(TimeTagDesign_str);
xlim([TimeTagDesigntick(1)+15 TimeTagDesigntick(end)]);
ylim([0 15]);

subplot(3,1,3); hold on;
BFB1b_psCaCurves = BFB1b_ps.CaTraceAll(1:BFB1b_ps.LcmtCountNum-1,:);
BFB1b_psCaCurvesCut = BFB1b_psCaCurves(:,1:PlotLength);
BFB1b_psCaCurvesCut_sort = SortPeakTime_lcmt(BFB1b_psCaCurvesCut,LcmtBin_Time(:,1:PlotLength),0);
imagesc(BFB1b_psCaCurvesCut_sort,[0.9 2]); title('BFB1b-ps Ca');
plot([Icount,Icount],[0.5 size(BFB1b_psCaCurvesCut,1)+0.5],'w--','LineWidth',2);
box off;colorbar;
ylabel('Trace No.');
xticks(TimeTagDesigntick);
xticklabels(TimeTagDesign_str);
xlim([TimeTagDesigntick(1)+15 TimeTagDesigntick(end)]);
ylim([0 15]);
xlabel('Time (s)');

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

saveas(hd32,[SavingFolderName,filesep,'FB_Ca_2Dimage.jpg']);
saveas(hd32,[SavingFolderName,filesep,'FB_Ca_2Dimage.fig']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%% bar plots EC Diam %%%%%%%%%%%%%%%%%%%%

hd4=figure(4);hold on;
ROIRealName_short = {'AFBS','BFB1b-sas','BFB1b-Pialsheath'};

subplot(2,3,1);hold on;
mean_pial = mean(AFBS.DiamPeakAmp,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.DiamPeakAmp,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.DiamPeakAmp,'omitnan');

std_pial = std(AFBS.DiamPeakAmp,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.DiamPeakAmp,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.DiamPeakAmp,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS.DiamPeakAmp)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.DiamPeakAmp,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.DiamPeakAmp)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.DiamPeakAmp,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.DiamPeakAmp)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.DiamPeakAmp,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Diameter peak amplitude');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Diameter peak amplitude']);
mylim=ylim;


mylim=ylim;
PlotStatStars2(hd4,2,3,1,AFBS.DiamPeakAmp,BFB1b_sas.DiamPeakAmp,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd4,2,3,1,BFB1b_sas.DiamPeakAmp,BFB1b_ps.DiamPeakAmp,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd4,2,3,1,AFBS.DiamPeakAmp,BFB1b_ps.DiamPeakAmp,[1 3],mylim(2)*0.93,3);



%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots  Diam

subplot(2,3,2);hold on;
mean_pial = mean(AFBS.DiamDuration,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.DiamDuration,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.DiamDuration,'omitnan');
std_pial = std(AFBS.DiamDuration,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.DiamDuration,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.DiamDuration,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS.DiamDuration)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.DiamDuration,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.DiamDuration)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.DiamDuration,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.DiamDuration)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.DiamDuration,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Diameter duration (s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Diameter duration']);
mylim=ylim;


mylim=ylim;
PlotStatStars2(hd4,2,3,2,AFBS.DiamDuration,BFB1b_sas.DiamDuration,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd4,2,3,2,BFB1b_sas.DiamDuration,BFB1b_ps.DiamDuration,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd4,2,3,2,AFBS.DiamDuration,BFB1b_ps.DiamDuration,[1 3],mylim(2)*0.93,3);



%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots DiamOnset
subplot(2,3,3);hold on;
mean_pial = mean(AFBS.DiamOnset,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.DiamOnset,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.DiamOnset,'omitnan');

std_pial = std(AFBS.DiamOnset,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.DiamOnset,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.DiamOnset,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS.DiamOnset)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.DiamOnset,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.DiamOnset)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.DiamOnset,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.DiamOnset)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.DiamOnset,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Diameter change onset (s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Diameter change onset']);
mylim=ylim;


mylim=ylim;
PlotStatStars2(hd4,2,3,3,AFBS.DiamOnset,BFB1b_sas.DiamOnset,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd4,2,3,3,BFB1b_sas.DiamOnset,BFB1b_ps.DiamOnset,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd4,2,3,3,AFBS.DiamOnset,BFB1b_ps.DiamOnset,[1 3],mylim(2)*0.93,3);






%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots Diam AUC
subplot(2,3,4);hold on;
mean_pial = mean(AFBS.DiamAUC,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.DiamAUC,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.DiamAUC,'omitnan');

std_pial = std(AFBS.DiamAUC,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.DiamAUC,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.DiamAUC,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS.DiamAUC)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.DiamAUC,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.DiamAUC)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.DiamAUC,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.DiamAUC)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.DiamAUC,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Diameter change onset (s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Diameter AUC']);
mylim=ylim;



mylim=ylim;
PlotStatStars2(hd4,2,3,4,AFBS.DiamAUC,BFB1b_sas.DiamAUC,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd4,2,3,4,BFB1b_sas.DiamAUC,BFB1b_ps.DiamAUC,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd4,2,3,4,AFBS.DiamAUC,BFB1b_ps.DiamAUC,[1 3],mylim(2)*0.93,3);






%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots Diam AUC
subplot(2,3,5);hold on;
mean_pial = mean(AFBS.DiamPeakTime,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.DiamPeakTime,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.DiamPeakTime,'omitnan');

std_pial = std(AFBS.DiamPeakTime,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.DiamPeakTime,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.DiamPeakTime,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS.DiamPeakTime)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.DiamPeakTime,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.DiamPeakTime)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.DiamPeakTime,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.DiamPeakTime)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.DiamPeakTime,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Time (s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Diameter Peak time']);
mylim=ylim;


mylim=ylim;
PlotStatStars2(hd4,2,3,5,AFBS.DiamPeakTime,BFB1b_sas.DiamPeakTime,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd4,2,3,5,BFB1b_sas.DiamPeakTime,BFB1b_ps.DiamPeakTime,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd4,2,3,5,AFBS.DiamPeakTime,BFB1b_ps.DiamPeakTime,[1 3],mylim(2)*0.93,3);




%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots Diam AUC
subplot(2,3,6);hold on;
mean_pial = mean(AFBS.DiamRisingSlope,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.DiamRisingSlope,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.DiamRisingSlope,'omitnan');

std_pial = std(AFBS.DiamRisingSlope,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.DiamRisingSlope,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.DiamRisingSlope,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS.DiamRisingSlope)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.DiamRisingSlope,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.DiamRisingSlope)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.DiamRisingSlope,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.DiamRisingSlope)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.DiamRisingSlope,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Slope (%/s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Diameter Rising slope']);
mylim=ylim;

mylim=ylim;
PlotStatStars2(hd4,2,3,6,AFBS.DiamRisingSlope,BFB1b_sas.DiamRisingSlope,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd4,2,3,6,BFB1b_sas.DiamRisingSlope,BFB1b_ps.DiamRisingSlope,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd4,2,3,6,AFBS.DiamRisingSlope,BFB1b_ps.DiamRisingSlope,[1 3],mylim(2)*0.93,3);


set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);


saveas(hd4,[SavingFolderName,filesep,'FB_DiamBarPlots.jpg']);
saveas(hd4,[SavingFolderName,filesep,'FB_DiamBarPlots.fig']);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%% bar plots Ca2+
hd5=figure(5);hold on;

AFBS_CaPeakAmp = AFBS.CaPeakAmp;
BFB1b_sas_CaPeakAmp = BFB1b_sas.CaPeakAmp; 
[M,I] = max(BFB1b_sas_CaPeakAmp);BFB1b_sas_CaPeakAmp(I)=[];
BFB1b_ps_CaPeakAmp = BFB1b_ps.CaPeakAmp;

subplot(2,3,1);hold on;
mean_pial = mean(AFBS_CaPeakAmp,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas_CaPeakAmp,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps_CaPeakAmp,'omitnan');

std_pial = std(AFBS_CaPeakAmp,'omitnan');
std_BFB1b_sas = std(BFB1b_sas_CaPeakAmp,'omitnan');
std_BFB1b_ps = std(BFB1b_ps_CaPeakAmp,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS_CaPeakAmp)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS_CaPeakAmp,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas_CaPeakAmp)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas_CaPeakAmp,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps_CaPeakAmp)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps_CaPeakAmp,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('peak amplitude (%)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Ca2+ peak amplitude']);
mylim=ylim;


mylim=ylim;
PlotStatStars2(hd5,2,3,1,AFBS_CaPeakAmp,BFB1b_sas_CaPeakAmp,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd5,2,3,1,BFB1b_sas_CaPeakAmp,BFB1b_ps_CaPeakAmp,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd5,2,3,1,AFBS_CaPeakAmp,BFB1b_ps_CaPeakAmp,[1 3],mylim(2)*0.93,3);



%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots  Ca
%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots  Diam Duration

subplot(2,3,2);hold on;
mean_pial = mean(AFBS.CaDuration,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.CaDuration,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.CaDuration,'omitnan');

std_pial = std(AFBS.CaDuration,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.CaDuration,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.CaDuration,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS.CaDuration)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.CaDuration,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.CaDuration)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.CaDuration,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.CaDuration)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.CaDuration,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Ca2+ duration (s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Ca2+ duration']);
mylim=ylim;


mylim=ylim;
PlotStatStars2(hd5,2,3,2,AFBS.CaDuration,BFB1b_sas.CaDuration,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd5,2,3,2,BFB1b_sas.CaDuration,BFB1b_ps.CaDuration,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd5,2,3,2,AFBS.CaDuration,BFB1b_ps.CaDuration,[1 3],mylim(2)*0.93,3);





%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots CaOnset

AFBS_CaOnset = AFBS.CaOnset;
II0 = find(AFBS_CaOnset==0);
AFBS_CaOnset(II0) = AFBS_CaOnset(II0)+rand(1)*2;

BFB1b_sas_CaOnset = BFB1b_sas.CaOnset; 
II0 = find(BFB1b_sas_CaOnset==0);
BFB1b_sas_CaOnset(II0) = BFB1b_sas_CaOnset(II0)+rand(1)*2;

BFB1b_ps_CaOnset = BFB1b_ps.CaOnset;
II0 = find(BFB1b_ps_CaOnset==0);
BFB1b_ps_CaOnset(II0) = BFB1b_ps_CaOnset(II0)+rand(1)*2;


subplot(2,3,3);hold on;
mean_pial = mean(AFBS_CaOnset,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas_CaOnset,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps_CaOnset,'omitnan');

std_pial = std(AFBS_CaOnset,'omitnan');
std_BFB1b_sas = std(BFB1b_sas_CaOnset,'omitnan');
std_BFB1b_ps = std(BFB1b_ps_CaOnset,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS_CaOnset)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS_CaOnset,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas_CaOnset)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas_CaOnset,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps_CaOnset)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps_CaOnset,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Ca2+ onset (s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Ca2+ change onset time']);



mylim=ylim;
PlotStatStars2(hd5,2,3,3,AFBS_CaOnset,BFB1b_sas_CaOnset,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd5,2,3,3,BFB1b_sas_CaOnset,BFB1b_ps_CaOnset,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd5,2,3,3,AFBS_CaOnset,BFB1b_ps_CaOnset,[1 3],mylim(2)*0.93,3);






%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots Ca AUC
subplot(2,3,4);hold on;

AFBS_CaAUC = AFBS.CaAUC;
BFB1b_sas_CaAUC = BFB1b_sas.CaAUC; 
[M,I] = max(BFB1b_sas_CaAUC);BFB1b_sas_CaAUC(I)=[];
BFB1b_ps_CaAUC = BFB1b_ps.CaAUC;


mean_pial = mean(AFBS_CaAUC,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas_CaAUC,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps_CaAUC,'omitnan');

std_pial = std(AFBS_CaAUC,'omitnan');
std_BFB1b_sas = std(BFB1b_sas_CaAUC,'omitnan');
std_BFB1b_ps = std(BFB1b_ps_CaAUC,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS_CaAUC)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS_CaAUC,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas_CaAUC)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas_CaAUC,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps_CaAUC)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps_CaAUC,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Ca2+ AUC');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Ca2+ AUC']);



mylim=ylim;
PlotStatStars2(hd5,2,3,4,AFBS_CaAUC,BFB1b_sas_CaAUC,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd5,2,3,4,BFB1b_sas_CaAUC,BFB1b_ps_CaAUC,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd5,2,3,4,AFBS_CaAUC,BFB1b_ps_CaAUC,[1 3],mylim(2)*0.93,3);






%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots Ca
subplot(2,3,5);hold on;

AFBS_CaPeakTime = AFBS.CaPeakTime;
II0 = find(AFBS_CaPeakTime==0);
AFBS_CaPeakTime(II0) = AFBS_CaPeakTime(II0)+rand(1)*5;


BFB1b_sas_CaPeakTime = BFB1b_sas.CaPeakTime; 
II0 = find(BFB1b_sas_CaPeakTime==0);
BFB1b_sas_CaPeakTime(II0) = BFB1b_sas_CaPeakTime(II0)+rand(1)*5;

BFB1b_ps_CaPeakTime = BFB1b_ps.CaPeakTime;
II0 = find(BFB1b_ps_CaPeakTime==0);
BFB1b_ps_CaPeakTime(II0) = BFB1b_ps_CaPeakTime(II0)+rand(1)*5;


mean_pial = mean(AFBS_CaPeakTime,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas_CaPeakTime,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps_CaPeakTime,'omitnan');

std_pial = std(AFBS_CaPeakTime,'omitnan');
std_BFB1b_sas = std(BFB1b_sas_CaPeakTime,'omitnan');
std_BFB1b_ps = std(BFB1b_ps_CaPeakTime,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS_CaPeakTime)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS_CaPeakTime,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas_CaPeakTime)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas_CaPeakTime,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps_CaPeakTime)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps_CaPeakTime,20,'MarkerEdgeColor','b');

bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Ca2+ peak time (s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Ca2+ Peak Time']);
mylim=ylim;


mylim=ylim;
PlotStatStars2(hd5,2,3,5,AFBS_CaPeakTime,BFB1b_sas_CaPeakTime,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd5,2,3,5,BFB1b_sas_CaPeakTime,BFB1b_ps_CaPeakTime,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd5,2,3,5,AFBS_CaPeakTime,BFB1b_ps_CaPeakTime,[1 3],mylim(2)*0.93,3);






set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);


saveas(hd5,[SavingFolderName,filesep,'FB_CaBarPlots.jpg']);
saveas(hd5,[SavingFolderName,filesep,'FB_CaBarPlots.fig']);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%% bar plots Ca - Diam timing

hd6=figure(6);hold on;


%%%%%%%%%%%%%%%%%%%%
subplot(2,3,1);hold on;
mean_11 = mean(AFBS.DiamOnset,'omitnan');
mean_12 = mean(AFBS_CaOnset,'omitnan');
std_11 = std(AFBS.DiamOnset,'omitnan');
std_12 = std(AFBS_CaOnset,'omitnan');
mean_21 = mean(BFB1b_sas.DiamOnset,'omitnan');
mean_22 = mean(BFB1b_sas_CaOnset,'omitnan');
std_21 = std(BFB1b_sas.DiamOnset,'omitnan');
std_22 = std(BFB1b_sas_CaOnset,'omitnan');
mean_31 = mean(BFB1b_ps.DiamOnset,'omitnan');
mean_32 = mean(BFB1b_ps_CaOnset,'omitnan');
std_31 = std(BFB1b_ps.DiamOnset,'omitnan');
std_32 = std(BFB1b_ps_CaOnset,'omitnan');
b=bar(1:3,[mean_11,mean_12;mean_21,mean_22;mean_31,mean_32]);
b(1).FaceAlpha = 0.5;b(2).FaceAlpha = 0.5;

ThisDiamTmp = AFBS.DiamOnset;   ThisCaTmp = AFBS_CaOnset;  
nancc = isnan(ThisCaTmp); ThisDiamTmp(find(nancc))=[];ThisCaTmp(find(nancc))=[];
for kk = 1:length(ThisDiamTmp)
    plot([1-0.14 1+0.14],[ThisDiamTmp(kk) ThisCaTmp(kk)],'Color',[0.6 0.6 0.6],'Marker','.','MarkerSize',12);
end
ThisDiamTmp = BFB1b_sas.DiamOnset; ThisCaTmp = BFB1b_sas_CaOnset;
nancc = isnan(ThisCaTmp); ThisDiamTmp(find(nancc))=[];ThisCaTmp(find(nancc))=[];
for kk = 1:length(ThisDiamTmp)
    plot([2-0.14 2+0.14],[ThisDiamTmp(kk) ThisCaTmp(kk)],'Color',[0.6 0.6 0.6],'Marker','.','MarkerSize',12);
end
ThisDiamTmp = BFB1b_ps.DiamOnset; ThisCaTmp = BFB1b_ps_CaOnset;
nancc = isnan(ThisCaTmp); ThisDiamTmp(find(nancc))=[];ThisCaTmp(find(nancc))=[];
for kk = 1:length(ThisDiamTmp)
    plot([3-0.14 3+0.14],[ThisDiamTmp(kk) ThisCaTmp(kk)],'Color',[0.6 0.6 0.6],'Marker','.','MarkerSize',12);
end

errorbar([1-0.14 1+0.14;2-0.14 2+0.14;3-0.14 3+0.14],[mean_11,mean_12;mean_21,mean_22;mean_31,mean_32],[std_11,std_12;std_21,std_22;std_31,std_32],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Latency (s)');
xticks(1:3);
xticklabels(ROIRealName_short);
title('Diameter-Ca Onset Time');
mylim=ylim;
[h, p, ci, stats] = ttest2(AFBS.DiamOnset, AFBS_CaOnset);
if p<=0.05
    plot([1-0.14 1+0.14],[mylim(2)*0.9 mylim(2)*0.9],'k-');
    if p<0.001
        text(1-0.14,mylim(2)*0.9,'***','Fontsize',16);
    elseif p<0.01 && p>=0.001
        text(1-0.14,mylim(2)*0.9,'**','Fontsize',16);
    elseif p>=0.01 && p<=0.05
        text(1-0.14,mylim(2)*0.9,'*','Fontsize',16);
    end
end
[h, p, ci, stats] = ttest2(BFB1b_sas.DiamOnset, BFB1b_sas_CaOnset);
if p<=0.05
    plot([2-0.14 2+0.14],[mylim(2)*0.9 mylim(2)*0.9],'k-');
    if p<0.001
        text(2-0.14,mylim(2)*0.9,'***','Fontsize',16);
    elseif p<0.01 && p>=0.001
        text(2-0.14,mylim(2)*0.9,'**','Fontsize',16);
    elseif p>=0.01 && p<=0.05
        text(2-0.14,mylim(2)*0.9,'*','Fontsize',16);
    end
end
[h, p, ci, stats] = ttest2(BFB1b_ps.DiamOnset, BFB1b_ps_CaOnset);
if p<=0.05
    plot([3-0.14 3+0.14],[mylim(2)*0.9 mylim(2)*0.9],'k-');
    if p<0.001
        text(3-0.14,mylim(2)*0.9,'***','Fontsize',16);
    elseif p<0.01 && p>=0.001
        text(3-0.14,mylim(2)*0.9,'**','Fontsize',16);
    elseif p>=0.01 && p<=0.05
        text(3-0.14,mylim(2)*0.9,'*','Fontsize',16);
    end
end



%%%%%%%%%%%%%%%%%%%%
subplot(2,3,2);hold on;
mean_11 = mean(AFBS.DiamDuration,'omitnan');
mean_12 = mean(AFBS.CaDuration,'omitnan');
std_11 = std(AFBS.DiamDuration,'omitnan');
std_12 = std(AFBS.CaDuration,'omitnan');
mean_21 = mean(BFB1b_sas.DiamDuration,'omitnan');
mean_22 = mean(BFB1b_sas.CaDuration,'omitnan');
std_21 = std(BFB1b_sas.DiamDuration,'omitnan');
std_22 = std(BFB1b_sas.CaDuration,'omitnan');
mean_31 = mean(BFB1b_ps.DiamDuration,'omitnan');
mean_32 = mean(BFB1b_ps.CaDuration,'omitnan');
std_31 = std(BFB1b_ps.DiamDuration,'omitnan');
std_32 = std(BFB1b_ps.CaDuration,'omitnan');
b=bar(1:3,[mean_11,mean_12;mean_21,mean_22;mean_31,mean_32]);
b(1).FaceAlpha = 0.5;b(2).FaceAlpha = 0.5;

ThisDiamTmp = AFBS.DiamDuration;   ThisCaTmp = AFBS.CaDuration;  
nancc = isnan(ThisCaTmp); ThisDiamTmp(find(nancc))=[];ThisCaTmp(find(nancc))=[];
for kk = 1:length(ThisDiamTmp)
    plot([1-0.14 1+0.14],[ThisDiamTmp(kk) ThisCaTmp(kk)],'Color',[0.6 0.6 0.6],'Marker','.','MarkerSize',12);
end
ThisDiamTmp = BFB1b_sas.DiamDuration; ThisCaTmp = BFB1b_sas.CaDuration;
nancc = isnan(ThisCaTmp); ThisDiamTmp(find(nancc))=[];ThisCaTmp(find(nancc))=[];
for kk = 1:length(ThisDiamTmp)
    plot([2-0.14 2+0.14],[ThisDiamTmp(kk) ThisCaTmp(kk)],'Color',[0.6 0.6 0.6],'Marker','.','MarkerSize',12);
end
ThisDiamTmp = BFB1b_ps.DiamDuration; ThisCaTmp = BFB1b_ps.CaDuration;
nancc = isnan(ThisCaTmp); ThisDiamTmp(find(nancc))=[];ThisCaTmp(find(nancc))=[];
for kk = 1:length(ThisDiamTmp)
    plot([3-0.14 3+0.14],[ThisDiamTmp(kk) ThisCaTmp(kk)],'Color',[0.6 0.6 0.6],'Marker','.','MarkerSize',12);
end

errorbar([1-0.14 1+0.14;2-0.14 2+0.14;3-0.14 3+0.14],[mean_11,mean_12;mean_21,mean_22;mean_31,mean_32],[std_11,std_12;std_21,std_22;std_31,std_32],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Latency (s)');
xticks(1:3);
xticklabels(ROIRealName_short);
title('Diameter-Ca Duration Time');
mylim=ylim;
[h, p, ci, stats] = ttest2(AFBS.DiamDuration, AFBS.CaDuration);
if p<=0.05
    plot([1-0.14 1+0.14],[mylim(2)*0.9 mylim(2)*0.9],'k-');
    if p<0.001
        text(1-0.14,mylim(2)*0.9,'***','Fontsize',16);
    elseif p<0.01 && p>=0.001
        text(1-0.14,mylim(2)*0.9,'**','Fontsize',16);
    elseif p>=0.01 && p<=0.05
        text(1-0.14,mylim(2)*0.9,'*','Fontsize',16);
    end
end
[h, p, ci, stats] = ttest2(BFB1b_sas.DiamDuration, BFB1b_sas.CaDuration);
if p<=0.05
    plot([2-0.14 2+0.14],[mylim(2)*0.9 mylim(2)*0.9],'k-');
    if p<0.001
        text(2-0.14,mylim(2)*0.9,'***','Fontsize',16);
    elseif p<0.01 && p>=0.001
        text(2-0.14,mylim(2)*0.9,'**','Fontsize',16);
    elseif p>=0.01 && p<=0.05
        text(2-0.14,mylim(2)*0.9,'*','Fontsize',16);
    end
end
[h, p, ci, stats] = ttest2(BFB1b_ps.DiamDuration, BFB1b_ps.CaDuration);
if p<=0.05
    plot([3-0.14 3+0.14],[mylim(2)*0.9 mylim(2)*0.9],'k-');
    if p<0.001
        text(3-0.14,mylim(2)*0.9,'***','Fontsize',16);
    elseif p<0.01 && p>=0.001
        text(3-0.14,mylim(2)*0.9,'**','Fontsize',16);
    elseif p>=0.01 && p<=0.05
        text(3-0.14,mylim(2)*0.9,'*','Fontsize',16);
    end
end



%%%%%%%%%%%%%%%%%%%%
subplot(2,3,3);hold on;
mean_11 = mean(AFBS.DiamPeakTime,'omitnan');
mean_12 = mean(AFBS_CaPeakTime,'omitnan');
std_11 = std(AFBS.DiamPeakTime,'omitnan');
std_12 = std(AFBS_CaPeakTime,'omitnan');
mean_21 = mean(BFB1b_sas.DiamPeakTime,'omitnan');
mean_22 = mean(BFB1b_sas_CaPeakTime,'omitnan');
std_21 = std(BFB1b_sas.DiamPeakTime,'omitnan');
std_22 = std(BFB1b_sas_CaPeakTime,'omitnan');
mean_31 = mean(BFB1b_ps.DiamPeakTime,'omitnan');
mean_32 = mean(BFB1b_ps_CaPeakTime,'omitnan');
std_31 = std(BFB1b_ps.DiamPeakTime,'omitnan');
std_32 = std(BFB1b_ps_CaPeakTime,'omitnan');
b=bar(1:3,[mean_11,mean_12;mean_21,mean_22;mean_31,mean_32]);
b(1).FaceAlpha = 0.5;b(2).FaceAlpha = 0.5;

ThisDiamTmp = AFBS.DiamPeakTime;   ThisCaTmp = AFBS_CaPeakTime;  
nancc = isnan(ThisCaTmp); ThisDiamTmp(find(nancc))=[];ThisCaTmp(find(nancc))=[];
for kk = 1:length(ThisDiamTmp)
    plot([1-0.14 1+0.14],[ThisDiamTmp(kk) ThisCaTmp(kk)],'Color',[0.6 0.6 0.6],'Marker','.','MarkerSize',12);
end
ThisDiamTmp = BFB1b_sas.DiamPeakTime; ThisCaTmp = BFB1b_sas_CaPeakTime;
nancc = isnan(ThisCaTmp); ThisDiamTmp(find(nancc))=[];ThisCaTmp(find(nancc))=[];
for kk = 1:length(ThisDiamTmp)
    plot([2-0.14 2+0.14],[ThisDiamTmp(kk) ThisCaTmp(kk)],'Color',[0.6 0.6 0.6],'Marker','.','MarkerSize',12);
end
ThisDiamTmp = BFB1b_ps.DiamPeakTime; ThisCaTmp = BFB1b_ps_CaPeakTime;
nancc = isnan(ThisCaTmp); ThisDiamTmp(find(nancc))=[];ThisCaTmp(find(nancc))=[];
for kk = 1:length(ThisDiamTmp)
    plot([3-0.14 3+0.14],[ThisDiamTmp(kk) ThisCaTmp(kk)],'Color',[0.6 0.6 0.6],'Marker','.','MarkerSize',12);
end

errorbar([1-0.14 1+0.14;2-0.14 2+0.14;3-0.14 3+0.14],[mean_11,mean_12;mean_21,mean_22;mean_31,mean_32],[std_11,std_12;std_21,std_22;std_31,std_32],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Latency (s)');
xticks(1:3);
xticklabels(ROIRealName_short);
title('Diameter-Ca Peak Time');
mylim=ylim;
[h, p, ci, stats] = ttest2(AFBS.DiamPeakTime, AFBS_CaPeakTime);
if p<=0.05
    plot([1-0.14 1+0.14],[mylim(2)*0.9 mylim(2)*0.9],'k-');
    if p<0.001
        text(1-0.14,mylim(2)*0.9,'***','Fontsize',16);
    elseif p<0.01 && p>=0.001
        text(1-0.14,mylim(2)*0.9,'**','Fontsize',16);
    elseif p>=0.01 && p<=0.05
        text(1-0.14,mylim(2)*0.9,'*','Fontsize',16);
    end
end
[h, p, ci, stats] = ttest2(BFB1b_sas.DiamPeakTime, BFB1b_sas_CaPeakTime);
if p<=0.05
    plot([2-0.14 2+0.14],[mylim(2)*0.9 mylim(2)*0.9],'k-');
    if p<0.001
        text(2-0.14,mylim(2)*0.9,'***','Fontsize',16);
    elseif p<0.01 && p>=0.001
        text(2-0.14,mylim(2)*0.9,'**','Fontsize',16);
    elseif p>=0.01 && p<=0.05
        text(2-0.14,mylim(2)*0.9,'*','Fontsize',16);
    end
end
[h, p, ci, stats] = ttest2(BFB1b_ps.DiamPeakTime, BFB1b_ps_CaPeakTime);
if p<=0.05
    plot([3-0.14 3+0.14],[mylim(2)*0.9 mylim(2)*0.9],'k-');
    if p<0.001
        text(3-0.14,mylim(2)*0.9,'***','Fontsize',16);
    elseif p<0.01 && p>=0.001
        text(3-0.14,mylim(2)*0.9,'**','Fontsize',16);
    elseif p>=0.01 && p<=0.05
        text(3-0.14,mylim(2)*0.9,'*','Fontsize',16);
    end
end

%%%%%%%%%%%%%%%%%%%%
subplot(2,3,4);hold on;
AFBS.OnsetDiff = AFBS.DiamOnset - AFBS_CaOnset;
BFB1b_sas.OnsetDiff = BFB1b_sas.DiamOnset - BFB1b_sas_CaOnset;
BFB1b_ps.OnsetDiff = BFB1b_ps.DiamOnset - BFB1b_ps_CaOnset;

mean_pial = mean(AFBS.OnsetDiff,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.OnsetDiff,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.OnsetDiff,'omitnan');

std_pial = std(AFBS.OnsetDiff,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.OnsetDiff,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.OnsetDiff,'omitnan');

xxx=repmat(1,1,length(~isnan(AFBS.OnsetDiff)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.OnsetDiff,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.OnsetDiff)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.OnsetDiff,20,'MarkerEdgeColor','k');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.OnsetDiff)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.OnsetDiff,20,'MarkerEdgeColor','k');

bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Onset delay (s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Delay of Diam-Ca Onset Time']);

mylim=ylim;
PlotStatStars2(hd6,2,3,4,AFBS.OnsetDiff,BFB1b_sas.OnsetDiff,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd6,2,3,4,BFB1b_sas.OnsetDiff,BFB1b_ps.OnsetDiff,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd6,2,3,4,AFBS.OnsetDiff,BFB1b_ps.OnsetDiff,[1 3],mylim(2)*0.93,3);

[h, p1, ci, stats] = ttest(AFBS.OnsetDiff, 0, 'Alpha', 0.05);
if p1<0.001
    text(0.75,mylim(2)*0.5,'***','Fontsize',16,'Color','red');
elseif p1<0.01 && p1>=0.001
    text(0.75,mylim(2)*0.5,'**','Fontsize',16,'Color','red');
elseif p1>=0.01 && p1<=0.05
    text(0.75,mylim(2)*0.5,'*','Fontsize',16,'Color','red');
end
[h, p2, ci, stats] = ttest(BFB1b_sas.OnsetDiff, 0, 'Alpha', 0.05);
if p2<0.001
    text(1.75,mylim(2)*0.5,'***','Fontsize',16,'Color','red');
elseif p2<0.01 && p2>=0.001
    text(1.75,mylim(2)*0.5,'**','Fontsize',16,'Color','red');
elseif p2>=0.01 && p2<=0.05
    text(1.75,mylim(2)*0.5,'*','Fontsize',16,'Color','red');
end
[h, p3, ci, stats] = ttest(BFB1b_ps.OnsetDiff, 0, 'Alpha', 0.05);
if p3<0.001
    text(2.75,mylim(2)*0.5,'***','Fontsize',16,'Color','red');
elseif p3<0.01 && p3>=0.001
    text(2.75,mylim(2)*0.5,'**','Fontsize',16,'Color','red');
elseif p3>=0.01 && p3<=0.05
    text(2.75,mylim(2)*0.5,'*','Fontsize',16,'Color','red');
end


%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(2,3,5);hold on;
AFBS.DurationDiff = AFBS.DiamDuration - AFBS.CaDuration;
BFB1b_sas.DurationDiff = BFB1b_sas.DiamDuration - BFB1b_sas.CaDuration;
BFB1b_ps.DurationDiff = BFB1b_ps.DiamDuration - BFB1b_ps.CaDuration;
mean_pial = mean(AFBS.DurationDiff,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.DurationDiff,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.DurationDiff,'omitnan');

std_pial = std(AFBS.DurationDiff,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.DurationDiff,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.DurationDiff,'omitnan');

xxx=repmat(1,1,length(~isnan(AFBS.DurationDiff)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.DurationDiff,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.DurationDiff)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.DurationDiff,20,'MarkerEdgeColor','k');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.DurationDiff)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.DurationDiff,20,'MarkerEdgeColor','k');

bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Duration diff (s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Diff of Diam-Ca duration']);

mylim=ylim;
PlotStatStars2(hd6,2,3,5,AFBS.DurationDiff,BFB1b_sas.DurationDiff,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd6,2,3,5,BFB1b_sas.DurationDiff,BFB1b_ps.DurationDiff,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd6,2,3,5,AFBS.DurationDiff,BFB1b_ps.DurationDiff,[1 3],mylim(2)*0.93,3);

[h, p1, ci, stats] = ttest(AFBS.DurationDiff, 0, 'Alpha', 0.05);
if p1<0.001
    text(0.75,mylim(2)*0.5,'***','Fontsize',16,'Color','red');
elseif p1<0.01 && p1>=0.001
    text(0.75,mylim(2)*0.5,'**','Fontsize',16,'Color','red');
elseif p1>=0.01 && p1<=0.05
    text(0.75,mylim(2)*0.5,'*','Fontsize',16,'Color','red');
end
[h, p2, ci, stats] = ttest(BFB1b_sas.DurationDiff, 0, 'Alpha', 0.05);
if p2<0.001
    text(1.75,mylim(2)*0.5,'***','Fontsize',16,'Color','red');
elseif p2<0.01 && p2>=0.001
    text(1.75,mylim(2)*0.5,'**','Fontsize',16,'Color','red');
elseif p2>=0.01 && p2<=0.05
    text(1.75,mylim(2)*0.5,'*','Fontsize',16,'Color','red');
end
[h, p3, ci, stats] = ttest(BFB1b_ps.DurationDiff, 0, 'Alpha', 0.05);
if p3<0.001
    text(2.75,mylim(2)*0.5,'***','Fontsize',16,'Color','red');
elseif p3<0.01 && p3>=0.001
    text(2.75,mylim(2)*0.5,'**','Fontsize',16,'Color','red');
elseif p3>=0.01 && p3<=0.05
    text(2.75,mylim(2)*0.5,'*','Fontsize',16,'Color','red');
end




%%%%%%%%%%%%%%%%%%%%%%%%% 
subplot(2,3,6);hold on;
AFBS.PeakTimeDiff = AFBS.DiamPeakTime - AFBS_CaPeakTime;
BFB1b_sas.PeakTimeDiff = BFB1b_sas.DiamPeakTime - BFB1b_sas_CaPeakTime;
BFB1b_ps.PeakTimeDiff = BFB1b_ps.DiamPeakTime - BFB1b_ps_CaPeakTime;

mean_pial = mean(AFBS.PeakTimeDiff,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.PeakTimeDiff,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.PeakTimeDiff,'omitnan');
std_pial = std(AFBS.PeakTimeDiff,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.PeakTimeDiff,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.PeakTimeDiff,'omitnan');

xxx=repmat(1,1,length(~isnan(AFBS.PeakTimeDiff)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.PeakTimeDiff,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.PeakTimeDiff)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.PeakTimeDiff,20,'MarkerEdgeColor','k');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.PeakTimeDiff)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.PeakTimeDiff,20,'MarkerEdgeColor','k');

bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('PeakTime diff (s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Diff of Diam-Ca peak time']);

mylim=ylim;
PlotStatStars2(hd6,2,3,6,AFBS.PeakTimeDiff,BFB1b_sas.PeakTimeDiff,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd6,2,3,6,BFB1b_sas.PeakTimeDiff,BFB1b_ps.PeakTimeDiff,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd6,2,3,6,AFBS.PeakTimeDiff,BFB1b_ps.PeakTimeDiff,[1 3],mylim(2)*0.93,3);

[h, p1, ci, stats] = ttest(AFBS.PeakTimeDiff, 0, 'Alpha', 0.05);
if p1<0.001
    text(0.75,mylim(2)*0.5,'***','Fontsize',16,'Color','red');
elseif p1<0.01 && p1>=0.001
    text(0.75,mylim(2)*0.5,'**','Fontsize',16,'Color','red');
elseif p1>=0.01 && p1<=0.05
    text(0.75,mylim(2)*0.5,'*','Fontsize',16,'Color','red');
end
[h, p2, ci, stats] = ttest(BFB1b_sas.PeakTimeDiff, 0, 'Alpha', 0.05);
if p2<0.001
    text(1.75,mylim(2)*0.5,'***','Fontsize',16,'Color','red');
elseif p2<0.01 && p2>=0.001
    text(1.75,mylim(2)*0.5,'**','Fontsize',16,'Color','red');
elseif p2>=0.01 && p2<=0.05
    text(1.75,mylim(2)*0.5,'*','Fontsize',16,'Color','red');
end
[h, p3, ci, stats] = ttest(BFB1b_ps.PeakTimeDiff, 0, 'Alpha', 0.05);
if p3<0.001
    text(2.75,mylim(2)*0.5,'***','Fontsize',16,'Color','red');
elseif p3<0.01 && p3>=0.001
    text(2.75,mylim(2)*0.5,'**','Fontsize',16,'Color','red');
elseif p3>=0.01 && p3<=0.05
    text(2.75,mylim(2)*0.5,'*','Fontsize',16,'Color','red');
end


set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);


saveas(hd6,[SavingFolderName,filesep,'FB_DiamCa_TimingCmp.jpg']);
saveas(hd6,[SavingFolderName,filesep,'FB_DiamCa_TimingCmp.fig']);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%% cross-correlation

hd7=figure(7);hold on;

subplot(2,3,1);hold on;
AFBSDiamCurves = AFBS.DiamTraceAll-1;
AFBSDiamCurves(AFBS.LcmtCountNum:end,:)=[];
AFBSCaCurves = AFBS.CaTraceAll-1;
AFBSCaCurves(AFBS.LcmtCountNum:end,:)=[];

AFBSXcorr = zeros(size(AFBSDiamCurves,1),2*size(AFBSDiamCurves,2)-1);
AFBSXcorrXmax = [];
AFBSXcorrYmax = [];
XcorrTime = TimeStampInterval*(1-size(AFBSDiamCurves,2):size(AFBSDiamCurves,2)-1);
for i=1:size(AFBSDiamCurves,1)
    DiamTmp = AFBSDiamCurves(i,:);
    CaTmp = AFBSCaCurves(i,:);
    DiamTmp = fillmissing(DiamTmp, 'linear');
    CaTmp = fillmissing(CaTmp, 'linear');
    % AFBSXcorr(i,:)=xcorr(DiamTmp,CaTmp, 'coeff');
    AFBSXcorr(i,:)=xcorr(DiamTmp,CaTmp);
    plot(XcorrTime,AFBSXcorr(i,:),'Color',[0.7 0.7 0.7]);
    [AFBSXcorrYmax(i),AFBSXcorrXmax(i)] = max(AFBSXcorr(i,:));

end
AFBSXcorrXmax = XcorrTime(AFBSXcorrXmax);
hd7=figure(7);subplot(2,3,1);hold on;
stdshade_changsi_v2(AFBSXcorr,0.3,'b',XcorrTime);
ylim([-20 35]);
mylim=ylim;plot([0 0],mylim*0.99,'k--');
title('Xcorr: AFBS Artery');
xlabel('Time (s)');

%%%%
subplot(2,3,2);hold on;
BFB1b_sasDiamCurves = BFB1b_sas.DiamTraceAll-1;
BFB1b_sasDiamCurves(BFB1b_sas.LcmtCountNum:end,:)=[];
BFB1b_sasCaCurves = BFB1b_sas.CaTraceAll-1;
BFB1b_sasCaCurves(BFB1b_sas.LcmtCountNum:end,:)=[];

BFB1b_sasXcorr = zeros(size(BFB1b_sasDiamCurves,1),2*size(BFB1b_sasDiamCurves,2)-1);
BFB1b_sasXcorrXmax = [];
BFB1b_sasXcorrYmax = [];
XcorrTime = TimeStampInterval*(1-size(BFB1b_sasDiamCurves,2):size(BFB1b_sasDiamCurves,2)-1);
for i=1:size(BFB1b_sasDiamCurves,1)
    DiamTmp = BFB1b_sasDiamCurves(i,:);
    CaTmp = BFB1b_sasCaCurves(i,:);
    % if sum(isnan(DiamTmp))<=3
        DiamTmp = fillmissing(DiamTmp, 'linear');
    % end
    % if sum(isnan(CaTmp))<=3
        CaTmp = fillmissing(CaTmp, 'linear');
    % end
    % BFB1b_sasXcorr(i,:)=xcorr(DiamTmp,CaTmp, 'coeff');
    BFB1b_sasXcorr(i,:)=xcorr(DiamTmp,CaTmp);
    plot(XcorrTime,BFB1b_sasXcorr(i,:),'Color',[0.7 0.7 0.7]);
    [BFB1b_sasXcorrYmax(i),BFB1b_sasXcorrXmax(i)] = max(BFB1b_sasXcorr(i,:));
end

BFB1b_sasXcorrXmax = XcorrTime(BFB1b_sasXcorrXmax);
hd7=figure(7);subplot(2,3,2);hold on;
stdshade_changsi_v2(BFB1b_sasXcorr,0.3,'b',XcorrTime);
ylim([-20 35]);
mylim=ylim;plot([0 0],mylim*0.99,'k--');
title('Xcorr: BFB1b_sas');
xlabel('Time (s)');

subplot(2,3,3);hold on;
BFB1b_psDiamCurves = BFB1b_ps.DiamTraceAll-1;
BFB1b_psDiamCurves(BFB1b_ps.LcmtCountNum:end,:)=[];
BFB1b_psCaCurves = BFB1b_ps.CaTraceAll-1;
BFB1b_psCaCurves(BFB1b_ps.LcmtCountNum:end,:)=[];

BFB1b_psXcorr = zeros(size(BFB1b_psDiamCurves,1),2*size(BFB1b_psDiamCurves,2)-1);
BFB1b_psXcorrXmax = [];
BFB1b_psXcorrYmax = [];
XcorrTime = TimeStampInterval*(1-size(BFB1b_psDiamCurves,2):size(BFB1b_psDiamCurves,2)-1);
for i=1:size(BFB1b_psDiamCurves,1)
    DiamTmp = BFB1b_psDiamCurves(i,:);
    CaTmp = BFB1b_psCaCurves(i,:);
    % if sum(isnan(DiamTmp))<=3
        DiamTmp = fillmissing(DiamTmp, 'linear');
    % end
    % if sum(isnan(CaTmp))<=3
        CaTmp = fillmissing(CaTmp, 'linear');
    % end
    % BFB1b_psXcorr(i,:)=xcorr(DiamTmp,CaTmp, 'coeff');
    BFB1b_psXcorr(i,:)=xcorr(DiamTmp,CaTmp);
    plot(XcorrTime,BFB1b_psXcorr(i,:),'Color',[0.7 0.7 0.7]);
    [BFB1b_psXcorrYmax(i),BFB1b_psXcorrXmax(i)] = max(BFB1b_psXcorr(i,:));
end

BFB1b_psXcorrXmax = XcorrTime(BFB1b_psXcorrXmax);
hd7=figure(7);subplot(2,3,3);hold on;
stdshade_changsi_v2(BFB1b_psXcorr,0.3,'b',XcorrTime);
ylim([-20 35]);
mylim=ylim;plot([0 0],mylim*0.99,'k--');
title('Xcorr: BFB1b_ps');
xlabel('Time (s)');



subplot(2,3,5);hold on;
mean_1 = mean(AFBSXcorrYmax,'omitnan');
std_1 = std(AFBSXcorrYmax,'omitnan');
mean_2 = mean(BFB1b_sasXcorrYmax,'omitnan');
std_2 = std(BFB1b_sasXcorrYmax,'omitnan');
mean_3 = mean(BFB1b_psXcorrYmax,'omitnan');
std_3 = std(BFB1b_psXcorrYmax,'omitnan');
bar(1:3,[mean_1,mean_2,mean_3]);
plot(repmat(1,1,length(AFBSXcorrYmax))+ rand(1,length(AFBSXcorrYmax))*0.5-0.25,AFBSXcorrYmax,'b.','MarkerSize',10);
plot(repmat(2,1,length(BFB1b_sasXcorrYmax))+ rand(1,length(BFB1b_sasXcorrYmax))*0.5-0.25,BFB1b_sasXcorrYmax,'b.','MarkerSize',10);
plot(repmat(3,1,length(BFB1b_psXcorrYmax))+ rand(1,length(BFB1b_psXcorrYmax))*0.5-0.25,BFB1b_psXcorrYmax,'b.','MarkerSize',10);
errorbar(1:3,[mean_1,mean_2,mean_3],[std_1,std_2,std_3],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Amplitude');
xticks(1:3);
ROIRealName_short = {'AFBS','BFB1b_sas','BFB1b-pialsheath'};
xticklabels(ROIRealName_short);
title('Xcorr - Power Amp');


mylim=ylim;
PlotStatStars2(hd7,2,3,5,AFBSXcorrYmax,BFB1b_sasXcorrYmax,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd7,2,3,5,BFB1b_sasXcorrYmax,BFB1b_psXcorrYmax,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd7,2,3,5,AFBSXcorrYmax,BFB1b_psXcorrYmax,[1 3],mylim(2)*0.93,3);



subplot(2,3,6);hold on;
mean_1 = mean(AFBSXcorrXmax,'omitnan');
std_1 = std(AFBSXcorrXmax,'omitnan');
mean_2 = mean(BFB1b_sasXcorrXmax,'omitnan');
std_2 = std(BFB1b_sasXcorrXmax,'omitnan');
mean_3 = mean(BFB1b_psXcorrXmax,'omitnan');
std_3 = std(BFB1b_psXcorrXmax,'omitnan');
bar(1:3,[mean_1,mean_2,mean_3]);
plot(repmat(1,1,length(AFBSXcorrXmax))+ rand(1,length(AFBSXcorrXmax))*0.5-0.25,AFBSXcorrXmax,'b.','MarkerSize',10);
plot(repmat(2,1,length(BFB1b_sasXcorrXmax))+ rand(1,length(BFB1b_sasXcorrXmax))*0.5-0.25,BFB1b_sasXcorrXmax,'b.','MarkerSize',10);
plot(repmat(3,1,length(BFB1b_psXcorrXmax))+ rand(1,length(BFB1b_psXcorrXmax))*0.5-0.25,BFB1b_psXcorrXmax,'b.','MarkerSize',10);
errorbar(1:3,[mean_1,mean_2,mean_3],[std_1,std_2,std_3],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Amplitude');
xticks(1:3);
ROIRealName_short = {'AFBS','BFB1b_sas','BFB1b-pialsheath'};
xticklabels(ROIRealName_short);
title('Xcorr - Latency');



set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);


mylim=ylim;
PlotStatStars2(hd7,2,3,6,AFBSXcorrXmax,BFB1b_sasXcorrXmax,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd7,2,3,6,BFB1b_sasXcorrXmax,BFB1b_psXcorrXmax,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd7,2,3,6,AFBSXcorrXmax,BFB1b_psXcorrXmax,[1 3],mylim(2)*0.93,3);

[h, p1, ci, stats] = ttest(AFBSXcorrXmax, 0, 'Alpha', 0.05);
if p1<0.001
    text(0.75,mylim(2)*0.5,'***','Fontsize',16,'Color','red');
elseif p1<0.01 && p1>=0.001
    text(0.75,mylim(2)*0.5,'**','Fontsize',16,'Color','red');
elseif p1>=0.01 && p1<=0.05
    text(0.75,mylim(2)*0.5,'*','Fontsize',16,'Color','red');
end

[h, p2, ci, stats] = ttest(BFB1b_sasXcorrXmax, 0, 'Alpha', 0.05);
if p2<0.001
    text(1.75,mylim(2)*0.5,'***','Fontsize',16,'Color','red');
elseif p2<0.01 && p2>=0.001
    text(1.75,mylim(2)*0.5,'**','Fontsize',16,'Color','red');
elseif p2>=0.01 && p2<=0.05
    text(1.75,mylim(2)*0.5,'*','Fontsize',16,'Color','red');
end

[h, p3, ci, stats] = ttest(BFB1b_psXcorrXmax, 0, 'Alpha', 0.05);
if p3<0.001
    text(2.75,mylim(2)*0.5,'***','Fontsize',16,'Color','red');
elseif p3<0.01 && p3>=0.001
    text(2.75,mylim(2)*0.5,'**','Fontsize',16,'Color','red');
elseif p3>=0.01 && p3<=0.05
    text(2.75,mylim(2)*0.5,'*','Fontsize',16,'Color','red');
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

saveas(hd7,[SavingFolderName,filesep,'FB_DiamCa_Xcorr.jpg']);
saveas(hd7,[SavingFolderName,filesep,'FB_DiamCa_Xcorr.fig']);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% correlation of diameter and calcium
%% %%%%%%%%%%%%%% doted plots

hd9 = figure(9);hold on;


mycolormap = 'krbgc';


subplot(2,3,1);hold on;
plot([AFBS.CaPeakAmp],[AFBS.DiamPeakAmp],[mycolormap(2),'.'],'MarkerSize',14);
plotFittedLine(9,2,3,1,[AFBS.CaPeakAmp],[AFBS.DiamPeakAmp],mycolormap(2));
plot([BFB1b_sas.CaPeakAmp],[BFB1b_sas.DiamPeakAmp],[mycolormap(3),'.'],'MarkerSize',14);
plotFittedLine(9,2,3,1,[BFB1b_sas.CaPeakAmp],[BFB1b_sas.DiamPeakAmp],mycolormap(3));
plot([BFB1b_ps.CaPeakAmp],[BFB1b_ps.DiamPeakAmp],[mycolormap(4),'.'],'MarkerSize',14);
plotFittedLine(9,2,3,1,[BFB1b_ps.CaPeakAmp],[BFB1b_ps.DiamPeakAmp],mycolormap(4));
xlabel('Ca2+ PeakAmp (%)');
ylabel('Diam PeakAmp (%)');
title('Peak Amp');


subplot(2,3,2);hold on;
plot([AFBS.CaPeakTime],[AFBS.DiamPeakTime],[mycolormap(2),'.'],'MarkerSize',14);
plotFittedLine(9,2,3,2,[AFBS.CaPeakTime],[AFBS.DiamPeakTime],mycolormap(2));
plot([BFB1b_sas.CaPeakTime],[BFB1b_sas.DiamPeakTime],[mycolormap(3),'.'],'MarkerSize',14);
plotFittedLine(9,2,3,2,[BFB1b_sas.CaPeakTime],[BFB1b_sas.DiamPeakTime],mycolormap(3));
plot([BFB1b_ps.CaPeakTime],[BFB1b_ps.DiamPeakTime],[mycolormap(4),'.'],'MarkerSize',14);
plotFittedLine(9,2,3,2,[BFB1b_ps.CaPeakTime],[BFB1b_ps.DiamPeakTime],mycolormap(4));
xlabel('Ca2+ PeakTime (s)');
ylabel('Diam PeakTime (s)');
title('Peak Time');


subplot(2,3,3);hold on;
plot([AFBS.CaDuration],[AFBS.DiamDuration],[mycolormap(2),'.'],'MarkerSize',14);
plotFittedLine(9,2,3,3,[AFBS.CaDuration],[AFBS.DiamDuration],mycolormap(2));
plot([BFB1b_sas.CaDuration],[BFB1b_sas.DiamDuration],[mycolormap(3),'.'],'MarkerSize',14);
plotFittedLine(9,2,3,3,[BFB1b_sas.CaDuration],[BFB1b_sas.DiamDuration],mycolormap(3));
plot([BFB1b_ps.CaDuration],[BFB1b_ps.DiamDuration],[mycolormap(4),'.'],'MarkerSize',14);
plotFittedLine(9,2,3,3,[BFB1b_ps.CaDuration],[BFB1b_ps.DiamDuration],mycolormap(4));
xlabel('Ca2+ Duration (s)');
ylabel('Diam Duration (s)');
title('Duration');


subplot(2,3,6);hold on;
plot([AFBS.CaAUC],[AFBS.DiamAUC],[mycolormap(2),'.'],'MarkerSize',14);
plotFittedLine(9,2,3,6,[AFBS.CaAUC],[AFBS.DiamAUC],mycolormap(2));
plot([BFB1b_sas.CaAUC],[BFB1b_sas.DiamAUC],[mycolormap(3),'.'],'MarkerSize',14);
plotFittedLine(9,2,3,6,[BFB1b_sas.CaAUC],[BFB1b_sas.DiamAUC],mycolormap(3));
plot([BFB1b_ps.CaAUC],[BFB1b_ps.DiamAUC],[mycolormap(4),'.'],'MarkerSize',14);
plotFittedLine(9,2,3,6,[BFB1b_ps.CaAUC],[BFB1b_ps.DiamAUC],mycolormap(4));
xlabel('Ca2+ AUC (%*s)');
ylabel('Diam AUC (%*s)');
title('AUC');

saveas(hd9,[SavingFolderName,filesep,'FB_Diam_Ca_LinearFit.jpg']);
saveas(hd9,[SavingFolderName,filesep,'FB_Diam_Ca_LinearFit.fig']);



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hd10 = figure(10);hold on;

subplot(3,3,1);hold on;title('AFBS Diam Onset wCaOnset');
plot([0 0],[0 1],'k--');ylim([0 1]);xlim([-15 30]);
subplot(3,3,2);hold on;title('AFBS Diam Offset wCaOnset');
plot([0 0],[0 1],'k--');ylim([0 1]);xlim([-15 30]);
subplot(3,3,3);hold on;title('AFBS Diam Peak wCaOnset');
plot([0 0],[0 1],'k--');ylim([0 1]);xlim([-15 30]);
AFBS_DiamOn_CaDelay_All=[];
AFBS_DiamOff_CaDelay_All=[];
AFBS_DiamPeak_CaDelay_All=[];

for ii = 1:length(AFBS.CaTransPeakX)
    CaTransPeakX = AFBS.CaTransPeakX{ii};
    if ~isnan(CaTransPeakX)
        DiamOnsetT = AFBS.CaOnset(ii);
        DiamOffsetT = AFBS.CaOnset(ii) + AFBS.CaDuration(ii);
        DiamPeakT = AFBS.DiamPeakTime(ii);

        CaTransReg = AFBS.CaTransReg{ii};
        CaOnsetT = CaTransReg(:,1);

        DiamOn_CaDelay = CaOnsetT-DiamOnsetT;
        DiamOff_CaDelay = CaOnsetT-DiamOffsetT;
        DiamPeak_CaDelay = CaOnsetT-DiamPeakT;

        AFBS_DiamOn_CaDelay_All = [AFBS_DiamOn_CaDelay_All;DiamOn_CaDelay];
        AFBS_DiamOff_CaDelay_All = [AFBS_DiamOff_CaDelay_All;DiamOff_CaDelay];
        AFBS_DiamPeak_CaDelay_All = [AFBS_DiamPeak_CaDelay_All;DiamPeak_CaDelay];


        for jj = 1:length(CaOnsetT)
            subplot(3,3,1);hold on;plot([DiamOn_CaDelay(jj) DiamOn_CaDelay(jj)],[0.25 0.75],'r-');
            subplot(3,3,2);hold on;plot([DiamOff_CaDelay(jj) DiamOff_CaDelay(jj)],[0.25 0.75],'b-');
            subplot(3,3,3);hold on;plot([DiamPeak_CaDelay(jj) DiamPeak_CaDelay(jj)],[0.25 0.75],'g-');
        end
    end
end


subplot(3,3,4);hold on;title('BFB1b sas Diam Onset wCaOnset');
plot([0 0],[0 1],'k--');ylim([0 1]);xlim([-30 30]);
subplot(3,3,5);hold on;title('BFB1b sas Diam Offset wCaOnset');
plot([0 0],[0 1],'k--');ylim([0 1]);xlim([-30 30]);
subplot(3,3,6);hold on;title('BFB1b sas Diam Peak wCaOnset');
plot([0 0],[0 1],'k--');ylim([0 1]);xlim([-30 30]);
BFB1b_sas_DiamOn_CaDelay_All=[];
BFB1b_sas_DiamOff_CaDelay_All=[];
BFB1b_sas_DiamPeak_CaDelay_All=[];

for ii = 1:length(BFB1b_sas.CaTransPeakX)
    CaTransPeakX = BFB1b_sas.CaTransPeakX{ii};
    if ~isnan(CaTransPeakX)
        DiamOnsetT = BFB1b_sas.CaOnset(ii);
        DiamOffsetT = BFB1b_sas.CaOnset(ii) + BFB1b_sas.CaDuration(ii);
        DiamPeakT = BFB1b_sas.DiamPeakTime(ii);

        CaTransReg = BFB1b_sas.CaTransReg{ii};
        CaOnsetT = CaTransReg(:,1);

        DiamOn_CaDelay = CaOnsetT-DiamOnsetT;
        DiamOff_CaDelay = CaOnsetT-DiamOffsetT;
        DiamPeak_CaDelay = CaOnsetT-DiamPeakT;

        BFB1b_sas_DiamOn_CaDelay_All = [BFB1b_sas_DiamOn_CaDelay_All;DiamOn_CaDelay];
        BFB1b_sas_DiamOff_CaDelay_All = [BFB1b_sas_DiamOff_CaDelay_All;DiamOff_CaDelay];
        BFB1b_sas_DiamPeak_CaDelay_All = [BFB1b_sas_DiamPeak_CaDelay_All;DiamPeak_CaDelay];


        for jj = 1:length(CaOnsetT)
            subplot(3,3,4);hold on;plot([DiamOn_CaDelay(jj) DiamOn_CaDelay(jj)],[0.25 0.75],'r-');
            subplot(3,3,5);hold on;plot([DiamOff_CaDelay(jj) DiamOff_CaDelay(jj)],[0.25 0.75],'b-');
            subplot(3,3,6);hold on;plot([DiamPeak_CaDelay(jj) DiamPeak_CaDelay(jj)],[0.25 0.75],'g-');
        end
    end
end


subplot(3,3,7);hold on;title('BFB1b pialsheath Diam Onset wCaOnset');
plot([0 0],[0 1],'k--');ylim([0 1]);xlim([-30 30]);
subplot(3,3,8);hold on;title('BFB1b pialsheath Diam Offset wCaOnset');
plot([0 0],[0 1],'k--');ylim([0 1]);xlim([-30 30]);
subplot(3,3,9);hold on;title('BFB1b pialsheath Diam Peak wCaOnset');
plot([0 0],[0 1],'k--');ylim([0 1]);xlim([-30 30]);
BFB1b_ps_DiamOn_CaDelay_All=[];
BFB1b_ps_DiamOff_CaDelay_All=[];
BFB1b_ps_DiamPeak_CaDelay_All=[];

for ii = 1:length(BFB1b_ps.CaTransPeakX)
    CaTransPeakX = BFB1b_ps.CaTransPeakX{ii};
    if ~isnan(CaTransPeakX)
        DiamOnsetT = BFB1b_ps.CaOnset(ii);
        DiamOffsetT = BFB1b_ps.CaOnset(ii) + BFB1b_ps.CaDuration(ii);
        DiamPeakT = BFB1b_ps.DiamPeakTime(ii);

        CaTransReg = BFB1b_ps.CaTransReg{ii};
        CaOnsetT = CaTransReg(:,1);

        DiamOn_CaDelay = CaOnsetT-DiamOnsetT;
        DiamOff_CaDelay = CaOnsetT-DiamOffsetT;
        DiamPeak_CaDelay = CaOnsetT-DiamPeakT;

        BFB1b_ps_DiamOn_CaDelay_All = [BFB1b_ps_DiamOn_CaDelay_All;DiamOn_CaDelay];
        BFB1b_ps_DiamOff_CaDelay_All = [BFB1b_ps_DiamOff_CaDelay_All;DiamOff_CaDelay];
        BFB1b_ps_DiamPeak_CaDelay_All = [BFB1b_ps_DiamPeak_CaDelay_All;DiamPeak_CaDelay];


        for jj = 1:length(CaOnsetT)
            subplot(3,3,7);hold on;plot([DiamOn_CaDelay(jj) DiamOn_CaDelay(jj)],[0.25 0.75],'r-');
            subplot(3,3,8);hold on;plot([DiamOff_CaDelay(jj) DiamOff_CaDelay(jj)],[0.25 0.75],'b-');
            subplot(3,3,9);hold on;plot([DiamPeak_CaDelay(jj) DiamPeak_CaDelay(jj)],[0.25 0.75],'g-');
        end
    end
end

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

saveas(hd10,[SavingFolderName,filesep,'FB_DiamOnOffset_wCaOnset.jpg']);
saveas(hd10,[SavingFolderName,filesep,'FB_DiamOnOffset_wCaOnset.fig']);



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hd11 = figure(11);hold on;

%%%%
subplot(3,3,1);hold on;title('AFBS Diam Onset wCaOnset');
AFBS_DiamOnset=zeros(1,6);
for ii = 1:length(AFBS_DiamOn_CaDelay_All)
    ThisDelay = AFBS_DiamOn_CaDelay_All(ii);
    if ThisDelay>-10 && ThisDelay<25
        MyInd = ceil((ThisDelay+10+0.01)/5);
        if MyInd ==7  continue; end
        AFBS_DiamOnset(MyInd)=AFBS_DiamOnset(MyInd)+1;
    end
end
bar(1:6,AFBS_DiamOnset);
xticks(1:6);
xticklabels({'-10s~-5s','-5s~0s','0s~5s','5s~10s','10s~15s','15s~20s'});

%%%%
subplot(3,3,2);hold on;title('AFBS Diam Offset wCaOnset');
AFBS_DiamOff=zeros(1,6);
for ii = 1:length(AFBS_DiamOff_CaDelay_All)
    ThisDelay = AFBS_DiamOff_CaDelay_All(ii);
    if ThisDelay>-10 && ThisDelay<25
        MyInd = ceil((ThisDelay+10+0.01)/5);
        if MyInd ==7  continue; end
        AFBS_DiamOff(MyInd)=AFBS_DiamOff(MyInd)+1;
    end
end
bar(1:6,AFBS_DiamOff);
xticks(1:6);
xticklabels({'-10s~-5s','-5s~0s','0s~5s','5s~10s','10s~15s','15s~20s'});

%%%%
subplot(3,3,3);hold on;title('AFBS Diam Peak wCaOnset');
AFBS_DiamPeak=zeros(1,6);
for ii = 1:length(AFBS_DiamPeak_CaDelay_All)
    ThisDelay = AFBS_DiamPeak_CaDelay_All(ii);
    if ThisDelay>-10 && ThisDelay<25
        MyInd = ceil((ThisDelay+10+0.01)/5);
        if MyInd ==7  continue; end
        AFBS_DiamPeak(MyInd)=AFBS_DiamPeak(MyInd)+1;
    end
end
bar(1:6,AFBS_DiamPeak);
xticks(1:6);
xticklabels({'-10s~-5s','-5s~0s','0s~5s','5s~10s','10s~15s','15s~20s'});

%%%%
subplot(3,3,4);hold on;title('BFB1b sas Diam Onset');
BFB1b_sas_DiamOnset=zeros(1,6);
for ii = 1:length(BFB1b_sas_DiamOn_CaDelay_All)
    ThisDelay = BFB1b_sas_DiamOn_CaDelay_All(ii);
    if ThisDelay>-10 && ThisDelay<25
        MyInd = ceil((ThisDelay+10+0.01)/5);
        if MyInd ==7  continue; end
        BFB1b_sas_DiamOnset(MyInd)=BFB1b_sas_DiamOnset(MyInd)+1;
    end
end
bar(1:6,BFB1b_sas_DiamOnset);
xticks(1:6);
xticklabels({'-10s~-5s','-5s~0s','0s~5s','5s~10s','10s~15s','15s~20s'});

%%%%
subplot(3,3,5);hold on;title('BFB1b sas Diam Offset');
BFB1b_sas_DiamOff=zeros(1,6);
for ii = 1:length(BFB1b_sas_DiamOff_CaDelay_All)
    ThisDelay = BFB1b_sas_DiamOff_CaDelay_All(ii);
    if ThisDelay>-10 && ThisDelay<25
        MyInd = ceil((ThisDelay+10+0.01)/5);
        if MyInd ==7  continue; end
        BFB1b_sas_DiamOff(MyInd)=BFB1b_sas_DiamOff(MyInd)+1;
    end
end
bar(1:6,BFB1b_sas_DiamOff);
xticks(1:6);
xticklabels({'-10s~-5s','-5s~0s','0s~5s','5s~10s','10s~15s','15s~20s'});

%%%%
subplot(3,3,6);hold on;title('BFB1b sas Diam Peak');
BFB1b_sas_DiamPeak=zeros(1,6);
for ii = 1:length(BFB1b_sas_DiamPeak_CaDelay_All)
    ThisDelay = BFB1b_sas_DiamPeak_CaDelay_All(ii);
    if ThisDelay>-10 && ThisDelay<25
        MyInd = ceil((ThisDelay+10+0.01)/5);
        if MyInd ==7  continue; end
        BFB1b_sas_DiamPeak(MyInd)=BFB1b_sas_DiamPeak(MyInd)+1;
    end
end
bar(1:6,BFB1b_sas_DiamPeak);
xticks(1:6);
xticklabels({'-10s~-5s','-5s~0s','0s~5s','5s~10s','10s~15s','15s~20s'});

%%%%
subplot(3,3,7);hold on;title('BFB1b Pial-sheath Diam Onset');
BFB1b_ps_DiamOnset=zeros(1,6);
for ii = 1:length(BFB1b_ps_DiamOn_CaDelay_All)
    ThisDelay = BFB1b_ps_DiamOn_CaDelay_All(ii);
    if ThisDelay>-10 && ThisDelay<25
        MyInd = ceil((ThisDelay+10+0.01)/5);
        if MyInd ==7  continue; end
        BFB1b_ps_DiamOnset(MyInd)=BFB1b_ps_DiamOnset(MyInd)+1;
    end
end
bar(1:6,BFB1b_ps_DiamOnset);
xticks(1:6);
xticklabels({'-10s~-5s','-5s~0s','0s~5s','5s~10s','10s~15s','15s~20s'});

%%%%
subplot(3,3,8);hold on;title('BFB1b Pial-sheath Diam Offset');
BFB1b_ps_DiamOff=zeros(1,6);
for ii = 1:length(BFB1b_ps_DiamOff_CaDelay_All)
    ThisDelay = BFB1b_ps_DiamOff_CaDelay_All(ii);
    if ThisDelay>-10 && ThisDelay<25
        MyInd = ceil((ThisDelay+10+0.01)/5);
        if MyInd ==7  continue; end
        BFB1b_ps_DiamOff(MyInd)=BFB1b_ps_DiamOff(MyInd)+1;
    end
end
bar(1:6,BFB1b_ps_DiamOff);
xticks(1:6);
xticklabels({'-10s~-5s','-5s~0s','0s~5s','5s~10s','10s~15s','15s~20s'});

%%%%
subplot(3,3,9);hold on;title('BFB1b Pial-sheath Diam Peak');
BFB1b_ps_DiamPeak=zeros(1,6);
for ii = 1:length(BFB1b_ps_DiamPeak_CaDelay_All)
    ThisDelay = BFB1b_ps_DiamPeak_CaDelay_All(ii);
    if ThisDelay>-10 && ThisDelay<25
        MyInd = ceil((ThisDelay+10+0.01)/5);
        if MyInd ==7  continue; end
        BFB1b_ps_DiamPeak(MyInd)=BFB1b_ps_DiamPeak(MyInd)+1;
    end
end
bar(1:6,BFB1b_ps_DiamPeak);
xticks(1:6);
xticklabels({'-10s~-5s','-5s~0s','0s~5s','5s~10s','10s~15s','15s~20s'});

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

saveas(hd11,[SavingFolderName,filesep,'FB_DiamOnOffset_wCaOnset_Barplot.jpg']);
saveas(hd11,[SavingFolderName,filesep,'FB_DiamOnOffset_wCaOnset_Barplot.fig']);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% save into excel file for stat analysis
h3=msgbox('Saving to excel file...');

%%%% AFBS
col_header_STI={'DataName','MouseID','LocID','Date','Diam_PeakAmp(%)','Diam_Durt(s)','Diam_Onset(s)','Diam_AUC(%*s)','Diam_PeakTime(s)','Diam_RisingSlope','Ca_PeakAmp(%)','Ca_Durt(s)','Ca_Onset(s)','Ca_AUC(%*s)','Ca_PeakTime(s)'};
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],{'AFBS'},1,'A1');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],col_header_STI,1,'A3');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.DataName).',1,'A4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.DiamPeakAmp).',1,'E4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.DiamDuration).',1,'F4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.DiamOnset).',1,'G4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.DiamAUC).',1,'H4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.DiamPeakTime).',1,'I4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.DiamRisingSlope).',1,'J4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.CaPeakAmp).',1,'K4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.CaDuration).',1,'L4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS_CaOnset).',1,'M4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.CaAUC).',1,'N4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS_CaPeakTime).',1,'O4');

MouseID_All=cell(size((AFBS.DataName).'));
LocID_All = cell(size((AFBS.DataName).'));
Date_All = cell(size((AFBS.DataName).'));
for i=1:length((AFBS.DataName).')
    % disp(['i=',num2str(i)]);
    ThisDataName = AFBS.DataName{i};
    I = strfind(ThisDataName,'_');
    MouseID_All{i} = ThisDataName(1:I(1)-1);
    LocID_All{i} = ThisDataName(I(1)+1:I(2)-1);
    if length(I)>=3
        Date_All{i} = ThisDataName(I(2)+1:I(3)-1);
    else
        Date_All{i} = ThisDataName(I(2)+1:end);
    end
end
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],MouseID_All,1,'B4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],LocID_All,1,'C4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],Date_All,1,'D4');






xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],{'BFB1b_sas'},2,'A1');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],col_header_STI,2,'A3');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.DataName).',2,'A4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.DiamPeakAmp).',2,'E4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.DiamDuration).',2,'F4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.DiamOnset).',2,'G4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.DiamAUC).',2,'H4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.DiamPeakTime).',2,'I4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.DiamRisingSlope).',2,'J4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.CaPeakAmp).',2,'K4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.CaDuration).',2,'L4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas_CaOnset).',2,'M4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.CaAUC).',2,'N4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas_CaPeakTime).',2,'O4');

MouseID_All=cell(size((BFB1b_sas.DataName).'));
LocID_All = cell(size((BFB1b_sas.DataName).'));
Date_All = cell(size((BFB1b_sas.DataName).'));
for i=1:length((BFB1b_sas.DataName).')
    ThisDataName = BFB1b_sas.DataName{i};
    I = strfind(ThisDataName,'_');
    MouseID_All{i} = ThisDataName(1:I(1)-1);
    LocID_All{i} = ThisDataName(I(1)+1:I(2)-1);
    if length(I)>=3
        Date_All{i} = ThisDataName(I(2)+1:I(3)-1);
    else
        Date_All{i} = ThisDataName(I(2)+1:end);
    end
end
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],MouseID_All,2,'B4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],LocID_All,2,'C4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],Date_All,2,'D4');






xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],{'BFB1b_ps'},3,'A1');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],col_header_STI,3,'A3');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.DataName).',3,'A4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.DiamPeakAmp).',3,'E4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.DiamDuration).',3,'F4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.DiamOnset).',3,'G4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.DiamAUC).',3,'H4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.DiamPeakTime).',3,'I4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.DiamRisingSlope).',3,'J4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.CaPeakAmp).',3,'K4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.CaDuration).',3,'L4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps_CaOnset).',3,'M4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.CaAUC).',3,'N4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps_CaPeakTime).',3,'O4');

MouseID_All=cell(size((BFB1b_ps.DataName).'));
LocID_All = cell(size((BFB1b_ps.DataName).'));
Date_All = cell(size((BFB1b_ps.DataName).'));
for i=1:length((BFB1b_ps.DataName).')
    ThisDataName = BFB1b_ps.DataName{i};
    I = strfind(ThisDataName,'_');
    MouseID_All{i} = ThisDataName(1:I(1)-1);
    LocID_All{i} = ThisDataName(I(1)+1:I(2)-1);
    if length(I)>=3
        Date_All{i} = ThisDataName(I(2)+1:I(3)-1);
    else
        Date_All{i} = ThisDataName(I(2)+1:end);
    end
end
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],MouseID_All,3,'B4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],LocID_All,3,'C4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],Date_All,3,'D4');

close(h3);
