% % % Script to calculate the center of mass of the points generated from
% % % a single on event.

clear all
inputFilename2=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
% density=[];
% dist=[];
matfile1=sprintf('analysisData/Dkp15_Drl15/dist_vs_density.mat');
load(matfile1);
for file=27:51
    file
    matfile=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/gradient/Dirs_traj_on_c4_7_c5_5_c6_4.dat/00005.00005.00002.00003.%05d.mat',file);
load(matfile);
onEvents=0;
onEvents=find(sum(sum(sum(sum(celldata,5),4),3),2)>0);
data=zeros(5,50,50,50,17);
for i=1:onEvents(end)
    for j=1:50
        for k=1:50
            for l=1:50
                for m=1:17
                    data(i,j,k,l,m)=(m-1)*celldata(i,j,k,l,m);
                end
            end
        end
    end
end
max=0;
event=[];
for i=1:onEvents(end)
total=sum(data(i,:,:,:,:),5);
tot=find(total>0);
if size(tot,1)>200
    event=[event i];
% end
mean1=sum(data(i,:,:,:,:),5)./sum(sum(sum(sum(data(i,:,:,:,:),5),4),3),2);
[p q r s]=ind2sub(size(mean1),find(mean1>0));
% mean1(find(mean1>0));
cmx=0;
cmy=0;
cmz=0;
for i=1:size(p,1)
    density1(i)=mean1(1,q(i),r(i),s(i));
    cmx= cmx+ q(i)*density1(i);
    cmy=cmy+r(i)*density1(i);
    cmz=cmz+s(i)*density1(i);
end
density;
cmx=cmx./sum(density1);
cmy=cmy./sum(density1);
cmz=cmz./sum(density1);
% figure
% scatter3(q,r,s,200,'.')
% hold on;
% scatter3(cmx,cmy,cmz,600,'.','r')

for i=1:size(p,1)
    dist1(i)=sqrt((cmx-q(i))^2+(cmy-r(i))^2+(cmz-s(i))^2);
    density1(i)=mean1(1,q(i),r(i),s(i));
end
density=[density density1];
dist=[dist dist1];
clear mean1 density1 dist1 p q r s
end
end
event
end

% delete('analysisData/Dkp15_Drl15/dist_vs_density.mat');
% outputFilename=sprintf('analysisData/Dkp15_Drl15/dist_vs_density.mat');
% save(outputFilename,'dist','density');

% figure
% scatter(dist,density);
% binranges=0:max(dist)
[Na,binranges]=hist(dist,10);
% [Nr,q]=hist(ratio,10);
meanRatioHist=zeros(size(binranges,2),1);
for id=1:size(binranges,2)
%     id
    if (id==1),
        [idx3]=ind2sub(size(dist(1,:)),find(dist(1,:)<=binranges(id)));
        for a5=1:size(idx3,2)
        meanRatioHist(id)=meanRatioHist(id)+density(1,idx3(1,a5))./size(idx3,2);
        end
    else
       [idx3]=ind2sub(size(dist(1,:)),find(dist(1,:)>binranges(id-1) & dist(1,:)<=binranges(id)));
       if isempty(idx3)==1
           continue
       else
       for a5=1:size(idx3,2)
        meanRatioHist(id)=meanRatioHist(id)+density(1,idx3(1,a5))./size(idx3,2);
       end
       end
    end
end
% figure
plot(binranges,meanRatioHist);
% hold on;

% for a=1:size(p,1)
%     mean2(a)=mean1(1,q(a),r(a),s(a));
%     vabx(a)=q(a)-ctr;
%     vaby(a)=r(a)-ctr;
%     vabz(a)=s(a)-ctr;
%     va0x=0-ctr;
%     va0y=0-ctr;
%     va0z=0-ctr;
%     cr0bx(a)=va0y*vabz(a)-va0z*vaby(a);
%     cr0by(a)=va0z*vabx(a)-va0x*vabz(a);
%     cr0bz(a)=va0x*vaby(a)-va0y*vabx(a);
%     ab(a)=sqrt((vabx(a))^2+(vaby(a))^2+(vaby(a))^2);
%     a0=sqrt(va0x^2+va0y^2+va0z^2);
% %     angle(a)=acos((vabx(a)*va0x+vaby(a)*va0y+vabz(a)*va0z)/(ab(a)*a0));
%     dot0b(a)=vabx(a)*va0x+vaby(a)*va0y+vabz(a)*va0z;
%     normcr0b(a)=sqrt((cr0bx(a))^2+(cr0by(a))^2+(cr0bz(a))^2);
%     angle(a)=atan2(normcr0b(a),dot0b(a));
% end

% % % [Na,binranges]=hist(angle,5);
% % % % [Nr,q]=hist(ratio,10);
% % % meanRatioHist=zeros(size(binranges,2),1);
% % % for id=1:size(binranges,2)
% % % %     id
% % %     if (id==1),
% % %         [idx3]=ind2sub(size(angle(1,:)),find(angle(1,:)<=binranges(id)));
% % %         for a5=1:size(idx3,1)
% % %         meanRatioHist(id)=meanRatioHist(id)+density(1,idx3(1,a5))./size(idx3,1);
% % %         end
% % %     else
% % %        [idx3]=ind2sub(size(angle(1,:)),find(angle(1,:)>binranges(id-1) & angle(1,:)<=binranges(id)));
% % %        if isempty(idx3)==1
% % %            continue
% % %        else
% % %        for a5=1:size(idx3,1)
% % %         meanRatioHist(id)=meanRatioHist(id)+density(1,idx3(1,a5))./size(idx3,1);
% % %        end
% % %        end
% % %     end
% % % end
% figure
% % % plot(binranges,meanRatioHist);
% % % hold on;

% figure
% scatter(angle,mean2)
% hold on;
% end
% title(['density vs angle'])
% xlabel({'theta'});
% ylabel({'density'})
% % clear mean1 density dist p q r s angle
% % end


