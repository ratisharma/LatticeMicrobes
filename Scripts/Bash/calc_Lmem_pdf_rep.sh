#!/bin/bash

    X=64;
    maxTime=1e4 writeInterval=1e2;
    replicates="1-50";
    #outputDir=pdf_gradSteep_memThick2.dat;
    outputDir=pdf_c6_4_memThick2/Dkp_5e-15.dat;
    dataDir=data_gradSteep_memThick2;
    logsDir=logs_gradSteep_memThick2;
    c1b=3.0e-5;
    c2b=7.0e-5;
    c4=8.0e-3;
    c5=8.0e-3;
    c6=4.0e-5;
    Dk=5.0e-12;
    Dkps=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
    Dr=5.0e-12;
    Dl=5.0e-11;
    Drls=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
    maxReps=(0 1 2 3 4 5 6 7 8 9 10 11)
    is=`seq -f "%g" 4 4`;
    js=`seq -f "%g" 1 1`;
    ks=`seq -f "%g" 5 5`;
    ls=`seq -f "%g" 1 1 8`;
    for i in $is; do
	for j in $js; do
	    for k in $ks; do
		for l in $ls; do
            	    Dkp=${Dkps[i]};
	    	    Drl=${Drls[j]};
	    	    species=${k}; 
		    maxReplicates=${maxReps[l]};
		    filename=cell_rdme_Lmem_gradSteep_c1b_${c1b}_c2b_${c2b}_c4_${c4}_c5_${c5}_c6_${c6}_Dk_${Dk}_Dkp_${Dkp}_Dr_${Dr}_Drl_${Drl}.lm;
    		    #filename=cell_rdme_Lmem_gradSteep_noSpecies.lm
		    matfilename=`printf %05d $((i+1))`.`printf %05d $((j+1))`.`printf %05d $((k+1))`.`printf %05d $((l+1))`.mat;
    		    rm -f ../matlab/${outputDir}/${matfilename};
     		    if [ ! -e "../matlab/${outputDir}/${matfilename}" ]; then
         	    fileSizeBlocks=(`ls -s ../${dataDir}/${filename}`);
         	    fileSizeBlocks=${fileSizeBlocks[0]};
         	    if [ ${fileSizeBlocks} -gt 16 ]; then
              	       echo "Processing $filename->$matfilename";
	      	   #python calc_rdme_pdf.py matlab/pdf.dat data/${filename} 5 ${i};
	      	       python-submit calc_test_rep.py ../matlab/${outputDir} ../${dataDir}/${filename} ${species} ${maxReplicates} ${i} ${j} ${k} ${l} ../${logsDir}/calc_pdf_${filename}.${species}.${maxReplicates}.log batch rsharm28 02:00:00;
         	   else
                       echo "Skipping small file $filename";
         	   fi;
         	   else
                       echo "Skipping   $filename->$matfilename";
         	   fi;
		   sleep 1m;
		done;
	    done;
	done;
    done;
