function SAs = getRegionSurfaceAreas(atlas)
%%%%%%%%%% INPUT %%%%%%%%%
% 1)atlas- the atlas that you want to find the surface areas of 
%%%%%%%%%% OUTPUT %%%%%%%%
% 1) SAs:a n x 2 list where the first column is the number of the 
%region and the second column is the surface area of that region.

% pull out the unique regions 
regions = unique(atlas(:));
dims = size(atlas);
% if one of the unique regions is zero we want to delete this 
if(regions(1)==0)
    regions(1) = [];
end
% initialize a blank volume list of two columns
SAs = zeros(length(regions),1);
% loop over all regions and count the volume of each
for i = 1:dims(1)
    for j = 1:dims(2)
        for k = 1:dims(3)
             if(atlas(i,j,k)>0)
                 region = atlas(i,j,k);
                 nextTo = 0;
                 if(i+1 <=dims(1))
                     if(atlas(i+1,j,k)==region)
                         nextTo = nextTo+1;
                     end
                 end
                 if(i-1 >= 1)
                     if(atlas(i-1,j,k)==region)
                         nextTo = nextTo+1;
                     end
                 end
                 if(j+1 <=dims(2))
                     if(atlas(i,j+1,k)==region)
                         nextTo = nextTo+1;
                     end
                 end
                 if(j-1 >=1)
                     if(atlas(i,j-1,k)==region)
                         nextTo = nextTo+1;
                     end
                 end
                 if(k+1 <= dims(3))
                     if(atlas(i,j,k+1)==region)
                         nextTo = nextTo+1;
                     end
                 end
                 if(k-1 >= 1)
                     if(atlas(i,j,k-1)==region)
                         nextTo = nextTo+1;
                     end
                 end
                 if(nextTo<6)
                     SAs(region) = SAs(region) + ((6-nextTo)*0.001*0.001);
                 end
                   
             end
        end
    end
end

end

