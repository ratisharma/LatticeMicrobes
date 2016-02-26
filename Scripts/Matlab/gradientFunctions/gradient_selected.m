function [u2]=gradient_selected(u,dsrc,dcell,nx,ny,nz,dx)

xsource=(nx-1)/2+1; % x position of source
ysource=(ny-1)/2+1; % y position of source
zsource=(nz-1)/2+1; % z position of source

dms=dsrc/dx;  %diameter of a source cell/dx
dm=dcell/dx; %diameter of a cell/dx
xdist=xsource+(dms); % distance from source in the x direction
ydist=ysource+(dms); % distance from source in the y direction
zdist=zsource+(dms); % distance from source in the z direction


l1=xdist:xdist+(dm+1);
m1=ydist:ydist+(dm+1);
n1=zdist:zdist+(dm+1);

l2=1:(dm+2);
m2=1:(dm+2);
n2=1:(dm+2);
u2(l2,m2,n2)=u(l1,m1,n1);
u2;