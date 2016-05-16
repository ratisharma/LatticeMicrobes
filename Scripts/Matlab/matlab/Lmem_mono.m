clear all
rows=2;cols=2;plotIndex=1;
figure(1)
% i=1;
%     if (i==1),
% inputFilename=sprintf('../data/data_mono_gradSteep_Dkp15/cell_rdme_mono_c1b_0.5e-5_c2b_1.0e-5_c0__c4_5.0e-3_c5_8.0e-3_Dkp_5.0e-15.lm');
%     end
%     totKinases=64;
% x=[0:totKinases];
% numberReplicates=15;
% species=1;
% % for R=[1:numberReplicates]
% % if R == 1
% % % % R=4;
% % ts=cast(permute(hdf5read(inputFilename,...
% % sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
% % Pt1=zeros(size(x,2),size(ts,2));
% % end
% % counts=cast(permute(hdf5read(inputFilename,...
% % sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
% % for ti=[1:size(ts,2)]
% % Pt1(counts(ti,species)+1,ti)=Pt1(counts(ti,species)+1,ti)+1;
% % end
% % end
% % Pt1=Pt1./numberReplicates;
% % 
% % Pts=sum(Pt1,2);
% % plot(1-x./totKinases,Pts/sum(Pts));
% 
% R=1;
% ts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
% 
% counts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
% plot(ts,totKinases-counts(:,1));
% hold;

for i=2
    if (i==2),
        inputFilename=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand_countR_100.lm');
    else
        inputFilename=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
    end
            
totKinases=64;
x=[0:totKinases];
numberReplicates=15;
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
% figure(1)
% subplot(rows,cols,plotIndex)
Pts=sum(Pt1,2);
plot(1-x./totKinases,Pts/sum(Pts));

% % % axis([0 1 0 10])
% 
% title(['c1b=',num2str(c1b),', c2b=',num2str(c2b),', c4=',num2str(c4),', c5=',num2str(c5),', c6=',num2str(c6),', Dkp=',num2str(Dkp)])
%     xlabel('Fraction of Kinases \rightarrow')
%     ylabel('{\leftarrow} Probability')
    
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
% rows1=3;cols1=4;plotIndex1=1;
% for 
%     R=1;
% ts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
% 
% counts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
% % a(i,s,R)=counts(size(ts,2),1);
% % figure (3)
% % subplot(rows,cols,plotIndex);
% % plot(ts(1:1000),counts(1:1000,1))
% plot(ts,totKinases-counts(:,1));
% % 
% % % plotIndex=plotIndex+1;
% % % if plotIndex>rows*cols; plotIndex=1; end 
% % end
% 
    end
% % title(['c1b=',num2str(c1b),', c2b=',num2str(c2b),', c4=',num2str(c4),', c5=',num2str(c5),', c6=',num2str(c6),', Dkp=',num2str(Dkp)])
% %     xlabel('Fraction of phosphorylated kinases')
% %     ylabel('Probability')
%     
%     xlabel('time (s)')
%     ylabel('copy number of phosphorylated kinases')
