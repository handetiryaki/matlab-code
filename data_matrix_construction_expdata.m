function [ z ] = data_matrix_construction_expdata(term_weighting_scheme,feature_size,feature_selection_method,dataset_type,train_set)
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here
tic;


global dataset_class_idx;
global stopword_list_map;
global term_feature_map;
global document_frequency_map;

%load document_frequencies document_frequency_map;
load dataset_class_idx;
load term_list_pre;



document_frequency_map=containers.Map();

lenterms=length(term_list_pre);

for i=1:lenterms
    if isKey(document_frequency_map,term_list_pre(1,i).NAME)==1
        document_frequency_map(term_list_pre(1,i).NAME)=document_frequency_map(term_list_pre(1,i).NAME)+term_list_pre(1,i).DF;
    else
        document_frequency_map(term_list_pre(1,i).NAME)=term_list_pre(1,i).DF;
    end
end
save document_frequency_map document_frequency_map;

if train_set==1
        if (feature_selection_method==1)%mutual information
            load features term_feature_mi
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_mi(1,i).term);
            end
        elseif (feature_selection_method==2)%gini index
            load features term_feature_gi
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_gi(1,i).term);
            end    
        elseif (feature_selection_method==3)%information gain
            load features term_feature_ig
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_ig(1,i).term);
            end
        elseif (feature_selection_method==4)%chi 2
            load features term_feature_chi2
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_chi2(1,i).term);                
            end
        elseif (feature_selection_method==5)%amguity tf
            load features term_feature_am_tf
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_am_tf(1,i).term);                
            end
        elseif (feature_selection_method==6)%phd novel metric formula 2
            load features term_feature_phdnm_f2
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_phdnm_f2(1,i).term);                
            end 
        elseif (feature_selection_method==7)%DFS
            load features term_feature_dfs
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_dfs(1,i).term);                
            end     
        elseif (feature_selection_method==8)%document frequency
            load features term_feature_df
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_df(1,i).term);                
            end 
        elseif (feature_selection_method==9)%gini index original formula
            load features term_feature_gi_original
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_gi_original(1,i).term);                
            end
         elseif (feature_selection_method==10)%information gain original formula
            load features term_feature_ig_original
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_ig_original(1,i).term);                
            end
         elseif (feature_selection_method==11)%chi2 average formula
            load features term_feature_chi2_original
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_chi2_original(1,i).term);                
            end
         elseif (feature_selection_method==12)%poisson distribution
            load features term_feature_poisson
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_poisson(1,i).term);                
            end
         elseif (feature_selection_method==13)%probability based weighting scores
            load features term_feature_pbweighting
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_pbweighting(1,i).term);                
            end            
         elseif (feature_selection_method==14)%TF-RF weighting scores
            load features term_feature_tfrf
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_tfrf(1,i).term);                
            end               
         elseif (feature_selection_method==15)%LOG TF-RF weighting scores
            load features term_feature_tfrf
            term_feature=repmat(cellstr(''), 1,feature_size);

            for i=1:feature_size
                term_feature(1,i)=cellstr(term_feature_tfrf(1,i).term);                
            end                 
         end
    save term_feature term_feature
else
    load term_feature
end


%global
term_feature_map = containers.Map();

for i=1:length(term_feature)
    term_feature_map(char(term_feature(1,i)))=i;
end


% Dataset types
DATASET_REUTERS = 1;
DATASET_MILLIYET = 2;
DATASET_NEWS10 = 3;
DATASET_NEWS20 = 4;
DATASET_SPAMSMSTR = 5;
DATASET_REUTERS_PARTIAL = 6;
DATASET_NEWS3=7;
DATASET_SPAMSMSENG = 8;
DATASET_WEBKB = 9;
DATASET_ENRON1 = 10;

% Initializations
topic_cnt = 0;


