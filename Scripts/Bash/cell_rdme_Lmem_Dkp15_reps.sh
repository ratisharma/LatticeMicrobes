#!/bin/bash

replicates="501-1000";
numCPUs=101;
dataDir=data_Dkp15_Drl15_memThick2;
logsDir=logs_Dkp15_Drl15_memThick2;
gradData=scaled_test_D50_rateProd865_dilFac46_distSrc0.5.h5;
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
c6s=(1.0e-5 2.0e-5 3.0e-5 4.0e-5);

is=`seq -f "%g" 6 6`;
js=`seq -f "%g" 4 4`;
ks=`seq -f "%g" 3 3`;

for i in $is; do
    for j in $js; do
        for k in $ks; do
        c4=${c4s[i]};
        c5=${c5s[j]};
        c6=${c6s[k]};
        c1a=`awk -v a="2" -v b="${c1b}" 'BEGIN{print (a * b)}'`
        c2a=`awk -v a="2" -v b="${c2b}" 'BEGIN{print (a * b)}'`
        c3a=`awk -v a="2" -v b="${c3b}" 'BEGIN{print (a * b)}'`
        c0b=`awk -v a="2" -v b="${c0a}" 'BEGIN{print (a * b)}'`
        filename=cell_rdme_Lmem_gradSteep_1000reps_c1b_${c1b}_c2b_${c2b}_c3b_${c3b}_c0a_${c0a}_c4_${c4}_c5_${c5}_c6_${c6}_Dk_${Dk}_Dkp_${Dkp}_Dr_${Dr}_Drl_${Drl}.lm;
        lmes-submit ../${dataDir}/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../${logsDir}/${filename}.log batch ${numCPUs} rsharm28 25:00:00;
        done;
    done;
done;
