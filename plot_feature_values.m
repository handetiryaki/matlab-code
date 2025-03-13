function plot_feature_values(fselectiontype, boundary, feature_count)
% params 
% feature selection type
% boundary(red coloured features)
% feature count (total), total-boundary=blue-coloured
load features;

if (fselectiontype==1)
    term_feature_list=term_feature_mi;
elseif (fselectiontype==2)
    term_feature_list=term_feature_gi;
elseif (fselectiontype==3)
    term_feature_list=term_feature_ig;
elseif (fselectiontype==4)
    term_feature_list=term_feature_chi2;
elseif (fselectiontype==6)
    term_feature_list=term_feature_phdnm_f2;
elseif (fselectiontype==7)
    term_feature_list=term_feature_phdnm_f1;
elseif (fselectiontype==9)
    term_feature_list=term_feature_gi_original;
end

y=zeros(1,boundary);
for i=1:boundary
    y(1,i)=term_feature_list(1,i).value;
end

plot(y,y,'*','LineWidth',0.1,...
                'MarkerEdgeColor','r',...
                'MarkerFaceColor','r',...
                'MarkerSize',3);
hold on;
            
y=zeros(1,feature_count-boundary);
for i=boundary:feature_count
    y(1,i)=term_feature_list(1,i).value;
end

plot(y,y,'*','LineWidth',0.1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',3);
end