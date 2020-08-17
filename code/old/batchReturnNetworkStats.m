function batchReturnNetworkStats(subs,nodes,strucPerms,outputPath)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
summaryData = zeros(length(subs)*length(nodes)*strucPerms,9);
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
    genPath = strcat('/gdrive/public/DATA/Human_Data/BIDS_processed/sub-RID',subStr,'/connectivity_matrices/');
    % loop over the number of events for each subject
    % loop over the nodes in the atlases that we want to try 
    for k = 1:length(nodes)
        % pull off the node and convert to its string format... the way
        % the BIDS was set up, we also need it to 3. 
        node = nodes(k);
        if(node<1000)
            nodeStr = sprintf('%04d',node);
        else
            nodeStr = num2str(node);
        end
        if(node<100)
            node3 = sprintf('%03d',node);
        else
            node3 = num2str(node);
        end
        disp(strcat('Starting Analysis for Node ', nodeStr))
        for l = 1:strucPerms
            if(l<1000)
                permStr = sprintf('%04d',l);
            else
                permStr = num2str(l);
            end
            try
                strucPath = strcat(genPath,'structural/RA_N',nodeStr,'/sub-RID',subStr,'_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.RA_N',node3,'_Perm',permStr,'.count.pass.connectivity.mat');
                load(strucPath,'connectivity')
            catch
                disp('Caught an error')
                strucPath = strcat(genPath,'structural/RA_N',nodeStr,'/sub-RID',subStr,'_ses-preop3T_dwi-eddyMotionB0Corrected.nii.gz.trk.gz.RA_N',nodeStr,'_Perm',permStr,'.count.pass.connectivity.mat');
                load(strucPath,'connectivity')
            end
            % run the network stat analysis. 
            [charPath,clust,degree,smallWorld,normCharPath,normClust] = returnNetworkStats(connectivity);
            summaryData(overallCount,:) = [sub,node,l,charPath,clust,degree,smallWorld,normCharPath,normClust];
            overallCount = overallCount + 1; 
        end
    end
end
outputPath = strcat(outputPath,'networkStats.mat');
save(outputPath,'summaryData')



end

