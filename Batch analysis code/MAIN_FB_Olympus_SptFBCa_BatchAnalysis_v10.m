%% any locomotion between 30s and 35s which is higher than 1cm distance are defined as active locomotion. Less than 1cm is definied as without locomotion
clear all;clc;close all;

%% %% Parameter Settings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Celltype='FB Spontaneous Ca New_NoAverage_v2';

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
Filepath{1} = 'D:\ChangsiCai\Chen He\1Chens projects\Fibroblasts\Spontaneous\Arachnoid FBS';
Filepath{2} = 'D:\ChangsiCai\Chen He\1Chens projects\Fibroblasts\Spontaneous\BFB1b FBs';
Filepath{3} = 'D:\ChangsiCai\Chen He\1Chens projects\Fibroblasts\Spontaneous\Endfeet of perivascular FBs';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Premark the time range of locomotion
AFBSLcmtRangeMarks.DataNames{1} = 'Mouse144_loca_20240219_arc';
AFBSLcmtRangeMarks.LcmtReg{1} =[10 60;125 NaN];
AFBSLcmtRangeMarks.BL{1} = [60 75];
AFBSLcmtRangeMarks.avgstdThld{1} = 2;
AFBSLcmtRangeMarks.DataNames{2} = 'Mouse156_locb3_20240221_arc';
AFBSLcmtRangeMarks.LcmtReg{2} =[40 70;110 NaN];
AFBSLcmtRangeMarks.BL{2} = [20 40];
AFBSLcmtRangeMarks.avgstdThld{2} = 2;
AFBSLcmtRangeMarks.DataNames{3} = 'Mouse156_locd_20240401_arc';
AFBSLcmtRangeMarks.LcmtReg{3} =[NaN NaN];
AFBSLcmtRangeMarks.BL{3} = [20 30];
AFBSLcmtRangeMarks.avgstdThld{3} = 2;
AFBSLcmtRangeMarks.DataNames{4} = 'Mouse166_loc3_20240528_arc';
AFBSLcmtRangeMarks.LcmtReg{4} = [75 NaN];
AFBSLcmtRangeMarks.BL{4} = [20 40];
AFBSLcmtRangeMarks.avgstdThld{4} = 2;
AFBSLcmtRangeMarks.DataNames{5} = 'Mouse166_loca_20240503_arc';
AFBSLcmtRangeMarks.LcmtReg{5} = [NaN NaN];
AFBSLcmtRangeMarks.BL{5} = [1 45;60 67];     
AFBSLcmtRangeMarks.avgstdThld{5} = 2;
AFBSLcmtRangeMarks.DataNames{6} = 'Mouse166_loca_20240508_left_arc';
AFBSLcmtRangeMarks.LcmtReg{6} = [NaN NaN];
AFBSLcmtRangeMarks.BL{6} = [1 35;100 120];
AFBSLcmtRangeMarks.avgstdThld{6} = 2;
AFBSLcmtRangeMarks.DataNames{7} = 'Mouse166_loca_20240508_right_arc';
AFBSLcmtRangeMarks.LcmtReg{7} = [NaN NaN];
AFBSLcmtRangeMarks.BL{7} = [25 55];
AFBSLcmtRangeMarks.avgstdThld{7} = 2;
AFBSLcmtRangeMarks.DataNames{8} = 'Mouse166_locc_20240508_arc';
AFBSLcmtRangeMarks.LcmtReg{8} = [NaN NaN];
AFBSLcmtRangeMarks.BL{8} = [60 90];
AFBSLcmtRangeMarks.avgstdThld{8} = 2;
AFBSLcmtRangeMarks.DataNames{9} = 'Mouse214_locb_20241031_arc_no6';
AFBSLcmtRangeMarks.LcmtReg{9} = [NaN NaN];
AFBSLcmtRangeMarks.BL{9} = [1 10;40 60;95 110;120 139];
AFBSLcmtRangeMarks.avgstdThld{9} = 2;
AFBSLcmtRangeMarks.DataNames{10} = 'Mouse214_locc_20241031_arc_no10';
AFBSLcmtRangeMarks.LcmtReg{10} = [NaN NaN];
AFBSLcmtRangeMarks.BL{10} = [90 110];
AFBSLcmtRangeMarks.avgstdThld{10} = 1.8;
AFBSLcmtRangeMarks.DataNames{11} = 'Mouse15_loca_20241031_arc_no1';
AFBSLcmtRangeMarks.LcmtReg{11} = [70 NaN];
AFBSLcmtRangeMarks.BL{11} = [1 60];
AFBSLcmtRangeMarks.avgstdThld{11} = 1.8;
AFBSLcmtRangeMarks.DataNames{12} = 'Mouse15_locb_20241031_arc_no5';
AFBSLcmtRangeMarks.LcmtReg{12} = [NaN NaN];
AFBSLcmtRangeMarks.BL{12} = [15 30;65 85;100 120];
AFBSLcmtRangeMarks.avgstdThld{12} = 1.5;
AFBSLcmtRangeMarks.DataNames{13} = 'Mouse15_locb_20241031_arc_no6';
AFBSLcmtRangeMarks.LcmtReg{13} = [NaN NaN];
AFBSLcmtRangeMarks.BL{13} = [40 60];
AFBSLcmtRangeMarks.avgstdThld{13} = 2;
AFBSLcmtRangeMarks.DataNames{14} = 'Mouse15_locc_20241031_arc_no7';
AFBSLcmtRangeMarks.LcmtReg{14} = [NaN NaN];
AFBSLcmtRangeMarks.BL{14} = [60 90];
AFBSLcmtRangeMarks.avgstdThld{14} = 1.5;
AFBSLcmtRangeMarks.DataNames{15} = 'Mouse15_locc_20241031_arc_no11';
AFBSLcmtRangeMarks.LcmtReg{15} = [NaN NaN];
AFBSLcmtRangeMarks.BL{15} = [20 40];
AFBSLcmtRangeMarks.avgstdThld{15} = 2;
AFBSLcmtRangeMarks.DataNames{16} = 'Mouse39_loca_20241031_arc_no2';
AFBSLcmtRangeMarks.LcmtReg{16} = [NaN NaN];
AFBSLcmtRangeMarks.BL{16} = [20 50];
AFBSLcmtRangeMarks.avgstdThld{16} = 2.5;
AFBSLcmtRangeMarks.DataNames{17} = 'Mouse39_locc_20241031_arc_no12';
AFBSLcmtRangeMarks.LcmtReg{17} = [NaN NaN];
AFBSLcmtRangeMarks.BL{17} = [60 100];
AFBSLcmtRangeMarks.avgstdThld{17} = 2.5;
AFBSLcmtRangeMarks.DataNames{18} = 'Mouse87_locb2_20240219_arc_airpuff';
AFBSLcmtRangeMarks.LcmtReg{18} = [10 50];
AFBSLcmtRangeMarks.BL{18} = [60 80];
AFBSLcmtRangeMarks.avgstdThld{18} = 2;



