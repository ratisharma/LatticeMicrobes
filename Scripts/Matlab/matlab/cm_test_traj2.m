% % % Script to calculate the center of mass of the points generated from
% % % a single on event.

clear all
inputFilename2=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
% density=[];
% dist=[];
matfile1=sprintf('analysisData/Dkp14_Drl14_1.0/dist_vs_density_bigCluster.mat');
load(matfile1);


for file=181:201
    file
% % %     matfile=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/gradient/Dirs_traj_on_c4_7_c5_5_c6_4.dat/00005.00005.00002.00003.%05d.mat',file);
    matfile=sprintf('../pdf/pdf_Lmem_1.0Dkp14_Drl14/gradient/Dirs_traj_on.dat/00005.00005.00002.00003.%05d.mat',file);
load(matfile);
onEvents=0;
onEvents=find(sum(sum(sum(sum(celldata,5),4),3),2)>0);
data=zeros(onEvents(end),50,50,50,17);
particle=zeros(onEvents(end),50,50,50,17);
for i=1:17
    particle(:,:,:,:,i)=i-1;
end
% data=particle*celldata(1:onEvents(end),:,:,:,:);
for i=1:onEvents(end)
    for j=1:50
        for k=1:50
            for l=1:50
                data(i,j,k,l,:)=particle(i,j,k,l,:).*celldata(i,j,k,l,:);
            end
        end
    end
end
max=0;
event=[];
for i=1:onEvents(end)
total=sum(data(i,:,:,:,:),5);
tot=find(total>0);
if size(tot,1)>200
    event=[event i];
% end
mean1=sum(data(i,:,:,:,:),5)./sum(sum(sum(sum(data(i,:,:,:,:),5),4),3),2);
[p q r s]=ind2sub(size(mean1),find(mean1>0));
X=[q r s];
cutoffDistance=4;
[M2]=cluster_Chaining_onEvents(X,cutoffDistance);
cmx=0;
cmy=0;
cmz=0;
size(M2,1);
for i=1:size(M2,1)
    density1(i)=mean1(1,M2(i,1),M2(i,2),M2(i,3));
    cmx= cmx+ M2(i,1)*density1(i);
    cmy=cmy+M2(i,2)*density1(i);
    cmz=cmz+M2(i,3)*density1(i);
end
density;
cmx=cmx./sum(density1);
cmy=cmy./sum(density1);
cmz=cmz./sum(density1);
% figure
% scatter3(M2(:,1),M2(:,2),M2(:,3),200,'.')
% hold on;
% scatter3(cmx,cmy,cmz,600,'.','r')
% xlabel('x');ylabel('y');zlabel('z');

for i=1:size(M2,1)
    dist1(i)=sqrt((cmx-M2(i,1))^2+(cmy-M2(i,2))^2+(cmz-M2(i,3))^2);
    density1(i)=mean1(1,M2(i,1),M2(i,2),M2(i,3));
end
density1=density1./sum(density1);
density=[density density1];
dist=[dist dist1];
% figure
% scatter(dist,density);
clear mean1 density1 dist1 p q r s
% figure
% scatter(dist,density);
end
end
event
end

delete('analysisData/Dkp14_Drl14_1.0/dist_vs_density_bigCluster.mat');
outputFilename=sprintf('analysisData/Dkp14_Drl14_1.0/dist_vs_density_bigCluster.mat');
save(outputFilename,'dist','density');

figure
scatter(dist,density);

