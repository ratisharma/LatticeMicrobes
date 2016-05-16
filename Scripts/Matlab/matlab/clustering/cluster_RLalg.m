% Clustering analysis for RDME LM simulations for single time step
% Adapted from Rodriguez and Laio 2014
% works with cluster_RLalg('T2.1.2-alphaGradient-copy.lm',1,56,2)
function [M,centerpts]=cluster_RLalg(filename,replicate,ts,cutoffDistance)

figure
M=[];
d=cutoffDistance;

inputFilename=sprintf(filename)
L=permute(permute(h5read(inputFilename,sprintf('/Simulations/%07d/Lattice/%010d',replicate,ts)),[4:-1:1]),[4:-1:1]);
for p=1:16
    for x=1:50
        for y=1:50
            for z=1:50
    if L(p,x,y,z)==1 || L(p,x,y,z)==2 || L(p,x,y,z)==3 
    M(end+1,:)=[x,y,z];
    end
            end
        end
    end
end

subplot(2,2,1)
scatter3(M(:,1),M(:,2),M(:,3),50,'.')
title([inputFilename, ' ts=',num2str(ts)]); xlabel('x'); ylabel('y'); zlabel('z');

%Pairwise distance between rows in M
  P=squareform(pdist(M));
  P1=squareform(pdist(M));
  P1(P1>d)=0;
  P2=P1<d;
  %subplot(2,2,2)
  %imagesc(P1)
  %title(['pairwise distance', ' ts=',num2str(ts),' Type ',num2str(stype),' DistanceAway ',num2str(d)])

  %Calculate local density for each point for decision plot
  localDensity=sum(exp(P1))./sum(P2,1);
  LD=localDensity;
  
  %Calculate min distance to point of higher density
  minDist=[];
  assignMinDist=[];
  twopt=[];
  for a=1:length(localDensity) 
      tmp=[];
     for b=1:length(localDensity)
        if localDensity(b)>localDensity(a) && localDensity(a)>0
            tmp(end+1,:)=[a b P(a,b)];
        elseif localDensity(b)==localDensity(a) && localDensity(a)>1 && a~=b && P(a,b)<3 && localDensity(a)>0
            twopt(end+1,:)=[M(a,:) a];
            twopt(end+1,:)=[M(b,:) a];
            localDensity(a)=0;
        end
     end
        if isempty(tmp)
            minDist(end+1)=[max(P(a,:))];
            assignMinDist(end+1,:)=[a a 1];
        else
            minDist(end+1)=[min(tmp(:,3))];
            [x,y]=min(tmp(:,3)); %indices for assigning clusters
            assignMinDist(end+1,:)=tmp(y,:); %for assigning clusters
        end

  end
  
  %Decision Plot
  %figure
  subplot(2,2,2)
  scatter(LD,minDist,50,'.')
  title('Decision Plot')
  xlabel('localDensity'); ylabel('minDistanceFromHigherDensity');
  
  %Assign clusters
  noclusterpts=[];clustPts=[];
  num=1;centerpts=[];cl=[];
  for c=1:length(localDensity)
      if localDensity(c)>1 && minDist(c)>=5
          centerpts(end+1,:)=[M(c,:) c];
      elseif localDensity(c)>1 && minDist(c)<5
          clustPts(end+1,:)=M(c,:);
          cl(end+1,:)=[M(c,:) assignMinDist(c,2) c];
      elseif localDensity(c)<=1 && localDensity(c) ~=0
          noclusterpts(end+1,:)=M(c,:);
      end
  end

clock
%Reassign cluster number based on cluster number of nearest neighbor of higher density
tmp=[];idx=[];index=[];
if size(cl,1)>=1
for p=1:size(cl,1)   
  tmp=cl(p,4);%look at 4th column of p row
  for r=1:size(centerpts,1)
    if tmp==centerpts(r,4)%returns true if tmp is a member of centerpts
        idx(end+1,:)=cl(p,:);
    end
  end
     while ~ismember(centerpts(:,4),tmp)%returns true if tmp is not a member of centerpts
       if ~isempty(twopt)
         if ~ismember(twopt(:,4),tmp)%correction for mislabeled twopt
         tmp=find(cl(:,5)==tmp);%move to that row's 5th column
         tmp=cl(tmp,4);%store 4th column value in tmp
         idx=cl(p,:);%store rows in idx
         idx(:,4)=tmp;%replace all 4th column values in tmp with center pt
         else
            idx=cl(p,:);
            break
         end
       else isempty(twopt)
         tmp=find(cl(:,5)==tmp);%move to that row's 5th column
         tmp=cl(tmp,4);%store 4th column value in tmp
         idx=cl(p,:);%store rows in idx
         idx(:,4)=tmp;%replace all 4th column values in tmp with center pt
       end
     end
     clock
    index=[index; idx];
    index=unique(index,'rows'); %only take unique values
    
end
end

clock
  %Concatenate all cluster point matrices
  allpts1=[];
  if length(clustPts)>=1
  allpts1=[allpts1; clustPts(:,1) clustPts(:,2)  clustPts(:,3) ones(size(clustPts,1),1)];
  end
  if length(centerpts)>=1
  allpts1=[allpts1; centerpts(:,1) centerpts(:,2) centerpts(:,3) 2*ones(length(centerpts(:,1)),1)];
  end
  if length(twopt)>=1
  allpts1=[allpts1; twopt(:,1) twopt(:,2) twopt(:,3) 3*ones(length(twopt(:,1)),1)];
  end
   
  allpts2=[];
  if length(index)>=1
      allpts2=[allpts2; index(:,1) index(:,2) index(:,3) index(:,4)];
  end
  allpts2=[allpts2; centerpts];
  allpts2=[allpts2; twopt];
  
  %Visualize clusters by center points and by cluster number
  %figure
  subplot(2,2,3)
%   scatter3(noclusterpts(:,1),noclusterpts(:,2),noclusterpts(:,3),50,'.','k')
%   hold on
  scatter3(clustPts(:,1),clustPts(:,2),clustPts(:,3),50,'.','b') 
  hold on;
  scatter3(centerpts(:,1),centerpts(:,2),centerpts(:,3),50,'.','r')
  scatter3(twopt(:,1),twopt(:,2),twopt(:,3),50,'.','g')
  %scatter3(allpts1(:,1),allpts1(:,2),allpts1(:,3),50,allpts1(:,4),'.')
  hold off
  title('Centers and Cluster points'); xlabel('x'); ylabel('y'); zlabel('z');
  
  subplot(2,2,4)
  %figure
%   scatter3(noclusterpts(:,1),noclusterpts(:,2),noclusterpts(:,3),50,'.','k')
%   hold on
%   scatter3(centerpts(:,1),centerpts(:,2),centerpts(:,3),50,centerpts(:,4),'.') 
%   scatter(index(:,1),index(:,2),50,index(:,3),'.')
%   scatter3(twopt(:,1),twopt(:,2),twopt(:,3),50,twopt(:,4),'.')
  scatter3(allpts2(:,1),allpts2(:,2),allpts2(:,3),50,allpts2(:,4),'.')
%   hold off
  title('Clusters'); xlabel('x'); ylabel('y'); zlabel('z');
  
end