BFB1b_sasLcmtRangeMarks.DataNames{1} = 'Mouse166_loc3_20240528_BFB1b';
BFB1b_sasLcmtRangeMarks.LcmtReg{1} =[75 NaN];
BFB1b_sasLcmtRangeMarks.BL{1} = [25 40;50 60];
BFB1b_sasLcmtRangeMarks.avgstdThld{1} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{2} = 'Mouse166_loca_20240503_BFB1b_left1';
BFB1b_sasLcmtRangeMarks.LcmtReg{2} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{2} = [25 39];
BFB1b_sasLcmtRangeMarks.avgstdThld{2} = 2.5;
BFB1b_sasLcmtRangeMarks.DataNames{3} = 'Mouse166_loca_20240503_BFB1b_left2';
BFB1b_sasLcmtRangeMarks.LcmtReg{3} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{3} = [85 105];
BFB1b_sasLcmtRangeMarks.avgstdThld{3} = 1.5;
BFB1b_sasLcmtRangeMarks.DataNames{4} = 'Mouse166_loca_20240503_BFB1b_right1';
BFB1b_sasLcmtRangeMarks.LcmtReg{4} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{4} = [13 42];
BFB1b_sasLcmtRangeMarks.avgstdThld{4} = 2.5;
BFB1b_sasLcmtRangeMarks.DataNames{5} = 'Mouse166_loca_20240503_BFB1b_right2';
BFB1b_sasLcmtRangeMarks.LcmtReg{5} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{5} = [36 55];
BFB1b_sasLcmtRangeMarks.avgstdThld{5} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{6} = 'Mouse166_loca_20240508_BFB1b_left1';
BFB1b_sasLcmtRangeMarks.LcmtReg{6} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{6} = [90 105];
BFB1b_sasLcmtRangeMarks.avgstdThld{6} = 1.5;
BFB1b_sasLcmtRangeMarks.DataNames{7} = 'Mouse166_loca_20240508_BFB1b_left2';
BFB1b_sasLcmtRangeMarks.LcmtReg{7} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{7} = [30 60];
BFB1b_sasLcmtRangeMarks.avgstdThld{7} = 1.2;
BFB1b_sasLcmtRangeMarks.DataNames{8} = 'Mouse166_loca_20240508_BFB1b_left3';
BFB1b_sasLcmtRangeMarks.LcmtReg{8} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{8} = [50 78];
BFB1b_sasLcmtRangeMarks.avgstdThld{8} = 2.5;
BFB1b_sasLcmtRangeMarks.DataNames{9} = 'Mouse166_loca_20240508_BFB1b_right1';
BFB1b_sasLcmtRangeMarks.LcmtReg{9} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{9} = [55 77];
BFB1b_sasLcmtRangeMarks.avgstdThld{9} = 2.1;
BFB1b_sasLcmtRangeMarks.DataNames{10} = 'Mouse166_locc_20240508_BFB1b_left1';
BFB1b_sasLcmtRangeMarks.LcmtReg{10} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{10} = [20 55];
BFB1b_sasLcmtRangeMarks.avgstdThld{10} = 2.1;
BFB1b_sasLcmtRangeMarks.DataNames{11} = 'Mouse166_locc_20240508_BFB1b_left2';
BFB1b_sasLcmtRangeMarks.LcmtReg{11} =[115 NaN];
BFB1b_sasLcmtRangeMarks.BL{11} = [1 15];
BFB1b_sasLcmtRangeMarks.avgstdThld{11} = 1.5;
BFB1b_sasLcmtRangeMarks.DataNames{12} = 'Mouse166_locd_20240514_BFB1b';
BFB1b_sasLcmtRangeMarks.LcmtReg{12} =[80 NaN];
BFB1b_sasLcmtRangeMarks.BL{12} = [70 80];
BFB1b_sasLcmtRangeMarks.avgstdThld{12} = 1.5;
BFB1b_sasLcmtRangeMarks.DataNames{13} = 'Mouse214_locb_20241031_BFB1b_left_no6';
BFB1b_sasLcmtRangeMarks.LcmtReg{13} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{13} = [60 80];
BFB1b_sasLcmtRangeMarks.avgstdThld{13} = 2.5;
BFB1b_sasLcmtRangeMarks.DataNames{14} = 'Mouse214_locb_20241031_BFB1b_right_no6';
BFB1b_sasLcmtRangeMarks.LcmtReg{14} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{14} = [17 45];
BFB1b_sasLcmtRangeMarks.avgstdThld{14} = 2.5;
BFB1b_sasLcmtRangeMarks.DataNames{15} = 'Mouse214_locc_20241031_BFB1b_left_no10';
BFB1b_sasLcmtRangeMarks.LcmtReg{15} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{15} = [40 60];
BFB1b_sasLcmtRangeMarks.avgstdThld{15} = 1.8;
BFB1b_sasLcmtRangeMarks.DataNames{16} = 'Mouse214_locc_20241031_BFB1b_right_no10';
BFB1b_sasLcmtRangeMarks.LcmtReg{16} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{16} = [20 60];
BFB1b_sasLcmtRangeMarks.avgstdThld{16} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{17} = 'Mouse15_loca_20241031_BFB1b_no1';
BFB1b_sasLcmtRangeMarks.LcmtReg{17} =[70 90];
BFB1b_sasLcmtRangeMarks.BL{17} = [60 75];
BFB1b_sasLcmtRangeMarks.avgstdThld{17} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{18} = 'Mouse15_locb_20241031_BFB1b_no5_left';
BFB1b_sasLcmtRangeMarks.LcmtReg{18} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{18} = [55 70];
BFB1b_sasLcmtRangeMarks.avgstdThld{18} = 1.7;
BFB1b_sasLcmtRangeMarks.DataNames{19} = 'Mouse15_locb_20241031_BFB1b_no5_right';  %#######
BFB1b_sasLcmtRangeMarks.LcmtReg{19} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{19} = [5 10;40 58];
BFB1b_sasLcmtRangeMarks.avgstdThld{19} = 1.5;
BFB1b_sasLcmtRangeMarks.DataNames{20} = 'Mouse15_locb_20241031_BFB1b_no6_left';
BFB1b_sasLcmtRangeMarks.LcmtReg{20} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{20} = [5 25;40 60];
BFB1b_sasLcmtRangeMarks.avgstdThld{20} = 2.5;
BFB1b_sasLcmtRangeMarks.DataNames{21} = 'Mouse15_locb_20241031_BFB1b_no6_right';
BFB1b_sasLcmtRangeMarks.LcmtReg{21} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{21} = [20 60];
BFB1b_sasLcmtRangeMarks.avgstdThld{21} = 3;
BFB1b_sasLcmtRangeMarks.DataNames{22} = 'Mouse15_locc_20241031_BFB1b_no7_left';
BFB1b_sasLcmtRangeMarks.LcmtReg{22} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{22} = [20 40;80 100];
BFB1b_sasLcmtRangeMarks.avgstdThld{22} = 1.5;
BFB1b_sasLcmtRangeMarks.DataNames{23} = 'Mouse15_locc_20241031_BFB1b_no7_right';
BFB1b_sasLcmtRangeMarks.LcmtReg{23} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{23} = [20 30;45 60;100 120];
BFB1b_sasLcmtRangeMarks.avgstdThld{23} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{24} = 'Mouse15_locc_20241031_BFB1b_no11_left';
BFB1b_sasLcmtRangeMarks.LcmtReg{24} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{24} = [1 15;71 90];
BFB1b_sasLcmtRangeMarks.avgstdThld{24} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{25} = 'Mouse15_locc_20241031_BFB1b_no11_right';
BFB1b_sasLcmtRangeMarks.LcmtReg{25} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{25} = [1 110];
BFB1b_sasLcmtRangeMarks.avgstdThld{25} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{26} = 'Mouse39_loca_20241031_BFB1b_no2_left';
BFB1b_sasLcmtRangeMarks.LcmtReg{26} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{26} = [1 20];
BFB1b_sasLcmtRangeMarks.avgstdThld{26} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{27} = 'Mouse39_loca_20241031_BFB1b_no2_right';
BFB1b_sasLcmtRangeMarks.LcmtReg{27} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{27} = [40 55;65 80];
BFB1b_sasLcmtRangeMarks.avgstdThld{27} = 3;
BFB1b_sasLcmtRangeMarks.DataNames{28} = 'Mouse87_locb2_20240219_BFB1b_right1_airpuff';
BFB1b_sasLcmtRangeMarks.LcmtReg{28} =[10 50];
BFB1b_sasLcmtRangeMarks.BL{28} = [60 80];
BFB1b_sasLcmtRangeMarks.avgstdThld{28} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{29} = 'Mouse87_locb2_20240219_BFB1b_right2_airpuff';
BFB1b_sasLcmtRangeMarks.LcmtReg{29} =[10 50];
BFB1b_sasLcmtRangeMarks.BL{29} = [60 150];
BFB1b_sasLcmtRangeMarks.avgstdThld{29} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{30} = 'Mouse144_loca_20240219_BFB1b_left';
BFB1b_sasLcmtRangeMarks.LcmtReg{30} =[5 30];
BFB1b_sasLcmtRangeMarks.BL{30} = [60 75];
BFB1b_sasLcmtRangeMarks.avgstdThld{30} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{31} = 'Mouse144_loca_20240219_BFB1b_right1';
BFB1b_sasLcmtRangeMarks.LcmtReg{31} =[5 40];
BFB1b_sasLcmtRangeMarks.BL{31} = [80 100];
BFB1b_sasLcmtRangeMarks.avgstdThld{31} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{32} = 'Mouse144_loca_20240219_BFB1b_right2';
BFB1b_sasLcmtRangeMarks.LcmtReg{32} =[5 40];
BFB1b_sasLcmtRangeMarks.BL{32} = [80 110];
BFB1b_sasLcmtRangeMarks.avgstdThld{32} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{33} = 'Mouse156_locb3_20240221_BFB1b_left';
BFB1b_sasLcmtRangeMarks.LcmtReg{33} =[48 80;115 NaN];
BFB1b_sasLcmtRangeMarks.BL{33} = [20 40];
BFB1b_sasLcmtRangeMarks.avgstdThld{33} = 2;
BFB1b_sasLcmtRangeMarks.DataNames{34} = 'Mouse156_locb3_20240221_BFB1b_right';
BFB1b_sasLcmtRangeMarks.LcmtReg{34} =[45 80;115 NaN];
BFB1b_sasLcmtRangeMarks.BL{34} = [1 30];
BFB1b_sasLcmtRangeMarks.avgstdThld{34} = 2.5;
BFB1b_sasLcmtRangeMarks.DataNames{35} = 'Mouse156_locd_20240401_BFB1b';
BFB1b_sasLcmtRangeMarks.LcmtReg{35} =[NaN NaN];
BFB1b_sasLcmtRangeMarks.BL{35} = [85 100];
BFB1b_sasLcmtRangeMarks.avgstdThld{35} = 2;





BFB1b_psLcmtRangeMarks.DataNames{1} = 'Mouse144_loca_20240219_pial sheath';
BFB1b_psLcmtRangeMarks.LcmtReg{1} =[5 40];
BFB1b_psLcmtRangeMarks.BL{1} = [40 83];
BFB1b_psLcmtRangeMarks.avgstdThld{1} = 2;
BFB1b_psLcmtRangeMarks.DataNames{2} = 'Mouse156_locd_20240401_pial sheath';
BFB1b_psLcmtRangeMarks.LcmtReg{2} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{2} = [10 40];
BFB1b_psLcmtRangeMarks.avgstdThld{2} = 2;
BFB1b_psLcmtRangeMarks.DataNames{3} = 'Mouse166_loc3_20240528_pial sheath';
BFB1b_psLcmtRangeMarks.LcmtReg{3} =[70 NaN];
BFB1b_psLcmtRangeMarks.BL{3} = [20 35];
BFB1b_psLcmtRangeMarks.avgstdThld{3} = 2;
BFB1b_psLcmtRangeMarks.DataNames{4} = 'Mouse166_loca_20240503_left_pial sheath';
BFB1b_psLcmtRangeMarks.LcmtReg{4} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{4} = [1 60];
BFB1b_psLcmtRangeMarks.avgstdThld{4} = 2.5;
BFB1b_psLcmtRangeMarks.DataNames{5} = 'Mouse166_loca_20240503_right_pial sheath';
BFB1b_psLcmtRangeMarks.LcmtReg{5} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{5} = [10 30];
BFB1b_psLcmtRangeMarks.avgstdThld{5} = 2.5;
BFB1b_psLcmtRangeMarks.DataNames{6} = 'Mouse166_loca_20240508_pial sheath';
BFB1b_psLcmtRangeMarks.LcmtReg{6} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{6} = [60 90];
BFB1b_psLcmtRangeMarks.avgstdThld{6} = 2;
BFB1b_psLcmtRangeMarks.DataNames{7} = 'Mouse166_locc_20240508_pial sheath';
BFB1b_psLcmtRangeMarks.LcmtReg{7} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{7} = [1 35];
BFB1b_psLcmtRangeMarks.avgstdThld{7} = 2.2;
BFB1b_psLcmtRangeMarks.DataNames{8} = 'Mouse166_locd3_20240514_pial sheath';
BFB1b_psLcmtRangeMarks.LcmtReg{8} =[20 40];
BFB1b_psLcmtRangeMarks.BL{8} = [1 19];
BFB1b_psLcmtRangeMarks.avgstdThld{8} = 2;
BFB1b_psLcmtRangeMarks.DataNames{9} = 'Mouse166_locd5_20240514_left_pial sheath';
BFB1b_psLcmtRangeMarks.LcmtReg{9} =[90 NaN];
BFB1b_psLcmtRangeMarks.BL{9} = [1 40];
BFB1b_psLcmtRangeMarks.avgstdThld{9} = 2.3;
BFB1b_psLcmtRangeMarks.DataNames{10} = 'Mouse166_locd5_20240514_right_pial sheath';
BFB1b_psLcmtRangeMarks.LcmtReg{10} =[90 NaN];
BFB1b_psLcmtRangeMarks.BL{10} = [20 35];
BFB1b_psLcmtRangeMarks.avgstdThld{10} = 2.5;
BFB1b_psLcmtRangeMarks.DataNames{11} = 'Mouse87_locb2_20240219_pial sheath_air puff';
BFB1b_psLcmtRangeMarks.LcmtReg{11} =[10 50];
BFB1b_psLcmtRangeMarks.BL{11} = [90 150];
BFB1b_psLcmtRangeMarks.avgstdThld{11} = 2;
BFB1b_psLcmtRangeMarks.DataNames{12} = 'Mouse214_locc_20241031_left_pial sheath_no10';
BFB1b_psLcmtRangeMarks.LcmtReg{12} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{12} = [20 90];
BFB1b_psLcmtRangeMarks.avgstdThld{12} = 2.1;
BFB1b_psLcmtRangeMarks.DataNames{13} = 'Mouse214_locc_20241031_right_pial sheath_no10';
BFB1b_psLcmtRangeMarks.LcmtReg{13} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{13} = [5 25];
BFB1b_psLcmtRangeMarks.avgstdThld{13} = 2;
BFB1b_psLcmtRangeMarks.DataNames{14} = 'Mouse15_loca_20241031_pial sheath_no1';
BFB1b_psLcmtRangeMarks.LcmtReg{14} =[75 90];
BFB1b_psLcmtRangeMarks.BL{14} = [35 65];
BFB1b_psLcmtRangeMarks.avgstdThld{14} = 2.2;
BFB1b_psLcmtRangeMarks.DataNames{15} = 'Mouse15_locb_20241031_pial sheath_left_no5';
BFB1b_psLcmtRangeMarks.LcmtReg{15} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{15} = [1 60;90 110];
BFB1b_psLcmtRangeMarks.avgstdThld{15} = 1.8;
BFB1b_psLcmtRangeMarks.DataNames{16} = 'Mouse15_locb_20241031_pial sheath_left_no6';
BFB1b_psLcmtRangeMarks.LcmtReg{16} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{16} = [1 30;45 75];
BFB1b_psLcmtRangeMarks.avgstdThld{16} = 2.5;
BFB1b_psLcmtRangeMarks.DataNames{17} = 'Mouse15_locb_20241031_pial sheath_right_no5';
BFB1b_psLcmtRangeMarks.LcmtReg{17} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{17} = [1 55];
BFB1b_psLcmtRangeMarks.avgstdThld{17} = 2.5;
BFB1b_psLcmtRangeMarks.DataNames{18} = 'Mouse15_locb_20241031_pial sheath_right_no6';
BFB1b_psLcmtRangeMarks.LcmtReg{18} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{18} = [20 40;60 78];
BFB1b_psLcmtRangeMarks.avgstdThld{18} = 1.7;
BFB1b_psLcmtRangeMarks.DataNames{19} = 'Mouse15_locc_20241031_pial sheath_no7';
BFB1b_psLcmtRangeMarks.LcmtReg{19} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{19} = [50 120];
BFB1b_psLcmtRangeMarks.avgstdThld{19} = 2.5;
BFB1b_psLcmtRangeMarks.DataNames{20} = 'Mouse15_locc_20241031_pial sheath_right_no11';
BFB1b_psLcmtRangeMarks.LcmtReg{20} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{20} = [20 80];
BFB1b_psLcmtRangeMarks.avgstdThld{20} = 2;
BFB1b_psLcmtRangeMarks.DataNames{21} = 'Mouse39_locb_20241031_pial sheath_no7';
BFB1b_psLcmtRangeMarks.LcmtReg{21} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{21} = [1 40;55 70];
BFB1b_psLcmtRangeMarks.avgstdThld{21} = 1.8;
BFB1b_psLcmtRangeMarks.DataNames{22} = 'Mouse39_locc_20241031_pial sheath_left_no12';
BFB1b_psLcmtRangeMarks.LcmtReg{22} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{22} = [40 90];
BFB1b_psLcmtRangeMarks.avgstdThld{22} = 2.2;
BFB1b_psLcmtRangeMarks.DataNames{23} = 'Mouse39_locc_20241031_pial sheath_right_no12';
BFB1b_psLcmtRangeMarks.LcmtReg{23} =[NaN NaN];
BFB1b_psLcmtRangeMarks.BL{23} = [35 80];
BFB1b_psLcmtRangeMarks.avgstdThld{23} = 2.5;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PreDurt = -5;   %%%%%%% the perios used as baseline
ExaminedDurt = 20;    %%%%%% examine the period of 20s post whisking event

