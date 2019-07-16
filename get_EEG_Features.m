function [features] = get_EEG_Features(values,sampleRate)

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
% Do filtering
order = 4; % Changed this from 5 to 4
low_freq = 0.5; % Hz
high_freq = 50; % Hz

[b,a] = besself(order,[low_freq high_freq],'bandpass');
[bz, az] = impinvar(b,a,sampleRate);
values=filter(bz,az,values); % This is generating almost 50% Nans

% Theta band power
fcutlow1=4;   %low cut frequency in Hz
fcuthigh1=8;   %high cut frequency in Hz
p_theta = mean(bandpower(values,sampleRate,[fcutlow1 fcuthigh1]));

% Alpha band power
fcutlow2=8;   %low cut frequency in Hz    
fcuthigh2=12; %high cut frequcency in Hz
p_alpha = mean(bandpower(values,sampleRate,[fcutlow2 fcuthigh2]));

% Filter for beta band
fcutlow3=12;   %low cut frequency in Hz
fcuthigh3=25;   %high cut frequency in Hz
p_beta = mean(bandpower(values,sampleRate,[fcutlow3 fcuthigh3]));

% Filter for 25-40 Hz low gamma band
fcutlow4=25;   %low cut frequency in Hz
fcuthigh4=40;   %high cut frequency in Hz
p_lowgamma = mean(bandpower(values,sampleRate,[fcutlow4 fcuthigh4]));

% Calculate features based on linelength
Line_length = sum(abs(diff(values)));

% Calculate signal energy
Energy = sum(values.^2);

% Calculate wavelet entropy
Entropy = wentropy(values,'shannon');

% Calculate ensemble synchrony
adj_matrix = correlation_Matrix(values);
Synch = mean(mean(adj_matrix));

% Return vector of features
features = [p_theta p_alpha p_beta p_lowgamma Line_length Energy Entropy Synch];
end