if dataset_type == DATASET_REUTERS || dataset_type == DATASET_REUTERS_PARTIAL %DATASET_REUTERS
    
    dataset_topics = {'earn', 'acq', 'money-fx', 'grain', 'crude', 'trade', 'interest', 'ship', 'wheat', 'corn'};
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
   % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter','a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'particular', 'particularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    
    if (dataset_type==DATASET_REUTERS)
        filecount=22;
    else
        filecount=6;
    end
    for cnt=1:filecount
        
        % Filename setup
        file_name = int2str(cnt-1);
        
        if (length(file_name) == 1)
            zero_pad = '00';
        elseif (length(file_name) == 2)
            zero_pad = '0';
        end
        
        file_name = [zero_pad file_name];
        
        if (dataset_type==DATASET_REUTERS)
            fpath=['D:\DATASETS\TEXT\ENGLISH\REUTERS-21578\reut2-' file_name '.sgm'];
        else
            fpath=['D:\datasets\text\experimentaldata\multiclass\reuters-21578-partial-1\reut2-' file_name '.sgm'];
        end
        fid = fopen(fpath, 'r');
        
        % Initial state
        op_state = 1;
        
        while 1
            curr_line = fgets(fid);
            
            % If EOF is encountered, finish process
            if curr_line < 0
                break
            end
            
            % -----------------------------------------------------------------
            % Find ModApte split
            % -----------------------------------------------------------------
            switch (op_state)
                case 1

                    % If file header is encountered for ModApte split, proceed to next state
                    if train_set == 1
                        res = strfind(curr_line, '<REUTERS TOPICS="YES" LEWISSPLIT="TRAIN"');
                    elseif train_set == 2
                        res = strfind(curr_line, '<REUTERS TOPICS="YES" LEWISSPLIT="TEST"');
                    end
                    
                    if ~isempty(res)
                        op_state = 2;
                    end
                    
                case 2
                    
                    % If topic header is encountered, find topic type.
                    res = strfind(curr_line, '<TOPICS>');
                    
                    if ~isempty(res)
                        
                        % Set next operation state
                        op_state = 1;
                        
                        % Initially no topic is found
                        topic_found = 0;
                        
                        % Get topic line
                        topic_line = curr_line;
                        
                        % -----------------------------------------------------------------
                        % If current topic is in the dataset, start feature extraction
                        % -----------------------------------------------------------------
                        for topic_idx=1:length(dataset_topics)
                            
                            curr_topic = ['<D>' char(dataset_topics(topic_idx)) '</D>'];
                            
                            if ~isempty(strfind(topic_line, curr_topic))
                                
                                % Set current class
                                curr_class = topic_idx;
                                
                                % Display topic count for tracking
                                topic_cnt = topic_cnt + 1;
                                if (mod(topic_cnt, 10) == 0)
                                    disp(topic_cnt);
                                end
                                
                                % Extract text if it is not done previously
                                if topic_found == 0
                                    
                                    % Topic is found
                                    topic_found = 1;
                                    
                                    % Look for header to find start of the text
                                    while 1
                                        tmp_line = fgets(fid);
                                        res = strfind(tmp_line, '<TEXT');
                                        if ~isempty(res)
                                            break;
                                        end
                                    end
                                    
                                    % Extract text until BODY footer is found
                                    curr_text = tmp_line;
                                    
                                    while 1
                                        tmp_line = fgets(fid);
                                        curr_text = [curr_text tmp_line];
                                        
                                        res = strfind(tmp_line, '</TEXT>');
                                        
                                        if ~isempty(res)
                                            % Remove header and footer from the text
                                            idx1 = strfind(curr_text, '<TEXT');
                                            idx2 = strfind(curr_text, '</TEXT>');
                                            curr_text = curr_text(idx1+6:idx2);
                                            break;
                                        end
                                    end
                                    
                                end
                                
                                % -----------------------------------------------------------------
                                % Process current text
                                % -----------------------------------------------------------------
                                
                                
                                result=process_curr_text(curr_text,term_feature);
                                if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                                        train_matrix=[train_matrix;result];
                                        topic_matrix=[topic_matrix;curr_class];                                                             
                                else%prepare test matrix within test documents
                                        test_matrix=[test_matrix;result];
                                        topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
                                end
                                
                            end
                        end
                    end
            end
        end
        
        % Close file
        fclose(fid);
        
    end

