clear all
rows=1;cols=3;plotIndex=1;
for file=1:3
    if file==1
        inputFilename=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand_countR_100.lm');
        numberReplicates=15;
    elseif file==2
        inputFilename=sprintf('../data/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
        numberReplicates=200;
    elseif file==3
        inputFilename=sprintf('../data/feedback_kp/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
        numberReplicates=200;
    end
        totKinases=64;
x=[0:totKinases];

species=1;
for R=[1:numberReplicates]
if R == 1
% % R=4;
ts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
Pt1=zeros(size(x,2),size(ts,2));
end
counts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
for ti=[1:size(ts,2)]
Pt1(counts(ti,species)+1,ti)=Pt1(counts(ti,species)+1,ti)+1;
end
end
Pt1=Pt1./numberReplicates;

Pts=sum(Pt1,2);
subplot(rows,cols,plotIndex)
plot(1-x./totKinases,Pts/sum(Pts),'b','LineWidth',3);
xlabel('Fraction of phosphorylated kinases','FontWeight','b','FontSize',14)
ylabel('Probability','FontWeight','b','FontSize',14)
plotIndex=plotIndex+1
    
end