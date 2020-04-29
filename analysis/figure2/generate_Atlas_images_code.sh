#!/bind/bash

ATLAS_DIRECTORY=/Users/andyrevell/Box/01_papers/paper001_brainAtlasChoiceSFC/figure2_data
FIGURE_DIRECTORY=/Users/andyrevell/Documents/20_papers/paper001_brainAtlasChoiceSFC/figures/figure2
#coordinates
x=-10.71519
y=-32.61282
z=19.02231


fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_AAL.png $ATLAS_DIRECTORY/aal_res-1x1x1.nii.gz -cm brain_colours_flow
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_CPAC.png $ATLAS_DIRECTORY/CPAC200_res-1x1x1.nii.gz -cm brain_colours_nih_fire
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_DK.png $ATLAS_DIRECTORY/DK_res-1x1x1.nii.gz -cm brain_colours_nih_ice_iso
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_JHU.png $ATLAS_DIRECTORY/JHU_res-1x1x1.nii.gz -cm brain_colours_nih_ice_iso
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_Schaefer0100.png $ATLAS_DIRECTORY/Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm.nii.gz -cm subcortical
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_Schaefer0200.png $ATLAS_DIRECTORY/Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm.nii.gz -cm subcortical
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_Schaefer0300.png $ATLAS_DIRECTORY/Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm.nii.gz -cm subcortical
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_Schaefer0400.png $ATLAS_DIRECTORY/Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm.nii.gz -cm subcortical
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_Schaefer1000.png $ATLAS_DIRECTORY/Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm.nii.gz -cm subcortical
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_Talairach.png $ATLAS_DIRECTORY/Talairach_res-1x1x1.nii.gz -cm brain_colours_nih
#note Yeo atlases have different x y z orientation (-yx --> -zh option):  
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -zh -yc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_Yeo07.png $ATLAS_DIRECTORY/Yeo2011_7Networks_MNI152_FreeSurferConformed1mm.nii.gz -cm subcortical
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -zh -yc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_Yeo17.png $ATLAS_DIRECTORY/Yeo2011_17Networks_MNI152_FreeSurferConformed1mm.nii.gz -cm subcortical
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_Desikan.png $ATLAS_DIRECTORY/desikan_res-1x1x1.nii.gz -cm brain_colours_french
fsleyes render -wl $x $y $z -hc -bg 1 1 1 -xh -yh -zc 0 0 -zz 900 -hl -sz 400 500 --outfile $FIGURE_DIRECTORY/figure2_glasser.png $ATLAS_DIRECTORY/glasser_res-1x1x1.nii.gz -cm brain_colours_cardiac


#Overlap Image
x=18.58511
y=-13.35112
z=4.946755

zoom=870
size_x=3000
size_y=1000

fsleyes render --scene ortho --worldLoc $x $y $z --outfile $FIGURE_DIRECTORY/figure2_overlap_AAL.png --displaySpace $ATLAS_DIRECTORY/aal_res-1x1x1.nii.gz -sz $size_x $size_y -xc 0 0 -yc 0 0 -zc 0 0 -xz $zoom -yz $zoom -zz $zoom -hl --layout horizontal -hc --bgColour 1 1 1 $ATLAS_DIRECTORY/aal_res-1x1x1.nii.gz --name "AAL" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap blue-lightblue --negativeCmap greyscale --displayRange 0.0 116.0 --clippingRange 0.0 117.16 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 $ATLAS_DIRECTORY/JHU_res-1x1x1.nii.gz --name "JHU" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap red --negativeCmap greyscale --displayRange 0.0 48.0 --clippingRange 0.0 48.48 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 $ATLAS_DIRECTORY/niiEmptyEdit.nii --name "NoCoverage" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap brain_colours_nih --negativeCmap greyscale --useNegativeCmap --displayRange 0.0 7000.0 --clippingRange 0.0 7070.0 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0 $ATLAS_DIRECTORY/niiOverlapEdit.nii --name "Overlap" --overlayType volume --alpha 100.0 --brightness 50.0 --contrast 50.0 --cmap yellow --negativeCmap greyscale --displayRange 0.0 7000.0 --clippingRange 0.0 7070.0 --gamma 0.0 --cmapResolution 256 --interpolation none --numSteps 100 --blendFactor 0.1 --smoothing 0 --resolution 100 --numInnerSteps 10 --clipMode intersection --volume 0





