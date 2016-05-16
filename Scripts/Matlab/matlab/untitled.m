clear all
% c1=0:0.001:0.2;
% c2=0:0.0025:0.5;
% y=zeros(size(c1,1),size(c2,2));
% y=importdata('biRegion.txt');
% contourf(c1,c2,y')

% lt=0:0.1:2;
% y=importdata('monostable.txt');
% plot(y(:,1),y(:,2))
% axis([0 2 0 1])

c1=0:0.001:0.2;
c2=0:0.0025:0.5;
y1=zeros(size(c1,1),size(c2,2));
y1=importdata('biRegionNoLigand.txt');
figure
caxis([min(min(y1)) max(max(y1))]);
% map = [0.9, 0.9, 0.9
%     1.0, 1.0, 1.0];
% subplot(1,2,1)
contour(c1,c2,y1');
xlabel('c_1'); ylabel('c_2');
title('Bistable region without ligand')
% colormap(map)

hold on
% c1=0:0.001:0.2;
% c2=0:0.0025:0.5;
y2=zeros(size(c1,1),size(c2,2));
y2=importdata('biRegion_feedback.txt');
% y2=importdata('biRegion.txt');
% map = [0.0, 0.0, 0.0
%     1.0, 1.0, 1.0];
% subplot(1,2,2)
contour(c1,c2,y2');
xlabel('c_1'); ylabel('c_2');
title('Bistable region with ligand')
% 
% colormap(map)
% axis([0 0.2 0 0.5]);
% ax=gca;
% ax.XTick=[0 0.05 0.1 0.15 0.2];
% ax.YTick=[0 0.1 0.2 0.3 0.4 0.5];
% hold off
% xlabel('c_1'); ylabel('c_2');