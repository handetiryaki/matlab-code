%===================================================================
% Feature Extraction for Text
%===================================================================
function pr_fe_text_high_speed(dataset,train_set,issamedataset)

tic

%clc
%clear all

disp('Starting feature extraction of texts...');

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


% -----------------------------------------------------------------
% Define state: 0 or 1
% -----------------------------------------------------------------
state_train = 0;

% Set dataset type
%dataset_type = DATASET_REUTERS;
dataset_type = dataset;

% Pre-Item List (used in term defining)
global term_list_pre;
global term_existence_map;
global stopword_list_map;


term_list_pre   = struct('CLASS', {}, 'NAME', {},'FREQ', {}, 'MUTUAL_INFO', {}, 'CHI2', {}, 'IG', {},'IG_FOR_TERM', {},'GINI_INDEX', {}, 'GINI_INDEX_FOR_TERM', {},'DFS', {},'PHD_NM_F2', {},'POISSON', {},'AM_TF', {},'MOR', {},'PB_TERM_WEIGHT',{},'TF_RF', {},'TF_RR', {},'DF', {}, 'APPEARANCE', {}, 'MARKED', {});
term_existence_map = containers.Map();

if dataset_type == DATASET_NEWS10 || dataset_type == DATASET_NEWS3
    
    % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter', 'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'particular', 'particularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

elseif dataset_type == DATASET_NEWS20
    
    % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter', 'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'particular', 'particularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    

