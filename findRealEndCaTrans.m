function NewEndPoint = findRealEndCaTrans(Time_all,Ca_all_smth,PreDefEP,Mymean, MyThld,WinSize)
% 
% PreDefEP = I2_Ca(end);
% Mymean = bl_mean;
% MyThld = bl_mean + bl_std;
% WinSize = 5;   % at most 5 second to extend

MostWinSteps = fix(WinSize/(Time_all(3)-Time_all(2)));

PreDefEP_New = PreDefEP+MostWinSteps;
if PreDefEP_New>length(Time_all)
    PreDefEP_New = length(Time_all);
end

% figure;hold on;
% plot(Time_all(PreDefEP_New-20*20:PreDefEP_New),Ca_all_smth(PreDefEP_New-20*20:PreDefEP_New),'b');
% mxlim = xlim;
% plot(xlim,Mymean.*ones(size(xlim)),'k-');
% plot(xlim,MyThld.*ones(size(xlim)),'k--');

CountBackEndP = PreDefEP;
while CountBackEndP<PreDefEP_New && Ca_all_smth(CountBackEndP)>MyThld      
    CountBackEndP = CountBackEndP+1;
    if Ca_all_smth(CountBackEndP)>Ca_all_smth(CountBackEndP-1)
        break;
    end
end

% plot(Time_all(PreDefEP_New-20*20:CountBackEndP),Ca_all_smth(PreDefEP_New-20*20:CountBackEndP),'g');

NewEndPoint = CountBackEndP;