    # Execute the simulations.
    #          0        1        2 
    Dkps=(5.00e-15 1.00e-14 5.00e-14 );
    #                       0          1 
    boundaryTypes=('gradient' 'constant');
    #               0      1 
    modelTypes=('MII' 'MIII');
    replicatess=('1-2500' '2501-5000');
    is="0 1 2";
    js="1";
    ks="0";
    ls="0";
    for i in $is; do
        for j in $js; do
            for k in $ks; do
                for l in $ls; do
                    Dkp=${Dkps[i]};
                    boundaryType=${boundaryTypes[j]};
                    modelType=${modelTypes[k]};
                    replicates=${replicatess[l]};
                    filename=ts_${modelType}_${Dkp}_${boundaryType}.lm;
                    fileSizeBlocks=0; if [ -e "data/lm/${filename}" ]; then fileSizeBlocks=(`ls -s data/lm/${filename}`); fileSizeBlocks=${fileSizeBlocks[0]}; fi;
                    if [ ${fileSizeBlocks} -lt 320000 ]; then
                        echo "Starting $filename";
                        lmes-submit data/lm/${filename} -m lm::rdme::NextSubvolumeSolver -r ${replicates} -ff sfile -fo data/lm/${filename%.*}_${l}.sfile logs/${filename}_${l}.log parallel 360 eroberts 48:00:00;
                    else
                        echo "Skipping completed file $filename";
                    fi;
                done;
            done;
        done;
    done;

