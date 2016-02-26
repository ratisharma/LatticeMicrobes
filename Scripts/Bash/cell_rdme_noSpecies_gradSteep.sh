#!/bin/bash


replicates="1-40";
numCPUs=41;
dataDir=data_gradSteep_memThick2;
logsDir=logs_gradSteep_memThick2;
buildCell=build_cell_noSpecies_memThick2.py;
gradData=scaled_test_D50_rateProd865_dilFac46_distSrc0.5.h5;
Dl="50e-12";
		filename=cell_rdme_Lmem_gradSteep_noSpecies.lm;
		rm -f ../${dataDir}/${filename};
		rm -f ../${logsDir}/${filename}.log;
		cp l_noSpecies.lm ../${dataDir}/${filename};
		lm_setdm ../${dataDir}/${filename} numberReactions=1 numberSpecies=1 numberSiteTypes=3 "latticeSize=[50,50,50]" latticeSpacing=5.0e-8 particlesPerSite=8 "DiffusionMatrix=[${Dl},${Dl},0;${Dl},${Dl},0;0,0,0]" "ReactionLocationMatrix=[0,1,0]";
		lm_setp ../${dataDir}/${filename} writeInterval=5e-1 latticeWriteInterval=5e-1 maxTime=1e3;
		lm_python -s ${buildCell} -sa ../${dataDir}/${filename};
		lm_setp ../${dataDir}/${filename} boundaryConditions=FIXED_GRADIENT boundarySite=0 boundarySpecies=0;
		h5copy -v -f shallow -i "${gradData}" -s "dataset1" -o "../${dataDir}/${filename}" -d "Model/Diffusion/Gradient";
		#lmes-submit ../${dataDir}/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../${logsDir}/${filename}.log gpu-1 16;
		lmes-submit ../${dataDir}/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../${logsDir}/${filename}.log batch ${numCPUs} rsharm28 60:00:00;
