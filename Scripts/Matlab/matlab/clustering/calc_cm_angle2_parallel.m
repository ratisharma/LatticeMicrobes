clear all

for d=1:10
    filenum=d
% filename=sprintf('../../data/feedback_kp/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
% filename=sprintf('../../data/feedback_kp/data_Dkp15_Drl15_memThick2/min_ligand/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
% filename=sprintf('../../data/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
filename=sprintf('../../data/data_Dkp15_Drl15_memThick2/min_ligand/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
% filename=sprintf('../../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand_countR_400_t500.lm');
cutoffDistance=25;
% msd2=zeros(20,200);
parfor replicate=1:200
    R=200*(d-1)+replicate
    ts=cast(permute(hdf5read(filename,...
    sprintf('/Simulations/%07d/SpeciesCountTimes',replicate)),[2,1]),'double');
    counts=cast(permute(hdf5read(filename,...
    sprintf('/Simulations/%07d/SpeciesCounts',replicate)),[2,1]),'double');
%     plot(1:size(ts,2),counts(:,3))
    [msd,cm2]=clusterMSD(filename,replicate,cutoffDistance);
    if cm2==0
        continue;
    else
%     cm3(replicate,1:size(cm2,1))=cm2;
%     scatter(1:size(msd2,2),msd2(replicate,:),600,'.');
%     hold on;

ctr=25;
for a3=1:size(cm2,1)
    vabx(replicate,a3)=cm2(a3,1)-ctr;
    vaby(replicate,a3)=cm2(a3,2)-ctr;
    vabz(replicate,a3)=cm2(a3,3)-ctr;
    va0x=0-ctr;
    va0y=0-ctr;
    va0z=0-ctr;
    cr0bx(replicate,a3)=va0y*vabz(replicate,a3)-va0z*vaby(replicate,a3);
    cr0by(replicate,a3)=va0z*vabx(replicate,a3)-va0x*vabz(replicate,a3);
    cr0bz(replicate,a3)=va0x*vaby(replicate,a3)-va0y*vabx(replicate,a3);
    ab(replicate,a3)=sqrt((vabx(replicate,a3))^2+(vaby(replicate,a3))^2+(vaby(replicate,a3))^2);
    a0=sqrt(va0x^2+va0y^2+va0z^2);
%     angle(a)=acos((vabx(a)*va0x+vaby(a)*va0y+vabz(a)*va0z)/(ab(a)*a0));
    dot0b(a3)=vabx(a3)*va0x+vaby(a3)*va0y+vabz(a3)*va0z;
    normcr0b(a3)=sqrt((cr0bx(a3))^2+(cr0by(a3))^2+(cr0bz(a3))^2);
    angle2(a3)=atan2(normcr0b(a3),dot0b(a3));
    modcm(a3)=(cm2(a3,1)^2+cm2(a3,2)^2+cm2(a3,3)^2);
end
% figure
scatter(1:size(angle2,2),angle2,600,'.');
hold on;
angleBeg(R)=angle2(1);
angleEnd(R)=angle2(end);
delTheta(R)=angle2(size(angle2,2))-angle2(1);
    end
    clear cm2 angle2
end
end

% % % % % % % delete('analysisData/gradient_2000_1.mat');
% outputFilename=sprintf('analysisData/min_ligand_2000_1.mat');
% save(outputFilename,'delTheta','angleBeg','angleEnd');

