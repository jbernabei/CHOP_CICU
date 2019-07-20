function features = moving_Window(values, fs, winLen, winDisp, featFn)

%   moving_Window.m
%   
%   Inputs:
%    
%       values:     Values for which features will be calculated.MxN where
%                   each of M rows is a channel of N samples of 
%                   electrophysiologic data.
%           fs:     Sampling rate
%       winLen:     Length of window
%      winDisp:     Displacement from one window to next
%       featFn:     Handle of function to calculate features
%    
%   Output:
%    
%     features:     Features calculated for use in classifier
%    
%    License:       MIT License
%
%    Author:        John Bernabei
%    Affiliation:   Center for Neuroengineering & Therapeutics
%                   University of Pennsylvania
%                    
%    Website:       www.littlab.seas.upenn.edu
%    Repository:    http://github.com/jbernabei
%    Email:         johnbe@seas.upenn.edu
%
%    Version:       1.0
%    Last Revised:  July 2019
%%
    xLen = size(values,2); % length of signal
    numWins = ceil(((xLen/fs)-(winLen-winDisp))/winDisp) % max number of full windows

    samplesWin = winLen * fs; % number of samples in each window
    samplesDisp = winDisp * fs; % number of samples in each displacement window

    n=1; % initialize window counting
    firstSample = 1; % initialize sample counting
    features = []; % initialize array to store features
    out = filter_channels(values); % checks channels for nans or constant values
    values = values(out,:);
    while n <= numWins-1
        values1 = values(:,firstSample:(firstSample+samplesWin-1)); % determine signal values for window
        if sum(sum(isnan(values1)))==0
            res = get_EEG_Features(values1,fs);
            features = [features res']; % calculate features for window
        end

        n = n+1; % advance window counter
        firstSample = firstSample + samplesDisp; % advance sample counter
    end
