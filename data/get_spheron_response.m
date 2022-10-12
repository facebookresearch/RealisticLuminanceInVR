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

function cam_spectral = get_spheron_response()

    if(~isfile('SPHERON_COLOUR.txt'))
        disp('Download https://syns.soton.ac.uk/SPHERON_COLOUR.txt to data directory first');
        return
    end

    intable = readtable('SPHERON_COLOUR.txt','ConsecutiveDelimitersRule','join');
    cam_spectral = horzcat(str2double(intable{1:72,1}),table2array(intable(1:72,2:4)))
end