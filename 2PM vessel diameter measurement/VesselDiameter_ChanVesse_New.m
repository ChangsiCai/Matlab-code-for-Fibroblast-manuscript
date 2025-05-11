function varargout = VesselDiameter_ChanVesse_New(varargin)
% VESSELDIAMETER_CHANVESSE_NEW MATLAB code for VesselDiameter_ChanVesse_New.fig
%      VESSELDIAMETER_CHANVESSE_NEW, by itself, creates a new VESSELDIAMETER_CHANVESSE_NEW or raises the existing
%      singleton*.
%
%      H = VESSELDIAMETER_CHANVESSE_NEW returns the handle to a new VESSELDIAMETER_CHANVESSE_NEW or the handle to
%      the existing singleton*.
%
%      VESSELDIAMETER_CHANVESSE_NEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VESSELDIAMETER_CHANVESSE_NEW.M with the given input arguments.
%
%      VESSELDIAMETER_CHANVESSE_NEW('Property','Value',...) creates a new VESSELDIAMETER_CHANVESSE_NEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VesselDiameter_ChanVesse_New_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VesselDiameter_ChanVesse_New_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VesselDiameter_ChanVesse_New

% Last Modified by GUIDE v2.5 08-Nov-2019 11:19:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VesselDiameter_ChanVesse_New_OpeningFcn, ...
                   'gui_OutputFcn',  @VesselDiameter_ChanVesse_New_OutputFcn, ...
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


% --- Executes just before VesselDiameter_ChanVesse_New is made visible.
function VesselDiameter_ChanVesse_New_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VesselDiameter_ChanVesse_New (see VARARGIN)

% Choose default command line output for VesselDiameter_ChanVesse_New
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VesselDiameter_ChanVesse_New wait for user response (see UIRESUME)
% uiwait(handles.figure1);


global hLine1 hLine2 hAx hAllDots LineProfile currentVesselNo hThldLine LineProfile_Mask ChanVessePixelNum BinaryPixelNum LineProfile_New ifNew BinaryPixelNumNew;
global hThldLine1 hThldLine2 hContourPunish1 hContourPunish2 hStepSize1 hStepSize2 hStopCr1 hStopCr2 hCVforceIN hCVforceOUT hCorrectBaseline HistoThld hPIHthld hHistogram hSmoothCurve;

%%% set the handles global
hContourPunish1=handles.ContourPunish1;
hContourPunish2=handles.ContourPunish2;
hStepSize1=handles.StepSize1;
hStepSize2=handles.StepSize2;
hStopCr1=handles.StopCr1;
hStopCr2=handles.StopCr2;
hCVforceIN=handles.CVforceIN;
hCVforceOUT=handles.CVforceOUT;
hCorrectBaseline=handles.hCorrectBaseline;
hPIHthld=handles.PIHthld;
hHistogram=handles.Histogram;
hSmoothCurve=handles.SmoothCurve;

LineProfile_New=LineProfile;
ifNew=0;


%%%% realign LineProfile

%%%%%%%%%%%%%%%%%%%%%%%%


