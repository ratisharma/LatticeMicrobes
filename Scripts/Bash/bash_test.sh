#!/bin/bash

#lm_sbml_import rl1.lm rl1.txt;

Ls=(0 25 50 75 100 125 150 175 200 225 250);
X=64;
X1=0;
onOffs=(0	1);
writeInterval=1.0e1;
maxTime=1.0e4;
replicates="1-200";
is=`seq -f "%g" 0 1 10`;
for i in $is; do
    L=${Ls[i]};
    # Start in the unphos (off) state:
    filename=pdf_off_on_${L}_${X}_${X1}.lm
    #rm -f ${filename};
    fileSizeBlocks=0; if [ -e "data/${filename}" ]; then fileSizeBlocks=(`ls -s data/${filename}`); fileSizeBlocks=${fileSizeBlocks[0]}; fi;
        if [ ${fileSizeBlocks} -lt 16 ]; then
            echo "Starting ${filename}";
            cp rl1.lm data/${filename};
            lm_setrm data/${filename} "InitialSpeciesCounts(0)=${X}" > /dev/null;
    	    lm_setrm data/${filename} "InitialSpeciesCounts(2)=${X1}" > /dev/null;
    	    lm_setrm data/${filename} "InitialSpeciesCounts(5)=${L}" > /dev/null;
    	    lm_setp data/${filename} writeInterval=${writeInterval} maxTime=${maxTime};
    	    lm -r ${replicates} -ws -f data/${filename};
    	fi;
    # Start in the full phos (on) state:
    filename=pdf_on_off_${L}_${X1}_${X}.lm
    #filename=pdf_on_off_250_0_64.lm;
    #rm -f ${filename};
    fileSizeBlocks=0; if [ -e "data/${filename}" ]; then fileSizeBlocks=(`ls -s data/${filename}`); fileSizeBlocks=${fileSizeBlocks[0]}; fi;
        if [ ${fileSizeBlocks} -lt 16 ]; then
            echo "Starting ${filename}"
            cp rl1.lm data/${filename};
            lm_setrm data/${filename} "InitialSpeciesCounts(0)=${X1}" > /dev/null;
            lm_setrm data/${filename} "InitialSpeciesCounts(2)=${X}" > /dev/null;
            lm_setrm data/${filename} "InitialSpeciesCounts(5)=${L}" > /dev/null;
            lm_setp data/${filename} writeInterval=${writeInterval} maxTime=${maxTime};
            lm -r ${replicates} -ws -f data/${filename};
        fi;
done



