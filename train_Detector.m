
%% Machine learning problems

% Problem 1: detect visual changes (different classes listed above)
% Description: Traditional supervised machine learning problem
% Features: Continuity, voltage, frequency, symmetry
% Question - how often are these assessed, what time frame is important

% Problem 2: Novel qEEG features that occur prior to arrest
% Description: Unsupervised learning (Using PCA + k-means?) of features
% Novel features to add: Synchrony, entropy, skewness, kurtosis, frequency
% Question - what time points to test, what results do we want for this

% Problem 3: Compare predictive value of different methods

%% Load data
% User altered parameters
% ieeg.org username and password
clear all
ID = 'jbernabei';
PW = 'jbe_ieeglogin.bin';

% List endings for patient IDs to use
patient_ID = {'01','02','03','04','05','06'};
addpath(genpath('jsonlab-1.5'))

%% Start session
num_pts = size(patient_ID,2);
all_train_feats = [];
all_train_labels = [];

pt_ind = [1,2,5,6]

for pt = pt_ind
    pt
session = IEEGSession(sprintf('CHOP_CICU_00%s',patient_ID{pt}),ID,PW);
freq = session.data.sampleRate;

% Get labels
%ann_struct(1).data = getEvents(session.data.annLayer,0);
ann_struct = loadjson(sprintf('/Users/jbernabei/Downloads/CHOP_json/CHOP_CICU_%s_annotations_edit_new.iann_EEG labels.json',patient_ID{pt}));
[class_label,label_time, CPR_time] = parse_Labels(ann_struct);

% Get features
time_offset = [];

% Select channels
channel_nums_1 = [1:5,8:14,16:20,24:27]; %For patients 1-7
%channel_nums_2 = [1:3,6:9,12:16,21:26]; %For patients 8+

% Get number of data segments for supervised learning problem
num_data_segments = length(class_label);
length_data = 600; % 600 seconds = 10 minutes
split_data_num = 3; % number of segments to split each length_data into

% loop through data segments
for i = 1:num_data_segments
    i
    skip_segment = 0;
    for j = 1:split_data_num
        time_start = ceil((label_time(i)+length_data*(j-1)./split_data_num)*freq);
        time_stop = ceil((label_time(i)+length_data*(j)./split_data_num)*freq);
        full_raw_data = session.data.getvalues(time_start:time_stop, channel_nums_1)';
        if sum(sum(isnan(full_raw_data))) == (size(full_raw_data,1).*size(full_raw_data,2))
            skip_segment = 1;
        end
    % Do feature calculation (in progress)
    size(full_raw_data)
    if skip_segment==0    
        placeholder_feats = moving_Window(full_raw_data, freq, 10, 1)';
        real_feats(i).data(j,:) = [mean(placeholder_feats), var(placeholder_feats)];
    end
    end
    
    if skip_segment==0
        patient_features((split_data_num*(i-1)+1):split_data_num*i,:) = real_feats(i).data;
        patient_labels((split_data_num*(i-1)+1):split_data_num*i,1:2) = repmat([class_label(i),pt],split_data_num,1);
    end
end
all_train_feats = [all_train_feats; patient_features];
all_train_labels = [all_train_labels; patient_labels];
end
%% Save calculated feature matrix

%% Train classifier and perform CV
% Split data into folds

% Random forest
% LASSO

%% Perform unsupervised feature learning
% Search 5, 10, 20, 30, 60, 90, 120, 180, 240 mins before arrest
% Here instead of 10 minute segments we will check 60 secs before & after
% time point

% Examine within and across patients

