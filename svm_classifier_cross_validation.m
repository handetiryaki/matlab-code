function [ z ] = svm_classifier_cross_validation(dataset_type,tokenization_type,feature_selection_method,usespecialfeatures,usestopwordremoval,uselowercase,usestemming,hastfidfweighting,feature_size,currentpart,crossvaltotal)
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here


% Dataset types
DATASET_REUTERS = 1;
DATASET_MILLIYET = 2;
DATASET_NEWS10 = 3;
DATASET_NEWS20 = 4;
DATASET_SPAMSMSTR = 5;
DATASET_REUTERS_PARTIAL = 6;
DATASET_WEBKB = 9;
DATASET_ENRON1 = 10;
DATASET_BRITISHENGLISHSPAMSMS = 11;
DATASET_SPAMEMAILTR = 12;
DATASET_ENRON1_PARTIAL = 13;
DATASET_CLASSIC3 = 14;
DATASET_OHSUMED_SINGLELABEL_VERSION = 17;
DATASET_MEDLINETR_ENGABSTRACT_SINGLELABEL_VERSION = 18;
DATASET_MININEWS20 = 19;

if dataset_type==DATASET_REUTERS
    resfoldername='experiments_with_reuters_21578';
elseif dataset_type==DATASET_MILLIYET
    resfoldername='experiments_with_milliyet_collection';
elseif dataset_type==DATASET_SPAMSMSTR
    resfoldername='experiments_with_spamsmstr';
elseif dataset_type==DATASET_REUTERS_PARTIAL
    resfoldername='experiments_with_reuters_partial';
elseif dataset_type==DATASET_WEBKB
    resfoldername='experiments_with_webkb';
elseif dataset_type==DATASET_BRITISHENGLISHSPAMSMS
    resfoldername='experiments_with_britishenglishspamsms';
elseif dataset_type==DATASET_SPAMEMAILTR
    resfoldername='experiments_with_spamemailtr';
elseif dataset_type==DATASET_ENRON1_PARTIAL
    resfoldername='experiments_with_spamemailenronpartial';
elseif dataset_type==DATASET_CLASSIC3
    resfoldername='experiments_with_classic3';
elseif dataset_type==DATASET_NEWS10
    resfoldername='experiments_with_news10';
elseif dataset_type==DATASET_NEWS20
    resfoldername='experiments_with_news20';
elseif dataset_type==DATASET_MININEWS20
    resfoldername='experiments_with_mininews20';
elseif dataset_type==DATASET_OHSUMED_SINGLELABEL_VERSION
    resfoldername='experiments_with_ohsumed_singlelabel';
elseif dataset_type==DATASET_MEDLINETR_ENGABSTRACT_SINGLELABEL_VERSION
    resfoldername='experiments_with_medlinetr_engabstract_singlelabel';   
elseif dataset_type==DATASET_ENRON1
    resfoldername='experiments_with_enron1';       
end

destination_fpath=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\',resfoldername,'\');
eval(['load ', strcat(destination_fpath,'train_matrix.mat'), '  train_matrix topic_matrix'])
eval(['load ', strcat(destination_fpath,'test_matrix.mat'), '  test_matrix topic_matrix_for_test'])
eval(['load ', strcat(destination_fpath,'dataset_class_idx.mat'), '  dataset_class_idx'])
eval(['load ', strcat(destination_fpath,'term_feature.mat'), '  term_feature'])

disp('testing phase started');


% %feature ratio kullanýldýðý durum için
% load features term_feature_chi2_original;
% feature_size=length(term_feature_chi2_original)*(feature_size/100);
% feature_size=floor(feature_size);

len=length(train_matrix(1,:));
term_feature=term_feature(:,1:feature_size);

if (usespecialfeatures==0)
    train_matrix=train_matrix(:,1:feature_size);
    test_matrix=test_matrix(:,1:feature_size);    
elseif (usespecialfeatures==1)
    train_matrix=[train_matrix(:,1:feature_size),train_matrix(:,len)];
    test_matrix=[test_matrix(:,1:feature_size),test_matrix(:,len)];
    feature_size=feature_size+1;
elseif (usespecialfeatures==2)
    train_matrix=[train_matrix(:,1:feature_size),train_matrix(:,len)];
    test_matrix=[test_matrix(:,1:feature_size),test_matrix(:,len)];
    feature_size=feature_size+1;
elseif (usespecialfeatures==3)
    train_matrix=[train_matrix(:,1:feature_size),train_matrix(:,len)]; 
    test_matrix=[test_matrix(:,1:feature_size),test_matrix(:,len)];
    feature_size=feature_size+1;