% AirPuffEventDurt = 20;    %%%%%% i believe that the Ca, Diam back to baseline after air puff, and treat as spontaneous after that

TimeStampInterval = 0.05;

% AirPuffTime = 40;

SptFBBin_Time = PreDurt:TimeStampInterval:ExaminedDurt;

SptLcmtExtraTime = 15;
SptLcmtPreTime = 3;

MyMeanStdThld = 2.5;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MouseInfo = struct();

MouseInfo.MouseID=[];
MouseInfo.LocID=[];
MouseInfo.ExpDate=[];
MouseInfo.RepNum=[];
MouseInfo.FrameTime=[];
MouseInfo.FullName=[];

AFBS.SptFBCountNum = 1;
AFBS.DiamTraceAll = {};
AFBS.CaTraceAll = {};
AFBS.CaPeakAmp = NaN(1,100); 
AFBS.CaTransAUC = NaN(1,100); 
AFBS.CaTransDurt = NaN(1,100); 
AFBS.CaTransTTmin = NaN(1,100);   % transient times per min
AFBS.CaTransTTminArea = NaN(1,100);   % transient times per min per area
AFBS.CaTransTPrct = NaN(1,100);   % Percentage of time have Ca transients

AFBS.DataName = {};
AFBS.DataNameCaFreq = {};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BFB1b_sas.SptFBCountNum = 1;
BFB1b_sas.DiamTraceAll = {};
BFB1b_sas.CaTraceAll = {};
BFB1b_sas.CaPeakAmp = NaN(1,100); 
BFB1b_sas.CaTransAUC = NaN(1,100); 
BFB1b_sas.CaTransDurt = NaN(1,100); 
BFB1b_sas.CaTransTTmin = NaN(1,100);   % transient times per min
BFB1b_sas.CaTransTTminArea = NaN(1,100);   % transient times per min per area
BFB1b_sas.CaTransTPrct = NaN(1,100);   % Percentage of time have Ca transients

BFB1b_sas.DataName = {};
BFB1b_sas.DataNameCaFreq = {};


%%%%%%%%%%%%%%%%%%%%%%


BFB1b_ps.SptFBCountNum = 1;
BFB1b_ps.DiamTraceAll = {};
BFB1b_ps.CaTraceAll = {};
BFB1b_ps.CaPeakAmp = NaN(1,100); 
BFB1b_ps.CaTransAUC = NaN(1,100); 
BFB1b_ps.CaTransDurt = NaN(1,100); 
BFB1b_ps.CaTransTTmin = NaN(1,100);   % transient times per min
BFB1b_ps.CaTransTTminArea = NaN(1,100);   % transient times per min per area
BFB1b_ps.CaTransTPrct = NaN(1,100);   % Percentage of time have Ca transients

BFB1b_ps.DataName = {};
BFB1b_ps.DataNameCaFreq = {};

%%%%%%%%%%%%%%%%%%%%%%%%%

All_LcmtTraceStartTime = NaN(1,100);
All_LcmtTraceEndTime = NaN(1,100);
All_LcmtTraceName = cell(1,100);
All_LcmtTraceAgeGroup = cell(1,100);
All_LcmtCountNum = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%

PreDurt_PN = round(PreDurt/TimeStampInterval);   % point number (PN)
ExaminedDurt_PN = round(ExaminedDurt/TimeStampInterval);
% AirPuffEventDurt_PN = round(AirPuffEventDurt/TimeStampInterval);

%%% sort the ROI legend

DataNumCount = 0;
DataNumCount_AllLoc = [0 0 0]; % the 3 numbers are the ROI number for each ROIrealname

ROILegendLut = {'AFBS','BFB1b_sas','BFB1b_ps'};
ROIRealName = {'AFBS','BFB1b_sas','BFB1b_ps'};
ROILegendColInd=[1 2 3];
ColorCollection='rbgmcyk';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% excel file setting

ColName = {'MouseID','LocID','Date','CapOrder','DataType','PeakAmp','PeakTime','OnsetTime','Duration','FallingTime','AUC','RisingSlope'};
RowCount = 0;

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
        % LcmtBin_Time = PreDurt:TimeStampInterval:ExaminedDurt;

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
        hd2 = figure(2); clf(hd2);


        CurrentDataPath = [Allfiles(j).folder,filesep,Allfiles(j).name];
        filePattern_diam = dir([CurrentDataPath,filesep,'TPM',filesep,'*Dia_AllParameters.mat']);
        fullname_diam = [filePattern_diam.folder,filesep,filePattern_diam.name];
        load(fullname_diam);

        Diam_time = myTimeTicks;
        DiamWaves = fig4_waves;

        %%%% Read in ROI area from a spreadsheet
        filePattern_ROIarea= dir([CurrentDataPath,filesep,'TPM',filesep,'New Microsoft Excel Worksheet.xlsx']);
        fullname_ROIarea = [filePattern_ROIarea.folder,filesep,filePattern_ROIarea.name];
        ROIarea_all = xlsread(fullname_ROIarea);



        %%%% Read in EC Calcium
        filePattern_Ca = dir([CurrentDataPath,filesep,'TPM',filesep,'*_AnalysisParameters.mat']);
        fullname_Ca = [filePattern_Ca.folder,filesep,filePattern_Ca.name];
        LoadedCaData = load(fullname_Ca);

        if i==1
            DiamROINames = 'AFBS';
            CaROINames = 'AFBS';

            Ca_time = LoadedCaData.myTimeTicks;
            CaWaves = LoadedCaData.ROI_GCh_CaWave_All;
            % CaWaves = smooth(CaWaves,3);
        elseif i==2
            DiamROINames = 'BFB1b_sas';
            CaROINames = 'BFB1b_sas';

            Ca_time = LoadedCaData.myTimeTicks;
            CaWaves = LoadedCaData.ROI_GCh_CaWave_All;
            % CaWaves = smooth(CaWaves,3);
        elseif i==3
            DiamROINames = 'BFB1b_ps';
            CaROINames = 'BFB1b_ps';

            if isfield(LoadedCaData, 'myTimeTag')
                Ca_time = LoadedCaData.myTimeTag;
                CaWaves = LoadedCaData.EC_Ca_Signal_norm;
            else
                Ca_time = LoadedCaData.myTimeTicks;
                CaWaves = LoadedCaData.ROI_GCh_CaWave_All;
            end
            % CaWaves = smooth(CaWaves,3);
            
        end

        if isequal(length(Diam_time),length(Ca_time))
            myTime_TPM = Ca_time;
        else
            disp('Error 6: The two pial artery times are not identical');
            pause;
        end

        if length(ROIarea_all)~=size(CaWaves,1)
            disp('Error 7: Roi area in xls file is not equal to Ca measurement.');
        end

        

        if size(DiamWaves,1)==1
            % CaWaves = mean(CaWaves,1);
            % if size(CaWaves,1)~=1
            %     pause(1);
            % end
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


            Ca_tmp_interp = interp1(myTime_TPM,Ca_tmp2,TimeStampInterp);
            Ca_waveNew_interp(k,:) = Ca_tmp_interp;

            Diam_tmp = DiamWaves(1,:);
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
            MyPercentile = 70;
            ThisBL = cell(size(CaWaves,1),1);
            for kk = 1:length(AFBSLcmtRangeMarks.DataNames)
                ThisNameTmp = AFBSLcmtRangeMarks.DataNames{kk};
                if strcmp(ThisNameTmp,CurrentDataName)
                    ThisLcmtReg = AFBSLcmtRangeMarks.LcmtReg{kk};
                    % ThisBL = AFBSLcmtRangeMarks.BL{kk};
                    continue;
                end
            end        

            %%%%%% try the percentile algorithm to estimate the baseline
            for k=1:size(Ca_waveNew_interp,1)
                ThisCurve = Ca_waveNew_interp(k,:);
                threshold = prctile(ThisCurve, MyPercentile);             
                II = find(ThisCurve<=threshold);
                ThisBL{k} = II;

            end
            

        elseif i==2
            MyPercentile = 50;
            ThisBL = cell(size(CaWaves,1),1);
            for kk = 1:length(BFB1b_sasLcmtRangeMarks.DataNames)
                ThisNameTmp = BFB1b_sasLcmtRangeMarks.DataNames{kk};
                if strcmp(ThisNameTmp,CurrentDataName)
                    ThisLcmtReg = BFB1b_sasLcmtRangeMarks.LcmtReg{kk};
                    % ThisBL = BFB1b_sasLcmtRangeMarks.BL{kk};
                    continue;
                end
            end 

            %%%%%% try the percentile algorithm to estimate the baseline
            for k=1:size(Ca_waveNew_interp,1)
                ThisCurve = Ca_waveNew_interp(k,:);
                threshold = prctile(ThisCurve, MyPercentile);             
                II = find(ThisCurve<=threshold);
                ThisBL{k} = II;

            end



        elseif i==3
            MyPercentile = 70;
            ThisBL = cell(size(CaWaves,1),1);
            for kk = 1:length(BFB1b_psLcmtRangeMarks.DataNames)
                ThisNameTmp = BFB1b_psLcmtRangeMarks.DataNames{kk};
                if strcmp(ThisNameTmp,CurrentDataName)
                    ThisLcmtReg = BFB1b_psLcmtRangeMarks.LcmtReg{kk};
                    % ThisBL = BFB1b_psLcmtRangeMarks.BL{kk};
                    continue;
                end
            end

            %%%%%% try the percentile algorithm to estimate the baseline
            for k=1:size(Ca_waveNew_interp,1)
                ThisCurve = Ca_waveNew_interp(k,:);
                threshold = prctile(ThisCurve, MyPercentile);             
                II = find(ThisCurve<=threshold);
                ThisBL{k} = II;

            end

        end

        %%%% normalize to the baseline
        % II=[];
        % 
        % for ttt = 1:size(ThisBL,1)
        % 
        %     IItemp = find(TimeStampInterp>=ThisBL(ttt,1) & TimeStampInterp<=ThisBL(ttt,2));
        %     II = [II IItemp];
        % end

        % if size(ThisBL,1)>=3
        %     xtemp = TimeStampInterp(II);
        %     ytemp = Ca_waveNew_interp(II);
        %     p = polyfit(xtemp,ytemp,1);
        %     Ca_BL_temp = polyval(p,TimeStampInterp);   % linear drift of the baseline, we gonna remove it
        %     Ca_waveNew_interp = Ca_waveNew_interp - Ca_BL_temp+1;
        % end
        
        for k=1:size(Ca_waveNew_interp,1)
            Diam_waveNew_interp(k,:) = Diam_waveNew_interp(k,:)./mean(Diam_waveNew_interp(k,ThisBL{k}));
            Ca_waveNew_interp(k,:) = Ca_waveNew_interp(k,:)./mean(Ca_waveNew_interp(k,ThisBL{k}));
        end


        %%%%%%%%%%%%%%%%%%%%% plot
        hd1=figure(1);
        clf(hd1);

        hd1 = figure(1); hold on;
        subplot(3,1,1);hold on;
        ROIInd = find(strcmp(DiamROINames,ROIRealName));
        plot(TimeStampInterp,Diam_waveNew_interp,'k');
        % plot(TimeStampInterp,Diam_waveNew_interp,ColorCollection(ROIInd));
        % legend(ROIRealName{ROIInd});

        title([CurrentDataName_figtitle, '      Diameter',' (i=',num2str(i),' j=',num2str(j),')']);

        subplot(3,1,2);hold on;
        ROIInd = find(strcmp(CaROINames,ROIRealName));
        for k = 1:size(Ca_waveNew_interp,1)
            plot(TimeStampInterp,Ca_waveNew_interp(k,:),ColorCollection(k));
        end
        % plot(TimeStampInterp,Ca_waveNew_interp,ColorCollection(ROIInd));
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

        % CaBLcurves = Ca_waveNew_interp(II);


        %%%%%% equalize all three subplots
        % subplot(3,1,1);mylim=ylim;plot([AirPuffTime AirPuffTime],mylim*0.99,'m--');
        % subplot(3,1,2);mylim=ylim;plot([AirPuffTime AirPuffTime],mylim*0.99,'m--');
        % subplot(3,1,3);mylim=ylim;plot([AirPuffTime AirPuffTime],mylim*0.99,'m--');


        subplot(3,1,1);hold on;xlim([0 TimeLength]);
        subplot(3,1,2);hold on;xlim([0 TimeLength]);
        subplot(3,1,3);hold on;xlim([0 TimeLength]);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%% start to analyze the spontaneous FB Ca %%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% find the mask of spontaneous period by defining the mask
        SptFBCaMask = ones(size(TimeStampInterp));

        for k = 1:size(ThisLcmtReg,1)
            x1 = ThisLcmtReg(k,1);
            x2 = ThisLcmtReg(k,2);

            if isnan(x1) && isnan(x2)
                break;
            elseif ~isnan(x1) && isnan(x2)
                x2 = TimeStampInterp(end);
            end

            [C,I] = find(TimeStampInterp>x1 & TimeStampInterp<x2);
            LcmtMaskCut0 = Mask_lcmt_interp(I);
            [C2,I2] = find(LcmtMaskCut0);
            % 
            LcmtStartTime = TimeStampInterp(I(1)+I2(1)-1);
            LcmtStartTime2 = TimeStampInterp(I(1)+I2(1)-1)-SptLcmtPreTime;
            if LcmtStartTime2 <=0
                LcmtStartTime2 = TimeStampInterp(1);
            end
            LcmtEndTime = TimeStampInterp(I(1)+I2(end)-1)+SptLcmtExtraTime;   % count another 10s after lcmt is finished

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

            [C3,I3] = find(TimeStampInterp>LcmtStartTime2 & TimeStampInterp<LcmtEndTime);
            SptFBCaMask(I3) = 0;

        end

        %% examine the spotaneous FB ca2+ events during this period of time
        CutAwayMask = 1-SptFBCaMask;
        Diam_waveNew_interp_clean = Diam_waveNew_interp;
        Diam_waveNew_interp_clean(:,find(CutAwayMask)) = 1;

        Ca_waveNew_interp_clearn = Ca_waveNew_interp;
        Ca_waveNew_interp_clearn(:,find(CutAwayMask)) = 1;

        ThisOrderName_Ca=CaROINames;
        ThisOrderName_Diam=DiamROINames;

        RowCount = RowCount+1;
