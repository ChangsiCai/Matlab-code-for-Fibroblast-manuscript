function [PeakAmp,PeakTime,OnsetTime,Duration,AUC,RisingSlope,CaTransReg,CaTransPeakX,CaTransPeakY,CaTransAUC,CaTransDurt,CaTransMask] = AnalysisPeaks_Lcmt_ThldAvg2Std_4FBCa_AllTime_v9(Time_all,Ca_all,AirPuffTime,LcmtDurt,mytitle,PreDurt,BLcurves)
showfigure = 0;

if showfigure
    hd3 = figure(3);hold on;
    title(mytitle);
    plot(Time_all,Ca_all,'b--');
end

Ca_all_smth = Ca_all;
I00=find(~isnan(Ca_all));


% Ca_all_smth(I00) = smooth(Ca_all(I00),30);
% Ca_all_smth(I00) = smooth(Ca_all_smth(I00),30);

if showfigure
    plot(Time_all,Ca_all_smth,'b');
    mylim=ylim;
    plot([0 0],[mylim(1)*1.01 mylim(2)*0.99],'r--');
end

%%%%%% Area under the curve
I0 = find(Time_all>=AirPuffTime & Time_all<=AirPuffTime+LcmtDurt);
AUC = sum(Ca_all_smth(I0)-1).*(Time_all(3)-Time_all(2))*100;

I0 = find(Time_all>=AirPuffTime & Time_all<=AirPuffTime+LcmtDurt);


%%%%%% peak point
Ca_all_smth2 = Ca_all_smth(I0);
[C1,I1] = max(Ca_all_smth2);
I1 = I1+I0(1)-1;
PeakAmp = (C1-1)*100;

