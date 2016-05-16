clear all

inputFilename2=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);

data=zeros(50,50,50,17);
mean2=zeros(1,size(x1,1));
mean4=zeros(1,size(x1,1));
matfile1=sprintf('analysisData/pdf_min_ligand.mat');
load(matfile1);
sumpdf=sum(sum(sum(sum(pdf,4),3),2));

for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:17]
   
                density(i,j,k,l)=(l-1)*pdf(i,j,k,l);
                

            end
            
        end
    end
end

mean1=sum(density,4);

data2=zeros(50,50,50,17);
matfile2=sprintf('analysisData/pdf_gradient.mat');
matfile3=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/pdf_c4_7_c5_5_c6_4.dat/00005.00005.00007.mat');
load(matfile2);
sumPDF=sum(sum(sum(sum(pdf),2),3),4);

for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:16]
   
                data2(i,j,k,l)=(l-1)*(pdf(i,j,k,l));
                

            end
            
        end
    end
end

mean3=sum(data2,4);


load(matfile3);
for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:16]
   
                data3(i,j,k,l)=(l-1)*(celldata(i,j,k,l));
                

            end
            
        end
    end
end

mean5=sum(data3,4);

for a=1:size(x1)
    mean2(a)=mean1(x1(a),y1(a),z1(a));
    mean4(a)=mean3(x1(a),y1(a),z1(a));
    grad(a)=mean5(x1(a),y1(a),z1(a));
    ratio(a)=mean4(a)/mean2(a);
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
ratio=ratio;
grad=grad./sum(grad);
meangrad=sum(grad)./size(grad,2)
M1=[angle' ratio'];
M2=sortrows(M1);
M3=[angle' grad'];
M4=sortrows(M3);
uAngle=unique(M2(:,1));
for a2=1:size(uAngle,1)
    [idx1]=ind2sub(size(M2(:,1)),find(M2(:,1)==uAngle(a2)));
    [idx2]=ind2sub(size(M4(:,1)),find(M4(:,1)==uAngle(a2)));
    meanRatio(a2)=0;
    meanGrad(a2)=0;
    meanRatioSqr(a2)=0;
    for a3=1:size(idx1,1)
        meanRatio(a2)=meanRatio(a2)+M2(idx1(a3,1),2)./size(idx1,1);
        meanRatioSqr(a2)=meanRatioSqr(a2)+(M2(idx1(a3,1),2).^2)/size(idx1,1);
    end
%     varRatio(a2)=(meanRatioSqr(a2)-meanRatio(a2)^2)/meanRatio(a2);
    for a4=1:size(idx2,1)
        meanGrad(a2)=meanGrad(a2)+M4(idx2(a4,1),2)./size(idx2,1);
    end
    varRatio(a2)=(meanRatioSqr(a2)-meanGrad(a2)^2)/meanGrad(a2);
end
figure
scatter(angle,ratio);
hold on;
% plot(uAngle,meanGrad);
% hold on;
plot(uAngle,meanRatio);
% plot(uAngle,varRatio)
% plot(uAngle,meanRatio./meanGrad)
% figure
% [Ntheta,p,q]=hist2d(angle,ratio,20,20);
% image(Ntheta)
