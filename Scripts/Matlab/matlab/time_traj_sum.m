clear all



% inputFilename=sprintf('../data/data_gradSteep_memThick2/cell_rdme_Lmem_gradSteep_1000rep_c1b_3.0e-5_c2b_7.0e-5_c4_8.0e-3_c5_8.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-12.lm');
% inputFilename=sprintf('../data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
inputFilename=sprintf('../data/data_Dkp15_Drl15_memThick2/cell_rdme_Lmem_gradSteep_1000reps_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
LS=permute(hdf5read(inputFilename,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);

sp=[0 1 2 5 6];
% R=1;
sizeL=2000;
numReplicates=15;
rows=1;cols=1;plotIndex=1;
for i=2
    species=sp(i)
    Ntheta=zeros(100,100);
%     Nphi=zeros(10,10);
    for R=1:numReplicates
        fprintf('analyzing replicate %d\n',R);
        
        countsTime=zeros(sizeL,50,50,50);
        traj=zeros(sizeL,size(x1,1));
        for L=1:sizeL
            fprintf('binning replicate %d lattice %d\n',R,L);
            data=cast(permute(hdf5read(inputFilename,...
                sprintf('/Simulations/%07d/Lattice/%010d',R,L)),[4,3,2,1]),'double');
            counts=zeros(50,50,50,17);
            SubvolumeCount=sum((data==species+1),4);
            [l,m,n]=ind2sub(size(SubvolumeCount),find(SubvolumeCount>0));
%             if (size(l,1)==size(m,1)) && (size(m,1)==size(n,1))
                for x=1:size(l,1)
                    count=SubvolumeCount(l(x),m(x),n(x));
                    counts(l(x),m(x),n(x),count)=counts(l(x),m(x),n(x),count)+1;
                end
%             end
%             for latticex=1:50
%             for latticey=1:50
%                 for latticez=1:50
                for x=1:size(l,1)
                    for num=1:9
%                         mean(latticex,latticey,latticez,num)=(num)*counts(latticex,latticey,latticez,num);
                        mean(l(x),m(x),n(x),num)=num*counts(l(x),m(x),n(x),num);
                    end
                end
%             end
%         end
        Lcounts=sum(mean,4);
%             Lcounts=sum(counts,4);
            for x=1:size(l)
                countsTime(L,l(x),m(x),n(x))=Lcounts(l(x),m(x),n(x));
            end
            for a=1:size(x1)
                traj(L,a)=countsTime(L,x1(a),y1(a),z1(a));
            end
        end
        
%         traj=zeros(100,size(x1,1));
%         
%         for time=1:100
%             for a=1:size(x1)
%                 traj(time,a)=countsTime(time,x1(a),y1(a),z1(a));
%             end
%             
%         end
        [t,a1]=ind2sub(size(traj),find(traj>0));
        Ntheta=hist2d(t,theta(a1),100,100)+Ntheta;
%         Nphi=hist2d(t,phi(a1),10,10)+Nphi;
    end
    Ntheta=Ntheta./numReplicates;
%     Nphi=Nphi./numReplicates;
    figure(1)
    subplot(rows,cols,plotIndex)
    %     contourf(q,p,N)
    
    image(Ntheta)
    title(['theta vs time, species=',num2str(species)]);
    
%     figure(2)
%     subplot(rows,cols,plotIndex)
%     %     contourf(q,p,N)
%     
%     image(Nphi)
%     title(['phi vs time, species=',num2str(species)]);
%     
%     figure(3)
%     subplot(rows,cols,plotIndex)
%     contourf(Ntheta)
%     title(['theta vs time, species=',num2str(species)]);
%     
%     figure(4)
%     subplot(rows,cols,plotIndex)
%     contourf(Nphi)
%     title(['phi vs time, species=',num2str(species)]);
outputFilename=sprintf('matfiles/sum_Dkp15_Drl15/data2_Dkp15_Drl15_species_%d',species);
    save(outputFilename,'Ntheta')
    plotIndex=plotIndex+1;
    if (plotIndex>rows*cols), plotIndex=1; end
    
end