%% %%%%%%%%%%%%%%%%%%%%%%%%
        if strcmp(ThisOrderName_Ca,'BFB1b_sas')

            index = find(cellfun(@(x) strcmp(x,CurrentDataName),BFB1b_sasLcmtRangeMarks.DataNames));

            for k=1:size(Ca_waveNew_interp,1)

                % [CaTransRegCord,CaTransRegTime,CaTransPeakY,CaTransAUC,CaTransDurt,CaTransMask] = AnalysisPeaks_Spt_ThldAvg2Std_4FBCa_AllTime_v11(TimeStampInterp,Ca_waveNew_interp_clearn(k,:),'BFB1b-sas Ca',ThisBL{k},BFB1b_sasLcmtRangeMarks.avgstdThld{index});
                [CaTransRegCord,CaTransRegTime,CaTransPeakY,CaTransAUC,CaTransDurt,CaTransMask] = AnalysisPeaks_Spt_ThldAvg2Std_4FBCa_AllTime_v12(TimeStampInterp,Ca_waveNew_interp_clearn(k,:),'BFB1b-sas Ca',ThisBL{k},MyMeanStdThld);

                hd2=figure(2);subplot(size(Ca_waveNew_interp,1),1,k);
                hold on; legend('off');
                if k==1
                    title([CurrentDataName_figtitle, '      Diameter',' (i=',num2str(i),' j=',num2str(j),')']);

                else
                    title(['Ca2+ ROI ',num2str(k)]);
                end
                plot(TimeStampInterp,Ca_waveNew_interp(k,:),ColorCollection(k));

          
            
            
                if ~isnan(CaTransRegTime)
                    for kkk=1:size(CaTransRegTime,1)

                        mylim=ylim; yll=mylim(2)-mylim(1);
                        fill([CaTransRegTime(kkk,1), CaTransRegTime(kkk,2), CaTransRegTime(kkk,2), CaTransRegTime(kkk,1)],[0.05*yll+mylim(1) 0.05*yll+mylim(1) 0.95*yll+mylim(1) 0.95*yll+mylim(1)],ColorCollection(k),'FaceAlpha',0.2);


                        BFB1b_sas.DataName{BFB1b_sas.SptFBCountNum+kkk-1} = CurrentDataName_figtitle;

                        %% Extract the traces
                        Start_PN = CaTransRegCord(kkk,1) + PreDurt_PN;
                        End_PN = CaTransRegCord(kkk,1) + ExaminedDurt_PN;
                        ThisCaTrace = NaN(size(SptFBBin_Time));
                        ThisDiamTrace = NaN(size(SptFBBin_Time));
                        if Start_PN<1
                            Start_Ind = Start_PN*(-1)+2;
                            ThisCaTrace(Start_Ind:end) = Ca_waveNew_interp(k,1:End_PN);
                            ThisDiamTrace(Start_Ind:end) = Diam_waveNew_interp(k,1:End_PN);

                        elseif End_PN>length(TimeStampInterp)
                            End_Ind = End_PN - length(TimeStampInterp);
                            ThisCaTrace(1:length(Ca_waveNew_interp)-Start_PN+1) = Ca_waveNew_interp(k,Start_PN:end);
                            ThisDiamTrace(1:length(Diam_waveNew_interp)-Start_PN+1) = Diam_waveNew_interp(k,Start_PN:end);

                        else
                            ThisCaTrace = Ca_waveNew_interp(k,Start_PN:End_PN);
                            ThisDiamTrace = Diam_waveNew_interp(k,Start_PN:End_PN);

                        end
                        BFB1b_sas.CaTraceAll{BFB1b_sas.SptFBCountNum+kkk-1} = ThisCaTrace;
                        BFB1b_sas.DiamTraceAll{BFB1b_sas.SptFBCountNum+kkk-1} = ThisDiamTrace;
                        BFB1b_sas.DataNameCaFreq{BFB1b_sas.SptFBCountNum} = CurrentDataName_figtitle;
                    end

                    %%% register down
                    BFB1b_sas.CaPeakAmp(BFB1b_sas.SptFBCountNum:BFB1b_sas.SptFBCountNum+length(CaTransPeakY)-1) = CaTransPeakY.';
                    BFB1b_sas.CaTransAUC(BFB1b_sas.SptFBCountNum:BFB1b_sas.SptFBCountNum+length(CaTransPeakY)-1) = CaTransAUC.';
                    BFB1b_sas.CaTransDurt(BFB1b_sas.SptFBCountNum:BFB1b_sas.SptFBCountNum+length(CaTransPeakY)-1) = CaTransDurt.';


                    BFB1b_sas.CaTransTPrct(BFB1b_sas.SptFBCountNum) = sum(CaTransMask)./sum(SptFBCaMask);
                    BFB1b_sas.CaTransTTmin(BFB1b_sas.SptFBCountNum) = length(CaTransPeakY)/(sum(SptFBCaMask)*TimeStampInterval)*60;
                    BFB1b_sas.CaTransTTminArea(BFB1b_sas.SptFBCountNum) = length(CaTransPeakY)/(sum(SptFBCaMask)*TimeStampInterval)*60/ROIarea_all(k);

                    BFB1b_ps.DataNameCaFreq{BFB1b_ps.SptFBCountNum} = CurrentDataName_figtitle;
                end



                BFB1b_sas.SptFBCountNum = BFB1b_sas.SptFBCountNum+length(CaTransPeakY);

                mylim=ylim; yll=mylim(2)-mylim(1);
                plot(TimeStampInterp(ThisBL{k}),Ca_waveNew_interp(k,ThisBL{k}),'k*');

                ThisBLmeantemp = mean(Ca_waveNew_interp(k,ThisBL{k}),'omitnan');
                plot([TimeStampInterp(1) TimeStampInterp(end)],[ThisBLmeantemp ThisBLmeantemp],'k-');

                ThisBLstdtemp = std(Ca_waveNew_interp(k,ThisBL{k}),'omitnan');
                % plot([TimeStampInterp(1) TimeStampInterp(end)],[ThisBLmeantemp+ThisBLstdtemp*BFB1b_sasLcmtRangeMarks.avgstdThld{index} ThisBLmeantemp+ThisBLstdtemp*BFB1b_sasLcmtRangeMarks.avgstdThld{index}],'k--');
                plot([TimeStampInterp(1) TimeStampInterp(end)],[ThisBLmeantemp+ThisBLstdtemp*MyMeanStdThld ThisBLmeantemp+ThisBLstdtemp*MyMeanStdThld],'k--');

            end



            %% %%%%%%%%%%%%%%%%%%%%%%%%
        elseif strcmp(ThisOrderName_Ca,'BFB1b_ps')

            index = find(cellfun(@(x) strcmp(x,CurrentDataName),BFB1b_psLcmtRangeMarks.DataNames));

            for k=1:size(Ca_waveNew_interp,1)

                % [CaTransRegCord,CaTransRegTime,CaTransPeakY,CaTransAUC,CaTransDurt,CaTransMask] = AnalysisPeaks_Spt_ThldAvg2Std_4FBCa_AllTime_v11(TimeStampInterp,Ca_waveNew_interp_clearn,'BFB1b_ps',ThisBL{k},BFB1b_psLcmtRangeMarks.avgstdThld{index});
                [CaTransRegCord,CaTransRegTime,CaTransPeakY,CaTransAUC,CaTransDurt,CaTransMask] = AnalysisPeaks_Spt_ThldAvg2Std_4FBCa_AllTime_v12(TimeStampInterp,Ca_waveNew_interp_clearn,'BFB1b_ps',ThisBL{k},MyMeanStdThld);

                hd2=figure(2);subplot(size(Ca_waveNew_interp,1),1,k);
                hold on; legend('off');
                if k==1
                    title([CurrentDataName_figtitle, '      Diameter',' (i=',num2str(i),' j=',num2str(j),')']);

                else
                    title(['Ca2+ ROI ',num2str(k)]);
                end
                plot(TimeStampInterp,Ca_waveNew_interp(k,:),ColorCollection(k));
          


            if ~isnan(CaTransRegTime)
                for kkk=1:size(CaTransRegTime,1)

                    mylim=ylim; yll=mylim(2)-mylim(1);
                    fill([CaTransRegTime(kkk,1), CaTransRegTime(kkk,2), CaTransRegTime(kkk,2), CaTransRegTime(kkk,1)],[0.05*yll+mylim(1) 0.05*yll+mylim(1) 0.95*yll+mylim(1) 0.95*yll+mylim(1)],ColorCollection(k),'FaceAlpha',0.2);
                    
                    BFB1b_ps.DataName{BFB1b_ps.SptFBCountNum+kkk-1} = CurrentDataName_figtitle;

                    %% Extract the traces                    
                    Start_PN = CaTransRegCord(kkk,1) + PreDurt_PN;
                    End_PN = CaTransRegCord(kkk,1) + ExaminedDurt_PN;
                    ThisCaTrace = NaN(size(SptFBBin_Time));
                    ThisDiamTrace = NaN(size(SptFBBin_Time));
                    if Start_PN<1
                       Start_Ind = Start_PN*(-1)+2;
                       ThisCaTrace(Start_Ind:end) = Ca_waveNew_interp(k,1:End_PN);
                       ThisDiamTrace(Start_Ind:end) = Diam_waveNew_interp(k,1:End_PN);
                    
                    elseif End_PN>length(TimeStampInterp)
                        End_Ind = End_PN - length(TimeStampInterp);
                        ThisCaTrace(1:length(Ca_waveNew_interp)-Start_PN+1) = Ca_waveNew_interp(k,Start_PN:end);
                        ThisDiamTrace(1:length(Diam_waveNew_interp)-Start_PN+1) = Diam_waveNew_interp(k,Start_PN:end);

                    else
                        ThisCaTrace = Ca_waveNew_interp(k,Start_PN:End_PN);
                        ThisDiamTrace = Diam_waveNew_interp(k,Start_PN:End_PN);

                    end
                    BFB1b_ps.CaTraceAll{BFB1b_ps.SptFBCountNum+kkk-1} = ThisCaTrace;
                    BFB1b_ps.DiamTraceAll{BFB1b_ps.SptFBCountNum+kkk-1} = ThisDiamTrace;
                end

                %%% register down
                BFB1b_ps.CaPeakAmp(BFB1b_ps.SptFBCountNum:BFB1b_ps.SptFBCountNum+length(CaTransPeakY)-1) = CaTransPeakY.';
                BFB1b_ps.CaTransAUC(BFB1b_ps.SptFBCountNum:BFB1b_ps.SptFBCountNum+length(CaTransPeakY)-1) = CaTransAUC.';
                BFB1b_ps.CaTransDurt(BFB1b_ps.SptFBCountNum:BFB1b_ps.SptFBCountNum+length(CaTransPeakY)-1) = CaTransDurt.';

                BFB1b_ps.CaTransTPrct(BFB1b_ps.SptFBCountNum) = sum(CaTransMask)./sum(SptFBCaMask);
                BFB1b_ps.CaTransTTmin(BFB1b_ps.SptFBCountNum) = length(CaTransPeakY)/(sum(SptFBCaMask)*TimeStampInterval)*60;
                BFB1b_ps.CaTransTTminArea(BFB1b_ps.SptFBCountNum) = length(CaTransPeakY)/(sum(SptFBCaMask)*TimeStampInterval)*60/ROIarea_all(k);

                BFB1b_ps.DataNameCaFreq{BFB1b_ps.SptFBCountNum} = CurrentDataName_figtitle;
            end



            BFB1b_ps.SptFBCountNum = BFB1b_ps.SptFBCountNum+length(CaTransPeakY);

            % mylim=ylim; yll=mylim(2)-mylim(1);
            % plot(TimeStampInterp(II),Ca_waveNew_interp(k,II),'k*');
            % 
            % 
            % ThisBLmeantemp = mean(Ca_waveNew_interp(k,II),'omitnan');
            % plot([TimeStampInterp(1) TimeStampInterp(end)],[ThisBLmeantemp ThisBLmeantemp],'k-');
            % 
            % ThisBLstdtemp = std(Ca_waveNew_interp(k,II),'omitnan');
            % plot([TimeStampInterp(1) TimeStampInterp(end)],[ThisBLmeantemp+ThisBLstdtemp*BFB1b_psLcmtRangeMarks.avgstdThld{index} ThisBLmeantemp+ThisBLstdtemp*BFB1b_psLcmtRangeMarks.avgstdThld{index}],'k--');

                mylim=ylim; yll=mylim(2)-mylim(1);
                plot(TimeStampInterp(ThisBL{k}),Ca_waveNew_interp(k,ThisBL{k}),'k*');

                ThisBLmeantemp = mean(Ca_waveNew_interp(k,ThisBL{k}),'omitnan');
                plot([TimeStampInterp(1) TimeStampInterp(end)],[ThisBLmeantemp ThisBLmeantemp],'k-');

                ThisBLstdtemp = std(Ca_waveNew_interp(k,ThisBL{k}),'omitnan');
                plot([TimeStampInterp(1) TimeStampInterp(end)],[ThisBLmeantemp+ThisBLstdtemp*MyMeanStdThld ThisBLmeantemp+ThisBLstdtemp*MyMeanStdThld],'k--');


            end


