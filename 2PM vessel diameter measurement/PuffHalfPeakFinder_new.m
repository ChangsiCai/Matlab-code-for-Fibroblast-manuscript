function [HPPT HPPLoc HNPT HNPLoc]=PuffHalfPeakFinder_new(mywave,FrameNo1)  
% This function is to detect the positive and negative peak of the wave
% after puffing

% PPT: positive peak time
% PPLoc: positive peak location
% NPT: negative peak time
% NPLoc: negative peak location

FrameNo=str2num(FrameNo1);

global BaseLineFrameNo FrameTime myTimeTicks STITimeTicks;

if FrameNo~=0

    % calculate baseline
    bl=mywave(FrameNo);

    % time range when detection of positive peak
    TimeRange=15;    % no later than 30s after stimulation

    %%%% detection of positive peak
    % curvefitting
    PosPeakTimeWin=myTimeTicks(FrameNo:FrameNo+round(TimeRange/FrameTime*1000)); 
    PosPeakLocWin=mywave(FrameNo:FrameNo+round(TimeRange/FrameTime*1000));
    P=polyfit(PosPeakTimeWin,PosPeakLocWin,7);
    % interpolation
    mywaveInterpX=linspace(PosPeakTimeWin(1),PosPeakTimeWin(end),1000);
    mywaveInterpY=polyval(P,mywaveInterpX);
    % find max for positive peak
    [C,I]=max(mywaveInterpY);
    PPT=mywaveInterpX(I);
    PPLoc=C;
    
    % time range when detection of negative peak
    TimeRangeN=60;    % no later than 70s after stimulation
    

    %%%% detection of negative peak
    % curvefitting
    NegPeakTimeWin=myTimeTicks(ceil(PPT/FrameTime*1000):FrameNo+round(TimeRangeN/FrameTime*1000));
    NegPeakLocWin=mywave(ceil(PPT/FrameTime*1000):FrameNo+round(TimeRangeN/FrameTime*1000));
    P=polyfit(NegPeakTimeWin,NegPeakLocWin,7);
    % interpolation
    mywaveInterpX=linspace(NegPeakTimeWin(1),NegPeakTimeWin(end),1000);
    mywaveInterpY=polyval(P,mywaveInterpX);
    % find min for positive peak
    [C,I]=min(mywaveInterpY);
    NPT=mywaveInterpX(I);
    NPLoc=C;
    
    
else
    PPT=0;
    PPLoc=0;
    NPT=0;
    NPLoc=0;
end
