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


% converts the SYNS dataset from RGB to luminance estimates using methods described in the report
% displays aggregate luminance histograms for indoor and outdoor scenes separately
% edit code to obtain the luminance images for other purposes
function [L_indoor, L_outdoor] = SYNS_RGB_to_luminance(location)
    
    saving = 1;
    visualizing = 1;
    
    if(~exist('location','var'))
        location = 'SYNSData/';
    end
    
    % adding paths
    addpath(genpath(pwd));
    % run the method for outdoor and indoor scenes separately
    [L_indoor , Threshold_5_indoor , Mean_Luminance_indoor ] ...
        = SYNS_luminance_estimation('indoor' , location, visualizing);  
    
    % adding an extra synthetic case for a flat field
    L_indoor{end+1} = ones(size(L_indoor{end})).*1000;
    Threshold_5_indoor(1, length(L_indoor)) = 50;
    Threshold_5_indoor(2, length(L_indoor)) = 5000;
    Mean_Luminance_indoor(length(L_indoor)) = 1000;
        
    [L_outdoor, Threshold_5_outdoor, Mean_Luminance_outdoor] ...
        = SYNS_luminance_estimation('outdoor', location, visualizing);
    
    if(saving)
        save('SYNS_L_indoor' ,'L_indoor' , 'Threshold_5_indoor' , 'Mean_Luminance_indoor' );
        save('SYNS_L_outdoor','L_outdoor', 'Threshold_5_outdoor', 'Mean_Luminance_outdoor');
    end
end

function [L, Threshold_5, Mean_Luminance] = SYNS_luminance_estimation(category, location , visualizing)

    if(~exist('visualizing','var'))
        visualizing = 1;
    end

    % setting up file names to read in .hdr images
    folder = [location category '/'];
    h = dir(folder); h = h(4:end);
    
    loc = 1;
    for i = 1:length(h)
        % for each available image (with valid metadata)
        if( strcmp(category,'indoor') || strcmp(category,'outdoor') )

            loc1 = dir([folder h(i).name '/SYNSData/']);
            loc2 = dir([folder h(i).name '/SYNSData/' loc1(end).name '/']);
            location = [folder h(i).name '/SYNSData/' loc1(end).name '/'];
            fname = [location 'rep1.hdr'];% loc2(4).name];
            % gather metadata from text file and calculate EV
            data{i} = metadata_parser(location, loc2);
            % read in HDR file
            hdr{i} = hdrread(fname); % load HDR image
            hdr{i} = hdr{i}(1:2400,:,:); % cropping the black line at the bottom
            % create image for visualization
            if(1)
                I{loc} = tonemap(hdr{i});
                % optional, write out the SDR image for visualization
%                 imwrite(I{i}, [h(i).name '.png']);
            end
            
            % convert to luminance using the XYZ2RGB matrix    
            L{loc} = spheron_RGB2Yunscaled(hdr{i});
            
            % obtain the multiplier that is supposed to convert pixel values to luminance
            kMult = get_Kmult();
            
            % multiply by the linear factor
            % this is calculated by taking into account the calculated EV from metadata
            L{loc} = L{loc}.*kMult.*(2.^(data{i}.EV)); 

            fprintf('case %d, max Lum = %f\n', i, max(L{loc}(:)));      
            
            loc = loc+1;

        else
            fprintf('skipped %s i = %d\n',category, i)
        end

        
    end
    
    for i = 1:length(L)
        Current_L = L{i}(:);
        [~, Threshold_5(1,i), Threshold_5(2,i), ~] = isoutlier(Current_L,'percentiles',[5 95]);
        
        Current_L(Current_L > Threshold_5(2,i)) = Threshold_5(2,i);
        Current_L(Current_L < Threshold_5(1,i)) = Threshold_5(1,i);
        
        Mean_Luminance(i) = mean(Current_L);
    end
    
    if(visualizing)
        % plotting the aggregate luminance histograms
        visualize_histogram(L, 'luminance', [category ' luminances']);
    end

end

function data = metadata_parser(location, loc2)

    % find the text file with the metadata
    i = 1;
    while(~contains(loc2(i).name,'.txt'))
        i = i+1;
    end
    % open the file
    h = fopen([location loc2(i).name]);
    % skip lines until you get to the spheron metadata
    S = [];
    while(~strcmp(S,'--Spheron HDR--'))
        S = fgetl(h);
    end
    % extract the specific values we are looking for
    S = fgetl(h); data.f = str2num(S(15:end));
    S = fgetl(h); data.e = str2num(S(20:end));
    S = fgetl(h); data.i = str2num(S(15:end));
    % apply the EV formula:
    data.EV = get_EV(data.f, data.e, data.i);
    % close the file again
    fclose(h);
end