#!/bin/bash

    X=64;
    maxTime=1e4 writeInterval=1e2;
    replicates="1-50";
    outputDir=pdf_rl.dat;
    dataDir=data_rl;
    logsDir=logs_rl;
    c4=5.0e-3;
    c5=8.0e-3;
    Drs=(5e-12 5e-13 5e-14 5e-15 5e-16);
    Drls=(5e-12 5e-13 5e-14 5e-15 5e-16);
    is=`seq -f "%g" 0 0`;
    js=`seq -f "%g" 1 1`;
    ks=`seq -f "%g" 1 1 2`;
    for i in $is; do
	for j in $js; do
	    for k in $ks; do
            	Dr=${Drs[i]};
	    	Drl=${Drls[j]};
	    	species=${k}; 
		filename=test_cell_rdme_rl_c4_${c4}_c5_${c5}_Dr_${Dr}_Drl_${Drl}.lm;
    		matfilename=`printf %05d $((i+1))`.`printf %05d $((j+1))`.`printf %05d $((k+1))`.mat;
    		#rm -f matlab/pdf.dat/${matfilename};
    		if [ ! -e "../matlab/${outputDir}/${matfilename}" ]; then
         	fileSizeBlocks=(`ls -s ../${dataDir}/${filename}`);
         	fileSizeBlocks=${fileSizeBlocks[0]};
         	if [ ${fileSizeBlocks} -gt 16 ]; then
              	   echo "Processing $filename->$matfilename";
	      	   #python calc_rdme_pdf.py matlab/pdf.dat data/${filename} 5 ${i};
	      	   python-submit calc_test.py ../matlab/${outputDir} ../${dataDir}/${filename} ${species} ${i} ${j} ${k} ../${logsDir}/calc_pdf_${filename}.log batch rsharm28 2:00:00;
         	else
                   echo "Skipping small file $filename";
         	fi;
         	else
                   echo "Skipping   $filename->$matfilename";
         	fi;
	    done;
	done;
    done;
