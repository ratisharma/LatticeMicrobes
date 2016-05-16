clear all
for d=11:40
    filenum=d
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%%%    D=Dkp13
  filename=sprintf('../../data_Dkp13_Drl13_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_%d_c1b_2.0e-5_c2b_6.0e-5_c3b_3.0e-3_c0a_4.0e-3_c4_7.5e-3_c5_6.0e-3_c6_4.5e-5_Dk_5.0e-12_Dkp_5.0e-13_Dr_5.0e-12_Drl_5.0e-13.lm',d);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename=sprintf('../../feedback_kp/data_Dkp15_Drl15_memThick2/gradient/c7_4.0e-6/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
% filename=sprintf('../../feedback_kp/data_Dkp15_Drl15_memThick2/min_ligand/c7_4.0e-6/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
% filename=sprintf('../../data_Dkp15_Drl15_memThick2/gradient/gradient/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
% filename=sprintf('../../data/data_Dkp15_Drl15_memThick2/min_ligand/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
% filename=sprintf('../../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand_countR_400_t500.lm');
cutoffDistance=25;
% msd2=zeros(20,200);
for replicate=1:400
%     R=200*(d-1)+replicate
    sprintf('filename = %d; replicate = %d;',filenum,replicate)
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
    vabx(a3)=cm2(a3,1)-ctr;
    vaby(a3)=cm2(a3,2)-ctr;
    vabz(a3)=cm2(a3,3)-ctr;
    va0x=0-ctr;
    va0y=0-ctr;
    va0z=0-ctr;
    cr0bx(a3)=va0y*vabz(a3)-va0z*vaby(a3);
    cr0by(a3)=va0z*vabx(a3)-va0x*vabz(a3);
    cr0bz(a3)=va0x*vaby(a3)-va0y*vabx(a3);
    ab(a3)=sqrt((vabx(a3))^2+(vaby(a3))^2+(vaby(a3))^2);
    a0=sqrt(va0x^2+va0y^2+va0z^2);
%     angle(a)=acos((vabx(a)*va0x+vaby(a)*va0y+vabz(a)*va0z)/(ab(a)*a0));
    dot0b(a3)=vabx(a3)*va0x+vaby(a3)*va0y+vabz(a3)*va0z;
    normcr0b(a3)=sqrt((cr0bx(a3))^2+(cr0by(a3))^2+(cr0bz(a3))^2);
    angle2(a3)=atan2(normcr0b(a3),dot0b(a3));
    modcm(a3)=(cm2(a3,1)^2+cm2(a3,2)^2+cm2(a3,3)^2);
end
% figure
% scatter(1:size(angle2,2),angle2,600,'.');
% hold on;
angler(replicate,1:size(angle2,2))=angle2;
angleBeg(replicate)=angle2(1);
angleEnd(replicate)=angle2(end);
delTheta(replicate)=angle2(size(angle2,2))-angle2(1);

    end
    msd2(replicate,1:size(msd,1))=msd;
    clear cm2 angle2 msd
end
outputFilename1=sprintf('analysisData/cm_Dk13/gradient/gradient_%d.mat',d);
save(outputFilename1,'delTheta','angleBeg','angleEnd','angler');
outputFilename2=sprintf('analysisData/msd_Dk13/gradient/msd_gradient_%d.mat',d);
save(outputFilename2,'msd2');
clear angleBeg angleEnd delTheta angler msd2
end

% % % % % % % delete('analysisData/gradient_2000_1.mat');
% % outputFilename=sprintf('analysisData/feedback_gradient_6000_2.mat');
% % save(outputFilename,'delTheta','angleBeg','angleEnd');

