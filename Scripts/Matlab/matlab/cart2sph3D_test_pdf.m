% % % % % % % % Convert 3D coordinates to spherical polar coordinates
clear all
reps=[250 500 1000 1500 2000 3500];
rows=2;cols=3;plotIndex=1;

%     inputFilename2=sprintf('../data/data_gradSteep_memThick2/cell_rdme_Lmem_gradSteep_c1b_3.0e-5_c2b_7.0e-5_c4_8.0e-3_c5_8.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-12_Dr_5.0e-12_Drl_5.0e-12.lm');
inputFilename2=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
% theta=atan2(abs(y1-ctr),abs(x1-ctr));
%             phi=atan2((abs(z1-ctr)),sqrt((x1-ctr).^2+(y1-ctr).^2));
%             rho=sqrt((x1-ctr).^2+(y1-ctr).^2+(abs(z1-ctr)).^2);

for d=1:6
    replicates=reps(d);
    mean2=zeros(1,size(x1,1));
% species=sp(i);
%     inputFilename=sprintf('../pdf/pdf_c6_4_memThick2/Dkp_5e-15_1000rep.dat/00005.00002.0000%d.mat',species);
%     inputFilename=sprintf('../pdf/pdf_mono_Dkp15_Drl15/ligand.dat/00005.00005.0000%d.mat',species);
    inputFilename=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/tavg_on_c4_7_c5_5_c6_4_%da.dat/00005.00005.00003.mat',replicates);
% if (species==6)||(species==7),
%    inputFilename=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/pdf_c4_7_c5_5_c6_4.dat/00005.00005.0000%d.mat',species); 
% end
load(inputFilename);
data=zeros(50,50,50,17);
sumPDF=sum(sum(sum(sum(celldata),2),3),4);
for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:16]
   
                data(i,j,k,l)=(l-1).*celldata(i,j,k,l)./sumPDF;
                

            end
            
        end
    end
end

mean1=sum(data,4);

for a=1:size(x1)
    mean2(a)=mean1(x1(a),y1(a),z1(a));
end



pdfmax(d)=max(mean2,[],2);
pdfmin(d)=min(mean2,[],2);
diff(d)=pdfmax(d)-pdfmin(d);

[h1]=ind2sub(size(mean2),find(mean2>0.95*pdfmax(d)));
cluster(d)=100*size(h1,2)./size(mean2,2);


figure (14)
subplot(rows,cols,plotIndex)
scatter(theta,mean2)
title(['density vs theta, maxReplicates=',num2str(replicates)])
xlabel({'theta'});
ylabel({'density'})

figure(15)
subplot(rows,cols,plotIndex)
scatter(phi,mean2)
title(['density vs phi, maxReplicates=',num2str(replicates)])
xlabel({'ph'});
ylabel({'density'})

figure(1)
subplot(rows,cols,plotIndex)
scatter3(x1,y1,z1,100,mean2,'filled'),colorbar
title(['density vs phi, maxReplicates=',num2str(replicates)])

figure(10)
subplot(rows,cols,plotIndex)
scatter(theta,z1,100,mean2,'filled'),colorbar
title(['density vs theta and z1, maxReplicates=',num2str(replicates)])
plotIndex=plotIndex+1;
if (plotIndex>rows*cols), plotIndex=1; end   
    
    
end

figure(2)
plot(reps,pdfmax);
hold;
plot(reps,pdfmin)
plot(reps,diff)
legend('pdfmax','pdfmin','diff')
xlabel({'replicates'});
ylabel({'pdf'})


figure(3)
plot(reps,cluster)
title(['no. of replicates vs percentage clustered'])
xlabel({'replicates'});
ylabel({'percentage clustered'})

