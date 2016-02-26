#!/bin/bash


replicates="1-15";
dataDir=data_Dkp15_memThick2;
logsDir=logs_Dkp15_memThick2;
buildCell=build_cell_noL.py;
Dk="5e-12";
Dl="50e-12";
Dkp=5.0e-15;
c1bs=(0.5e-5 1.0e-5 1.5e-5 2.0e-5 2.5e-5 3.0e-5 4.0e-6 3.0e-6 2.0e-6 1.0e-6);
c2bs=(1.0e-5 2.0e-5 3.0e-5 4.0e-5 5.0e-5 6.0e-5 7.0e-5);
c3bs=(4.0e-3 3.0e-3 2.0e-3 1.0e-3);
c0as=(4.0e-3 3.0e-3 2.0e-3 1.0e-3);
#c4s=(1.0e-3 2.0e-3 3.0e-3 4.0e-3 5.0e-3 6.0e-3 7.0e-3 8.0e-3);
#c5s=(1.0e-3 2.0e-3 3.0e-3 4.0e-3 5.0e-3 6.0e-3 7.0e-3 8.0e-3);
#c6s=(1.0e-5 2.0e-5 3.0e-5 4.0e-5 5.0e-5);
is=`seq -f "%g" 0 0`;
js=`seq -f "%g" 0 0`;
ks=`seq -f "%g" 0 1 3`;
ls=`seq -f "%g" 0 1 3`;
#ks=`seq -f "%g" 7 7`;
#ls=`seq -f "%g" 7 7`;
#ms=`seq -f "%g" 2 1 4`;
for i in $is; do
    for j in $js; do
	for k in $ks; do
	    for l in $ls; do
#		for m in $ms; do
		c1b=${c1bs[i]};
		c2b=${c2bs[j]};
		c3b=${c3bs[k]};
		c0a=${c0as[l]};
#		c4=${c4s[k]};
#		c5=${c5s[l]};
#		c6=${c6s[m]};
		c1a=`awk -v a="2" -v b="${c1b}" 'BEGIN{print (a * b)}'`
		c2a=`awk -v a="2" -v b="${c2b}" 'BEGIN{print (a * b)}'`
		c3a=`awk -v a="2" -v b="${c3b}" 'BEGIN{print (a * b)}'`
		c0b=`awk -v a="2" -v b="${c0a}" 'BEGIN{print (a * b)}'`
		filename=cell_rdme_Dkp_${Dkp}_c1b_${c1b}_c2b_${c2b}_c3b_${c3b}_c0a_${c0a}.lm;
		rm -f ../${dataDir}/${filename};
		rm -f ../${logsDir}/${filename}.log;
		cp kin.lm ../${dataDir}/${filename};
		lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(0:7,0)=[${c1a};${c1b};${c2a};${c2b};${c3a};${c3b};${c0a};${c0b}]";
#		lm_setrm ../${dataDir}/${filename} "ReactionRateConstants(8:10,0)=[${c4};${c5};${c6}]";
		lm_setdm ../${dataDir}/${filename} numberReactions=8 numberSpecies=4 numberSiteTypes=3 "latticeSize=[50,50,50]" latticeSpacing=5.0e-8 particlesPerSite=8 "DiffusionMatrix=[0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0;${Dk},${Dkp},${Dkp},${Dk};0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0]" "ReactionLocationMatrix=[0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0]";
		lm_setp ../${dataDir}/${filename} writeInterval=1e0 latticeWriteInterval=1e2 maxTime=2e3;
		lm_python -s ${buildCell} -sa ../${dataDir}/${filename};
	#	lm_setp ../${dataDir}/${filename} boundaryConditions=FIXED_GRADIENT boundarySite=0 boundarySpecies=5;
		#lmes-submit ../${dataDir}/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../${logsDir}/${filename}.log gpu-1 16;
		lmes-submit ../${dataDir}/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -cr 1 ../${logsDir}/${filename}.log batch 16 rsharm28 10:00:00;
	#	done;
	    done;
	done;
   done;
done;
