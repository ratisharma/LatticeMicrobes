clear all
sp=[2 3 6 7];
rows=1;cols=1;plotIndex=1;

%     inputFilename2=sprintf('../data/data_gradSteep_memThick2/cell_rdme_Lmem_gradSteep_c1b_3.0e-5_c2b_7.0e-5_c4_8.0e-3_c5_8.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-12_Dr_5.0e-12_Drl_5.0e-12.lm');
inputFilename2=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
mean2=zeros(1,size(x1,1));
first=zeros(size(x1));
second=zeros(size(x1));
total=zeros(size(x1));
for i=1:size(x1)
    if (LS(x1(i)+1,y1(i),z1(i))==1)
        first(i)=first(i)+1;
    end
    if (LS(x1(i)-1,y1(i),z1(i))==1)
        first(i)=first(i)+1;
    end
    if (LS(x1(i),y1(i)+1,z1(i))==1)
        first(i)=first(i)+1;
    end
    if (LS(x1(i),y1(i)-1,z1(i))==1)
        first(i)=first(i)+1;
    end
    if (LS(x1(i),y1(i),z1(i)+1)==1)
        first(i)=first(i)+1;
    end
    if (LS(x1(i),y1(i),z1(i)-1)==1)
        first(i)=first(i)+1;
    end
    if (LS(x1(i)+2,y1(i),z1(i))==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i),y1(i)+2,z1(i))==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i),y1(i),z1(i)+2)==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i)-2,y1(i),z1(i))==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i),y1(i)-2,z1(i))==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i),y1(i),z1(i)-2)==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i)+1,y1(i)+1,z1(i))==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i)+1,y1(i)-1,z1(i))==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i)+1,y1(i),z1(i)+1)==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i)+1,y1(i),z1(i)-1)==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i)-1,y1(i)+1,z1(i))==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i)-1,y1(i)-1,z1(i))==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i)-1,y1(i),z1(i)+1)==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i)-1,y1(i),z1(i)-1)==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i),y1(i)+1,z1(i)+1)==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i),y1(i)+1,z1(i)-1)==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i),y1(i)-1,z1(i)+1)==1)
        second(i)=second(i)+1;
    end
    if (LS(x1(i),y1(i)-1,z1(i)-1)==1)
        second(i)=second(i)+1;
    end
    total(i)=first(i)+second(i);
end
figure(12)
scatter3(x1,y1,z1,100,first,'filled'),colorbar;
figure(13)
scatter3(x1,y1,z1,100,second./first,'filled'),colorbar;
figure(14)
scatter3(x1,y1,z1,100,total,'filled'),colorbar;
outputFilename=sprintf('analysisData/neighbours.mat');
save(outputFilename,'first','second','total');

% inputFilename=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/tavg_on_c4_7_c5_5_c6_4_2000a.dat/00005.00005.00003.mat');
% load(inputFilename);
% data=zeros(50,50,50,16);
% sumPDF=sum(sum(sum(sum(celldata),2),3),4);
% for i=[1:50]
%     for j=[1:50]
%         for k=[1:50]
%             for l=[1:16]
%    
%                 data(i,j,k,l)=(l-1).*celldata(i,j,k,l)./sumPDF;
%                 
% 
%             end
%             
%         end
%     end
% end
% 
% mean1=sum(data,4);
% 
% for a=1:size(x1)
%     mean2(a)=mean1(x1(a),y1(a),z1(a))/(total(a));
% end
% 
% figure(15)
% scatter(theta,z1,100,mean2,'filled'),colorbar;
% 
% figure(16)
% scatter(theta,mean2,'filled');
% 
% figure(17)
% scatter(phi,mean2,'filled');


    