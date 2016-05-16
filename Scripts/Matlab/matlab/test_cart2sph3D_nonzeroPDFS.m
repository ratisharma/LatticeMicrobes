% % % % % % % % Convert 3D coordinates to spherical polar coordinates
clear all
sp=[1 2 3 6 7];
rows=2;cols=2;plotIndex=1;
for i=1:4
    inputFilename2=sprintf('../data/data_gradSteep_memThick2/cell_rdme_Lmem_gradSteep_c1b_3.0e-5_c2b_7.0e-5_c4_8.0e-3_c5_8.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-12_Dr_5.0e-12_Drl_5.0e-12.lm');

LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
% [theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
% theta=atan2(abs(y1-ctr),abs(x1-ctr));
%             phi=atan2((abs(z1-ctr)),sqrt((x1-ctr).^2+(y1-ctr).^2));
%             rho=sqrt((x1-ctr).^2+(y1-ctr).^2+(abs(z1-ctr)).^2);
mean2=zeros(1,size(x1,1));
species=sp(i);
    inputFilename=sprintf('../pdf/pdf_c6_4_memThick2/Dkp_5e-14.dat/00004.00002.0000%d.mat',species);
load(inputFilename);


for i=[1:50]
    for j=[1:50]
        for k=[1:50]
            for l=[1:17]
                data(i,j,k,l)=(l-1).*celldata(i,j,k,l);

            end
            
        end
    end
end

mean1=sum(data,4);
[x2 y2 z2]=ind2sub(size(mean1),find(mean1>0));
[theta phi rho]=cart2sph(x2-ctr,y2-ctr,z2-ctr);
% for a=1:size(x1)
%     mean2(a)=mean1(x1(a),y1(a),z1(a));
% end
mean2=zeros(1,size(x2,1));
for a=1:size(x2)
    mean2(a)=mean1(x2(a),y2(a),z2(a));
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
figure (1)
subplot(rows,cols,plotIndex)
scatter3(theta,phi,mean2)
% hold;
% scatter(phi,mean2)
%  contourf(Zinterp)
figure (2)
subplot(rows,cols,plotIndex)
scatter(theta,mean2)

figure(3)
subplot(rows,cols,plotIndex)
scatter(phi,mean2)
plotIndex=plotIndex+1;
if (plotIndex>rows*cols), plotIndex=1; end   
    
    
end