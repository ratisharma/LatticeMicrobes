clear all;
% inputFilename='alpha_time_1.lm'; %% D=320, volume=100x100x100
% inputFilename='alpha_time_10_D_50.lm';
inputFilename='../data/data_ligand/alpha_time_10_D50_rateProd865_distSrc0.5.lm';
numParticles=8;
totParticles=170;
x=[0:totParticles];
numberReplicates=10;
species=1;
nlattice1=50;
nlattice2=50;
nlattice3=50;

% % Computing concentration across diagonal by dividing whole volume into 5



% for R=[1:numberReplicates]
% if R == 1
% i=1:nlattice1;
% j=1;
% k=1;
% l=1:numParticles;
% ts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
% t=size(ts,2);
% Bconc = zeros(numberReplicates,nlattice1,nlattice2,nlattice2,numParticles);
% Pt1=zeros(nlattice1,size(ts,2));
% end  
% counts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/Lattice/0000000500',R)),[4,3,2,1]),'double');
% Bconc(R,i,j,k,l)=counts(i,j,k,l);
% end
% Bconc;
% i=1:nlattice1;
% j=1:nlattice2;
% k=1:nlattice2;
% u(i,j,k,l)=sum(Bconc,1);
% u1(i,j,k)=sum(u,4)./numberReplicates;




% ni=10
for R=[1:numberReplicates]
% for R=[1001:2000]
    R
if R == 1
    ni=10
   i=1:nlattice1;
j=1:nlattice2;
k=1:nlattice3;

l=1:numParticles;
ts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
t=size(ts,2);
% Bconc = zeros(numberReplicates,t,nlattice1,nlattice2,nlattice3,numParticles);
% Pt1=zeros(nlattice1,size(x,2),size(ts,2));
Pt1=zeros(nlattice1,size(x,2),size(ts,2));
cts=zeros(ni,size(x,2),t);
end
    

% i=1:nlattice1;
% j=1:nlattice2;
% k=1:nlattice3;
% 
% l=1:numParticles;
% ts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
% t=size(ts,2);
% load('Pt1_alpha_D50.mat');
% cts=zeros(ni,size(x,2),t);
for ti=[1:t]
   
counts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/Lattice/000000%04d',R,ti-1)),[4,3,2,1]),'double');
% counts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
% Bconc(R,ti,i,j,k,l)=counts(i,j,k,l);
countsxyz(ti,i,j,k)=sum(counts(i,j,k,l),4);
countstot(ti)=sum(sum(sum(sum(counts(i,j,k,l),4),3),2));
for i1=1:5
%     i2=ni*(i1-1)+1:ni*i1
%     for j1=1:10
%         for k1=1:10
%     countsR(ti,i1)=countsxyz(ti,i1,i1,i1);
    countsRed(ti,i1)=sum(sum(sum(countsxyz(ti,ni*(i1-1)+1:ni*i1,ni*(i1-1)+1:ni*i1,ni*(i1-1)+1:ni*i1),4),3),2);
% for a=[1:nlattice1]
% %     for b=[1:nlattice2]
% %         for c=[1:nlattice3]
%             Pt1(a,countsxyz(ti,a,a,a)+1,ti)=Pt1(a,countsxyz(ti,a,a,a)+1,ti)+1;
% %         end
% %     end
% end
    Pt1(i1,countsRed(ti,i1)+1,ti)=Pt1(i1,countsRed(ti,i1)+1,ti)+1;
%     Pt1(i1,countsR(ti,i1)+1,ti)=Pt1(i1,countsR(ti,i1)+1,ti)+1;
%         end
%     end
end
end
end

Pt1=Pt1./numberReplicates;
ni2=5
i=1:ni2;
j=1:nlattice2;
k=1:nlattice3;
E=zeros(ni2,size(ts,2));
V=zeros(ni2,size(ts,2));
for x=[1:totParticles+1]
    cts(:,x,:)=x-1;
end
n=1:totParticles+1;
for ti=[1:size(ts,2)]
E(i,ti)=sum(cts(i,:,ti).*Pt1(i,:,ti),2);
V(i,ti)=sum(cts(i,:,ti).*cts(i,:,ti).*Pt1(i,:,ti),2)-sum(cts(i,:,ti).*Pt1(i,:,ti),2).*sum(cts(i,:,ti).*Pt1(i,:,ti),2);
StdDev(i,ti)=V(i,ti).^0.5;
end
% meanE=mean(E(:,2:end),2)
% meanVar=mean(V(:,2:end),2)

subplot(2,1,1);
plot(ts(1:end), E(1,1:end));
hold on;
for i=[2:ni2]
plot(ts(1:end), E(i,1:end),'m');
% plot(ts(2:end),StdDev(i,2:end),'-m');
end
%plot(ts(1:10:end-1), E(3,1:10:end-1),'g');
xlabel('Time (s)'); ylabel('E\{A(t)\}');
subplot(2,1,2);
plot(ts(2:end), V(1,2:end));
hold on;
for i=[2:ni2]
plot(ts(2:end), V(i,2:end),'k');
% plot(ts(2:end),StdDev(i,2:end),'-k')
end;
%plot(ts(1:10:end-1), V(3,1:10:end-1),'g');
xlabel('Time (s)'); ylabel('V\{A(t)\}');