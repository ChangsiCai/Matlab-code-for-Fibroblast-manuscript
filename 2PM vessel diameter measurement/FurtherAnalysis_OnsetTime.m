close all;
global BaseLineFrameNo FrameTime myTimeTicks STITimeTicks;


%
presetcolor='rbgykcm';
Vesselno=0;
ResOnsetTimeAll=[];   % Dilation onset time
ResOnsetLocAll=[]; 
ResMaxLocAll=[];    % Dilation max location within 20s of STI
PuffPeak1Time=[];
PuffPeak1Loc=[];
PuffPeak2Time=[];
PuffPeak2Loc=[];
LegendName=[];


%
mainpath='E:\Data\Fiona Data\20150713\Results\F20';
cd(mainpath);
DataNameList=cellstr(ls);

% set the path of result folder
% if exist('@Results\Ca_Activities','dir')==0
%     mkdir('Results\Ca_Activities');
% end

hd1=figure(1);
hold on;
set(gca,'FontSize',15);

fileindex=strncmpi(DataNameList,'AllFormWaves',length('AllFormWaves'));
for i=1:length(fileindex)
    if fileindex(i)
        load(DataNameList{i});
        
        % get the real name of the vessel
        VesselName=DataNameList{i};
        VesselName(end-3:end)=[];
        VesselName(1:length('AllFormWaves_'))=[];
        
        % prepare for analyze
        FrameTime=myTimeTicks(2)-myTimeTicks(1);
        Vesselno=Vesselno+1;
        
        % prepare for the legend
        if Vesselno==1
            LegendName=[char(39),VesselName,char(39)];
        else
            LegendName=[LegendName,',',char(39),VesselName,char(39)];
        end
        
        % count the BaselineframeNo
        if STIExist==1
            BaseLineFrameNo=fix(STITimeTicks(1)/FrameTime)-1;
        elseif PuffExist==1
            BaseLineFrameNo=fix(PuffStartTime/FrameTime)-1;
        end
        
        % calculate the onset
        VesselDiam1=Norm1;
        VesselDiam1 = VesselDiam1./mean(VesselDiam1(2:BaseLineFrameNo));
        mymax=max(VesselDiam1(BaseLineFrameNo+1:BaseLineFrameNo+round(20/FrameTime)));
        VesselDiam1(2:end)=smooth(VesselDiam1(2:end),5);
        [ResStTime ResStLoc]=ResponseStartTime10P(VesselDiam1);
        
        if length(STITimeTicks)
            ResOnsetTimeAll=[ResOnsetTimeAll ResStTime-STITimeTicks(1)];
            ResOnsetLocAll=[ResOnsetLocAll ResStLoc];
            ResMaxLocAll=[ResMaxLocAll mymax];
        end
        
       % plot
       figure(1)
       plot(myTimeTicks(2:end),VesselDiam1(2:end),presetcolor(Vesselno),'LineWidth',2);  
               
        
    end
end
eval(['legend(',LegendName,',',char(39),'Location',char(39),',',char(39),'SouthEast',char(39),')']);
xlabel('\fontsize{18}Time(s)');
ylabel('\fontsize{19}Fluorescent Intensity');

% plot the onset time point
if length(STITimeTicks)
    Vesselno=0;
    myylim=ylim;
    mylim=myylim(2)-myylim(1);
    for i=1:length(fileindex)
        if fileindex(i)
            Vesselno=Vesselno+1;
            line([ResOnsetTimeAll(Vesselno)+STITimeTicks(1) ResOnsetTimeAll(Vesselno)+STITimeTicks(1)],[ResOnsetLocAll(Vesselno)-0.1*mylim ResOnsetLocAll(Vesselno)+0.1*mylim],'Color',presetcolor(Vesselno),'LineWidth',2);
        
            t4mark=round(ResOnsetTimeAll(Vesselno)*100)/100;
            text(ResOnsetTimeAll(Vesselno)+STITimeTicks(1),ResOnsetLocAll(Vesselno)-0.1*mylim,[num2str(t4mark),'s'],'color',presetcolor(Vesselno));
        
        end
    end
end

% plot STI
mylim=get(gca,'ylim');
STITicksLoc=[mylim(2)-0.03*(mylim(2)-mylim(1)) mylim(2)];
if length(STITimeTicks)>=1
    for i=1:length(STITimeTicks)
        line([STITimeTicks(i) STITimeTicks(i)],STITicksLoc,'Color','k');
    end
    line([STITimeTicks(1) STITimeTicks(1)],mylim,'Color','k','LineStyle','--');
end

% plot puff
mylim=get(gca,'ylim');
if PuffExist==1
    myX=[PuffStartTime PuffStartTime PuffEndTime PuffEndTime];
    myY=[mylim(1) mylim(2) mylim(2) mylim(1)];
    p=patch(myX,myY,'m');
    set(p,'FaceAlpha',0.5);   
end

% save
saveas(hd1,'OnsetDetect20P','fig');
saveas(hd1,'OnsetDetect20P','jpg');

save('FurtherAnalysis_OnsetPeak','ResOnsetTimeAll','ResMaxLocAll','PuffPeak1Time','PuffPeak1Loc','PuffPeak2Time','PuffPeak2Loc');

LegendName
ResOnsetTimeAll
ResMaxLocAll

