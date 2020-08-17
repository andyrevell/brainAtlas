function sphericity = getRegionSphericities(atlas)
%%%%%%%%%% INPUT %%%%%%%%%
% 1)atlas- the atlas that you want to find the sphericity of 
%%%%%%%%%% OUTPUT %%%%%%%%
% 1) sphericity:a n x 2 list where the first column is the number of the 
%region and the second column is the sphericity of that region.
% pull out the unique regions 
volumes = getRegionVolumes(atlas);
volumes(:,2) = volumes(:,2)*(0.001)*(0.001)*(0.001);
sa = getRegionSurfaceAreas(atlas);
sphericity = zeros(length(volumes),2);
sphericity(:,1) = volumes(:,1);
sphericity(:,2) = ((pi^(1/3)).*((6*volumes(:,2)).^(2/3)))./(sa);
plot(volumes(:,2),sphericity(:,2),'o')
title('Sphericity vs Volume')
xlabel('Volume (voxels)')
ylabel('Sphericity')
end


