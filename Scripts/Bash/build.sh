    # Build the simulation files.
    Dk=5.00e-12 ;
    Dr=5.00e-12 ;
    Dl=5.00e-11 ;
    #          0        1        2 
    Dkps=(5.00e-15 1.00e-14 5.00e-14 );
    #          0        1        2 
    Drls=(5.00e-15 1.00e-14 5.00e-14 );
    #          0        1        2 
    c1bs=(5.00e-06 6.00e-06 1.00e-05 );
    #          0        1        2 
    c2bs=(1.00e-05 1.20e-05 2.00e-05 );
    #          0        1        2 
    c3bs=(1.00e-03 1.50e-03 2.00e-03 );
    #          0        1        2 
    c0as=(4.00e-03 4.00e-03 4.00e-03 );
    #          0        1        2 
    c4s=(7.00e-03 7.10e-03 7.50e-03 );
    #          0        1        2 
    c5s=(5.00e-03 6.00e-03 7.00e-03 );
    #          0        1        2 
    c6s=(4.00e-05 4.30e-05 4.50e-05 );
    #                       0          1 
    boundaryTypes=('gradient' 'constant');
    #               0      1 
    modelTypes=('MII' 'MIII');
    maxTime=1e3; writeInterval=1e-4; latticeWriteInterval=1e-2;
    is=`seq -f "%g" 0 2`;
    js="1";
    ks="0";
    for i in $is; do
        for j in $js; do
            for k in $ks; do
                Dkp=${Dkps[i]};
                Drl=${Drls[i]};
                c1b=${c1bs[i]};
                c2b=${c2bs[i]};
                c3b=${c3bs[i]};
                c0a=${c0as[i]};
                c4=${c4s[i]};
                c5=${c5s[i]};
                c6=${c6s[i]};
                c1a=`awk -v a="2" -v b="${c1b}" 'BEGIN{print (a * b)}'`
                c2a=`awk -v a="2" -v b="${c2b}" 'BEGIN{print (a * b)}'`
                c3a=`awk -v a="2" -v b="${c3b}" 'BEGIN{print (a * b)}'`
                c0b=`awk -v a="2" -v b="${c0a}" 'BEGIN{print (a * b)}'`
                boundaryType=${boundaryTypes[j]}
                modelType=${modelTypes[k]}
                filename=ts_${modelType}_${Dkp}_${boundaryType}.lm
                fileSizeBlocks=0; if [ -e "data/lm/${filename}" ]; then fileSizeBlocks=(`ls -s data/lm/${filename}`); fileSizeBlocks=${fileSizeBlocks[0]}; fi;
                if [ ${fileSizeBlocks} -lt 320000 ]; then
                    echo "Building $filename";
                    rm -f logs/${filename}.log;
                    cp ${modelType}.lm data/lm/${filename};
                    lm_setrm data/lm/${filename} "ReactionRateConstants(0:7,0)=[${c1a};${c1b};${c2a};${c2b};${c3a};${c3b};${c0a};${c0b}]";
                    lm_setrm data/lm/${filename} "ReactionRateConstants(8:10,0)=[${c4};${c5};${c6}]";
                    lm_setdm data/lm/${filename} numberReactions=11 numberSpecies=7 numberSiteTypes=3 "latticeSize=[50,50,50]" latticeSpacing=5.0e-8 particlesPerSite=16 "DiffusionMatrix=[0,0,0,0,0,${Dl},0;0,0,0,0,0,${Dl},0;0,0,0,0,0,0,0;0,0,0,0,0,${Dl},0;${Dk},${Dkp},${Dkp},${Dk},${Dk},${Dl},${Drl};0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0;0,0,0,0,0,0,0]" "ReactionLocationMatrix=[0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0;0,1,0]";
                    lm_setp  data/lm/${filename} writeInterval=${writeInterval} latticeWriteInterval=${latticeWriteInterval} maxTime=${maxTime};
                    lm_python -s build_cell_5_memThick2.py -sa data/lm/${filename};
                    lm_setp data/lm/${filename} boundaryConditions=FIXED_GRADIENT boundarySite=0 boundarySpecies=5;
                    h5copy -v -f shallow -i "${boundaryType}_ligand.h5" -s "dataset1" -o "data/lm/${filename}" -d "Model/Diffusion/Gradient";
                else
                    echo "Skipping completed file $filename";
                fi;
            done;
        done;
    done;

