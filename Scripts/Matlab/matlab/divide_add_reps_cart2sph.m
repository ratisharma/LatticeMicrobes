% % % % % % % % Convert 3D coordinates to spherical polar coordinates
clear all
reps=200;
rows=1;cols=1;plotIndex=1;

%     inputFilename2=sprintf('../data/data_gradSteep_memThick2/cell_rdme_Lmem_gradSteep_c1b_3.0e-5_c2b_7.0e-5_c4_8.0e-3_c5_8.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-12_Dr_5.0e-12_Drl_5.0e-12.lm');
inputFilename2=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);

data=zeros(50,50,50,17);
mean2=zeros(1,size(x1,1));
mean4=zeros(1,size(x1,1));


for d=1:25
    
% species=sp(i);
%     inputFilename=sprintf('../pdf/pdf_c6_4_memThick2/Dkp_5e-15_1000rep.dat/00005.00002.0000%d.mat',species);
%     inputFilename=sprintf('../pdf/pdf_mono_Dkp15_Drl15/ligand.dat/00005.00005.0000%d.mat',species);
    inputFilename=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/min_ligand/Dirs_tavg_on_c4_7_c5_5_c6_4.dat/00005.00005.%05d.00003.mat',d);
% if (species==6)||(species==7),
%    inputFilename=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/pdf_c4_7_c5_5_c6_4.dat/00005.00005.0000%d.mat',species); 
% end
load(inputFilename);
fprintf('Processing filename %d\n',d);
sumPDF=sum(sum(sum(sum(celldata),2),3),4);
for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:17]
   
                data(i,j,k,l)=data(i,j,k,l)+celldata(i,j,k,l);
                

            end
            
        end
    end
end
end



sumdata=sum(sum(sum(sum(data,4),3),2));
pdf=data./sumdata;

outputFilename=sprintf('analysisData/pdf_min_ligand.mat');
save(outputFilename,'pdf');
sumpdf=sum(sum(sum(sum(pdf,4),3),2));
for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:17]
   
                density(i,j,k,l)=(l-1).*pdf(i,j,k,l)./sumpdf;
                

            end
            
        end
    end
end

mean1=sum(density,4);

matfile=sprintf('analysisData/neighbours.mat');
load(matfile);

for a=1:size(x1)
    mean2(a)=mean1(x1(a),y1(a),z1(a))/total(a);
end




    inputFilename3=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/tavg_on_c4_7_c5_5_c6_4_2000a.dat/00005.00005.00003.mat');

load(inputFilename3);
data2=zeros(50,50,50,17);
sumPDF=sum(sum(sum(sum(celldata),2),3),4);
for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:16]
   
                data2(i,j,k,l)=(l-1).*celldata(i,j,k,l)./sumPDF;
                

            end
            
        end
    end
end

mean3=sum(data2,4);

for a=1:size(x1)
    mean4(a)=mean3(x1(a),y1(a),z1(a))/total(a);
end

% matfile=sprintf('analysisData/neighbours.mat');
% load(matfile);

for a=1:size(x1)
    ratio(a)=mean4(a)/(mean2(a));
end

ratioNorm=ratio./sum(ratio);

figure(10)
subplot(rows,cols,plotIndex)
scatter3(x1,y1,z1,100,ratioNorm,'filled'),colorbar

figure(11)
subplot(rows,cols,plotIndex)
scatter(theta,z1,100,ratioNorm,'filled'),colorbar
title(['density vs theta and z for gradient'])
xlabel({'theta'});
ylabel({'z'})


figure (1)
subplot(rows,cols,plotIndex)
scatter(theta,ratioNorm)
title(['density vs theta'])
xlabel({'theta'});
ylabel({'density'})

figure(2)
subplot(rows,cols,plotIndex)
scatter(phi,ratioNorm)
title(['density vs phi'])
xlabel({'ph'});
ylabel({'density'})





