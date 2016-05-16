clear all
for d=1:36
filename=sprintf('../../feedback_kp/data_Dkp15_Drl15_memThick2/gradient/c7_4.0e-6/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
% filename=sprintf('../../data_Dkp15_Drl15_memThick2/gradient/gradient/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
cutoffDistance=25;
% msd2=zeros(20,200);
for replicate=101:200
    R=replicate-100
    ts=cast(permute(hdf5read(filename,...
    sprintf('/Simulations/%07d/SpeciesCountTimes',replicate)),[2,1]),'double');
    counts=cast(permute(hdf5read(filename,...
    sprintf('/Simulations/%07d/SpeciesCounts',replicate)),[2,1]),'double');
    msd=clusterMSD(filename,replicate,cutoffDistance);
    msd2(R,1:size(msd,1))=msd;
%     scatter(1:size(msd2,2),msd2(replicate,:),600,'.');
%     hold on;
clear msd
end

% for j=1:size(msd2,2)
% %     scatter(1:200,msd2(j,:),50,'.');
%     [idx]=ind2sub(size(msd2(:,j)),find(msd2(:,j)>0));
%     
%     meanMSD(j)=sum(msd2(:,j),1)./size(idx,1);
% %     hold on;
% end
% for k=1:100
%     scatter(1:size(msd2,2),msd2(k,:),50,'.');
%     hold on;
% end
% plot(1:size(msd2,2),meanMSD,'b')

% delete('analysisData/feedback_msd_gradient.mat');
outputFilename=sprintf('analysisData/msd/feedback_msd_gradient_100_%d.mat',d);
save(outputFilename,'msd2');
clear msd2
end

    