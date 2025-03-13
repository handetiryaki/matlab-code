function plot_class_membership(fselectiontype,boundary,classcount)
% params 
% feature selection type
% boundary(red coloured features)
% class count (total), total-boundary=blue-coloured
load term_list_pre;
load features;
load term_existence_map;

if (fselectiontype==1)
    term_feature_list=term_feature_mi;
elseif (fselectiontype==2)
    term_feature_list=term_feature_gi;
elseif (fselectiontype==3)
    term_feature_list=term_feature_ig;
elseif (fselectiontype==4)
    term_feature_list=term_feature_chi2;
elseif (fselectiontype==7)
    term_feature_list=term_feature_phdnm_f1;
end

y=zeros(boundary,classcount);
for i=1:boundary
    term=term_feature_list(1,i).term;
    
    for j=1:classcount
      term_and_class=char(strcat(strcat(term,'_'), int2str(j)));  
        if (isKey(term_existence_map,term_and_class)==1)
            term_index=term_existence_map(term_and_class);
            if (fselectiontype==1)
                y(i,j)= term_list_pre(term_index).MUTUAL_INFO;
            elseif (fselectiontype==2)
                y(i,j)= term_list_pre(term_index).GINI_INDEX;
            elseif (fselectiontype==3)
                y(i,j)= term_list_pre(term_index).IG;
            elseif (fselectiontype==4)
                y(i,j)= term_list_pre(term_index).CHI2;
            elseif (fselectiontype==7)
                y(i,j)= term_list_pre(term_index).PHD_NM_F1;
            end
        end
    end
end


for i=1:boundary
    max_of_raw=max(y(i,:));
    for j=1:classcount
        if (y(i,j)==max_of_raw)
            y(i,j)=1;
        else
            y(i,j)=0;
        end
    end
    
end

for j=1:classcount
    totalforclass=sum(y(:,j));
    disp(['The feature count of class ', num2str(j), ' is: ', num2str(totalforclass) ]);
end

figure;
imagesc(y)



end

