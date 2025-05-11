function NewStartPoint = findRealStartCaTrans(Time_all,Ca_all_smth,PreDefSP,Mymean, MyThld,WinSize)

% PreDefSP = I2_Ca(1);
% Mymean = bl_mean;
% MyThld = bl_mean + bl_std;
% WinSize = 5;   % at most 5 second to extend

MostWinSteps = fix(WinSize/(Time_all(3)-Time_all(2)));

PreDefSP_New = PreDefSP-MostWinSteps;
if PreDefSP_New<1
    PreDefSP_New = 1;
end

% figure;hold on;
% plot(Time_all(PreDefSP_New:PreDefSP_New+20*20),Ca_all_smth(PreDefSP_New:PreDefSP_New+20*20),'b');
% mxlim = xlim;
% plot(xlim,Mymean.*ones(size(xlim)),'k-');
% plot(xlim,MyThld.*ones(size(xlim)),'k--');

CountBackStartP = PreDefSP;
while CountBackStartP>PreDefSP_New && Ca_all_smth(CountBackStartP)>MyThld  
    CountBackStartP = CountBackStartP-1;
    if Ca_all_smth(CountBackStartP)>Ca_all_smth(CountBackStartP+1)
        break;
    end
end

% plot(Time_all(CountBackStartP:PreDefSP_New+20*20),Ca_all_smth(CountBackStartP:PreDefSP_New+20*20),'g');

NewStartPoint = CountBackStartP;
