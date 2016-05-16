clear all
inputFilename2=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);
for file=141:145
    matfile=sprintf('../pdf/pdf_Lmem_Dkp15_Drl15/gradient/Dirs_traj_on_c4_7_c5_5_c6_4.dat/00005.00005.00002.00003.%05d.mat',file)
load(matfile)
for i=1:5
    for j=1:50
        for k=1:50
            for l=1:50
                for m=1:17
                    data(i,j,k,l,m)=(m-1)*celldata(i,j,k,l,m);
                end
            end
        end
    end
end

mean1=sum(data(4,:,:,:,:),5)./sum(sum(sum(sum(data(4,:,:,:,:),5),4),3),2);

for a=1:size(x1)
    mean2(a)=mean1(1,x1(a),y1(a),z1(a));
    vabx(a)=x1(a)-ctr;
    vaby(a)=y1(a)-ctr;
    vabz(a)=z1(a)-ctr;
    va0x=0-ctr;
    va0y=0-ctr;
    va0z=0-ctr;
    cr0bx(a)=va0y*vabz(a)-va0z*vaby(a);
    cr0by(a)=va0z*vabx(a)-va0x*vabz(a);
    cr0bz(a)=va0x*vaby(a)-va0y*vabx(a);
    ab(a)=sqrt((vabx(a))^2+(vaby(a))^2+(vaby(a))^2);
    a0=sqrt(va0x^2+va0y^2+va0z^2);
%     angle(a)=acos((vabx(a)*va0x+vaby(a)*va0y+vabz(a)*va0z)/(ab(a)*a0));
    dot0b(a)=vabx(a)*va0x+vaby(a)*va0y+vabz(a)*va0z;
    normcr0b(a)=sqrt((cr0bx(a))^2+(cr0by(a))^2+(cr0bz(a))^2);
    angle(a)=atan2(normcr0b(a),dot0b(a));
end

% figure
scatter(angle,mean2)
hold on;
end
title(['density vs angle'])
xlabel({'theta'});
ylabel({'density'})


