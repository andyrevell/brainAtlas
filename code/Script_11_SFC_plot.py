"""
2020.01.01
Andy Revell
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Logic of code:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Input:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Output:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Example:
    python3.6 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"""

#%%
path = "/mnt" #/mnt is the directory in the Docker or Singularity Continer where this study is mounted
path = "/Users/andyrevell/deepLearner/home/arevell/Documents/01_papers/paper001"
import sys
import os
from os.path import join as ospj
sys.path.append(ospj(path, "brainAtlas/code/tools"))
import pandas as pd
import numpy as np
import seaborn as sns
import copy
import matplotlib.pyplot as plt
import scipy.stats

#%% Paths and File names

ifname_EEG_times = ospj(path, "data/data_raw/iEEG_times/EEG_times.xlsx")
ifpath_atlases_standard = ospj( path, "data/data_raw/atlases/standard_atlases")
ifpath_atlases_random = ospj( path, "data/data_raw/atlases/random_atlases")
ofpath_SFC_processed = ospj( path, "data/data_processed/structure_function_correlation_processed")
ofpath_SFC_population_averages = ospj( ofpath_SFC_processed, "SFC_population_averages")

ofpath_figure = ospj( path,  "brainAtlas", "figures", "average_all_seizures")


#%%Load Data
data = pd.read_excel(ifname_EEG_times)    
sub_ID_unique = np.unique(data.RID)


atlas_names_standard = [f for f in sorted(os.listdir(ifpath_atlases_standard))]
atlas_names_random = [f for f in sorted(os.listdir(ifpath_atlases_random))]

data_original    =  pd.read_csv(ospj(ofpath_SFC_population_averages, "all_SFC_data.csv"), sep=",")              

data = copy.deepcopy(data_original)

#%%

cols = ["subject", "atlas", "seizure", "period", "frequency", "period_index", "SFC"]
np.unique(data.atlas)
np.unique(data.frequency)
np.unique(data.subject)

#%%
gap = 20
data.period_index += np.where(data.period.eq("preictal"), 100 + gap,0)
data.period_index += np.where(data.period.eq("ictal"), 200 + gap,0)
data.period_index += np.where(data.period.eq("postictal"), 300 + gap,0)


#%%
# Making seizure colors and moving the order around so they look good
color = sns.color_palette("coolwarm", 4)
tmp = color[2]
color[2] = color[3]
color[3] = tmp

tmp = color[0]
color[0] = color[1]
color[1] = tmp
freq = np.unique(data.frequency)
freq_label = ["Alpha/Theta", "Beta", "Broadband", "High Gamma", "Low Gamma"]

