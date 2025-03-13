function custom_precalculations()

%term feature matrices are constructed by using term_list_pre matrix
%maximum feature selection values of each term are selected and
%saved as 7 ordered matrices in features.mat file
tic
load dataset_class_idx;
load term_list_pre;

term_feature_am_tf   = struct('term', {},'value', {});
term_feature_dfs = struct('term', {},'value', {});
term_feature_phdnm_f2 = struct('term', {},'value', {});
term_feature_gi   = struct('term', {},'value', {});
term_feature_ig   = struct('term', {},'value', {});
term_feature_chi2   = struct('term', {},'value', {});
term_feature_mi   = struct('term', {},'value', {});
term_feature_df   = struct('term', {},'value', {});
term_feature_gi_original   = struct('term', {},'value', {});
term_feature_ig_original   = struct('term', {},'value', {});
term_feature_chi2_original   = struct('term', {},'value', {});
term_feature_poisson   = struct('term', {},'value', {});
term_feature_pbweighting   = struct('term', {},'value', {});
term_feature_tfrf   = struct('term', {},'value', {});
term_feature_tfrr   = struct('term', {},'value', {});


doc_freq_of_terms   = struct('term', {},'value', {});

term_list=repmat(cellstr(''), 1,length(term_list_pre));

for i=1:length(term_list_pre)
    term_list(1,i)=cellstr(term_list_pre(i).NAME);
end

%sort matrices according to alphabetic order
[~, order] = sort(term_list(1,:));
new_term_list_pre_namesorted = term_list_pre(order);


counter=1;
termcounter=1;
lengthterms=length(term_list_pre);

tempterm=new_term_list_pre_namesorted(1,1).NAME;
term_feature_am_tf(1,1).value=0;
term_feature_dfs(1,1).value=0;
term_feature_phdnm_f2(1,1).value=0;
term_feature_gi(1,1).value=0;
term_feature_ig(1,1).value=0;
term_feature_chi2(1,1).value=0;
term_feature_mi(1,1).value=0;
term_feature_df(1,1).value=0;
doc_freq_of_terms(1,1).value=0;
term_feature_gi_original(1,1).value=0;
term_feature_ig_original(1,1).value=0;
term_feature_chi2_original(1,1).value=0;
term_feature_poisson(1,1).value=0;
term_feature_pbweighting(1,1).value=0;
term_feature_tfrf(1,1).value=0;
term_feature_tfrr(1,1).value=0;

%control=0;

