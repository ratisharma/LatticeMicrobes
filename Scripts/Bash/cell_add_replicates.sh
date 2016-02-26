#!/bin/bash

replicates=("501-1500" "1501-2000" "2001-2500" "2501-3000" "3001-3500" "3501-4000" "4001-4500" "4501-5000");
numCPUs=252;
dataDir=data_Dkp15_Drl15_memThick2;
logsDir=logs_Dkp15_Drl15_memThick2;
Dk="5.0e-12";
Dkps=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
Dr=5.0e-12;
Drls=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
Dl="50e-12";
c1b=0.5e-5;
c2b=1.0e-5;
c3b=1.0e-3;
c0a=4.0e-3;
c4=7.0e-3;
c5=5.0e-3;
c6=10.0e-5;

is=`seq -f "%g" 4 4`;
js=`seq -f "%g" 4 4`;
ks=`seq -f "%g" 0 0`;

for i in $is; do
    for j in $js; do
	for k in $ks; do
        Dkp=${Dkps[i]};
	Drl=${Drls[j]};
	reps=${replicates[k]};
	filename=cell_rdme_Lmem_gradSteep_t500_c1b_${c1b}_c2b_${c2b}_c3b_${c3b}_c0a_${c0a}_c4_${c4}_c5_${c5}_c6_${c6}_Dk_${Dk}_Dkp_${Dkp}_Dr_${Dr}_Drl_${Drl}.lm;
	rm -f ../${logsDir}/${filename}.${reps}.log;
	lmes-submit ../${dataDir}/${filename} -m lm::rdme::NextSubvolumeSolver -r ${reps} -cr 1 ../${logsDir}/${filename}.${reps}.log batch ${numCPUs} rsharm28 40:00:00;
	done;
    done;
done;
