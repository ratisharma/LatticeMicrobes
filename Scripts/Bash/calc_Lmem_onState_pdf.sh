
#!/bin/bash

    X=64;
    maxTime=1e4 writeInterval=1e2;
    replicates="1-50";
    outputDir=pdf_c6_4_memThick2/tavg_on_Dkp_5e-12.dat;
    dataDir=data_gradSteep_memThick2;
    logsDir=logs_gradSteep_memThick2;
    onThresholds=(42 22 13);
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
    is=`seq -f "%g" 1 1`;
    js=`seq -f "%g" 1 1`;
    ks=`seq -f "%g" 2 2`;
    for i in $is; do
	for j in $js; do
	    for k in $ks; do
            	Dkp=${Dkps[i]};
	    	Drl=${Drls[j]};
	    	species=${k};
		onThreshold=${onThresholds[k]}; 
		filename=cell_rdme_Lmem_gradSteep_c1b_${c1b}_c2b_${c2b}_c4_${c4}_c5_${c5}_c6_${c6}_Dk_${Dk}_Dkp_${Dkp}_Dr_${Dr}_Drl_${Drl}.lm;
    		matfilename=`printf %05d $((i+1))`.`printf %05d $((j+1))`.`printf %05d $((k+1))`.mat;
    		rm -f ../matlab/${outputDir}/${matfilename};
    		if [ ! -e "../matlab/${outputDir}/${matfilename}" ]; then
         	fileSizeBlocks=(`ls -s ../${dataDir}/${filename}`);
         	fileSizeBlocks=${fileSizeBlocks[0]};
         	if [ ${fileSizeBlocks} -gt 16 ]; then
              	   echo "Processing $filename->$matfilename";
	      	   #python calc_rdme_pdf.py matlab/pdf.dat data/${filename} 5 ${i};
		   python-submit calc_test_onState.py ../matlab/${outputDir} ../${dataDir}/${filename} ${species} ${onThreshold} ${i} ${j} ${k} ../${logsDir}/calc_pdf_${filename}.${species}.on.log batch rsharm28 2:00:00;	      	   
		   #python-submit calc_test.py ../matlab/${outputDir} ../${dataDir}/${filename} ${species} ${i} ${j} ${k} ../${logsDir}/calc_pdf_${filename}.${species}.log batch rsharm28 2:00:00;
         	else
                   echo "Skipping small file $filename";
         	fi;
         	else
                   echo "Skipping   $filename->$matfilename";
         	fi;
		#sleep 3m;
	    done;
	done;
    done;
