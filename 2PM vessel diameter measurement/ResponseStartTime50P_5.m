function [ResStTime50, ResStLoc50, ResPeakTime, ResPeakLoc, ResConsTimePN50, ResConsLocPN50, ResConsTimeP50, ResConsLocP50, ResNegPeakTime, ResNegPeakLoc, ResBackToBaselineTime, AUCLast1min]=ResponseStartTime50P_5(mywave)
% This function is to detect the start time of response after STI
% after start of STI, if wave is larger than 10% of (peak-baseline)


global BaseLineFrameNo FrameTime myTimeTicks STITimeTicks CutFrameNum1 CutFrameNum2;
% baseline properties
bl=mywave(CutFrameNum1:BaseLineFrameNo);   
blmean=mean(bl);
blstd=std(bl);

TimeRangeP=40;    % positive peak is detected in no later than 20s after stimulation
TimeRangeN=180;   % negative peak is detected in no later than 100s after stimulation
DiamChangeThrld=0.01;




% peak property
[peakc,peaki]=max(mywave(BaseLineFrameNo+1:BaseLineFrameNo+round(TimeRangeP/FrameTime*1000)));
[peakcN,peakiN]=min(mywave(BaseLineFrameNo+round(TimeRangeP/FrameTime*1000):min([BaseLineFrameNo+round(TimeRangeN/FrameTime*1000),length(mywave)])));


% onset property
Onset50P=0.5*(peakc-blmean);
Fall50PN=peakc-1-0.5*(peakc-peakcN);


% interpolation
if length(STITimeTicks)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Onset rising phase
    TimeWindow=myTimeTicks(find(myTimeTicks>=STITimeTicks(1) & myTimeTicks<=STITimeTicks(1)+TimeRangeP));  % if 90s after the STI, there's still no response, then the vascular response do not exist
    mywaveInterpX=linspace(TimeWindow(1),TimeWindow(end),1000);    
    mywaveInterpY=interp1(TimeWindow,mywave(find(myTimeTicks>=STITimeTicks(1) & myTimeTicks<=STITimeTicks(1)+TimeRangeP)),mywaveInterpX);
    
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
    NewCutTime2FN=min([BaseLineFrameNo+round(TimeRangeN/FrameTime*1000),length(mywave)]);
    TimeWindow2=myTimeTicks(NewCutTime1FN:NewCutTime2FN);  
    mywaveInterpX=linspace(myTimeTicks(NewCutTime1FN),myTimeTicks(NewCutTime2FN),1000);    
    mywaveInterpY=interp1(TimeWindow2,mywave(NewCutTime1FN:NewCutTime2FN),mywaveInterpX);
    
    [tNC,tNI]=min(mywaveInterpY);
    ResNegPeakTime=mywaveInterpX(tNI);
    ResNegPeakLoc=tNC;
    
    %%%% This is for pure 0.5 falling phase without undershoot
    stallN=find(mywaveInterpY<=1+Onset50P);
    if ~isempty(stallN) && mywaveInterpY(stallN(1))-1>=DiamChangeThrld && stallN(1)~=1
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
    if ~isempty(stallPN) && ResPeakLoc-min(mywaveInterpY)>=DiamChangeThrld && stallPN(1)~=1
        ResConsTimePN50=mywaveInterpX(stallPN(1));
        ResConsLocPN50=mywaveInterpY(stallPN(1));   
         
    else
        ResConsTimePN50=0;
        ResConsLocPN50=0;
    end
    
    
    % mean AUC in the last 1 min
    LastOneMin=fix(60/(myTimeTicks(2)-myTimeTicks(1)));
    AUCLast1min=mean(mywave(CutFrameNum2-LastOneMin:CutFrameNum2));     % unit: % per min
    
else
    ResStTime50=0;
    ResStLoc50=0;
    ResPeakTime=0;
    ResPeakLoc=0;
    
    ResNegPeakTime=0;
    ResNegPeakLoc=0;
    
    ResConsTimeP50=0;
    ResConsLocP50=0;
    
    ResConsTimePN50=0;
    ResConsLocPN50=0;
    
    ResBackToBaselineTime=0;
    
end
