This repository contains our Matlab demo code converting RGB pixel data to luminance, following the steps in our paper:

Realistic Luminance in VR 
Nathan Matsuda*, Alexandre Chapiro*, Yang Zhao, Clinton Smith, Romain Bachy, Douglas Lanman
Meta, USA
Conference track of SIGGRAPH Asia 2022

The code generates the plots in the paper, and can be easily modified to use a different camera or observer type. If you use this code in your research, please cite our paper above.


# Installation

First, save the following to the "data" directory:
- https://www.rit-mcsl.org/UsefulData/MacbethColorChecker.xls
- https://www.rit-mcsl.org/UsefulData/D65_and_A.xls
- https://syns.soton.ac.uk/SPHERON_COLOUR.txt


Then, download the Southampton-York Natural Scenes dataset to the from its authors' website before running the SYNS_RGB_to_luminance demo: https://syns.soton.ac.uk/browse

The scenes used in our work were the following:

9 indoor scenes:
- Indoor Lecture Hall #81
- Indoor Office #82
- Indoor Classroom #83
- Indoor Office #85
- Indoor Living Room #86
- Indoor Foyer #88
- Indoor Lecture Hall #89
- Indoor Cafe #90
- Indoor Living Room #92

10 outdoor scenes:
- Outdoor Urban #1
- Outdoor Suburban #2
- Outdoor Retail #3
- Outdoor Forest #4
- Outdoor Wetlands #5
- Outdoor Forest #6
- Outdoor Forest #26
- Outdoor Glass Houses #31
- Outdoor Beach #37
- Outdoor Forest #71

The folder structure is set up as in the examples below for indoor scene #81. The top path is for the .hdr image containing the image capture we will use to extract the luminance information. The second path is for the metadata file that has the camera exposure, ISO, and f values we need to compute luminance.
SYNSData -> indoor -> SYNS_scene_81_indoor_Lecturehall -> SYNSData -> 81 -> rep1.hdr
SYNSData -> indoor -> SYNS_scene_81_indoor_Lecturehall -> SYNSData -> 81 -> I_25_81.txt

The same is repeated for e.g. outdoor scene #1:
SYNSData -> outdoor -> SYNS_scene_1_outdoor_Urban -> SYNSData -> 1 -> rep1.hdr
SYNSData -> outdoor -> SYNS_scene_1_outdoor_Urban -> SYNSData -> 1 -> O_1_14.txt

# Usage

There are 3 top-level Matlab scripts used to generate the plots in our paper:

- "spectral_demo.m" uses the camera's spectral response function and standard observer CMFs to generate an RGB to XYZ matrix using MIM/MIMP. It generates the plots in Figures 2 and 3 of the paper.
- "SpheronCharacterization2022_luminancePrediction.m" uses the ground truth luminance data collected by us in the lab (Fig. 4) and the EV formula to convert XYZ Y values obtained the using matrix T from the previous demo into luminance in nits. This code generates the plot in Figure 5 of the paper.
- "SYNS_RGB_to_luminance.m" converts the 360 immersive images from the SYNS dataset into luminance values. Before running this code, please download the SYNS dataset following the instructions in the SYNSData folder.

# Contact

Please feel free to reach out to Alex Chapiro (alex@chapiro.net) and Nathan Matsuda (nathan.matsuda@fb.com) with any questions or comments, we love hearing about folk using our code!

# LICENSE

Shield: [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg