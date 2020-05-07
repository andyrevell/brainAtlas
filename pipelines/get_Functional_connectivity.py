# -*- coding: utf-8 -*-
"""
Created on Fri Feb 07 19:04:04 2020

@author: asilv
"""
import echobase
from echobase import broadband_conn, multiband_conn
import numpy as np 
import scipy.io as sio

def getFuncConn(dataPath,saveDir):
    mat_contents = sio.loadmat(dataPath)
    out = mat_contents['dataInt']
    Fs = mat_contents['Fs']
    Fs = float(Fs)
    totalSecs = np.floor(np.size(out,0)/Fs)
    totalSecs = int(totalSecs)
    all_adj_alphatheta = np.zeros((np.size(out,1),np.size(out,1),totalSecs))
    all_adj_beta = np.zeros((np.size(out,1),np.size(out,1),totalSecs))
    all_adj_broadband_CC = np.zeros((np.size(out,1),np.size(out,1),totalSecs))
    all_adj_highgamma = np.zeros((np.size(out,1),np.size(out,1),totalSecs))
    all_adj_lowgamma = np.zeros((np.size(out,1),np.size(out,1),totalSecs))
    for t in range(0,totalSecs):
        startInd = int(t*Fs)
        endInd = int(((t+1)*Fs) - 1)
        window = out[startInd:endInd,:]
        broad = broadband_conn(window,int(Fs),avgref=True)
        adj_alphatheta, adj_beta, adj_lowgamma, adj_highgamma = multiband_conn(window,int(Fs),avgref=True)
        all_adj_alphatheta[:,:,t] = adj_alphatheta
        all_adj_beta[:,:,t] = adj_beta
        all_adj_broadband_CC[:,:,t] = broad
        all_adj_highgamma[:,:,t] = adj_highgamma
        all_adj_lowgamma[:,:,t] = adj_lowgamma
        print(t)
    
    pathParts = dataPath.split('_')
    pathParts[2] = pathParts[2][0:-4]
    overallPath = saveDir + 'HUP' + pathParts[1] + '.Ictal.' + pathParts[2] + '.multiband.npz';
    np.savez(overallPath,all_adj_alphatheta=all_adj_alphatheta,all_adj_beta=all_adj_beta,all_adj_broadband_CC=all_adj_broadband_CC,all_adj_highgamma=all_adj_highgamma,all_adj_lowgamma=all_adj_lowgamma) 
    