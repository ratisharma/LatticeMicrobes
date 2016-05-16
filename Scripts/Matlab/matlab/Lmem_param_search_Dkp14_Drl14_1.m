clear all;
% Ls=[0 400 800 1200 1600 2000];
% Drls=[0.0 5.0e-18 5.0e-17 5.0e-16 5.0e-15 5.0e-14 5.0e-13 5.0e-12];
% Drls=[0 16 15 14 13 12];
% Drls=[0 12 13 14 15 16 17 18]
%% param search Lmem_memThick2

c1bs=[0.5 0.6 0.7 0.8 0.9 1.0];
c2bs=[1.0 1.2 1.4 1.6 1.8 2.0];
c3bs=[1.0 1.25 1.5 2.0];
c0as=[1.0 2.0 3.0 4.0];
c4s=[7.0 7.1 7.2 7.3 7.4 7.5];
c5s=[5.0 6.0 7.0 8.0];
c6s=[4.0 4.1 4.2 4.3 4.4 4.5];
Dk=5e-12;
Dkp=5e-12
X=64;
X1=0;

rows=1; cols=1; plotIndex=1;
for i=[2]
    for j=[2]
        for k=[2]
            for l=[4]
                for m=[2]
                    for n=[2]
                        for p=[4]
                    c1b=c1bs(i);
                    c2b=c2bs(j);
                    c3b=c3bs(k);
                    c0a=c0as(l);
                    c4=c4s(m)
                    c5=c5s(n);
                    c6=c6s(p);

                  inputFilename=sprintf('../data_1.0Dkp14_Drl14_memThick2/param/cell_rdme_Lmem_gradSteep_t500_1_c1b_%0.1fe-5_c2b_%0.1fe-5_c3b_%0.1fe-3_c0a_%0.1fe-3_c4_%0.1fe-3_c5_%0.1fe-3_c6_%0.1fe-5_Dk_5.0e-12_Dkp_1.0e-14_Dr_5.0e-12_Drl_1.0e-14.lm',c1b,c2b,c3b,c0a,c4,c5,c6);

                  %       �inputFilename=sprintf('../data/data_Dkp15_memThick2/cell_rdme_Dkp_5.0e-15_c1b_%0.1fe-5_c2b_%0.1fe-5_c3b_%0.1fe-3.lm',c1b,c2b,c3b);
    totKinases=64;
x=[0:totKinases];
numberReplicates=23;
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
plot(1-x./totKinases,Pts,'b');
% % % axis([0 1 0 10])
% 
title(['c1b=',num2str(c1b),', c2b=',num2str(c2b),', c3b=',num2str(c3b),', c4=',num2str(c4),', c5=',num2str(c5),', c6=',num2str(c6)])
% title(['c1b=',num2str(c1b),', c2b=',num2str(c2b),', c3b=',num2str(c3b)])
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
rows1=5;cols1=4;plotIndex1=1;
for R=1:20;
ts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');

counts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
% a(i,s,R)=counts(size(ts,2),1);
figure (1+plotIndex)
subplot(rows1,cols1,plotIndex1);
% plot(ts(1:1000),counts(1:1000,1))
species=1;
plot(ts,counts(:,species))
title(['c1b=',num2str(c1b),', c2b=',num2str(c2b),', c3b=',num2str(c3b),', c4=',num2str(c4),', c5=',num2str(c5),', c6=',num2str(c6)])
xlabel({'time'})
ylabel({'counts in off state'})
plotIndex1=plotIndex1+1;
if plotIndex1>rows1*cols1; plotIndex1=1; end 
end
plotIndex=plotIndex+1;
Pt1=0;
Pts=0;
if plotIndex>rows*cols; plotIndex=1; end  
                end
            end
        end
    end
        end
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