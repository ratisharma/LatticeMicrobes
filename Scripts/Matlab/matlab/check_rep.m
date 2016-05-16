clear all
% for d=1:80
%     d
% filename=sprintf('../feedback_kp/data_Dkp15_Drl15_memThick2/gradient/c7_4.0e-6/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
% filename=sprintf('../data_Dkp15_Drl15_memThick2/min_ligand/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
% cutoffDistance=25;
% msd2=zeros(20,200);
% R=200;
% ts=cast(permute(hdf5read(filename,...
% sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
% 
% counts=cast(permute(hdf5read(filename,...
% sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
% plot(ts,counts(:,1));
% hold on;
% end


 totKinases=64;
x=[0:totKinases];
% filename=sprintf('../feedback_kp/data_Dkp15_Drl15_memThick2/gradient/c7_4.0e-6/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
inputFilename=sprintf('../data_Dkp15_Drl15_memThick2/min_ligand/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
numberReplicates=200;
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
subplot(2,2,1)
Pts=sum(Pt1,2);
plot(1-x./totKinases,Pts,'b');
    xlabel('Fraction of Kinases')
    ylabel('Probability')
    
R=1;
ts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');

counts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
subplot(2,2,3);
plot(ts,counts(:,1))
xlabel('time (s)')
ylabel('Kinase copy number')


inputFilename=sprintf('../feedback_kp/data_Dkp15_Drl15_memThick2/min_ligand/c7_4.0e-6/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
numberReplicates=200;
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
subplot(2,2,2)
Pts=sum(Pt1,2);
plot(1-x./totKinases,Pts,'b');
    xlabel('Fraction of Kinases')
    ylabel('Probability')
    
R=1;
ts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');

counts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
subplot(2,2,4);
plot(ts,counts(:,1))
xlabel('time (s)')
ylabel('Kinase copy number')



