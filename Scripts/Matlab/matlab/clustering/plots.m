clear all

load('analysisData/gradient_2000_1.mat');
figure
% subplot(1,2,1)
% [N1,a1]=hist(delTheta,20)
a1=delTheta;
b1=angleBeg;
c1=angleEnd;
load('analysisData/gradient_2000_1.mat');
a2=delTheta;
b2=angleBeg;
c2=angleEnd;
load('analysisData/gradient_4000_3.mat');
a3=delTheta;
b3=angleBeg;
c3=angleEnd;
load('analysisData/gradient_8000_4.mat');
a4=delTheta;
b4=angleBeg;
c4=angleEnd;
a=[a1,a2,a3,a4];
b=[b1,b2,b3,b4];
c=[c1,c2,c3,c4];
hist(a./16000,25)
figure
hist(b./16000,25)
figure
hist(c./16000,25)
% h1=histogram(delTheta,25)
% hold on;
% load('analysisData/angle2_min_ligand.mat');
% h2=histogram(delTheta,20)
% title('gradient');
% xlabel('deltheta');
% ylabel('p(delTheta)');
% legend('gradient','constant')
% load('analysisData/feedback_gradient_2000.mat');
% % subplot(1,2,2)
% [N2,a2]=hist(delTheta,20)
% h3=histogram(delTheta,50)
% hold on;
% load('analysisData/feedback_angle2_min_ligand_2000.mat');
% h4=histogram(delTheta,25);
% title('gradient with feedback in 2 steps');
% xlabel('deltheta');
% ylabel('p(delTheta)');
% legend('gradient','constant')
% figure
% plot(a1,N1);
% hold;
% plot(a2,N2);
% load('analysisData/gradient_2000_1.mat');
% figure
% % subplot(1,2,1)
% h1=histogram(angleBeg,25)
% hold on;
% % load('analysisData/angle2_min_ligand.mat');
% % h2=histogram(angleBeg,20)
% % title('gradient');
% % xlabel('initial angle');
% % ylabel('p(initial angle)');
% % legend('gradient','constant')
load('analysisData/feedback_gradient_2000.mat');
% subplot(1,2,2)
figure
hist(angleBeg,25)
% h3=histogram(angleBeg,25)
% hold on;
% load('analysisData/feedback_angle2_min_ligand_2000.mat');
% h4=histogram(angleBeg,50);
% title('feedback in 2 steps');
% xlabel('initial angle');
% ylabel('p(initial angle)');
% legend('gradient','constant')