elseif (usespecialfeatures==4)
    train_matrix=[train_matrix(:,1:feature_size),train_matrix(:,len)]; 
    test_matrix=[test_matrix(:,1:feature_size),test_matrix(:,len)];
    feature_size=feature_size+1;
elseif (usespecialfeatures==5)
    train_matrix=[train_matrix(:,1:feature_size),train_matrix(:,len)];
    test_matrix=[test_matrix(:,1:feature_size),test_matrix(:,len)];
    feature_size=feature_size+1;
elseif (usespecialfeatures==6)
    train_matrix=[train_matrix(:,1:feature_size),train_matrix(:,len)];     
    test_matrix=[test_matrix(:,1:feature_size),test_matrix(:,len)]; 
    feature_size=feature_size+1;
elseif (usespecialfeatures==7)
    train_matrix=[train_matrix(:,1:feature_size),train_matrix(:,len-5:len)];    
    test_matrix=[test_matrix(:,1:feature_size),test_matrix(:,len-5:len)]; 
    feature_size=feature_size+6;
elseif (usespecialfeatures==8)%feature size for revision(BOW+SF1+SF2+SF3)
    train_matrix=[train_matrix(:,1:feature_size),train_matrix(:,len-2:len)];    
    test_matrix=[test_matrix(:,1:feature_size),test_matrix(:,len-2:len)]; 
    feature_size=feature_size+3;     
end


%LIBSVM Matlab Wrapper for 64 bit matlab
model=svmtrain(topic_matrix,train_matrix,'-t 0');
[predicted_labels, ~, ~] = svmpredict(topic_matrix_for_test, test_matrix, model);
predicted_labels = predicted_labels';

% %LIBLINEAR SVM Matlab Wrapper for 64 bit matlab
% train_matrix = sparse(train_matrix);
% test_matrix = sparse(test_matrix);
% model = train(topic_matrix, train_matrix, '-s 1');
% [predicted_labels, ~, ~] = predict(topic_matrix_for_test, test_matrix, model);
% predicted_labels = predicted_labels';


num_true_classifications=0;
num_false_classifications=0;
confusion_matrix=zeros(length(dataset_class_idx),length(dataset_class_idx));
lentest=length(test_matrix(:,1));

for i=1:lentest
    indice_of_maximum=predicted_labels(1,i);
    
    if (indice_of_maximum==topic_matrix_for_test(i,1))
        num_true_classifications=num_true_classifications+1;
        confusion_matrix(indice_of_maximum,indice_of_maximum)=confusion_matrix(indice_of_maximum,indice_of_maximum)+1;
    else
        num_false_classifications=num_false_classifications+1;
        confusion_matrix(topic_matrix_for_test(i,1),indice_of_maximum)=confusion_matrix(topic_matrix_for_test(i,1),indice_of_maximum)+1;
    end            
end




%--------------------------------------------------------------------
% Compute Micro-F1
%--------------------------------------------------------------------
 
% Compute overall true positive
tp_value = sum(diag(confusion_matrix));
 
% Compute overall false positive
fp_value = 0;

NUM_CLASS=length(dataset_class_idx);
 
for class=1:NUM_CLASS
 
   % Get index of classes except current one
   class_idx = [1:NUM_CLASS];
   class_idx(class) = [];
 
   fp_value = fp_value + sum(confusion_matrix(class_idx, class));
 
end
 
% Compute overall false negative
fn_value = 0;

for class=1:NUM_CLASS
 
   % Get index of classes except current one
   class_idx = [1:NUM_CLASS];
   class_idx(class) = [];
 
   fn_value = fn_value + sum(confusion_matrix(class, class_idx));
 
end
 
% Compute precision
p_value = tp_value / (tp_value + fp_value);
 
% Compute recall
r_value = tp_value / (tp_value + fn_value);
 
% Compute Micro-F1
micro_F1 = 100 * (2 * p_value * r_value) / (p_value + r_value);


%--------------------------------------------------------------------
% Compute Macro-F1
%--------------------------------------------------------------------
 
% Init
F1_measures = [];
 
for class=1:NUM_CLASS
 
    % Get class index except current one
    class_idx = [1:NUM_CLASS];
    class_idx(class) = [];
 
    % Compute true positive
    tp_value = confusion_matrix(class, class);
 
    % Compute false positive
    fp_value = sum(confusion_matrix(class_idx, class));
 
    % Compute false negative
    fn_value = sum(confusion_matrix(class, class_idx));
 
    % Compute precision
    p_value = tp_value / (tp_value + fp_value);
 
    % Compute recall
    r_value = tp_value / (tp_value + fn_value);
 
    % Compute current F1 measure
    curr_F1 = 100 * (2 * p_value * r_value) / (p_value + r_value);
    if isnan(curr_F1)
        curr_F1 = 0;
    end
 
    F1_measures = [F1_measures curr_F1];
 
