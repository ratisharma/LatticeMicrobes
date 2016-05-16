clear all
for d=1
% filename=sprintf('../../feedback_kp/data_Dkp15_Drl15_memThick2/gradient/c7_4.0e-6/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
% filename=sprintf('../../data/data_1.0Dkp14_Drl14_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.6e-5_c2b_1.2e-5_c3b_1.5e-3_c0a_4.0e-3_c4_7.1e-3_c5_6.0e-3_c6_4.3e-5_Dk_5.0e-12_Dkp_1.0e-14_Dr_5.0e-12_Drl_1.0e-14.lm',d);
filename=sprintf('../../data/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
cutoffDistance=25;
% msd2=zeros(20,200);
rep=[4]%,33] % ,41,17];
for replicate1=1:2
    filenumber=d
    replicate=rep(replicate1)
    ts=cast(permute(hdf5read(filename,...
    sprintf('/Simulations/%07d/SpeciesCountTimes',replicate)),[2,1]),'double');
    counts=cast(permute(hdf5read(filename,...
    sprintf('/Simulations/%07d/SpeciesCounts',replicate)),[2,1]),'double');
    subplot(2,1,replicate1)
%     figure()
%     title(['ts = ', num2str(ts)])
%     [msd,cm2]=clusterMSD_surface(filename,replicate,cutoffDistance);
    [msd,cm2]=clusterMSD_surface_traj(filename,replicate,cutoffDistance);
    msd2(replicate,1:size(msd,1))=msd;
    
%     size(cm2)
%     cm3(replicate,1:size(cm2,1))=cm2;
%     scatter(1:size(msd2,2),msd2(replicate,:),600,'.');
%     hold on;
clear msd cm2
end

% for j=1:size(msd2,2)
% %     scatter(1:200,msd2(j,:),50,'.');
%     [idx]=ind2sub(size(msd2(:,j)),find(msd2(:,j)>0));
%     
%     meanMSD(j)=sum(msd2(:,j),1)./size(idx,1);
% %     hold on;
% end
% for k=1:replicate
%     scatter(1:size(msd2,2),msd2(k,:),50,'.');
%     hold on;
% end
% plot(1:size(msd2,2),meanMSD,'b')

% delete('analysisData/msd_surface_Dkp15/gradientmsd_surface_gradient_%d.mat',d);
% outputFilename=sprintf('analysisData/msd_surface_1.0Dkp14/gradient/msd_surface_gradient_%d.mat',d);
% save(outputFilename,'msd2');
% clear msd2
end

    