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

% This function uses the T matrix obtained using the "maximum ignorance
% method with positivity" from the previous demo.
% pass 3xN RGB values, get back 3xN XYZ values
function XYZ = spheron_RGB2XYZ(RGB)

    if(size(RGB,1) ~= 3)
        error('input must be RGB pixels as a 3xN matrix');
        if(size(RGB,2) == 3)
            warning('make sure the RGB input is correctly aligned');
        end
    end
    
    % RGB2XYZ matrix
    T =     [1.9435    1.6334    0.8696
             0.9094    3.7017    0.2069
            -0.0342   -0.6593    5.6478];
    % obs.: up to a multiplicative factor 
    XYZ = T*RGB;

end


