function PlotStatStars2(fig_hd,subplot_ind1,subplot_ind2,subplot_ind3,cmp1,cmp2,line_locX,line_locY,Pweight)

if ~isempty(cmp1) && ~isempty(cmp2)
    [h, p, ci, stats] = ttest2(cmp1, cmp2);
    p = p*Pweight;
    if p<=0.1
        figure(fig_hd);hold on;
        subplot(subplot_ind1,subplot_ind2,subplot_ind3);hold on;
        plot(line_locX,[line_locY line_locY],'k-');
        if p<0.001
            text(line_locX(1),line_locY,'***','Fontsize',16);
        elseif p<0.01 && p>=0.001
            text(line_locX(1),line_locY,'**','Fontsize',16);
        elseif p>=0.01 && p<=0.05
            text(line_locX(1),line_locY,'*','Fontsize',16);
        elseif p>0.05 && p<=0.1
            text(line_locX(1),line_locY,['p=',num2str(p)],'Fontsize',10);

        end
    end
end
