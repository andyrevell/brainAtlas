"""
2020.05.06
Andy Revell and Alex Silva
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Purpose:
    Calculate functional correlations between given time series data and channels.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Logic of code:
    1. Calculate correlations within a given time window: Window data in 1 second
    2. Calculate broadband functional connectivity with echobase broadband_conn
    3. Calculate other band functional connectivity with echobase multiband_conn
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Input:
    inputfile: a pickled list. See get_iEEG_data.py and https://docs.python.org/3/library/pickle.html for more information
        index 0: time series data N x M : row x column : time x channels
        index 1: fs, sampling frequency of time series data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Output:
    Saves file outputfile as a pickel. For more info on pickeling, see https://docs.python.org/3/library/pickle.html
    Briefly: it is a way to save + compress data. it is useful for saving lists, as in a list of time series data and sampling frequency together along with channel names

    List index 0: ndarray. broadband. C x C x T. C: channels. T: times (1 second intervals). To change, see line 70: endInd = int(((t+1)*fs) - 1)
    List index 1: ndarray. alphatheta. C x C x T
    List index 2: ndarray. beta. C x C x T
    List index 3: ndarray. lowgamma. C x C x T
    List index 4: ndarray. highgamma. C x C x T
    List index 5: ndarray. C x _  Electrode row and column names. Stored here are the corresponding row and column names in the matrices above.
    List index 6: pd.DataFrame. N x 1. order of matrices in pickle file. The order of stored matrices are stored here to aid in transparency.
        Typically, the order in broadband, alphatheta, beta, lowgamma, highgamma

    To open the pickle file, use command:
    with open(outputfile, 'rb') as f: broadband, alphatheta, beta, lowgamma, highgamma, electrode_row_and_column_names, order_of_matrices_in_pickle_file = pickle.load(f)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Example:

inputfile = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/eeg/sub-RID0278_HUP138_phaseII_248432340000_248525740000_EEG.pickle'
outputfile = '/Users/andyrevell/mount/DATA/Human_Data/BIDS_processed/sub-RID0278/connectivity_matrices/functional/sub-RID0278_HUP138_phaseII_248432340000_248525740000_functionalConnectivity.pickle'
get_Functional_connectivity(inputfile,outputfile)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Please use this naming convention if data is from iEEG.org
sub-RIDXXXX_iEEGFILENAME_STARTTIME_STOPTIME_functionalConnectivity.pickle
example: 'sub-RID0278_HUP138_phaseII_248432340000_248525740000_functionalConnectivity.pickle'

"""
import numpy as np
import nibabel as nib
import os

def grassfireAlgorithm(edgePoints,atlas,vols):
    dims = atlas.shape
    if((edgePoints.shape[0]*7) < (dims[0]*dims[1]*dims[2])):
        newEdgePoints = np.zeros((edgePoints.shape[0]*7, 4))
    else:
        newEdgePoints = np.zeros((dims[0]*dims[1]*dims[2],4))
    counter = 1
    dimsEdge = edgePoints.shape
    
    
    
    for i in range(0,dimsEdge[0]):
        point = edgePoints[i,:].astype(int)
        # step in positive x
        if((point[0]+1)<dims[0]):
            if(atlas[point[0]+1,point[1],point[2]]==0):
                newEdgePoints[counter,:] = [point[0]+1,point[1],point[2], point[3]]
                atlas[point[0]+1,point[1],point[2]]= point[3]
                counter = counter + 1
                vols[point[3]-1] = vols[point[3]-1]+1
        # step in negative x
        if((point[0]-1)>=0):
            if(atlas[point[0]-1,point[1],point[2]]==0):
                newEdgePoints[counter,:] = [point[0]-1,point[1],point[2], point[3]]
                atlas[point[0]-1,point[1],point[2]]= point[3]
                counter = counter + 1
                vols[point[3]-1] = vols[point[3]-1]+1
        # step in positive y
        if((point[1]+1)<dims[1]):
            if(atlas[point[0],point[1]+1,point[2]]==0):
                newEdgePoints[counter,:] = [point[0],point[1]+1,point[2], point[3]]
                atlas[point[0],point[1]+1,point[2]]= point[3]
                counter = counter + 1
                vols[point[3]-1] = vols[point[3]-1]+1
        # step in negative y
        if((point[1]-1)>=0):
            if(atlas[point[0],point[1]-1,point[2]]==0):
                newEdgePoints[counter,:] = [point[0],point[1]-1,point[2], point[3]]
                atlas[point[0],point[1]-1,point[2]]= point[3]
                counter = counter + 1
                vols[point[3]-1] = vols[point[3]-1]+1
        # step in positive z
        if((point[2]+1)<dims[2]):
            if(atlas[point[0],point[1],point[2]+1]==0):
                newEdgePoints[counter,:] = [point[0],point[1],point[2]+1, point[3]]
                atlas[point[0],point[1],point[2]+1]= point[3]
                counter = counter + 1
                vols[point[3]-1] = vols[point[3]-1]+1
        # step in negative x
        if((point[2]-1)>=0):
            if(atlas[point[0],point[1],point[2]-1]==0):
                newEdgePoints[counter,:] = [point[0],point[1],point[2]-1, point[3]]
                atlas[point[0],point[1],point[2]-1]= point[3]
                counter = counter + 1
                vols[point[3]-1] = vols[point[3]-1]+1
                
    newEdgePoints = newEdgePoints[~np.all(newEdgePoints == 0, axis=1)]
    extraCol = np.zeros((newEdgePoints.shape[0],1))
    newEdgePoints = np.concatenate((newEdgePoints,extraCol),axis=1)
    if(newEdgePoints.shape[0]>1):
        for i in range(0,newEdgePoints.shape[0]):
            newEdgePoints[i,4] = vols[int(newEdgePoints[i,3]-1)]                                          
                                      
    newEdgePoints = newEdgePoints[newEdgePoints[:,4].argsort()]       
    return(newEdgePoints,atlas,vols)