axes(handles.Original);hold on;
hLP=imagesc(LineProfile.');
title(['\fontsize{14}r',num2str(currentVesselNo)]);
colormap(gray);
axis off;
aSize0=get(gca,'Position');

% set the starting lines
hThldLine1=line([1 size(LineProfile,1)],[size(LineProfile,2)-2 size(LineProfile,2)-2],'Color','g');
hThldLine2=line([1 size(LineProfile,1)],[3 3],'Color','g');
draggable(hThldLine1,'v');
draggable(hThldLine2,'v');

set(handles.Refine,'Visible','off');
set(handles.Accept,'Visible','off');

% Set the pixel histogram
allpixels=reshape(LineProfile,1,[]);
[nelements,centers]=hist(allpixels,50);
bar(handles.Histogram,centers(1:50),nelements(1:50));
axes(handles.Histogram);hold on;box off;
% xlim([0 150]);
ylabel('\fontsize{12}Num of Pixels');
xlabel('\fontsize{12}Intensity Level');

% estimate a rough threshold
mylim=ylim;
[C,I]=max(nelements(1:50));
MyAvg=mean(nelements);
MyDiff0=find(nelements>MyAvg);
MyDiff1=diff(MyDiff0);
DiffInd=find(MyDiff1~=1);
if length(DiffInd)>=1   % two peaks at least above average
    BackgroundRange=[MyDiff0(1) MyDiff0(DiffInd(1))];
    [CC,center1]=max(nelements([BackgroundRange(1):BackgroundRange(2)]));
    center1=center1+BackgroundRange(1)-1;
    
    ForegroundRange=[MyDiff0(DiffInd(1)+1) MyDiff0(end)];  
    [CC,center2]=max(nelements([ForegroundRange(1):ForegroundRange(2)]));
    center2=center2+ForegroundRange(1)-1;
    
    HistoThld=(centers(center1)+centers(center2))/2;
    
else                              % only one peak above average, which is the background    
    
    HistoThld=centers(MyDiff0(end));  
end

set(hPIHthld,'String',num2str(HistoThld));


hThldLine=line([HistoThld HistoThld],mylim,'Color','b','LineWidth',2);
draggable(hThldLine,'h');

% create a usepihcurve mask
LineProfile_Mask=zeros(size(LineProfile));
LineProfile_Mask(find(LineProfile>HistoThld))=1;

% fill the holes
Mask_filled = imfill(LineProfile_Mask,'holes');
holes = Mask_filled & ~LineProfile_Mask;
bigholes = bwareaopen(holes, 100);
smallholes = holes & ~bigholes;
Mask_filled = LineProfile_Mask | smallholes;

% delete individual pixel
NowImg=double(Mask_filled);
ImgTemplate=[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
NowImg2=conv2(NowImg,ImgTemplate,'same').*NowImg;
NowImg2(find((NowImg2<5/9)))=0;
NowImg2(find((NowImg2>=5/9)))=1;

% dilate the images
% se8 = strel('disk',8,8);
% se6 = strel('disk',6,6);
% se4 = strel('disk',4,4);    
% NowImg3 = imdilate(NowImg2,se8);
% NowImg3 = imerode(NowImg3,se4);

% Finalize the mask
LineProfile_Mask=NowImg2;

% Plot in Original
axes(handles.Original);hold on;
[row,col]=find(LineProfile_Mask);
hAllDots=plot(row,col,'r.','MarkerSize',2);

% the pixel number by pixelized images
BinaryPixelNum=zeros(1,size(LineProfile,1));
for i=1:size(LineProfile,1)
    BinaryPixelNum(i)=length(find(LineProfile_Mask(i,:)));
end
% BinaryPixelNum=smooth(BinaryPixelNum,3);

ChanVessePixelNum=zeros(1,size(LineProfile,1));
% plot out in Diameter
axes(handles.Diameter);hold on;
axis([1 size(LineProfile,1) 1 size(LineProfile,2)]);

%%%%%%%% smooth the curve while there is no 0
BinaryPixelNumNew=SmoothNonZeros(BinaryPixelNum);


if get(handles.SmoothCurve,'Value')
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNumNew);
else
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNum);
end
xlabel('\fontsize{12}Num of stacks');
ylabel(hAx(1),'ChanVesse P.N.'); % left y-axis
ylabel(hAx(2),'Binary P.N.'); % right y-axis
set(hLine1,'Color','k');
set(hLine2,'Color','g');
set(hAx(1),'YColor','k');
set(hAx(2),'YColor','g');
% xlim1=get(hAx(1),'xlim');
% xlim2=get(hAx(2),'xlim');
set(hAx(1),'xlim',[0 size(LineProfile,1)+1]);
set(hAx(2),'xlim',[0 size(LineProfile,1)+1]);
% set(hAx(1),'ylim',[0 size(LineProfile,2)+1]);
% set(hAx(2),'ylim',[0 size(LineProfile,2)+1]);
ylim1=get(hAx(1),'ylim');
ylim2=get(hAx(2),'ylim');
set(hAx(1),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
set(hAx(2),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
box off;
% ax=get(gca,'Position');
% ax(2)=ax(2)+0.1;
% ax(3)=aSize0(3);
% ax(4)=aSize0(4);
% set(gca,'Position',ax);








% --- Outputs from this function are returned to the command line.
function varargout = VesselDiameter_ChanVesse_New_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Update.
function Update_Callback(hObject, eventdata, handles)
global hLine1 hLine2 hAx hAllDots LineProfile currentVesselNo hThldLine LineProfile_Mask ChanVessePixelNum BinaryPixelNum hPIHthld;
global ifNew LineProfile_New hSmoothCurve BinaryPixelNumNew;

if ifNew
    ThisLP=LineProfile_New;
else
    ThisLP=LineProfile;    
end

% get the location of the threshold line
tt=get(hThldLine);
HistoThld=round(tt.XData(1));

set(hPIHthld,'String',num2str(HistoThld));

% create a usepihcurve mask
LineProfile_Mask=zeros(size(ThisLP));
LineProfile_Mask(find(ThisLP>HistoThld))=1;

% fill the holes
Mask_filled = imfill(LineProfile_Mask,'holes');
holes = Mask_filled & ~LineProfile_Mask;
bigholes = bwareaopen(holes, 100);
smallholes = holes & ~bigholes;
Mask_filled = LineProfile_Mask | smallholes;

% delete individual pixel
NowImg=double(Mask_filled);
ImgTemplate=[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
NowImg2=conv2(NowImg,ImgTemplate,'same').*NowImg;
NowImg2(find((NowImg2<5/9)))=0;
NowImg2(find((NowImg2>=5/9)))=1;

% dilate the images
% se8 = strel('disk',8,8);
% se6 = strel('disk',6,6);
% se4 = strel('disk',4,4);    
% NowImg3 = imdilate(NowImg2,se8);
% NowImg3 = imerode(NowImg3,se4);

% Finalize the mask
LineProfile_Mask=NowImg2;
for i=1:size(ThisLP,1)
    BinaryPixelNum(i)=length(find(LineProfile_Mask(i,:)));
end
% BinaryPixelNum=smooth(BinaryPixelNum,3);

%%%%%%% update the orginal image
axes(handles.Original);hold on;
% cla(handles.Original);
delete(hAllDots);
% hLP=imagesc(LineProfile.');
% title(['\fontsize{14}r',num2str(currentVesselNo)]);
% colormap(gray);
% axis off;
[row,col]=find(LineProfile_Mask);
hAllDots=plot(row,col,'r.','MarkerSize',2);

%%%%%%%% smooth the curve while there is no 0
BinaryPixelNumNew=SmoothNonZeros(BinaryPixelNum);



%%%%%%%%%%%%%%%% update the diameter plot
axes(handles.Diameter);hold on;
cla(handles.Diameter,'reset');
% delete(hAx);
[hAx,hLine1,hLine2] = plotyy(1:size(ThisLP,1),ChanVessePixelNum,1:size(ThisLP,1),BinaryPixelNumNew);
xlabel('\fontsize{12}Num of stacks');xlim([0 size(ThisLP,1)+1]);
ylabel(hAx(1),'ChanVesse P.N.'); % left y-axis
ylabel(hAx(2),'Binary P.N.'); % right y-axis
set(hLine1,'Color','k');
set(hLine2,'Color','g');
set(hAx(1),'YColor','k');
set(hAx(2),'YColor','g');
set(hAx(1),'xlim',[0 size(ThisLP,1)+1]);
set(hAx(2),'xlim',[0 size(ThisLP,1)+1]);
% set(hAx(1),'ylim',[0 size(LineProfile,2)+1]);
% set(hAx(2),'ylim',[0 size(LineProfile,2)+1]);
ylim1=get(hAx(1),'ylim');
ylim2=get(hAx(2),'ylim');
set(hAx(1),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
set(hAx(2),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
box off;






% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
global hcLSF hLine1 hDiam_px hThldLine1 hThldLine2 LineProfile LSF hLine2 ChanVessePixelNum BinaryPixelNum handlesSmoothCurve;
global hContourPunish1 hContourPunish2 hStepSize1 hStepSize2 hStopCr1 hStopCr2 hCVforceIN hCVforceOUT hCorrectBaseline BinaryPixelNumNew;

% clear the previous contour line if any
try
     delete(hcLSF);
     delete(hLine1);
end

% get the location of two threshold line
tt1=get(hThldLine1);
ThldLine1_pos=tt1.YData(1);
tt2=get(hThldLine2);
ThldLine2_pos=tt2.YData(2);
clear tt1 tt2;

I=LineProfile.';

% level set function as a mask
LSF=ones(size(I));     % level set function
LSF(fix(ThldLine1_pos),:)=0;
LSF(fix(ThldLine2_pos),:)=0;
LSF(fix(ThldLine1_pos)+1:end,:)=-1;
LSF(1:fix(ThldLine2_pos)-1,:)=-1;

%%%%% Rescaling into [0,1]
m = min(min(I));M = max(max(I));
d=1/(M-m);
I = d*(I-m);

%Preset analysis parameter
nu=str2num(get(hContourPunish1,'String'));    % weight of punishment of contour length
n=size(I,1)*size(I,2);
num_iter_max=100;
LSF_old=zeros(size(LSF));
dt=str2num(get(hStepSize1,'String'));
tol=str2num(get(hStopCr1,'String'));					% stopping criterium for relative error 


for i=1:num_iter_max
    
    % Core algorithm of Chan-Vese
    inidx = find(LSF>=0); % frontground index
	outidx = find(LSF<0); % background index
    c1 = sum(sum(I.*Heaviside(LSF)))/(length(inidx)+eps)*str2num(get(hCVforceIN,'String'));		%Av. inside u 
	c2 = sum(sum(I.*(1-Heaviside(LSF))))/(length(outidx)+eps)*str2num(get(hCVforceOUT,'String'));  % Av.outside u 
    
    force_image=-(I-c1).^2+(I-c2).^2;					
    force =nu*kappa(LSF)./max(max(abs(kappa(LSF))))+force_image;% external force
	LSF = LSF+dt*force;

    
    % Plot the updated contour of vessel in the upper subplot
    axes(handles.Original);hold on;
    try
        delete(hcLSF);
    catch
    end
    [ct,hcLSF]=contour(LSF, [0 0], 'r','LineWidth',1);
    
    % Plot the updated diameter in the lower subplot
    LSF_binary=zeros(size(LSF));
    LSF_binary(LSF>=0)=1;    % binarize the level set function / image contour
    %prepare to fill the holes
    LSF_binary_p1 = padarray(LSF_binary,[0 1],1,'post');
    LSF_binary_p2 = padarray(LSF_binary_p1,[0 1],1,'pre');
%     LSF_binary_p3 = padarray(LSF_binary_p2,[0 1],1,'post');
%     LSF_binary_p4 = padarray(LSF_binary_p3,[0 1],1,'pre');
    LSF_binary2=imfill(LSF_binary_p2,26,'holes');   % hole size smaller than 26 will be erased
    LSF_binary2(:,1)=[];LSF_binary2(:,end)=[];
    Diam_px=sum(LSF_binary2,1);
    axes(handles.Diameter);hold on;
    try
        delete(hLine1);
    end
    
    % smooth
    Diam_px=smooth(Diam_px,3);
    %
    hLine1=plot(1:length(Diam_px),Diam_px,'k','LineWidth',1);
    
    ylim([min(Diam_px)-10 max(Diam_px)+10]);
    
    % STOPPING CRITERIUM
    invariant_sum=sum(sum((LSF<0)==(LSF_old<0)));
	ER=(n-invariant_sum)/n;
	if ER<tol && i>10 	       % For some cases ER<tol is satisfied for too small i
  		num_iter=i;
        
%         % replot the last contour to get rid of the little hole
%         axes(hCV_sp1);hold on;
%         try
%             delete(hcLSF);
%         catch
%         end
%        [ct,hcLSF]=contour(LSF_binary2, [0 0], 'r','LineWidth',1);
        
  		break;
    end
    LSF_old=LSF;
    
    
end

set(handles.Refine,'Visible','on');
set(handles.Accept,'Visible','on');


ChanVessePixelNum=Diam_px;

%%%%%%%%%%%%%%%% update teh diameter plot
axes(handles.Diameter);hold on;
cla(handles.Diameter);
% delete(hAx);

if get(handles.SmoothCurve,'Value')
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNumNew);
else
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNum);
end
xlabel('\fontsize{12}Num of stacks');xlim([0 size(LineProfile,1)+1]);
ylabel(hAx(1),'ChanVesse P.N.'); % left y-axis
ylabel(hAx(2),'Binary P.N.'); % right y-axis
set(hLine1,'Color','k');
set(hLine2,'Color','g');
set(hAx(1),'YColor','k');
set(hAx(2),'YColor','g');
set(hAx(1),'xlim',[0 size(LineProfile,1)+1]);
set(hAx(2),'xlim',[0 size(LineProfile,1)+1]);
% set(hAx(1),'ylim',[0 size(LineProfile,2)+1]);
% set(hAx(2),'ylim',[0 size(LineProfile,2)+1]);
ylim1=get(hAx(1),'ylim');
ylim2=get(hAx(2),'ylim');
set(hAx(1),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
set(hAx(2),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
box off;




% --- Executes on button press in Refine.
function Refine_Callback(hObject, eventdata, handles)
global hcLSF hLine1 hDiam_px hThldLine1 hThldLine2 LineProfile LSF hLine2 ChanVessePixelNum BinaryPixelNum BinaryPixelNumNew;
global hContourPunish1 hContourPunish2 hStepSize1 hStepSize2 hStopCr1 hStopCr2 hCVforceIN hCVforceOUT hCorrectBaseline handlesSmoothCurve;

set(handles.Accept,'Visible','off');

% clear the previous contour line if any
try
     delete(hcLSF);
     delete(hLine1);
end

% interpolarization
Itemp=LineProfile.';
[Itemp_x,Itemp_y]=meshgrid(1:size(Itemp,2),1:0.1:size(Itemp,1));
I_interp=interp2(Itemp,Itemp_x,Itemp_y,'spline');
LSF_interp=interp2(LSF,Itemp_x,Itemp_y,'spline');

%%%%% Resizing on base 256x256
% s = 256./min(size(I,1),size(I,2)); 
% if s<1;I = imresize(I,s);end
%%%%% Rescaling into [0,1]
m = min(min(I_interp));M = max(max(I_interp));
d=1/(M-m);
I_interp = d*(I_interp-m);



%Preset analysis parameter
% I=LineProfile.';
nu=str2num(get(hContourPunish2,'String'));    % weight of punishment of contour length
n=size(I_interp,1)*size(I_interp,2);
num_iter_max=150;
LSF_old=zeros(size(LSF_interp));
dt=str2num(get(hStepSize2,'String'));  %0.5
tol=str2num(get(hStopCr2,'String'));				% stopping criterium for relative error 

%%%%%%%%%%%%%%%%%%%%%%%%% start Chan-Vese analysis
for i=1:num_iter_max
    
    % Core algorithm of Chan-Vese
    inidx = find(LSF_interp>=0); % frontground index
	outidx = find(LSF_interp<0); % background index
    c1 = sum(sum(I_interp.*Heaviside(LSF_interp)))/(length(inidx)+eps)*str2num(get(hCVforceIN,'String'));		%Av. inside u 
	c2 = sum(sum(I_interp.*(1-Heaviside(LSF_interp))))/(length(outidx)+eps)*str2num(get(hCVforceOUT,'String'));  % Av.outside u 
    
    force_image=-(I_interp-c1).^2+(I_interp-c2).^2;					
    force =nu*kappa(LSF_interp)./max(max(abs(kappa(LSF_interp))))+force_image;% external force
	LSF_interp = LSF_interp+dt*force;

   
    
%     % image resize to plot the contour
%     LSF_interp_rsz=imresize(LSF_interp,size(LSF));
%     [ct,hcLSF]=contour(LSF_interp_rsz, [0 0], 'r','LineWidth',1);

    
    % Plot the updated diameter in the lower subplot
    LSF_binary=zeros(size(LSF_interp));
    LSF_binary(LSF_interp>=0)=1;    % binarize the level set function / image contour
    
    % fill the holes in the negative area
    LSF_binary_neg = 1-LSF_binary;
    LSF_binary_neg = padarray(LSF_binary_neg,[1 0],1,'post');
    LSF_binary_neg = padarray(LSF_binary_neg,[1 0],1,'pre');    
    LSF_binary_neg=imfill(LSF_binary_neg,26,'holes');
    LSF_binary_neg(1,:)=[];LSF_binary_neg(end,:)=[];
    LSF_Polish=LSF_interp.*LSF_binary_neg;
    LSF_interp(find(LSF_Polish>0))=LSF_interp(find(LSF_Polish>0))*(-1);
    LSF_binary=1-LSF_binary_neg;    
    
    
    
    %prepare to fill the holes
    LSF_binary_p1 = padarray(LSF_binary,[0 1],1,'post');
    LSF_binary_p2 = padarray(LSF_binary_p1,[0 1],1,'pre');
    LSF_binary2=imfill(LSF_binary_p2,26,'holes');   % hole size smaller than 26 will be erased
    LSF_binary2(:,1)=[];LSF_binary2(:,end)=[];
%     LSF_binary2=imfill(LSF_binary,26,'holes');   % hole size smaller than 26 will be erased

    % Plot the updated contour of vessel in the upper subplot
    axes(handles.Original);hold on;
    try
        delete(hcLSF);
    catch
    end
    
    % image resize to plot the contour
%     LSF_interp_rsz=imresize(LSF_interp,size(LSF));
%     [ct,hcLSF]=contour(LSF_interp_rsz, [0 0], 'r','LineWidth',1);
    LSF_Polish=LSF_interp.*LSF_binary2;
    LSF_interp(find(LSF_Polish<0))=LSF_interp(find(LSF_Polish<0))*(-1);
    
    LSF_interp_rsz=imresize(LSF_interp,size(LSF));
    [ct,hcLSF]=contour(LSF_interp_rsz, [0 0], 'r','LineWidth',1);
    


    Diam_px=sum(LSF_binary2,1);
    axes(handles.Diameter);hold on;
    try
        delete(hLine1);
    catch
    end
    
    % smooth
%     Diam_px=Diam_px/10;
    Diam_px=smooth(Diam_px,3)/10;
    hLine1=plot(1:length(Diam_px),Diam_px,'k','LineWidth',1);    
    ylim([min(Diam_px)-10 max(Diam_px)+10]);
    
    
    % STOPPING CRITERIUM
    invariant_sum=sum(sum((LSF_interp<0)==(LSF_old<0)));
	ER=(n-invariant_sum)/n;
	if ER<tol && i>10 	       % For some cases ER<tol is satisfied for too small i
  		num_iter=i;
        
%         % replot the last contour to get rid of the little hole
%         axes(hCV_sp1);hold on;
%         try
%             delete(hcLSF);
%         catch
%         end
%         LSF_binary2_rsz=imresize(LSF_binary2,size(LSF));
%        [ct,hcLSF]=contour(LSF_binary2_rsz, [0 0], 'r','LineWidth',1);
       
  		break;
    end
    LSF_old=LSF_interp;
    

end
set(handles.Accept,'Visible','on');

ChanVessePixelNum=Diam_px;


% hd_hd=figure(101);
% hold on;
% plot(ChanVessePixelNum,'k');
% plot(smooth(ChanVessePixelNum,'lowess'),'r--');
% plot(smooth(ChanVessePixelNum,'loess'),'b--');
% plot(smooth(ChanVessePixelNum,'sgolay'),'g--');
% plot(smooth(ChanVessePixelNum,'rlowess'),'m--');
% plot(smooth(ChanVessePixelNum,'rloess'),'c--');
% pause;
% close(hd_hd);

ChanVessePixelNum=smooth(ChanVessePixelNum,'rlowess');


%%%%%%%%%%%%%%%% update the diameter plot
axes(handles.Diameter);hold on;
cla(handles.Diameter);
% delete(hAx);
if get(handles.SmoothCurve,'Value')
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNumNew);
else
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNum);
end

xlabel('\fontsize{12}Num of stacks');xlim([0 size(LineProfile,1)+1]);
ylabel(hAx(1),'ChanVesse P.N.'); % left y-axis
ylabel(hAx(2),'Binary P.N.'); % right y-axis
set(hLine1,'Color','k');
set(hLine2,'Color','g');
set(hAx(1),'YColor','k');
set(hAx(2),'YColor','g');
set(hAx(1),'xlim',[0 size(LineProfile,1)+1]);
set(hAx(2),'xlim',[0 size(LineProfile,1)+1]);
% set(hAx(1),'ylim',[0 size(LineProfile,2)+1]);
% set(hAx(2),'ylim',[0 size(LineProfile,2)+1]);
ylim1=get(hAx(1),'ylim');
ylim2=get(hAx(2),'ylim');
set(hAx(1),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
set(hAx(2),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
box off;



% --- Executes on button press in Accept.
function Accept_Callback(hObject, eventdata, handles)

global ChanVessePixelNum FrameNum ;
global hCV hCorrectBaseline CellIOT PixelSize;

CellIOT=zeros(FrameNum,1);   % intensity over time
CellIOT(1:end)=ChanVessePixelNum*PixelSize;

% if get(hCorrectBaseline,'Value')
%     Wave4AdjustY=CellIOT(2:20);
%     a = polyfit(2:1:20,Wave4AdjustY.',1);
%     mypatch=a(1).*(18:-1:0);
%     mypatch2=Wave4AdjustY+mypatch.';
%     mypatch2=mypatch2-(mypatch2-Wave4AdjustY(end))*3/4;
%     CellIOT(2:20)=mypatch2;
%     
% end

if get(hCorrectBaseline,'Value')
    Wave4AdjustY=CellIOT(2:30);
    a = polyfit(1:1:30,Wave4AdjustY.',1);
    mypatch=a(1).*(29:-1:0);
    mypatch2=Wave4AdjustY+mypatch.';
    mypatch2=mypatch2-(mypatch2-Wave4AdjustY(end))*3/4;
    CellIOT(1:30)=mypatch2;
    
end



close(hCV);



function ContourPunish1_Callback(hObject, eventdata, handles)

function ContourPunish1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ContourPunish2_Callback(hObject, eventdata, handles)




function ContourPunish2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StepSize1_Callback(hObject, eventdata, handles)




function StepSize1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StepSize2_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function StepSize2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StopCr1_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function StopCr1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StopCr2_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function StopCr2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in hCorrectBaseline.
function hCorrectBaseline_Callback(hObject, eventdata, handles)



% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
global hLine1 hLine2 hAx hAllDots LineProfile currentVesselNo hThldLine LineProfile_Mask ChanVessePixelNum BinaryPixelNum LineProfile_New ifNew BinaryPixelNumNew;
global hThldLine1 hThldLine2 hContourPunish1 hContourPunish2 hStepSize1 hStepSize2 hStopCr1 hStopCr2 hCVforceIN hCVforceOUT hCorrectBaseline handlesSmoothCurve;


LineProfile_New=LineProfile;
ifNew=0;

axes(handles.Original);hold on;
hLP=imagesc(LineProfile.');
title(['\fontsize{14}r',num2str(currentVesselNo)]);
colormap(gray);
axis off;
aSize0=get(gca,'Position');

% set the starting lines
hThldLine1=line([1 size(LineProfile,1)],[size(LineProfile,2)-2 size(LineProfile,2)-2],'Color','g');
hThldLine2=line([1 size(LineProfile,1)],[3 3],'Color','g');
draggable(hThldLine1,'v');
draggable(hThldLine2,'v');

set(handles.Refine,'Visible','off');
set(handles.Accept,'Visible','off');

% Set the pixel histogram
allpixels=reshape(LineProfile,1,[]);
[nelements,centers]=hist(allpixels,50);
cla(handles.Histogram);
bar(handles.Histogram,centers(1:50),nelements(1:50));
axes(handles.Histogram);hold on;box off;
% xlim([0 150]);
ylabel('\fontsize{12}Num of Pixels');
xlabel('\fontsize{12}Intensity Level');

% estimate a rough threshold
mylim=ylim;
[C,I]=max(nelements(1:50));
MyAvg=mean(nelements);
MyDiff0=find(nelements>MyAvg);
MyDiff1=diff(MyDiff0);
DiffInd=find(MyDiff1~=1);
if length(DiffInd)>=1   % two peaks at least above average
    BackgroundRange=[MyDiff0(1) MyDiff0(DiffInd(1))];
    [CC,center1]=max(nelements([BackgroundRange(1):BackgroundRange(2)]));
    center1=center1+BackgroundRange(1)-1;
    
    ForegroundRange=[MyDiff0(DiffInd(1)+1) MyDiff0(end)];  
    [CC,center2]=max(nelements([ForegroundRange(1):ForegroundRange(2)]));
    center2=center2+ForegroundRange(1)-1;
    
    HistoThld=(centers(center1)+centers(center2))/2;
    
else                              % only one peak above average, which is the background    
    
    HistoThld=centers(MyDiff0(end));  
end



hThldLine=line([HistoThld HistoThld],mylim,'Color','b','LineWidth',2);
draggable(hThldLine,'h');

% create a usepihcurve mask
LineProfile_Mask=zeros(size(LineProfile));
LineProfile_Mask(find(LineProfile>HistoThld))=1;

% fill the holes
Mask_filled = imfill(LineProfile_Mask,'holes');
holes = Mask_filled & ~LineProfile_Mask;
bigholes = bwareaopen(holes, 100);
smallholes = holes & ~bigholes;
Mask_filled = LineProfile_Mask | smallholes;

% delete individual pixel
NowImg=double(Mask_filled);
ImgTemplate=[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
NowImg2=conv2(NowImg,ImgTemplate,'same').*NowImg;
NowImg2(find((NowImg2<5/9)))=0;
NowImg2(find((NowImg2>=5/9)))=1;

% dilate the images
% se8 = strel('disk',8,8);
% se6 = strel('disk',6,6);
% se4 = strel('disk',4,4);    
% NowImg3 = imdilate(NowImg2,se8);
% NowImg3 = imerode(NowImg3,se4);

% Finalize the mask
LineProfile_Mask=NowImg2;

% Plot in Original
axes(handles.Original);hold on;
[row,col]=find(LineProfile_Mask);
hAllDots=plot(row,col,'r.','MarkerSize',2);

% the pixel number by pixelized images
BinaryPixelNum=zeros(1,size(LineProfile,1));
for i=1:size(LineProfile,1)
    BinaryPixelNum(i)=length(find(LineProfile_Mask(i,:)));
end
% BinaryPixelNum=smooth(BinaryPixelNum,3);

ChanVessePixelNum=zeros(1,size(LineProfile,1));
% plot out in Diameter
axes(handles.Diameter);hold on;
cla(handles.Diameter);
axis([1 size(LineProfile,1) 1 size(LineProfile,2)]);

if get(handles.SmoothCurve,'Value')
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNumNew);
else
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNum);
end

xlabel('\fontsize{12}Num of stacks');
ylabel(hAx(1),'ChanVesse P.N.'); % left y-axis
ylabel(hAx(2),'Binary P.N.'); % right y-axis
set(hLine1,'Color','k');
set(hLine2,'Color','g');
set(hAx(1),'YColor','k');
set(hAx(2),'YColor','g');
% xlim1=get(hAx(1),'xlim');
% xlim2=get(hAx(2),'xlim');
set(hAx(1),'xlim',[0 size(LineProfile,1)+1]);
set(hAx(2),'xlim',[0 size(LineProfile,1)+1]);
% set(hAx(1),'ylim',[0 size(LineProfile,2)+1]);
% set(hAx(2),'ylim',[0 size(LineProfile,2)+1]);
ylim1=get(hAx(1),'ylim');
ylim2=get(hAx(2),'ylim');
set(hAx(1),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
set(hAx(2),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
box off;


% --- Executes on button press in UsePIHcurve.
function UsePIHcurve_Callback(hObject, eventdata, handles)
global BinaryPixelNum HeightStep WidthStep FrameNum CellIOT hCorrectBaseline hCV BinaryPixelNumNew PixelSize;

CellIOT=zeros(FrameNum,1);   % intensity over time
CellIOT(1:end)=BinaryPixelNum*PixelSize;

% if get(hCorrectBaseline,'Value')
%     Wave4AdjustY=CellIOT(2:20);
%     a = polyfit(2:1:20,Wave4AdjustY.',1);
%     mypatch=a(1).*(18:-1:0);
%     mypatch2=Wave4AdjustY+mypatch.';
%     mypatch2=mypatch2-(mypatch2-Wave4AdjustY(end))*3/4;
%     CellIOT(2:20)=mypatch2;
%     
% end

if get(hCorrectBaseline,'Value')
    Wave4AdjustY=CellIOT(1:30);
    a = polyfit(1:1:30,Wave4AdjustY.',1);
    mypatch=a(1).*(29:-1:0);
    mypatch2=Wave4AdjustY+mypatch.';
    mypatch2=mypatch2-(mypatch2-Wave4AdjustY(end))*3/4;
    CellIOT(1:30)=mypatch2;
    
end

% CellIOT(2:end)=smooth(CellIOT(2:end),3);

% CellIOT(2:end)=smooth(CellIOT(2:end),5);


if get(handles.SmoothCurve,'Value')
    BinaryPixelNum = BinaryPixelNumNew;
end



close(hCV);









% --- Executes on button press in AlignContour.
function AlignContour_Callback(hObject, eventdata, handles)
global LineProfile currentVesselNo hThldLine1 hThldLine2 LineProfile_New ifNew hThldLine;
global LineProfile_Mask hAllDots BinaryPixelNum ChanVessePixelNum hAx hLine1 hLine2 handlesSmoothCurve;

if ifNew
    ThisLP=LineProfile_New;
else
    ThisLP=LineProfile;    
end

AbMidPoint=round(size(ThisLP,2)/2);
MovDisAll=zeros(size(ThisLP,1),1);

for i=1:size(ThisLP,1)
%     hd_temp=figure(100);hold on;
    LP1=ThisLP(i,:);   
%     plot(LP1,'b');
    
    LP2=smooth(LP1,'lowess');
%     plot(LP2,'r--');
    
    [C,I]=max(LP2);
    BL=mean(ThisLP([1:3,end-3:end]));
    OneThirdPeak=(C-BL)/3;
    
    [CC,II]=find(ThisLP>OneThirdPeak);
    MidPoint=round(mean([min(II) max(II)]));
    
    MovDisAll(i)=MidPoint-AbMidPoint;
    
%     LP3=LP2;
%     if MidPoint<AbMidPoint
%         MovDis=AbMidPoint-MidPoint;
%         LP3(MovDis+1:end)=LP2(1:end-MovDis);
%         LP3(1:MovDis)=ones(MovDis,1)*LP2(1);
%         
%     elseif MidPoint>AbMidPoint
%         MovDis=MidPoint-AbMidPoint;
%         LP3(1:end-MovDis)=LP2(1+MovDis:end);
%         LP3(end-MovDis+1:end)=ones(MovDis,1)*LP2(end);
%     end
%     plot(LP3,'g--');
%     
    
%     ThisLP(i,:)=LP3;
    
    
    
%     pause(0.2);
%     cla(hd_temp);
end

MovDisAll2=round(smooth(MovDisAll,3));
hdd=figure;hold on;plot(MovDisAll,'b');plot(MovDisAll2,'r');
pause(0.5);close(hdd);

MovDisAll3=zeros(size(MovDisAll2));


for i=1:size(ThisLP,1)
    LP1=ThisLP(i,:);   
    LP2=smooth(LP1,'lowess');
    LP3=LP2;
    if MovDisAll3(i)<0
        temp=MovDisAll3(i)*(-1);
%         MovDis=AbMidPoint-MidPoint;
        LP3(temp+1:end)=LP2(1:end-temp);
        LP3(1:temp)=ones(temp,1)*LP2(1);
        
    elseif MovDisAll3(i)>0
%         MovDisAll2(i)=MidPoint-AbMidPoint;
        LP3(1:end-MovDisAll3(i))=LP2(1+MovDisAll3(i):end);
        LP3(end-MovDisAll3(i)+1:end)=ones(MovDisAll3(i),1)*LP2(end);
    end
    
    ThisLP(i,:)=LP3;
    
end


ifNew=1;

LineProfile_New=ThisLP;

cla(handles.Original);
axes(handles.Original);hold on;

hLP=imagesc(LineProfile_New.');
title(['\fontsize{14}r',num2str(currentVesselNo)]);
colormap(gray);
axis off;
aSize0=get(gca,'Position');

% set the starting lines
hThldLine1=line([1 size(LineProfile_New,1)],[size(LineProfile_New,2)-2 size(LineProfile_New,2)-2],'Color','g');
hThldLine2=line([1 size(LineProfile_New,1)],[3 3],'Color','g');
draggable(hThldLine1,'v');
draggable(hThldLine2,'v');

set(handles.Refine,'Visible','off');
set(handles.Accept,'Visible','off');
% set(handles.SmoothCurve,'Visible','off');

% Set the pixel histogram
allpixels=reshape(LineProfile_New,1,[]);
[nelements,centers]=hist(allpixels,50);
cla(handles.Histogram);
bar(handles.Histogram,centers(1:50),nelements(1:50));
axes(handles.Histogram);hold on;box off;
% xlim([0 150]);
ylabel('\fontsize{12}Num of Pixels');
xlabel('\fontsize{12}Intensity Level');

% estimate a rough threshold
mylim=ylim;
[C,I]=max(nelements(1:50));
MyAvg=mean(nelements);
MyDiff0=find(nelements>MyAvg);
MyDiff1=diff(MyDiff0);
DiffInd=find(MyDiff1~=1);
if length(DiffInd)>=1   % two peaks at least above average
    BackgroundRange=[MyDiff0(1) MyDiff0(DiffInd(1))];
    [CC,center1]=max(nelements([BackgroundRange(1):BackgroundRange(2)]));
    center1=center1+BackgroundRange(1)-1;
    
    ForegroundRange=[MyDiff0(DiffInd(1)+1) MyDiff0(end)];  
    [CC,center2]=max(nelements([ForegroundRange(1):ForegroundRange(2)]));
    center2=center2+ForegroundRange(1)-1;
    
    HistoThld=(centers(center1)+centers(center2))/2;
    
else                              % only one peak above average, which is the background    
    
    HistoThld=centers(MyDiff0(end));  
end

hThldLine=line([HistoThld HistoThld],mylim,'Color','b','LineWidth',2);
draggable(hThldLine,'h');

% create a usepihcurve mask
LineProfile_Mask=zeros(size(LineProfile_New));
LineProfile_Mask(find(LineProfile_New>HistoThld))=1;

% fill the holes
Mask_filled = imfill(LineProfile_Mask,'holes');
holes = Mask_filled & ~LineProfile_Mask;
bigholes = bwareaopen(holes, 100);
smallholes = holes & ~bigholes;
Mask_filled = LineProfile_Mask | smallholes;

% delete individual pixel
NowImg=double(Mask_filled);
ImgTemplate=[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
NowImg2=conv2(NowImg,ImgTemplate,'same').*NowImg;
NowImg2(find((NowImg2<5/9)))=0;
NowImg2(find((NowImg2>=5/9)))=1;


% Finalize the mask
LineProfile_Mask=NowImg2;

% Plot in Original
axes(handles.Original);hold on;
[row,col]=find(LineProfile_Mask);
hAllDots=plot(row,col,'r.','MarkerSize',1);

% the pixel number by pixelized images
BinaryPixelNum=zeros(1,size(LineProfile_New,1));
for i=1:size(LineProfile_New,1)
    BinaryPixelNum(i)=length(find(LineProfile_Mask(i,:)));
end
% BinaryPixelNum=smooth(BinaryPixelNum,3);

ChanVessePixelNum=zeros(1,size(LineProfile_New,1));
% plot out in Diameter
axes(handles.Diameter);hold on;
axis([1 size(LineProfile_New,1) 1 size(LineProfile_New,2)]);

if get(handles.SmoothCurve,'Value')
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNumNew);
else
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNum);
end

xlabel('\fontsize{12}Num of stacks');
ylabel(hAx(1),'ChanVesse P.N.'); % left y-axis
ylabel(hAx(2),'Binary P.N.'); % right y-axis
set(hLine1,'Color','k');
set(hLine2,'Color','g');
set(hAx(1),'YColor','k');
set(hAx(2),'YColor','g');
% xlim1=get(hAx(1),'xlim');
% xlim2=get(hAx(2),'xlim');
set(hAx(1),'xlim',[0 size(LineProfile_New,1)+1]);
set(hAx(2),'xlim',[0 size(LineProfile_New,1)+1]);
% set(hAx(1),'ylim',[0 size(LineProfile,2)+1]);
% set(hAx(2),'ylim',[0 size(LineProfile,2)+1]);
ylim1=get(hAx(1),'ylim');
ylim2=get(hAx(2),'ylim');
set(hAx(1),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
set(hAx(2),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
box off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function H=Heaviside(z)
% Heaviside step function (smoothed version)
epsilon=10^(-10);
H=zeros(size(z,1),size(z,2));
idx1=find(z>epsilon);
idx2=find(z<epsilon & z>-epsilon);
H(idx1)=1;
for i=1:length(idx2)
    H(idx2(i))=1/2*(1+z(idx2(i))/epsilon+1/pi*sin(pi*z(idx2(i))/epsilon));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function KG = kappa(I)
u=I;%double(I);
[ux,uy]=gradient(u);
G=sqrt(ux.^2+uy.^2);
K=divergence(ux./(G+eps),uy./(G+eps));
KG = K.*G;
KG(1,:) = eps;KG(end,:) = eps;
KG(:,1) = eps;KG(:,end) = eps;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ThisCurveNew=SmoothNonZeros(ThisCurve)

%%% find non zero range
[C,ZeroPoint]=find(~ThisCurve);
Dif1=diff(ZeroPoint);
Dif1=[0 Dif1];
[C2,ZP2]=find(Dif1~=1);
NonZeroRange=zeros(2,length(ZP2)+1);
    
if length(ZeroPoint)

    j=1;
    StartEndInd=1;
    ColumnInd=1;
    while j<=length(ThisCurve)
        if ~ismember(j,ZeroPoint)
            NonZeroRange(StartEndInd,ColumnInd)=j;
            StartEndInd=2;
        else
            if StartEndInd==2
                ColumnInd=ColumnInd+1;
            end
            StartEndInd=1;            
        end
        j=j+1;
    end
    
    % delete the redundent column
    temp=mean(NonZeroRange,1);
    [C,I]=find(temp==0);
    NonZeroRange(:,I)=[];

    ThisCurveNew=ThisCurve;
    %%%% smooth the curve
    for j=1:size(NonZeroRange,2)
        if NonZeroRange(2,j)-NonZeroRange(1,j)>=2
            ThisCurveNew(NonZeroRange(1,j):NonZeroRange(2,j))=smooth(ThisCurveNew(NonZeroRange(1,j):NonZeroRange(2,j)),3);
%             ThisCurveNew(NonZeroRange(1,j):NonZeroRange(2,j))=smooth(ThisCurveNew(NonZeroRange(1,j):NonZeroRange(2,j)),5);
%             ThisCurveNew(NonZeroRange(1,j):NonZeroRange(2,j))=smooth(ThisCurveNew(NonZeroRange(1,j):NonZeroRange(2,j)),7);
        end
    end
else
    ThisCurveNew=smooth(ThisCurve,3);
%     ThisCurveNew=smooth(ThisCurve,5);
%     ThisCurveNew=smooth(ThisCurve,7);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)




function PIHthld_Callback(hObject, eventdata, handles)




function PIHthld_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SetPIHThld.
function SetPIHThld_Callback(hObject, eventdata, handles)
global hLine1 hLine2 hAx hAllDots LineProfile currentVesselNo hThldLine LineProfile_Mask ChanVessePixelNum BinaryPixelNum hPIHthld;
global ifNew LineProfile_New hHistogram handlesSmoothCurve BinaryPixelNumNew;

if ifNew
    ThisLP=LineProfile_New;
else
    ThisLP=LineProfile;    
end

% get the location of the threshold line
HistoThld=str2num(get(hPIHthld,'String'));

% create a usepihcurve mask
LineProfile_Mask=zeros(size(ThisLP));
LineProfile_Mask(find(ThisLP>HistoThld))=1;

% fill the holes
Mask_filled = imfill(LineProfile_Mask,'holes');
holes = Mask_filled & ~LineProfile_Mask;
bigholes = bwareaopen(holes, 100);
smallholes = holes & ~bigholes;
Mask_filled = LineProfile_Mask | smallholes;

% delete individual pixel
NowImg=double(Mask_filled);
ImgTemplate=[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9];
NowImg2=conv2(NowImg,ImgTemplate,'same').*NowImg;
NowImg2(find((NowImg2<5/9)))=0;
NowImg2(find((NowImg2>=5/9)))=1;

% dilate the images
% se8 = strel('disk',8,8);
% se6 = strel('disk',6,6);
% se4 = strel('disk',4,4);    
% NowImg3 = imdilate(NowImg2,se8);
% NowImg3 = imerode(NowImg3,se4);

% Finalize the mask
LineProfile_Mask=NowImg2;
for i=1:size(ThisLP,1)
    BinaryPixelNum(i)=length(find(LineProfile_Mask(i,:)));
end
% BinaryPixelNum=smooth(BinaryPixelNum,3);

%%%%%%% update the orginal image
axes(handles.Original);hold on;
% cla(handles.Original);
delete(hAllDots);
% hLP=imagesc(LineProfile.');
% title(['\fontsize{14}r',num2str(currentVesselNo)]);
% colormap(gray);
% axis off;
[row,col]=find(LineProfile_Mask);
hAllDots=plot(row,col,'r.','MarkerSize',2);

%%%%%%%% smooth the curve while there is no 0
BinaryPixelNumNew=SmoothNonZeros(BinaryPixelNum);

%%%%%%%%%%%%%%%% update the diameter plot
axes(handles.Diameter);hold on;
cla(handles.Diameter);
% delete(hAx);

if get(handles.SmoothCurve,'Value')
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNumNew);
else
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNum);
end

xlabel('\fontsize{12}Num of stacks');xlim([0 size(ThisLP,1)+1]);
ylabel(hAx(1),'ChanVesse P.N.'); % left y-axis
ylabel(hAx(2),'Binary P.N.'); % right y-axis
set(hLine1,'Color','k');
set(hLine2,'Color','g');
set(hAx(1),'YColor','k');
set(hAx(2),'YColor','g');
set(hAx(1),'xlim',[0 size(ThisLP,1)+1]);
set(hAx(2),'xlim',[0 size(ThisLP,1)+1]);
% set(hAx(1),'ylim',[0 size(LineProfile,2)+1]);
% set(hAx(2),'ylim',[0 size(LineProfile,2)+1]);
ylim1=get(hAx(1),'ylim');
ylim2=get(hAx(2),'ylim');
set(hAx(1),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
set(hAx(2),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
box off;


%%%%%% update the position of draggable threshold
axes(hHistogram);hold on;
delete(hThldLine);
mylim=ylim;
hThldLine=line([HistoThld HistoThld],mylim,'Color','b','LineWidth',2);
draggable(hThldLine,'h');




% --- Executes on button press in SmoothCurve.
function SmoothCurve_Callback(hObject, eventdata, handles)
global BinaryPixelNumNew BinaryPixelNum hAx hLine1 hLine2 LineProfile ChanVessePixelNum handlesSmoothCurve;


axes(handles.Diameter);hold off;
cla(handles.Diameter, 'reset');

if get(handles.SmoothCurve,'Value')
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNumNew);
else
    [hAx,hLine1,hLine2] = plotyy(1:size(LineProfile,1),ChanVessePixelNum,1:size(LineProfile,1),BinaryPixelNum);
end

xlabel('\fontsize{12}Num of stacks');
ylabel(hAx(1),'ChanVesse P.N.'); % left y-axis
ylabel(hAx(2),'Binary P.N.'); % right y-axis
set(hLine1,'Color','k');
set(hLine2,'Color','g');
set(hAx(1),'YColor','k');
set(hAx(2),'YColor','g');
% xlim1=get(hAx(1),'xlim');
% xlim2=get(hAx(2),'xlim');
set(hAx(1),'xlim',[0 size(LineProfile,1)+1]);
set(hAx(2),'xlim',[0 size(LineProfile,1)+1]);
% set(hAx(1),'ylim',[0 size(LineProfile,2)+1]);
% set(hAx(2),'ylim',[0 size(LineProfile,2)+1]);
ylim1=get(hAx(1),'ylim');
ylim2=get(hAx(2),'ylim');
set(hAx(1),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
set(hAx(2),'ylim',[min([ylim1(1) ylim2(1)]) max([ylim1(2) ylim2(2)])]);
box off;
