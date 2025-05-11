function [CaTransRegCord,CaTransRegTime,CaTransPeakY,CaTransAUC,CaTransDurt,CaTransMask] = AnalysisPeaks_Spt_ThldAvg2Std_4FBCa_AllTime_v12(Time_all,Ca_all,mytitle,ThisBLIndex,ThisThld)
showfigure = 0;

if showfigure
    hd3 = figure(3);hold on;
    title(mytitle);
    plot(Time_all,Ca_all,'b--');
end

Ca_all_smth = Ca_all;
I00=find(~isnan(Ca_all));


Ca_all_smth(I00) = smooth(Ca_all(I00),30);
% Ca_all_smth(I00) = smooth(Ca_all_smth(I00),30);

if showfigure
    plot(Time_all,Ca_all_smth,'b');
    mylim=ylim;
    plot([0 0],[mylim(1)*1.01 mylim(2)*0.99],'r--');
end

%%%%%%%%%
II = ThisBLIndex;
BLcurves = Ca_all_smth(II);

if showfigure
    plot(Time_all(II),BLcurves,'g');
end

% BLcurves = smooth(BLcurves,30);
bl_mean = mean(BLcurves,'omitnan');
bl_std = std(BLcurves,'omitnan');
bl_thld = bl_mean+ThisThld*bl_std;

if showfigure
    plot(Time_all,bl_mean*ones(size(Time_all)),'k-');
    plot(Time_all,(bl_mean+bl_std)*ones(size(Time_all)),'k--');
    plot(Time_all,bl_thld*ones(size(Time_all)),'k--');
end

I2 = find(Ca_all_smth>=bl_thld);
CaTransMask = zeros(size(Ca_all_smth));

I22 = find(Ca_all_smth>=bl_mean+bl_std); %%% the purpose is to find a more precise start and end time of Ca2+


%%% merge the small events if their interval is less than 1s
MaskTmp=zeros(size(Ca_all_smth));MaskTmp(I2)=1;
se = strel('line', 20, 0);
MaskTmp = imclose(MaskTmp,se);
I2=find(MaskTmp);

%%% take away the small events if their duration is less than 0.5s
MaskTmp=zeros(size(Ca_all_smth));MaskTmp(I2)=1;
se2 = strel('line', 15, 0);
MaskTmp = imerode(MaskTmp,se2);
MaskTmp = imdilate(MaskTmp,se2);
I2=find(MaskTmp);

I2_Ca = I2;


%%%%
I2_Ca_diff = diff(I2_Ca);
[C5,I5] = find(I2_Ca_diff~=1);
if length(I5)==0 && length(I2_Ca)~=0
    % CaTransReg=[Time_all(I2_Ca(1)) Time_all(I2_Ca(end))];

    NewStartPoint = findRealStartCaTrans(Time_all,Ca_all_smth,I2_Ca(1),bl_mean, bl_mean + bl_std,5);
    NewEndPoint = findRealEndCaTrans(Time_all,Ca_all_smth,I2_Ca(end),bl_mean, bl_mean + bl_std,5);


    CaTransReg=[NewStartPoint NewEndPoint];
    ThisCaWave=Ca_all_smth(NewStartPoint:NewEndPoint);
    CaTransMask(NewStartPoint:NewEndPoint)=1;
    [Cmax,Imax] = max(ThisCaWave);
    CaTransPeakY = (Cmax-1)*100;
    CaTransDurt = Time_all(NewEndPoint) - Time_all(NewStartPoint);
    CaTransAUC = sum(ThisCaWave-1)*100*(Time_all(3)-Time_all(2));
    
