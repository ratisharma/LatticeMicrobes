clear all
% msd_r=[];
% cm_r=zeros(16000,400);
angleBegG=[];
angleEndG=[];
delThetaG=[];
delThetaM=[];
delThetaGFirst=[];
delThetaGSecond=[];
delThetaMFirst=[];
delThetaMSecond=[];
for d=1:80
%     inputFile=sprintf('analysisData/cm_new_1.0Dkp14/gradient/gradient_%d.mat',d);
    inputFile=sprintf('analysisData/cm_new_Dkp15/gradient/gradient_%d.mat',d);
    load(inputFile);
    for replicate=1:200
        delThetaG=[delThetaG delTheta(replicate)];
        if angleBeg(replicate)<1.5708
            delThetaGFirst=[delThetaGFirst delTheta(replicate)];
        elseif angleBeg(replicate)>=1.5708
            delThetaGSecond=[delThetaGSecond delTheta(replicate)];
        end
    end
end
for d=1:80
%     inputFile=sprintf('analysisData/cm_new_1.0Dkp14/gradient/gradient_%d.mat',d);
    inputFile=sprintf('analysisData/cm_new_Dkp15/min_ligand/min_ligand_%d.mat',d);
    load(inputFile);
    for replicate=1:200
        delThetaM=[delThetaM delTheta(replicate)];
        if angleBeg(replicate)<1.5708
            delThetaMFirst=[delThetaMFirst delTheta(replicate)];
        elseif angleBeg(replicate)>=1.5708
            delThetaMSecond=[delThetaMSecond delTheta(replicate)];
        end
    end
end

dbins=-pi:2*pi/10:pi;
[dg,rg]=hist(delThetaG,dbins);
[dgFirst,rgFirst]=hist(delThetaGFirst,dbins);
[dgSecond,rgSecond]=hist(delThetaGSecond,dbins);
[dm,rm]=hist(delThetaM,rg);
[dmFirst,rmFirst]=hist(delThetaMFirst,rgFirst);
[dmSecond,rmSecond]=hist(delThetaMSecond,rgSecond);
% subplot(2,2,1)
% bar(rgFirst,dgFirst-dmFirst)
% ax=gca;
% axis([-3.2 3.2 -600 600]);
% ax.XTick=[-pi -pi/2 0 pi/2 pi]
% xlabel('{\Delta\Omega}');
% ylabel('density')
% title('Model II first half')
% subplot(2,2,2)
% bar(rgSecond,dgSecond-dmSecond)
% ax=gca;
% axis([-3.2 3.2 -600 600]);
% ax.XTick=[-pi -pi/2 0 pi/2 pi]
% xlabel('{\Delta\Omega}');
% ylabel('density')
% title('Model II second half')
% subplot(2,3,3)
subplot(1,2,1)
bar(rg,dg-dm)
ax=gca;
axis([-3.2 3.2 -400 400]);
ax.XTick=[-pi -pi/2 0 pi/2 pi]
xlabel('{\Delta\Omega}');
ylabel('density')
title('Model II full')

clear dgFirst rgFirst dgSecond rgSecond dmFirst rmFirst dmSecond rmSecond dg rg dm rm 


angleBegG=[];
angleEndG=[];
delThetaG=[];
delThetaM=[];
delThetaGFirst=[];
delThetaGSecond=[];
delThetaMFirst=[];
delThetaMSecond=[];

for d=1:80
%     inputFile=sprintf('analysisData/cm_new_feedback_1.0Dkp14/gradient/gradient_%d.mat',d);
    inputFile=sprintf('analysisData/cm_new_feedback_Dkp15/gradient/gradient_%d.mat',d);
    load(inputFile);
    for replicate=1:200
        delThetaG=[delThetaG delTheta(replicate)];
        if angleBeg(replicate)<1.5708
            delThetaGFirst=[delThetaGFirst delTheta(replicate)];
        elseif angleBeg(replicate)>=1.5708
            delThetaGSecond=[delThetaGSecond delTheta(replicate)];
        end
    end
end

for d=1:80
%     inputFile=sprintf('analysisData/cm_new_feedback_1.0Dkp14/gradient/gradient_%d.mat',d);
    inputFile=sprintf('analysisData/cm_new_feedback_Dkp15/min_ligand/min_ligand_%d.mat',d);
    load(inputFile);
    for replicate=1:200
        delThetaM=[delThetaM delTheta(replicate)];
        if angleBeg(replicate)<1.5708
            delThetaMFirst=[delThetaMFirst delTheta(replicate)];
        elseif angleBeg(replicate)>=1.5708
            delThetaMSecond=[delThetaMSecond delTheta(replicate)];
        end
    end
end

dbins=-pi:2*pi/10:pi;
[dg,rg]=hist(delThetaG,dbins);
[dgFirst,rgFirst]=hist(delThetaGFirst,dbins);
[dgSecond,rgSecond]=hist(delThetaGSecond,dbins);
[dm,rm]=hist(delThetaM,rg);
[dmFirst,rmFirst]=hist(delThetaMFirst,rgFirst);
[dmSecond,rmSecond]=hist(delThetaMSecond,rgSecond);
% subplot(2,2,3)
% bar(rgFirst,dgFirst-dmFirst)
% ax=gca;
% axis([-3.2 3.2 -600 600]);
% ax.XTick=[-pi -pi/2 0 pi/2 pi]
% xlabel('{\Delta\Omega}');
% ylabel('density')
% title('Model III first half')
% subplot(2,2,4)
% bar(rgSecond,dgSecond-dmSecond)
% ax=gca;
% axis([-3.2 3.2 -600 600]);
% ax.XTick=[-pi -pi/2 0 pi/2 pi]
% xlabel('{\Delta\Omega}');
% ylabel('density')
% title('Model III second half')
% subplot(2,3,6)
subplot(1,2,2)
bar(rg,dg-dm)
ax=gca;
axis([-3.2 3.2 -400 400]);
ax.XTick=[-pi -pi/2 0 pi/2 pi]
xlabel('{\Delta\Omega}');
ylabel('density')
title('Model III full')

