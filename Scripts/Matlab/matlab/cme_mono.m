clear all;
% Ls=[0 400 800 1200 1600 2000];
Ls=[0 25 50 75 100 125 150 175 200 225 250 300];
X=64;
X1=0;
E1=zeros(size(Ls,1),1001);
E2=zeros(size(Ls,1),1001);
V=zeros(size(Ls,1),1001);
rows=3; cols=2; plotIndex=1;
i=1;
L=Ls(i);
inputFilename=sprintf('../data/data_mono/pdf_off_on_%d_%d_%d.lm',L,X,X1);
totKinases=64;
x=[0:totKinases];
numberReplicates=100;
species=1;
% for R=[1:numberReplicates]
% if R == 1
% % % R=4;
% ts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
% Pt1=zeros(size(x,2),size(ts,2));
% end
% counts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
% for ti=[1:size(ts,2)]
% Pt1(counts(ti,species)+1,ti)=Pt1(counts(ti,species)+1,ti)+1;
% end
% end
% Pt1=Pt1./numberReplicates;
% figure(1)
% Pts=sum(Pt1,2);
% plot(1-x./totKinases,Pts/sum(Pts),'b');
% title(['fraction of phosphorylated kinases vs probability'])
% xlabel('fraction of phosphorylated kinases','FontWeight','bold','FontSize',12);
% ylabel('probability','FontWeight','bold','FontSize',12)
% % legend('L=0');
% hold;

R=5;
ts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');

counts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
plot(ts,totKinases-counts(:,1));
title(['trajectory'])
ylabel('fraction of phosphorylated kinases','FontWeight','bold','FontSize',12);
xlabel('time','FontWeight','bold','FontSize',12)
hold;
for i=[3:2:12]
    for s=[1]
L=Ls(i);
if (s==1)
inputFilename=sprintf('../data/data_mono/pdf_off_on_%d_%d_%d.lm',L,X,X1);
end
% if (s==2)
%    inputFilename=sprintf('../data/data_mono/pdf_on_off_%d_%d_%d.lm',L,X1,X);
% end


totKinases=64;
x=[0:totKinases];
numberReplicates=100;
species=1;
% for R=[1:numberReplicates]
% if R == 1
% % % R=4;
% ts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
% Pt1=zeros(size(x,2),size(ts,2));
% end
% counts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
% for ti=[1:size(ts,2)]
% Pt1(counts(ti,species)+1,ti)=Pt1(counts(ti,species)+1,ti)+1;
% end
% end
% Pt1=Pt1./numberReplicates;
% 
% % figure(1)
% Pts=sum(Pt1,2);
% % subplot(rows,cols,plotIndex);
% plot(1-x./totKinases,Pts/sum(Pts));
% legend('L= ',num2str(Ls(i)));
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
% R=5;
% ts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
% 
% counts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
% a(i,s,R)=counts(size(ts,2),1);
% 
% % plot(ts(1:10:1e3),counts(1:10:1e3,1))
% figure(3)
% subplot(rows,cols,plotIndex);
% plot(ts,counts(:,1))
% plotIndex=plotIndex+1;
% if plotIndex>rows*cols; plotIndex=1; end  
% end
R=5;
ts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');

counts=cast(permute(hdf5read(inputFilename,...
sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
plot(ts,totKinases-counts(:,1));
    end
end
legend('RL=0','RL=50','RL=100','RL=150','RL=200','RL=250','FontWeight','bold','FontSize',12);
