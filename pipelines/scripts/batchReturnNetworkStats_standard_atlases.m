function batchReturnNetworkStats_templates(subs,outputPath)
%subs: RID numbers of subjects to analyze
%templist: list of the templates to analyze 
%outputPath: where to save the data
% tempList = ["AAL600", "aal_res-1x1x1", "JHU_res-1x1x1", "CPAC200_res-1x1x1", "desikan_res-1x1x1", "DK_res-1x1x1",...
%     "Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm", "Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm",...
%     "Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm", "Schaefer2018_300Parcels_17Networks_order_FSLMNI152_1mm",...
%     "Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm", "Talairach_res-1x1x1"];
tempList = ["JHU_aal_combined_res-1x1x1"];
summaryData = zeros(length(subs)*length(tempList),7);
overallCount = 1; 
for i = 1:length(subs)
    sub = subs(i);
    if(sub<1000)
        subStr = sprintf('%04d',sub);
    else
        subStr = num2str(sub);
    end
    disp(strcat('Starting Analysis for ',subStr))
    % general path that we are working on in borel 
    genPath = strcat('/gdrive/public/DATA/Human_Data/BIDS_processed/sub-RID',subStr,'/connectivity_matrices/structural/');
    % loop over the number of events for each subject
    % loop over the nodes in the atlases that we want to try 
    for k = 1:length(tempList)
        % pull off the node and convert to its string format... the way
        % the BIDS was set up, we also need it to 3. 
        temp = tempList(k);
        try
            strucPath = strcat(genPath,temp,'/sub-RID',subStr,'_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.',temp,'.count.pass.connectivity.mat');
            load(strucPath,'connectivity')
        catch 
            strucPath = strcat(genPath,temp,'/sub-RID',num2str(sub),'_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.',temp,'.count.pass.connectivity.mat');
            load(strucPath,'connectivity')   
        end
        %run the network stat analysis. 
        [charPath,clust,degree,smallWorld,normCharPath,normClust] = returnNetworkStats(connectivity);
        summaryData(overallCount,:) = [sub,charPath,clust,degree,smallWorld,normCharPath,normClust];
        overallCount = overallCount + 1; 
    end
end

outputPath = strcat(outputPath,'networkStats.mat');
save(outputPath,'summaryData')



end

