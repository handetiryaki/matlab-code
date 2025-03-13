function plot_fsmethod_comparison(reffselectiontype,rivalfselectiontype,boundary)
% params 
% feature selection type
% boundary(red coloured features)
% class count (total), total-boundary=blue-coloured
load term_list_pre;
load features;
load term_existence_map;

if (reffselectiontype==1)
    ref_feature_list=term_feature_mi;
elseif (reffselectiontype==2)
    ref_feature_list=term_feature_gi;
elseif (reffselectiontype==3)
    ref_feature_list=term_feature_ig;
elseif (reffselectiontype==4)
    ref_feature_list=term_feature_chi2;
elseif (reffselectiontype==5)
    ref_feature_list=term_feature_am_tf;
elseif (reffselectiontype==6)
    ref_feature_list=term_feature_phdnm_f2;
elseif (reffselectiontype==7)
    ref_feature_list=term_feature_phdnm_f1;
elseif (reffselectiontype==9)
    ref_feature_list=term_feature_gi_original;
elseif (reffselectiontype==10)
    ref_feature_list=term_feature_ig_original;
elseif (reffselectiontype==11)
    ref_feature_list=term_feature_chi2_original;
elseif (reffselectiontype==12)
    ref_feature_list=term_feature_poisson;
end

if (rivalfselectiontype==1)
    rival_feature_list=term_feature_mi;
elseif (rivalfselectiontype==2)
    rival_feature_list=term_feature_gi;
elseif (rivalfselectiontype==3)
    rival_feature_list=term_feature_ig;
elseif (rivalfselectiontype==4)
    rival_feature_list=term_feature_chi2;
elseif (rivalfselectiontype==5)
    rival_feature_list=term_feature_am_tf;
elseif (rivalfselectiontype==6)
    rival_feature_list=term_feature_phdnm_f2;
elseif (rivalfselectiontype==7)
    rival_feature_list=term_feature_phdnm_f1;
elseif (rivalfselectiontype==9)
    rival_feature_list=term_feature_gi_original;
elseif (rivalfselectiontype==10)
    rival_feature_list=term_feature_ig_original;
elseif (rivalfselectiontype==11)
    rival_feature_list=term_feature_chi2_original;
elseif (rivalfselectiontype==12)
    rival_feature_list=term_feature_poisson;
end


term_location_map=containers.Map();
lenterms=length(rival_feature_list);

for i=1:lenterms
    term_location_map(rival_feature_list(1,i).term)=i;
end


y=zeros(boundary,2);
counter=0;

for i=1:boundary
    y(i,1)=i;
    y(i,2)=0;
    for j=1:boundary
        if (strcmp(ref_feature_list(1,i).term,rival_feature_list(1,j).term)==1)
            y(i,2)=j;
        end
    end
    if (y(i,2)==0)
       index=term_location_map(ref_feature_list(1,i).term);
       score=rival_feature_list(1,index).value;
       disp(['Feature ', num2str(i), ': ', ref_feature_list(1,i).term, ' _index: ', num2str(index), ' _score: ', num2str(score)]);
       counter=counter+1;

    end
end

disp(['Not selected feature count = ', num2str(counter) ]);


imagesc(y);

end