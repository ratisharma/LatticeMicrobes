clear all
% msd_r=[];
% cm_r=zeros(16000,400);
angleBegG=[];
angleEndG=[];
delThetaG=[];
for d=1:40
    inputFile=sprintf('analysisData/cm_Dk13/gradient/gradient_%d.mat',d);
    load(inputFile);
    angleBegG=[angleBegG angleBeg];
    angleEndG=[angleEndG angleEnd];
    delThetaG=[delThetaG delTheta];
end
% for d=38:61
%     inputFile=sprintf('analysisData/cm/feedback_gradient_%d.mat',d);
%     load(inputFile);
%     angleBegG=[angleBegG angleBeg];
%     angleEndG=[angleEndG angleEnd];
%     delThetaG=[delThetaG delTheta];
% end
% % histogram(angleBegR)


angleBegM=[];
angleEndM=[];
delThetaM=[];
for d=1:40
    inputFile=sprintf('analysisData/cm_Dk13/min_ligand/min_ligand_%d.mat',d);
    load(inputFile);
    angleBegM=[angleBegM angleBeg];
    angleEndM=[angleEndM angleEnd];
    delThetaM=[delThetaM delTheta];
end

[Bg,pg]=hist(angleBegG,10);
[Bm,pm]=hist(angleBegM,10);
[Eg,qg]=hist(angleEndG,10);
[Em,qm]=hist(angleEndM,10);
[dg,rg]=hist(delThetaG,10);
[dm,rm]=hist(delThetaM,10);
% histogram(angleBegG,20)
% figure
% plot(pg,Bg./Bm);
% hold on;
% plot(qg,Eg./Em);
subplot(3,2,2)
bar(pg,Bg./Bm);
axis([0 3 0.8 1.4])
title('Dk13 Model 3')
ylabel('density')
xlabel('omega(t=0)')
% hold on;
subplot(3,2,4);
bar(qg,Eg./Em);
axis([0 3 0.8 1.5])
xlabel('omega(t=final)')
ylabel('density')
subplot(3,2,6)
bar(rg,dg)
xlabel('del omega');
ylabel('density')
% ylabel('ratio of gradient to min. ligand')
% legend('initial angle','final angle')

% clear angleBegG angleBegM delThetaG delThetaM angleEndG angleEndM
angleBegG=[];
angleEndG=[];
delThetaG=[];
    inputFile=sprintf('analysisData/gradient_8000_4.mat');
    load(inputFile);
    angleBegG1=angleBeg;
    angleEndG1=angleEnd;
    delThetaG1=delTheta;
%     clear angleBeg angleEnd delTheta
    inputFile=sprintf('analysisData/gradient_4000_3.mat');
    load(inputFile);
    angleBegG2=angleBeg;
    angleEndG2=angleEnd;
    delThetaG2=delTheta;
    clear angleBeg angleEnd delTheta
    inputFile=sprintf('analysisData/gradient_2000_1.mat');
    load(inputFile);
    angleBegG3=angleBeg;
    angleEndG3=angleEnd;
    delThetaG3=delTheta;
    clear angleBeg angleEnd delTheta
    inputFile=sprintf('analysisData/gradient_2000_2.mat');
    load(inputFile);
    angleBegG4=angleBeg;
    angleEndG4=angleEnd;
    delThetaG4=delTheta;
%     angleBegG=[angleBegG2 angleBegG3 angleBegG4];
%     angleEndG=[angleEndG2 angleEndG3 angleEndG4];
%     delThetaG=[delThetaG2 delThetaG3 delThetaG4];
        angleBegG=[angleBegG1 angleBegG2 angleBegG3 angleBegG4];
    angleEndG=[angleEndG1 angleEndG2 angleEndG3 angleEndG4];
    delThetaG=[delThetaG1 delThetaG2 delThetaG3 delThetaG4];
% angleBegG=[angleBegG1];
%     angleEndG=[angleEndG1];
%     delThetaG=[delThetaG1];    
    
angleBegM=[];
angleEndM=[];
delThetaM=[];
for d=1:80
    inputFile=sprintf('analysisData/cm/min_ligand_%d.mat',d);
    load(inputFile);
    angleBegM=[angleBegM angleBeg];
    angleEndM=[angleEndM angleEnd];
    delThetaM=[delThetaM delTheta];
end
% for d=28:61
%     inputFile=sprintf('analysisData/cm/min_ligand_%d.mat',d);
%     load(inputFile);
%     angleBegM=[angleBegM angleBeg];
%     angleEndM=[angleEndM angleEnd];
%     delThetaM=[delThetaM delTheta];
% end
[Bg,pg]=hist(angleBegG,10);
[Bm,pm]=hist(angleBegM,10);
[Eg,qg]=hist(angleEndG,10);
[Em,qm]=hist(angleEndM,10);
[dg,rg]=hist(delThetaG,10);
[dm,rm]=hist(delThetaM,10);
% figure
subplot(3,2,1)
bar(pg,Bg./Bm);
axis([0 3 0.8 1.4])
xlabel('omega(t=0)')
ylabel('density')
title('Dk15 Model 2')
% hold on;
subplot(3,2,3)
bar(qg,Eg./Em);
axis([0 3 0.8 1.4])
ylabel('density')
xlabel('omega(t=final)')
subplot(3,2,5)
bar(rg,dg);
xlabel('del omega');
ylabel('density')
% ylabel('ratio of gradient to min. ligand')
% title('model2')
% legend('initial angle','final angle')
% % % histogram(Bg*100./Bm,20);
% % % hold on;
% % % histogram(Eg*100./Em,20);
% ubeg=unique(angleBegM);
% plot(rg,dg./dm)
