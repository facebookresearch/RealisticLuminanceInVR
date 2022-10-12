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

%   Reference:
%       Finlayson, Graham D., and Mark S. Drew. 
%       "The maximum ignorance assumption with positivity." 
%       Color and Imaging Conference. Vol. 1996. No. 1. 
%       Society for Imaging Science and Technology, 1996.
% obs.: looked up code from https://github.com/fangfufu/Colour_Correction_Toolbox
function T = get_colorspace_xform_MIP(cssf, cmf)

    %POS_IDENT_MAT Construct a positive identiy matrix
    s = max(size(cmf));
    llt = ones(s)/4;
    llt(logical(eye(s))) = 1/3;
    T = cmf' * llt * cssf * inv(cssf' * llt * cssf);
    
end