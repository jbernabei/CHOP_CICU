function [feats] = get_EEG_Features(vals,sampleRate)

%   get_EEG_Features.m
%   
%   Inputs:
%    
%       values:     Values for which features will be calculated.MxN where
%                   each of M rows is a channel of N samples of 
%                   electrophysiologic data.
%
%       sampleRate: Sampling rate of the EEG in Hz.
%    
%   Output:
%    
%       features:      Returns vector of features for chunk of data
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
% 
%% Do initial data processing

% Theta band power
fcutlow1=2;   %low cut frequency in Hz
fcuthigh1=8;   %high cut frequency in Hz
p_theta = mean(bandpower(vals',sampleRate,[fcutlow1 fcuthigh1]));
%v_theta = var(bandpower(vals',sampleRate,[fcutlow1 fcuthigh1]));

% Alpha band power
fcutlow2=8;   %low cut frequency in Hz    
fcuthigh2=12; %high cut frequcency in Hz
p_alpha = mean(bandpower(vals',sampleRate,[fcutlow2 fcuthigh2]));
%v_alpha = var(bandpower(vals',sampleRate,[fcutlow2 fcuthigh2]));

% Filter for beta band
fcutlow3=12;   %low cut frequency in Hz
fcuthigh3=20;   %high cut frequency in Hz
p_beta = mean(bandpower(vals',sampleRate,[fcutlow3 fcuthigh3]));
%v_beta = var(bandpower(vals',sampleRate,[fcutlow3 fcuthigh3]));

% % Filter for 25-40 Hz low gamma band
% fcutlow4=25;   %low cut frequency in Hz
% fcuthigh4=40;   %high cut frequency in Hz
% p_lowgamma = mean(bandpower(vals',sampleRate,[fcutlow4 fcuthigh4]));

% Calculate features based on linelength
Line_length = mean(sum(abs(diff(vals))));
%v_LL = var(sum(abs(diff(vals))));

% Calculate signal energy
%Energy = mean(sum(vals.^2));

% Calculate wavelet entropy
Entropy = mean(wentropy(vals,'shannon'));

% Return vector of features
feats = [p_theta p_alpha p_beta Line_length Entropy];
end