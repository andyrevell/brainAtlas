function [charPath,clust,degree,smallWorld,normCharPath,normClust] = returnNetworkStats(adj)
%%%%%% INPUT %%%%%%%%
%1) adj-An adjacency matrix
%%%%%% OUTPUT %%%%%%%
%1)charPath- characteristic path length
%2) clust- clustering coefficient
%3) degree- mean degree 
%4) smallWorld-normalized small world measure
% normalized copy of the matrix 
binNorm = weight_conversion(adj,'binarize');
% get the distances
distMat = distance_bin(binNorm);
% If there are any disjointed nodes set them equal to the largest non-Inf
% length
distMat(distMat==Inf) = -1;
distMat(distMat==-1) = max(distMat,[],'all');
% get the characteristic, average shortest path length. 
cPath = charpath(distMat);
% get the clustering coeff 
avgClust = mean(clustering_coef_bu(binNorm));
% get the avg Degree 
avgDegree = mean(degrees_und(adj));
% get normalized small world measure based on random graph. 
randomClust = avgDegree/size(adj,1);
randomPath  = log(size(adj,1))/log(avgDegree);
sigma=(avgClust/randomClust)/(cPath/randomPath);
normClust =(avgClust/randomClust);
normCharPath = (cPath/randomPath);
% Assign outputs 
smallWorld = sigma;
degree = avgDegree;
clust = avgClust;
charPath = cPath;
end

