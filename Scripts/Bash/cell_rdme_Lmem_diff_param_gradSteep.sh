#!/bin/bash

replicates="601-1200";
numCPUs=101;
dataDir=data_gradSteep_memThick2;
logsDir=logs_gradSteep_memThick2;
gradData=scaled_test_D50_rateProd865_dilFac46_distSrc0.5.h5;
buildCell=build_cell_5_memThick2.py;

Dk="5.0e-12";
Dkps=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18 5.0e-19 5.0e-20);
Dr=5.0e-12;
Drls=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
Dl="50e-12";
c1b=3.0e-5;
c2b=7.0e-5;
c4=8.0e-3;
c5=8.0e-3;
c6=4.0e-5;

is=`seq -f "%g" 2 1 3`;
js=`seq -f "%g" 1 1`;

for i in $is; do
    for j in $js; do
        Dkp=${Dkps[i]};
	Drl=${Drls[j]};
###        c1a=`awk -v a="2" -v b="${c1b}" 'BEGIN{print (a * b)}'`
###        c2a=`awk -v a="2" -v b="${c2b}" 'BEGIN{print (a * b)}'`
        filename=cell_rdme_Lmem_gradSteep_1000rep_c1b_${c1b}_c2b_${c2b}_c4_${c4}_c5_${c5}_c6_${c6}_Dk_${Dk}_Dkp_${Dkp}_Dr_${Dr}_Drl_${Drl}.lm;
###        rm -f ../${dataDir}/${filename};
###        rm -f ../${logsDir}/${filename}.log;
###        cp rl3.lm ../${dataDir}/${filename};
###        lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(0:3,0)=[${c1a};${c1b};${c2a};${c2b}]";
###        lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(8:10,0)=[${c4};${c5};${c6}]";
###        lm_setdm ../${dataDir}/${filename} numberReactions=11 numberSpecies=7 numberSiteTypes=3 "latticeSize=[50,50,50]" latticeSpacing=5.0e-8 particlesPerSite=16 "DiffusionMatrix=[0,0,0,0,0,${Dl},0;0,0,0,0,0,${Dl},0;0,0,0,0,0,0,0;0,0,0,0,0,${Dl},0;${Dk},${Dkp},${Dkp},${Dk},${Dk},${Dl},${Drl};0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0]" "ReactionLocationMatrix=[0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0]";
###        lm_setp ../${dataDir}/${filename} writeInterval=1e0 latticeWriteInterval=1e0 maxTime=1e2;
###        lm_python -s ${buildCell} -sa ../${dataDir}/${filename};
###        lm_setp ../${dataDir}/${filename} boundaryConditions=FIXED_GRADIENT boundarySite=0 boundarySpecies=5;
###        h5copy -v -f shallow -i "${gradData}" -s "dataset1" -o "../${dataDir}/${filename}" -d "Model/Diffusion/Gradient";
####        #lmes-submit ../data_Lmem3/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../logs_Lmem/${filename}.log gpu-1 16;
	lmes-submit ../${dataDir}/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../${logsDir}/${filename}.log batch ${numCPUs} rsharm28 06:00:00;
    done;
done;
