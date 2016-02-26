#!/bin/bash

    X=64;
    maxTime=1e4 writeInterval=1e2;
    replicates="1-50";
    pythonFile=calc_test.py
    #pythonFile=calc_time_traj.py
    #outputDir=pdf_gradSteep_memThick2.dat;
    #outputDir=pdf_c6_4_memThick2/Dkp_5e-14_1200rep.dat;
    outputDir=pdf_mono_Dkp15_Drl15/gradient_countR_400.dat;
    dataDir=data_mono_Dkp15_Drl15;
    logsDir=logs_mono_Dkp15_Drl15;
    ##outputDir=pdf_Lmem_Dkp15_Drl15/pdf_c4_7_c5_5_c6_4.dat
    ##dataDir=data_Dkp15_Drl15_memThick2;
    ##logsDir=logs_Dkp15_Drl15_memThick2;
    #dataDir=data_gradSteep_memThick2;
    #logsDir=logs_gradSteep_memThick2;
    c1b=0.5e-5;
    c2b=1.0e-5;
    c3b=1.0e-3;
    c0a=4.0e-3;
    c4=7.0e-3;
    c5=5.0e-3;
    c6=4.0e-5;
    Dk=5.0e-12;
    Dkps=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
    Dr=5.0e-12;
    Dl=5.0e-11;
    Drls=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
    is=`seq -f "%g" 4 4`;
    js=`seq -f "%g" 4 4`;
    ks=`seq -f "%g" 0 1 5`;
    for i in $is; do
	for j in $js; do
	    for k in $ks; do
            	Dkp=${Dkps[i]};
	    	Drl=${Drls[j]};
	    	species=${k}; 
		filename=cell_rdme_mono_ligand_countR_400_t500.lm;		
		####filename=cell_rdme_Lmem_gradSteep_1000reps_c1b_${c1b}_c2b_${c2b}_c3b_${c3b}_c0a_${c0a}_c4_${c4}_c5_${c5}_c6_${c6}_Dk_${Dk}_Dkp_${Dkp}_Dr_${Dr}_Drl_${Drl}.lm;
    		rm -f ../${logsDir}/calc_pdf_${filename}.${species}.log;
		#filename=cell_rdme_Lmem_gradSteep_noSpecies.lm
		matfilename=`printf %05d $((i+1))`.`printf %05d $((j+1))`.`printf %05d $((k+1))`.mat;
    		rm -f ../matlab/${outputDir}/${matfilename};
    		if [ ! -e "../matlab/${outputDir}/${matfilename}" ]; then
         	fileSizeBlocks=(`ls -s ../${dataDir}/${filename}`);
         	fileSizeBlocks=${fileSizeBlocks[0]};
         	if [ ${fileSizeBlocks} -gt 16 ]; then
              	   echo "Processing $filename->$matfilename";
	      	   #python calc_rdme_pdf.py matlab/pdf.dat data/${filename} 5 ${i};
	      	   python-submit ${pythonFile} ../matlab/${outputDir} ../${dataDir}/${filename} ${species} ${i} ${j} ${k} ../${logsDir}/calc_pdf_${filename}.${species}.log batch rsharm28 8:00:00;
         	else
                   echo "Skipping small file $filename";
         	fi;
         	else
                   echo "Skipping   $filename->$matfilename";
         	fi;
		#sleep 10m;
	    done;
	done;
    done;
