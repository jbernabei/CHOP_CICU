
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

% Get labels
ann_struct(1).data = getEvents(session.data.annLayer,0)

% Get features