for f in range(len(freq)):

    
    data_broadband = data[data.frequency.eq(freq[f])]
    data_alphatheta = data[data.frequency.eq("alphatheta")]
    data_beta = data[data.frequency.eq("beta")]
    data_lowgamma = data[data.frequency.eq("lowgamma")]
    data_highgamma = data[data.frequency.eq("highgamma")]
    
    data_broadband_AAL = data_broadband[data_broadband.atlas.eq("aal_res-1x1x1")]
    data_broadband_AAL600 = data_broadband[data_broadband.atlas.eq("AAL600")]
    data_broadband_Schaefer0100 = data_broadband[data_broadband.atlas.eq("Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm")]
    data_broadband_Schaefer0400 = data_broadband[data_broadband.atlas.eq("Schaefer2018_400Parcels_17Networks_order_FSLMNI152_1mm")]
    data_broadband_Schaefer1000 = data_broadband[data_broadband.atlas.eq("Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm")]
    data_broadband_desikan = data_broadband[data_broadband.atlas.eq("desikan_res-1x1x1")]
    data_broadband_DKT = data_broadband[data_broadband.atlas.eq("DK_res-1x1x1")]
    data_broadband_JHU = data_broadband[data_broadband.atlas.eq("JHU_res-1x1x1")]
    data_broadband_AAL_JHU = data_broadband[data_broadband.atlas.eq("AAL_JHU_combined_res-1x1x1")]
    data_broadband_CPAC = data_broadband[data_broadband.atlas.eq("CPAC200_res-1x1x1")]
    data_broadband_RandomAtlas0000010 = data_broadband[data_broadband.atlas.eq("RandomAtlas0000010")]
    data_broadband_RandomAtlas0000030 = data_broadband[data_broadband.atlas.eq("RandomAtlas0000030")]
    data_broadband_RandomAtlas0000100 = data_broadband[data_broadband.atlas.eq("RandomAtlas0000100")]
    data_broadband_RandomAtlas0001000 = data_broadband[data_broadband.atlas.eq("RandomAtlas0001000")]
    data_broadband_RandomAtlas0005000 = data_broadband[data_broadband.atlas.eq("RandomAtlas0005000")]
    data_broadband_RandomAtlas0010000 = data_broadband[data_broadband.atlas.eq("RandomAtlas0010000")]
    
    
    
    
    
    
    sns.set_style("dark", {"ytick.left": True, "xtick.bottom": True })
    sns.set_context("paper", font_scale=1.4, rc={"lines.linewidth": 0.75})
    
    fig9 = plt.figure(constrained_layout=False, dpi=300, figsize=(6, 4))
    gs1 = fig9.add_gridspec(nrows=3, ncols=3, left=0.1, right=0.440, bottom=0.425, top=0.92, wspace=0.02, hspace = 0.2)
    f9_ax1 = fig9.add_subplot(gs1[:, :])
    
    gs2 = fig9.add_gridspec(nrows=2, ncols=3, left=0.45, right=0.99, bottom=0.425, top=0.92, wspace=0.02, hspace = 0.05)
    f9_ax2 = fig9.add_subplot(gs2[0, 0])
    f9_ax3 = fig9.add_subplot(gs2[0, 1])
    f9_ax4 = fig9.add_subplot(gs2[0, 2])
    f9_ax5 = fig9.add_subplot(gs2[1, 0])
    f9_ax6 = fig9.add_subplot(gs2[1, 1])
    f9_ax7 = fig9.add_subplot(gs2[1, 2])
    
    
    gs3 = fig9.add_gridspec(nrows=1, ncols=2, left=0.1, right=0.440, bottom=0.05, top=0.375, wspace=0.02, hspace=0.05)
    f9_ax8 = fig9.add_subplot(gs3[0, 0])
    f9_ax9 = fig9.add_subplot(gs3[0, 1])
    
    gs4 = fig9.add_gridspec(nrows=1, ncols=3, left=0.45, right=0.99, bottom=0.05, top=0.375, wspace=0.02, hspace=0.05)
    f9_ax10 = fig9.add_subplot(gs4[0, 0])
    f9_ax11 = fig9.add_subplot(gs4[0, 1])
    f9_ax12 = fig9.add_subplot(gs4[0, 2])
    
    
    
    axes = [f9_ax1, f9_ax2, f9_ax3, f9_ax4, f9_ax5, f9_ax6, f9_ax7, f9_ax8, f9_ax9, f9_ax10, f9_ax11, f9_ax12]
    
    plt1 = data_broadband_AAL
    plt2 = data_broadband_AAL600
    plt3 = data_broadband_AAL_JHU
    plt4 = data_broadband_desikan
    plt5 = data_broadband_Schaefer0100
    plt6 = data_broadband_Schaefer0400
    plt7 = data_broadband_Schaefer1000
    plt8 = data_broadband_RandomAtlas0000010
    plt9 = data_broadband_RandomAtlas0000030
    plt10 = data_broadband_RandomAtlas0000100
    plt11 = data_broadband_RandomAtlas0001000
    plt12 = data_broadband_RandomAtlas0010000
    plots = [plt1, plt2, plt3, plt4, plt5, plt6, plt7, plt8, plt9, plt10, plt11, plt12]
    
    atlas_labels = ["Standard AAL atlas", "AAL600", "AAL-JHU", "Desikan", "Schaefer 100", "Schaefer 400", "Schaefer 1,000", 
                    "Random Atlas \n10", "Random Atlas \n30", "Random Atlas \n100", "Random Atlas \n1,000", "Random Atlas \n10,000"]
    
    ylim = [-0.05, 0.45]
    for s in range(len(plots)):
             
        df =   plots[s]
        
        
        sns.lineplot(data =df,  x = "period_index", y = "SFC", hue= "period" ,  ax = axes[s], legend = False, ci = 95, n_boot = 1000, palette= color)
        #plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
        axes[s].set_ylim(ylim)
        axes[s].set_ylabel('')    
        axes[s].set_xlabel('')
    
        #writing interictal, pretictal, ictal, postictal labels
        xlim = axes[s].get_xlim()
        if s == 0:
            mult_factor_x = 17
            mult_factor_y = 0.9
            axes[s].text(x = (xlim[0] + 100 + gap)/2, y = ylim[1]*mult_factor_y, s = "inter", va='baseline', ha = "center")
            axes[s].text(x = (-xlim[0] + gap + 100 + 200)/2, y = ylim[1]*mult_factor_y, s = "pre", va='baseline', ha = "center")
            axes[s].text(x = (-xlim[0] + gap + 200 + 300)/2, y = ylim[1]*mult_factor_y, s = "ictal", va='baseline', ha = "center")
            axes[s].text(x = (gap + 300 + xlim[1])/2, y = ylim[1]*mult_factor_y, s = "post", va='baseline', ha = "center")  
            
        vertical_line = [100+ gap, 200 + gap, 300 + gap]
        for x in vertical_line:
            axes[s].axvline(x, color='k', linestyle='--', lw = 0.5)
            
        axes[s].set(xticklabels=[], xticks=[])
        axes[s].set(yticklabels=[], yticks=[0, 0.1 ,0.2, 0.3, 0.4 ])    
        axes[s].tick_params(axis='both', which='both', length=2.75, direction = "in")
        #setting ticks
        if s == 0:
            axes[s].set(yticklabels=["0.0", 0.1, 0.2, 0.3, ""], yticks=[0, 0.1 ,0.2, 0.3, 0.4 ]) 
            axes[s].tick_params(axis='both', which='both', length=6, labelcolor = "black", labelsize = 8)
            
        if s == 0 or s == 7:
            axes[s].set(yticklabels=["0.0", 0.1, 0.2, 0.3, 0.4], yticks=[0, 0.1 ,0.2, 0.3, 0.4 ]) 
            axes[s].tick_params(axis='y', which='both', length=6, labelcolor = "black", labelsize = 8)
        if s == 0:
            axes[s].set(xticklabels=["-100", "0", "100"], xticks=[100 +gap, 200+gap, 300 + gap ]) 
            axes[s].tick_params(axis='x', which='both', length=0, labelcolor = "black", labelsize = 8)
            
            
        
        #Setting plot titles
        if s == 0:
            axes[s].text(x = (xlim[0] + xlim[1])/2, y = ylim[0] + (ylim[1] - ylim[0])*0.05 , fontsize = 15, s = atlas_labels[s], va='baseline', ha = "center")
            
        if s >=1 and s < 7:
            axes[s].text(x = (xlim[0] + xlim[1])/2, y = ylim[0] + (ylim[1] - ylim[0])*0.05 , fontsize = 8, s = atlas_labels[s], va='baseline', ha = "center")
            
        if s >=7:
            axes[s].text(x = (xlim[0] + xlim[1])/2, y = ylim[1] - (ylim[1] - ylim[0])*0.05 , fontsize = 8, s = atlas_labels[s], va='top', ha = "center")
            
                   
        #Setting A and B labels    
        if s == 0:
            axes[s].text(xlim[0]-83, ylim[1], 'A.', ha='right', va = "top", fontsize = 15, fontweight = 'bold')
        if s == 7:
            axes[s].text(xlim[0]-180, ylim[1], 'B.', ha='right', va = "top", fontsize = 15, fontweight = 'bold')
    
    
    
    fig9.text(0.5, 0.01, 'Time (interpolated to 100 a.u.)', ha='center', fontsize = 8)
    fig9.text(0.04, 0.5, 'Spearkman Rank Correlation', ha='left',  va = "center", rotation = 'vertical', fontsize = 8)
    
        
    fig9.text(0.5, 0.99, 'Average All Seizures ({0})'.format(freq_label[f]), ha='center', va = "top")
    
    fig9.savefig(ospj(ofpath_figure, "average_all_seizures_{0}".format(freq[f])))
            
