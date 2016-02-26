
#!/bin/bash

    #X=64;
    #maxTime=1e4 writeInterval=1e2;
    #replicates="1-50";
    #outputDir=pdf/pdf_mono_Dkp15_Drl15/traj_countR_400_ligand.dat;
    #dataDir=data/data_mono_Dkp15_Drl15;
    #logsDir=data/logs_Dkp15_Drl15_memThick2/gradient;
    outputDir=pdf/pdf_Lmem_Dkp14_Drl14/gradient/Dirs_traj_on.dat;
    dataDir=data/data_Dkp14_Drl14_memThick2/gradient;    
	onThresholds=(44 1 1 1 1);
	Dk=5.0e-12;
	Dkps=(0.0 5.0e-12 5.0e-13 1.0e-14 5.0e-14 5.0e-15);
	Dr=5.0e-12;
	Drls=(0.0 5.0e-12 5.0e-13 1.0e-14 5.0e-14 5.0e-15);
	Dl=50e-12;

    is=`seq -f "%g" 4 4`;
    js=`seq -f "%g" 4 4`;
    ks=`seq -f "%g" 2 2`;
    ps=`seq -f "%g" 1 1`;
    Rs=`seq -f "%g" 1 1 200`;
    
 for i in $is; do
	for j in $js; do
	    for k in $ks; do
	    				for p in $ps; do
					for R in $Rs; do
	    					Dkp=${Dkps[i]};
	    					Drl=${Drls[j]};
	    					species=${k};
	    					#c4=${c4s[l]};
	    					#c5=${c5s[m]};
	    					#c6=${c6s[n]};
						####c7=${c7s[q]};
	    					fileNum=${p};
	    					onThreshold=${onThresholds[k]};
						replicate=${R};
						echo "replicate = ${R}"; 
#filename=cell_rdme_mono_ligand_countR_400_t500.lm
#filename=cell_rdme_Lmem_gradSteep_t500_${p}_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_${Dkp}_Dr_5.0e-12_Drl_${Drl}.lm;
##filename=cell_rdme_Lmem_gradSteep_t500_${p}_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_${Dkp}_Dr_5.0e-12_Drl_${Drl}.lm;
##filename=cell_rdme_Lmem_gradSteep_t500_2_c1b_0.6e-5_c2b_1.2e-5_c3b_1.5e-3_c0a_4.0e-3_c4_7.1e-3_c5_6.0e-3_c6_4.3e-5_Dk_5.0e-12_Dkp_1.0e-14_Dr_5.0e-12_Drl_1.0e-14.lm;
filename=cell_rdme_Lmem_gradSteep_t500_1_c1b_1.0e-5_c2b_2.0e-5_c3b_2.0e-3_c0a_4.0e-3_c4_7.5e-3_c5_7.0e-3_c6_4.5e-5_Dk_5.0e-12_Dkp_5.0e-14_Dr_5.0e-12_Drl_5.0e-14.lm;
						matfilename=`printf %05d $((i+1))`.`printf %05d $((j+1))`.`printf %05d $((p+1))`.`printf %05d $((k+1))`.`printf %05d $((R+1))`.mat;
						rm -f ../${outputDir}/${matfilename};
						if [ ! -e "../${outputDir}/${matfilename}" ]; then
         					fileSizeBlocks=(`ls -s ../${dataDir}/${filename}`);
         					fileSizeBlocks=${fileSizeBlocks[0]};
         					if [ ${fileSizeBlocks} -gt 16 ]; then
              	   				echo "Processing $filename->$matfilename";
	    					python calc_counts_onState_traj_Dir_membrane_replicates.py ../${outputDir} ../${dataDir}/${filename} ${species} ${onThreshold} ${R} ${i} ${j} ${p} ${k} ${R}
	    					#../${logsDir}/calc_counts_${filename}.${species}.on.${R}.log batch rsharm28 1:00:00;  	   
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
done;