elseif dataset_type == DATASET_WEBKB %DATASET_WEBKB
    
    dataset_topics = {'course', 'faculty', 'project', 'student'};
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
   % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'particular', 'particularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    
    
    
    
     if train_set==1
            folder_name='train.txt';
        else
            folder_name='test.txt';
        end
        
        fpath=['D:\datasets\text\english\webkb_train_test\' folder_name];                                                                
        
        fid = fopen(fpath, 'r');
        
        while 1
            curr_line = fgets(fid);
            
            % If EOF is encountered, finish process
            if curr_line < 0
                break
            end
            
            for curr_class=1:length(dataset_topics)
                startindex=findstr(curr_line,char(dataset_topics(1,curr_class)));
                if (~isnan(startindex))
                    if (startindex(1,1)==1)
                        curr_line=curr_line(1,length(char(dataset_topics(1,curr_class)))+1:length(curr_line));
                        break;
                    end
                end
            end
            
            curr_text = curr_line;
            
            result=process_curr_text(curr_text,term_feature);
            
            if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                    train_matrix=[train_matrix;result];
                    topic_matrix=[topic_matrix;curr_class];                                                             
            else%prepare test matrix within test documents
                    test_matrix=[test_matrix;result];
                    topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
            end


            
            
        end
        
                    % Close file
            fclose(fid);              
    
    
elseif dataset_type == DATASET_ENRON1
    
    
    dataset_topics = {'spam', 'ham'};
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
   % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'particular', 'particularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    
    
    train_set_ratio=2/3;

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['D:\datasets\text\english\enron1\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        % Define start/stop index
        if train_set == 1
            start_idx = 1;          
            stop_idx=floor(num_files*train_set_ratio);           
        elseif train_set == 2
            start_idx = floor(num_files*train_set_ratio)+1;
            stop_idx = num_files;
        end
        
        % Start processing files
        for idx=start_idx:stop_idx

            % Display topic count for tracking
            topic_cnt = topic_cnt + 1;
            if (mod(topic_cnt, 10) == 0)
                disp(topic_cnt);
            end
            
            % Open current file
            file_path = [class_path '\' dir_data(idx + 2).name];
            curr_fid = fopen(file_path, 'r');
          
            
            curr_text='';
            while 1
                curr_line = fgets(curr_fid);
            
                % If EOF is encountered, finish process
                if curr_line < 0
                    break
                end
            
                curr_text = [curr_text curr_line];
            end
                        
            fclose(curr_fid);
            
            result=process_curr_text(curr_text,term_feature);
            
            if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                    train_matrix=[train_matrix;result];
                    topic_matrix=[topic_matrix;curr_class];                                                             
            else%prepare test matrix within test documents
                    test_matrix=[test_matrix;result];
                    topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
            end
            
        end
        
    end        
                                
    
elseif dataset_type == DATASET_NEWS10 || dataset_type == DATASET_NEWS20 || dataset_type == DATASET_NEWS3
    
    if dataset_type == DATASET_NEWS3
        dataset_topics = {'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x'};
    elseif dataset_type == DATASET_NEWS10
        dataset_topics = {'alt.atheism', 'comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x', 'misc.forsale', 'rec.autos', 'rec.motorcycles', 'rec.sport.baseball'};
    elseif dataset_type == DATASET_NEWS20
        dataset_topics = {'alt.atheism', 'comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x', 'misc.forsale', 'rec.autos', 'rec.motorcycles', 'rec.sport.baseball', 'rec.sport.hockey', 'sci.crypt', 'sci.electronics', 'sci.med', 'sci.space', 'soc.religion.christian', 'talk.politics.guns', 'talk.politics.mideast', 'talk.politics.misc', 'talk.religion.misc'};
    end
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    
   % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'particular', 'particularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

    for curr_class=1:length(dataset_topics)
    
        % Set pathname for directory of current class
        class_path = ['D:\DATASETS\TEXT\ENGLISH\NEWS20\ORG\' char(dataset_topics(curr_class))];
        dir_data = dir(class_path);

        % Find number of files in directory of current class
        num_files = length(dir_data) - 2;
        
        % Define start/stop index
        if train_set == 1
            start_idx = 1;
            stop_idx = 500;
        elseif train_set == 2
            start_idx = 501;
            stop_idx = num_files;
        end
        
        % Start processing files
        for idx=start_idx:stop_idx

            % Display topic count for tracking
            topic_cnt = topic_cnt + 1;
            if (mod(topic_cnt, 10) == 0)
                disp(topic_cnt);
            end
            
            % Open current file
            file_path = [class_path '\' dir_data(idx + 2).name];
            curr_fid = fopen(file_path, 'r');

            % Init current text
            curr_text = [];
            
            while 1
                curr_line = fgets(curr_fid);
                
                % If EOF is encountered, finish process and close file
                if curr_line < 0
                    fclose(curr_fid);
                    break;
                end
                
                % Add current line to curr_text
                curr_text = [curr_text curr_line];
                
            end
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------


            result=process_curr_text(curr_text,term_feature);
            if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                    train_matrix=[train_matrix;result];
                    topic_matrix=[topic_matrix;curr_class];                                                             
            else%prepare test matrix within test documents
                    test_matrix=[test_matrix;result];
                    topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
            end
            
            % Increment feature count for current class.
            %dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
            
        end
        
    end
    
    elseif dataset_type == DATASET_SPAMSMSENG %SPAM SMS ENGLISH
      
    topic_matrix=[];
    train_matrix=[];
        
    topic_matrix_for_test=[];
    test_matrix=[];
    

    
        if train_set==1
            file_name='train';
        else
            file_name='test';
        end
        
        fpath=['D:\datasets\text\english\spamsms\spamsms30_70percent\' file_name '.txt'];
        fid = fopen(fpath, 'r');
        
        
        while 1
            curr_line = fgets(fid);
            
            % If EOF is encountered, finish process
            if curr_line < 0
                break
            end
            
            res = strfind(curr_line, 'spam');
            
            if ~isempty(res)
                curr_class=1;
                modifiedStr = strrep(curr_line, 'spam', '');
            else
                curr_class=2;
                modifiedStr = strrep(curr_line, 'ham', '');

            end
            
            curr_text=char(modifiedStr);
            
            result=process_curr_text(curr_text, term_feature);
            
            if (train_set==1)%prepare training matrix l*p l=sample size, p=feature dimension size
                   train_matrix=[train_matrix;result];
                   topic_matrix=[topic_matrix;curr_class];                                                             
            else%prepare test matrix within test documents
                   test_matrix=[test_matrix;result];
                   topic_matrix_for_test=[topic_matrix_for_test;curr_class];                                    
            end
            

        end
        % Close file
        fclose(fid);              
        
       
   
end

    train_matrix_without_weighting=train_matrix;
    
    load weighting_index_maps term_feature_dfs_map term_feature_gi_original_map term_feature_ig_original_map term_feature_chi2_original_map term_feature_poisson_map term_feature_pbweighting_map term_feature_tfrf_map term_feature_tfrr_map;

    
    load  dataset_class_idx;
    if (term_weighting_scheme==0)%BINARY WEIGHTING 
       if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                tempvalue=document_frequency_map(char(tempterm));

                for v=1:lenv
                    if (train_matrix(v,h)>0)
                        train_matrix(v,h)=1;
                    else
                        train_matrix(v,h)=0;
                    end
                    train_matrix(v,h)=train_matrix(v,h);
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                tempvalue=document_frequency_map(char(tempterm));

                for v=1:lenv
                    if (test_matrix(v,h)>0)
                        test_matrix(v,h)=1;
                    else
                        test_matrix(v,h)=0;
                    end
                    test_matrix(v,h)=test_matrix(v,h);
                end
            end            
       end
    elseif(term_weighting_scheme==1)%TF WEIGHTING (ALREADY TF WEIGHTED)
        disp('TF WEIGHTED');
        %Continue            
    elseif(term_weighting_scheme==2)%TF-IDF WEIGHTING        
        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                tempvalue=document_frequency_map(char(tempterm));

                for v=1:lenv
                    train_matrix(v,h)=train_matrix(v,h)*log10(sum(dataset_class_idx)/tempvalue);
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                tempvalue=document_frequency_map(char(tempterm));

                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*log10(sum(dataset_class_idx)/tempvalue);
                end
            end            
        end
        
        elseif(term_weighting_scheme==7)%TF-DFS WEIGHTING
            load features term_feature_dfs;
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dfs_map(char(tempterm));
                

                for v=1:lenv
                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_dfs(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_dfs_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_dfs(1,feature_index).value;
                end
            end            
        end
        
      elseif(term_weighting_scheme==9)%TF-GI WEIGHTING
            load features term_feature_gi_original;
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_gi_original_map(char(tempterm));
                

                for v=1:lenv                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_gi_original(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_gi_original_map(char(tempterm));

                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_gi_original(1,feature_index).value;
                end
            end            
        end
        
        
      elseif(term_weighting_scheme==10)%TF-IG WEIGHTING
            load features term_feature_ig_original;
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ig_original_map(char(tempterm));
                
                for v=1:lenv                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_ig_original(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_ig_original_map(char(tempterm));


                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_ig_original(1,feature_index).value;
                end
            end            
        end
        
        
      elseif(term_weighting_scheme==11)%TF-CHI2 WEIGHTING
            load features term_feature_chi2_original;
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_chi2_original_map(char(tempterm));
                

                for v=1:lenv                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_chi2_original(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_chi2_original_map(char(tempterm));
                

                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_chi2_original(1,feature_index).value;
                end
            end            
        end        
        
      elseif(term_weighting_scheme==13)%TF-PB based WEIGHTING
            load features term_feature_pbweighting;
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_pbweighting_map(char(tempterm));
                

                for v=1:lenv                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_pbweighting(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_pbweighting_map(char(tempterm));
                

                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_pbweighting(1,feature_index).value;
                end
            end            
        end        
        
      elseif(term_weighting_scheme==14)%TF-RF based WEIGHTING
            load features term_feature_tfrf;
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_tfrf_map(char(tempterm));
                

                for v=1:lenv                    
                    train_matrix(v,h)=train_matrix(v,h)*term_feature_tfrf(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_tfrf_map(char(tempterm));
                

                for v=1:lenv
                    test_matrix(v,h)=test_matrix(v,h)*term_feature_tfrf(1,feature_index).value;
                end
            end            
        end     
        
      elseif(term_weighting_scheme==15)%LOG TF-RF based WEIGHTING
            load features term_feature_tfrf;
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_tfrf_map(char(tempterm));
                

                for v=1:lenv                    
                    train_matrix(v,h)=log2(1+train_matrix(v,h))*term_feature_tfrf(1,feature_index).value;
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_tfrf_map(char(tempterm));
                

                for v=1:lenv
                    test_matrix(v,h)=log2(1+test_matrix(v,h))*term_feature_tfrf(1,feature_index).value;
                end
            end            
        end        
        
        
elseif(term_weighting_scheme==16)%LOG TF-RR based WEIGHTING
            load features term_feature_tfrr;
            

        if (train_set==1)
            lenv=length(train_matrix(:,1));
            lenh=length(train_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_tfrr_map(char(tempterm));
                

                for v=1:lenv
                    if (train_matrix(v,h)>0)
                        train_matrix(v,h)=(log2(train_matrix(v,h)) + 1)*term_feature_tfrr(1,feature_index).value;
                    end
                end
            end
            
        else% if in the test phase
            lenv=length(test_matrix(:,1));
            lenh=length(test_matrix(1,:));

            for h=1:lenh

                tempterm=term_feature(1,h);
                feature_index=term_feature_tfrr_map(char(tempterm));
                

                for v=1:lenv
                    if (test_matrix(v,h)>0)
                        test_matrix(v,h)=(log2(test_matrix(v,h)) + 1)*term_feature_tfrr(1,feature_index).value;
                    end
                end
            end            
        end         
        
        
    end
                       
    
    if train_set==1
        disp('train data construction finished');
        save train_matrix train_matrix topic_matrix train_matrix_without_weighting;
    else
        disp('test data construction finished');
        save test_matrix test_matrix topic_matrix_for_test;
    end
    
end





%===================================================================
% Process Current English Text
%===================================================================
function z=process_curr_text(curr_text,term_feature)

% Globals
global stopword_list_map;
global term_feature_map;

result=zeros(1,length(term_feature));

% Stopword list
%stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter', 'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'particular', 'particularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'};

% Make all text lowercase
curr_text = lower(curr_text);

% Get decimal format of current text
dec_curr_text = abs(curr_text);

% Convert all irregular chars to space
curr_text(dec_curr_text < 65 | (dec_curr_text > 90 & dec_curr_text < 97) | dec_curr_text > 122) = 32;

% Extract words from current text
word_list = strread(curr_text, '%s');


for ind=1:length(word_list)
    
    % -----------------------------------------------------------------
    % Get current word
    % -----------------------------------------------------------------
    
    curr_word = word_list(ind);
    
    % -----------------------------------------------------------------
    % Stopword list elimination
    % -----------------------------------------------------------------
    
    is_stopword = 0;
    
%     for cnt=1:length(stopword_list)
%         if (strcmp(stopword_list(cnt), curr_word) == 1)
%             is_stopword = 1;
%             break;
%         end
%     end
    
    if isKey(stopword_list_map,curr_word)==1
        is_stopword = 1;
    end

    
    % If term is not in the stopword list, process it.
    if is_stopword ~= 1
        
        % -----------------------------------------------------------------
        % Porter stemming
        % -----------------------------------------------------------------
        
        curr_word = pr_fe_text_stemmer(char(curr_word));
        word_index=-1;
%         for i=1:length(term_feature)
%             if strcmp(curr_word,term_feature(1,i))==1
%                 word_index=i;
%             end
%         end

        if isKey(term_feature_map,curr_word)==1
            word_index=term_feature_map(curr_word);
        end


        if word_index~=-1
            %result(1,word_index)=1; Set feature with id i=1
            result(1,word_index)=result(1,word_index)+1;%increase feature frequency with id i=1
        end
        
        
    end
end
z=result;

    
end
