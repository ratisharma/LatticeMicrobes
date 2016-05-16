clear all
inputFilename=sprintf('../data/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
% inputFilename=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
size(x1)
species=6;
speciesCounts=0;
totTime=0;
numberReplicates=100;
R=1
if R == 1
ts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',1)),[2,1]),'double');
end
counts=zeros(500,1);
sumCounts=0;
sumSqrCounts=0;
for R=[1:numberReplicates]
    R
    counts=zeros(500,1);
for ti=[1:size(ts,2)-1]
    L=permute(hdf5read(inputFilename,sprintf('/Simulations/%07d/Lattice/%010d',R,ti)),[4:-1:1]);
    for i=1:size(x1)
        for l=1:8
            if L(x1(i),y1(i),z1(i),l)==6,
                counts(ti)=counts(ti)+1;
            end
        end
    end
end
   sumCounts = sumCounts+sum(counts);
   sumSqrCounts = sumSqrCounts+sum(counts.^2);
end
avgCounts = sumCounts/(numberReplicates*500);
sqrCounts = sumSqrCounts/(numberReplicates*500);
varCounts = sqrCounts-avgCounts^2
