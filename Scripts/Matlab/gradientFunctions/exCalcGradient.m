clear all

D=320; % Diffusion coefficient (units:{\mu}m^2/s)
length=12; % length, width or height of volume (units: {\mu}m)
rateProd=865; % rate of production of molecules at the source (units: molecules/s)
tf=1; % final time upto which the concentration gardient needs to be calculated (units: s)
N=24; % number of sub lattices in the diffusion volume
dsrc=5; % distance from the source cell (units: {\mu}m)
dcell=5; % diameter of simulation cell (units: {\mu}m)
scale=20; % scaling factor
completeGradFile='test_complete.h5';
selectedGradFile='test.h5';
scaledGradFile='scaled_test.h5';
[completeGradFile,selectedGradFile,scaledGradFile]=calcGradient(D,length,rateProd,tf,N,dsrc,dcell,scale,completeGradFile,selectedGradFile,scaledGradFile);
