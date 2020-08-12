%files = dir('./newAtlasTemplates2Analyze');
files = dir('./randomAtlasesForVolSpher');
%files(1:2) = [];
vols = {};
sphers = {};
%%
for i = 1:length(files)
    curFile = load_nii(strcat('./randomAtlasesForVolSpher/',files(i).name)).img;
    volume = getRegionVolumes(curFile);
    spher = getRegionSphericities(curFile);
    vols{i} = volume;
    sphers{i} = spher;    
end