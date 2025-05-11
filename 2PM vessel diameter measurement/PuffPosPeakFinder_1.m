function [ResStTime ResStLoc]=PuffPosPeakFinder_1(mywave,FrameNo1)
% This function is to detect the start time of response after STI
% after start of STI, if wave is larger than 10% of (peak-baseline)

FrameNo=str2num(FrameNo1);

global BaseLineFrameNo FrameTime myTimeTicks STITimeTicks;

if FrameNo~=0

    % calculate baseline
    bl=mywave(FrameNo);

    TimeRange=40;    % no later than 20s after stimulation

    % peak property
    [peakc,peaki]=max(mywave(FrameNo:FrameNo+round(TimeRange/FrameTime*1000)));

    % interpolation
    TimeWindow=myTimeTicks(FrameNo:FrameNo+round(TimeRange/FrameTime*1000)); 
    mywaveInterpX=linspace(TimeWindow(1),TimeWindow(end),1000);
    mywaveInterpY=interp1(TimeWindow,mywave(FrameNo:FrameNo+round(TimeRange/FrameTime*1000)),mywaveInterpX,'spline');
    
    
    if length(Onset10P)
        stall=find(mywaveInterpY>=1+Onset10P);
        if ~isempty(stall)
            ResStTime=mywaveInterpX(stall(1))+FrameTime/1000;   % mywave count from the second frame, while myTimeTicks count from the very beginning
            ResStLoc=mywaveInterpY(stall(1));
        else
            ResStTime=0;
            ResStLoc=0;
        end
    else
        ResStTime=0;
        ResStLoc=0;
    end
else
    ResStTime=0;
    ResStLoc=0;
end