end
 
macro_F1 = mean(F1_measures);
 

%precision and recall calculation end




finalresults=[num2str(crossvaltotal)  num2str(currentpart) '_' 'final_results' '_' num2str(dataset_type) '_' num2str(hastfidfweighting) '_' num2str(usespecialfeatures) '_' num2str(tokenization_type) '_' num2str(usestopwordremoval) num2str(uselowercase) num2str(usestemming) '_' num2str(feature_size)];
finalmatrix=[num2str(crossvaltotal)  num2str(currentpart) '_' 'final_matrix' '_' num2str(dataset_type) '_' num2str(hastfidfweighting) '_' num2str(usespecialfeatures) '_' num2str(tokenization_type) '_' num2str(usestopwordremoval) num2str(uselowercase) num2str(usestemming) '_' num2str(feature_size)];

filename = [finalresults 'statistics' '.txt'];

finalresults = [finalresults '.mat']; 
finalmatrix = [finalmatrix '.mat']; 


if dataset_type==DATASET_REUTERS
    resfoldername='experiments_with_reuters_21578';
    finalresults=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\reutersexperiments\',finalresults);
    finalmatrix=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\reutersexperiments\',finalmatrix);
    filename=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\reutersexperiments\',filename);
elseif dataset_type==DATASET_MILLIYET
    resfoldername='experiments_with_milliyet_collection';
    finalresults=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\milliyetexperiments\',finalresults);
    finalmatrix=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\milliyetexperiments\',finalmatrix);
    filename=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\milliyetexperiments\',filename);
elseif dataset_type==DATASET_SPAMSMSTR
    resfoldername='experiments_with_spamsmstr';
    finalresults=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\spamsmstrexperiments\',finalresults);
    finalmatrix=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\spamsmstrexperiments\',finalmatrix);
    filename=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\spamsmstrexperiments\',filename);
elseif dataset_type==DATASET_REUTERS_PARTIAL
    resfoldername='experiments_with_reuters_partial';
    finalresults=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\reuterspartialexperiments\',finalresults);
    finalmatrix=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\reuterspartialexperiments\',finalmatrix);
    filename=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\reuterspartialexperiments\',filename);
elseif dataset_type==DATASET_WEBKB
    resfoldername='experiments_with_webkb';
    finalresults=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\webkbexperiments\',finalresults);
    finalmatrix=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\webkbexperiments\',finalmatrix);
    filename=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\webkbexperiments\',filename);    
elseif dataset_type==DATASET_BRITISHENGLISHSPAMSMS
    resfoldername='experiments_with_britishenglishspamsms';
    finalresults=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\britishenglishspamsmsexperiments\',finalresults);
    finalmatrix=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\britishenglishspamsmsexperiments\',finalmatrix);
    filename=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\britishenglishspamsmsexperiments\',filename); 
elseif dataset_type==DATASET_SPAMEMAILTR
    resfoldername='experiments_with_spamemailtr';
    finalresults=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\spamemailtrexperiments\',finalresults);
    finalmatrix=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\spamemailtrexperiments\',finalmatrix);
    filename=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\spamemailtrexperiments\',filename);  
elseif dataset_type==DATASET_ENRON1_PARTIAL
    resfoldername='experiments_with_spamemailenronpartial';
    finalresults=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\spamemailenronpartialexperiments\',finalresults);
    finalmatrix=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\spamemailenronpartialexperiments\',finalmatrix);
    filename=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\spamemailenronpartialexperiments\',filename);
elseif dataset_type==DATASET_CLASSIC3
    resfoldername='experiments_with_classic3';
    finalresults=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\classic3experiments\',finalresults);
    finalmatrix=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\classic3experiments\',finalmatrix);
    filename=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\classic3experiments\',filename);
elseif dataset_type==DATASET_NEWS10
    resfoldername='experiments_with_news10';
    finalresults=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\news10experiments\',finalresults);
    finalmatrix=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\news10experiments\',finalmatrix);
    filename=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\news10experiments\',filename);    
elseif dataset_type==DATASET_NEWS20
    resfoldername='experiments_with_news20';
    finalresults=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\news20experiments\',finalresults);
    finalmatrix=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\news20experiments\',finalmatrix);
    filename=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\news20experiments\',filename);
elseif dataset_type==DATASET_MININEWS20
    resfoldername='experiments_with_mininews20';
    finalresults=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\mininews20experiments\',finalresults);
    finalmatrix=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\mininews20experiments\',finalmatrix);
    filename=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\mininews20experiments\',filename);  
