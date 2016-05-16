% % % Script to calculate the center of mass of the points generated from
% % % a single on event.

clear all
% inputFilename2=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
inputFile=sprintf('../data/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm')
LS=permute(hdf5read(inputFile,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
% ctr=25;
% [theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
density=[];
dist=[];
% matfile1=sprintf('analysisData/Dkp14_Drl14_1.0/dist_vs_density_bigCluster_normTraj.mat');
% load(matfile1);
M3=[x1 y1 z1];


for file=2:201
    file
%     matfile=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/gradient/Dirs_traj_on_c4_7_c5_5_c6_4.dat/00005.00005.00002.00003.%05d.mat',file);
    matfile=sprintf('../pdf/pdf_Lmem_1.0Dkp14_Drl14/gradient/Dirs_traj_on.dat/00004.00004.00003.00003.%05d.mat',file);
%     matfile=sprintf('../pdf/pdf_Lmem_Dkp14_Drl14/gradient/Dirs_traj_on.dat/00005.00005.00002.00003.%05d.mat',file);
%     matfile=sprintf('../pdf/feedback_kp/pdf_Lmem_Dkp15_Drl15/gradient/Dirs_traj_on_normTraj.dat/00005.00005.00002.00003.%05d.mat',file);
%     matfile=sprintf('../pdf/pdf_mono_Dkp15_Drl15/traj_countR_400.dat/00005.00005.00002.00002.%05d.mat',file);
%     matfile=sprintf('../pdf/pdf_mono_Dkp15_Drl15/traj_countR_400_ligand.dat/00005.00005.00002.00005.%05d.mat',file);
load(matfile);
onEvents=0;
onEvents=find(sum(celldata,2)>0)
data=zeros(onEvents(end),size(x1,1));
for i=1:onEvents(end)
    data(i,:)=celldata(i,:);
end

event=[];
for onEvent=1:onEvents(end)
total=data(onEvent,:);
tot=find(total>0);
if size(tot,2)>8
    event=[event onEvent];
mean1=data(onEvent,:);
[l]=ind2sub(size(mean1,2),find(mean1(1,:)>0));
X=zeros(size(l,2),3);
for i=1:size(l,2)
    X(i,1)=M3(l(1,i),1);
    X(i,2)=M3(l(1,i),2);
    X(i,3)=M3(l(1,i),3);
    X(i,4)=mean1(1,l(1,i));
end
X;
cutoffDistance=4;
[M2]=cluster_Chaining_onEvents(X(:,1:3),cutoffDistance);
ctr=25;
% [theta phi rho]=cart2sph(M2(:,1)-ctr,M2(:,2)-ctr,M2(:,3)-ctr);
cmx=0; cmy=0; cmz=0;
ctheta=0;
cphi=0;
crho=0;

density3=zeros(1,size(M3,1));
for i=1:size(M2,1)
%     density1(i)=mean1(1,M2(i,1),M2(i,2),M2(i,3));
    [idxDensity]=ind2sub(size(M3,1),find(M3(:,1)==M2(i,1) & M3(:,2)==M2(i,2) & M3(:,3)==M2(i,3)));
    density3(idxDensity)=mean1(1,idxDensity);
    [idxM2]=ind2sub(size(M2,1),find(M2(:,1)==M3(idxDensity,1) & M2(:,2)==M3(idxDensity,2) & M2(:,3)==M3(idxDensity,3)));
    density1(idxM2)=density3(idxDensity);
end

maxdID=ind2sub(size(density1),find(density1==max(density1)));
maxd=maxdID(1);
% [ctheta cphi crho]=cart2sph(M2(maxd,1)-ctr,M2(maxd,2)-ctr,M2(maxd,3)-ctr);
% crho=19.0;
% 
% [cmx cmy cmz]=sph2cart(ctheta,cphi,crho);
% cmx = cmx+ctr;
% cmy = cmy+ctr;
% cmz = cmz+ctr;

cmx=M2(maxd,1); cmy=M2(maxd,2); cmz=M2(maxd,3);
ax1=cmx-ctr; ay1=cmy-ctr; az1=cmz-ctr;
crho=19.0;
% figure
% subplot(1,2,1)
% scatter3(M2(:,1),M2(:,2),M2(:,3),900,density1,'.')
% hold on;
% scatter3(cmx,cmy,cmz,900,'.','r')
% subplot(1,2,2)
% scatter(theta,phi,900,'.')
% hold on;
% scatter(ctheta,cphi,900,'.')
% xlabel('x');ylabel('y');zlabel('z');
% title(['onEvent is ', num2str(onEvent)])

arcAngle=zeros(1,size(M3,1));
bx2=zeros(1,size(M3,1)); by2=zeros(1,size(M3,1)); bz2=zeros(1,size(M3,1));
abcr=zeros(1,size(M3,1));
abdot=zeros(1,size(M3,1));
dist1=zeros(1,size(M3,1));
for i=1:size(M3,1)
%     lat(i)=atan2(M2(i,3)-ctr,sqrt((M2(i,1)-ctr)^2+(M2(i,2)-ctr)^2));
%     lon(i)=atan2(M2(i,2)-ctr,M2(i,1)-ctr);
    bx2(i)=M3(i,1)-ctr; by2(i)=M3(i,2)-ctr; bz2(i)=M3(i,3)-ctr;
    abcr(i)=sqrt((ax1*by2(i)-bx2(i)*ay1)^2+(ay1*bz2(i)-az1*by2(i))^2+(az1*bx2(i)-ax1*bz2(i))^2);
    abdot(i)=ax1*bx2(i)+ay1*by2(i)+az1*bz2(i);
    arcAngle(i)=atan2(abcr(i),abdot(i));
    dist1(i)=arcAngle(i)*crho;
%     arclen(i) = distance('gc',latcm,loncm,lat(i),lon(i));
%     dist1(i)=arclen(i)*crho;
end
density3=density3;
% ./0.0025;
total=sum(density3);
density=[density density3];
dist=[dist dist1];
% figure
% scatter(dist1,density1);
% title(['onEvent is ', num2str(onEvent)])
clear mean1 density1 dist1 p q r s theta phi rho M2
% figure
% scatter(dist,density);
end
end
event
% delete('analysisData/Dkp15_Drl15/dist_vs_density_bigCluster_rep1.mat');
% outputFilename=sprintf('analysisData/Dkp15_Drl15/dist_vs_density_bigCluster_mono_rep%d.mat',file);
% delete(outputFilename);
% save(outputFilename,'dist','density');
end

delete('analysisData/Dkp14_Drl14_1.0/dist_vs_density_bigCluster_normTraj.mat');
outputFilename=sprintf('analysisData/Dkp14_Drl14_1.0/dist_vs_density_bigCluster_normTraj.mat');
save(outputFilename,'dist','density');

% figure
% scatter(dist,density);