%% %%%%%%%%%%%%%%%%%%%%%%%%
        elseif strcmp(ThisOrderName_Ca,'AFBS')

            index = find(cellfun(@(x) strcmp(x,CurrentDataName),AFBSLcmtRangeMarks.DataNames));


            for k=1:size(Ca_waveNew_interp,1)
                % [CaTransRegCord,CaTransRegTime,CaTransPeakY,CaTransAUC,CaTransDurt,CaTransMask] = AnalysisPeaks_Spt_ThldAvg2Std_4FBCa_AllTime_v11(TimeStampInterp,Ca_waveNew_interp_clearn(k,:),'AFBS',ThisBL{k},AFBSLcmtRangeMarks.avgstdThld{index});
                [CaTransRegCord,CaTransRegTime,CaTransPeakY,CaTransAUC,CaTransDurt,CaTransMask] = AnalysisPeaks_Spt_ThldAvg2Std_4FBCa_AllTime_v12(TimeStampInterp,Ca_waveNew_interp_clearn(k,:),'AFBS',ThisBL{k},MyMeanStdThld);

                hd2=figure(2);subplot(size(Ca_waveNew_interp,1),1,k);
                hold on; legend('off');
                if k==1
                    title([CurrentDataName_figtitle, '      Diameter',' (i=',num2str(i),' j=',num2str(j),')']);

                else
                    title(['Ca2+ ROI ',num2str(k)]);
                end
                plot(TimeStampInterp,Ca_waveNew_interp(k,:),ColorCollection(k));

                if ~isnan(CaTransRegTime)
                    for kkk=1:size(CaTransRegTime,1)

                        mylim=ylim; yll=mylim(2)-mylim(1);
                        fill([CaTransRegTime(kkk,1), CaTransRegTime(kkk,2), CaTransRegTime(kkk,2), CaTransRegTime(kkk,1)],[0.05*yll+mylim(1) 0.05*yll+mylim(1) 0.95*yll+mylim(1) 0.95*yll+mylim(1)],ColorCollection(k),'FaceAlpha',0.2);

                        AFBS.DataName{AFBS.SptFBCountNum+kkk-1} = CurrentDataName_figtitle;

                        %% Extract the traces
                        Start_PN = CaTransRegCord(kkk,1) + PreDurt_PN;
                        End_PN = CaTransRegCord(kkk,1) + ExaminedDurt_PN;
                        ThisCaTrace = NaN(size(SptFBBin_Time));
                        ThisDiamTrace = NaN(size(SptFBBin_Time));
                        if Start_PN<1
                            Start_Ind = Start_PN*(-1)+2;
                            ThisCaTrace(Start_Ind:end) = Ca_waveNew_interp(k,1:End_PN);
                            ThisDiamTrace(Start_Ind:end) = Diam_waveNew_interp(k,1:End_PN);

                        elseif End_PN>length(TimeStampInterp)
                            End_Ind = End_PN - length(TimeStampInterp);
                            ThisCaTrace(1:length(Ca_waveNew_interp)-Start_PN+1) = Ca_waveNew_interp(k,Start_PN:end);
                            ThisDiamTrace(1:length(Diam_waveNew_interp)-Start_PN+1) = Diam_waveNew_interp(k,Start_PN:end);

                        else
                            ThisCaTrace = Ca_waveNew_interp(k,Start_PN:End_PN);
                            ThisDiamTrace = Diam_waveNew_interp(k,Start_PN:End_PN);

                        end

                        % if all(isnan(ThisCaTrace))
                        %     pause;
                        % end

                        AFBS.CaTraceAll{AFBS.SptFBCountNum+kkk-1} = ThisCaTrace;
                        AFBS.DiamTraceAll{AFBS.SptFBCountNum+kkk-1} = ThisDiamTrace;
                    end

                    %%% register down
                    AFBS.CaPeakAmp(AFBS.SptFBCountNum:AFBS.SptFBCountNum+length(CaTransPeakY)-1) = CaTransPeakY.';
                    if isnan(CaTransPeakY)
                        pause;
                    end

                    AFBS.CaTransAUC(AFBS.SptFBCountNum:AFBS.SptFBCountNum+length(CaTransPeakY)-1) = CaTransAUC.';
                    AFBS.CaTransDurt(AFBS.SptFBCountNum:AFBS.SptFBCountNum+length(CaTransPeakY)-1) = CaTransDurt.';

                    AFBS.CaTransTPrct(AFBS.SptFBCountNum) = sum(CaTransMask)./sum(SptFBCaMask);
                    AFBS.CaTransTTmin(AFBS.SptFBCountNum) = length(CaTransPeakY)/(sum(SptFBCaMask)*TimeStampInterval)*60;
                    AFBS.CaTransTTminArea(AFBS.SptFBCountNum) = length(CaTransPeakY)/(sum(SptFBCaMask)*TimeStampInterval)*60/ROIarea_all(k);

                    AFBS.DataNameCaFreq{AFBS.SptFBCountNum} = CurrentDataName_figtitle;
                end

                AFBS.SptFBCountNum = AFBS.SptFBCountNum+length(CaTransPeakY);

                % mylim=ylim; yll=mylim(2)-mylim(1);
                % plot(TimeStampInterp(II),Ca_waveNew_interp(k,II),'k*');
                %
                %
                % ThisBLmeantemp = mean(Ca_waveNew_interp(k,II),'omitnan');
                % plot([TimeStampInterp(1) TimeStampInterp(end)],[ThisBLmeantemp ThisBLmeantemp],'k-');
                %
                % ThisBLstdtemp = std(Ca_waveNew_interp(k,II),'omitnan');
                % plot([TimeStampInterp(1) TimeStampInterp(end)],[ThisBLmeantemp+ThisBLstdtemp*AFBSLcmtRangeMarks.avgstdThld{index} ThisBLmeantemp+ThisBLstdtemp*AFBSLcmtRangeMarks.avgstdThld{index}],'k--');

                mylim=ylim; yll=mylim(2)-mylim(1);
                plot(TimeStampInterp(ThisBL{k}),Ca_waveNew_interp(k,ThisBL{k}),'k*');

                ThisBLmeantemp = mean(Ca_waveNew_interp(k,ThisBL{k}),'omitnan');
                plot([TimeStampInterp(1) TimeStampInterp(end)],[ThisBLmeantemp ThisBLmeantemp],'k-');

                ThisBLstdtemp = std(Ca_waveNew_interp(k,ThisBL{k}),'omitnan');
                plot([TimeStampInterp(1) TimeStampInterp(end)],[ThisBLmeantemp+ThisBLstdtemp*MyMeanStdThld ThisBLmeantemp+ThisBLstdtemp*MyMeanStdThld],'k--');

            end

            % pause;
        end

        
        set(hd1, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);
        set(hd2, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        saveas(hd1,[SavingFolderName2,filesep,DiamROINames,'-',CurrentDataName,'.jpg']);
        saveas(hd1,[SavingFolderName2,filesep,DiamROINames,'-',CurrentDataName,'.fig']);

        saveas(hd2,[SavingFolderName2,filesep,DiamROINames,'-',CurrentDataName,'-IndividualROIs.jpg']);
        saveas(hd2,[SavingFolderName2,filesep,DiamROINames,'-',CurrentDataName,'-IndividualROIs.fig']);

        pause(0.5);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% overlay the traces
hd2=figure(2);hold on;
DiamColor='rrrrr';
CaColor='gggg';

SptFBBin_Time_New = SptFBBin_Time+0.5;

subplot(1,3,1),hold on;
AFBS_CaTraceAll = NaN(length(AFBS.CaTraceAll{1}),length(AFBS.CaTraceAll));
AFBS_DiamTraceAll = NaN(length(AFBS.CaTraceAll{1}),length(AFBS.CaTraceAll));
for i=1:length(AFBS.CaTraceAll)
    CaTmp = AFBS.CaTraceAll{i};
    if length(CaTmp)
    if ~all(isnan(CaTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8)))
    CaTmp = CaTmp./mean(CaTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8),'omitnan');
    end
    AFBS_CaTraceAll(:,i) = CaTmp;

    DiamTmp = AFBS.DiamTraceAll{i};
    if ~all(isnan(DiamTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8)))
    DiamTmp = DiamTmp./mean(DiamTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8),'omitnan');
    end
    DiamTmp = DiamTmp./mean(DiamTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8),'omitnan');
    AFBS_DiamTraceAll(:,i) = DiamTmp;
    end
