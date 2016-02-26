
#!/bin/bash

    #X=64;
    #maxTime=1e4 writeInterval=1e2;
    #replicates="1-50";
    outputDir=pdf/pdf_Lmem_Dkp15_Drl15/gradient/Dirs_onEvents_c4_7_c5_5_c6_4.dat;
    dataDir=data/data_Dkp15_Drl15_memThick2/gradient;
    logsDir=logs_Dkp15_Drl15_memThick2/gradient;
    onThresholds=(44 10 4);
	Dk=5.0e-12;
	Dkps=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15);
	Dr=5.0e-12;
	Drls=(0.0 5.0e-12 5.0e-13 5.0e-14 5.0e-15);
	Dl=50e-12;
	c1b=0.5e-5;
	c2b=1.0e-5;
	c3b=1.0e-3;
	c0a=4.0e-3;
	c4s=(1.0e-3 2.0e-3 3.0e-3 4.0e-3 5.0e-3 6.0e-3 7.0e-3 8.0e-3);
	c5s=(1.0e-3 2.0e-3 3.0e-3 4.0e-3 5.0e-3 6.0e-3 7.0e-3 8.0e-3);
	c6s=(1.0e-5 2.0e-5 3.0e-5 4.0e-5 5.0e-5 6.0e-5 7.0e-5 8.0e-5 9.0e-5 10.0e-5);
	###c7s=(4.0e-7 4.0e-6 4.0e-5);   

    is=`seq -f "%g" 4 4`;
    js=`seq -f "%g" 4 4`;
    ks=`seq -f "%g" 2 2`;
    ls=`seq -f "%g" 6 6`;
    ms=`seq -f "%g" 4 4`;
    ns=`seq -f "%g" 3 3`;
    #qs=`seq -f "%g" 1 1`;
    ps=`seq -f "%g" 1 1`;
    
 for i in $is; do
	for j in $js; do
	    for k in $ks; do
	    	for l in $ls; do
	    		for m in $ms; do
	    			for n in $ns; do
				####for q in $qs; do
	    				for p in $ps; do
	    					Dkp=${Dkps[i]};
	    					Drl=${Drls[j]};
	    					species=${k};
	    					c4=${c4s[l]};
	    					c5=${c5s[m]};
	    					c6=${c6s[n]};
						####c7=${c7s[q]};
	    					fileNum=${p};
	    					onThreshold=${onThresholds[k]}; 
filename=cell_rdme_Lmem_gradSteep_t500_${p}_c1b_${c1b}_c2b_${c2b}_c3b_${c3b}_c0a_${c0a}_c4_${c4}_c5_${c5}_c6_${c6}_Dk_${Dk}_Dkp_${Dkp}_Dr_${Dr}_Drl_${Drl}.lm;
	    					matfilename=`printf %05d $((i+1))`.`printf %05d $((j+1))`.`printf %05d $((p+1))`.`printf %05d $((k+1))`.mat;
						rm -f ../${outputDir}/${matfilename};
						if [ ! -e "../matlab/${outputDir}/${matfilename}" ]; then
         					fileSizeBlocks=(`ls -s ../${dataDir}/${filename}`);
         					fileSizeBlocks=${fileSizeBlocks[0]};
         					if [ ${fileSizeBlocks} -gt 16 ]; then
              	   				echo "Processing $filename->$matfilename";
	    					python calc_onEvents.py ../${outputDir} ../${dataDir}/${filename} ${species} ${onThreshold} ${i} ${j} ${p} ${k} 
	    					#../${logsDir}/calc_counts_${filename}.${species}.on.log batch rsharm28 1:00:00;  	   
						else
                   				echo "Skipping small file $filename";
         					fi;
         					else
                   				echo "Skipping   $filename->$matfilename";
         					fi;
	    					#sleep 3m;
	    				done;
	   				#####done;
					done;
	   			done;
	   		done;
	   	done;
	done;
done;