%iterate over all terms,
%get unique terms and maximum their corresponding maximum values in new_term_list_pre_namesorted matrix 
while counter<=lengthterms
    %get unique term names
    term_feature_am_tf(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_dfs(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_phdnm_f2(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_gi(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_ig(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_chi2(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_mi(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_df(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    doc_freq_of_terms(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_gi_original(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_ig_original(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_chi2_original(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_poisson(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_pbweighting(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_tfrf(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    term_feature_tfrr(termcounter).term=new_term_list_pre_namesorted(1,counter).NAME;
    

    
    if (isnan(new_term_list_pre_namesorted(1,counter).TF_RR) || isinf(new_term_list_pre_namesorted(1,counter).TF_RR))
        temp_tfrr_weight=0;
    else
        temp_tfrr_weight=new_term_list_pre_namesorted(1,counter).TF_RR;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).PB_TERM_WEIGHT) || isinf(new_term_list_pre_namesorted(1,counter).PB_TERM_WEIGHT))
        temp_pb_weight=0;
    else
        temp_pb_weight=new_term_list_pre_namesorted(1,counter).PB_TERM_WEIGHT;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).TF_RF) || isinf(new_term_list_pre_namesorted(1,counter).TF_RF))
        temp_tfrf_weight=0;
    else
        temp_tfrf_weight=new_term_list_pre_namesorted(1,counter).TF_RF;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).PHD_NM_F2) || isinf(new_term_list_pre_namesorted(1,counter).PHD_NM_F2))
        temp_phdnm_f2=0;
    else
        temp_phdnm_f2=new_term_list_pre_namesorted(1,counter).PHD_NM_F2;
    end
    
    %use a temp_gini_index for comparisons, it is first occurrence value
    %for a term
    %replace its value if next values of a term are bigger than temp_gini_index
    
    if (isnan(new_term_list_pre_namesorted(1,counter).IG))
        temp_ig=0;
    else
        temp_ig=new_term_list_pre_namesorted(1,counter).IG;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).IG_FOR_TERM) || isinf(new_term_list_pre_namesorted(1,counter).IG_FOR_TERM))
        temp_igoriginal=0;
    else
        temp_igoriginal=new_term_list_pre_namesorted(1,counter).IG_FOR_TERM;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).CHI2) || isinf(new_term_list_pre_namesorted(1,counter).CHI2))
        temp_chi2=0;
    else
        temp_chi2=new_term_list_pre_namesorted(1,counter).CHI2;
    end
    
    if (isnan(new_term_list_pre_namesorted(1,counter).POISSON) || isinf(new_term_list_pre_namesorted(1,counter).POISSON))
        temp_poisson=0;
    else
        temp_poisson=new_term_list_pre_namesorted(1,counter).POISSON;
    end
    
    
    if (isnan(new_term_list_pre_namesorted(1,counter).MUTUAL_INFO))
        temp_mi=0;
    else
        temp_mi=new_term_list_pre_namesorted(1,counter).MUTUAL_INFO;
    end
        
    
    if (isnan(new_term_list_pre_namesorted(1,counter).DF) || isinf(new_term_list_pre_namesorted(1,counter).DF))
        temp_df=0;
    else
        temp_df=new_term_list_pre_namesorted(1,counter).DF;
    end
    
    
    %en buyugu 
    if (term_feature_tfrr(termcounter).value<temp_tfrr_weight)
        term_feature_tfrr(termcounter).value=temp_tfrr_weight;
    end
    
    %en buyugu 
    if (term_feature_tfrf(termcounter).value<temp_tfrf_weight)
        term_feature_tfrf(termcounter).value=temp_tfrf_weight;
    end
    
    %en buyugu 
    if (term_feature_pbweighting(termcounter).value<temp_pb_weight)
        term_feature_pbweighting(termcounter).value=temp_pb_weight;
    end
    
    if (term_feature_am_tf(termcounter).value<new_term_list_pre_namesorted(1,counter).AM_TF)
        term_feature_am_tf(termcounter).value=new_term_list_pre_namesorted(1,counter).AM_TF;
    end
    
    
% en buyugu    
%     if (term_feature_dfs(termcounter).value<new_term_list_pre_namesorted(1,counter).DFS)
%         term_feature_dfs(termcounter).value=new_term_list_pre_namesorted(1,counter).DFS;
%     end
 

% weighted average toplami
    %term_feature_dfs(termcounter).value=term_feature_dfs(termcounter).value+(dataset_class_idx(new_term_list_pre_namesorted(1,counter).CLASS)/sum(dataset_class_idx))*new_term_list_pre_namesorted(1,counter).DFS;
    

%normal toplam
    term_feature_dfs(termcounter).value=term_feature_dfs(termcounter).value+new_term_list_pre_namesorted(1,counter).DFS;
    %control=control+new_term_list_pre_namesorted(1,counter).DF;
    

% en buyugu 
%     if (term_feature_phdnm_f2(termcounter).value<temp_phdnm_f2)
%         term_feature_phdnm_f2(termcounter).value=temp_phdnm_f2;
%     end
  

%normal toplam    
term_feature_phdnm_f2(termcounter).value=term_feature_phdnm_f2(termcounter).value+temp_phdnm_f2;

