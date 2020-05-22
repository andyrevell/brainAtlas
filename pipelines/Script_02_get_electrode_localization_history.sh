#!/bin/bash
#Purpose: history of running Script_02_get_electrode_localization
#Example:
#python3.6 -c 'import Script_02_get_electrode_localization as el; el.batch_localize_electrodes(["RID0320"],[10,30,50,75,100,200,300,400,500,750,1000,2000],1,30,True)'


#python3.6 -c 'import Script_02_get_electrode_localization as el; el.batch_localize_electrodes(["RID0139", "RID0194", "RID0278","RID0309","RID0320","RID0365","RID0394","RID0420","RID0440"],[10,30,50,75,100,200,300,400,500,750,1000,2000],1,30,True)'
#python3.6 -c 'import Script_02_get_electrode_localization as el; el.batch_localize_electrodes(["RID0454"],[10,30,50,75,100,200,300,400,500,750,1000,2000],1,30,True)' #RID0454 originally had error where coordinate was outside of voxel index. Fixed now.
#python3.6 -c 'import Script_02_get_electrode_localization as el; el.batch_localize_electrodes(["RID0476","RID0490","RID0502","RID0508","RID0520","RID0522","RID0529","RID0536","RID0583"],[10,30,50,75,100,200,300,400,500,750,1000,2000],1,30,True)'
python3.6 -c 'import Script_02_get_electrode_localization as el; el.batch_localize_electrodes(["RID0536"],[10,30,50,75,100,200,300,400,500,750,1000,2000],1,30,True)' #Re-running where electrode names do not match those on iEEG.org (example LA01 on iEEG vs LA1 in the coordinate files)
python3.6 -c 'import Script_02_get_electrode_localization as el; el.batch_localize_electrodes(["RID0309"],[10,30,50,75,100,200,300,400,500,750,1000,2000],1,30,True)' #Re-running where electrode names do not match those on iEEG.org (example LA01 on iEEG vs LA1 in the coordinate files)
python3.6 -c 'import Script_02_get_electrode_localization as el; el.batch_localize_electrodes(["RID0320"],[10,30,50,75,100,200,300,400,500,750,1000,2000],1,30,True)' #Re-running where electrode names do not match those on iEEG.org (example LA01 on iEEG vs LA1 in the coordinate files)
python3.6 -c 'import Script_02_get_electrode_localization as el; el.batch_localize_electrodes(["RID0440"],[10,30,50,75,100,200,300,400,500,750,1000,2000],1,30,True)' #Re-running where electrode names do not match those on iEEG.org (example LA01 on iEEG vs LA1 in the coordinate files)