#%%



#Grouping/averaging each period's 100 points together
Data_mean = data.groupby(['subject','atlas', "seizure", "period", "frequency"])["SFC"].mean().reset_index()

#Getting volumes and sphericity data
volumes_and_sphericity_means    =  pd.read_csv( ospj(path, "data_processed/volumes_and_sphericity_means/volumes_and_sphericity.csv"), sep=",")    
volumes_and_sphericity_means.columns = ["atlas", volumes_and_sphericity_means.columns[1], volumes_and_sphericity_means.columns[2]]
volumes_and_sphericity_means.volume_voxels = np.log10(volumes_and_sphericity_means.volume_voxels)

#adding volume and sphericity data to the mean data
Data_mean = pd.merge(Data_mean,volumes_and_sphericity_means, on="atlas"  )

#%%
f = 2
for f in range(len(freq)):
    #Getting just interictal data for figure 7A (baseline SFC)
    Data_mean_interictal = Data_mean[Data_mean.period.eq("interictal")]
    
    
    #Getting just frequency specific data for figure 7A
    Data_mean_interictal_broadband = Data_mean_interictal[Data_mean_interictal.frequency.eq(freq[f])]
    
    #Getting random atlas data
    Data_mean_interictal_broadband_RandomAtlas = Data_mean_interictal_broadband.iloc[np.where(Data_mean_interictal_broadband["atlas"].str.contains("RandomAtlas"))[0],:]
    
    #Getting standard atlas data
    Data_mean_interictal_broadband_StandardAtlas = Data_mean_interictal_broadband.iloc[np.where(~Data_mean_interictal_broadband["atlas"].str.contains("RandomAtlas"))[0],:]
    #remove JHU
    Data_mean_interictal_broadband_StandardAtlas = Data_mean_interictal_broadband_StandardAtlas.iloc[np.where(~Data_mean_interictal_broadband_StandardAtlas["atlas"].str.contains("JHU_res-1x1x1"))[0],:]
    
    
    #Calculating Differences between ictal and preictal SFC
    
    #getting preictal and ictal data
    Data_mean_preictal = Data_mean[Data_mean.period.eq("preictal")]
    Data_mean_ictal = Data_mean[Data_mean.period.eq("ictal")]
    
    #Subtracting and making new dataframe with the difference
    Difference = np.array(Data_mean_ictal.SFC) -  np.array(Data_mean_preictal.SFC)
    Data_mean_difference = copy.deepcopy(Data_mean_ictal)
    Data_mean_difference.SFC = Difference
    
    #Getting just frequency specific data for figure 7C
    Data_mean_difference_broadband = Data_mean_difference[Data_mean_difference.frequency.eq(freq[f])]
    
    #Getting random atlas data
    Data_mean_difference_broadband_RandomAtlas = Data_mean_difference_broadband.iloc[np.where(Data_mean_difference_broadband["atlas"].str.contains("RandomAtlas"))[0],:]
    
    #Getting standard atlas data
    Data_mean_difference_broadband_StandardAtlas = Data_mean_difference_broadband.iloc[np.where(~Data_mean_difference_broadband["atlas"].str.contains("RandomAtlas"))[0],:]
    #remove JHU
    Data_mean_difference_broadband_StandardAtlas = Data_mean_difference_broadband_StandardAtlas.iloc[np.where(~Data_mean_difference_broadband_StandardAtlas["atlas"].str.contains("JHU_res-1x1x1"))[0],:]
    
    
    
    
    
    
    
    
    sns.set_style("dark", {"ytick.left": True, "xtick.bottom": True })
    sns.set_context("paper", font_scale=1.4, rc={"lines.linewidth": 0.75})
     
    fig10 = plt.figure(constrained_layout=False, dpi=300, figsize=(6, 4))
    gs1 = fig10.add_gridspec(nrows=1, ncols=1, left=0.08, right=0.4, bottom=0.52, top=0.89, wspace=0.02, hspace = 0.2)
    f10_ax1 = fig10.add_subplot(gs1[:, :])
    
    gs2 = fig10.add_gridspec(nrows=1, ncols=1, left=0.08, right=0.4, bottom=0.1, top=0.5, wspace=0.02, hspace = 0.05)
    f10_ax2 = fig10.add_subplot(gs2[:, :])
    
    
    gs3 = fig10.add_gridspec(nrows=2, ncols=6, left=0.45, right=0.99, bottom=0.52, top=0.89, wspace=0.05, hspace=0.05)
    
    f10_ax3 = fig10.add_subplot(gs3[0, 0])
    f10_ax4 = fig10.add_subplot(gs3[0, 1])
    f10_ax5 = fig10.add_subplot(gs3[0, 2])
    f10_ax6 = fig10.add_subplot(gs3[0, 3])
    f10_ax7 = fig10.add_subplot(gs3[0, 4])
    f10_ax8 = fig10.add_subplot(gs3[0, 5])
    f10_ax9 = fig10.add_subplot(gs3[1, 0])
    f10_ax10 = fig10.add_subplot(gs3[1, 1])
    f10_ax11 = fig10.add_subplot(gs3[1, 2])
    f10_ax12 = fig10.add_subplot(gs3[1, 3])
    f10_ax13 = fig10.add_subplot(gs3[1, 4])
    f10_ax14 = fig10.add_subplot(gs3[1, 5])
    
    gs4 = fig10.add_gridspec(nrows=2, ncols=7, left=0.45, right=0.99, bottom=0.1, top=0.50, wspace=0.05, hspace=0.05)
    f10_ax15 = fig10.add_subplot(gs4[0, 0])
    f10_ax16 = fig10.add_subplot(gs4[0, 1])
    f10_ax17 = fig10.add_subplot(gs4[0, 2])
    f10_ax18 = fig10.add_subplot(gs4[0, 3])
    f10_ax19 = fig10.add_subplot(gs4[0, 4])
    f10_ax20 = fig10.add_subplot(gs4[0, 5])
    f10_ax21 = fig10.add_subplot(gs4[0, 6])
    f10_ax22 = fig10.add_subplot(gs4[1, 0])
    f10_ax23 = fig10.add_subplot(gs4[1, 1])
    f10_ax24 = fig10.add_subplot(gs4[1, 2])
    f10_ax25 = fig10.add_subplot(gs4[1, 3])
    f10_ax26 = fig10.add_subplot(gs4[1, 4])
    f10_ax27 = fig10.add_subplot(gs4[1, 5])
    f10_ax28 = fig10.add_subplot(gs4[1, 6])
    
    
    axes = [f10_ax1, f10_ax2, f10_ax3, f10_ax4, f10_ax5, f10_ax6, f10_ax7, f10_ax8, f10_ax9, f10_ax10, f10_ax11, f10_ax12, f10_ax13, f10_ax14, f10_ax15, f10_ax16, f10_ax17, f10_ax18, f10_ax19, f10_ax20,f10_ax21, f10_ax22, f10_ax23, f10_ax24, f10_ax25, f10_ax26, f10_ax27, f10_ax28]
    
    standard_atlas_names = np.unique(Data_mean_difference_broadband_StandardAtlas.atlas)
    random_atlas_names = np.unique(Data_mean_difference_broadband_RandomAtlas.atlas)
    
    standard_atlas_names_labels = ["AAL600", "AAL-JHU", "CPAC", "DKT", "Schaefer \n1,000", "Schaefer \n100", "Schaefer \n200", "Schaefer \n300", "Schaefer \n400", "Talairach", "AAL", "Desikan   \n"]
    order_standard = [10, 0, 1, 2,3,11,5,6,7,8,4, 9]
    random_atlas_names_labels = ["Random\nAtlas\n10", "30", "50", "75", "100", "200", "300", "400", "500", "750", "1,000", "2,000", "5,000", "10,000"]
    
    colors_pre = sns.hls_palette(len(standard_atlas_names), l=.3, s=.7)
    colors_ic = sns.hls_palette(len(standard_atlas_names), l=.44, s=1)
    
    np.array(colors_pre)[order_standard]
    
    random_color = sns.color_palette("Blues_r", 10)[0]
    
    #Fig 7A
    df = Data_mean_interictal_broadband_RandomAtlas
    sns.lineplot(data =df,  x = "volume_voxels", y = "SFC" , legend = False, color= random_color,  linewidth=2, alpha = 0.3, ci = 95, marker="o", ax = axes[0])
    #ax = sns.scatterplot(data =df,  x = "volume_voxels", y = "SFC" , legend = False, color= "black",  linewidth=0, alpha = 0.6)
    
    
    
    for a in range(12):
        
        df = Data_mean_interictal_broadband_StandardAtlas[Data_mean_interictal_broadband_StandardAtlas.atlas.eq(standard_atlas_names[  order_standard[a] ]  )]
    
        #df = Data_mean_interictal_broadband_StandardAtlas
        sns.lineplot(data =df,  x = "volume_voxels", y = "SFC" ,color = np.array(colors_pre)[a]  ,  linewidth=2, alpha = 0.9, err_style="bars", marker="o", ax = axes[0])
    
        
    #Fig7B
    df = Data_mean_difference_broadband_RandomAtlas
    sns.lineplot(data =df,  x = "volume_voxels", y = "SFC" , legend = False, color= random_color,  linewidth=2, alpha = 0.3, ci = 95, marker="o", ax = axes[1])
    #ax = sns.scatterplot(data =df,  x = "volume_voxels", y = "SFC" , legend = False, color= "black",  linewidth=0, alpha = 0.6)
    
    for a in range(12):
        
        df = Data_mean_difference_broadband_StandardAtlas[Data_mean_difference_broadband_StandardAtlas.atlas.eq(standard_atlas_names[  order_standard[a] ]  )]
    
        #df = Data_mean_interictal_broadband_StandardAtlas
        sns.lineplot(data =df,  x = "volume_voxels", y = "SFC" ,color = np.array(colors_pre)[a]  ,  linewidth=2, alpha = 0.9, err_style="bars", marker="o", ax = axes[1])
    
    
    #df = Data_mean_difference_broadband_StandardAtlas
    #sns.lineplot(data =df,  x = "volume_voxels", y = "SFC" , hue = "atlas", legend = False, linewidth=2, alpha = 0.6, err_style="bars", marker="o", ax = axes[1])
    
    alpha = 0.05
    N_F = 26 * len(freq_label)
    
    
    ylim1 = [-0.015, 0.35]
    ylim2 = [-0.015, 0.175]
    ylim3 = [-0.05, 0.6]
    xlim = axes[0].get_xlim()
    axes[0] .set_ylim(ylim1)
    axes[0].set(xticklabels=[], xticks=[2,2.5,3,3.5,4,4.5,5])
    axes[0].set(yticklabels=["0.00", "0.10" ,"0.20", "0.30"], yticks=[0, 0.1 ,0.2, 0.3 ])  
    axes[0].set_ylabel('SFC',fontsize=8)    
    axes[0].set_xlabel('')
    axes[0].text((xlim[0]+xlim[1])/2, ylim1[1], 'SFC resting-state', ha='center', va = "top", fontsize = 10)    
    axes[0].text(xlim[0], ylim1[1], 'A.', ha='left', va = "top", fontsize = 15, fontweight = 'bold')    
    axes[0].tick_params(axis='x', which='both', length=3, labelcolor = "black", labelsize = 8, direction = "out")
    axes[0].tick_params(axis='y', which='both', length=3, labelcolor = "black", labelsize = 8, direction = "out")
    
    
    
    xlim = axes[1].get_xlim()
    axes[1] .set_ylim(ylim2)
    axes[1].set(xticklabels=[2,2.5,3,3.5,4,4.5,5], xticks=[2,2.5,3,3.5,4,4.5,5])
    axes[1].set(yticklabels=["0.00", 0.05, "0.10", 0.15], yticks=[0, 0.05, 0.1, 0.15]) 
    axes[1].set_ylabel('SFC difference',fontsize=8)    
    axes[1].set_xlabel('Volume (log10voxels or log10mm^3)',fontsize=8)
    axes[1].text((xlim[0]+xlim[1])/2, ylim2[1], 'SFC ictal-preictal \ndifference', ha='center', va = "top", fontsize = 10)    
    axes[1].text(xlim[0], ylim2[1], 'C.', ha='left', va = "top", fontsize = 15, fontweight = 'bold')    
    axes[1].tick_params(axis='x', which='both', length=3, labelcolor = "black", labelsize = 8, direction = "out")
    axes[1].tick_params(axis='y', which='both', length=3, labelcolor = "black", labelsize = 8, direction = "out")
     
    
    
    
    #Standard Atlas
    s= 2
    
    for a in range(len(standard_atlas_names) ):
        
        Data_mean_atlas = Data_mean[Data_mean.atlas.eq(standard_atlas_names[order_standard[a]])]
        Data_mean_atlas_broadband = Data_mean_atlas[Data_mean_atlas.frequency.eq(freq[f])]
        df = Data_mean_atlas_broadband
        sns.violinplot(x="period", y="SFC", data=df, order = [ "preictal", "ictal"], inner="quartile", ax = axes[s], palette=[colors_pre[a], colors_ic[a]])
        
    
        handles, labels = axes[s].get_legend_handles_labels()
        axes[s].legend(handles[:], labels[:])
        axes[s].legend([],[], frameon=False)
        axes[s] .set_ylim(ylim3) 
        axes[s].tick_params(axis='both', which='both', length=3, direction = "in")
        axes[s].set_ylabel('')    
        axes[s].set_xlabel('')
        
        xlim = axes[s].get_xlim()
        ylim = axes[s].get_ylim()
        if s == 2:
            axes[s].text(xlim[0]-1, 0.6, 'B.', ha='left', va = "top", fontsize = 15, fontweight = 'bold')    
    
        axes[s].set(xticklabels=[], xticks=[])
        axes[s].set(yticklabels=[], yticks=[0, 0.1 ,0.2, 0.3, 0.4, 0.5,0.6])  
        #title
        axes[s].text(xlim[0]+1, ylim[1]*0.95, standard_atlas_names_labels[order_standard[a]] , ha='center', va = "top", fontsize = 6) 
        
        
        #stats
        group1 = df.where(df.period== "preictal").dropna()['SFC']
        group2 = df.where(df.period== "ictal").dropna()['SFC']
    
        p_value = scipy.stats.wilcoxon(group1, group2)[1]
        print("{0} p-value: {1}              {2}".format(standard_atlas_names_labels[order_standard[a]], p_value,  p_value < alpha/N_F))
        if p_value *N_F < alpha:
            axes[s].text(xlim[0]+1, ylim[1]*1.22, "\n*", ha='center', va = "top", fontsize = 20, fontweight = 'bold')    
    
    
        
        
        
        s = s +1
        
    #Random Atlas
    for a in range(len(random_atlas_names) ):
        
        Data_mean_atlas = Data_mean[Data_mean.atlas.eq(random_atlas_names[a])]
        Data_mean_atlas_broadband = Data_mean_atlas[Data_mean_atlas.frequency.eq(freq[f])]
        df = Data_mean_atlas_broadband
        sns.violinplot(x="period", y="SFC", data=df, order = [ "preictal", "ictal"], inner="quartile", ax = axes[s], palette="Blues_r")
        
    
        handles, labels = axes[s].get_legend_handles_labels()
        axes[s].legend(handles[:], labels[:])
        axes[s].legend([],[], frameon=False)
        axes[s] .set_ylim(ylim3)
        axes[s].tick_params(axis='both', which='both', length=3, direction = "in")
        axes[s].set_ylabel('')    
        axes[s].set_xlabel('')
    
        xlim = axes[s].get_xlim()
        ylim = axes[s].get_ylim()
        if s == 24:
            axes[s].set(xticklabels=["pre", "ictal"])
            #axes[s].text(xlim[0]+0.5, ylim[0], 'pre', ha='center', va = "bottom", fontsize = 7)    
            #axes[s].text(xlim[0]+1.5, ylim[0], 'ictal', ha='center', va = "bottom", fontsize = 7)    
            axes[s].tick_params(axis='x', which='both', length=3, labelcolor = "black", labelsize = 8, direction = "out")
            axes[s].set_xlabel('Preictal vs Ictal SFC',fontsize=8)
            axes[s].set(yticklabels=[], yticks=[0, 0.1 ,0.2, 0.3, 0.4, 0.5, 0.6])  
        elif s == 21:
            axes[s].set(yticklabels=["0.0", 0.1, 0.2, 0.3, 0.4, 0.5], yticks=[0, 0.1 ,0.2, 0.3,0.4, 0.5,0.6])  
            axes[s].tick_params(axis='y', which='both', length=3, labelcolor = "black", labelsize = 8, direction = "in")
            axes[s].set(xticklabels=[], xticks=[])
        else:
            axes[s].set(xticklabels=[], xticks=[])
            axes[s].set(yticklabels=[], yticks=[0, 0.1 ,0.2, 0.3, 0.4, 0.5, 0.6])  
        #title
        axes[s].text(xlim[0]+1, ylim[1]*0.95, random_atlas_names_labels[a] , ha='center', va = "top", fontsize = 6)    
        
    
        
        #stats
        group1 = df.where(df.period== "preictal").dropna()['SFC']
        group2 = df.where(df.period== "ictal").dropna()['SFC']
        
        p_value = scipy.stats.wilcoxon(group1, group2)[1]
        #if reaches statistical significance 
        print("{0} p-value: {1}       {2}".format(random_atlas_names_labels[a], p_value,  p_value < alpha/N_F))
        if p_value *N_F < alpha:
            axes[s].text(xlim[0]+1, ylim[1]*1.22, "\n*", ha='center', va = "top", fontsize = 20, fontweight = 'bold')    
        
        
        
        
        s = s +1
     
        
     
        
     
    
     
        
     
        
    
    
    
    fig10.text(0.5, 0.99, 'Altases Capturing the Brain\'s \nStructure-Function Relationship ({0})'.format(freq_label[f]), ha='center', va = "top")
    fig10.savefig(ospj(ofpath_figure, "best_corresponding_atlas_{0}".format(freq[f])))

