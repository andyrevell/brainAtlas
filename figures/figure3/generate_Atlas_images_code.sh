#!/bind/bash

ATLAS_DIRECTORY=/Users/andyrevell/Box/01_papers/paper001_brainAtlasChoiceSFC/figure3_data
FIGURE_DIRECTORY=/Users/andyrevell/Documents/20_papers/paper001_brainAtlasChoiceSFC/figures/figure3
#coordinated
x=-10.71519
y=-32.61282
z=19.02231


fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/RA_N2000_Perm0001.png $ATLAS_DIRECTORY/RA_N2000_Perm0001.nii.gz -cm brain_colours_flow_iso

