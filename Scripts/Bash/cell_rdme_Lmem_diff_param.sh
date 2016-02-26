#!/bin/bash

replicates="1-15";
dataDir=data_Lmem_memThick2;
logsDir=data_Lmem_memThick2;

Dk="5.0e-12";
Dkps=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
Dr=5.0e-12;
Drls=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
Dl="50e-12";
c1b=0.5e-5;
c2b=1.0e-5;
c4=5.0e-3;
c5=8.0e-3;
c6=2.0e-5;

is=`seq -f "%g" 1 1`;
js=`seq -f "%g" 1 1`;

for i in $is; do
    for j in $js; do
        Dkp=${Dkps[i]};
	Drl=${Drls[j]};
        c1a=`awk -v a="2" -v b="${c1b}" 'BEGIN{print (a * b)}'`
        c2a=`awk -v a="2" -v b="${c2b}" 'BEGIN{print (a * b)}'`
        filename=cell_rdme_Lmem_c1b_${c1b}_c2b_${c2b}_c4_${c4}_c5_${c5}_c6_${c6}_Dk_${Dk}_Dkp_${Dkp}_Dr_${Dr}_Drl_${Drl}.lm;
        rm -f ../${dataDir}/${filename};
        rm -f ../${logsDir}/${filename}.log;
        cp rl3.lm ../${dataDir}/${filename};
        lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(0:3,0)=[${c1a};${c1b};${c2a};${c2b}]";
        lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(8:10,0)=[${c4};${c5};${c6}]";
        lm_setdm ../${dataDir}/${filename} numberReactions=11 numberSpecies=7 numberSiteTypes=3 "latticeSize=[50,50,50]" latticeSpacing=5.0e-8 particlesPerSite=16 "DiffusionMatrix=[0,0,0,0,0,${Dl},0;0,0,0,0,0,${Dl},0;0,0,0,0,0,0,0;0,0,0,0,0,${Dl},0;${Dk},${Dkp},${Dkp},${Dk},${Dk},${Dl},${Drl};0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0]" "ReactionLocationMatrix=[0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0]";
        lm_setp ../${dataDir}/${filename} writeInterval=1e0 latticeWriteInterval=1e0 maxTime=2e3;
        lm_python -s build_cell_5_memThick2.py -sa ../${dataDir}/${filename};
        lm_setp ../${dataDir}/${filename} boundaryConditions=FIXED_GRADIENT boundarySite=0 boundarySpecies=5;
        h5copy -v -f shallow -i "../scaled_alpha_865_test_40.h5" -s "dataset1" -o "../${dataDir}/${filename}" -d "Model/Diffusion/Gradient";
        #lmes-submit ../data_Lmem3/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../logs_Lmem/${filename}.log gpu-1 16;
	lmes-submit ../${dataDir}/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../${logsDir}/${filename}.log batch 16 rsharm28 50:00:00;
    done;
done;
