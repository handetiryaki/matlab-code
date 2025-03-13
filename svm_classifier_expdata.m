function [ z ] = svm_classifier_expdata(hastfidfweighting,feature_size,feature_selection_method,dataset_type)
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here

load train_matrix train_matrix topic_matrix;
load test_matrix test_matrix topic_matrix_for_test;
load dataset_class_idx dataset_class_idx;
load term_feature term_feature;
disp('testing phase started');

train_matrix=train_matrix(:,1:feature_size);
test_matrix=test_matrix(:,1:feature_size);
term_feature=term_feature(:,1:feature_size);


%LIBSVM Matlab Wrapper for 64 bit matlab
model=svmtrain(topic_matrix,train_matrix,'-t 0');
[predicted_labels, ~, ~] = svmpredict(topic_matrix_for_test, test_matrix, model);
predicted_labels = predicted_labels';


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



finalresults=['final_results' '_' num2str(dataset_type) '_' num2str(feature_selection_method) '_' num2str(hastfidfweighting) '_' num2str(length(term_feature))];
finalmatrix=['final_matrix' '_' num2str(dataset_type) '_' num2str(feature_selection_method) '_' num2str(hastfidfweighting) '_' num2str(length(term_feature))];

filename = [finalresults 'statistics' '.txt'];

finalresults = [finalresults '.mat']; 
finalmatrix = [finalmatrix '.mat']; 


if dataset_type==1
    resfoldername='experiments_with_reuters_21578';
    finalresults=strcat('reutersexperiments\',finalresults);
    finalmatrix=strcat('reutersexperiments\',finalmatrix);
    filename=strcat('reutersexperiments\',filename);
elseif dataset_type==2
    resfoldername='experiments_with_milliyet_collection';
    finalresults=strcat('milliyetexperiments\',finalresults);
    finalmatrix=strcat('milliyetexperiments\',finalmatrix);
    filename=strcat('milliyetexperiments\',filename);
elseif dataset_type==3
    resfoldername='experiments_with_news10';
    finalresults=strcat('news10experiments\',finalresults);
    finalmatrix=strcat('news10experiments\',finalmatrix);
    filename=strcat('news10experiments\',filename);
elseif dataset_type==4
    resfoldername='experiments_with_news20';
    finalresults=strcat('news20experiments\',finalresults);
    finalmatrix=strcat('news20experiments\',finalmatrix);
    filename=strcat('news20experiments\',filename);
elseif dataset_type==5
    resfoldername='experiments_with_spamsmstr';
    finalresults=strcat('spamsmstrexperiments\',finalresults);
    finalmatrix=strcat('spamsmstrexperiments\',finalmatrix);
    filename=strcat('spamsmstrexperiments\',filename);
elseif dataset_type==6
    resfoldername='experiments_with_reuters_21578_partial';
    finalresults=strcat('reuterspartialexperiments\',finalresults);
    finalmatrix=strcat('reuterspartialexperiments\',finalmatrix);
    filename=strcat('reuterspartialexperiments\',filename);
elseif dataset_type==7
    resfoldername='experiments_with_news3';
    finalresults=strcat('news3experiments\',finalresults);
    finalmatrix=strcat('news3experiments\',finalmatrix);
    filename=strcat('news3experiments\',filename);
elseif dataset_type==8
    resfoldername='experiments_with_spamsmsen';
    finalresults=strcat('spamsmsenexperiments\',finalresults);
    finalmatrix=strcat('spamsmsenexperiments\',finalmatrix);
    filename=strcat('spamsmsenexperiments\',filename);
elseif dataset_type==9
    resfoldername='experiments_with_webkb';
    finalresults=strcat('webkbexperiments\',finalresults);
    finalmatrix=strcat('webkbexperiments\',finalmatrix);
    filename=strcat('webkbexperiments\',filename);
elseif dataset_type==10
    resfoldername='experiments_with_enron1';
    finalresults=strcat('enron1experiments\',finalresults);
    finalmatrix=strcat('enron1experiments\',finalmatrix);
    filename=strcat('enron1experiments\',filename);
end

fid_stat = fopen(filename, 'w');

accuracy=num_true_classifications/(num_true_classifications+num_false_classifications);
%save finalresults num_true_classifications num_false_classifications accuracy confusion_matrix predicted_labels;


%save finalmatrix train_matrix test_matrix term_feature;

eval(['save ', finalresults, '  num_true_classifications num_false_classifications accuracy confusion_matrix predicted_labels'])
eval(['save ', finalmatrix, '  train_matrix test_matrix term_feature'])


% File header
fprintf(fid_stat, '======================================================\r\n');
fprintf(fid_stat, 'TEXT DATASET STATS\r\n');
fprintf(fid_stat, '======================================================\r\n');

fprintf(fid_stat,'FSMethod:%d \r\n FCount:%d \r\n FSize:%d \r\n TClassification:%d \r\n FClassification:%d \r\n MicroF1:%6.3f \r\n MacroF1:%6.3f\r\n',feature_selection_method,length(term_feature),feature_size,num_true_classifications,num_false_classifications,micro_F1,macro_F1);

fprintf(fid_stat, '\r\nCONFUSION MATRIX\r\n');
fprintf(fid_stat, '------------------------------------------------------\r\n\r\n');

for idx=1:NUM_CLASS
    for idy=1:NUM_CLASS
        fprintf(fid_stat, '%d\t', confusion_matrix(idy,idx));
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


result_fpath=strcat('D:\googledriveakuysal\academic\kod\term_weighting_experiments\',resfoldername,'\svmres.txt');


fresid = fopen(result_fpath, 'a');
fprintf(fresid,'%d %d %d %d %d %d %6.3f %6.3f\n',hastfidfweighting,feature_selection_method,length(term_feature),feature_size,num_true_classifications,num_false_classifications,micro_F1,macro_F1);
fclose(fresid);

end