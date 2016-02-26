#!/bin/bash

    X=64;
    maxTime=1e4 writeInterval=1e2;
    replicates="1-50";
    outputDir=pdf_mono.dat;
    dataDir=data_mono;
    logsDir=logs_mono;
    c1b=0.5e-5;
    c2b=1.0e-5;
    c4=5.0e-3;
    c5=8.0e-3;
    c6=2.0e-5;
    Dk=5.0e-12;
    Dkps=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
    Dr=5.0e-12;
    Dl=5.0e-11;
    Drls=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15 5.0e-16 5.0e-17 5.0e-18);
    is=`seq -f "%g" 1 1`;
    js=`seq -f "%g" 1 1`;
    ks=`seq -f "%g" 0 1 6`;
    for i in $is; do
	for j in $js; do
	    for k in $ks; do
            	Dkp=${Dkps[i]};
	    	Drl=${Drls[j]};
	    	species=${k}; 
		filename=cell_rdme_mono_Dkp_${Dkp}_Drl_${Drl}_50t2000.lm;
    		matfilename=`printf %05d $((i+1))`.`printf %05d $((j+1))`.`printf %05d $((k+1))`.mat;
    		rm -f ../matlab/${outputDir}/${matfilename};
    		if [ ! -e "../matlab/${outputDir}/${matfilename}" ]; then
         	fileSizeBlocks=(`ls -s ../${dataDir}/${filename}`);
         	fileSizeBlocks=${fileSizeBlocks[0]};
         	if [ ${fileSizeBlocks} -gt 16 ]; then
              	   echo "Processing $filename->$matfilename";
	      	   #python calc_rdme_pdf.py matlab/pdf.dat data/${filename} 5 ${i};
	      	   python-submit calc_test.py ../matlab/${outputDir} ../${dataDir}/${filename} ${species} ${i} ${j} ${k} ../${logsDir}/calc_pdf_${filename}.${species}.log batch rsharm28 2:00:00;
         	else
                   echo "Skipping small file $filename";
         	fi;
         	else
                   echo "Skipping   $filename->$matfilename";
         	fi;
		sleep 62m;
	    done;
	done;
    done;
