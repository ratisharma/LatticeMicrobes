clear all
switchTimes=[];
for d=1
% filename=sprintf('../../feedback_kp/data_Dkp15_Drl15_memThick2/gradient/c7_4.0e-6/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_c7_4.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm',d);
% filename=sprintf('../../data/data_1.0Dkp14_Drl14_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_%d_c1b_0.6e-5_c2b_1.2e-5_c3b_1.5e-3_c0a_4.0e-3_c4_7.1e-3_c5_6.0e-3_c6_4.3e-5_Dk_5.0e-12_Dkp_1.0e-14_Dr_5.0e-12_Drl_1.0e-14.lm',d);
filename=sprintf('../../data/data_Dkp15_Drl15_memThick2/gradient/cell_rdme_Lmem_gradSteep_t500_1_c1b_0.5e-5_c2b_1.0e-5_c3b_1.0e-3_c0a_4.0e-3_c4_7.0e-3_c5_5.0e-3_c6_4.0e-5_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm');
cutoffDistance=25;
% msd2=zeros(20,200);
% rep=[4,33];
filenumber=d
for replicate1=1:200
    replicate=replicate1;
    ts=cast(permute(hdf5read(filename,...
    sprintf('/Simulations/%07d/SpeciesCountTimes',replicate)),[2,1]),'double');
    counts=cast(permute(hdf5read(filename,...
    sprintf('/Simulations/%07d/SpeciesCounts',replicate)),[2,1]),'double');
    [onzeros]=switchTime_OnToOff(filename,replicate);
    switchTimes=[switchTimes onzeros];
    
clear msd cm2
end
end

figure
hist(switchTimes)
subplot(121)
h1 = histfit(switchTimes,20,'exponential');
title('small volume') 
xlabel('switching times');ylabel('counts');
para1 = fitdist(switchTimes','exponential')
hold on;
x=1:1:250;
y=703*exp(-(1/23.152)*x);
plot(x,y,'b')

subplot(122)
matfile = sprintf('repSwitchTimes_volFull_sp2.mat');
load(matfile)
h2 = histfit(repSwitchTimes,20,'exponential');
title('large volume') 
xlabel('switching times');ylabel('counts');
para2 = fitdist(repSwitchTimes,'exponential')
hold on;
x=1:1:2500;
y=86.71*exp(-(1/179.385)*x);
plot(x,y,'b')