def generateRandomAtlases_wholeBrain(nodeNumber,numPerm,saveDir,MNItemp_path):
    #generateRandomAtlases_wholeBrain(1000,3,'/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases/custom_atlases/random_atlases/whole_brain/RA_N1000/tmp/','/Users/andyrevell/mount/TOOLS/atlases_and_templates/templates/MNI152_T1_1mm_brain.nii.gz')
    print('\n##########################################\n')
    print('##########################################\n')
    print('Starting generateRandomAtlases_wholeBrain\n')
    print('##########################################\n')
    print('##########################################\n')
    print('Loading Template \n')
    MNItemp_path = nib.load(MNItemp_path)
    T1_data = MNItemp_path.get_fdata() #getting actual image data array
    atlas = np.zeros(T1_data.shape)
    dimOrig = atlas.shape
    print('Geting all the points in the template that are not CSF or outside of brain \n')
    brainPoints = np.zeros((dimOrig[0]*dimOrig[1]*dimOrig[2],4))
    rowCount = 1
    for i in range(0,dimOrig[0]):
        for j in range(0,dimOrig[1]):
            for k in range(0,dimOrig[2]):
                
                if(T1_data[i,j,k]>2000):
                    #This was the cutoff we found optimal
                    brainPoints[rowCount,:] = [i,j,k,T1_data[i,j,k]]
                    rowCount = rowCount + 1
                else: 
                    atlas[i,j,k] = -1
    
    brainPoints = brainPoints[~np.all(brainPoints == 0, axis=1)]
    print('\nGenerating Random Atlases: \n')
    for j in range(0,numPerm):
        nodeNumber_str = '{:03}'.format(nodeNumber)
        permNumber_str = '{:04}'.format(j+1)
        print("RA_N{0}_Perm{1}.nii.gz".format(nodeNumber_str,permNumber_str))
        currentAtlas = atlas.copy()
        # choose n random start points inside brain
        indexstartPoints = np.random.choice(brainPoints.shape[0],nodeNumber,replace=False)
        startPoints = brainPoints[indexstartPoints,0:3]
        extraCols = np.zeros((startPoints.shape[0],2))
        startPoints = np.concatenate((startPoints,extraCols),axis=1)
        for i in range(0,startPoints.shape[0]):
            startPoints[i,3] = i+1
            startPoints[i,4] = 1
            point = startPoints[i,:]
            currentAtlas[int(point[0]),int(point[1]),int(point[2])] = point[3]
        
        vols = np.ones((startPoints.shape[0],1))
        print('Expanding seeds with Grassfire Algorithm\n')
        while(startPoints.size !=0):
            startPoints,currentAtlas,vols=grassfireAlgorithm(startPoints,currentAtlas,vols)
            
        #print('Atlas percent filled: {0} \n'.format(round(nnz(currentAtlas(:))/length(currentAtlas(:))*100,3) )) 
        currentAtlas[currentAtlas == -1] = 0  
        # write out the atlas to file \
        cur_nifti_img = nib.Nifti1Image(currentAtlas, MNItemp_path.affine)
        filepath = "{0}RA_N{1}_Perm{2}.nii.gz".format(saveDir,nodeNumber_str,permNumber_str)
        if((os.path.exists(saveDir))==False):
            os.mkdir(saveDir) 
            
        nib.save(cur_nifti_img, filepath)
        
