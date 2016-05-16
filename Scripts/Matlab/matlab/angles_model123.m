
% This script is meant to calculate a histogram of the density of
% phosphorylated kinases vs. the angle (omega) along the gradient. The mean
% of the histogram is then plotted vs. the angle (omega).This is done for
% the three models in this case.

clear all
for file=1:4
    if (file==1),
%         matfile1=sprintf('analysisData/feedback_kp/Dkp14_Drl14/pdf_min_ligand.mat');
%         matfile2=sprintf('analysisData/feedback_kp/Dkp14_Drl14/pdf_gradient.mat');
%         matfile1=sprintf('analysisData/Dkp14_Drl14/pdf_min_ligand.mat');
%         matfile2=sprintf('analysisData/Dkp14_Drl14/pdf_gradient.mat');
        matfile1=sprintf('../pdf/pdf_mono_Dkp15_Drl15/min_ligand_countR_400.dat/00005.00005.00002.mat');
        matfile2=sprintf('../pdf/pdf_mono_Dkp15_Drl15/gradient_countR_400.dat/00005.00005.00002.mat');
    elseif (file==2)
%         matfile1=sprintf('analysisData/feedback_kp/Dkp14_Drl14_1.0/pdf_min_ligand.mat');
%         matfile2=sprintf('analysisData/feedback_kp/Dkp14_Drl14_1.0/pdf_gradient.mat');
%         matfile1=sprintf('analysisData/Dkp14_Drl14_1.0/pdf_min_ligand9.mat');
%         matfile2=sprintf('analysisData/Dkp14_Drl14_1.0/pdf_gradient9.mat');
        matfile1=sprintf('analysisData/pdf_min_ligand.mat');
        matfile2=sprintf('analysisData/pdf_gradient.mat');
    elseif (file==3)
%         matfile1=sprintf('analysisData/pdf_min_ligand.mat');
%         matfile2=sprintf('analysisData/pdf_gradient.mat');
        matfile1=sprintf('analysisData/feedback_kp/Dkp15_Drl15/pdf_min_ligand.mat');
        matfile2=sprintf('analysisData/feedback_kp/Dkp15_Drl15/pdf_gradient.mat');
    elseif (file==4)
        matfile1=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/pdf_c4_7_c5_5_c6_4.dat/00005.00005.00006.mat');
        matfile2=matfile1;
    end
        
inputFilename2=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);

data=zeros(50,50,50,17);
mean2=zeros(1,size(x1,1));
mean4=zeros(1,size(x1,1));
% matfile1=sprintf('analysisData/pdf_min_ligand.mat');
load(matfile1);
% sumpdf=sum(sum(sum(sum(pdf,4),3),2));
if (file==1)
    for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:9]
   
                density(i,j,k,l)=(l-1)*celldata(i,j,k,l);
                

            end
            
        end
    end
    end
elseif (file==4)
    for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:17]
   
                density(i,j,k,l)=(l-1)*celldata(i,j,k,l);
                

            end
            
        end
    end
    end

else
for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:17]
   
                density(i,j,k,l)=(l-1)*pdf(i,j,k,l);
                

            end
            
        end
    end
end
end

mean1=sum(density,4);

data2=zeros(50,50,50,17);
load(matfile2);
% sumPDF=sum(sum(sum(sum(pdf),2),3),4);
if (file==1)
    for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:9]
   
                data2(i,j,k,l)=(l-1)*(celldata(i,j,k,l));
                

            end
            
        end
    end
    end
elseif (file==2)||(file==3)
for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:16]
   
                data2(i,j,k,l)=(l-1)*(pdf(i,j,k,l));
                

            end
            
        end
    end
end
end

if (file==1)||(file==2)||(file==3)
mean3=sum(data2,4);
else
    mean3=mean1;
end

for a=1:size(x1)
    mean2(a)=mean1(x1(a),y1(a),z1(a));
    mean4(a)=mean3(x1(a),y1(a),z1(a));
%     grad(a)=mean5(x1(a),y1(a),z1(a));
    if file==4
        ratio(a)=mean4(a);
    else
        ratio(a)=mean4(a)./mean2(a);
    end
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
if file==4
avgLigand=(sum(mean4)/size(x1,1));
ratio=ratio./avgLigand;
end
% grad=grad./sum(grad);
% meangrad=sum(grad)./size(grad,2)
M1=[angle' ratio'];
M2=sortrows(M1);
% % M3=[angle' grad'];
% % M4=sortrows(M3);
% uAngle=unique(M2(:,1));
% for a2=1:size(uAngle,1)
%     [idx1]=ind2sub(size(M2(:,1)),find(M2(:,1)==uAngle(a2)));
%     [idx2]=ind2sub(size(M4(:,1)),find(M4(:,1)==uAngle(a2)));
%     meanRatio(a2)=0;
%     meanGrad(a2)=0;
%     meanRatioSqr(a2)=0;
%     num(a2)=size(idx1,1);
%     for a3=1:size(idx1,1)
%         meanRatio(a2)=meanRatio(a2)+M2(idx1(a3,1),2)./size(idx1,1);
% %         meanRatioSqr(a2)=meanRatioSqr(a2)+(M2(idx1(a3,1),2).^2)/size(idx1,1);
%     end
% %     varRatio(a2)=(meanRatioSqr(a2)-meanRatio(a2)^2)/meanRatio(a2);
%     for a4=1:size(idx2,1)
%         meanGrad(a2)=meanGrad(a2)+M4(idx2(a4,1),2)./size(idx2,1);
%     end
% %     varRatio(a2)=(meanRatioSqr(a2)-meanGrad(a2)^2)/meanGrad(a2);
% end
% figure
% scatter(angle,ratio);
% hold on;
% % plot(uAngle,meanGrad);
% % hold on;
% plot(uAngle,meanRatio);
% plot(uAngle,varRatio)
% plot(uAngle,meanRatio./meanGrad)
% figure
% [Ntheta,p,q]=hist2d(angle,ratio,20,20);
% image(Ntheta)
% subplot(1,2,1)
% scatter(theta,z1,100,ratio,'filled'),colorbar
% subplot(1,2,2)
% scatter(theta,z1,100,angle,'filled'),colorbar
% [N,p,q]=hist2d(angle,ratio,10,10)
% plot(p,max(N))
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
% figure
plot(centers,meanRatioHist,'*--');
% errorbar(centers,meanRatioHist,stdError,'*--')
hold on;
end
legend('Model I','Model II', 'Model III','Ligand')
xlabel('omega');
ylabel('density')
axis([0 3.2 0.85 1.25])
ax = gca;
ax.XTick = [0 pi/2 pi];
        





