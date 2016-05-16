clear all



%     inputFilename=sprintf('../data/data_gradSteep_memThick2/cell_rdme_Lmem_gradSteep_1000rep_c1b_3.0e-5_c2b_7.0e-5_c4_8.0e-3_c5_8.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-12.lm');
inputFilename=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);

sp=[0 1 2 5 6];
R=1;
sizeL=2000;
rows=2;cols=2;plotIndex=1;
for i=2
    species=sp(i);
    countsTime=zeros(sizeL,50,50,50);
    for L=1:sizeL
        data=cast(permute(hdf5read(inputFilename,...
            sprintf('/Simulations/%07d/Lattice/%010d',R,L)),[4,3,2,1]),'double');
        counts=zeros(50,50,50,17);
        SubvolumeCount=sum((data==species+1),4);
        [l,m,n]=ind2sub(size(SubvolumeCount),find(SubvolumeCount>0));
        if (size(l,1)==size(m,1)) && (size(m,1)==size(n,1))
            for x=1:size(l,1)
                count=SubvolumeCount(l(x),m(x),n(x));
                counts(l(x),m(x),n(x),count)=counts(l(x),m(x),n(x),count)+1;
            end
        end
        for latticex=1:50
            for latticey=1:50
                for latticez=1:50
                    for num=1:9
                        mean(latticex,latticey,latticez,num)=(num-1)*counts(latticex,latticey,latticez,num);
                    end
                end
            end
        end
        Lcounts=sum(mean,4);
        for x=1:size(l)
            countsTime(L,l(x),m(x),n(x))=Lcounts(l(x),m(x),n(x));
        end
    end
    
    traj=zeros(100,size(x1,1));
    
    for time=1:100
        for a=1:size(x1)
            traj(time,a)=countsTime(time,x1(a),y1(a),z1(a));
        end
        
    end
    [t,a1]=ind2sub(size(traj),find(traj>0));
    [Ntheta,p,q]=hist2d(t,theta(a1))
    figure(1)
    subplot(rows,cols,plotIndex)
%     contourf(q,p,N)
    
    image(Ntheta)
    title(['theta vs time, species=',num2str(species)]);
    [Nphi,p,q]=hist2d(t,phi(a1))
    figure(2)
    subplot(rows,cols,plotIndex)
%     contourf(q,p,N)
    
    image(Nphi)
    title(['phi vs time, species=',num2str(species)]);
   
%     time=1:100;
    % figure(i)
    % plot(theta,traj(100,:))
%     figure(3)
%     subplot(rows,cols,plotIndex)
    % plot(time,sum(traj,2))
    % contour(theta,time,traj)
%     image(traj*64)
%     title(['species=',num2str(species)]);
%     figure(4)
%     subplot(rows,cols,plotIndex)
    % contour(phi,time,traj)
    % scatter(theta,traj(100,:))
%     image(traj*64)
%     % [N,X,Y]=hist2d(theta,traj(100,:))
%     title(['species=',num2str(species)]);
    plotIndex=plotIndex+1;
    if (plotIndex>rows*cols), plotIndex=1; end
end



% ts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
% 
% counts=cast(permute(hdf5read(inputFilename,...
% sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
% % a(i,s,R)=counts(size(ts,2),1);
% figure (3)
% subplot(rows,cols,plotIndex);
% % plot(ts(1:1000),counts(1:1000,1))
% plot(ts,counts(:,1))