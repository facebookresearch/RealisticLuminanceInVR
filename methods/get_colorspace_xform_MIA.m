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

% Reference: 
% Horn, Berthold KP. "Exact reproduction of colored images." 
% Computer Vision, Graphics, and Image Processing 26.2 (1984): 135-167.
% obs.: looked up code from https://github.com/fangfufu/Colour_Correction_Toolbox
function T = get_colorspace_xform_MIA(cam_spd_res, st_obs)

    T = (cam_spd_res./max(cam_spd_res(:))) \ (st_obs./max(st_obs(:)));
    
end
