clear all
rows=1;cols=3;plotIndex=1;
figure
for diff=1:4
    if diff==2,
        matfile=sprintf('analysisData/Dkp15_Drl15/dist_vs_density_bigCluster_normTraj.mat');    
        inputFile=sprintf('../data/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
        matfile2=sprintf('analysisData/Dkp15_Drl15/dist_vs_density_bigCluster_min_ligand.mat');
            species=3;
            E=64;
            avgProb=23.3604/9028;
    elseif diff==3,
            matfile=sprintf('analysisData/feedback_kp/Dkp15_Drl15/dist_vs_density_bigCluster_normTraj.mat');
            matfile2=sprintf('analysisData/feedback_kp/Dkp15_Drl15/dist_vs_density_bigCluster_min_ligand.mat');
            inputFile=sprintf('../data/feedback_kp/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
            species=3;
            E=64;
            avgProb=20/9028;
    elseif diff==1,
            matfile=sprintf('analysisData/Dkp15_Drl15/dist_vs_density_bigCluster_mono.mat');
            matfile2=sprintf('analysisData/Dkp15_Drl15/dist_vs_density_bigCluster_mono_Kp_min_ligand.mat');
            inputFile=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand_countR_400_t500.lm');
            species=3;
            E=64;
            avgProb=47.585/125000;
    elseif diff==4,
            matfile=sprintf('analysisData/Dkp15_Drl15/dist_vs_density_bigCluster_mono_ligand.mat');
            matfile2=sprintf('analysisData/Dkp15_Drl15/dist_vs_density_bigCluster_mono_min_ligand.mat');
            inputFile=sprintf('../data/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
            species=6;
            E=105.05;
            avgProb=86/125000;
    end
load(matfile);
[Na,centers]=hist(dist,20);
% [Nr,q]=hist(ratio,10);
binranges=zeros(1,size(centers,2)+1);
binranges(1,1)=min(dist);
for i=2:size(binranges,2)-1
    binranges(1,i)=centers(1,i-1)+centers(1,i-1)-binranges(1,i-1);
end
binranges(1,end)=max(dist);
meanRatioHist=zeros(size(binranges,2)-1,1);
maxD=zeros(size(binranges,2)-1,1);
for id=1:size(binranges,2)-1
%     id
    if (id==1),
        [idx3]=ind2sub(size(dist(1,:)),find(dist(1,:)<=binranges(id+1)));
        size(idx3,1);
        maxD(id)=max(density(1,idx3(1,:)));
        for a5=1:size(idx3,2)
        meanRatioHist(id)=meanRatioHist(id)+density(1,idx3(1,a5))./size(idx3,2);
        end
    else
       [idx3]=ind2sub(size(dist(1,:)),find(dist(1,:)>binranges(id) & dist(1,:)<=binranges(id+1)));
       size(idx3);
       if isempty(idx3)==1
           continue
       else
       maxD(id)=max(density(1,idx3(1,:)));
       for a5=1:size(idx3,2)
        meanRatioHist(id)=meanRatioHist(id)+density(1,idx3(1,a5))./size(idx3,2);
       end
       end
    end
end
% figure
% scatter(dist*50e-3,density);
% hold on;
% plot(centers*50e-3,meanRatioHist,'r--');

load(matfile2);
[Na,centers2]=hist(dist,centers);
% [Nr,q]=hist(ratio,10);
binranges=zeros(1,size(centers,2)+1);
binranges(1,1)=min(dist);
for i=2:size(binranges,2)-1
    binranges(1,i)=centers(1,i-1)+centers(1,i-1)-binranges(1,i-1);
end
binranges(1,end)=max(dist);
meanRatioHist2=zeros(size(binranges,2)-1,1);
maxD=zeros(size(binranges,2)-1,1);
for id=1:size(binranges,2)-1
%     id
    if (id==1),
        [idx3]=ind2sub(size(dist(1,:)),find(dist(1,:)<=binranges(id+1)));
        size(idx3,1);
        maxD(id)=max(density(1,idx3(1,:)));
        for a5=1:size(idx3,2)
        meanRatioHist2(id)=meanRatioHist2(id)+density(1,idx3(1,a5))./size(idx3,2);
        end
    else
       [idx3]=ind2sub(size(dist(1,:)),find(dist(1,:)>binranges(id) & dist(1,:)<=binranges(id+1)));
       size(idx3);
       if isempty(idx3)==1
           continue
       else
       maxD(id)=max(density(1,idx3(1,:)));
       for a5=1:size(idx3,2)
        meanRatioHist2(id)=meanRatioHist2(id)+density(1,idx3(1,a5))./size(idx3,2);
       end
       end
    end
end

% figure
% scatter(dist*50e-3,density);
% hold on;
% plot(centers*50e-3,meanRatioHist2,'r--');
% 

% figure
% scatter(dist*50e-3,density);
% plot(centers*50e-3,meanRatioHist,'ko');
% hold on;
% plot(centers*50e-3,meanRatioHist2,'LineWidth',1);
% plot(centers*50e-3,maxD,'LineWidth',1);
% figure
if diff==1 || diff ==4,
    plot(centers*50e-3,meanRatioHist./meanRatioHist2,'LineWidth',1);
else
    plot(centers*50e-3,meanRatioHist,'LineWidth',1);
end
% % figure
% hist(dist,20)
Int=trapz(centers,meanRatioHist./sum(meanRatioHist))
hold on;
end
xlabel('distance from point of highest density ({\mu}m)','FontWeight','b','FontSize',20); 
ylabel('average of mean density per on event','FontWeight','b','FontSize',20)
legend('Model I','Model II','Model III','Ligand')
% legend('Model I','Model II','Ligand')
% legend('Model II')
%figure
% scatter(dist,density);
% hold on;
% plot(centers,meanRatioHist);
% xlabel=['distance from centre of mass']; ylabel=['mean density per on event']


% matfile=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/gradient/Dirs_onEvents_c4_7_c5_5_c6_4.dat/00005.00005.00002.00003.mat');
% load(matfile)
% onEvents=size(find(celldata(:,1)>0),1)
% for i=1:onEvents
% switchTimes(i)=size(find(celldata(i,:)>0),2);
% end
% [idx]=find(switchTimes>4);
% for i=1:size(idx,2)
%     switchTimes2(i)=switchTimes(idx(1,i));
% end
% histfit(switchTimes2,20,'exp')











