clear all

% data=permute(hdf5read('3D_diff_alpha.h5','/dataset1'),[3,2,1]);
data=permute(hdf5read('../scripts/scaled_test_D50_rateProd865_dilFac46_distSrc0.5.h5','/dataset1'),[3,2,1]);

data2=data(2:51,2:51,2:51);
nx=size(data2,1);
ny=size(data2,2);
nz=size(data2,3);
ni=5
for i=[1:ni]
y(i)=data2(10*(i-1)+1,10*(i-1)+1,10*(i-1)+1);
end
x=1:5
% plot(x*0.5,y(1:5))
% hold on;
% load('E_alpha_time1_rep_100_div5volumes.mat');

load('E_mean_alpha_D50.mat');
% load('StdDev_alpha_D50.mat');
load('V_var_alpha_D50.mat');
ts=1:size(E,2);
i=1:5;
for ti=[1:size(ts,2)]
StdDev(i,ti)=V(i,ti).^0.5;
end
figure
 plot(ts(1:end), E(1,1:end));
hold on;
plot(ts(2:end),V(1,2:end),'-k');
for i=[2:ni]
plot(ts(1:end), E(i,1:end),'m');
% plot(ts(2:end),StdDev(i,2:end),'-k');
plot(ts(2:end),V(i,2:end),'-k');
end
% load('E_alpha_time10_rep_100_div5volumes_rateProd865_D50_dsrc1.mat');
meanE=mean(E(1:5,5:end),2)./(1.25*6.023e+7)
% load('StdDev_alpha_D50.mat');
% StdD=zeros(ni,1);
% for i=1:ni
%     for j=2:101
%     StdD(i)=StdD(i)+sqrt((E(i,j)-meanE(i,1))^2)./10;
%     end
%     SEM(i)=StdD(i)./(10*1.25*6.023e+7);
% end
    
meanStdDev=mean(StdDev(1:5,5:end),2)./(10*1.25*6.023e+7)
% load('V_var_alpha_D50.mat');
meanV=mean(V(1:5,5:end),2)
% meanStdDev=sqrt(meanV)./(1.25*6.023e+7)
% xsim=meanE(2:2:10);
% plot(1:5,xsim./sum(xsim),'k')
% plot(x*0.5,meanE,'k')
figure
plot(x*0.5,y(1:5),'k--')
hold on;
errorbar(x*0.5,E(:,101)./(1.25*6.023e+7),StdDev(:,101)./(sqrt(3000)*1.25*6.023e+7),'*')
% errorbar(x*0.5,meanE,meanStdDev,'*--')
% errorbar(x*0.5,meanE,SEM)
xlabel('x along diagonal({\mu}m)');
ylabel('concentration of ligand (M)');
% x./sum(x)
% meanE./sum(meanE)