function features = moving_Window(values, fs, winLen, winDisp, featFn)

%   correlation_Matrix.m
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
    xLen = length(values); % length of signal
    numWins = ceil(((xLen/fs)-(winLen-winDisp))/winDisp); % max number of full windows

    samplesWin = winLen * fs; % number of samples in each window
    samplesDisp = winDisp * fs; % number of samples in each displacement window

    n=1; % initialize window counting
    firstSample = 1; % initialize sample counting
    features = []; % initialize array to store features
    while n <= numWins-1
        values = values(firstSample:(firstSample+samplesWin-1)); % determine signal values for window
        res = featFn(values,fs);
        features = [features res']; % calculate features for window

        n = n+1; % advance window counter
        firstSample = firstSample + samplesDisp; % advance sample counter
    end
