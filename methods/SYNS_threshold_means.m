%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2022 Meta Platforms, Inc. and affiliates
%
% This repository contains Matlab code associated with our paper:
% 
% Realistic Luminance in VR 
% Nathan Matsuda*, Alexandre Chapiro*, Yang Zhao, Clinton Smith, Romain Bachy, Douglas Lanman 
% Conference track of SIGGRAPH Asia 2022
%
% Contact:
% Alex Chapiro (alex@chapiro.net) 
% Nathan Matsuda (nathan.matsuda@fb.com)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SYNS_threshold_means()
    % loading the luminance data
    load('SYNS_L_indoor.mat' );
    load('SYNS_L_outdoor.mat');
    % calculating what the max luminance can be without clipping more than 5% of pixels
    % obs.: discarding synthetic flat field from this analysis (last "indoor" image)
    max_mean_indoor   = find_maximal_mean(Threshold_5_indoor(:,1:end-1),  Mean_Luminance_indoor(1:end-1) );
    max_mean_outdoor = find_maximal_mean(Threshold_5_outdoor, Mean_Luminance_outdoor);
    % final number
    max_mean_allowed = min([max_mean_indoor max_mean_outdoor])
    
end

% Im is a luminance image
% we are trying to find a mean log-luminance offset such that no more than 5% of pixels are clipped
function max_mean = find_maximal_mean(threshold5, mean_luminance)
    % get log thresholds
    log_threshold5 = log10(threshold5);
    
    M = 20940; % max nits for display
    logM = log10(M);
    
    log_mean_luminance = log10(mean_luminance);
    
    max_offset = logM - log_threshold5(2,:);
    
    max_mean = 10.^(max_offset + log_mean_luminance);
    
end