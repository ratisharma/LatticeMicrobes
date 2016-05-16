% This script is meant to calculate a histogram of the density of
% ligand vs. the angle (omega) along the gradient.
% The mean of the histogram is then plotted vs. the angle (omega). The
% density scatter plot is plotted across the theta z space as well.
clear all
inputFilename2=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
matfile1=sprintf('../pdf/pdf_mono_Dkp15_Drl15/min_ligand_countR_400.dat/00005.00005.00005.mat');
% matfile1=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/pdf_c4_7_c5_5_c6_4.dat/00005.00005.00006.mat');
load(matfile1);
% sumpdf=sum(sum(sum(sum(pdf,4),3),2));

for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:9]
                density(i,j,k,l)=(l-1)*celldata(i,j,k,l);
            end

        end
    end
end
sum_mean=sum(sum(sum(sum(celldata,4),3),2));
mean1=sum(density,4);
% ./sum_mean;

for a=1:size(x1)
    mean2(a)=mean1(x1(a),y1(a),z1(a));
    vabx(a)=x1(a)-ctr;
    vaby(a)=y1(a)-ctr;
    vabz(a)=z1(a)-ctr;
    va0x=0-ctr;
    va0y=0-ctr;
    va0z=0-ctr;
    cr0bx(a)=va0y*vabz(a)-va0z*vaby(a);
    cr0by(a)=va0z*vabx(a)-va0x*vabz(a);
    cr0bz(a)=va0x*vaby(a)-va0y*vabx(a);
    ab(a)=sqrt((vabx(a))^2+(vaby(a))^2+(vaby(a))^2);
    a0=sqrt(va0x^2+va0y^2+va0z^2);
%     angle(a)=acos((vabx(a)*va0x+vaby(a)*va0y+vabz(a)*va0z)/(ab(a)*a0));
    dot0b(a)=vabx(a)*va0x+vaby(a)*va0y+vabz(a)*va0z;
    normcr0b(a)=sqrt((cr0bx(a))^2+(cr0by(a))^2+(cr0bz(a))^2);
    angle(a)=atan2(normcr0b(a),dot0b(a));
end
M1=[angle' mean2'];
M2=sortrows(M1);
uAngle=unique(M2(:,1));

[Na,centers]=hist(angle,10);
binranges=zeros(1,size(centers,2)+1);
binranges(1,1)=min(angle);
for i=2:size(binranges,2)-1
    binranges(1,i)=centers(1,i-1)+centers(1,i-1)-binranges(1,i-1);
end
binranges(1,end)=max(angle);
meanRatioHist=zeros(size(binranges,2)-1,1);
meanRatioSqr=zeros(size(binranges,2)-1,1);
varRatioHist=zeros(size(binranges,2)-1,1);
for id=1:size(binranges,2)-1
    if (id==1),
        [idx3]=ind2sub(size(M2(:,1)),find(M2(:,1)<=binranges(id+1)));
        for a5=1:size(idx3,1)
        meanRatioHist(id)=meanRatioHist(id)+M2(idx3(a5,1),2)./size(idx3,1);
        meanRatioSqr(id)=meanRatioSqr(id)+(M2(idx3(a5,1),2).^2)./size(idx3,1);
        end
        meanNum(1:size(idx3,1))=meanRatioHist(id);
%         for a5=1:size(idx3,1)
%         meanRatioSqr(id)=meanRatioSqr(id)+((M2(idx3(a5,1),2)-meanNum(a5)).^2)/size(idx3,1);
%         end
        varRatioHist(id)=(meanRatioSqr(id)-meanRatioHist(id).^2);
%         /meanRatio(a2);
        stdError(id)=sqrt(varRatioHist(id))./sqrt(size(idx3,1));
    else
       [idx3]=ind2sub(size(M2(:,1)),find(M2(:,1)>binranges(id) & M2(:,1)<=binranges(id+1)));
       for a5=1:size(idx3,1)
        meanRatioHist(id)=meanRatioHist(id)+M2(idx3(a5,1),2)./size(idx3,1);
        meanRatioSqr(id)=meanRatioSqr(id)+(M2(idx3(a5,1),2).^2)./size(idx3,1);
       end
        varRatioHist(id)=(meanRatioSqr(id)-meanRatioHist(id)^2); 
        stdError(id)=sqrt(varRatioHist(id))./sqrt(size(idx3,1));
    end
end
subplot(1,2,1)
scatter(theta,z1*0.05,20,mean2.*1e-2*1e9/(125*6.023),'filled')
axis([-3.2 3.2 0.0 2.5])
ax = gca;
ax.XTick = [-pi -pi/2 0 pi/2 pi];
ax.YTick = [1 2];
xlabel('{\theta}');ylabel('z ({\mum})')
caxis manual
caxis([11 20]);
colorbar
subplot(1,2,2)
errorbar(centers,meanRatioHist.*1e-2*1e9/(125*6.023),stdError,'*--')
% plot(centers,meanRatioHist.*1e-2/(125*6.023),'*--')
% plot(M2(:,1),(M2(:,2).*1e-2)/(125*6.023))
% legend('D=5.0e-14','D=1.0e-14', 'D=0.5e-14')
xlabel('omega');
ylabel('Ligand concentration (nM)')
% axis([0 3.2 0.94 1.12])
ax = gca;
ax.XTick = [0 pi/2 pi];
