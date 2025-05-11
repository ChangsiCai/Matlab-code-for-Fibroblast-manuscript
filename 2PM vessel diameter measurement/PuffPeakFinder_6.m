function [PPT PPLoc NPT NPLoc HPPT HPPLoc HNPT HNPLoc PPPA PNPA_woPP PNPA_wPP PNPT_woPP PNPLoc_woPP]=PuffPeakFinder_6(mywave,FrameNo1,FrameNo2)  
% This function is to detect the positive and negative peak of the wave
% after puffing

% PPT: positive peak time
% PPLoc: positive peak location
% NPT: negative peak time
% NPLoc: negative peak location
% HPPT: half positive peak time
% HPPLoc: half positive peak location
% HNPT: half negative peak time
% HNPLoc: half negative peak location
% PPPA: PuffPosPeakAmp_Real
% PNPA_woPP: PuffNegPeakAmp_Real without counting the positive peak
% PNPA_wPP: PuffNegPeakAmp_Real with counting the positive peak
% PNPT_woPP: PuffNegPeakTime_Real_woPP for time of half of pure negative peak
% PNPLoc_woPP: PuffNegPeakLoc_Real_woPP for amp of half of pure negative peak




FrameNo=str2num(FrameNo1);
FrameNo2=str2num(FrameNo2);

global BaseLineFrameNo FrameTime myTimeTicks STITimeTicks CutFrameNum1;


if FrameNo~=0

    % calculate baseline
    bl=mywave(CutFrameNum1:BaseLineFrameNo);   
    blmean=mean(bl);
    blstd=std(bl);
%     bl=mean(mywave(FrameNo-15:FrameNo));

    % time range when detection of positive peak
    TimeRange=30;    % no later than 30s after stimulation

    %%%% detection of positive peak
    % curvefitting
    PosPeakTimeWin=myTimeTicks(FrameNo:FrameNo+round(TimeRange/FrameTime*1000)); 
    PosPeakLocWin=mywave(FrameNo:FrameNo+round(TimeRange/FrameTime*1000));
    P=polyfit(PosPeakTimeWin,PosPeakLocWin,11);
    % interpolation
    mywaveInterpX=linspace(PosPeakTimeWin(1),PosPeakTimeWin(end),1000);
    mywaveInterpY=polyval(P,mywaveInterpX);
    
%     %%% plot out
%     figure(100);hold on;
%     plot(PosPeakTimeWin,PosPeakLocWin,'b');
%     plot(mywaveInterpX,mywaveInterpY,'r');
    
    % calculate baseline for positive peak, try to save the data from over
    % puffed constriction
    SearchRange=10;     % 5sec search for the puffing mechanical dip
    bl4DilRange=[FrameNo-1:FrameNo+fix(SearchRange*1000/FrameTime)];
    [bl4Dil,I]=min(mywave(bl4DilRange));
%     plot(bl4DilRange,mywave(bl4DilRange),'y');
    
    if bl4Dil<1
        % find max for positive peak
        c0=mywave(bl4DilRange(I));
        [c1,i1]=min(abs(mywaveInterpY-c0));
        
        [C,I]=max(mywaveInterpY(i1:end));
        if I==1                % it means there're two dots which is very close to c0, while the nearest one could potentially be the down part from Dilation peak. Judge it.
            [c1,i1]=min(abs(mywaveInterpY(1:i1-10)-c0));
            [C,I]=max(mywaveInterpY(i1:end));
        end
        PPT=mywaveInterpX(I+i1-1);
        PPLoc=C;
        PPPA=C-bl4Dil;
    
        %judge whether the positive peak exist
        if PPPA>=0.01 && I+i1-1~=1
            HPPLoc=bl4Dil+PPPA/2;
            xx=I+i1-1;xxloc=C;
            while xx>1 && xxloc>HPPLoc 
                xx=xx-1;
                xxloc=mywaveInterpY(xx);
            end
            HPPT=mywaveInterpX(xx);
            HPPLoc=mywaveInterpY(xx);
        else
            PPT=0;
            PPLoc=0;
            HPPT=0;
            HPPLoc=0;
            PPPA=0;
        end
    else
        % find max for positive peak
        [C,I]=max(mywaveInterpY);
        PPT=mywaveInterpX(I);
        PPLoc=C;
        PPPA=C-blmean;
        
        %judge whether the positive peak exist
        if PPPA>=0.01 && I~=1
            HPPLoc=blmean+PPPA/2;
            xx=I;xxloc=C;
            while xx>1 && xxloc>HPPLoc 
                xx=xx-1;
                xxloc=mywaveInterpY(xx);
            end
            HPPT=mywaveInterpX(xx);
            HPPLoc=mywaveInterpY(xx);
        else
            PPT=0;
            PPLoc=0;
            HPPT=0;
            HPPLoc=0;
            PPPA=0;
        end
    end

    
    