if PeakAmp>3

    if showfigure
        plot(Time_all(I1),C1,'r*');
    end
    PeakTime = Time_all(I1)-AirPuffTime;

    % I_bl = find(Time_all<AirPuffTime & Time_all>AirPuffTime+PreDurt);
    bl_mean = mean(BLcurves,'omitnan');
    bl_std = std(BLcurves,'omitnan');
    bl_thld = bl_mean+2*bl_std;

    %%%%%%% uprising
    HalfPeakAmp = bl_thld;
    I2 = find(Ca_all_smth>=HalfPeakAmp);
    CaTransMask = zeros(size(Ca_all_smth));

    %%% merge the small events if their interval is less than 1s
    MaskTmp=zeros(size(Ca_all_smth));MaskTmp(I2)=1;
    se = strel('line', 20, 90);
    MaskTmp = imclose(MaskTmp,se);
    I2=find(MaskTmp);

    %%% take away the small events if their duration is less than 0.5s
    MaskTmp=zeros(size(Ca_all_smth));MaskTmp(I2)=1;
    se2 = strel('line', 10, 90);
    MaskTmp = imerode(MaskTmp,se2);
    MaskTmp = imdilate(MaskTmp,se2);
    I2=find(MaskTmp);

    I2_diam = I2;
    % I2_diam = I2_diam+I0(1)-1;
    if showfigure
        if length(I2_diam)
            plot(Time_all(I2_diam),Ca_all_smth(I2_diam),'r-');
            plot(Time_all(I2_diam(1)),Ca_all_smth(I2_diam(1)),'r*');
        end
    end

    
    I2_diam_diff = diff(I2_diam);
    [C5,I5] = find(I2_diam_diff~=1);
    if length(I5)==0 && length(I2_diam)~=0
        CaTransReg=[Time_all(I2_diam(1)) Time_all(I2_diam(end))]-AirPuffTime;
        CaTransPeakY = PeakAmp;
        CaTransPeakX = PeakTime;
        CaTransMask(I2_diam(1):I2_diam(end))=1;
        CaTransAUC = sum(Ca_all_smth(I2_diam(1):I2_diam(end))-1).*(Time_all(3)-Time_all(2))*100;

    elseif length(I5)>0
        CaTransReg = zeros(length(I5)+1,2);
        CaTransPeakY = zeros(length(I5)+1,1);
        CaTransPeakX = zeros(length(I5)+1,1);
        CaTransAUC = zeros(length(I5)+1,1);
        for kkk = 1:length(I5)+1
            if kkk ==1
                CaTransReg(kkk,1)=I2_diam(1);
                CaTransReg(kkk,2)=I2_diam(I5(kkk));
                CaTransMask(I2_diam(1):I2_diam(I5(kkk)))=1;
            elseif kkk==length(I5)+1
                CaTransReg(kkk,1)=I2_diam(I5(kkk-1)+1);
                CaTransReg(kkk,2)=I2_diam(length(I2_diam));
                CaTransMask(I2_diam(I5(kkk-1)+1):I2_diam(length(I2_diam)))=1;
            else
                CaTransReg(kkk,1)=I2_diam(I5(kkk-1)+1);
                CaTransReg(kkk,2)=I2_diam(I5(kkk));
                CaTransMask(I2_diam(I5(kkk-1)+1):I2_diam(I5(kkk)))=1;
            end

             [Cmax,Imax] = max(Ca_all_smth(CaTransReg(kkk,1):CaTransReg(kkk,2)));
             CaTransPeakY(kkk) = (Cmax-1)*100;
             CaTransPeakX(kkk) = Imax+CaTransReg(kkk,1)-1;
             CaTransAUC(kkk) = sum(Ca_all_smth(CaTransReg(kkk,1):CaTransReg(kkk,2))-1).*(Time_all(3)-Time_all(2))*100;
            
        end
        
        %%% if amplitude is less than 5%
        I6=find(CaTransPeakY<3);
        if length(I6)~=0
            CaTransReg(I6,:)=[];
            CaTransPeakY(I6)=[];
            CaTransPeakX(I6)=[];
        end

        %%% if the duration is less than 1s, erase it
        DurtTmp = Time_all(CaTransReg);
        DurtTmp2 = diff(DurtTmp.');
        Ck = find(DurtTmp2<=1);
        CaTransReg(Ck,:)=[];
        CaTransPeakY(Ck)=[];
        CaTransPeakX(Ck)=[];
        CaTransAUC(Ck)=[];


        CaTransReg = Time_all(CaTransReg)-AirPuffTime;
        CaTransPeakX = Time_all(CaTransPeakX)-AirPuffTime;

    elseif length(I2_diam)==0
        CaTransReg=NaN;
        CaTransPeakY = NaN;
        CaTransPeakX = NaN;
        CaTransAUC = NaN;
    end

    I2_stim = find(Ca_all_smth2>=HalfPeakAmp);
    I2_stim = I2_stim+I0(1)-1;

    if length(I2_stim)
        OnsetTime = Time_all(I2_stim(1))-AirPuffTime;
        Duration = length(I2_stim)*(Time_all(3)-Time_all(2));

        % I2_tmp = diff(I2_stim);

        RisingSlope = NaN;

        %%%%%%% falling
        if contains(mytitle, 'Ca')
            FallingHalfPeakTime = Time_all(I2_diam(end));
            if showfigure
                plot(FallingHalfPeakTime,Ca_all_smth(I2_diam(end)),'r*');
            end
        else
            FallingHalfPeakTime = Time_all(I2_stim(end));
            if showfigure
                plot(FallingHalfPeakTime,Ca_all_smth(I2_stim(end)),'r*');
            end
            % CaTransReg = [Time_all(I2_stim(1)) FallingHalfPeakTime];
            % CaTransPeakX = Time_all(I1);
            % CaTransPeakY = PeakAmp;
        end

        % Duration = FallingHalfPeakTime-Time_all(I2_stim(1));
        Duration = length(I2_stim).*(Time_all(3)-Time_all(2));



    elseif length(I2_stim)==0
        OnsetTime = NaN;
        Duration = NaN;
        RisingSlope = NaN;

        % CaTransPeakY = NaN;
        % CaTransPeakX = NaN;
    end


    if showfigure
        mylim=ylim;plot([AirPuffTime AirPuffTime],[mylim(1)*1.01 mylim(2)*0.99],'r--');
    end
else
    % PeakAmp=;
    PeakTime=NaN;
    OnsetTime=NaN;
    Duration=NaN;
    RisingSlope=NaN;

    CaTransPeakY = NaN;
    CaTransPeakX = NaN;
    CaTransReg=NaN;
    CaTransAUC = NaN;

    CaTransMask = NaN;

end

if ~isnan(CaTransReg)
    CaTransDurt = CaTransReg(:,2) - CaTransReg(:,1);
else
    CaTransDurt = NaN;
end

pause(0.1);

if showfigure
    close(hd3);
end
