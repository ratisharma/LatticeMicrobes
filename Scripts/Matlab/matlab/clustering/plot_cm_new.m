clear all
% msd_r=[];
% cm_r=zeros(16000,400);
angleBegG=[];
angleEndG=[];
delThetaG=[];
for d=1:80
%     inputFile=sprintf('analysisData/cm_new_feedback_1.0Dkp14/gradient/gradient_%d.mat',d);
    inputFile=sprintf('analysisData/cm_new_feedback_Dkp15/gradient/gradient_%d.mat',d);
    load(inputFile);
    angleBegG=[angleBegG angleBeg];
    angleEndG=[angleEndG angleEnd];
    delThetaG=[delThetaG delTheta];
end


angleBegM=[];
angleEndM=[];
delThetaM=[];
for d=1:80
%     inputFile=sprintf('analysisData/cm_new_feedback_1.0Dkp14/min_ligand/min_ligand_%d.mat',d);
    inputFile=sprintf('analysisData/cm_new_feedback_Dkp15/min_ligand/min_ligand_%d.mat',d);
    load(inputFile);
    angleBegM=[angleBegM angleBeg];
    angleEndM=[angleEndM angleEnd];
    delThetaM=[delThetaM delTheta];
end
% xbins=[0 0.5 1.0 1.5 2.0 2.5 3.0]
xbins=10;
% xbins=[0 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0 2.25 2.5 2.75 3.0]
% dbins=[-3 -2.25 -1.5 -0.75 0 0.75 1.5 2.25 3];
dbins=10;
[Bg,pg]=hist(angleBegG,xbins);
[Bm,pm]=hist(angleBegM,pg);
[Eg,qg]=hist(angleEndG,xbins);
[Em,qm]=hist(angleEndM,qg);
[dg,rg]=hist(delThetaG,dbins);
[dm,rm]=hist(delThetaM,rg);
% histogram(angleBegG,20)
% figure
% plot(pg,Bg./Bm);
% hold on;
% plot(qg,Eg./Em);
subplot(4,2,2)
load('analysisData/cm_new_feedback_Dkp15/gradient/gradient_1.mat');
% load('analysisData/cm_new_feedback_1.0Dkp14/gradient/gradient_1.mat');
endTime=ind2sub(size(angler(20,:),2),find(angler(20,:)>0));
    plot(endTime(1:end),angler(20,endTime(1:end)));
    hold on;
for traj=9:12
    endTime=ind2sub(size(angler(traj,:),2),find(angler(traj,:)>0));
    plot(endTime(1:end),angler(traj,endTime(1:end)));
end
xlabel('time (s)')
ylabel('{\Omega}')
ax=gca;
ax.YTick=[0 pi/2 pi]
title('Dkp15 Model 3')
subplot(4,2,4)
bar(pg,Bg./Bm);
axis([0 3.2 0 2.0])
ax=gca;
ax.XTick=[0 pi/2 pi]
% title('Dk14 Model 2')
ylabel('density')
xlabel('{\Omega}(t=0)')
% hold on;
subplot(4,2,6);
bar(qg,Eg./Em);
axis([0 3.2 0 2.0])
ax=gca;
ax.XTick=[0 pi/2 pi]
xlabel('{\Omega}(t=final)')
ylabel('density')
subplot(4,2,8)
bar(rg,dg)
ax=gca;
ax.XTick=[-pi -pi/2 0 pi/2 pi]
xlabel('{\Delta\Omega}');
ylabel('density')
% ylabel('ratio of gradient to min. ligand')
% legend('initial angle','final angle')

% clear angleBegG angleBegM delThetaG delThetaM angleEndG angleEndM
angleBegG=[];
angleEndG=[];
delThetaG=[];
for d=1:80
%     inputFile=sprintf('analysisData/cm_new_1.0Dkp14/gradient/gradient_%d.mat',d);
    inputFile=sprintf('analysisData/cm_new_Dkp15/gradient/gradient_%d.mat',d);
    load(inputFile);
    angleBegG=[angleBegG angleBeg];
    angleEndG=[angleEndG angleEnd];
    delThetaG=[delThetaG delTheta];
end


angleBegM=[];
angleEndM=[];
delThetaM=[];
for d=1:80
%     inputFile=sprintf('analysisData/cm_new_1.0Dkp14/min_ligand/min_ligand_%d.mat',d);
    inputFile=sprintf('analysisData/cm_new_Dkp15/min_ligand/min_ligand_%d.mat',d);
    load(inputFile);
    angleBegM=[angleBegM angleBeg];
    angleEndM=[angleEndM angleEnd];
    delThetaM=[delThetaM delTheta];
end

[Bg,pg]=hist(angleBegG,xbins)
[Bm,pm]=hist(angleBegM,pg);
[Eg,qg]=hist(angleEndG,xbins);
[Em,qm]=hist(angleEndM,qg);
[dg,rg]=hist(delThetaG,dbins);
[dm,rm]=hist(delThetaM,rg);

% figure
h1=subplot(4,2,1)
load('analysisData/cm_new_Dkp15/gradient/gradient_1.mat');
% load('analysisData/cm_new_1.0Dkp14/gradient/gradient_1.mat');
endTime=ind2sub(size(angler(1,:),2),find(angler(1,:)>0));
    plot(1:endTime(end),angler(1,1:endTime(end)));
    hold on;
for traj=2:5
    endTime=ind2sub(size(angler(traj,:),2),find(angler(traj,:)>0));
    plot(1:endTime(end),angler(traj,1:endTime(end)));
%     hold on;
end
% hold off;
ax=gca;
ax.YTick=[0 pi/2 pi];
xlabel('time (s)')
ylabel('{\Omega}')
title('Dkp15 Model 2')
subplot(4,2,3)
bar(pg,Bg./Bm);
axis([0 3.2 0 2.0])
ax=gca;
ax.XTick=[0 pi/2 pi];
xlabel('{\Omega}(t=0)')
ylabel('density')
% title('Dk15 Model 2')
% hold on;
subplot(4,2,5)
bar(qg,Eg./Em);
axis([0 3.2 0 2.0])
ax=gca;
ax.XTick=[0 pi/2 pi];
ylabel('density')
xlabel('{\Omega}(t=final)')
subplot(4,2,7)
bar(rg,dg);
ax=gca;
ax.XTick=[-pi -pi/2 0 pi/2 pi];
xlabel('{\Delta\Omega}');
ylabel('density')
% ylabel('ratio of gradient to min. ligand')
% title('model2')
% legend('initial angle','final angle')
% % % histogram(Bg*100./Bm,20);
% % % hold on;
% % % histogram(Eg*100./Em,20);
% ubeg=unique(angleBegM);
% plot(rg,dg./dm)
% [a]=ind2sub(size(angleEndG),find(angleEndG<0.1))
