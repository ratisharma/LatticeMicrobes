#!/bin/bash

#filename=cell_rdme_noL4.lm;
replicates="1-15";
Dk="5e-12";
c1bs=(0.5e-5 1.0e-5 1.5e-5);
c2bs=(1.0e-5 2.0e-5 3.0e-5 4.0e-5 5.0e-5);
is=`seq -f "%g" 0 1 2`;
js=`seq -f "%g" 0 1 4`;
for i in $is; do
    for j in $js; do
	c1b=${c1bs[i]};
	c2b=${c2bs[j]};
	c1a=`awk -v a="2" -v b="${c1b}" 'BEGIN{print (a * b)}'`
	c2a=`awk -v a="2" -v b="${c2b}" 'BEGIN{print (a * b)}'`
	filename=cell_rdme_noL_c1b_${c1b}_c2b_${c2b}.lm;
	rm -f ../data_noL/${filename};
	rm -f ../logs_noL/${filename}.log;
	#lm_sbml_import kin4.lm kin4.txt;
	cp ../kin3.lm ../data_noL/${filename};
	lm_setrm ../data_noL/${filename} "ReactionRateConstants(0:3,0)=[${c1a};${c1b};${c2a};${c2b}]";
	lm_setdm ../data_noL/${filename} numberReactions=8 numberSpecies=4 numberSiteTypes=3 "latticeSize=[50,50,50]" latticeSpacing=5.0e-8 particlesPerSite=8 "DiffusionMatrix=[0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0;${Dk},${Dk},${Dk},${Dk};0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0]" "ReactionLocationMatrix=[0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0]";
	lm_setp ../data_noL/${filename} writeInterval=1e1 latticeWriteInterval=1e2 maxTime=4e3;
	lm_python -s build_cell_noL.py -sa ../data_noL/${filename};
#lm_setp data/${filename} boundaryConditions=FIXED_GRADIENT boundarySite=0 boundarySpecies=5;
#h5copy -v -f shallow -i "scaled_alpha_865_test_40.h5" -s "dataset1" -o "data/${filename}" -d "Model/Diffusion/Gradient";
#lm-submit alpha_test.lm -r 1-2 -sl lm::rdme::NextSubvolumeSolver alpha_test.log smp-1 5;

#lm -r 1-10 -ws -f bimol.lm;
#lm -r 1-2 -sl lm::rdme::NextSubvolumeSolver -f ${filename} -gr 0;
lmes-submit ../data_noL/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../logs_noL/${filename}.log gpu-1 16;
   done;
done;
