#!/bin/bash

lm_sbml_import rl1.lm rl1.txt;

Ls=(0 200 400 600 800 125 150 175 200 225 250);
c1s=(5.0e-6 6.0e-6 7.0e-6 8.0e-6 9.0e-6 10.0e-6);
c2s=(1.45e-5 1.55e-5 1.65e-5 1.75e-5 1.85e-5 1.95e-5);
c3s=(5.0e-4 6.0e-4 7.0e-4 8.0e-4 9.0e-4 10.0e-4);
c0s=(5.0e-4 6.0e-4 7.0e-4 8.0e-4 9.0e-4 10.0e-4);
X=512;
X1=0;
onOffs=(0	1);
writeInterval=1.0e1;
maxTime=1.0e4;
replicates="1-10";
dataDir=data_cme;
logsDir=logs_cme;
is=`seq -f "%g" 0 0`;
js=`seq -f "%g" 2 2`;
ks=`seq -f "%g" 3 1 4`;
ls=`seq -f "%g" 0 0`;
ms=`seq -f "%g" 0 1 5`;
for i in $is; do
for j in $js; do
for k in $ks; do
for l in $ls; do
for m in $ms; do
    L=${Ls[i]};
    c1b=${c1s[j]};
    c2b=${c2s[k]};
    c3b=${c3s[l]};
    c0a=${c0s[m]};
    c1a=`awk -v a="2" -v b="${c1b}" 'BEGIN{print (a*b)}'`
    c2a=`awk -v a="2" -v b="${c2b}" 'BEGIN{print (a*b)}'`
    c3a=`awk -v a="2" -v b="${c3b}" 'BEGIN{print (a*b)}'`
    c0b=`awk -v a="2" -v b="${c0a}" 'BEGIN{print (a*b)}'`
    # Start in the unphos (off) state:
    filename=pdf_off_on_${L}_${X}_${X1}_c1b_${c1b}_c2b_${c2b}_c3b_${c3b}_c0b_${c0b}.lm
    rm -f ../${dataDir}/${filename};
    fileSizeBlocks=0; if [ -e "../${dataDir}/${filename}" ]; then fileSizeBlocks=(`ls -s ../${dataDir}/${filename}`); fileSizeBlocks=${fileSizeBlocks[0]}; fi;
        if [ ${fileSizeBlocks} -lt 16 ]; then
            echo "Starting ${filename}";
            cp rl_vol_full.lm ../${dataDir}/${filename};
            lm_setrm ../${dataDir}/${filename} "InitialSpeciesCounts(0)=${X}" > /dev/null;
    	    lm_setrm ../${dataDir}/${filename} "InitialSpeciesCounts(2)=${X1}" > /dev/null;
    	    lm_setrm ../${dataDir}/${filename} "InitialSpeciesCounts(5)=${L}" > /dev/null;
	    lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(0:7,0)=[${c1a};${c1b};${c2a};${c2b};${c3a};${c3b};${c0a};${c0b}]";
	    lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(6:7,0)=[${c0a};${c0b}]";
    	    lm_setp ../${dataDir}/${filename} writeInterval=${writeInterval} maxTime=${maxTime};
    	    ####lm -r ${replicates} -ws -f data/${filename};
	    lmes-submit ../${dataDir}/${filename} -m lm::cme::GillespieDSolver -r ${replicates} -cr 1 ../${logsDir}/${filename}.log smp-1 11;
    	fi;
    # Start in the full phos (on) state:
    #filename=pdf_on_off_${L}_${X1}_${X}.lm
    #filename=pdf_on_off_250_0_64.lm;
    #rm -f ${filename};
    #fileSizeBlocks=0; if [ -e "data/${filename}" ]; then fileSizeBlocks=(`ls -s data/${filename}`); fileSizeBlocks=${fileSizeBlocks[0]}; fi;
    #    if [ ${fileSizeBlocks} -lt 16 ]; then
    #        echo "Starting ${filename}"
    #        cp rl1.lm data/${filename};
    #        lm_setrm data/${filename} "InitialSpeciesCounts(0)=${X1}" > /dev/null;
    #        lm_setrm data/${filename} "InitialSpeciesCounts(2)=${X}" > /dev/null;
    #        lm_setrm data/${filename} "InitialSpeciesCounts(5)=${L}" > /dev/null;
    #        lm_setp data/${filename} writeInterval=${writeInterval} maxTime=${maxTime};
    #        lm -r ${replicates} -ws -f data/${filename};
    #    fi;
done
done
done
done
done
