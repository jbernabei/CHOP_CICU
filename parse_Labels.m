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
num_ann = size(ann_struct.annotations,2);
ann_count = 1;
for i = 1:num_ann
    ann_label = ann_struct.annotations{i}.description;
    
    get_label = 0;
    if strcmp(ann_label,'Normal Continuity') || strcmp(ann_label,'Continuity') || strcmp(ann_label,'Continuous')
        class_label(ann_count) = 1; get_label = 1;
    elseif strcmp(ann_label,'Normal Discontinuity')
        class_label(ann_count) = 2; get_label = 1;
    elseif strcmp(ann_label,'Continuous Low Voltage')
        class_label(ann_count) = 3; get_label = 1;
    elseif strcmp(ann_label,'Excessive Discontinuity')
        class_label(ann_count) = 4; get_label = 1;
    elseif strcmp(ann_label,'Low Voltage Suppression')
        class_label(ann_count) = 5; get_label = 1;
    end
    
    if get_label==1;
        label_time(ann_count) = ann_struct.annotations{i}.startOffsetMicros./1e6;
        ann_count = ann_count+1;
    end
    
    if strcmp(ann_struct.annotations{i}.type,'CPR Onset')
        CPR_time = ann_struct.annotations{i}.startOffsetMicros./1e6;
    end
end

end