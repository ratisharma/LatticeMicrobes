clear all

filename=sprintf('../../feedback_kp/data_Dkp15_Drl15_memThick2/gradient/c7_4.0e-6/cell_rdme_Lmem_gradSteep_t500_10_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
replicate=50;
cutoffDistance=3;
begt=10;
endt=70;

times=cast(permute(hdf5read(filename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',replicate)),[2,1]),'double');

counts=cast(permute(hdf5read(filename,...
sprintf('/Simulations/%07d/SpeciesCounts',replicate)),[2,1]),'double');
ts1=0;

% LS=permute(hdf5read(filename,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
% [x1 y1 z1]=ind2sub(size(LS),find(LS==1));
% ctr=25;
% [theta1 phi1 rho1]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
% T=[theta1 phi1 rho1 x1 y1 z1];
% T2=sortrows(T)

for t1=2:size(times,2)
    if counts(times(1,t1),3)>10
        ts1=ts1+1;
        onts(ts1)=times(t1);
    end
end
% onts
% for ts2=1:size(onts,2)
% ts=onts(ts2)
for ts=99
[M]=cluster_Chaining2(filename,replicate,ts,cutoffDistance);
% [M,centerpts]=cluster_RLalg(filename,replicate,ts,cutoffDistance)
[idx]=ind2sub(size(M(:,4),1),find(M(:,4)>0));
if isempty(idx)==0
%     break;
% else
for i=1:size(idx,1)
    M2a(i)=M(idx(i),1);
    M2b(i)=M(idx(i),2);
    M2c(i)=M(idx(i),3);
    M2d(i)=M(idx(i),4);
end
% % M2d
% maxt(ts)=max(M2d);
ctr=25;
% % [theta phi rho]=cart2sph(M(:,1)-ctr,M(:,2)-ctr,M(:,3)-ctr);
% [theta phi rho]=cart2sph(M2a-ctr,M2b-ctr,M2c-ctr);
% th(1:size(theta,2),ts)=theta(1,:);
% ph(1:size(phi,2),ts)=phi(1,:);
% rh(1:size(rho,2),ts)=rho(1,:);
% clusterCounts(1:size(theta,2),ts)=M2d(1,:);
% clusterCounts(1:size(theta),ts)=theta(:,1);
% clearvars M;
% end
% figur

% plot(1:20,th(5,1:20))
% scatter(th,ts,'filled'),colorbar
% image(clusterCounts*20)
% for a=[1:size(clusterCounts,1)]
%     for b=1:size(clusterCounts,2)
%         theta1(a+(b-1)*size(clusterCounts,1))=th(a,b);
%         phi1(a+(b-1)*size(clusterCounts,1))=ph(a,b);
%         ts1(a+(b-1)*size(clusterCounts,1))=b;
%         counts(a+(b-1)*size(clusterCounts,1))=clusterCounts(a,b);
%     end
% end
% figure
% subplot(2,1,1)
% scatter(theta1,ts1,100,counts,'.'),colorbar
% xlabel('theta','FontWeight','bold','FontSize',12)
% ylabel('time','FontWeight','bold','FontSize',12)
% % axes([-3.5 3.5 20 70])
% subplot(2,1,2)
% % plot(1:size(clusterCounts,2),sum(clusterCounts,1))
% % figure
% % subplot(2,1,1)
% scatter(phi1,ts1,100,counts,'.'),colorbar
% xlabel('phi','FontWeight','bold','FontSize',12)
% ylabel('time','FontWeight','bold','FontSize',12)
% axes([-0.8 0.8 20 70])
% hist(maxt);
% subplot(2,1,2)
% plot(1:size(clusterCounts,2),sum(clusterCounts,1))
        
% figure
%  scatter(theta1,ts1,'filled')
% scatter(theta,M2c,400,M2d,'.'),colorbar
% scatter3(M2a,M2b,M2c,400,M2d,'.'),colorbar

%%%%%%%% Find the max cluster size for each time step: %%%%%%%

M2=[M2a' M2b' M2c' M2d'];
% [theta phi rho]=cart2sph(M2(:,1),M2(:,2),M2(:,3));
% figure
% scatter(theta,M2(:,3),400,M2(:,4),'.'),colorbar
% 
% figure
% scatter3(M2(:,1),M2(:,2),M2(:,3),400,M2(:,4),'.'),colorbar

totClusters=max(M2d');
for j=1:totClusters
    [clusterNum]=ind2sub(size(M2(:,4),1),find(M2(:,4)==j));
    countsSize(j)=size(clusterNum,1);
end
countsSize;
maxSize=max(countsSize);
[maxNum]=ind2sub(size(countsSize,1),find(countsSize==maxSize));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%% Find center of mass of the cluster with max size: %%%%%%%%%%%%%%%

big3d=ind2sub(size(M2(:,4)),find(M2(:,4)==maxNum(1)));
cma=0;
cmb=0;
cmc=0;
for l=1:size(big3d)
    M3a(l)=M2(big3d(l),1);
    M3b(l)=M2(big3d(l),2);
    M3c(l)=M2(big3d(l),3);
    M3d(l)=maxNum(1);
    cma=cma+M3a(l)./maxSize;
    cmb=cmb+M3b(l)./maxSize;
    cmc=cmc+M3c(l)./maxSize;
end
cma=round(cma);
cmb=round(cmb);
cmc=round(cmc);

LS=permute(hdf5read(filename,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
% [x1 y1 z1]=ind2sub(size(LS),find(LS==1));
if LS(cma,cmb,cmc)==1
    cm=[cma cmb cmc];
else
    fprintf('center of mass not on membrane for ts= %d\n',ts)
    dist2=zeros(1,size(M3a,2));
    for k=1:size(M3a,2)
        dist2(k)=sqrt((cma-M3a(1,k))^2+(cmb-M3b(1,k))^2+(cmc-M3d(1,k))^2);
    end
    minDist=min(dist2);
    idxMinD=ind2sub(size(dist2),find(dist2==minDist));
    cmprev=[cma cmb cmc];
    cm=[M3a(idxMinD(1)) M3b(idxMinD(1)) M3c(idxMinD(1))];
end
cm1(ts,:)=cm;
ctr=25;
[theta(ts) phi(ts) rho(ts)]=cart2sph(cm1(ts,1)-ctr,cm1(ts,2)-ctr,cm1(ts,3)-ctr);
% th(1:size(theta,2),ts)=theta(1,:);
% ph(1:size(phi,2),ts)=phi(1,:);
% rh(1:size(rho,2),ts)=rho(1,:);
% figure
% scatter3(M3a,M3b,M3c,400,'g.')
% hold;
% scatter3(cma,cmb,cmc,400,'r.')
% scatter3(cm(1,1),cm(1,2),cm(1,3),2000,'b.');
end
clearvars M j M2a M2b M2c M2d cma cmb cmc cm maxNum countsSize clusterNum totClusters
end
% figure
% subplot(2,1,1)
% scatter(1:ts,theta,400,'.')
% xlabel('time','FontWeight','b','FontSize',12);
% ylabel('theta','FontWeight','b','FontSize',12);
% subplot(2,1,2)
% scatter(1:ts,phi,400,'.')
% xlabel('time','FontWeight','b','FontSize',12);
% ylabel('phi','FontWeight','b','FontSize',12);
% 
% figure
% scatter(theta,cm1(:,3),400,1:ts,'.')


    





        
        
        
        
        
        