end

stdshade_changsi_v2(AFBS_DiamTraceAll.',0.5,DiamColor(1),SptFBBin_Time_New);
stdshade_changsi_v2(AFBS_CaTraceAll.',0.5,CaColor(1),SptFBBin_Time_New);
ylabel('TPM');
ylim([0.95 1.25]); 
plot([0 0],[0.96 1.24],'k--');
title('AFBS (Gch-Ca, Rch-Diam）');


subplot(1,3,2),hold on;
BFB1b_sas_CaTraceAll = NaN(length(BFB1b_sas.CaTraceAll{1}),length(BFB1b_sas.CaTraceAll));
BFB1b_sas_DiamTraceAll = NaN(length(BFB1b_sas.CaTraceAll{1}),length(BFB1b_sas.CaTraceAll));
for i=1:length(BFB1b_sas.CaTraceAll)
    % disp(['i=',num2str(i)]);
    CaTmp = BFB1b_sas.CaTraceAll{i};
    if length(CaTmp)
        if ~all(isnan(CaTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8)))
            CaTmp = CaTmp./mean(CaTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8),'omitnan');
        end
        BFB1b_sas_CaTraceAll(:,i) = CaTmp;

        DiamTmp = BFB1b_sas.DiamTraceAll{i};
        if ~all(isnan(DiamTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8)))
            DiamTmp = DiamTmp./mean(DiamTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8),'omitnan');
        end
        BFB1b_sas_DiamTraceAll(:,i) = DiamTmp;
    end
end
stdshade_changsi_v2(BFB1b_sas_DiamTraceAll.',0.5,DiamColor(1),SptFBBin_Time_New);
stdshade_changsi_v2(BFB1b_sas_CaTraceAll.',0.5,CaColor(1),SptFBBin_Time_New);
ylabel('TPM');
ylim([0.95 1.25]);
plot([0 0],[0.96 1.24],'k--');
title('BFB1b-sas (Gch-Ca, Rch-Diam）');


subplot(1,3,3),hold on;
BFB1b_ps_CaTraceAll = NaN(length(BFB1b_ps.CaTraceAll{1}),length(BFB1b_ps.CaTraceAll));
BFB1b_ps_DiamTraceAll = NaN(length(BFB1b_ps.CaTraceAll{1}),length(BFB1b_ps.CaTraceAll));
for i=1:length(BFB1b_ps.CaTraceAll)
    CaTmp = BFB1b_ps.CaTraceAll{i};
    if length(CaTmp)
        if ~all(isnan(CaTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8)))
            CaTmp = CaTmp./mean(CaTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8),'omitnan');
        end
        BFB1b_ps_CaTraceAll(:,i) = CaTmp;

        DiamTmp = BFB1b_ps.DiamTraceAll{i};
        if ~all(isnan(DiamTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8)))
            DiamTmp = DiamTmp./mean(DiamTmp(PreDurt_PN*(-1)*0.4:PreDurt_PN*(-1)*0.8),'omitnan');
        end
        BFB1b_ps_DiamTraceAll(:,i) = DiamTmp;
    end
end
stdshade_changsi_v2(BFB1b_ps_DiamTraceAll.',0.5,DiamColor(1),SptFBBin_Time_New);
stdshade_changsi_v2(BFB1b_ps_CaTraceAll.',0.5,CaColor(1),SptFBBin_Time_New);
ylabel('TPM');
ylim([0.95 1.25]);
plot([0 0],[0.96 1.24],'k--');
title('BFB1b-ps (Gch-Ca, Rch-Diam）');

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

saveas(hd2,[SavingFolderName,filesep,'FB_OverlayByBFLoc.jpg']);
saveas(hd2,[SavingFolderName,filesep,'FB_OverlayByBFLoc.fig']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% overlay the traces
hd3=figure(3);hold on;

subplot(1,2,1),hold on;
plot(SptFBBin_Time_New,mean(AFBS_DiamTraceAll,2,'omitnan'),'r-');
plot(SptFBBin_Time_New,mean(BFB1b_sas_DiamTraceAll,2,'omitnan'),'b-');
plot(SptFBBin_Time_New,mean(BFB1b_ps_DiamTraceAll,2,'omitnan'),'g-');
stdshade_changsi_v2(AFBS_DiamTraceAll.',0.5,'r',SptFBBin_Time_New);
stdshade_changsi_v2(BFB1b_sas_DiamTraceAll.',0.5,'b',SptFBBin_Time_New);
stdshade_changsi_v2(BFB1b_ps_DiamTraceAll.',0.5,'g',SptFBBin_Time_New);
legend({'AFBS','BFB1b-sas','BFB1b-Pialsheath'});
ylabel('TPM');
title('Diameter');
ylim([0.98 1.02]);
plot([0 0],[0.98 1.02],'k--');


subplot(1,2,2),hold on;
plot(SptFBBin_Time_New,mean(AFBS_CaTraceAll,2,'omitnan'),'r-');
plot(SptFBBin_Time_New,mean(BFB1b_sas_CaTraceAll,2,'omitnan'),'b-');
plot(SptFBBin_Time_New,mean(BFB1b_ps_CaTraceAll,2,'omitnan'),'g-');
stdshade_changsi_v2(AFBS_CaTraceAll.',0.5,'r',SptFBBin_Time_New);
stdshade_changsi_v2(BFB1b_sas_CaTraceAll.',0.5,'b',SptFBBin_Time_New);
stdshade_changsi_v2(BFB1b_ps_CaTraceAll.',0.5,'g',SptFBBin_Time_New);
legend({'AFBS','BFB1b-sas','BFB1b-Pialsheath'});
ylabel('TPM');
title('Ca');
ylim([0.95 1.25]);
plot([0 0],[0.96 1.24],'k--');

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

saveas(hd3,[SavingFolderName,filesep,'FB_OverlayByDiamCa.jpg']);
saveas(hd3,[SavingFolderName,filesep,'FB_OverlayByDiamCa.fig']);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% % FB Diam curves 2D imagesc

hd31 = figure(31);hold on;

ThisStartTime = 0;
ThisEndTime = 20;  % unit:sec

ThisPreDurt = 0-PreDurt;
PlotLength = ThisEndTime./TimeStampInterval;

Icount = (0-PreDurt)/(SptFBBin_Time_New(3)-SptFBBin_Time_New(2));

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
AFBSDiamCurves = AFBS_DiamTraceAll.';
AFBSDiamCurvesCut = AFBSDiamCurves(:,1:PlotLength);
% AFBSDiamCurvesCut_sort = SortPeakTime_lcmt(AFBSDiamCurvesCut,SptFBBin_Time_New(:,1:PlotLength),0);
imagesc(AFBSDiamCurvesCut,[0.9 1.1]); title('AFBS Diam');
plot([Icount,Icount],[0.5 size(AFBSDiamCurvesCut,1)+0.5],'w--','LineWidth',2);
box off;colorbar;
ylabel('Trace No.');
xticks(TimeTagDesigntick);
xticklabels(TimeTagDesign_str);
xlim([TimeTagDesigntick(1)+15 TimeTagDesigntick(end)]);
% ylim([0 28]);


subplot(3,1,2); hold on;
BFB1b_sasDiamCurves = BFB1b_sas_DiamTraceAll.';
BFB1b_sasDiamCurvesCut = BFB1b_sasDiamCurves(:,1:PlotLength);
% BFB1b_sasDiamCurvesCut_sort = SortPeakTime_lcmt(BFB1b_sasDiamCurvesCut,LcmtBin_Time(:,1:PlotLength),0);
imagesc(BFB1b_sasDiamCurvesCut,[0.9 1.1]); title('BFB1b-sas Diam');
plot([Icount,Icount],[0.5 size(BFB1b_sasDiamCurvesCut,1)+0.5],'w--','LineWidth',2);
box off;colorbar;
ylabel('Trace No.');
xticks(TimeTagDesigntick);
xticklabels(TimeTagDesign_str);
xlim([TimeTagDesigntick(1)+15 TimeTagDesigntick(end)]);
% ylim([0 28]);

subplot(3,1,3); hold on;
BFB1b_psDiamCurves = BFB1b_ps_DiamTraceAll.';
BFB1b_psDiamCurvesCut = BFB1b_psDiamCurves(:,1:PlotLength);
% BFB1b_psDiamCurvesCut_sort = SortPeakTime_lcmt(BFB1b_psDiamCurvesCut,LcmtBin_Time(:,1:PlotLength),0);
imagesc(BFB1b_psDiamCurvesCut,[0.9 1.1]); title('BFB1b-ps Diam');
plot([Icount,Icount],[0.5 size(BFB1b_psDiamCurvesCut,1)+0.5],'w--','LineWidth',2);
box off;colorbar;
ylabel('Trace No.');
xticks(TimeTagDesigntick);
xticklabels(TimeTagDesign_str);
xlim([TimeTagDesigntick(1)+15 TimeTagDesigntick(end)]);
% ylim([0 28]);
xlabel('Time (s)');

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

saveas(hd31,[SavingFolderName,filesep,'FB_Diam_2Dimage.jpg']);
saveas(hd31,[SavingFolderName,filesep,'FB_Diam_2Dimage.fig']);


%% %%%%%%%%%%%%%%%%%%%%%%%% FB Ca curves 2D imagesc

hd32 = figure(32);hold on;



subplot(3,1,1); hold on;
AFBSCaCurves = AFBS_CaTraceAll.';
AFBSCaCurvesCut = AFBSCaCurves(:,1:PlotLength);
AFBSCaCurvesCut_bl = mean(AFBSCaCurvesCut(:,1:Icount),2);
bl_nan = find(isnan(AFBSCaCurvesCut_bl));
AFBSCaCurvesCut(bl_nan,:) = [];
% AFBSCaCurvesCut_sort = SortPeakTime_lcmt(AFBSCaCurvesCut,LcmtBin_Time(:,1:PlotLength),0);
imagesc(AFBSCaCurvesCut,[0.9 1.5]); title('AFBS Ca');
plot([Icount,Icount],[0.5 size(AFBSCaCurvesCut,1)+0.5],'w--','LineWidth',2);
box off;colorbar;
ylabel('Trace No.');
xticks(TimeTagDesigntick);
xticklabels(TimeTagDesign_str);
xlim([TimeTagDesigntick(1)+15 TimeTagDesigntick(end)]);
% ylim([0 26]);


subplot(3,1,2); hold on;
BFB1b_sasCaCurves = BFB1b_sas_CaTraceAll.';
BFB1b_sasCaCurvesCut = BFB1b_sasCaCurves(:,1:PlotLength);
BFB1b_sasCaCurvesCut_bl = mean(BFB1b_sasCaCurvesCut(:,1:Icount),2);
bl_nan = find(isnan(BFB1b_sasCaCurvesCut_bl));
BFB1b_sasCaCurvesCut(bl_nan,:) = [];
% BFB1b_sasCaCurvesCut_sort = SortPeakTime_lcmt(BFB1b_sasCaCurvesCut,LcmtBin_Time(:,1:PlotLength),0);
imagesc(BFB1b_sasCaCurvesCut,[0.9 1.5]); title('BFB1b-sas Ca');
plot([Icount,Icount],[0.5 size(BFB1b_sasCaCurvesCut,1)+0.5],'w--','LineWidth',2);
box off;colorbar;
ylabel('Trace No.');
xticks(TimeTagDesigntick);
xticklabels(TimeTagDesign_str);
xlim([TimeTagDesigntick(1)+15 TimeTagDesigntick(end)]);
% ylim([0 26]);

subplot(3,1,3); hold on;
BFB1b_psCaCurves = BFB1b_ps_CaTraceAll.';
BFB1b_psCaCurvesCut = BFB1b_psCaCurves(:,1:PlotLength);
BFB1b_psCaCurvesCut_bl = mean(BFB1b_psCaCurvesCut(:,1:Icount),2);
bl_nan = find(isnan(BFB1b_psCaCurvesCut_bl));
BFB1b_psCaCurvesCut(bl_nan,:) = [];
% BFB1b_psCaCurvesCut_sort = SortPeakTime_lcmt(BFB1b_psCaCurvesCut,LcmtBin_Time(:,1:PlotLength),0);
imagesc(BFB1b_psCaCurvesCut,[0.9 1.5]); title('BFB1b-ps Ca');
plot([Icount,Icount],[0.5 size(BFB1b_psCaCurvesCut,1)+0.5],'w--','LineWidth',2);
box off;colorbar;
ylabel('Trace No.');
xticks(TimeTagDesigntick);
xticklabels(TimeTagDesign_str);
xlim([TimeTagDesigntick(1)+15 TimeTagDesigntick(end)]);
ylim([0 26]);
xlabel('Time (s)');

set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);

saveas(hd32,[SavingFolderName,filesep,'FB_Ca_2Dimage.jpg']);
saveas(hd32,[SavingFolderName,filesep,'FB_Ca_2Dimage.fig']);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%% bar plots Ca2+
hd5=figure(5);hold on;

subplot(2,3,1);hold on;
mean_pial = mean(AFBS.CaPeakAmp,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.CaPeakAmp,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.CaPeakAmp,'omitnan');

std_pial = std(AFBS.CaPeakAmp,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.CaPeakAmp,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.CaPeakAmp,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS.CaPeakAmp)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.CaPeakAmp,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.CaPeakAmp)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.CaPeakAmp,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.CaPeakAmp)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.CaPeakAmp,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('peak amplitude (%)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Ca2+ peak amplitude']);
mylim=ylim;


mylim=ylim;
PlotStatStars2(hd5,2,3,1,AFBS.CaPeakAmp,BFB1b_sas.CaPeakAmp,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd5,2,3,1,BFB1b_sas.CaPeakAmp,BFB1b_ps.CaPeakAmp,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd5,2,3,1,AFBS.CaPeakAmp,BFB1b_ps.CaPeakAmp,[1 3],mylim(2)*0.93,3);



%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots  Ca
%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots  Ca Duration

subplot(2,3,2);hold on;
mean_pial = mean(AFBS.CaTransDurt,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.CaTransDurt,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.CaTransDurt,'omitnan');

std_pial = std(AFBS.CaTransDurt,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.CaTransDurt,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.CaTransDurt,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS.CaTransDurt)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.CaTransDurt,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.CaTransDurt)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.CaTransDurt,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.CaTransDurt)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.CaTransDurt,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Ca2+ duration (s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Ca2+ duration']);
mylim=ylim;


mylim=ylim;
PlotStatStars2(hd5,2,3,2,AFBS.CaTransDurt,BFB1b_sas.CaTransDurt,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd5,2,3,2,BFB1b_sas.CaTransDurt,BFB1b_ps.CaTransDurt,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd5,2,3,2,AFBS.CaTransDurt,BFB1b_ps.CaTransDurt,[1 3],mylim(2)*0.93,3);





%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots Ca AUC
subplot(2,3,3);hold on;
mean_pial = mean(AFBS.CaTransAUC,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas.CaTransAUC,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps.CaTransAUC,'omitnan');

std_pial = std(AFBS.CaTransAUC,'omitnan');
std_BFB1b_sas = std(BFB1b_sas.CaTransAUC,'omitnan');
std_BFB1b_ps = std(BFB1b_ps.CaTransAUC,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS.CaTransAUC)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS.CaTransAUC,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas.CaTransAUC)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas.CaTransAUC,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps.CaTransAUC)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps.CaTransAUC,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Ca2+ AUC (%*s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Ca2+ transient AUC']);



mylim=ylim;
PlotStatStars2(hd5,2,3,3,AFBS.CaTransAUC,BFB1b_sas.CaTransAUC,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd5,2,3,3,BFB1b_sas.CaTransAUC,BFB1b_ps.CaTransAUC,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd5,2,3,3,AFBS.CaTransAUC,BFB1b_ps.CaTransAUC,[1 3],mylim(2)*0.93,3);






%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots Ca transient time per min
subplot(2,3,4);hold on;
AFBS_CaTransTTmin = AFBS.CaTransTTmin;
BFB1b_sas_CaTransTTmin = BFB1b_sas.CaTransTTmin;
BFB1b_ps_CaTransTTmin = BFB1b_ps.CaTransTTmin;

AFBS_CaTransTTmin(find(AFBS_CaTransTTmin==0))=[];
BFB1b_sas_CaTransTTmin(find(BFB1b_sas_CaTransTTmin==0))=[];
BFB1b_ps_CaTransTTmin(find(BFB1b_ps_CaTransTTmin==0))=[];

AFBS_CaTransTTmin(isnan(AFBS_CaTransTTmin))=[];
BFB1b_sas_CaTransTTmin(isnan(BFB1b_sas_CaTransTTmin))=[];
BFB1b_ps_CaTransTTmin(isnan(BFB1b_ps_CaTransTTmin))=[];

mean_pial = mean(AFBS_CaTransTTmin,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas_CaTransTTmin,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps_CaTransTTmin,'omitnan');

std_pial = std(AFBS_CaTransTTmin,'omitnan');
std_BFB1b_sas = std(BFB1b_sas_CaTransTTmin,'omitnan');
std_BFB1b_ps = std(BFB1b_ps_CaTransTTmin,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS_CaTransTTmin)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS_CaTransTTmin,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas_CaTransTTmin)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas_CaTransTTmin,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps_CaTransTTmin)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps_CaTransTTmin,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Times per min');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Ca2+ transient times per min (freqency)']);



