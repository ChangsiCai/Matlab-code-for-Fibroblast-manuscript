function NewArray = SortPeakTime_lcmt(OldArray,ThisTimeTicks,StimTime)

% OldArray = PACaCurvesCut;
% StimTime = 40;
% ThisTimeTicks = DiamTime(I0);

I2 = find(ThisTimeTicks>StimTime & ThisTimeTicks<StimTime+10);
PeakTime = zeros(1,size(OldArray,1));
PeakAmp= zeros(1,size(OldArray,1));

for ii = 1:length(PeakTime)
    ThisCurve = OldArray(ii,I2);
    [C3,I4] = max(ThisCurve);
    PeakTime(ii) = I4;
    PeakAmp(ii) = C3;
end

[PeakTimeNew,I5] = sort(PeakTime,'descend');
NewArray = zeros(size(OldArray));
for ii = 1:length(PeakTimeNew)
    NewArray(ii,:) = OldArray(I5(ii),:);
end

% [PeakAmpNew,I5] = sort(PeakAmp,'ascend');
% NewArray = zeros(size(OldArray));
% for ii = 1:length(PeakAmpNew)
%     NewArray(ii,:) = OldArray(I5(ii),:);
% end






