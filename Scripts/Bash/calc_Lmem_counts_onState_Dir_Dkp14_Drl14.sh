
#!/bin/bash

    #X=64;
    #maxTime=1e4 writeInterval=1e2;
    #replicates="1-50";
    outputDir=pdf_Lmem_Dkp14_Drl14/min_ligand/Dirs_tavg_on.dat;
    dataDir=data_Dkp14_Drl14_memThick2/min_ligand;
    logsDir=logs_Dkp14_Drl14_memThick2/min_ligand;
    onThresholds=(44 9 9);
	Dk=5.0e-12;
	Dkps=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15);
	Dr=5.0e-12;
	Drls=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15);
	Dl=50e-12;

c1b=1.0e-5;
c2b=2.0e-5;
c3b=2.0e-3;
c0a=4.0e-3;
c4=7.5e-3;
c5=7.0e-3;
c6=4.5e-5;


    is=`seq -f "%g" 3 3`;
    js=`seq -f "%g" 3 3`;
    ks=`seq -f "%g" 2 2`;
    #qs=`seq -f "%g" 1 1`;
    ps=`seq -f "%g" 1 1 40`;
 for i in $is; do
	for j in $js; do
	    for k in $ks; do
		for p in $ps; do
			Dkp=${Dkps[i]};
			Drl=${Drls[j]};
			species=${k};
			fileNum=${p};
			onThreshold=${onThresholds[k]};
filename=cell_rdme_Lmem_gradSteep_t500_${p}_c1b_${c1b}_c2b_${c2b}_c3b_${c3b}_c0a_${c0a}_c4_${c4}_c5_${c5}_c6_${c6}_Dk_${Dk}_Dkp_${Dkp}_Dr_${Dr}_Drl_${Drl}.lm;
			matfilename=`printf %05d $((i+1))`.`printf %05d $((j+1))`.`printf %05d $((p+1))`.`printf %05d $((k+1))`.mat;
			#rm -f ../matlab/${outputDir}/${matfilename};
			if [ ! -e "../matlab/${outputDir}/${matfilename}" ]; then
			fileSizeBlocks=(`ls -s ../${dataDir}/${filename}`);
			fileSizeBlocks=${fileSizeBlocks[0]};
			if [ ${fileSizeBlocks} -gt 16 ]; then
			echo "Processing $filename->$matfilename";
			python-submit calc_counts_onState_Dir.py ../matlab/${outputDir} ../${dataDir}/${filename} ${species} ${onThreshold} ${i} ${j} ${p} ${k} ../${logsDir}/calc_counts_${filename}.${species}.on.log batch rsharm28 6:00:00;  	   
			###python-submit calc_counts_onState_Dir.py ../matlab/${outputDir} ../${dataDir}/${filename} ${species} ${onThreshold} ${i} ${j} ${p} ${k} ../${logsDir}/calc_counts_${filename}.${species}.log analysis			
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
done;
