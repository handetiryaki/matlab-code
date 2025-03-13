%param(datasettype)={6=reuterspartial,7=news3, 8=spamsmseng, 9=spamsmstr, 3=news10, 9=webkb, 10=enron1}
function [ z ] = classifier_script_expdata(dataset_type,isterm_extraction_done)

% param1(datasettype)
%-----------------------%
% DATASET_REUTERS = 1;
% DATASET_MILLIYET = 2;
% DATASET_NEWS10 = 3;
% DATASET_NEWS20 = 4;
% DATASET_SPAMSMSTR = 5;
% DATASET_REUTERS_PARTIAL = 6;
% DATASET_WEBKB = 9;
% DATASET_ENRON1 = 10;
% DATASET_BRITISHENGLISHSPAMSMS = 11;
% DATASET_SPAMEMAILTR = 12;
% DATASET_ENRON1_PARTIAL = 13;
% DATASET_CLASSIC3 = 14;
% DATASET_OHSUMED_SINGLELABEL_VERSION = 17;
% DATASET_MEDLINETR_ENGABSTRACT_SINGLELABEL_VERSION = 18;
% DATASET_MININEWS20 = 19;

% param2(isterm_extraction_done)
%-----------------------%
% isterm_extraction_done = 0 (skip feature extraction, features are already extracted)
% isterm_extraction_done = 1 (extract features)


% param(term_weighting_scheme)
%-----------------------%
% term_weighting_scheme=0 (BINARY)
% term_weighting_scheme=1 (TF)
% term_weighting_scheme=2 (TF-IDF)
% term_weighting_scheme=5 (TF-AMB_MEASURE)
% term_weighting_scheme=7 (TF-DFS)
% term_weighting_scheme=9 (TF-GI)
% term_weighting_scheme=10 (TF-IG)
% term_weighting_scheme=11 (TF-CHI2)
% term_weighting_scheme=12 (TF-POISSON)
% term_weighting_scheme=13 (TF-PROBABILITY BASED WEIGHT)
% term_weighting_scheme=14 (TF-RF)
% term_weighting_scheme=15 (LOG TF-RF)
% term_weighting_scheme=16 (TF-RR)

%term_weighting_scheme=[0 1 2 7 9 10 11 13];
term_weighting_scheme=[16];
%term_weighting_scheme=[7 9 10 11];


pr_fe_text_high_speed(dataset_type,1,isterm_extraction_done);%terms are already extracted

feature_count=[500 300 200 100 50 10];%feature similarity analysis

custom_precalculations;


for j=11:-1:11 % feature selection method
    for k=1:length(term_weighting_scheme)
            data_matrix_construction_expdata(term_weighting_scheme(k),feature_count(1),j,dataset_type,1);
            data_matrix_construction_expdata(term_weighting_scheme(k),feature_count(1),j,dataset_type,2);
            for i=1:length(feature_count)
                svm_classifier_expdata(term_weighting_scheme(k),feature_count(i),j,dataset_type);
                knn_classifier_expdata(term_weighting_scheme(k),feature_count(i),j,dataset_type);
                pnn_classifier_expdata(term_weighting_scheme(k),feature_count(i),j,dataset_type);
                dtree_classifier_expdata(term_weighting_scheme(k),feature_count(i),j,dataset_type);
                mv_naivebayes_classifier_expdata(term_weighting_scheme(k),feature_count(i),j,dataset_type);
            end       
    end
end


end