mylim=ylim;
PlotStatStars2(hd5,2,3,4,AFBS_CaTransTTmin,BFB1b_sas_CaTransTTmin,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd5,2,3,4,BFB1b_sas_CaTransTTmin,BFB1b_ps_CaTransTTmin,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd5,2,3,4,AFBS_CaTransTTmin,BFB1b_ps_CaTransTTmin,[1 3],mylim(2)*0.93,3);






%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots Ca transient percentage of time
%%%%%%%%%%%%%%%%%%%%%%%%%%%% occurs Ca transients
subplot(2,3,5);hold on;
AFBS_CaTransTPrct = AFBS.CaTransTPrct;
BFB1b_sas_CaTransTPrct = BFB1b_sas.CaTransTPrct;
BFB1b_ps_CaTransTPrct = BFB1b_ps.CaTransTPrct;

AFBS_CaTransTPrct(find(AFBS_CaTransTPrct==0))=[];
BFB1b_sas_CaTransTPrct(find(BFB1b_sas_CaTransTPrct==0))=[];
BFB1b_ps_CaTransTPrct(find(BFB1b_ps_CaTransTPrct==0))=[];

AFBS_CaTransTPrct(isnan(AFBS_CaTransTPrct))=[];
BFB1b_sas_CaTransTPrct(isnan(BFB1b_sas_CaTransTPrct))=[];
BFB1b_ps_CaTransTPrct(isnan(BFB1b_ps_CaTransTPrct))=[];

mean_pial = mean(AFBS_CaTransTPrct,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas_CaTransTPrct,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps_CaTransTPrct,'omitnan');

std_pial = std(AFBS_CaTransTPrct,'omitnan');
std_BFB1b_sas = std(BFB1b_sas_CaTransTPrct,'omitnan');
std_BFB1b_ps = std(BFB1b_ps_CaTransTPrct,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS_CaTransTPrct)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS_CaTransTPrct,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas_CaTransTPrct)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas_CaTransTPrct,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps_CaTransTPrct)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps_CaTransTPrct,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Percentage');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Ca2+ transient percentage across the whole time']);
mylim=ylim;


mylim=ylim;
PlotStatStars2(hd5,2,3,5,AFBS_CaTransTPrct,BFB1b_sas_CaTransTPrct,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd5,2,3,5,BFB1b_sas_CaTransTPrct,BFB1b_ps_CaTransTPrct,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd5,2,3,5,AFBS_CaTransTPrct,BFB1b_ps_CaTransTPrct,[1 3],mylim(2)*0.93,3);




%%%%%%%%%%%%%%%%%%%%%%%%%%%% bar plots Ca transient time per min
subplot(2,3,6);hold on;
AFBS_CaTransTTminArea = AFBS.CaTransTTminArea;
BFB1b_sas_CaTransTTminArea = BFB1b_sas.CaTransTTminArea;
BFB1b_ps_CaTransTTminArea = BFB1b_ps.CaTransTTminArea;

AFBS_CaTransTTminArea(find(AFBS_CaTransTTminArea==0))=[];
BFB1b_sas_CaTransTTminArea(find(BFB1b_sas_CaTransTTminArea==0))=[];
BFB1b_ps_CaTransTTminArea(find(BFB1b_ps_CaTransTTminArea==0))=[];

AFBS_CaTransTTminArea(isnan(AFBS_CaTransTTminArea))=[];
BFB1b_sas_CaTransTTminArea(isnan(BFB1b_sas_CaTransTTminArea))=[];
BFB1b_ps_CaTransTTminArea(isnan(BFB1b_ps_CaTransTTminArea))=[];

mean_pial = mean(AFBS_CaTransTTminArea,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas_CaTransTTminArea,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps_CaTransTTminArea,'omitnan');

std_pial = std(AFBS_CaTransTTminArea,'omitnan');
std_BFB1b_sas = std(BFB1b_sas_CaTransTTminArea,'omitnan');
std_BFB1b_ps = std(BFB1b_ps_CaTransTTminArea,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS_CaTransTTminArea)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS_CaTransTTminArea,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas_CaTransTTminArea)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas_CaTransTTminArea,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps_CaTransTTminArea)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps_CaTransTTminArea,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Times per min per um2');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Ca2+ transient times per min per area (freqency)']);



mylim=ylim;
PlotStatStars2(hd5,2,3,6,AFBS_CaTransTTminArea,BFB1b_sas_CaTransTTminArea,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd5,2,3,6,BFB1b_sas_CaTransTTminArea,BFB1b_ps_CaTransTTminArea,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd5,2,3,6,AFBS_CaTransTTminArea,BFB1b_ps_CaTransTTminArea,[1 3],mylim(2)*0.93,3);





set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);


saveas(hd5,[SavingFolderName,filesep,'FB_CaBarPlots.jpg']);
saveas(hd5,[SavingFolderName,filesep,'FB_CaBarPlots.fig']);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%% bar plots EC Diam %%%%%%%%%%%%%%%%%%%%

hd4=figure(4);hold on;
ROIRealName_short = {'AFBS','BFB1b-sas','BFB1b-Pialsheath'};

for iii = 1:size(AFBS_DiamTraceAll,2)
    ThisTrace = AFBS_DiamTraceAll(:,iii);
    AFBS_DiamAUC(iii) = sum(ThisTrace-1,'omitnan').*(TimeStampInterp(3)-TimeStampInterp(2))*100;
end

for iii = 1:size(BFB1b_sas_DiamTraceAll,2)
    ThisTrace = BFB1b_sas_DiamTraceAll(:,iii);
    BFB1b_sas_DiamAUC(iii) = sum(ThisTrace-1,'omitnan').*(TimeStampInterp(3)-TimeStampInterp(2))*100;
end

for iii = 1:size(BFB1b_ps_DiamTraceAll,2)
    ThisTrace = BFB1b_ps_DiamTraceAll(:,iii);
    BFB1b_ps_DiamAUC(iii) = sum(ThisTrace-1,'omitnan').*(TimeStampInterp(3)-TimeStampInterp(2))*100;
end


subplot(2,3,1);hold on;
mean_pial = mean(AFBS_DiamAUC,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas_DiamAUC,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps_DiamAUC,'omitnan');

std_pial = std(AFBS_DiamAUC,'omitnan');
std_BFB1b_sas = std(BFB1b_sas_DiamAUC,'omitnan');
std_BFB1b_ps = std(BFB1b_ps_DiamAUC,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS_DiamAUC)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS_DiamAUC,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas_DiamAUC)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas_DiamAUC,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps_DiamAUC)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps_DiamAUC,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Diameter AUC (%*s)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Diameter AUC']);
mylim=ylim;



mylim=ylim;
PlotStatStars2(hd4,2,3,1,AFBS_DiamAUC,BFB1b_sas_DiamAUC,[1 2],mylim(2)*0.9,3);
PlotStatStars2(hd4,2,3,1,BFB1b_sas_DiamAUC,BFB1b_ps_DiamAUC,[2 3],mylim(2)*0.96,3);
PlotStatStars2(hd4,2,3,1,AFBS_DiamAUC,BFB1b_ps_DiamAUC,[1 3],mylim(2)*0.93,3);


