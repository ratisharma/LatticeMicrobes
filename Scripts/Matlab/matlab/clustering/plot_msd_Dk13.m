clear all
% msd_r=[];
msd_r=zeros(16000,200);
for d=1:40
    inputFile=sprintf('analysisData/msd_Dk13/gradient/msd_gradient_%d.mat',d);
    load(inputFile);
    for replicate=1:400
        R=400*(d-1)+replicate;
        msd_r(R,1:size(msd2,2))=msd2(replicate,1:size(msd2,2));
    end
%     clear msd2
end

for j=1:size(msd_r,2)
%     scatter(1:200,msd2(j,:),50,'.');
    [idx]=ind2sub(size(msd_r(:,j)),find(msd_r(:,j)>0));
    
    meanMSD(j)=sum(msd_r(:,j),1)./size(idx,1);
end
for k=1:400
    scatter(1:size(msd_r,2),msd_r(k,:),50,'.');
    hold on;
end
plot(1:size(msd_r,2),meanMSD,'b')
xlabel('time');
ylabel('Mean square displacement');
