clear all
sp=[1 2 3 6 7];
rows=1;cols=1;plotIndex=1;
for i=3
%     inputFilename2=sprintf('../data_gradSteep_memThick2/cell_rdme_Lmem_gradSteep_c1b_3.0e-5_c2b_7.0e-5_c4_8.0e-3_c5_8.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-12_Dr_5.0e-12_Drl_5.0e-12.lm');
inputFilename2=sprintf('../data/data_gradSteep_memThick2/cell_rdme_Lmem_gradSteep_noSpecies.lm');
LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
% theta=atan2(abs(y1-ctr),abs(x1-ctr));
%             phi=atan2((abs(z1-ctr)),sqrt((x1-ctr).^2+(y1-ctr).^2));
%             rho=sqrt((x1-ctr).^2+(y1-ctr).^2+(abs(z1-ctr)).^2);
% mean2=zeros(1,size(x1,1));
species=sp(i);
    inputFilename=sprintf('../pdf/pdf_c6_4_memThick2/Dkp_0.dat/00002.00002.0000%d.mat',species);
load(inputFilename);
% ctr=sqrt(3*(25^2));

for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:16]
                data(i,j,k,l)=(l-1).*celldata(i,j,k,l);

            end
            
        end
    end
end

mean1=sum(data,4)./sum(sum(sum(sum(data,4),3),2));
% mean1=sum(data,4);
for a=1:50
    mean2(a)=mean1(a,a,a);
end


subplot(rows,cols,plotIndex)
plot(1:50,mean2)
plotIndex=plotIndex+1;
if (plotIndex>rows*cols), plotIndex=1; end   
    
    
end