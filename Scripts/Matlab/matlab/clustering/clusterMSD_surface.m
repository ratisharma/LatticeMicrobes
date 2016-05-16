%%%%%%%%%%%% Claculate mean square displacement (MSD) of a cluster: %%%%%%%

function [msd,cm2]=clusterMSD_surface(filename,replicate,cutoffDistance)


times=cast(permute(hdf5read(filename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',replicate)),[2,1]),'double');

counts=cast(permute(hdf5read(filename,...
sprintf('/Simulations/%07d/SpeciesCounts',replicate)),[2,1]),'double');
ts1=1;
ts3=1;
n=1;
t1=2;
onevent1(n,ts3)=0;
%%%%%%% Determining the number of on events and selecting the biggest one: 
for t1=2:size(times,2)
%     if t1+1<size(times,2) & counts(times(1,t1),3)>9 & (counts(times(1,t1+1),3)>9 || counts(times(1,t1+2),3)>9)
%     t1
%     c=counts(times(1,t1),3)
    if counts(times(1,t1),3)>2 
%         onts(ts1)=times(t1);
        onevent1(n,ts3)=times(t1);
        ts3=ts3+1;
%     elseif t1>2 & t1<size(times,2) & counts(times(1,t1),3)<10 & counts(times(1,t1),3)>4 & counts(times(1,t1-1),3)>9 & counts(times(1,t1+1),3)>9
%             onevent1(n,ts3)=times(t1);
%             ts3=ts3+1;
% % %     elseif t1>2 & t1+1<size(times,2) & counts(times(1,t1),3)<5 & counts(times(1,t1-1),3)>9 & counts(times(1,t1+1),3)>9
% % %             if ts3>1
% % %                 n=n+1;
% % %             end
% % %             ts3=1;
% % %     elseif t1+1<size(times,2) & counts(times(1,t1),3)<10 & counts(times(1,t1+1),3)<10 & counts(times(1,t1+2),3)<10 
% % %         if ts3>1
% % %             n=n+1;
% % %         end
% % %             ts3=1;
% % %     elseif t1+1<size(times,2) & counts(times(1,t1),3)<10 & counts(times(1,t1+1),3)<10 & counts(times(1,t1-1),3)>10 
% % %         if ts3>1
% % %             n=n+1;
% % %         end
% % %             ts3=1;
% % % % %     elseif t1+1<size(times,2) & counts(times(1,t1),3)<10 & counts(times(1,t1-2),3)>10 & counts(times(1,t1-1),3)<10 
% % % % %         if ts3>1
% % % % %             n=n+1;
% % % % %         end
% % % % %             ts3=1;
    else 
        if ts3>1
            n=n+1;
        end
            ts3=1;
    end
%         ts1=ts1+1;
end
% onts;
onevent1;
if onevent1(1,1)==0
    msd=0;
    cm2=0;
    return
end
for i1=1:size(onevent1,1)
    for i2=1:size(onevent1,2)
        if onevent1(i1,i2)==0
            onzeros(i1)=i2;
            break;
        end
        if i2==size(onevent1,2)
            onzeros(i1)=i2+1;
        end
    end
end
onzeros; %%The index of the maximum is the largest cluster number
bigevent=ind2sub(size(onzeros),find(onzeros==max(onzeros))); %%gives the index
% bigevent=2;

% onevent1(bigevent(1),:)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

LS=permute(hdf5read(filename,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta1 phi1 rho1]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
T=[theta1 phi1 rho1 x1 y1 z1];
T2=sortrows(T);
uTheta=unique(T2(:,1));
size(uTheta)

for p1=1:size(uTheta)
    [ith]=ind2sub(size(T2(:,1)),find(T2(:,1)==uTheta(p1)));
    thIndex(ith(:,1))=p1;
    Ti(ith(:,1))= ith;
end
thIndex';
Ti';
T3=[Ti' thIndex' T2(:,4) T2(:,5) T2(:,6)];
% onevent1(bigevent(1),:);
histTheta=[];
histz=[];
histDensity=[];
% Nthetaz=zeros(50,size(uTheta,1));
for ts2=1:size(onevent1(bigevent(1),:),2)
    ts=onevent1(bigevent(1),ts2)-1;
    if ts==-1
        break;
    end
% for ts=486;
ts;
[Mtz2]=cluster_Chaining3(filename,replicate,ts,cutoffDistance,T3);
M=[Mtz2(:,3) Mtz2(:,4) Mtz2(:,5) Mtz2(:,6)];
[idx]=ind2sub(size(M(:,4),1),find(M(:,4)>0));
if isempty(idx)==0
for i=1:size(idx,1)
    M2a(i)=M(idx(i),1);
    M2b(i)=M(idx(i),2);
    M2c(i)=M(idx(i),3);
    M2d(i)=M(idx(i),4);
end
% figure
% subplot(2,1,1)
% scatter(Mtz2(:,1),Mtz2(:,5),400,Mtz2(:,6),'.'),colorbar
% subplot(2,1,2)
% scatter3(Mtz2(:,3),Mtz2(:,4),Mtz2(:,5),400,Mtz2(:,6),'.')
% maxt(ts)=max(Mtz2(:,6));
% size(uTheta)
histTheta=[histTheta uTheta(Mtz2(:,2))'];
histz=[histz Mtz2(:,5)'];
histDensity=[histDensity Mtz2(:,6)'];

% for n1=1:size(Mtz2,1)
%     Nthetaz(Mtz2(n1,5),thIndex(Mtz2(n1,2))) = Nthetaz(Mtz2(n1,5),thIndex(Mtz2(n1,2))) + 1;
% end
% figure
% subplot(1,2,ts2-9)
% scatter(uTheta(Mtz2(:,2)),Mtz2(:,5).*0.05,400,'b','.')
% ,colorbar
% title(['replicate = ', num2str(replicate), ', traj length = ', num2str(size(onevent1(bigevent(1),:),2))])
% xlabel('{\theta}'); ylabel('z ({\mu m})')
% axis([-3.2 3.2 0 2.5]);
% ax=gca;
% ax.XTick=[-pi -pi/2 0 pi/2 pi];
% hold on;

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
ctheta=0; cphi=0; crho=0;
for l=1:size(big3d)
    M3a(l)=M2(big3d(l),1);
    M3b(l)=M2(big3d(l),2);
    M3c(l)=M2(big3d(l),3);
    M3d(l)=maxNum(1);
%     cma=cma+M3a(l)./maxSize;
%     cmb=cmb+M3b(l)./maxSize;
%     cmc=cmc+M3c(l)./maxSize;
end
[theta1 phi1 rho1]=cart2sph(M3a,M3b,M3c);
for l=1:size(big3d)
    ctheta=ctheta+theta1(l)./maxSize;
    cphi=cphi+phi1(l)./maxSize;
    crho=crho+rho1(l)./maxSize;
end
[cma cmb cmc]=sph2cart(ctheta,cphi,crho);
cma=round(cma);
cmb=round(cmb);
cmc=round(cmc);




LS=permute(hdf5read(filename,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
% [x1 y1 z1]=ind2sub(size(LS),find(LS==1));
if LS(cma,cmb,cmc)==1
    cm=[cma cmb cmc];
else
%     fprintf('center of mass not on membrane for ts= %d\n',ts)
    dist2=zeros(1,size(M3a,2));
    for k=1:size(M3a,2)
        dist2(k)=sqrt((cma-M3a(1,k))^2+(cmb-M3b(1,k))^2+(cmc-M3d(1,k))^2);
    end
    minDist=min(dist2);
    idxMinD=ind2sub(size(dist2),find(dist2==minDist));
    cmprev=[cma cmb cmc];
    cm=[M3a(idxMinD(1)) M3b(idxMinD(1)) M3c(idxMinD(1))];
end
% figure
% subplot(1,2,1)
% scatter(theta1,phi1,400,'.');
% hold on;
% scatter(ctheta,cphi,400,'.');
% subplot(1,2,2)
% scatter3(M3a,M3b,M3c,400,'.');
% hold on;
% scatter3(cm(1,1),cm(1,2),cm(1,3),400,'.');
ts;
cm1(ts,:)=cm;
% size(cm1);
% ctr=25;
% [theta(ts) phi(ts) rho(ts)]=cart2sph(cm1(ts,1)-ctr,cm1(ts,2)-ctr,cm1(ts,3)-ctr);
% else
%     ts
%     fprintf('empty')
end
tsend=ts;
clearvars M Mtz2 p1 p2 p3 p4 j k ts2 ts M2a M2b M2c M2d cma cmb cmc cm maxNum countsSize clusterNum totClusters
end
Nthetaz=zeros(12,12);
[Nthetaz(2:11,2:11),hTheta,hz]=hist2d(histTheta,histz*0.05,10,10);
% image(Nthetaz)
Nthetaz;
hTheta=[-3.1416 hTheta 3.1416]
hz=[0 hz 2.5]   
% contourf(hTheta,hz,Nthetaz./size(onevent1(bigevent(1),:),2))
% sum(sum(Nthetaz,2))
scatter(histTheta,histz.*0.05,400,histDensity,'.')
title(['replicate = ', num2str(replicate), ', traj length = ', num2str(size(onevent1(bigevent(1),:),2))])
xlabel('{\theta}'); ylabel('z ({\mu m})')
caxis manual
% caxis([0.0 0.12]);
colorbar
axis([-3.1416 3.1416 0 2.5]);
ax=gca;
ax.XTick=[-pi -pi/2 0 pi/2 pi];
ax.YTick=[0 0.5 1.0 1.5 2.0 2.5]
totPoints=size(histDensity)
% figure
% subplot(2,1,1)
% scatter(1:tsend,theta,400,'.')
% xlabel('time','FontWeight','b','FontSize',12);
% ylabel('theta','FontWeight','b','FontSize',12);
% subplot(2,1,2)
% scatter(1:tsend,phi,400,'.')
% xlabel('time','FontWeight','b','FontSize',12);
% ylabel('phi','FontWeight','b','FontSize',12);
% 
% figure
% scatter(theta,cm1(:,3),400,1:tsend,'.')
% hold;
clearvars onts
% end
% size(cm1);
onevent1(bigevent(1),:);
t4=ind2sub(size(onevent1(bigevent(1),:)),find(onevent1(bigevent(1),:)>0));
bigtimes=onevent1(bigevent(1),t4(1))-1:onevent1(bigevent(1),t4(end))-1;
size(bigtimes);
cm1(bigtimes(1):end,:);
size(cm1(bigtimes(1):end,:));
% bigtimes(end);
% cm2=cm1(bigtimes(1):bigtimes(end),:);
cm2=cm1(bigtimes(1):end,:);
% size(cm2)
% outputFilename=sprintf('analysisData/feedback_cm2_gradient.mat');
% save(outputFilename,'cm2');
msd=zeros(size(cm2,1)-1,1);
ax1=zeros(size(cm2,1)-1,1); ay1=zeros(size(cm2,1)-1,1); 
az1=zeros(size(cm2,1)-1,1);
bx2=zeros(size(cm2,1)-1,1); by2=zeros(size(cm2,1)-1,1); 
bz2=zeros(size(cm2,1)-1,1);
abcr=zeros(size(cm2,1)-1,1); abdot=zeros(size(cm2,1)-1,1); arcAngle=zeros(size(cm2,1)-1,1);
dist1=zeros(size(cm2,1)-1,1);
size(az1);
ctr=25;
crho=19;
for i4=1:size(cm2,1)-1
    for i5=1:size(cm2,1)-i4
        ax1(i5+i4)=cm2(i5+i4,1)-ctr; 
        ay1(i5+i4)=cm2(i5+i4,2)-ctr; 
        az1(i5+i4)=cm2(i5+i4,3)-ctr;
        bx2(i5)=cm2(i5,1)-ctr;
        by2(i5)=cm2(i5,2)-ctr;
        bz2(i5)=cm2(i5,3)-ctr;
        abcr(i4)=sqrt((ax1(i5+i4)*by2(i5)-bx2(i5)*ay1(i5+i4))^2+(ay1(i5+i4)*bz2(i5)-by2(i5)*az1(i5+i4))^2+(az1(i5+i4)*bx2(i5)-bz2(i5)*ax1(i5+i4))^2);
        abdot(i4)=ax1(i5+i4)*bx2(i5)+ay1(i5+i4)*by2(i5)+az1(i5+i4)*bz2(i5);
        arcAngle(i4)=atan2(abcr(i4),abdot(i4));
        dist1(i4)=arcAngle(i4)*crho;
        msd(i4)=msd(i4)+(dist1(i4)^2)./(size(bigtimes,2)-i4);
    end
end
% for i4=1:size(cm2,1)-1
%     for i5=1:size(cm2,1)-i4
%         msd(i4)=msd(i4)+((cm2(i5+i4,1)-cm2(i5,1))^2+(cm2(i5+i4,2)-cm2(i5,2))^2+(cm2(i5+i4,3)-cm2(i5,3))^2)./(size(bigtimes,2)-i4);
%     end
% end
msd;
% % figure
% scatter(1:size(bigtimes,2)-1,msd,400,'.')
% xlabel('time');
% ylabel('msd');
% hold on;
% end
% end