% weighted average toplami
%term_feature_phdnm_f2(termcounter).value=term_feature_phdnm_f2(termcounter).value+(dataset_class_idx(new_term_list_pre_namesorted(1,counter).CLASS)/sum(dataset_class_idx))*temp_phdnm_f2;

    
    

    if (term_feature_gi(termcounter).value<new_term_list_pre_namesorted(1,counter).GINI_INDEX)
        term_feature_gi(termcounter).value=new_term_list_pre_namesorted(1,counter).GINI_INDEX;
    end
    
    if (term_feature_ig(termcounter).value<temp_ig)
        term_feature_ig(termcounter).value=temp_ig;
    end
    
    if (term_feature_chi2(termcounter).value<temp_chi2)
        term_feature_chi2(termcounter).value=temp_chi2;
    end
    
    if (term_feature_mi(termcounter).value<temp_mi)
        term_feature_mi(termcounter).value=temp_mi;
    end
    
    if (term_feature_df(termcounter).value<temp_df)
        term_feature_df(termcounter).value=temp_df;
    end
    
    
    term_feature_gi_original(termcounter).value=term_feature_gi_original(termcounter).value+new_term_list_pre_namesorted(1,counter).GINI_INDEX_FOR_TERM;
    term_feature_ig_original(termcounter).value=term_feature_ig_original(termcounter).value+temp_igoriginal;
    
    classprob=dataset_class_idx(1,new_term_list_pre_namesorted(1,counter).CLASS)/sum(dataset_class_idx);
    term_feature_chi2_original(termcounter).value=term_feature_chi2_original(termcounter).value+(classprob*temp_chi2);
    term_feature_poisson(termcounter).value=term_feature_poisson(termcounter).value+(classprob*temp_poisson);            



    
    doc_freq_of_terms(termcounter).value=doc_freq_of_terms(termcounter).value+new_term_list_pre_namesorted(1,counter).APPEARANCE;   
    
    
    %increase termcounter if reoccurring elements are finished and assign
    %next term as current
    if counter<lengthterms
        if strcmp(tempterm,new_term_list_pre_namesorted(1,counter+1).NAME)~=1
            %to eliminate terms occuring all documents
%             if (control==sum(dataset_class_idx))
%                 term_feature_dfs(1,termcounter).value=0;
%             end
%             control=0;
            
            termcounter=termcounter+1;
            tempterm=new_term_list_pre_namesorted(1,counter+1).NAME;
            term_feature_am_tf(1,termcounter).value=0;
            term_feature_dfs(1,termcounter).value=0;
            term_feature_phdnm_f2(1,termcounter).value=0;
            term_feature_gi(1,termcounter).value=0;
            term_feature_ig(1,termcounter).value=0;
            term_feature_mi(1,termcounter).value=0;
            term_feature_chi2(1,termcounter).value=0;
            term_feature_df(1,termcounter).value=0;
            doc_freq_of_terms(1,termcounter).value=0;
            term_feature_gi_original(1,termcounter).value=0;
            term_feature_ig_original(1,termcounter).value=0;
            term_feature_chi2_original(1,termcounter).value=0;
            term_feature_poisson(1,termcounter).value=0;
            term_feature_pbweighting(1,termcounter).value=0;
            term_feature_tfrf(1,termcounter).value=0;
            term_feature_tfrr(1,termcounter).value=0;


        end
    end
    %increase 
    counter=counter+1;

end




