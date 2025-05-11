function [rho,pval,slope,hd00] = plotFittedLine5(fig_hd,subplot_hd1,subplot_hd2,subplot_hd3,X_dots,Y_dots,mycolor,legendloc)

figure(fig_hd);hold on;
subplot(subplot_hd1,subplot_hd2,subplot_hd3);hold on;

ExaminedXaxis = X_dots;     Xisnan = isnan(ExaminedXaxis);
ExaminedYaxis = Y_dots;     Yisnan = isnan(ExaminedYaxis);
XYisnan = Xisnan | Yisnan;
ExaminedXaxis(XYisnan)=[];   ExaminedYaxis(XYisnan)=[];
[rho,pval]=corr(ExaminedXaxis.',ExaminedYaxis.'); rho = round(rho*100)/100;
Coef = polyfit(ExaminedXaxis,ExaminedYaxis,1);
fitted_y = polyval(Coef, ExaminedXaxis);
slope = Coef(1);


if pval<=0.05
    hd00=plot(ExaminedXaxis,fitted_y,'LineStyle','-','Color','k');
else
    hd00=plot(ExaminedXaxis,fitted_y,'LineStyle','-','Color','r'); 
    slope = NaN;
end

% if strcmp(legendloc,'right')
%     [maxc,maxi]=max(ExaminedXaxis);
%     text(maxc,fitted_y(maxi),['R=',num2str(rho)],'Color',mycolor);
% elseif strcmp(legendloc,'left')
%     [minc,mini]=min(ExaminedXaxis);
%     mylim=ylim;
%     myrg = abs(mylim(2)-mylim(1));
%     text(minc,fitted_y(mini)+myrg/20,['R=',num2str(rho)],'Color',mycolor);
% end



