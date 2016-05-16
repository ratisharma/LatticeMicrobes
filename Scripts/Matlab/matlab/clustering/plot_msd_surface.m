clear all
% msd_r=[];

msd_r=zeros(16000,400);
for d=1:80
    inputFile=sprintf('analysisData/msd_surface_new_Dkp15/gradient/msd_cm_surface_new_gradient_%d.mat',d);
%     inputFile=sprintf('analysisData/msd_surface_new_1.0Dkp14/gradient/msd_cm_surface_new_gradient_%d.mat',d);
%     inputFile=sprintf('analysisData/msd_surface_new_feedback_1.0Dkp14/gradient/msd_cm_surface_new_gradient_%d.mat',d);
    load(inputFile);
    for replicate=1:200
        R=200*(d-1)+replicate;
        msd_r(R,1:size(msd2,2))=msd2(replicate,1:size(msd2,2));
    end
%     clear msd2
end
subplot(1,2,1)
for j=1:size(msd_r,2)
%     scatter(1:200,msd2(j,:),50,'.');
    [idx]=ind2sub(size(msd_r(:,j)),find(msd_r(:,j)>0));
    
    meanMSD(j)=sum(msd_r(:,j),1)./size(idx,1);
end
for k=501:600
    scatter(1:size(msd_r,2),msd_r(k,:).*0.0025,50,0.5*[1 1 1],'.');
    hold on;
end
plot(1:size(meanMSD,2),meanMSD(1:end).*0.0025,'b')
xlabel('time');
ylabel('Mean square displacement');

msd_r=zeros(16000,400);
for d=1:80
    inputFile=sprintf('analysisData/msd_surface_new_feedback_Dkp15/gradient/msd_cm_surface_feedback_gradient_%d.mat',d);
%     inputFile=sprintf('analysisData/msd_surface_new_1.0Dkp14/gradient/msd_cm_surface_new_gradient_%d.mat',d);
%     inputFile=sprintf('analysisData/msd_surface_new_feedback_1.0Dkp14/gradient/msd_cm_surface_new_gradient_%d.mat',d);
    load(inputFile);
    for replicate=1:200
        R=200*(d-1)+replicate;
        msd_r(R,1:size(msd2,2))=msd2(replicate,1:size(msd2,2));
    end
%     clear msd2
end
subplot(1,2,2)
for j=1:size(msd_r,2)
%     scatter(1:200,msd2(j,:),50,'.');
    [idx]=ind2sub(size(msd_r(:,j)),find(msd_r(:,j)>0));
    
    meanMSD(j)=sum(msd_r(:,j),1)./size(idx,1);
end
for k=501:600
    scatter(1:size(msd_r,2),msd_r(k,:).*0.0025,50,0.5*[1 1 1],'.');
    hold on;
end

plot(1:size(meanMSD,2),meanMSD(1:end).*0.0025,'b')
xlabel('time');
ylabel('Mean square displacement');

