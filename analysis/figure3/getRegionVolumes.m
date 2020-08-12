function volumes = getRegionVolumes(atlas)
%%%%%%%%%% INPUT %%%%%%%%%
% 1)atlas- the atlas that you want to find the volumes of 
%%%%%%%%%% OUTPUT %%%%%%%%
% 1) volumes:a n x 2 list where the first column is the number of the 
%region and the second column is the volume of that region.
% pull out the unique regions 
regions = unique(atlas(:));
% if one of the unique regions is zero we want to delete this 
if(regions(1)==0)
    regions(1) = [];
end
% initialize a blank volume list of two columns
volumes = zeros(length(regions),2);
% loop over all regions and count the volume of each
for i = 1:length(regions)
    volumes(i,:) = [i length(find(atlas(:)==regions(i)))];
end

end

