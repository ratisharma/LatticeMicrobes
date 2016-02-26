#!/bin/bash

#lm_sbml_import rl3_complex.lm rl3_complex.txt;

replicates="1-50";
Drs=(5e-12 5e-13 5e-14 5e-15 5e-16 5e-17 5e-18);
Drls=(5e-12 5e-13 5e-14 5e-15 5e-16 5e-17 5e-18);
Dl="50e-12";
c4=5.0e-3;
c5=8.0e-3;

is=`seq -f "%g" 0 0`;
js=`seq -f "%g" 0 1 3`;
for i in $is; do
    for j in $js; do
	Dr=${Drs[i]};
	Drl=${Drls[j]};
	filename=cell_rdme_rl_Lcyt_c4_${c4}_c5_${c5}_Dr_${Dr}_Drl_${Drl}.lm;
	rm -f ../data_rl_Lcyt/${filename};
	rm -f ../logs_rl_Lcyt/${filename}.log;
	cp rl3_complex.lm ../data_rl_Lcyt/${filename};
	lm_setrm ../data_rl_Lcyt/${filename} "ReactionRateConstants(0:1,0)=[${c4};${c5}]";
	lm_setdm ../data_rl_Lcyt/${filename} numberReactions=2 numberSpecies=3 numberSiteTypes=3 "latticeSize=[50,50,50]" latticeSpacing=5.0e-8 particlesPerSite=8 "DiffusionMatrix=[0,${Dl},0;0,${Dl},0;0,${Dl},0;0,${Dl},0;${Dr},${Dl},${Drl};0,${Dl},0;0,${Dl},0;0,${Dl},0;0,${Dl},0]" "ReactionLocationMatrix=[0,1,0;0,1,0]";
	lm_setp ../data_rl_Lcyt/${filename} writeInterval=1e0 latticeWriteInterval=1e0 maxTime=1e3;
	lm_python -s build_cell_rl.py -sa ../data_rl_Lcyt/${filename};
	lm_setp ../data_rl_Lcyt/${filename} boundaryConditions=FIXED_GRADIENT boundarySite=0 boundarySpecies=1;
	h5copy -v -f shallow -i "../scaled_alpha_865_test_40.h5" -s "dataset1" -o "../data_rl_Lcyt/${filename}" -d "Model/Diffusion/Gradient";
	#lmes-submit ../data_rl_Lcyt/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../logs_rl_Lcyt/${filename}.log gpu-1 16;
	lmes-submit ../data_rl_Lcyt/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../logs_rl_Lcyt/${filename}.log batch 50 rsharm28 12:00:00;
    done;
done;
