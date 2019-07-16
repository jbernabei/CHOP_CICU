
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
ID = 'jbernabei';
PW = 'jbe_ieeglogin.bin';

% List endings for patient IDs to use
patient_ID = {'01','02','03','04','05','06','07','08','09','10','11','12',...
    '13_D01','14','15','16','17_D01','18_D01','19','20','21_D01','22','23','24'};

%% Start session
session = IEEGSession('RID0060',ID,PW);
freq = session.data.sampleRate;

% Get labels
ann_struct(1).data = getEvents(session.data.annLayer,0);
[class_label,label_time, CPR_time] = parse_Labels(ann_struct);

% Get features
time_offset = [];

% Select channels
channel_nums_1 = [1:5,8:14,16:20,24:27]; %For patients 1-7
channel_nums_2 = [1:3,6:9,12:16,21:26]; %For patients 8+

% Get number of data segments for supervised learning problem
num_data_segments = length(class_label);
length_data = 600; % 600 seconds = 10 minutes

% loop through data segments
for i = 1:num_data_segments
    full_raw_data = session.data.getvalues(ceil(label_time(i)*freq):ceil((label_time(i)+length_data)*freq), channel_nums_1)';
    % Do feature calculation (in progress)
    
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
