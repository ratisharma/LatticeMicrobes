% Clustering analysis for RDME LM simulations for single time step
% works with cluster_Chaining('T2.1.2-alphaGradient.lm',1,56,2)

function [Mtz2]= cluster_Chaining3(filename,replicate,ts,cutoffDistance,T3)
ts;
M=[];
d=cutoffDistance;

% figure
inputFilename=filename;
% L=permute(permute(h5read(inputFilename,sprintf('/Simulations/%07d/Lattice/%010d',replicate,ts)),[4:-1:1]),[4:-1:1]);
L=permute(hdf5read(inputFilename,sprintf('/Simulations/%07d/Lattice/%010d',replicate,ts)),[4:-1:1]);
for x=1:50
    for y=1:50
        for z=1:50
            for p=1:16
%     if L(p,x,y,z)==1 || L(p,x,y,z)==2 || L(p,x,y,z)==3 
    if L(x,y,z,p)==3
    M(end+1,:)=[x,y,z];
    end
            end
        end
    end
end
M;
for p4=1:size(M(:,1))
    [isame]=ind2sub(size(T3(:,2)),find(T3(:,3)==M(p4,1) & T3(:,4)==M(p4,2) & T3(:,5)==M(p4,3)));
    if isempty(isame)==1,
%         is(p4)=0
        continue;
    else
        is(p4)=isame;
    
    end
end
[isindex]=ind2sub(size(is,1),find(is>0));
% T3(is(isindex(1,:)),2)
% M(isindex(1,:),3)
Mtz=[T3(is(isindex(1,:)),2) M(isindex(1,:),3)];
    
%pairwise distance between rows in M
%   figure
%   P=squareform(pdist(M));
P=squareform(pdist(Mtz));
  P=P<d;
%  subplot(2,2,2)
%   imagesc(P)
%   title(['Pairwise distance with cutoff=',num2str(d)]) %' ts=',num2str(ts),' Type ',num2str(stype),' DistanceAway ',num2str(d)])
%   xlabel('1st Kinase ID'); ylabel('2nd Kinase ID');
  
cnum=0; %cluster number
nc = []; %no call list
for a=1:length(P)
    tmp = P(a,:);
    if P(a,a)==1 %exclude diagonal in pdist
        cnum = cnum + 1;
        nc = [a]; 
    end
    
    P(a,:) = zeros(1,size(P,2));
    
    index = find(tmp==1); %find where pdist is 1 in tmp row 
    nc = [nc; index']; %add those values to index
    
    while length(index)>=1  
        tmp = P(index,:); %look in index rows
        P(index,:) = zeros(size(tmp)); %turn rows just found to zeros
        [~,temp_j] = ind2sub(size(tmp),find(tmp==1)); %extract indices where pdist is 1
        index = unique(temp_j); %only take unique values
        nc = [nc; index]; %add new values to index
    end
    
    if length(nc)>=1
        total.cluster(cnum) = {unique(nc)}; %store clusters of one particle or more
    end
    nc = [];
end
%cluster_num=cnum

% %visualization of clusters
% Ma = [M zeros(size(M,1),1)];
% acl=[];
% %figure
% subplot(2,2,3)
% for b=1:length(total.cluster)
%     Ma(total.cluster{b},3) = repmat(b,length(total.cluster{b}),1);%replicate/tile array (so in form like pdist)
%     tmp = Ma(total.cluster{b},1:2);
%     if size(tmp,1)>2 %must be 2 or more 
%         [k,a] = convhull(tmp(:,1),tmp(:,2)); %convex hull (smallest convex set that contains all points)
%         plot(tmp(k,1),tmp(k,2))
%         hold on
%         %acl(end+1,:)=[a];
%     end
% end
% 
% scatter3(M(:,1),M(:,2),M(:,3),50,'.')
% title(['Convex hull']) %, ' ts=',num2str(ts),' DistanceAway ',num2str(d)])

%get rid of single points in total.cluster
for c=1:length(total.cluster)
    if length(total.cluster{c})==1
        total.cluster{c}=[]; 
    end  
end
total.cluster=total.cluster(~cellfun('isempty',total.cluster));
cluster_num=length(total.cluster);

%visualize total.cluster
% M=[M zeros(length(M),1)];
Mtz=[Mtz zeros(length(Mtz),1)];
for e=1:length(total.cluster)
%     M(total.cluster{e},4)=e;
    Mtz(total.cluster{e},3)=e;
end
Mtz2=[T3(is(isindex(1,:)),1) T3(is(isindex(1,:)),2) M(isindex(1,:),1) M(isindex(1,:),2) M(isindex(1,:),3) Mtz(:,3)];
% % subplot(2,2,4)
% figure
% % scatter3(M(:,1),M(:,2),M(:,3),200,M(:,4),'.'),colorbar
% scatter(Mtz(:,1),Mtz(:,2),400,Mtz(:,3),'.'),colorbar
% title(['Clusters']) %, ' ts=',num2str(ts),' DistanceAway ',num2str(d)])
% xlabel('x');ylabel('y');zlabel('z');


%number of particles per cluster
    
%end
