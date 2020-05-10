function electrodeROIs = batchAssignElectrodeRegions(subList,nodes,permNumber,MNItemp_path,aal600_path)
%%%%%% INPUTS %%%%%%
% - electrode_coordinates_mni_path name of file containing MNI coordiantes of electrodes
%    Here the each row should be a point. Column 1: Electrode Label names.
%    Columns 2-4: Electrode coordinates [x, y, z]
% - atlas_path - the atlas PATH to assign regions from (this is the atlas we are localizing the electrodes -
% usually a random parcellation)
% - MNItemp - the MNI template path to make the conversion from world to voxel.
% space 
% sample call
% matlab -nosplash -nodesktop -r "addpath(genpath('/gdrive/public/USERS/arevell/seizure-diffusion')); batchAssignElectrodeRegions([278,320,309,31,508],[10,100,150,500,600,850,1000,1500,2000,2500,3000,4000,5000,10000],5,'/gdrive/public/TOOLS/atlases_and_templates/templates/MNI152_T1_1mm_brain.nii.gz','/gdrive/public/TOOLS/atlases_and_templates/atlases/custom_atlases/AAL600.nii.gz'); exit"

%load MNItemp
MNItemp = load_nii(MNItemp_path);
AAL_600 = load_nii(aal600_path);
AAL_600Data = AAL_600.img;
%load atlas
for f = 1:length(subList)
    sub = subList(f);
    if(sub<1000)
        sub = sprintf('%04d',sub);
    else
        sub = num2str(sub);
    end
    disp('Reading in subject electrode coordinates)')
    electrode_coordinates_mni_path = strcat('/gdrive/public/DATA/Human_Data/BIDS/sub-RID',sub,'/processed/eeg/electrode_localization/electrodenames_coordinates_mni.csv')
    eCoord = round(worldToVoxel(electrode_coordinates_mni_path,MNItemp));
    isWhite = classifyByAAL(eCoord,AAL_600Data);
    for n = 1:length(nodes)
        disp('Starting analysis for Node')
        node = nodes(n);
        if(node<100)
            node2 = sprintf('%03d',node);
        else
            node2 = num2str(node);
        end
        if(node<1000)
            node = sprintf('%04d',node);
        else
            node = num2str(node);
        end
        for num = 1:permNumber
            if(num<1000)
                permStr = sprintf('%04d',num);
            else
                permStr = num2str(num);
            end

            atlas_path = strcat('/gdrive/public/TOOLS/atlases_and_templates/atlases/custom_atlases/random_atlases/whole_brain/RA_N',node,'/RA_N',node2,'_Perm',permStr,'.nii.gz');
            atlas = load_nii(atlas_path);
            % convert the electrode coordinates from world to voxel space
            region = zeros(size(eCoord,1),1);
            %cents = getCentroids(atlas);

            for i = 1:size(eCoord,1)
                electrode_coordinate = eCoord(i,:);
                region(i) = atlas.img(electrode_coordinate(1),electrode_coordinate(2),electrode_coordinate(3));
                %if region == 0 (i.e. electrode is outside of atlas labels), then find
                %closest ROI with a non-zero label)
                if region(i) == 0
                    %find coordinates with non-zero labels in atlas
                    [ind1, ind2, ind3] = ind2sub(size(atlas.img), find(atlas.img > 0));
                    coord_non_zero = [ind1, ind2, ind3];
                    %find the euclidean distance to all the non-zero atlas label coordinatesf from the region == 0
                    dist2 = sum((electrode_coordinate - coord_non_zero) .^ 2, 2);
                    %find the smallest distance to a non-zero atlas label:
                    closest = coord_non_zero(dist2 == min(dist2),:);
                    closest = closest(1,:,:); %pick the first closest if there are >1 closest
                    %replace the region ==0 with the closest non-zero atlas label
                    region(i) = atlas.img(closest(1), closest(2),closest(3));
                else
                    region(i) = region(i);
                end
            end
            region = num2cell(region);


            electrodeROIs = readtable(electrode_coordinates_mni_path);
            electrodeROIs = electrodeROIs(:,1);
            electrodeROIs = table2array(electrodeROIs);
            electrodeROIs(:,2) = region;
            electrodeROIs(:,3) = num2cell(isWhite);
            
            electrodeROIs = cell2table(electrodeROIs);
            output_csv_path = strcat('/gdrive/public/TOOLS/atlases_and_templates/atlases/custom_atlases/random_atlases/whole_brain/RA_N',node,'/RA_N',node,'_Perm',permStr,'_Sub',sub,'ElectrodeRegions.xlsx');
            writetable(electrodeROIs,output_csv_path, 'WriteVariableNames', false);
        end
    end

end

end
