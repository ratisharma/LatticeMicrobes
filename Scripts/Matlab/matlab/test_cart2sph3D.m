% % % % % % % % Convert 3D coordinates to spherical polar coordinates
clear all
sp=[1 2 6 7];
rows=2;cols=2;plotIndex=1;

%     inputFilename2=sprintf('../data/data_gradSteep_memThick2/cell_rdme_Lmem_gradSteep_c1b_3.0e-5_c2b_7.0e-5_c4_8.0e-3_c5_8.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-12_Dr_5.0e-12_Drl_5.0e-12.lm');
inputFilename2=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
% theta=atan2(abs(y1-ctr),abs(x1-ctr));
%             phi=atan2((abs(z1-ctr)),sqrt((x1-ctr).^2+(y1-ctr).^2));
%             rho=sqrt((x1-ctr).^2+(y1-ctr).^2+(abs(z1-ctr)).^2);
files=[2 3 4 5];
Ds=[12 13 14 15];
mean2=zeros(1,size(x1,1));
for i=2
    D=Ds(i);
    file=files(i);
species=sp(i);
%     inputFilename=sprintf('../pdf/pdf_c6_4_memThick2/Dkp_5e-%d.dat/0000%d.00002.00003.mat',D,file);
    inputFilename=sprintf('../pdf/pdf_mono_Dkp15_Drl15/ligand.dat/00005.00005.0000%d.mat',species);
%     inputFilename=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/tavg_on_c4_7_c5_5_c6_4_2000a.dat/00005.00005.0000%d.mat',species);
% if (species==6)||(species==7),
%    inputFilename=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/pdf_c4_7_c5_5_c6_4_500.dat/00005.00005.0000%d.mat',species); 
% end
load(inputFilename);
data=zeros(50,50,50,16);
sumPDF=sum(sum(sum(sum(celldata),2),3),4);
for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:9]
   
                data(i,j,k,l)=(l-1).*celldata(i,j,k,l)./sumPDF;
                

            end
            
        end
    end
end

mean1=sum(data,4);

for a=1:size(x1)
    mean2(a)=mean1(x1(a),y1(a),z1(a));
end


% rmin = min(rho); tmin = min(theta); pmin=min(phi);
%  rmax = max(rho); tmax = max(theta); pmax=max(phi);
%  
%  % Define the resolution of the grid:
%  rres=128; % # of grid points for R coordinate. (change to needed binning)
%  tres=90; % # of grid points for theta coordinate (change to needed binning)
%  pres=180;
%  F = TriScatteredInterp(theta,phi,mean2','natural');
% 
%  %Evaluate the interpolant at the locations (rhoi, thetai).
%  %The corresponding value at these locations is Zinterp:
% 
%  [thetai,phii] = meshgrid(linspace(tmin,tmax,tres),linspace(pmin,pmax,pres));
%  Zinterp = F(thetai,phii);
%  
% %  subplot(1,2,1); contourf(M) ; axis square
% %  subplot(1,2,2); contourf(Zinterp) ; axis square


    



 %Evaluate the interpolant at the locations (rhoi, thetai).
 %The corresponding value at these locations is Zinterp:

 

%  subplot(1,2,1); contourf(mean1(:,:,15)) ; axis square
%  subplot(1,2,2); contourf(Zinterp) ; axis square
% figure (10)
% subplot(rows,cols,plotIndex)
% scatter3(theta,phi,mean2)
% title(['density vs theta and phi, species=',num2str(species)])
% xlabel({'theta'});
% ylabel({'phi'})
% zlabel({'density'})
% contourf(mean1(:,:,25))
% % hold;
% % scatter(phi,mean2)
% %  contourf(Zinterp)

delete('analysisData/pdf_mono_gradient.mat');
outputFilename=sprintf('analysisData/pdf_mono_gradient.mat');
save(outputFilename,'data');

figure (8)
subplot(rows,cols,plotIndex)
scatter(theta,mean2)
title(['density vs theta, species',num2str(species)])
xlabel('theta','FontWeight','bold','FontSize',12);
ylabel('density','FontWeight','bold','FontSize',12)

figure(9)
subplot(rows,cols,plotIndex)
scatter(phi,mean2)
title(['density vs phi, species',num2str(species)])
xlabel('ph','FontWeight','bold','FontSize',12);
ylabel('density','FontWeight','bold','FontSize',12)

figure(10)
subplot(rows,cols,plotIndex)
scatter3(x1,y1,z1,100,mean2,'filled'),colorbar
xlabel('x','FontWeight','bold','FontSize',12);
ylabel('y','FontWeight','bold','FontSize',12);
zlabel('z','FontWeight','bold','FontSize',12);

figure(11)
subplot(rows,cols,plotIndex)
scatter(theta,z1,100,mean2,'filled'),colorbar
title(['density vs theta and z for gradient, species',num2str(species)])
xlabel('theta','FontWeight','bold','FontSize',12);
ylabel('z','FontWeight','bold','FontSize',12)
%  scatter(theta,mean2)
plotIndex=plotIndex+1;
if (plotIndex>rows*cols), plotIndex=1; end   
    
    
end