%%%%%%
AFBS_DiamPeakAmp = nan(1,size(AFBS_DiamTraceAll,2));
for iii = 1:size(AFBS_DiamTraceAll,2)
    ThisTrace = AFBS_DiamTraceAll(:,iii);
    if max(ThisTrace-1)<=0.1
    AFBS_DiamPeakAmp(iii) = max(ThisTrace-1)*100;
    end
end

BFB1b_sas_DiamPeakAmp = nan(1,size(BFB1b_sas_DiamTraceAll,2));
for iii = 1:size(BFB1b_sas_DiamTraceAll,2)
    ThisTrace = BFB1b_sas_DiamTraceAll(:,iii);
    if max(ThisTrace-1)<=0.1
    BFB1b_sas_DiamPeakAmp(iii) = max(ThisTrace-1)*100;
    end
end

BFB1b_ps_DiamPeakAmp = nan(1,size(BFB1b_ps_DiamTraceAll,2));
for iii = 1:size(BFB1b_ps_DiamTraceAll,2)
    ThisTrace = BFB1b_ps_DiamTraceAll(:,iii);
    if max(ThisTrace-1)<=0.1
    BFB1b_ps_DiamPeakAmp(iii) = max(ThisTrace-1)*100;
    end
end


subplot(2,3,2);hold on;
mean_pial = mean(AFBS_DiamPeakAmp,'omitnan');
mean_BFB1b_sas = mean(BFB1b_sas_DiamPeakAmp,'omitnan');
mean_BFB1b_ps = mean(BFB1b_ps_DiamPeakAmp,'omitnan');

std_pial = std(AFBS_DiamPeakAmp,'omitnan');
std_BFB1b_sas = std(BFB1b_sas_DiamPeakAmp,'omitnan');
std_BFB1b_ps = std(BFB1b_ps_DiamPeakAmp,'omitnan');


xxx=repmat(1,1,length(~isnan(AFBS_DiamPeakAmp)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,AFBS_DiamPeakAmp,20,'MarkerEdgeColor','k');

xxx=repmat(2,1,length(~isnan(BFB1b_sas_DiamPeakAmp)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_sas_DiamPeakAmp,20,'MarkerEdgeColor','r');

xxx=repmat(3,1,length(~isnan(BFB1b_ps_DiamPeakAmp)));
for i=1:length(xxx)
    xxx(i)=xxx(i)+0.6*rand()-0.3;
end
scatter(xxx,BFB1b_ps_DiamPeakAmp,20,'MarkerEdgeColor','b');


bar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],'FaceColor',[0 .5 .5],'EdgeColor',[.1 .1 .1],'FaceAlpha', 0.5);
errorbar(1:3,[mean_pial,mean_BFB1b_sas,mean_BFB1b_ps],[std_pial,std_BFB1b_sas,std_BFB1b_ps],'LineStyle','none','Color','black','LineWidth',1.5);
ylabel('Diameter Peak Amp (%)');
xticks([1,2,3]);
xticklabels({'AFBS','BFB1b-sas', 'BFB1b-pialsheath'});
title(['Diameter Peak Amp']);
mylim=ylim;




set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);


saveas(hd4,[SavingFolderName,filesep,'FB_DiamBarPlots.jpg']);
saveas(hd4,[SavingFolderName,filesep,'FB_DiamBarPlots.fig']);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% save into excel file for stat analysis
h3=msgbox('Saving to excel file...');
    
%%%% AFBS
col_header_STI={'DataName','MouseID','LocID','Date','Ca_PeakAmp(%)','CaTransAUC(%*s)','CaTransDurt(s)','DiamAUC(%*s)','DiamPeakAmp(%)','','','DataName','MouseID','LocID','Date','CaTransNumPerMin','CaTransPct(%)','CaTransNumPerMinPerArea'};
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],{'AFBS'},1,'A1');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],col_header_STI,1,'A3');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.DataName).',1,'A4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.CaPeakAmp).',1,'E4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.CaTransAUC).',1,'F4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS.CaTransDurt).',1,'G4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS_DiamAUC).',1,'H4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS_DiamPeakAmp).',1,'I4');

MouseID_All=cell(size((AFBS.DataName).'));
LocID_All = cell(size((AFBS.DataName).'));
Date_All = cell(size((AFBS.DataName).'));
for i=1:length((AFBS.DataName).')
    ThisDataName = AFBS.DataName{i};
    I = strfind(ThisDataName,'-');
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



AFBS_DataName_short = AFBS.DataNameCaFreq;
AFBS_DataName_short=AFBS_DataName_short(~cellfun('isempty', AFBS_DataName_short));
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(AFBS_DataName_short).',1,'L4');
CaTransTTmin_short = AFBS.CaTransTTmin; CaTransTTmin_short(isnan(CaTransTTmin_short))=[];CaTransTTmin_short(find(CaTransTTmin_short==0))=[];
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(CaTransTTmin_short).',1,'P4');
CaTransTPrct_short = AFBS.CaTransTPrct; CaTransTPrct_short(isnan(CaTransTPrct_short))=[];CaTransTPrct_short(find(CaTransTPrct_short==0))=[];
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(CaTransTPrct_short).',1,'Q4');
CaTransTTminArea_short = AFBS.CaTransTTminArea; CaTransTTminArea_short(isnan(CaTransTTminArea_short))=[];CaTransTTminArea_short(find(CaTransTTminArea_short==0))=[];
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(CaTransTTminArea_short).',1,'R4');

MouseID_All=cell(size(AFBS_DataName_short.'));
LocID_All = cell(size(AFBS_DataName_short.'));
Date_All = cell(size(AFBS_DataName_short.'));
for i=1:length(AFBS_DataName_short.')
    ThisDataName = AFBS_DataName_short{i};
    I = strfind(ThisDataName,'-');
    MouseID_All{i} = ThisDataName(1:I(1)-1);
    LocID_All{i} = ThisDataName(I(1)+1:I(2)-1);
    if length(I)>=3
        Date_All{i} = ThisDataName(I(2)+1:I(3)-1);
    else
        Date_All{i} = ThisDataName(I(2)+1:end);
    end
end
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],MouseID_All,1,'M4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],LocID_All,1,'N4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],Date_All,1,'O4');


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BFB1b-sas
% col_header_STI={'DataName','Ca_PeakAmp(%)','CaTransAUC(%*s)','CaTransDurt(s)','DiamAUC(%*s)','DiamPeakAmp(%)','','DataName','CaTransNumPerMin','CaTransPct(%)','CaTransNumPerMinPerArea'};
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],{'BFB1b-sas'},2,'A1');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],col_header_STI,2,'A3');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.DataName).',2,'A4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.CaPeakAmp).',2,'E4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.CaTransAUC).',2,'F4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas.CaTransDurt).',2,'G4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas_DiamAUC).',2,'H4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas_DiamPeakAmp).',2,'I4');

MouseID_All=cell(size((BFB1b_sas.DataName).'));
LocID_All = cell(size((BFB1b_sas.DataName).'));
Date_All = cell(size((BFB1b_sas.DataName).'));
for i=1:length((BFB1b_sas.DataName).')
    ThisDataName = BFB1b_sas.DataName{i};
    I = strfind(ThisDataName,'-');
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



BFB1b_sas_DataName_short = BFB1b_sas.DataNameCaFreq;
BFB1b_sas_DataName_short=BFB1b_sas_DataName_short(~cellfun('isempty', BFB1b_sas_DataName_short));
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_sas_DataName_short).',2,'L4');
CaTransTTmin_short = BFB1b_sas.CaTransTTmin; CaTransTTmin_short(isnan(CaTransTTmin_short))=[];CaTransTTmin_short(find(CaTransTTmin_short==0))=[];
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(CaTransTTmin_short).',2,'P4');
CaTransTPrct_short = BFB1b_sas.CaTransTPrct; CaTransTPrct_short(isnan(CaTransTPrct_short))=[];CaTransTPrct_short(find(CaTransTPrct_short==0))=[];
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(CaTransTPrct_short).',2,'Q4');
CaTransTTminArea_short = BFB1b_sas.CaTransTTminArea; CaTransTTminArea_short(isnan(CaTransTTminArea_short))=[];CaTransTTminArea_short(find(CaTransTTminArea_short==0))=[];
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(CaTransTTminArea_short).',2,'R4');

MouseID_All=cell(size(BFB1b_sas_DataName_short.'));
LocID_All = cell(size(BFB1b_sas_DataName_short.'));
Date_All = cell(size(BFB1b_sas_DataName_short.'));
for i=1:length(BFB1b_sas_DataName_short.')
    ThisDataName = BFB1b_sas_DataName_short{i};
    I = strfind(ThisDataName,'-');
    MouseID_All{i} = ThisDataName(1:I(1)-1);
    LocID_All{i} = ThisDataName(I(1)+1:I(2)-1);
    if length(I)>=3
        Date_All{i} = ThisDataName(I(2)+1:I(3)-1);
    else
        Date_All{i} = ThisDataName(I(2)+1:end);
    end
end
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],MouseID_All,2,'M4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],LocID_All,2,'N4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],Date_All,2,'O4');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BFB1b-ps
% col_header_STI={'DataName','Ca_PeakAmp(%)','CaTransAUC(%*s)','CaTransDurt(s)','DiamAUC(%*s)','DiamPeakAmp(%)','','DataName','CaTransNumPerMin','CaTransPct(%)','CaTransNumPerMinPerArea'};
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],{'BFB1b-ps'},3,'A1');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],col_header_STI,3,'A3');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.DataName).',3,'A4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.CaPeakAmp).',3,'E4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.CaTransAUC).',3,'F4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps.CaTransDurt).',3,'G4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps_DiamAUC).',3,'H4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps_DiamPeakAmp).',3,'I4');


MouseID_All=cell(size((BFB1b_ps.DataName).'));
LocID_All = cell(size((BFB1b_ps.DataName).'));
Date_All = cell(size((BFB1b_ps.DataName).'));
for i=1:length((BFB1b_ps.DataName).')
    ThisDataName = BFB1b_ps.DataName{i};
    I = strfind(ThisDataName,'-');
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


BFB1b_ps_DataName_short = BFB1b_ps.DataNameCaFreq;
BFB1b_ps_DataName_short = BFB1b_ps_DataName_short(~cellfun('isempty', BFB1b_ps_DataName_short));
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(BFB1b_ps_DataName_short).',3,'L4');
CaTransTTmin_short = BFB1b_ps.CaTransTTmin; CaTransTTmin_short(isnan(CaTransTTmin_short))=[];CaTransTTmin_short(find(CaTransTTmin_short==0))=[];
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(CaTransTTmin_short).',3,'P4');
CaTransTPrct_short = BFB1b_ps.CaTransTPrct; CaTransTPrct_short(isnan(CaTransTPrct_short))=[];CaTransTPrct_short(find(CaTransTPrct_short==0))=[];
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(CaTransTPrct_short).',3,'Q4');
CaTransTTminArea_short = BFB1b_ps.CaTransTTminArea; CaTransTTminArea_short(isnan(CaTransTTminArea_short))=[];CaTransTTminArea_short(find(CaTransTTminArea_short==0))=[];
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],(CaTransTTminArea_short).',3,'R4');

MouseID_All=cell(size(BFB1b_ps_DataName_short.'));
LocID_All = cell(size(BFB1b_ps_DataName_short.'));
Date_All = cell(size(BFB1b_ps_DataName_short.'));
for i=1:length(BFB1b_ps_DataName_short.')
    ThisDataName = BFB1b_ps_DataName_short{i};
    I = strfind(ThisDataName,'-');
    MouseID_All{i} = ThisDataName(1:I(1)-1);
    LocID_All{i} = ThisDataName(I(1)+1:I(2)-1);
    if length(I)>=3
        Date_All{i} = ThisDataName(I(2)+1:I(3)-1);
    else
        Date_All{i} = ThisDataName(I(2)+1:end);
    end
end
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],MouseID_All,3,'M4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],LocID_All,3,'N4');
xlswrite([SavingFolderName,filesep,'ResultsSummary_full.xlsx'],Date_All,3,'O4');

close(h3);