def generateRandomAtlases_wholeBrain_tissue_seg_based(nodeNumber,numPerm,saveDir,MNItemp_path,tissue_seg_path):
    #generateRandomAtlases_wholeBrain(1000,3,'/Users/andyrevell/mount/TOOLS/atlases_and_templates/atlases/custom_atlases/random_atlases/whole_brain/RA_N1000/tmp/','/Users/andyrevell/mount/TOOLS/atlases_and_templates/templates/MNI152_T1_1mm_brain.nii.gz')
    print('\n##########################################\n')
    print('##########################################\n')
    print('Starting generateRandomAtlases_wholeBrain\n')
    print('##########################################\n')
    print('##########################################\n')
    print('Loading Template \n')
    MNItemp_path = nib.load(MNItemp_path)
    T1_data = MNItemp_path.get_fdata() #getting actual image data array
    atlas = np.zeros(T1_data.shape)
    dimOrig = atlas.shape
    # load in the tissue segmentation 
    tissue_seg = nib.load(tissue_seg_path)
    tissue_data = tissue_seg.get_fdata()
    print('Geting all the points in the template that are not CSF or outside of brain \n')
    brainPoints = np.zeros((dimOrig[0]*dimOrig[1]*dimOrig[2],4))
    rowCount = 1
    for i in range(0,dimOrig[0]):
        for j in range(0,dimOrig[1]):
            for k in range(0,dimOrig[2]):
                
                if(tissue_seg[i,j,k]>0):
                    #This was the cutoff we found optimal
                    brainPoints[rowCount,:] = [i,j,k,T1_data[i,j,k]]
                    rowCount = rowCount + 1
                else: 
                    atlas[i,j,k] = -1
    
    brainPoints = brainPoints[~np.all(brainPoints == 0, axis=1)]
    print('\nGenerating Random Atlases: \n')
    for j in range(0,numPerm):
        nodeNumber_str = '{:03}'.format(nodeNumber)
        permNumber_str = '{:04}'.format(j+1)
        print("RA_N{0}_Perm{1}.nii.gz".format(nodeNumber_str,permNumber_str))
        currentAtlas = atlas.copy()
        # choose n random start points inside brain
        indexstartPoints = np.random.choice(brainPoints.shape[0],nodeNumber,replace=False)
        startPoints = brainPoints[indexstartPoints,0:3]
        extraCols = np.zeros((startPoints.shape[0],2))
        startPoints = np.concatenate((startPoints,extraCols),axis=1)
        for i in range(0,startPoints.shape[0]):
            startPoints[i,3] = i+1
            startPoints[i,4] = 1
            point = startPoints[i,:]
            currentAtlas[int(point[0]),int(point[1]),int(point[2])] = point[3]
        
        vols = np.ones((startPoints.shape[0],1))
        print('Expanding seeds with Grassfire Algorithm\n')
        while(startPoints.size !=0):
            startPoints,currentAtlas,vols=grassfireAlgorithm(startPoints,currentAtlas,vols)
            
        #print('Atlas percent filled: {0} \n'.format(round(nnz(currentAtlas(:))/length(currentAtlas(:))*100,3) )) 
        currentAtlas[currentAtlas == -1] = 0  
        # write out the atlas to file \
        cur_nifti_img = nib.Nifti1Image(currentAtlas, MNItemp_path.affine)
        filepath = "{0}RA_N{1}_Perm{2}.nii.gz".format(saveDir,nodeNumber_str,permNumber_str)
        if((os.path.exists(saveDir))==False):
            os.mkdir(saveDir) 
            
        nib.save(cur_nifti_img, filepath)
        
def batch_generateRandomAtlases_wholeBrain(nodeNumbers,numPerm,saveDir,MNItemp_path):
    for node in nodeNumbers:
        saveDirNode = saveDir + 'RA_N' + '{:04}'.format(node) + '/'
        generateRandomAtlases_wholeBrain(node,numPerm,saveDirNode,MNItemp_path)


        

               