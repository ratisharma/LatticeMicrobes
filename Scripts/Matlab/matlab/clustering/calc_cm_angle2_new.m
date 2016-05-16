clear all
% cm_r=zeros(16000,)
for d=1
    filenum=d
filename=sprintf('analysisData/msd_surface_new_Dkp15/gradient/msd_cm_surface_new_gradient_%d.mat',d);
% filename=sprintf('analysisData/msd_surface_new_1.0Dkp14/gradient/msd_cm_surface_new_gradient_%d.mat',d);
load(filename);
for replicate=1:200
    R=200*(d-1)+replicate
    cm_r(R,1:size(cm3,2),1:size(cm3,3))=cm3(replicate,1:size(cm3,2),1:size(cm3,3));
%     if cm2==0
%         continue;
%     else
%     cm3(replicate,1:size(cm2,1))=cm2;
%     scatter(1:size(msd2,2),msd2(replicate,:),600,'.');
%     hold on;

ctr=25;
for a3=1:size(cm_r,2)
    vabx(a3)=cm_r(R,a3,1)-ctr;
    vaby(a3)=cm_r(R,a3,2)-ctr;
    vabz(a3)=cm_r(R,a3,3)-ctr;
    va0x=0-ctr;
    va0y=0-ctr;
    va0z=0-ctr;
    cr0bx(a3)=va0y*vabz(a3)-va0z*vaby(a3);
    cr0by(a3)=va0z*vabx(a3)-va0x*vabz(a3);
    cr0bz(a3)=va0x*vaby(a3)-va0y*vabx(a3);
    ab(a3)=sqrt((vabx(a3))^2+(vaby(a3))^2+(vaby(a3))^2);
    a0=sqrt(va0x^2+va0y^2+va0z^2);
%     angle(a)=acos((vabx(a)*va0x+vaby(a)*va0y+vabz(a)*va0z)/(ab(a)*a0));
    dot0b(a3)=vabx(a3)*va0x+vaby(a3)*va0y+vabz(a3)*va0z;
    normcr0b(a3)=sqrt((cr0bx(a3))^2+(cr0by(a3))^2+(cr0bz(a3))^2);
    angle2(a3)=atan2(normcr0b(a3),dot0b(a3));
    modcm(a3)=(cm_r(R,a3,1)^2+cm_r(R,a3,2)^2+cm_r(R,a3,3)^2);
end
% figure
% scatter(1:size(angle2,2),angle2,600,'.');
% hold on;
angler(replicate,1:size(angle2,2))=angle2;
angleBeg(replicate)=angle2(1);
[idzero]=ind2sub(size(angle2,2),find(angler(replicate,:)>0));
angleEnd(replicate)=angle2(idzero(end));
delTheta(replicate)=angleEnd(replicate)-angleBeg(replicate);

end
    clear cm2 angle2

outputFilename1=sprintf('analysisData/cm_new_Dkp15/gradient/gradient_%d.mat',d);
save(outputFilename1,'delTheta','angleBeg','angleEnd','angler');
% outputFilename2=sprintf('analysisData/msd_1.0Dk14/min_ligand/msd_min_ligand_%d.mat',d);
% save(outputFilename2,'msd2');
clear angleBeg angleEnd delTheta angler 
end

% % % % % % % delete('analysisData/gradient_2000_1.mat');
% % outputFilename=sprintf('analysisData/feedback_gradient_6000_2.mat');
% % save(outputFilename,'delTheta','angleBeg','angleEnd');

