function [completeGradFile,selectedGradFile,scaledGradFile]=calcGradient(D,length,rateProd,tf,N,dsrc,dcell,scale,completeGradFile,selectedGradFile,scaledGradFile)
%% This script calculates the concentration of a diffusing species (the
%%% ligand) within a lattice. The setup is as follows: The source produces
%%% the ligand at a constant rate of production. The ligand molecules then
%%% diffuse away from the source into the medium. We select out a portion
%%% of this diffusing volume and assume that this is the cell that needs to
%%% be simulated via lattice microbes. The concentrations are calculated by
%%% solving the diffusion equation with appropriate boundary conditions via
%%% the Finite difference method, as laid out in the script. (See
%%% GradientSensingPaper by Rati Sharma and Elijah Roberts for the details
%%% of the initial and boundary conditions.) The calculation itself is done
%%% via the script "gradient_3D.m". The selection of only the simulation
%%% volume is done via the script "gradient_selected.m". Once the
%%% concentrations of the ligand at the boundaries of the simulation cell
%%% are calculated, they have to be scaled up to the desired number of
%%% subvolumes. This is done via the script "scaling_gradient.m". The final
%%% concentrations obtained are in (moles/Litre)M.

%% Following are the input arguments:
% D; % Diffusion coefficient (units:{\mu}m^2/s)
% length; % length, width or height of volume (units: {\mu}m)
% rateProd; % rate of production of molecules at the source (units: molecules/s)
% tf; % final time upto which the concentration gardient needs to be calculated (units: s)
% N; % Number of lattice spaces in each coordinate
% nxsteps=N; % Number of lattice spaces in x direction
% nysteps=N; % Number of lattice spaces in y direction 
% nzsteps=N; % Number of lattice spaces in z direction
% dsrc; % diameter of source cell (units: {\mu}m)
% dcell; % diameter of simulation cell (units: {\mu}m)
% scale; % scaling factor
% completeGradFile='test_complete.h5';
% selectedGradFile='test.h5';
% scaledGradFile='scaled_test.h5';

%% Calculation proceeds:

if (dsrc+dcell+2>length)
    error('length should be greater than dsrc+dcell+2.')
end
[q,r]=quorem(sym(N),2*length);
if ((q<1)||(r~=0))
    error('N should be at least 2 times that of length and 2*length/N should give remainder zero.')
end
nxsteps=N; % Number of lattice spaces in x direction
nysteps=N; % Number of lattice spaces in y direction 
nzsteps=N; % Number of lattice spaces in z direction
[u,nx,ny,nz,dx]=gradient_3D(D,nxsteps,nysteps,nzsteps,length,rateProd,tf)
delete(completeGradFile);
h5create(completeGradFile, '/dataset1', size(permute(u,[3,2,1])));
h5write(completeGradFile, '/dataset1', permute(u,[3,2,1]));

[u2]=gradient_selected(u,dsrc,dcell,nx,ny,nz,dx)
% contourf(l2,m2,u2(:,:,3));

delete(selectedGradFile);
h5create(selectedGradFile, '/dataset1', size(permute(u2,[3,2,1])));
h5write(selectedGradFile, '/dataset1', permute(u2,[3,2,1]));

filename=selectedGradFile; % file to be scaled
[c3]=scaling_gradient(dx,scale,filename)

delete(scaledGradFile);
h5create(scaledGradFile, '/dataset1', size(permute(c3,[3,2,1])));
h5write(scaledGradFile, '/dataset1', permute(c3,[3,2,1]));
completeGradFile;
selectedGradFile;
scaledGradFile;