#!/bin/bash


replicates="1-15";
dataDir=data_gradSteep_memThick2;
logsDir=logs_gradSteep_memThick2;
buildCell=build_cell_5_memThick2.py;
Dk="5e-12";
Dl="50e-12";
c1bs=(0.5e-5 1.0e-5 1.5e-5 2.0e-5 2.5e-5 3.0e-5);
c2bs=(1.0e-5 2.0e-5 3.0e-5 4.0e-5 5.0e-5 6.0e-5 7.0e-5);
c4s=(1.0e-3 2.0e-3 3.0e-3 4.0e-3 5.0e-3 6.0e-3 7.0e-3 8.0e-3);
c5s=(1.0e-3 2.0e-3 3.0e-3 4.0e-3 5.0e-3 6.0e-3 7.0e-3 8.0e-3);
c6s=(1.0e-5 2.0e-5 3.0e-5 4.0e-5 5.0e-5);
is=`seq -f "%g" 5 5`;
js=`seq -f "%g" 5 1 6`;
ks=`seq -f "%g" 7 7`;
ls=`seq -f "%g" 7 7`;
ms=`seq -f "%g" 2 1 4`;
for i in $is; do
    for j in $js; do
	for k in $ks; do
	    for l in $ls; do
		for m in $ms; do
		c1b=${c1bs[i]};
		c2b=${c2bs[j]};
		c4=${c4s[k]};
		c5=${c5s[l]};
		c6=${c6s[m]};
		c1a=`awk -v a="2" -v b="${c1b}" 'BEGIN{print (a * b)}'`
		c2a=`awk -v a="2" -v b="${c2b}" 'BEGIN{print (a * b)}'`
		filename=cell_rdme_Lmem_c1b_${c1b}_c2b_${c2b}_c4_${c4}_c5_${c5}_c6_${c6}.lm;
		rm -f ../${dataDir}/${filename};
		rm -f ../${logsDir}/${filename}.log;
		cp rl3.lm ../${dataDir}/${filename};
		lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(0:3,0)=[${c1a};${c1b};${c2a};${c2b}]";
		lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(8:10,0)=[${c4};${c5};${c6}]";
		lm_setdm ../${dataDir}/${filename} numberReactions=11 numberSpecies=7 numberSiteTypes=3 "latticeSize=[50,50,50]" latticeSpacing=5.0e-8 particlesPerSite=8 "DiffusionMatrix=[0,0,0,0,0,${Dl},0;0,0,0,0,0,${Dl},0;0,0,0,0,0,0,0;0,0,0,0,0,${Dl},0;${Dk},${Dk},${Dk},${Dk},${Dk},${Dl},${Dk};0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0]" "ReactionLocationMatrix=[0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0]";
		lm_setp ../${dataDir}/${filename} writeInterval=1e1 latticeWriteInterval=1e2 maxTime=3e3;
		lm_python -s ${buildCell} -sa ../${dataDir}/${filename};
		lm_setp ../${dataDir}/${filename} boundaryConditions=FIXED_GRADIENT boundarySite=0 boundarySpecies=5;
		h5copy -v -f shallow -i "scaled_test_D50_rateProd865_dilFac46_distSrc0.5.h5" -s "dataset1" -o "../${dataDir}/${filename}" -d "Model/Diffusion/Gradient";
		#lmes-submit ../${dataDir}/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../${logsDir}/${filename}.log gpu-1 16;
		lmes-submit ../${dataDir}/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../${logsDir}/${filename}.log batch 16 rsharm28 60:00:00;
		done;
	    done;
	done;
   done;
done;
