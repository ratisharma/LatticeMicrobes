#!/bin/bash

replicates="1-500";
numCPUs=101;
dataDir=data_mono_Dkp15_Drl15;
logsDir=logs_mono_Dkp15_Drl15;
#gradData=scaled_test_D50_rateProd865_dilFac46_distSrc0.5.h5;
gradData=min_ligand.h5
buildCell=build_cell_mono_5_memThick2.py;

countR=400;
Dk="5.0e-12";
Dkps=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
Dr=5.0e-12;
Drls=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
Dl="50e-12";
#c1b=0.5e-5;
#c0=
#c2b=1.0e-5;
#c4=5.0e-3;
#c5=8.0e-3;
#c6=2.0e-5;

is=`seq -f "%g" 4 4`;
js=`seq -f "%g" 4 4`;

for i in $is; do
    for j in $js; do
        Dkp=${Dkps[i]};
	Drl=${Drls[j]};
        #c1a=`awk -v a="2" -v b="${c1b}" 'BEGIN{print (a * b)}'`
        #c2a=`awk -v a="2" -v b="${c2b}" 'BEGIN{print (a * b)}'`
        filename=cell_rdme_mono_min_ligand_countR_${countR}_t500.lm;
        rm -f ../${dataDir}/${filename};
        rm -f ../${logsDir}/${filename}.log;
        cp mono.lm ../${dataDir}/${filename};
	lm_setrm ../${dataDir}/${filename} "InitialSpeciesCounts(3)=[${countR}]";
        #lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(0:3,0)=[${c1a};${c1b};${c2a};${c2b}]";
        #lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(8:10,0)=[${c4};${c5};${c6}]";
        lm_setdm ../${dataDir}/${filename} numberReactions=6 numberSpecies=6 numberSiteTypes=3 "latticeSize=[50,50,50]" latticeSpacing=5.0e-8 particlesPerSite=8 "DiffusionMatrix=[0,0,0,0,${Dl},0;0,0,0,0,${Dl},0;0,0,0,0,0,0;0,0,0,0,${Dl},0;${Dk},${Dkp},${Dk},${Dk},${Dl},${Drl};0,0,0,0,0,0;0,0,0,0,0,0;0,0,0,0,0,0;0,0,0,0,0,0]" "ReactionLocationMatrix=[0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0]";
        lm_setp ../${dataDir}/${filename} writeInterval=1e0 latticeWriteInterval=1e0 maxTime=5e2;
        lm_python -s ${buildCell} -sa ../${dataDir}/${filename} ${countR};
        lm_setp ../${dataDir}/${filename} boundaryConditions=FIXED_GRADIENT boundarySite=0 boundarySpecies=4;
        h5copy -v -f shallow -i "${gradData}" -s "dataset1" -o "../${dataDir}/${filename}" -d "Model/Diffusion/Gradient";
        #lmes-submit ../data_Lmem3/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../logs_Lmem/${filename}.log gpu-1 16;
	lmes-submit ../${dataDir}/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../${logsDir}/${filename}.log batch ${numCPUs} rsharm28 30:00:00;
    done;
done;
