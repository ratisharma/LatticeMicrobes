clear all

rows=1;cols=1;plotIndex=1;
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

for a=1:size(x1)
    mean2(a)=mean1(x1(a),y1(a),z1(a));
    
end

% inputFilename3=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/tavg_on_c4_7_c5_5_c6_4_all.dat/00005.00005.00003.mat');

% load(inputFilename3);
data2=zeros(50,50,50,17);
matfile2=sprintf('analysisData/pdf_gradient.mat');
load(matfile2);
sumPDF=sum(sum(sum(sum(pdf),2),3),4);

for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:17]
   
                data2(i,j,k,l)=(l-1)*(pdf(i,j,k,l));
                

            end
            
        end
    end
end

mean3=sum(data2,4);

for a=1:size(x1)
    mean4(a)=mean3(x1(a),y1(a),z1(a));
end

matfile3=sprintf('analysisData/neighbours.mat');
load(matfile3);

for a=1:size(x1)
    ratio(a)=(mean4(a))/mean2(a);
end

ratioNorm=ratio;

figure(10)
subplot(rows,cols,plotIndex)
scatter3(x1,y1,z1,100,ratioNorm,'filled'),colorbar
title(['density vs x,y,z for normalized gradient'])
xlabel('x','FontWeight','bold','FontSize',12);
ylabel('y','FontWeight','bold','FontSize',12);
zlabel('z','FontWeight','bold','FontSize',12);

figure(16)
subplot(rows,cols,plotIndex)
scatter3(x1,y1,z1,100,mean4,'filled'),colorbar
title(['density vs x,y,z for gradient'])
xlabel('x','FontWeight','bold','FontSize',12);
ylabel('y','FontWeight','bold','FontSize',12);
zlabel('z','FontWeight','bold','FontSize',12);

figure(12)
subplot(rows,cols,plotIndex)
scatter(theta,z1,200,ratioNorm,'filled'),colorbar
title(['density vs theta and z for normalized gradient'])
xlabel('theta','FontWeight','bold','FontSize',12);
ylabel('z','FontWeight','bold','FontSize',12);

figure(13)
subplot(rows,cols,plotIndex)
scatter(theta,z1,200,mean2,'filled'),colorbar
title(['density vs theta and z for constant conc of ligand'])
xlabel('theta','FontWeight','bold','FontSize',12);
ylabel('z','FontWeight','bold','FontSize',12);

figure(14)
subplot(rows,cols,plotIndex)
scatter(theta,z1,200,mean4,'filled'),colorbar
title(['density vs theta and z for gradient'])
xlabel('theta','FontWeight','bold','FontSize',12);
ylabel('z','FontWeight','bold','FontSize',12);


figure (1)
subplot(rows,cols,plotIndex)
scatter(theta,ratioNorm,100,'filled')
title(['density vs theta for normalized gradient'])
xlabel('theta','FontWeight','bold','FontSize',12);
ylabel('density','FontWeight','bold','FontSize',12)

figure (2)
subplot(rows,cols,plotIndex)
scatter(theta,mean4,100,'filled')
title(['density vs theta for gradient'])
xlabel('theta','FontWeight','bold','FontSize',14);
ylabel('density','FontWeight','bold','FontSize',14)

figure (3)
subplot(rows,cols,plotIndex)
scatter(phi,mean4,100,'filled')
title(['density vs phi for gradient'])
xlabel('phi','FontWeight','bold','FontSize',14);
ylabel('density','FontWeight','bold','FontSize',14)

figure (4)
subplot(rows,cols,plotIndex)
scatter(phi,ratioNorm,100,'filled')
title(['density vs phi for normalized gradient'])
xlabel('phi','FontWeight','bold','FontSize',14);
ylabel('density','FontWeight','bold','FontSize',14)