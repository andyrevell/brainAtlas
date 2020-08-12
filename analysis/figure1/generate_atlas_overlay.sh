#!/bind/bash

ATLAS_DIRECTORY=/Users/andyrevell/mount/USERS/arevell/papers/paper001/data_processed/figure2_data/standard_atlases
FIGURE_DIRECTORY=/Users/andyrevell/mount/USERS/arevell/papers/paper001/paper001/figures/figure1
#coordinates
x=-5.898249
y=-0.7267582
z=13.68003


fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -zh -yc 0 0 -yz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/overlay_AAL.png $ATLAS_DIRECTORY/aal_res-1x1x1.nii.gz -cm brain_colours_spectrum --invert

#fsleyes render --scene ortho -wl $x $y $z -xh -zh -yc 0 0 -yz 900 -hl -sz 400 500 -bg 1 1 1 --fgColour 0 0 0 --cmap brain_colours_spectrum --negativeCmap greyscale --displayRange 0.0 116.0 --clippingRange 0.0 117.16 --gamma 0.0 --cmapResolution 256 --interpolation none --invert --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0  --outfile $FIGURE_DIRECTORY/overlay_AAL.png $ATLAS_DIRECTORY/aal_res-1x1x1.nii.gz




