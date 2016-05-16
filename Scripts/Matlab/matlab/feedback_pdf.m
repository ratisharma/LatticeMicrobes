clear all;
% Ls=[0 400 800 1200 1600 2000];
c7s=[7 6 5];
totKinases=64;
rows=3; cols=1; plotIndex=1;
for i=[1:3]
    c7=c7s(i);

inputFilename=sprintf('../data/feedback_kp/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-%d_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',c7);
x=[0:totKinases];
numberReplicates=200;
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

% plot(ts,counts(:,1))

% E=zeros(1,size(ts,2));
% V=zeros(1,size(ts,2));
% for ti=[1:size(ts,2)]
% E(ti)=sum(x'.*Pt1(:,ti));
% V(ti)=sum((power(x'-E(ti),2)).*Pt1(:,ti));
% end
figure(1)
Pts=sum(Pt1,2);
subplot(rows,cols,plotIndex);
plot(1-x./totKinases,Pts/sum(Pts),'b');
title(['feedback_kp, c7=4.0e-',num2str(c7)]);
xlabel('fraction of phosphorylated kinase','FontWeight','bold','FontSize',12);
ylabel('probability','FontWeight','bold','FontSize',12);
% % % axis([0 1 0 10])
% 
% %     title({['2-D Diffusion with {\nu} = ',num2str(vis)];['time (\itt) = ',num2str(it*dt)]})
%     xlabel('Fraction of Kinases \rightarrow')
%     ylabel('{\leftarrow} Probability')
    
%     ti=1:size(ts,2);
%     x1=1:totKinases+1;
%     Pt2=log(Pt1);
% 
%     figure(2)
% %     contourf(Pt2(:,1:end))
% surf(Pt2)
%     
% rows=3; cols=3; plotIndex=1;


% for R=[1:100];
R=50;
ts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');

counts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');

% plot(ts(1:10:1e3),counts(1:10:1e3,1))
figure(3)
subplot(rows,cols,plotIndex);
plot(ts,counts(:,1))
hold;
plot(ts,counts(:,2))
plot(ts,counts(:,3))
title(['feedback_kp, c7=4.0e-',num2str(c7)]);
xlabel('time(s)','FontWeight','bold','FontSize',12);
ylabel('phosphorylated kinase','FontWeight','bold','FontSize',12);
plotIndex=plotIndex+1;
if plotIndex>rows*cols; plotIndex=1; end  
% end
  
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



