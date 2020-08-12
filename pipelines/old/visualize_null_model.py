# -*- coding: utf-8 -*-
"""
Created on Thu Jun 25 17:01:56 2020

@author: asilv
"""
import pickle
import numpy as np
import matplotlib.pyplot as plt 
function_file_path = './RA_N2000/sub-RID0278_HUP138_phaseII_394423190000_394512890000_RA_N2000_Perm0001_null_correlation.pickle'
with open(function_file_path, 'rb') as f: perm_sfc_list,order_of_matrices_in_pickle_file = pickle.load(f)


t_steps = perm_sfc_list[0][0].shape[0]
mean_freqs = []
std_freqs = []
for freq in range(0,len(perm_sfc_list[0])):
    freq_all = np.zeros((t_steps,100))
    for perm in range(0,len(perm_sfc_list)):
        freq_all[:,perm] = perm_sfc_list[perm][freq]
    mean_freqs.append(np.mean(freq_all,axis=1))
    std_freqs.append(np.std(freq_all,axis=1))
        
    # with open(outputfile, 'wb') as f: pickle.dump([perm_sfc_list,order_of_matrices_in_pickle_file], f)
x_data = np.arange(88)
plt.plot(x_data,mean_freqs[0][0:-1])
dyfit = std_freqs[0][0:-1]/np.sqrt(100)
plt.fill_between(x_data, mean_freqs[0][0:-1] - dyfit, mean_freqs[0][0:-1] + dyfit,
                 color='gray', alpha=0.5)