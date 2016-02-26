#!/bin/bash

filename=alpha_time_10_D50_rateProd865_dsrc1.lm;
replicates="1-100";
numCPUs=101;
rm -f ${filename};
#####lm_sbml_import ${filename} alpha_test_no_species.txt;
cp alpha.lm ${filename};
lm_setdm ${filename} numberReactions=1 numberSpecies=1 numberSiteTypes=1 "latticeSize=[50,50,50]" latticeSpacing=5.0e-8 particlesPerSite=8 "DiffusionMatrix=[50.0e-12]" "ReactionLocationMatrix=[1]";
lm_setp ${filename} writeInterval=1e-2 latticeWriteInterval=1e-2 maxTime=1e1;
lm_setp ${filename} boundaryConditions=FIXED_GRADIENT boundarySite=0 boundarySpecies=0;
h5copy -v -f shallow -i "scaled_test_rateProd_865_D50_dsrc_1.h5" -s "dataset1" -o "${filename}" -d "Model/Diffusion/Gradient";

#lmes-submit ${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 logs/${filename}.log smp-1 21;
#lmes-submit alpha_test.lm -sl lm::rdme::NextSubvolumeSolver -r 1 -cr 1 alpha_test.log smp-1 1;
lmes-submit ${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ${filename}.log batch ${numCPUs} rsharm28 2:00:00;