%     %%%% plot
%     hd10=figure(10);hold on;
%     plot(PosPeakTimeWin,PosPeakLocWin,'b');
%     plot(mywaveInterpX,mywaveInterpY,'r');
%     if PPT
%         plot([PPT PPT],[C-0.1 C+0.1],'r.-');
%         plot([HPPT HPPT],[HPPLoc-0.1 HPPLoc+0.1],'r--');
%     end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% time range when detection of negative peak
    TimeRangeN=320;    % no later than 70s after positive peak
    

    %%%% detection of negative peak
    % curvefitting
    if PPT~=0 && PPLoc~=0
        NegPeakTimeWin=myTimeTicks(ceil(PPT/FrameTime*1000):FrameNo+round(TimeRangeN/FrameTime*1000));
        NegPeakLocWin=mywave(ceil(PPT/FrameTime*1000):FrameNo+round(TimeRangeN/FrameTime*1000));
    else
        NegPeakTimeWin=myTimeTicks(FrameNo2+10:FrameNo2+10+round(TimeRangeN/FrameTime*1000));
        NegPeakLocWin=mywave(FrameNo2+10:FrameNo2+10+round(TimeRangeN/FrameTime*1000));
    end
    P=polyfit(NegPeakTimeWin,NegPeakLocWin,11);
    % interpolation
    mywaveInterpX=linspace(NegPeakTimeWin(1),NegPeakTimeWin(end),1000);
    mywaveInterpY=polyval(P,mywaveInterpX);
%     %%% plot out
%     figure(101);hold on;
%     plot(NegPeakTimeWin,NegPeakLocWin,'b');
%     plot(mywaveInterpX,mywaveInterpY,'r');
    
    
    % find min for negative peak
    [C2,I2]=min(mywaveInterpY);
    NPT=mywaveInterpX(I2);
    NPLoc=C2;
%     PNPA_woPP=PosPeakLocWin(1)-C2;
    if PPLoc~=0
        PNPA_wPP=blmean-C2;
    else
        PNPA_wPP=C-C2;
    end
    
    
    % judge if there's a neg peak (no matter higher or lower of BL)
    if NegPeakLocWin(1)-C2>=0.05     % amplitude must be higher than 2%
        HNPLoc=NegPeakLocWin(1)-(NegPeakLocWin(1)-C2)/2;
        xx=I2;xxloc=C2;
        while xx>0 && xxloc<HNPLoc 
            xx=xx-1;
            xxloc=mywaveInterpY(xx);
        end
        HNPT=mywaveInterpX(xx);
        HNPLoc=mywaveInterpY(xx);
        PNPA_woPP=blmean-C2;
        if PNPA_woPP<0
            PNPA_woPP=0;
        end
    else                
        HNPT=0;
        HNPLoc=0;
        PNPA_woPP=0;
    end
    
    % judge if there's real real real a neg peak (must be lower than BL)
    if blmean-C2>=0.05 
        RuAim=blmean-(blmean-C2)/2;
        xx=I2;xxloc=C2;
        while xx>1 && xxloc<RuAim 
            xx=xx-1;
            xxloc=mywaveInterpY(xx);
        end
        PNPT_woPP=mywaveInterpX(xx);
        PNPLoc_woPP=mywaveInterpY(xx);
    else
        PNPT_woPP=0;
        PNPLoc_woPP=0;
    end
    
    
%     %%%% plot
%     hd11=figure(11);hold on;
%     plot(NegPeakTimeWin,NegPeakLocWin,'b');
%     plot(mywaveInterpX,mywaveInterpY,'r');
%     if NPT
%         plot([NPT NPT],[C2-0.1 C2+0.1],'r.-');
%         plot([HNPT HNPT],[HNPLoc-0.1 HNPLoc+0.1],'r--');
%     end
%     
%     pause;
%     close(hd10);close(hd11);
    
else
    PPT=0;
    PPLoc=0;
    HPPT=0;
    HPPLoc=0;
    PPPA=0;
    NPT=0;
    NPLoc=0;
    HNPT=0;
    HNPLoc=0;
    PNPA_woPP=0;
    PNPA_wPP=0;
    PNPT_woPP=0;
    PNPLoc_woPP=0;
end





