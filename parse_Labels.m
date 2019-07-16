function [class_label,label_time, CPR_time] = parse_Labels(ann_struct)
% This function parses class labels for a supervised machine learning
% problem from an ieeg.org annotation structure

% Labels
% Normal continuous = class 1
% Normal discontinuous = class 2
% Continuous low voltage = class 3
% Excessive discontinuity = class 4
% Burst suppression = class 5
% Low voltage suppression = class 6
% Seizure = class 7
% All other = class 8
num_ann = size(ann_struct(1).data,2);
for i = 1:num_ann
    ann_label = ann_struct(1).data(i).description;
    label_time(i) = ann_struct(1).data(i).start./1e6;
    if strcmp(ann_label,'Normal continuous')
        class_label(i) = 1;
    elseif strcmp(ann_label,'Normal discontinuous')
        class_label(i) = 2;
    elseif strcmp(ann_label,'Continuous low voltage')
        class_label(i) = 3;
    elseif strcmp(ann_label,'Excessive discontinuity')
        class_label(i) = 4;
    elseif strcmp(ann_label,'Burst suppression')
        class_label(i) = 5;
    elseif strcmp(ann_label,'Low voltage suppression')
        class_label(i) = 6;
    elseif strcmp(ann_label,'Seizure')
        class_label(i) = 7;
    else
        class_label(i) = 8;
    end
    
    if strcmp(ann_struct(1).data(i).type,'CPR Onset')
        CPR_time = ann_struct(1).data(i).start./1e6;
    end
end

end