clear all;
% Ls=[0 400 800 1200 1600 2000];
% Drls=[0.0 5.0e-18 5.0e-17 5.0e-16 5.0e-15 5.0e-14 5.0e-13 5.0e-12];
% Drls=[0 16 15 14 13 12];
% Drls=[0 12 13 14 15 16 17 18]
%% param search Lmem_memThick2

c1b=3.0
c2b=7.0;
c4=8.0;
c5=8.0;
c6s=[4.0 5.0];
Dk=5e-12;
Dkps=[5.0 4.0 3.0 2.0 1.0 0.5] % e-12
X=64;
X1=0;

rows=3; cols=2; plotIndex=1;
for i=[1]
    for j=[6:-1:1]
        c6=c6s(i);
        Dkp=Dkps(j);
        if (j==6)
            inputFilename=sprintf('../data/data_gradSteep2_memThick2/cell_rdme_Lmem_gradSteep_c1b_%0.1fe-5_c2b_%0.1fe-5_c4_%0.1fe-3_c5_%0.1fe-3_c6_%0.1fe-5_Dk_5.0e-12_Dkp_5.0e-13_Dr_5.0e-12_Drl_5.0e-12.lm',c1b,c2b,c4,c5,c6);
        else
            inputFilename=sprintf('../data/data_gradSteep2_memThick2/cell_rdme_Lmem_gradSteep_c1b_%0.1fe-5_c2b_%0.1fe-5_c4_%0.1fe-3_c5_%0.1fe-3_c6_%0.1fe-5_Dk_5.0e-12_Dkp_%0.1fe-12_Dr_5.0e-12_Drl_5.0e-12.lm',c1b,c2b,c4,c5,c6,Dkp);
        end
    totKinases=64;
x=[0:totKinases];
numberReplicates=40;
species=1;
for R=[1:numberReplicates]
if R == 1
% % R=4;
ts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
Pt1=zeros(size(x,2),size(ts,2));
end
counts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
for ti=[1:size(ts,2)]
Pt1(counts(ti,species)+1,ti)=Pt1(counts(ti,species)+1,ti)+1;
end
end
Pt1=Pt1./numberReplicates;

Pts=sum(Pt1,2);
% hist(Pts)

% plot(ts,counts(:,1))

% E=zeros(1,size(ts,2));
% V=zeros(1,size(ts,2));
% for ti=[1:size(ts,2)]
% E(ti)=sum(x'.*Pt1(:,ti));
% V(ti)=sum((power(x'-E(ti),2)).*Pt1(:,ti));
% end
figure(1)
subplot(rows,cols,plotIndex)
Pts=sum(Pt1,2);
plot(1-x./totKinases,Pts./sum(Pts),'b');
% % % axis([0 1 0 10])
% 
title(['c1b=',num2str(c1b),', c2b=',num2str(c2b),', c4=',num2str(c4),', c5=',num2str(c5),', c6=',num2str(c6),', Dkp=',num2str(Dkp) 'e-12'])
    xlabel('Fraction of phosphorylated kinases','FontWeight','bold','FontSize',12)
    ylabel('Probability','FontWeight','bold','FontSize',12)
    
%     ti=1:size(ts,2);
%     x1=1:totKinases+1;
    Pt2=log(Pt1);
% 
%     figure(2)
% subplot(rows,cols,plotIndex);
%     contourf(Pt2(:,1:end))
% surf(Pt2)
%     
% rows=3; cols=3; plotIndex=1;


% for R=[1:100];
R=10;
ts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');

counts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
% a(i,s,R)=counts(size(ts,2),1);
figure (3)

subplot(rows,cols,plotIndex);
% plot(ts(1:1000),counts(1:1000,1))
plot(ts,totKinases-counts(:,1))
title(['c1b=',num2str(c1b),', c2b=',num2str(c2b),', c4=',num2str(c4),', c5=',num2str(c5),', c6=',num2str(c6),', Dkp=',num2str(Dkp) 'e-12'])
xlabel('time (s)','FontWeight','bold','FontSize',12)
ylabel('Copy number of kp+kpp','FontWeight','bold','FontSize',12)    
plotIndex=plotIndex+1;
Pt1=0;
Pts=0;
if plotIndex>rows*cols; plotIndex=1; end  
       
    end
end
% figure(1)
% contourf(a)
% ma=mean(a,2);
% figure(2)
% for R=[1:100]
% scatter(Ls,a(:,1,R),25,'MarkerEdgeColor',[0 0.5 0.5],'MarkerFaceColor',[0 0.7 0.7],'LineWidth',1.5)
% hold on;
% end
% 
% for R=[1:100]
% scatter(Ls,a(:,2,R),25,'MarkerEdgeColor',[0 0 1],'MarkerFaceColor',[0 0 1],'LineWidth',1.5)
% hold on;
% end