#%%

cols = ["subject", "atlas", "seizure", "period", "frequency", "period_index", "SFC"]

#%%
#Plotting frequency differences
"""
data_AAL = data[data.atlas.eq("aal_res-1x1x1")]
data_AAL600 = data[data.atlas.eq("AAL600")]
data_Schaefer1000 = data[data.atlas.eq("Schaefer2018_1000Parcels_17Networks_order_FSLMNI152_1mm")]
data_Schaefer0100 = data[data.atlas.eq("Schaefer2018_100Parcels_17Networks_order_FSLMNI152_1mm")]
data_desikan = data[data.atlas.eq("desikan_res-1x1x1")]
data_DKT = data[data.atlas.eq("DK_res-1x1x1")]
data_JHU = data[data.atlas.eq("JHU_res-1x1x1")]
data_AAL_JHU = data[data.atlas.eq("AAL_JHU_combined_res-1x1x1")]
data_RandomAtlas0000010 = data[data.atlas.eq("RandomAtlas0000010")]
data_RandomAtlas0000030 = data[data.atlas.eq("RandomAtlas0000030")]
data_RandomAtlas0000100 = data[data.atlas.eq("RandomAtlas0000100")]
data_RandomAtlas0001000 = data[data.atlas.eq("RandomAtlas0001000")]
data_RandomAtlas0005000 = data[data.atlas.eq("RandomAtlas0005000")]
data_RandomAtlas0010000 = data[data.atlas.eq("RandomAtlas0010000")]


fig10 = plt.figure(constrained_layout=False)
gs1 = fig10.add_gridspec(nrows=3, ncols=3, left=0.05, right=0.4, bottom=0.45, top=0.95, wspace=0.05)
f9_ax1 = fig10.add_subplot(gs1[:, :])

gs2 = fig10.add_gridspec(nrows=2, ncols=3, left=0.45, right=0.98, bottom=0.45, top=0.95,hspace=0.05)
f9_ax2 = fig10.add_subplot(gs2[0, 0])
f9_ax3 = fig10.add_subplot(gs2[0, 1])
f9_ax4 = fig10.add_subplot(gs2[0, 2])
f9_ax5 = fig10.add_subplot(gs2[1, 0])
f9_ax6 = fig10.add_subplot(gs2[1, 1])
f9_ax7 = fig10.add_subplot(gs2[1, 2])


gs3 = fig10.add_gridspec(nrows=1, ncols=2, left=0.05, right=0.4, bottom=0.1, top=0.4,hspace=0.05)
f9_ax8 = fig10.add_subplot(gs3[0, 0])
f9_ax9 = fig10.add_subplot(gs3[0, 1])

gs4 = fig10.add_gridspec(nrows=1, ncols=3, left=0.45, right=0.98, bottom=0.1, top=0.4,hspace=0.05)
f9_ax10 = fig10.add_subplot(gs4[0, 0])
f9_ax11 = fig10.add_subplot(gs4[0, 1])
f9_ax12 = fig10.add_subplot(gs4[0, 2])



axes = [f9_ax1, f9_ax2, f9_ax3, f9_ax4, f9_ax5, f9_ax6, f9_ax7, f9_ax8, f9_ax9, f9_ax10, f9_ax11, f9_ax12]

plt1 = data_AAL
plt2 = data_AAL600
plt3 = data_JHU
plt4 = data_AAL_JHU
plt5 = data_desikan
plt6 = data_Schaefer0100
plt7 = data_Schaefer1000
plt8 = data_RandomAtlas0000010
plt9 = data_RandomAtlas0000030
plt10 = data_RandomAtlas0000100
plt11 = data_RandomAtlas0001000
plt12 = data_RandomAtlas0005000
plots = [plt1, plt2, plt3, plt4, plt5, plt6, plt7, plt8, plt9, plt10, plt11, plt12]

ylim = [0, 0.5]
for s in range(len(plots)):
         
    df =   plots[s]
    
    
    sns.lineplot(data =df,  x = "period_index", y = "SFC", hue="frequency" ,  ax = axes[s], legend = False)
    #plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)
    axes[s].set_ylim(ylim)

    #writing interictal, pretictal, ictal, postictal labels
    #if s == 0:
    #    mult_factor = 0.95
    #    axes[s].text(x = 0, y = ylim[1]*mult_factor, s = "inter", verticalalignment='top')
    #    axes[s].text(x = 1.1* len(ii), y = ylim[1]*mult_factor, s = "pre", verticalalignment='top')
    #    axes[s].text(x = 1.1* len(ii)+ len(pi), y = ylim[1]*mult_factor, s = "ictal", verticalalignment='top')
    #    axes[s].text(x = 1.1* len(ii) + len(pi) + len(ic), y = ylim[1]*mult_factor, s = "post", verticalalignment='top')  
    vertical_line = [100+ gap, 200 + gap, 300 + gap]
    for x in vertical_line:
        axes[s].axvline(x, color='k', linestyle='--')
      


"""

#%%


    