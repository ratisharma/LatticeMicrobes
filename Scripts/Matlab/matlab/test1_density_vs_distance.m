clear all
figure
for diff=1:4
%     inputFile=sprintf('../data/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
    if diff==1,
matfile=sprintf('analysisData/Dkp15_Drl15/dist_vs_density_bigCluster_normTraj.mat');
matfile2=sprintf('analysisData/Dkp15_Drl15/dist_vs_density_bigCluster_min_ligand.mat');
inputFile=sprintf('../data/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
E=7.1750;
species=3
    elseif diff==2,
            matfile=sprintf('analysisData/Dkp14_Drl14_1.0/dist_vs_density_bigCluster_normTraj.mat');
            matfile2=sprintf('analysisData/Dkp14_Drl14_1.0/dist_vs_density_bigCluster_min_ligand.mat');
            E=19.9250;
    elseif diff==3,
                matfile=sprintf('analysisData/Dkp14_Drl14/dist_vs_density_bigCluster_normTraj.mat');
                matfile2=sprintf('analysisData/Dkp14_Drl14/dist_vs_density_bigCluster_min_ligand.mat');
                E=15.9650;
    elseif diff==4,
            matfile=sprintf('analysisData/Dkp15_Drl15/dist_vs_density_bigCluster_mono_ligand.mat');
            matfile2=sprintf('analysisData/Dkp15_Drl15/dist_vs_density_bigCluster_mono_min_ligand.mat');
            inputFile=sprintf('../data/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
            E=105.05;
    end
load(matfile)
[Na,centers]=hist(dist,20);
% [Nr,q]=hist(ratio,10);
binranges=zeros(1,size(centers,2)+1);
binranges(1,1)=min(dist);
for i=2:size(binranges,2)-1
    binranges(1,i)=centers(1,i-1)+centers(1,i-1)-binranges(1,i-1);
end
binranges(1,end)=max(dist);
meanRatioHist=zeros(size(binranges,2)-1,1);
for id=1:size(binranges,2)-1
%     id
    if (id==1),
        [idx3]=ind2sub(size(dist(1,:)),find(dist(1,:)<=binranges(id+1)));
        size(idx3,1);
        for a5=1:size(idx3,2)
        meanRatioHist(id)=meanRatioHist(id)+density(1,idx3(1,a5))./size(idx3,2);
        end
    else
       [idx3]=ind2sub(size(dist(1,:)),find(dist(1,:)>binranges(id) & dist(1,:)<=binranges(id+1)));
       size(idx3);
       if isempty(idx3)==1
           continue
       else
       for a5=1:size(idx3,2)
        meanRatioHist(id)=meanRatioHist(id)+density(1,idx3(1,a5))./size(idx3,2);
       end
       end
    end
end

load(matfile2)
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
% scatter(dist,density);
% 
% hold on;
if diff==1,
    plot(centers*50e-3,meanRatioHist,'Linewidth',1);
elseif diff ==2,
    plot(centers*50e-3,meanRatioHist./0.0024,'Linewidth',2);
elseif diff==3,
    plot(centers*50e-3,meanRatioHist./0.0028,'Linewidth',2);
else
    plot(centers*50e-3,meanRatioHist./meanRatioHist2,'Linewidth',2);
end
% plot(centers*50e-3,meanRatioHist.*105.05/(sum(meanRatioHist)*E*0.04768),'LineWidth',4);
% trapz(centers*50e-3,meanRatioHist./sum(meanRatioHist))
hold on;

end
xlabel('distance from centre of mass ({\mu}m)','FontWeight','b','FontSize',20); 
ylabel('average of mean density per on event','FontWeight','b','FontSize',20)
legend('D=5.0e-15','D=1.0e-14', 'D=5.0e-14','Ligand','FontWeight','b','FontSize',20)
% figure
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