elseif length(I5)>0
    CaTransReg = zeros(length(I5)+1,2);
    CaTransPeakY = zeros(length(I5)+1,1);
    CaTransDurt = zeros(length(I5)+1,1);
    CaTransAUC = zeros(length(I5)+1,1);

    for kkk = 1:length(I5)+1
        if kkk ==1
            NewStartPoint = findRealStartCaTrans(Time_all,Ca_all_smth,I2_Ca(1),bl_mean, bl_mean + bl_std,5);
            NewEndPoint = findRealEndCaTrans(Time_all,Ca_all_smth,I2_Ca(I5(kkk)),bl_mean, bl_mean + bl_std,5);

            CaTransReg(kkk,1)=NewStartPoint;
            CaTransReg(kkk,2)=NewEndPoint;
            CaTransMask(NewStartPoint:NewEndPoint)=1;
        elseif kkk==length(I5)+1
            NewStartPoint = findRealStartCaTrans(Time_all,Ca_all_smth,I2_Ca(I5(kkk-1)+1),bl_mean, bl_mean + bl_std,5);
            NewEndPoint = findRealEndCaTrans(Time_all,Ca_all_smth,I2_Ca(length(I2_Ca)),bl_mean, bl_mean + bl_std,5);

            CaTransReg(kkk,1)=NewStartPoint;
            CaTransReg(kkk,2)=NewEndPoint;
            CaTransMask(NewStartPoint:NewEndPoint)=1;
        else
            NewStartPoint = findRealStartCaTrans(Time_all,Ca_all_smth,I2_Ca(I5(kkk-1)+1),bl_mean, bl_mean + bl_std,5);
            NewEndPoint = findRealEndCaTrans(Time_all,Ca_all_smth,I2_Ca(I5(kkk)),bl_mean, bl_mean + bl_std,5);

            CaTransReg(kkk,1)=NewStartPoint;
            CaTransReg(kkk,2)=NewEndPoint;
            CaTransMask(NewStartPoint:NewEndPoint)=1;
        end

        ThisCaWave=Ca_all_smth(CaTransReg(kkk,1):CaTransReg(kkk,2));
        [Cmax,Imax] = max(ThisCaWave);
        CaTransPeakY(kkk) = (Cmax-1)*100;
        CaTransDurt(kkk) = Time_all(CaTransReg(kkk,2)) - Time_all(CaTransReg(kkk,1));
        CaTransAUC(kkk) = sum(Ca_all_smth(CaTransReg(kkk,1):CaTransReg(kkk,2))-1).*(Time_all(3)-Time_all(2))*100;

    end

elseif length(I2_Ca)==0
    CaTransReg=NaN;
    CaTransPeakY = NaN;
    CaTransDurt = NaN;
    CaTransAUC = NaN;

end


%%% if amplitude is less than 2%
I6=find(CaTransPeakY<2);
if length(I6)~=0
    CaTransMask(CaTransReg(I6,1):CaTransReg(I6,2))=0;
    CaTransReg(I6,:)=[];
    CaTransPeakY(I6)=[];
    CaTransDurt(I6)=[];
    CaTransAUC(I6)=[];
end


%%% if the duration is less than 1s, erase it
if ~isnan(CaTransReg)
    DurtTmp = Time_all(CaTransReg);
    DurtTmp2 = diff(DurtTmp.');
    Ck = find(DurtTmp2<=1);
    for i = 1:length(Ck)
        CaTransMask(CaTransReg(Ck(i),1):CaTransReg(Ck(i),2))=0;
    end
    CaTransReg(Ck,:)=[];
    CaTransPeakY(Ck)=[];
    CaTransDurt(Ck)=[];
    CaTransAUC(Ck)=[];

    CaTransRegCord = CaTransReg;
    CaTransRegTime = Time_all(CaTransReg);
else
    CaTransRegCord=[];
    CaTransRegTime=[];

end

%%% if the duration is more than 30s, erase it
if ~isnan(CaTransReg)
    DurtTmp = Time_all(CaTransReg);
    DurtTmp2 = diff(DurtTmp.');
    Ck = find(DurtTmp2>30);
    for i = 1:length(Ck)
        CaTransMask(CaTransReg(Ck(i),1):CaTransReg(Ck(i),2))=0;
    end
    CaTransReg(Ck,:)=[];
    CaTransPeakY(Ck)=[];
    CaTransDurt(Ck)=[];
    CaTransAUC(Ck)=[];

    CaTransRegCord = CaTransReg;
    CaTransRegTime = Time_all(CaTransReg);
else
    CaTransRegCord=[];
    CaTransRegTime=[];

end



if showfigure
    if size(CaTransReg,1)
        for kk = 1:size(CaTransReg,1)
            ThisCaTrans = CaTransReg(kk,:);
            plot(Time_all(ThisCaTrans(1):ThisCaTrans(2)),Ca_all_smth(ThisCaTrans(1):ThisCaTrans(2)),'r-');
        end
    end
end



% pause;

if showfigure
    close(hd3);
end
