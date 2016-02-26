
#!/bin/bash

    X=64;
    maxTime=1e4 writeInterval=1e2;
    replicates="1-50";
    outputDir=pdf_Lmem_Dkp15_Drl15/min_ligand/tavg_on_c4_7_c5_5_c6_4_2000.dat;
    dataDir=data_Dkp15_Drl15_memThick2/min_ligand;
    logsDir=logs_Dkp15_Drl15_memThick2/min_ligand;
    onThresholds=(40 10 10);
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
   
    is=`seq -f "%g" 4 4`;
    js=`seq -f "%g" 4 4`;
    ks=`seq -f "%g" 0 1 2`;
    ls=`seq -f "%g" 6 6`;
    ms=`seq -f "%g" 4 4`;
    ns=`seq -f "%g" 3 3`;
    
    for i in $is; do
	for j in $js; do
	    for k in $ks; do
		for l in $ls; do
		for m in $ms; do
		for n in $ns; do
            	Dkp=${Dkps[i]};
	    	Drl=${Drls[j]};
	    	species=${k};
		c4=${c4s[l]};
		c5=${c5s[m]};
		c6=${c6s[n]};
		onThreshold=${onThresholds[k]}; 
		filename=cell_rdme_Lmem_gradSteep_t500_c1b_${c1b}_c2b_${c2b}_c3b_${c3b}_c0a_${c0a}_c4_${c4}_c5_${c5}_c6_${c6}_Dk_${Dk}_Dkp_${Dkp}_Dr_${Dr}_Drl_${Drl}.lm;
		Dirpath=min_ligand
    		matfilename=`printf %05d $((i+1))`.`printf %05d $((j+1))`.`printf %05d $((k+1))`.mat;
    		rm -f ../matlab/${outputDir}/${matfilename};
		   python-submit calc_test_onState_Dir.py ../matlab/${outputDir} ../${dataDir} ${species} ${onThreshold} ${i} ${j} ${k} ../${logsDir}/calc_pdf.${species}.on.log batch rsharm28 22:00:00;  	   
		#sleep 3m;
		done;
		done;
		done;
	    done;
	done;
    done;
