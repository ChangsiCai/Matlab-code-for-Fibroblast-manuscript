function [ResStTime50, ResStLoc50, ResPeakTime, ResPeakLoc, ResConsTimePN50, ResConsLocPN50, ResConsTimeP50, ResConsLocP50, ResNegPeakTime, ResNegPeakLoc, ResBackToBaselineTime]=AirPuffPeakFinder(mywave,FrameNo1,FrameNo2)  
% This function is to detect the positive and negative peak of the wave
% after air puff of whisker


global BaseLineFrameNo FrameTime myTimeTicks CutFrameNum1 CutFrameNum2 PuffTimeNo1;
% baseline properties
bl=mywave(CutFrameNum1:BaseLineFrameNo);   
blmean=mean(bl);
blstd=std(bl);

TimeRangeP=30;    % positive peak is detected in no later than 20s after stimulation
TimeRangeN=60;   % negative peak is detected in no later than 100s after stimulation
DiamChangeThrld=0.01;




% peak property
[peakc,peaki]=max(mywave(BaseLineFrameNo+1:BaseLineFrameNo+round(TimeRangeP/FrameTime*1000)));
[peakcN,peakiN]=min(mywave(peaki:min([BaseLineFrameNo+round(TimeRangeN/FrameTime*1000),CutFrameNum2])));


% onset property
Onset50P=0.5*(peakc-blmean);
Fall50PN=peakc-1-0.5*(peakc-peakcN);


% interpolation
if str2num(FrameNo1)~=0
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Onset rising phase
    TimeWindow=myTimeTicks(find(myTimeTicks>=PuffTimeNo1 & myTimeTicks<=PuffTimeNo1+TimeRangeP));  % if 90s after the STI, there's still no response, then the vascular response do not exist
    mywaveInterpX=linspace(TimeWindow(1),TimeWindow(end),1000);    
    mywaveInterpY=interp1(TimeWindow,mywave(find(myTimeTicks>=PuffTimeNo1 & myTimeTicks<=PuffTimeNo1+TimeRangeP)),mywaveInterpX);
    
    [tC,tI]=max(mywaveInterpY);
    ResPeakTime=mywaveInterpX(tI);
    ResPeakLoc=tC;
    
    
%     if length(Onset50P)
        stall=find(mywaveInterpY>=1+Onset50P);
        if ~isempty(stall) && mywaveInterpY(stall(1))-1>=DiamChangeThrld && stall(1)~=1
            ResStTime50=mywaveInterpX(stall(1));   % mywave count from the second frame, while myTimeTicks count from the very beginning
            ResStLoc50=mywaveInterpY(stall(1));
            
        else
            ResStTime50=0;
            ResStLoc50=0;
        end
%     else
%         ResStTime=0;
%         ResStLoc=0;
%         ResPeakTime=0;
%         ResPeakLoc=0;
%     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Response Falling phase
    NewCutTime1FN=BaseLineFrameNo+peaki;
    NewCutTime2FN=min([BaseLineFrameNo+round(TimeRangeN/FrameTime*1000),CutFrameNum2]);
    TimeWindow2=myTimeTicks(NewCutTime1FN:NewCutTime2FN);  
    mywaveInterpX=linspace(myTimeTicks(NewCutTime1FN),myTimeTicks(NewCutTime2FN),1000);    
    mywaveInterpY=interp1(TimeWindow2,mywave(NewCutTime1FN:NewCutTime2FN),mywaveInterpX);
    
    [tNC,tNI]=min(mywaveInterpY);
    ResNegPeakTime=mywaveInterpX(tNI);
    ResNegPeakLoc=tNC;
    
    %%%% This is for pure 0.5 falling phase without undershoot
    stallN=find(mywaveInterpY<=1+Onset50P);
    if ~isempty(stallN) && abs(peakc-peakcN)>=DiamChangeThrld*2 && stallN(1)~=1
        ResConsTimeP50=mywaveInterpX(stallN(1));
        ResConsLocP50=mywaveInterpY(stallN(1));
        
        % count where does the dilation come back to baseline
        BLCountN=1;
        if min(mywaveInterpY)<1
            while mywaveInterpY(stallN(BLCountN))>1
                BLCountN=BLCountN+1;                
            end
            ResBackToBaselineTime=mywaveInterpX(stallN(BLCountN));
        else
            [CCm,IIm]=min(mywaveInterpY);
            ResBackToBaselineTime=mywaveInterpX(IIm);
        end
         
    else
        ResConsTimeP50=0;
        ResConsLocP50=0;
        ResBackToBaselineTime=0;
    end
    
    %%% This is a combinatin of positive and negative peak
    stallPN=find(mywaveInterpY<=1+Fall50PN);
    if ~isempty(stallPN) && abs(peakc-peakcN)>=DiamChangeThrld*2 && stallPN(1)~=1
        ResConsTimePN50=mywaveInterpX(stallPN(1));
        ResConsLocPN50=mywaveInterpY(stallPN(1));   
         
    else
        ResConsTimePN50=0;
        ResConsLocPN50=0;
    end
    
    
%     % mean AUC in the last 1 min
%     LastOneMin=fix(60/(myTimeTicks(2)-myTimeTicks(1)));
%     AUCLast1min=mean(mywave(CutFrameNum2-LastOneMin:CutFrameNum2));     % unit: % per min
    
else
    
    [peakc,peaki]=max(mywave(BaseLineFrameNo+1:CutFrameNum2));
    [peakcN,peakiN]=min(mywave(peaki:CutFrameNum2));
    
    ResStTime50=0;
    
    ResStLoc50=0;
    ResPeakTime=0;
    ResPeakLoc=peakc;
    
    ResNegPeakTime=0;
    ResNegPeakLoc=peakcN;
    
    ResConsTimeP50=0;
    ResConsLocP50=0;
    
    ResConsTimePN50=0;
    ResConsLocPN50=0;
    
    ResBackToBaselineTime=0;
    
end