elseif dataset_type==DATASET_OHSUMED_SINGLELABEL_VERSION
    resfoldername='experiments_with_ohsumed_singlelabel';
    finalresults=strcat('ohsumed_singlelabelexperiments\',finalresults);
    finalmatrix=strcat('ohsumed_singlelabelexperiments\',finalmatrix);
    filename=strcat('ohsumed_singlelabelexperiments\',filename);
elseif dataset_type==DATASET_MEDLINETR_ENGABSTRACT_SINGLELABEL_VERSION
    resfoldername='experiments_with_medlinetr_engabstract_singlelabel';
    finalresults=strcat('medlinetr_engabstract_singlelabelexperiments\',finalresults);
    finalmatrix=strcat('medlinetr_engabstract_singlelabelexperiments\',finalmatrix);
    filename=strcat('medlinetr_engabstract_singlelabelexperiments\',filename);    
elseif dataset_type==DATASET_ENRON1
    resfoldername='experiments_with_enron1';
    finalresults=strcat('enron1experiments\',finalresults);
    finalmatrix=strcat('enron1experiments\',finalmatrix);
    filename=strcat('enron1experiments\',filename);        
end

fid_stat = fopen(filename, 'w');

accuracy=num_true_classifications/(num_true_classifications+num_false_classifications);


%save finalresults num_true_classifications num_false_classifications
%accuracy confusion_matrix predicted_labels;
%save finalmatrix train_matrix test_matrix term_feature;

eval(['save ', finalresults, '  num_true_classifications num_false_classifications accuracy confusion_matrix predicted_labels'])
eval(['save ', finalmatrix, '  train_matrix test_matrix term_feature'])

if (tokenization_type==0)
    token='alphanumeric';
else
    token='alpha';
end



% File header
fprintf(fid_stat, '======================================================\r\n');
fprintf(fid_stat, 'TEXT DATASET STATS\r\n');
fprintf(fid_stat, '======================================================\r\n');

fprintf(fid_stat,'Specialfeatures:%d \r\n Tokenizer:%s \r\n Feature Selection Method:%s \r\n Stopwordremoval:%d \r\n Lowercase:%d \r\n Stemming:%d \r\n FSize:%d \r\n TClassification:%d \r\n FClassification:%d \r\n MicroF1:%6.3f \r\n MacroF1:%6.3f \r\n',usespecialfeatures,token,num2str(feature_selection_method),usestopwordremoval,uselowercase,usestemming,feature_size,num_true_classifications,num_false_classifications,micro_F1,macro_F1);


fprintf(fid_stat, '\r\nCONFUSION MATRIX\r\n');
fprintf(fid_stat, '------------------------------------------------------\r\n\r\n');

for idx=1:NUM_CLASS
    for idy=1:NUM_CLASS
        fprintf(fid_stat, '%d\t', confusion_matrix(idx,idy));
    end
    fprintf(fid_stat, '\r\n');
end

fprintf(fid_stat, '\r\nFEATURE LIST TERMS\r\n');

for idx=1:length(term_feature)    
    fprintf(fid_stat, '%s \t ', char(term_feature(1,idx)));
    if mod(idx,10)==0
        fprintf(fid_stat, '\r\n');
    end
end

fclose(fid_stat);


if (hastfidfweighting==1)
    result_fpath=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\',resfoldername,'\',num2str(crossvaltotal),num2str(currentpart),'svmres_with_tfidf.txt');
else
    result_fpath=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\',resfoldername,'\',num2str(crossvaltotal),num2str(currentpart),'svmres_without_tfidf.txt');
end




fresid = fopen(result_fpath, 'a');
%fprintf(fresid,'%d %d %d %d %d %d %d %d %d %d %6.3f %6.3f\t \n',dataset_type, tokenization_type, feature_selection_method, usespecialfeatures, usestopwordremoval,uselowercase,usestemming,feature_size,num_true_classifications,num_false_classifications,micro_F1,macro_F1);
fprintf(fresid,'%d %d %d %d %d %d %d %d %d %d %6.3f %6.3f',dataset_type, tokenization_type, feature_selection_method, usespecialfeatures, usestopwordremoval,uselowercase,usestemming,feature_size,num_true_classifications,num_false_classifications,micro_F1,macro_F1);


fprintf(fresid,'\n');




fclose(fresid);

destination_fpath=strcat('D:\googledriveakuysal\academic\kod\docentlik_baslica_eser_tc\',resfoldername,'\','overall_result_table.mat');
eval(['save ', destination_fpath, '  micro_F1 p_value r_value macro_F1'])



end