#!/bind/bash

ATLAS_DIRECTORY=/Users/andyrevell/Box/01_papers/paper001_brainAtlasChoiceSFC/figure3_data
FIGURE_DIRECTORY=/Users/andyrevell/Documents/01_writing/00_thesis_work/06_papers/paper001_brainAtlasChoiceSFC/figures/figure3
#coordinated
x=-10.71519
y=-32.61282
z=19.02231
zoom=900
sz_x=1000
sz_y=400

fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xc 0 0 -yc 0 0 -zc 0 0 -xz $zoom -yz $zoom -zz $zoom -hl -sz $sz_x $sz_y --outfile $FIGURE_DIRECTORY/RA_N2000_Perm0001.png $ATLAS_DIRECTORY/RA_N2000_Perm0001.nii.gz -cm color_map71 #brain_colours_flow_iso

