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

function make_MOA()

    addpath(genpath(pwd));
    
    % change to 0 if luminance data has already been generated for a speedup
    loading_data = 1;
    % change to 0 if you don't want to write out the final images
    writing_out  = 1;
    
    % recover luminance values
    if(~loading_data)
        [L_indoor, L_outdoor] = SYNS_RGB_to_luminance('SYNSData/');
    else
        load('SYNS_L_outdoor.mat');
        load('SYNS_L_indoor.mat' );
    end

    % scale to range [m M]
    % values below correspond to our VR-HDR prototype display
    m = 0.0001;
    M = 20940;
    % obs.: our display used linear gamma, but gamma encoding may be needed
    % for a different display modality!
    
    % from SYNS_threshold_means.m script
    max_mean_allowed = 2.7657e+03;
    % how many gradations in MOA experiment
    n_steps = 40;

    % means defined in log-space evenly between 50 and 4000 nits
    means = logspace(log10(6), log10(max_mean_allowed), n_steps);
        
    % for each scene in the Indoor set
    for scene_number = 1:length(L_indoor)
        % baseline is the original image
        I_lin_baseline = L_indoor{scene_number};
        for i = 1:length(means)
            % for each offset, change the mean while keeping log-contrast constant
            [I_lin{i}, mean_luminance_indoor(scene_number)] = equivalentLogContrast(I_lin_baseline, means(i), M, m);
%             I_gamma{i} = inverse_gamma(I_lin{i}, g, M, m);
            [I_norm{i}, I_max(i)] = normalize_image(I_lin{i});
        end

        if(writing_out)
            scene_name = sprintf('MOA_images/Indoor_SYNS_scene%02d/', scene_number);
            if(~exist(scene_name,'dir'))
                mkdir(scene_name);
            end
            for i = 1:length(means)
                name = [scene_name sprintf('%04dnits.hdr', round(means(i)))];
                
                I_write = add_back_bottom_bar(I_norm{i});
                
                hdrwrite(repmat(I_write, [1 1 3]), name);
            end
            
            % in our implementation, the maximum value is used to modulate the backlight strength
            name = [scene_name sprintf('Indoor_SYNS_scene%02d', scene_number) '_maxvals.csv'];
            csvwrite(name,I_max);
        end
    end    
        
    % for each scene in the Outdoor set
    for scene_number = 1:length(L_outdoor)
        % baseline is the original image
        I_lin_baseline = L_outdoor{scene_number};
        for i = 1:length(means)
            % for each offset, change the mean while keeping log-contrast constant
            [I_lin{i}, mean_luminance_outdoor(scene_number)] = equivalentLogContrast(I_lin_baseline, means(i), M, m);
            [I_norm{i}, I_max(i)] = normalize_image(I_lin{i});
        end

        if(writing_out)
            scene_name = sprintf('MOA_images/Outdoor_SYNS_scene%02d/', scene_number);
            if(~exist(scene_name,'dir'))
                mkdir(scene_name);
            end
            for i = 1:length(means)
                name = [scene_name sprintf('%04dnits.hdr', round(means(i)))];
                
                I_write = add_back_bottom_bar(I_norm{i});
                
                hdrwrite(repmat(I_write, [1 1 3]), name);
%                 hdrwrite(repmat(I_gamma{i}, [1 1 3]), name);
            end

            name = [scene_name sprintf('Outdoor_SYNS_scene%02d', scene_number) '_maxvals.csv'];
            csvwrite(name,I_max);
        end    
    end
    
   % generate plot with luminances means of dataset
   if(1)
        plot(1:length(mean_luminance_indoor),mean_luminance_indoor,'LineWidth',2);
        hold on
        plot(1+length(mean_luminance_indoor):length(mean_luminance_indoor)+length(mean_luminance_outdoor),mean_luminance_outdoor,'LineWidth',2);
        plot(1:length(mean_luminance_indoor),ones(size(mean_luminance_indoor)).*mean(mean_luminance_indoor),'b--','LineWidth',1);
        plot(1+length(mean_luminance_indoor):length(mean_luminance_indoor)+length(mean_luminance_outdoor),ones(size(mean_luminance_outdoor)).*mean(mean_luminance_outdoor),'r--','LineWidth',1);
        meanLabInd = sprintf('mean = %d', round(mean(mean_luminance_indoor)));
        meanLabOut = sprintf('mean = %d', round(mean(mean_luminance_outdoor)));
        legend({'indoor scenes','outdoor scenes',meanLabInd, meanLabOut},'Location','SouthEast')
        set(gca,'Yscale','log');
        xlabel('Scene #');
        ylabel('mean luminance (nits)')
        ylim([10 30000]);
        title('SYNS means');
        set(gca,'FontSize',15);
    end

end

% Im is a luminance image
% n_ is the new desired mean for the image
function [Im, n] = equivalentLogContrast(L_lin, n_, M, m)
    % original mean    
    n = mean(L_lin(:));
    % calculate needed log offset
    logmean_offset = log10(n_) - log10(n);
    % apply offset in log space
    Im = log10(L_lin) + logmean_offset;
    % clip values that are out of range
    Im(Im<log10(m)) = log10(m);
    Im(Im>log10(M)) = log10(M);
    % invert log
    Im = 10.^(Im);
end

% normalizes image to 0-1 range, and returns max value separately
function [I_norm, I_max] = normalize_image(I_lin)
    I_max = max(I_lin(:));
    I_norm = I_lin./I_max;
end

% adds back the black bar at the bottom of the image to avoid distortions
function [I_write] = add_back_bottom_bar(I_lin)
    sz = size(I_lin);
    I_write = zeros(2698, sz(2)); 
    I_write(1:sz(1), 1:sz(2)) = I_lin;
end