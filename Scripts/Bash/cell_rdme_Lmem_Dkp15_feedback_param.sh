#!/bin/bash

replicates="1-200";
numCPUs=101;
#dataDir=data_Dkp15_Drl15_memThick2/files;
#logsDir=logs_Dkp15_Drl15_memThick2/files;
#gradData=scaled_test_D50_rateProd865_dilFac46_distSrc0.5.h5;
#dataDir=feedback_kp/data_Dkp15_Drl15_memThick2/gradient;
#logsDir=feedback_kp/logs_Dkp15_Drl15_memThick2/gradient;
gradData=scaled_test_D50_rateProd865_dilFac46_distSrc0.5.h5;
#gradData=min_ligand.h5;
buildCell=build_cell_5_memThick2.py;

Dk=5.0e-12;
Dkp=5.0e-15;
Dr=5.0e-12;
Drl=5.0e-15;
Dl=50e-12;
c1b=0.5e-5;
c2b=1.0e-5;
c3b=1.0e-3;
c0a=4.0e-3;
c4s=(1.0e-3 2.0e-3 3.0e-3 4.0e-3 5.0e-3 6.0e-3 7.0e-3 8.0e-3);
c5s=(1.0e-3 2.0e-3 3.0e-3 4.0e-3 5.0e-3 6.0e-3 7.0e-3 8.0e-3);
c6s=(1.0e-5 2.0e-5 3.0e-5 4.0e-5 5.0e-5 6.0e-5 7.0e-5 8.0e-5 9.0e-5 10.0e-5);
c7s=(4.0e-7 4.0e-6 4.0e-5 4.0e-4 4.0e-3);


is=`seq -f "%g" 6 6`;
js=`seq -f "%g" 4 4`;
ks=`seq -f "%g" 3 3`;
ls=`seq -f "%g" 1 1`;
ms=`seq -f "%g" 37 37`;

for i in $is; do
    for j in $js; do
	for k in $ks; do
	for l in $ls; do
	for m in $ms; do
        c4=${c4s[i]};
	c5=${c5s[j]};
	c6=${c6s[k]};
	c7=${c7s[l]};
        c1a=`awk -v a="2" -v b="${c1b}" 'BEGIN{print (a * b)}'`
        c2a=`awk -v a="2" -v b="${c2b}" 'BEGIN{print (a * b)}'`
        c3a=`awk -v a="2" -v b="${c3b}" 'BEGIN{print (a * b)}'`
	c0b=`awk -v a="2" -v b="${c0a}" 'BEGIN{print (a * b)}'`
	dataDir=feedback_kp/data_Dkp15_Drl15_memThick2/gradient/c7_${c7};
	logsDir=feedback_kp/logs_Dkp15_Drl15_memThick2/gradient/c7_${c7};
filename=cell_rdme_Lmem_gradSteep_t500_${m}_c1b_${c1b}_c2b_${c2b}_c3b_${c3b}_c0a_${c0a}_c4_${c4}_c5_${c5}_c6_${c6}_c7_${c7}_Dk_${Dk}_Dkp_${Dkp}_Dr_${Dr}_Drl_${Drl}.lm;
        rm -f ../${dataDir}/${filename};
        rm -f ../${logsDir}/${filename}.log;
        cp rl3_feedback_kp.lm ../${dataDir}/${filename};
        lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(0:7,0)=[${c1a};${c1b};${c2a};${c2b};${c3a};${c3b};${c0a};${c0b}]";
        lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(8:11,0)=[${c4};${c5};${c6};${c7}]";
        lm_setdm ../${dataDir}/${filename} numberReactions=12 numberSpecies=7 numberSiteTypes=3 "latticeSize=[50,50,50]" latticeSpacing=5.0e-8 particlesPerSite=16 "DiffusionMatrix=[0,0,0,0,0,${Dl},0;0,0,0,0,0,${Dl},0;0,0,0,0,0,0,0;0,0,0,0,0,${Dl},0;${Dk},${Dkp},${Dkp},${Dk},${Dk},${Dl},${Drl};0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0]" "ReactionLocationMatrix=[0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0]";
        lm_setp ../${dataDir}/${filename} writeInterval=1e0 latticeWriteInterval=1e0 maxTime=5e2;
        lm_python -s ${buildCell} -sa ../${dataDir}/${filename};
        lm_setp ../${dataDir}/${filename} boundaryConditions=FIXED_GRADIENT boundarySite=0 boundarySpecies=5;
        h5copy -v -f shallow -i "${gradData}" -s "dataset1" -o "../${dataDir}/${filename}" -d "Model/Diffusion/Gradient";
        #lmes-submit ../data_Lmem3/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../logs_Lmem/${filename}.log gpu-1 16;
	lmes-submit ../${dataDir}/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../${logsDir}/${filename}.2.log batch ${numCPUs} rsharm28 9:00:00;
	done;
	done;
    done;
    done;
done;
