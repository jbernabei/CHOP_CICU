% A function that returns a list of channels without explicitly noisy data

% data - an IEEGDataset Object that has been accessed outside the function
% s_length - desired length of each data segment in seconds
% fs - sampling rate of the data
% out - a list of channels to be used

function out = filter_channels(data)
num_channels = size(data, 1);
% pre-allocate a vector that indicates which channels to remove
remove = zeros(1,num_channels);
out = [];
% Initialize counter
cnt = 0;
% the channel rejection proceeds under three criteria:
% 1) the channel only contains NaN values
% 2) the channel is flat (zero variance)
for ii = 1:num_channels
%   Counters to check whether each condition is satisfied for all samples
    c1 = 0;
    c2 = 0;
    c3 = 0;
    signal = data(ii,:);
    if sum(isnan(signal)) == length(signal)
        % update counter for NaN values
        c1 = c1 + 1;
        remove(ii) = 1;
    elseif var(signal) == 0
        % update counter for constant values
        c2 = c2 + 1;
        remove(ii) = 1;
    end
%   a zero in the 'remove' matrix means NOT to remove the iith channel
    if remove(ii) == 0
%       update counter
        cnt = cnt + 1;
%       append channel index to the output vector
        out(cnt) = ii;
    end
end
end