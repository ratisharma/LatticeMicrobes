
clear all
filename=sprintf('../../data/feedback_kp/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
cutoffDistance=25;

LS=permute(hdf5read(filename,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta1 phi1 rho1]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
T=[theta1 phi1 rho1 x1 y1 z1];
T2=sortrows(T);
uTheta=unique(T2(:,1));

for p1=1:size(uTheta)
    [ith]=ind2sub(size(T2(:,1)),find(T2(:,1)==uTheta(p1)));
    thIndex(ith(:,1))=p1;
    Ti(ith(:,1))= ith;
end
thIndex';
Ti';
T3=[Ti' thIndex' x1 y1 z1];
ts=179;
replicate=62;
[Mtz2]=cluster_Chaining3(filename,replicate,ts,cutoffDistance,T3);

figure
% scatter3(M(:,1),M(:,2),M(:,3),200,M(:,4),'.'),colorbar
scatter(Mtz2(:,2),Mtz2(:,5),400,Mtz2(:,6),'.'),colorbar
% scatter3(Mtz2(:,3),Mtz2(:,4),Mtz2(:,5),400,Mtz2(:,6),'.')
title(['Clusters']) %, ' ts=',num2str(ts),' DistanceAway ',num2str(d)])
xlabel('x');ylabel('y');zlabel('z');