%sort unique terms according to their value, dfs
lenterms=length(term_feature_dfs);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_dfs(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_dfs = term_feature_dfs(orderidx);


%sort unique terms according to their value, phd novel method formula 2
lenterms=length(term_feature_phdnm_f2);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_phdnm_f2(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_phdnm_f2 = term_feature_phdnm_f2(orderidx);


%sort unique terms according to their value, gini index

lenterms=length(term_feature_gi);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_gi(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_gi = term_feature_gi(orderidx);


%sort unique terms according to their value, information gain
lenterms=length(term_feature_ig);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    if (isnan(term_feature_ig(1,i).value))
        tmptermvalues(1,i)=0;
    else
        tmptermvalues(1,i)=term_feature_ig(1,i).value;
    end
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_ig = term_feature_ig(orderidx);


%sort unique terms according to their value, mutual information
lenterms=length(term_feature_mi);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_mi(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_mi = term_feature_mi(orderidx);


%sort unique terms according to their value, chi square

tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_chi2(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_chi2 = term_feature_chi2(orderidx);


%sort unique terms according to their value, ambiguity measure tf
lenterms=length(term_feature_am_tf);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_am_tf(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_am_tf = term_feature_am_tf(orderidx);

%sort unique terms according to their value, document frequency
%check for null df values and make them zero
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    if (isnan(term_feature_df(1,i).value) || isinf(term_feature_df(1,i).value))
        tmptermvalues(1,i)=0;
    else
        tmptermvalues(1,i)=term_feature_df(1,i).value;
    end
end

[dummy, orderidx] = sort(tmptermvalues,'descend');
term_feature_df = term_feature_df(orderidx);



%sort unique terms according to original gini index formula
lenterms=length(term_feature_gi_original);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_gi_original(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_gi_original = term_feature_gi_original(orderidx);


%sort unique terms according to original information gain formula
lenterms=length(term_feature_ig_original);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_ig_original(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_ig_original = term_feature_ig_original(orderidx);


%sort unique terms according to original chi square formula
lenterms=length(term_feature_chi2_original);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_chi2_original(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_chi2_original = term_feature_chi2_original(orderidx);

%sort unique terms according to probability based weighting formula
lenterms=length(term_feature_pbweighting);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_pbweighting(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_pbweighting = term_feature_pbweighting(orderidx);


%sort unique terms according to tfrf weighting formula
lenterms=length(term_feature_tfrf);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_tfrf(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_tfrf = term_feature_tfrf(orderidx);

%sort unique terms according to tfrr weighting formula
lenterms=length(term_feature_tfrr);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_tfrr(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_tfrr = term_feature_tfrr(orderidx);

%sort unique terms according to original chi square formula
lenterms=length(term_feature_chi2_original);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_chi2_original(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_chi2_original = term_feature_chi2_original(orderidx);


%sort unique terms according to poisson formula
lenterms=length(term_feature_poisson);
tmptermvalues=zeros(1,lenterms);
for i=1:lenterms
    tmptermvalues(1,i)=term_feature_poisson(1,i).value;
end

[~, orderidx] = sort(tmptermvalues,'descend');
term_feature_poisson = term_feature_poisson(orderidx);


document_frequency_map=containers.Map();

for i=1:lenterms
    document_frequency_map(doc_freq_of_terms(1,i).term)=doc_freq_of_terms(1,i).value;
end


% features are already sorted by multiple feature selection methods
% save index values of features into a map

term_feature_dfs_map = containers.Map();
term_feature_gi_original_map = containers.Map();
term_feature_ig_original_map = containers.Map();
term_feature_chi2_original_map = containers.Map();
term_feature_poisson_map = containers.Map();
term_feature_pbweighting_map = containers.Map();
term_feature_tfrf_map = containers.Map();
term_feature_tfrr_map = containers.Map();


for i=1:lenterms
    term_feature_dfs_map(term_feature_dfs(i).term)=i;
    term_feature_gi_original_map(term_feature_gi_original(i).term)=i;
    term_feature_ig_original_map(term_feature_ig_original(i).term)=i;
    term_feature_chi2_original_map(term_feature_chi2_original(i).term)=i;
    term_feature_poisson_map(term_feature_poisson(i).term)=i;
    term_feature_pbweighting_map(term_feature_pbweighting(i).term)=i;
    term_feature_tfrf_map(term_feature_tfrf(i).term)=i;
    term_feature_tfrr_map(term_feature_tfrr(i).term)=i;

end

save weighting_index_maps term_feature_dfs_map term_feature_gi_original_map term_feature_ig_original_map term_feature_chi2_original_map term_feature_poisson_map term_feature_pbweighting_map term_feature_tfrf_map term_feature_tfrr_map;

save features term_feature_am_tf term_feature_dfs term_feature_phdnm_f2 term_feature_gi term_feature_ig term_feature_mi term_feature_chi2 term_feature_df term_feature_gi_original term_feature_ig_original term_feature_chi2_original term_feature_poisson term_feature_pbweighting term_feature_tfrf term_feature_tfrr

save document_frequencies doc_freq_of_terms document_frequency_map



toc
end