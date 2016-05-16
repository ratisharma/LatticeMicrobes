clear all
% inputFilename=sprintf('../data/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
% inputFilename=sprintf('../data/feedback_kp/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
% inputFilename=sprintf('../data/data_Dkp14_Drl14_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_1.0e-5_c2b_2.0e-5_c3b_2.0e-3_c0a_4.0e-3_c4_7.5e-3_c5_7.0e-3_c6_4.5e-5_Dk_5.0e-12_Dkp_5.0e-14_Dr_5.0e-12_Drl_5.0e-14.lm');
inputFilename=sprintf('../data/data_1.0Dkp14_Drl14_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_2_c1b_0.6e-5_c2b_1.2e-5_c3b_1.5e-3_c0a_4.0e-3_c4_7.1e-3_c5_6.0e-3_c6_4.3e-5_Dk_5.0e-12_Dkp_1.0e-14_Dr_5.0e-12_Drl_1.0e-14.lm');
species=3;
onThreshold=15;
speciesCounts=0;
totTime=0;
numberReplicates=200;
for R=[1:numberReplicates]
if R == 1
ts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
end
counts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
for ti=[1:size(ts,2)]
    if counts(ti,species)>onThreshold,
        speciesCounts = speciesCounts+counts(ti,species);
        totTime = totTime +1;
    end 
% Pt1(counts(ti,species)+1,ti)=Pt1(counts(ti,species)+1,ti)+1;
end
end
% Pt1=Pt1./numberReplicates;
avgCounts = speciesCounts/totTime