elseif dataset_type == DATASET_REUTERS || dataset_type == DATASET_REUTERS_PARTIAL
    
    % Stopword list
    stopword_list = {'title', 'places', 'people', 'orgs', 'exchanges', 'companies', 'unknown', 'author', 'dateline', 'body', 've', 're', 'll', 'reuters', 'reuter', 'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'particular', 'particularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end   
elseif dataset_type == DATASET_SPAMSMSENG
    
    % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'particular', 'particularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end   
elseif dataset_type == DATASET_WEBKB
    
    % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'particular', 'particularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end   
elseif dataset_type == DATASET_ENRON1
    
    % Stopword list
    stopword_list = {'a', 'able', 'about', 'above', 'according', 'accordingly', 'across', 'actually', 'after', 'afterwards', 'again', 'against', 'all', 'allow', 'allows', 'almost', 'alone', 'along', 'already', 'also', 'although', 'always', 'am', 'among', 'amongst', 'an', 'and', 'another', 'any', 'anybody', 'anyhow', 'anyone', 'anything', 'anyway', 'anyways', 'anywhere', 'apart', 'appear', 'appreciate', 'appropriate', 'are', 'around', 'as', 'aside', 'ask', 'asking', 'associated', 'at', 'available', 'away', 'awfully', 'b', 'be', 'became', 'because', 'become', 'becomes', 'becoming', 'been', 'before', 'beforehand', 'behind', 'being', 'believe', 'below', 'beside', 'besides', 'best', 'better', 'between', 'beyond', 'both', 'brief', 'but', 'by', 'c', 'came', 'can', 'cannot', 'cant', 'cause', 'causes', 'certain', 'certainly', 'changes', 'clearly', 'co', 'com', 'come', 'comes', 'concerning', 'consequently', 'consider', 'considering', 'contain', 'containing', 'contains', 'corresponding', 'could', 'course', 'currently', 'd', 'definitely', 'described', 'despite', 'did', 'different', 'do', 'does', 'doing', 'done', 'down', 'downwards', 'during', 'e', 'each', 'edu', 'eg', 'eight', 'either', 'else', 'elsewhere', 'enough', 'entirely', 'especially', 'et', 'etc', 'even', 'ever', 'every', 'everybody', 'everyone', 'everything', 'everywhere', 'ex', 'exactly', 'example', 'except', 'f', 'far', 'few', 'fifth', 'first', 'five', 'followed', 'following', 'follows', 'for', 'former', 'formerly', 'forth', 'four', 'from', 'further', 'furthermore', 'g', 'get', 'gets', 'getting', 'given', 'gives', 'go', 'goes', 'going', 'gone', 'got', 'gotten', 'greetings', 'h', 'had', 'happens', 'hardly', 'has', 'have', 'having', 'he', 'hello', 'help', 'hence', 'her', 'here', 'hereafter', 'hereby', 'herein', 'hereupon', 'hers', 'herself', 'hi', 'him', 'himself', 'his', 'hither', 'hopefully', 'how', 'howbeit', 'however', 'i', 'ie', 'if', 'ignored', 'immediate', 'in', 'inasmuch', 'inc', 'indeed', 'indicate', 'indicated', 'indicates', 'inner', 'insofar', 'instead', 'into', 'inward', 'is', 'it', 'its', 'itself', 'j', 'just', 'k', 'keep', 'keeps', 'kept', 'know', 'knows', 'known', 'l', 'last', 'lately', 'later', 'latter', 'latterly', 'least', 'less', 'lest', 'let', 'like', 'liked', 'likely', 'little', 'look', 'looking', 'looks', 'ltd', 'm', 'mainly', 'many', 'may', 'maybe', 'me', 'mean', 'meanwhile', 'merely', 'might', 'more', 'moreover', 'most', 'mostly', 'much', 'must', 'my', 'myself', 'n', 'name', 'namely', 'nd', 'near', 'nearly', 'necessary', 'need', 'needs', 'neither', 'never', 'nevertheless', 'new', 'next', 'nine', 'no', 'nobody', 'non', 'none', 'noone', 'nor', 'normally', 'not', 'nothing', 'novel', 'now', 'nowhere', 'o', 'obviously', 'of', 'off', 'often', 'oh', 'ok', 'okay', 'old', 'on', 'once', 'one', 'ones', 'only', 'onto', 'or', 'other', 'others', 'otherwise', 'ought', 'our', 'ours', 'ourselves', 'out', 'outside', 'over', 'overall', 'own', 'p', 'particular', 'particularly', 'per', 'perhaps', 'placed', 'please', 'plus', 'possible', 'presumably', 'probably', 'provides', 'q', 'que', 'quite', 'qv', 'r', 'rather', 'rd', 're', 'really', 'reasonably', 'regarding', 'regardless', 'regards', 'relatively', 'respectively', 'right', 's', 'said', 'same', 'saw', 'say', 'saying', 'says', 'second', 'secondly', 'see', 'seeing', 'seem', 'seemed', 'seeming', 'seems', 'seen', 'self', 'selves', 'sensible', 'sent', 'serious', 'seriously', 'seven', 'several', 'shall', 'she', 'should', 'since', 'six', 'so', 'some', 'somebody', 'somehow', 'someone', 'something', 'sometime', 'sometimes', 'somewhat', 'somewhere', 'soon', 'sorry', 'specified', 'specify', 'specifying', 'still', 'sub', 'such', 'sup', 'sure', 't', 'take', 'taken', 'tell', 'tends', 'th', 'than', 'thank', 'thanks', 'thanx', 'that', 'thats', 'the', 'their', 'theirs', 'them', 'themselves', 'then', 'thence', 'there', 'thereafter', 'thereby', 'therefore', 'therein', 'theres', 'thereupon', 'these', 'they', 'think', 'third', 'this', 'thorough', 'thoroughly', 'those', 'though', 'three', 'through', 'throughout', 'thru', 'thus', 'to', 'together', 'too', 'took', 'toward', 'towards', 'tried', 'tries', 'truly', 'try', 'trying', 'twice', 'two', 'u', 'un', 'under', 'unfortunately', 'unless', 'unlikely', 'until', 'unto', 'up', 'upon', 'us', 'use', 'used', 'useful', 'uses', 'using', 'usually', 'uucp', 'v', 'value', 'various', 'very', 'via', 'viz', 'vs', 'w', 'want', 'wants', 'was', 'way', 'we', 'welcome', 'well', 'went', 'were', 'what', 'whatever', 'when', 'whence', 'whenever', 'where', 'whereafter', 'whereas', 'whereby', 'wherein', 'whereupon', 'wherever', 'whether', 'which', 'while', 'whither', 'who', 'whoever', 'whole', 'whom', 'whose', 'why', 'will', 'willing', 'wish', 'with', 'within', 'without', 'wonder', 'would', 'would', 'x', 'y', 'yes', 'yet', 'you', 'your', 'yours', 'yourself', 'yourselves', 'z', 'zero'}; 
    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end   
end


% Define dataset topics
global dataset_topics;
if dataset_type == DATASET_NEWS10

    % Original list
    dataset_topics = {'alt.atheism', 'comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x', 'misc.forsale', 'rec.autos', 'rec.motorcycles', 'rec.sport.baseball'};

    % Custom List
    %dataset_topics = {'alt.atheism'};
 
elseif dataset_type == DATASET_NEWS3

    % Original list
    dataset_topics = {'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x'};

    % Custom List
    %dataset_topics = {'alt.atheism'};

elseif dataset_type == DATASET_NEWS20

    % Original list
    dataset_topics = {'alt.atheism', 'comp.graphics', 'comp.os.ms-windows.misc', 'comp.sys.ibm.pc.hardware', 'comp.sys.mac.hardware', 'comp.windows.x', 'misc.forsale', 'rec.autos', 'rec.motorcycles', 'rec.sport.baseball', 'rec.sport.hockey', 'sci.crypt', 'sci.electronics', 'sci.med', 'sci.space', 'soc.religion.christian', 'talk.politics.guns', 'talk.politics.mideast', 'talk.politics.misc', 'talk.religion.misc'};

    % Custom List
    %dataset_topics = {'alt.atheism'};

elseif dataset_type == DATASET_REUTERS || dataset_type == DATASET_REUTERS_PARTIAL

    % Original Top-10 list
    dataset_topics = {'earn', 'acq', 'money-fx', 'grain', 'crude', 'trade', 'interest', 'ship', 'wheat', 'corn'};

    % Custom List
    %dataset_topics = {'wheat', 'corn'};
elseif dataset_type == DATASET_MILLIYET

    % Original Filtered Category list (son, guncel,yazar categories excluded)
    dataset_topics = {'astro', 'dunya', 'ekonomi', 'magazin', 'sanat', 'siyaset', 'spor', 'tv', 'yasam'};
elseif dataset_type == DATASET_SPAMSMSTR

    % Original Filtered Category list (son, guncel,yazar categories excluded)
    dataset_topics = {'spam', 'legitimate'};
elseif dataset_type == DATASET_SPAMSMSENG

    % Original Filtered Category list (son, guncel,yazar categories excluded)
    dataset_topics = {'spam', 'legitimate'};
elseif dataset_type == DATASET_WEBKB

    % Original Filtered Category list (son, guncel,yazar categories excluded)
    dataset_topics = {'course', 'faculty', 'project', 'student'};
elseif dataset_type == DATASET_SPAMSMSENG

    % Original Filtered Category list (son, guncel,yazar categories excluded)
    dataset_topics = {'spam', 'legitimate'};
elseif dataset_type == DATASET_ENRON1

    % Original Filtered Category list (son, guncel,yazar categories excluded)
    dataset_topics = {'spam', 'ham'};


end

% Init dataset
global NUM_CLASS;
NUM_CLASS=length(dataset_topics);

global dataset_class_idx;
dataset_class_idx = zeros(1, NUM_CLASS);

% Initializations
topic_cnt = 0;

% Process the selected dataset
if dataset_type == DATASET_NEWS10 || dataset_type == DATASET_NEWS20 || dataset_type == DATASET_NEWS3

    if (issamedataset==1)
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
            process_curr_text(state_train, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
            
        end
        
    end
    
    term_list_pre_unique_without_calculations=term_list_pre;
    save term_list_pre_unique_without_calculations term_list_pre_unique_without_calculations;
    
    
    else%if terms are already extracted, just load terms from .mat file
        load term_list_pre_unique_without_calculations term_list_pre_unique_without_calculations;
        load term_existence_map;
        load dataset_class_idx;
        term_list_pre=term_list_pre_unique_without_calculations;
        save term_list_pre term_list_pre;
        NUM_CLASS=length(dataset_class_idx);
    end
    
 elseif dataset_type == DATASET_ENRON1

    stopword_list_map = containers.Map();
    
    for i=1:length(stopword_list)
        stopword_list_map(char(stopword_list(i)))=1;
    end
    
    train_set_ratio=2/3;
    
    if issamedataset==1

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
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------
            %curr_text
            process_curr_text(state_train, curr_text, curr_class);
            
            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
            
        end
        
    end  
        term_list_pre_unique_without_calculations=term_list_pre;
        save term_list_pre_unique_without_calculations term_list_pre_unique_without_calculations;
    
    else%if terms are already extracted, just load terms from .mat file
        load term_list_pre_unique_without_calculations term_list_pre_unique_without_calculations;
        load term_existence_map;
        load dataset_class_idx;
        term_list_pre=term_list_pre_unique_without_calculations;
        save term_list_pre term_list_pre;
        NUM_CLASS=length(dataset_class_idx);
    end
    
elseif dataset_type == DATASET_REUTERS
    tic
    
    if (issamedataset==1)
    
    for cnt=1:22
        
        % Filename setup
        file_name = int2str(cnt-1);
        
        if (length(file_name) == 1)
            zero_pad = '00';
        elseif (length(file_name) == 2)
            zero_pad = '0';
        end
        
        file_name = [zero_pad file_name];
        
        fpath=['D:\DATASETS\TEXT\ENGLISH\REUTERS-21578\reut2-' file_name '.sgm'];
        %fid = fopen(fpath, 'r','UTF-8');
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
                                process_curr_text(state_train, curr_text, curr_class);
                                
                                % Increment feature count for current class.
                                dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
                                
                            end
                        end
                    end
            end
        end
        
        % Close file
        fclose(fid);
        
    end
    term_list_pre_unique_without_calculations=term_list_pre;
    save term_list_pre_unique_without_calculations term_list_pre_unique_without_calculations;
    
    
    else%if terms are already extracted, just load terms from .mat file
        load term_list_pre_unique_without_calculations term_list_pre_unique_without_calculations;
        load term_existence_map;
        load dataset_class_idx;
        term_list_pre=term_list_pre_unique_without_calculations;
        save term_list_pre term_list_pre;
        NUM_CLASS=length(dataset_class_idx);
    end
    
    toc

elseif dataset_type == DATASET_WEBKB
    tic
    
    if (issamedataset==1)        
       
        
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
            
            process_curr_text(state_train, curr_text, curr_class);

            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
            
            
        end
        
                    % Close file
            fclose(fid);                                                                                                                                   

        
    term_list_pre_unique_without_calculations=term_list_pre;
    save term_list_pre_unique_without_calculations term_list_pre_unique_without_calculations;
    
    
    else%if terms are already extracted, just load terms from .mat file
        load term_list_pre_unique_without_calculations term_list_pre_unique_without_calculations;
        load term_existence_map;
        load dataset_class_idx;
        term_list_pre=term_list_pre_unique_without_calculations;
        save term_list_pre term_list_pre;
        NUM_CLASS=length(dataset_class_idx);
    end
    
    toc
elseif dataset_type == DATASET_REUTERS_PARTIAL
    tic
    
    if (issamedataset==1)
    
    for cnt=1:6
        
        % Filename setup
        file_name = int2str(cnt-1);
        
        if (length(file_name) == 1)
            zero_pad = '00';
        elseif (length(file_name) == 2)
            zero_pad = '0';
        end
        
        file_name = [zero_pad file_name];
        
        fpath=['D:\datasets\text\experimentaldata\multiclass\reuters-21578-partial-1\reut2-' file_name '.sgm'];
        %fid = fopen(fpath, 'r','UTF-8');
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
                                process_curr_text(state_train, curr_text, curr_class);
                                
                                % Increment feature count for current class.
                                dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1;
                                
                            end
                        end
                    end
            end
        end
        
        % Close file
        fclose(fid);

        
    end
    term_list_pre_unique_without_calculations=term_list_pre;
    save term_list_pre_unique_without_calculations term_list_pre_unique_without_calculations;
    
    
    else%if terms are already extracted, just load terms from .mat file
        load term_list_pre_unique_without_calculations term_list_pre_unique_without_calculations;
        load term_existence_map;
        load dataset_class_idx;
        term_list_pre=term_list_pre_unique_without_calculations;
        save term_list_pre term_list_pre;
        NUM_CLASS=length(dataset_class_idx);
    end
    
    toc

    
elseif dataset_type == DATASET_SPAMSMSENG
    tic
    
    if (issamedataset==1)        
       
        
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
            
            % -----------------------------------------------------------------
            % Process current text
            % -----------------------------------------------------------------
            process_curr_text(state_train, curr_text, curr_class);

            % Increment feature count for current class.
            dataset_class_idx(curr_class) = dataset_class_idx(curr_class) + 1; 
        end
        % Close file
        fclose(fid);                       
                            
                        
                    
        


        
    term_list_pre_unique_without_calculations=term_list_pre;
    save term_list_pre_unique_without_calculations term_list_pre_unique_without_calculations;
    
    
    else%if terms are already extracted, just load terms from .mat file
        load term_list_pre_unique_without_calculations term_list_pre_unique_without_calculations;
        load term_existence_map;
        load dataset_class_idx;
        term_list_pre=term_list_pre_unique_without_calculations;
        save term_list_pre term_list_pre;
        NUM_CLASS=length(dataset_class_idx);
    end
    
    toc
end

    % Save terms
    save dataset_class_idx dataset_class_idx;
    save term_list_pre term_list_pre;
    
    % Compute mutual information of terms
    toc
    disp('Computing mutual information...');
    mutual_info;    
    
    % Save terms and phrases
    save term_list_pre term_list_pre;

    % Compute chi2 values of terms
    toc
    disp('Computing chi2 value...');
    chi2;

    % Save terms and phrases
    save term_list_pre term_list_pre;
    
    % Compute phd novel method formula 1 values of terms
    toc
    disp('Computing phd novel method formula 1 value...');
    dfs;

    
    % Compute phd novel method formula 2 values of terms
    toc
    disp('Computing phd novel method formula 2 value...');
    phd_novel_method_f2;
    
    % Save terms and phrases
    save term_list_pre term_list_pre; 
    
    % Compute gini index values of terms
    toc
    disp('Computing gini index value...');
    gini_index;    
    
    % Compute gini index for term values
    toc
    disp('Computing gini index for term value...');
    gini_index_for_term;
    
    toc
    disp('Computing AM value according to TF...');
    ambiguity_measure_tf;  
    
    toc
    disp('Computing MOR value...');
    multiclass_odds_ratio;
    
    toc
    disp('Computing PROBABILITY BASED value...');
    probability_based_term_weighting;
    
    
    toc
    disp('Computing TF-RF value...');
    TFRF_term_weighting;
    
    toc
    disp('Computing TF-RR value...');
    TFRR_term_weighting;

    % Save terms and phrases
    save term_list_pre term_list_pre;
    
    % Compute information gain values of terms
    toc
    disp('Computing IG value...');
    info_gain;    
    
    % Compute information gain for term values
    toc
    disp('Computing information gain for term value...');
    info_gain_for_term;
    
    % Compute poisson distribution for term values
    toc
    disp('Computing poisson distribution for term value...');
    poisson_distribution;
    
    toc
    disp('Computing Document Frequency value...');
    document_frequency;
    

    % Save terms and phrases
    save term_list_pre term_list_pre;
    
    % Display number of items in each class
    dataset_class_idx    

toc
disp('Done...');

return;


%===================================================================
% Process Current English Text
%===================================================================
function process_curr_text(state_train, curr_text, curr_class)

% Globals
global term_list_pre;
global phrase_list_pre;
global term_list_post;
global phrase_list_post;
global dataset_class;
global dataset_class_idx;
global term_existence_map;
global stopword_list_map;

% Make all text lowercase
curr_text = lower(curr_text);
% Remove html codes little than, greater than, and
curr_text = strrep(curr_text, '&lt;', ' ');
curr_text = strrep(curr_text, '&gt;', ' ');
curr_text = strrep(curr_text, '&amp;', ' ');


% Get decimal format of current text
dec_curr_text = abs(curr_text);

% Convert all irregular chars to space
curr_text((dec_curr_text < 65) | (dec_curr_text > 90 & dec_curr_text < 97) | (dec_curr_text > 122)) = 32;

% Extract words from current text
word_list = strread(curr_text, '%s');

% Init
prev_word = {};

% Initially no term/phrase is marked for appearance in current text
for wrd=1:length(term_list_pre)
    term_list_pre(wrd).MARKED = 0;
end

for wrd=1:length(phrase_list_pre)
    phrase_list_pre(wrd).MARKED = 0;
end

% Process word list in current text
for ind=1:length(word_list)
    
    % -----------------------------------------------------------------
    % Get current word
    % -----------------------------------------------------------------
    
    curr_word = word_list(ind);
    
    % -----------------------------------------------------------------
    % Stopword list elimination
    % -----------------------------------------------------------------
    
    is_stopword = 0;


    if isKey(stopword_list_map,curr_word)==1
        is_stopword = 1;
    end
    
    % If term is not in the stopword list, process it.
    if is_stopword ~= 1
        
        % -----------------------------------------------------------------
        % Porter stemming
        % -----------------------------------------------------------------
        
        curr_word = pr_fe_text_stemmer(char(curr_word));
        
        % -----------------------------------------------------------------
        % Preprocessing is now over. Process current word.
        % -----------------------------------------------------------------
        
        if state_train == 0
            
            % -----------------------------------------------------------------
            % Add current term to the term list.
            % -----------------------------------------------------------------
            
            
            % Search term set for current word
            num_item = length(term_list_pre);
            
            term_and_class=char(strcat(strcat(curr_word,'_'), int2str(curr_class)));
            
            % If term is already in the list, increment its freq.
            if isKey(term_existence_map,term_and_class)==1
                term_index=term_existence_map(term_and_class);
                term_list_pre(term_index).FREQ = term_list_pre(term_index).FREQ + 1;

                % If the term is not marked before, increment
                % appearance count.
                if term_list_pre(term_index).MARKED == 0
                    term_list_pre(term_index).APPEARANCE = term_list_pre(term_index).APPEARANCE + 1;
                    term_list_pre(term_index).MARKED = 1;
                end
                
            else
                %add to word list
                %term_existence_map(char(term_and_class))=num_item + 1;
                term_existence_map(term_and_class)=num_item + 1;
                term_list_pre(num_item + 1).CLASS = curr_class;
                term_list_pre(num_item + 1).NAME = curr_word;
                term_list_pre(num_item + 1).FREQ = 1;
                term_list_pre(num_item + 1).MARKED = 1;
                term_list_pre(num_item + 1).APPEARANCE = 1;
            end
      
            
        else
            
            % -----------------------------------------------------------------
            % Perform feature extraction for terms.
            % -----------------------------------------------------------------
            
            % If term is in the list, increment its freq.
            for wrd=1:length(term_list_post)
                if (strcmp(curr_word, term_list_post(wrd)) == 1)
                    dataset_class(curr_class, dataset_class_idx(curr_class) + 1, wrd) = dataset_class(curr_class, dataset_class_idx(curr_class) + 1, wrd) + 1;
                end
            end
            
            % -----------------------------------------------------------------
            % Perform feature extraction for phrases.
            % -----------------------------------------------------------------
            
            % Setup current phrase
            curr_phrase = [prev_word ' ' curr_word];
            
            % If phrase is in the list, increment its freq.
            for phr=1:length(phrase_list_post)
                if (strcmp(curr_phrase, phrase_list_post(phr)) == 1)
                    dataset_class(curr_class, dataset_class_idx(curr_class) + 1, phr + length(term_list_post)) = dataset_class(curr_class, dataset_class_idx(curr_class)+1, phr + length(term_list_post)) + 1;
                end
            end
            
            % Save current word as the previous word.
            prev_word = curr_word;
            
        end
        
    end
    
end
save term_existence_map term_existence_map;

return;



%===================================================================
% Compute Mutual Information
%===================================================================
function mutual_info()

% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% MI(term, category) = log (A * N / (A + C) * (A + B))
% MI(x, y) = sumx sumy p(x,y) * log (p(x,y) / (p(x) * p(y)))

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute mutual information for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)
    
    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end
    
    % Init
    curr_mutual_info = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    
    
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    
    % Compute mutual information of current term for regarding class
    for class=term_list_pre(wrd).CLASS;
    
        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        
        res = log2((N11 * N) / ((N11 + N01) * (N11 + N10)));

        % Assign mutual information if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_mutual_info(class) = res;
        end        
    end
        
    % Get mutual information for current term in current class
    term_list_pre(wrd).MUTUAL_INFO = curr_mutual_info(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;

return


%===================================================================
% Compute Mutual Information
%===================================================================
function poisson_distribution()

% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute mutual information for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)
    
    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end
    
    % Init
    curr_poisson = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    total_freq_for_class = zeros(1, NUM_CLASS);

    
    
    
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
            total_freq_for_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).FREQ;
         end
    end
    
    
    % Compute mutual information of current term for regarding class
    for class=term_list_pre(wrd).CLASS;
    
        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);

        
        tStart = tic;

        %lambda=(N11+N10)/N;
        lambda=sum(total_freq_for_class)/N;
        a_hat=(N11+N01)*(1-exp(-lambda));
        b_hat=(N11+N01)*(exp(-lambda));
        c_hat=(N10+N00)*(1-exp(-lambda));
        d_hat=(N10+N00)*(exp(-lambda));
        
        a=N11;
        b=N01;
        c=N10;
        d=N00;


        part1=(a-a_hat)^2/a_hat;
        part2=(b-b_hat)^2/b_hat;
        part3=(c-c_hat)^2/c_hat;
        part4=(d-d_hat)^2/d_hat;
        
        
        res = part1+part2+part3+part4;
        
        tElapsed = toc(tStart);

        % Assign mutual information if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_poisson(class) = res;
        end        
    end
        
    % Get mutual information for current term in current class
    term_list_pre(wrd).POISSON = curr_poisson(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;

return


%===================================================================
% Compute PHD Novel Method Formula 1
%===================================================================
function dfs()
%some extensions to modified ambiguity measure

%mutual information give same weights to features occurring in one class
%but it disregards term frequency. This method prevents terms occurring in
%one class and having small document frequency getting high score

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% PHDNMV1(term, category) = log (P(t|c)/P(t))+P(t|c)
% equivalent
% PHDNMV1(term, category) = (A / (A + C) + (A / (A + B)


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute DFS value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        


        %classprob=dataset_class_idx(class)/sum(dataset_class_idx);
        res = ((N11 / (N11 + N10)))/((N01/(N01+N11))+(N10/(N10+N00))+1);%(P(c|t))/(P(t_not|c)+1+P(t|c_not)) yeni formul  
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).DFS = curr_phdnm(term_list_pre(wrd).CLASS);
    
end

% Save terms and phrases
save term_list_pre term_list_pre;
return




%===================================================================
% Compute PHD Novel Method Formula 2
%===================================================================
function phd_novel_method_f2()
%some extensions to modified ambiguity measure

%mutual information give same weights to features occurring in one class
%but it disregards term frequency. This method prevents terms occurring in
%one class and having small document frequency getting high score

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N01 (B) : The number of times category occurs without term
% N10 (C) : The number of times term occurs without category
% N00 (D) : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% PHDNMV1(term, category) = log (P(t|c)/P(t))+P(t|c)


global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute Modified PHD Novel Method Formula 2 value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_phdnm2 = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute Phd novel formula 1 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        

        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        
        %res1 = radtodeg(asin((N11/(N11+N01))-(N10 / (N00 + N10))));%arcsin(P(t|c)-P(t|c_not))) 
        %res2 =(1-(N10/(N00+N10))^2)*((N11/(N01+N11)-(N10/(N00+N10)))^2);%(1-P(t|c_not))^2*(P(t|c)-P(t|c_not)^2
        %res3=(((N11)/(sqrt(N11+N10)*sqrt(N11+N01))));%Ochiai similarity en buyuk
        %res4=((N11/(N01+N10+N11)));%jaccard index en buyuk
        %res5=((2*N11)/(2*N11+N10+N01));%dice similarity en buyuk
        %res6=(((N11*N00)-(N01*N10))/(sqrt((N11+N01)*(N10+N00)*(N01+N00)*(N11+N10))));%phi coefficient en buyuk
        %res7=(((N11*N00))/(sqrt((N11+N01)*(N10+N00)*(N01+N00)*(N11+N10))));%Sokal and Sneath Similarity Measure 5 coefficient en buyuk
        %res8=((N11/(N11+N01))+(N11/(N11+N10))+(N00/(N01+N00))+(N00/(N10+N00)))/4;%Sokal and Sneath Similarity Measure 4 coefficient en buyuk
        %res9=(N11+N00)/(N11+N00+2*(N10+N01));%Rogers and Tanimoto Similarity Measure en buyuk
        %res10=((N11/N11+N01)+(N11/N11+N10))/2;%Kulczynski Similarity Measure 2 en buyuk
        %res11=((N11+N00)-(N10+N01))/(N11+N01+N10+N00);%Hamann Similarity Measure en buyuk
        %Goodman and Kruskal Lambda en buyuk baslangic
        %t1=max(N11,N01)+max(N10,N00)+max(N11,N10)+max(N01,N00);
        %t2=max(N11+N10,N01+N00)+max(N11+N01,N10+N00);
        %res12=(t1-t2)/(2*(N11+N01+N10+N00)-t2);%Goodman and Kruskal Lambda en buyuk bitis
        %Anderberg’s D (Similarity) en buyuk baslangic
        %t1=max(N11,N01)+max(N10,N00)+max(N11,N10)+max(N01,N00);
        %t2=max(N11+N10,N01+N00)+max(N11+N01,N10+N00);
        %res13=(t1-t2)/(2*(N11+N01+N10+N00));%Anderberg’s D (Similarity) en buyuk bitis
        %res14=(sqrt(N11*N00)-sqrt(N01*N10))/(sqrt(N11*N00)+sqrt(N01*N10));%Yule’s Y Coefficient en buyuk
        %res15=(N11*N00-N01*N10)/(N11+N01+N10+N00)^2;%Dispersion Similarity en buyuk
        %res16=N11/max(N11+N10,N11+N01);%BRAUN BANQUE en buyuk


        classprob=dataset_class_idx(class)/sum(dataset_class_idx);

        tStart = tic;
        
        res=(N11/(N11+N10))*(N11/(N11+N10+N01));%toplam
        
        tElapsed = toc(tStart);
        % Assign phd novel formula 1 if result is not NaN. Else, leave it as
        % zero
        if isnan(res) == 0
            curr_phdnm2(class) = res;
        end
        
                                                      
    end
        
    term_list_pre(wrd).PHD_NM_F2 = curr_phdnm2(term_list_pre(wrd).CLASS);
    
end

% Save terms and phrases
save term_list_pre term_list_pre;
return





%===================================================================
% Compute Chi-Square
%===================================================================
function chi2()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% chi2MI(x, y) = sumx sumy (Nxy - Exy)^2 / Exy

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute chi2 value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_chi2 = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute chi2 value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
        tStart = tic;

        % Calculate expected frequencies
        E11 = N * ((N11 + N10) / N) * ((N11 + N01) / N);
        E10 = N * ((N10 + N11) / N) * ((N10 + N00) / N);
        E01 = N * ((N01 + N00) / N) * ((N01 + N11) / N);
        E00 = N * ((N00 + N01) / N) * ((N00 + N10) / N);
        
        % Calculate chi2 value
        curr_chi2(class) = ((N00 - E00)^2 / E00) + ...
            ((N01 - E01)^2 / E01) + ...
            ((N10 - E10)^2 / E10) + ...
            ((N11 - E11)^2 / E11);
        
        tElapsed = toc(tStart);
    end
    
    
    % Get chi2 value for current term in current class
    term_list_pre(wrd).CHI2 = curr_chi2(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;




%===================================================================
% Compute Gini Index according to binary settings
%===================================================================
function gini_index()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% GINI_INDEX=1/((N11+N10)^2)*( (N11^2)/(N11+N01) )^2+( (N10^2)/(N10+N00) )^2)
% Formula is taken from "Comparison of metrics for feature selection in
% imbalanced text classification", Ogura et al.

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute GINI INDEX value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_gi = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute GINI INDEX value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N01 = dataset_class_idx(class) - N11;
        N00 = N - (N11 + N10 + N01);
        
        tStart = tic;

        part1 = 1/((N11+N10)^2);      
        part2=((N11^2)/(N11+N01))^2;
        part3=((N10^2)/(N10+N00))^2;
        
        % Calculate Gini Index value
        curr_gi(class) = part1*(part2+part3);
        tElapsed = toc(tStart);
                                                      
    end
        
    % Get Gini index value for current term in current class
    term_list_pre(wrd).GINI_INDEX = curr_gi(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;



%===================================================================
% Compute Gini Index
%===================================================================
function gini_index_for_term()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% GINI_INDEX=((N11)/(N11+N01) )^2)*((N10)/(N10+N00)^2)
% Formula is taken from "Comparison of metrics for feature selection in
% imbalanced text classification", Ogura et al.
% scores for term calculated by addition of all class values

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute GINI INDEX value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_gi = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute GINI INDEX value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));        
                
        N01 = dataset_class_idx(class) - N11;
                
        
        tStart = tic;
        res = ((N11/(N11+N01))^2)*((N11 / (N11 + N10))^2);
        
        tElapsed = toc(tStart);
        
        % Calculate Gini Index value
        curr_gi(class) = res;        
                                                      
    end
        
    % Get Gini index value for current term in current class
    term_list_pre(wrd).GINI_INDEX_FOR_TERM = curr_gi(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;





%===================================================================
% Compute Ambiguity Measure
%===================================================================
function ambiguity_measure_tf()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% AM=tf(t,c)/tf(t)
% AM=N11/(N11+N01)
% Formula is taken from ambiguity measure paper Nazli Goharian et. al

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% -----------------------------------------------------------------
% Compute AM value for each term regarding class
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_am= zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).FREQ;
         end
    end
    % Compute AM value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));                        
              
        % Calculate Ambiguity Measure
        curr_am(class) = N11/(N11+N10);         
                                                      
    end   
    
    % Get AM value for current term in current class
    term_list_pre(wrd).AM_TF = curr_am(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;




%===================================================================
% Compute Document Frequency Measure
%===================================================================
function document_frequency()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute Document Frequency value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_df = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    % Compute Document Freq value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);        
        
        % Calculate Document Frequency Measure
        curr_df(class) = N11;
        
                                                      
    end
        
    % Get DF value for current term in current class
    term_list_pre(wrd).DF = curr_df(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;


%===================================================================
% Compute Multi Class Odds Ratio
%===================================================================
function multiclass_odds_ratio()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% MOR=
% Formula is taken from "Feature selection for text classification with
% naive bayes", Chen et al.

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute MOR value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_mor= zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute MOR value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        
        
        
        N01 = dataset_class_idx(class) - N11;
        N00 = N - (N11 + N10 + N01);
        
        part1=N11/(N11+N01);
        part2=N10/(N00+N10);
        
        formula=((part1*(1-part2))/(part2*(1-part1)));
        
        % Calculate Multi Class Odds Ratio Measure
        %curr_mor(class) = abs(log(formula));
        curr_mor(class) = log(formula);        
                                                      
    end
        
    % Get MOR value for current term in current class
    term_list_pre(wrd).MOR = curr_mor(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;


%===================================================================
% Compute Probability based term weight
%===================================================================
function probability_based_term_weighting()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00 (D) : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

% PB_Weight = max(TF *  log(1 + (N11/N10)*(N11/N01) )

% Liu, Y., Loh, H. T., & Sun, A. (2009). Imbalanced text classification: A term weighting approach. Expert systems with Applications, 36(1), 690-701.

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute PROBABILITY BASED SCORE for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_pb = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute GINI INDEX value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));        
                
        N01 = dataset_class_idx(class) - N11;
                
        
        tStart = tic;
        part1 = 1;
        part2 = (N11/N10)*(N11/N01);
        res = log10(part1 + part2);
        
        tElapsed = toc(tStart);
        
        % Calculate Gini Index value
        curr_pb(class) = res;        
                                                      
    end
        
    % Get Gini index value for current term in current class
    term_list_pre(wrd).PB_TERM_WEIGHT = curr_pb(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;



%===================================================================
% Compute RF value for TF-RF term weight
%===================================================================
function TFRF_term_weighting()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00 (D) : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

% TF-RF = max(TF *  log2 (2 + (N11/N01) )

% Lan, M., Tan, C. L., Su, J., & Lu, Y. (2009). Supervised and traditional term weighting methods for automatic text categorization. Pattern Analysis and Machine Intelligence, IEEE Transactions on, 31(4), 721-735.

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute TF-RF SCORE for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_TFRF = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute GINI INDEX value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));        
                
        N01 = dataset_class_idx(class) - N11;
                
        
        tStart = tic;
        part1 = 2;
        part2 = (N11/N01);
        res = log2(part1 + part2);
        
        tElapsed = toc(tStart);
        
        % Calculate Gini Index value
        curr_TFRF(class) = res;        
                                                      
    end
        
    % Get Gini index value for current term in current class
    term_list_pre(wrd).TF_RF = curr_TFRF(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;




%===================================================================
% Compute RR value for TF-RR term weight
%===================================================================
function TFRR_term_weighting()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00 (D) : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)

% TF-RR = log (tf + 1) * log2( (P(t|c)/P(t|c_not)) + 2 )

% Ko, Y. (2015). A new term?weighting scheme for text classification using the odds of positive and negative class probabilities. Journal of the Association for Information Science and Technology.

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute TF-RF SCORE for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_TFRR = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute GINI INDEX value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);     
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));        
                
        N01 = dataset_class_idx(class) - N11;
        N00 = N - (N11 + N10 + N01);        
        
        tStart = tic;
        part1 = (N11/(N11+N01));
        part2 = (N10/(N10+N00));
        res = log2((part1 / part2) + 2);
        
        tElapsed = toc(tStart);
        
        % Calculate Gini Index value
        curr_TFRR(class) = res;        
                                                      
    end
        
    % Get Gini index value for current term in current class
    term_list_pre(wrd).TF_RR = curr_TFRR(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;




%===================================================================
% Compute Information Gain
%===================================================================
function info_gain()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% IG = e(pos,neg) – [Pword.e(tp,fp) + Pword'.e(fn,tn)]

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute IG value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_ig = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute IG value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
                
        % IG = e(pos,neg) – [Pword.e(tp,fp) + Pwordnot.e(fn,tn)]
        % IG = prm1       - [Pword.prm2     + Pwordnot.prm3    ]
        
        tmp_x = N11 + N01;
        tmp_y = N10 + N00;
        prm1 = -(tmp_x/(tmp_x+tmp_y))*log2(tmp_x/(tmp_x+tmp_y))-(tmp_y/(tmp_x+tmp_y))*log2(tmp_y/(tmp_x+tmp_y));
        
        tmp_x = N11;
        tmp_y = N10;
        prm2 = -(tmp_x/(tmp_x+tmp_y))*log2(tmp_x/(tmp_x+tmp_y))-(tmp_y/(tmp_x+tmp_y))*log2(tmp_y/(tmp_x+tmp_y));
        
        tmp_x = N01;
        tmp_y = N00;
        prm3 = -(tmp_x/(tmp_x+tmp_y))*log2(tmp_x/(tmp_x+tmp_y))-(tmp_y/(tmp_x+tmp_y))*log2(tmp_y/(tmp_x+tmp_y));

        Pword = (N11 + N10) / N;
        Pwordnot = 1 - Pword;
        
        % Calculate IG value
        curr_ig(class) = prm1 - (Pword * prm2 + Pwordnot * prm3);
    end
        
    % Get IG value for current term in current class
    term_list_pre(wrd).IG = curr_ig(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;


%===================================================================
% Compute Information Gain
%===================================================================
function info_gain_for_term()

% N is observed frequency
% E is expected frequency
%
% N11 (A) : The number of times term and category co-occur
% N10 (B) : The number of times term occurs without category
% N01 (C) : The number of times category occurs without term
% N00     : The number of times neither category nor term occurs
% N       : Total number of documents (N11 + N10 + N00 + N01)
%
% IG = e(pos,neg) – [Pword.e(tp,fp) + Pword'.e(fn,tn)]

global term_existence_map;
global term_list_pre;
global dataset_class_idx;
global NUM_CLASS;

% Compute dataset size
N = sum(dataset_class_idx);

% -----------------------------------------------------------------
% Compute IG value for each term
% -----------------------------------------------------------------
for wrd=1:length(term_list_pre)

    % Display term count for tracking purpose
    if (mod(wrd, 100) == 0)
        str = [int2str(wrd) ' / ' int2str(length(term_list_pre))];
        disp(str);
    end

    % Init
    curr_ig = zeros(1, NUM_CLASS);
    appearence_in_class = zeros(1, NUM_CLASS);
    
    % Find appearances of current term in all classes
    for cnt=1:length(dataset_class_idx) 
         term_and_class=char(strcat(strcat(term_list_pre(wrd).NAME,'_'), int2str(cnt)));
         if isKey(term_existence_map,term_and_class)==1
            term_index=term_existence_map(term_and_class);
            appearence_in_class(term_list_pre(term_index).CLASS) = term_list_pre(term_index).APPEARANCE;
         end
    end
    
    % Compute IG value of current term for regarding class
    for class=term_list_pre(wrd).CLASS
        
        % Calculate observed frequencies
        N11 = appearence_in_class(class);
        N01 = dataset_class_idx(class) - N11;
        
        other_classes = 1:NUM_CLASS;
        other_classes(class) = [];
        N10 = sum(appearence_in_class(other_classes));
        N00 = N - (N11 + N10 + N01);
                
        % IG = e(pos,neg) – [Pword.e(tp,fp) + Pwordnot.e(fn,tn)]
        % IG = prm1       - [Pword.prm2     + Pwordnot.prm3    ]
        tStart = tic;

        tmp_x = N11 + N01;
        tmp_y = N10 + N00;
        prm1 = -(tmp_x/(tmp_x+tmp_y))*log2(tmp_x/(tmp_x+tmp_y));
        
        tmp_x = N11;
        tmp_y = N10;
        prm2 = -(tmp_x/(tmp_x+tmp_y))*log2(tmp_x/(tmp_x+tmp_y));
        
        tmp_x = N01;
        tmp_y = N00;
        prm3 = -(tmp_x/(tmp_x+tmp_y))*log2(tmp_x/(tmp_x+tmp_y));

        Pword = (N11 + N10) / N;
        Pwordnot = 1 - Pword;
        
        % Calculate IG value
        curr_ig(class) = prm1 - (Pword * prm2 + Pwordnot * prm3);
        
        tElapsed = toc(tStart);
    end
        
    % Get IG value for current term in current class
    term_list_pre(wrd).IG_FOR_TERM = curr_ig(term_list_pre(wrd).CLASS);
    
end

% Save terms
save term_list_pre term_list_pre;

return