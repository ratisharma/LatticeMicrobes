function [u,nx,ny,nz,dx]=gradient_3D(D,nxsteps,nysteps,nzsteps,length,rateProd,tf)
% Simulating the 3-D Diffusion equation by the Finite Difference
...Method 
% Numerical scheme used is a first order upwind in time and a second
...order central difference in space (Implicit and Explicit)
    
if nargin ~= 7
    error('myApp:argChk', 'Wrong number of input arguments')
end

nx=nxsteps+1;
ny=nysteps+1;
nz=nzsteps+1;
dx=2*length/(nx-1);                     %Width of space step(x)
dy=2*length/(ny-1);                     %Width of space step(y)
dz=2*length/(nz-1);
dt = (0.25*(dx*dy*dz)^2)/(D*(dx^4+dy^4+dz^4));            %Width of each time step


nt=1+tf/dt;                          %Number of time steps 
beta=D*dt/(dx^2+dy^2); %Stability criterion (0<=beta<=0.5, for explicit)
x=-length:dx:length;                        %Range of x(0,2) and specifying the grid points (20 mim)
y=-length:dy:length;                       %Range of y(0,2) and specifying the grid points
z=-length:dz:length;

u=zeros(nx,ny,nz);                  %Preallocating u
un=zeros(nx,ny,nz);                 %Preallocating un
unvx=zeros(1,ny,nz);
unvy=zeros(nx,1,nz);
unvz=zeros(nx,ny,1);
unvxl=zeros(1,ny,nz);
unvys=zeros(nx,1,nz);
unvzs=zeros(nx,ny,1);
grad=zeros(nx,1);

area=6*dx^2                      % area (units: ${\mu}m^2)
J=rateProd/area                 % Flux (units: molecules/(${\mu}m^2s))

UW=0;                            %x=0 Dirichlet B.C 
UE=0;                            %x=L Dirichlet B.C 
US=0;                            %y=0 Dirichlet B.C 
UN=0;                            %y=L Dirichlet B.C 
UnW=J;                           %x=0 Neumann B.C (du/dn=UnW)
UnE=J;                           %x=L Neumann B.C (du/dn=UnE)
UnS=J;                           %y=0 Neumann B.C (du/dn=UnS)
UnN=J;                           %y=L Neumann B.C (du/dn=UnN)
UnZup=J;                         %z=L Neumann B.C 
UnZdwn=J;                        %z=0 Neumann B.C 

%%
%Initial Conditions
for i=1:nx
    for j=1:ny
        for k=1:nz
            u(i,j)=0;
        end
    end
end

% (nx-1)*dx
%%
% %Calculating the field variable for each time step
% i=2:nx-1;
% j=2:ny-1;
nt=1+tf/dt;

    
for it=0:nt
    i=2:nx-1;
    j=2:ny-1;
    k=2:nz-1;
    un=u;

%     Explicit method:
%     {

u(i,j,k)=un(i,j,k)+(D*dt*(un(i+1,j,k)-2*un(i,j,k)+un(i-1,j,k))/(dx*dx))+(D*dt*(un(i,j+1,k)-2*un(i,j,k)+un(i,j-1,k))/(dy*dy))+(D*dt*(un(i,j,k+1)-2*un(i,j,k)+un(i,j,k-1))/(dz*dz));

%     Boundary conditions
%     %Neumann:
% un(i,j)
un(nx,ny);
un(nx-1,ny);

 
u((nx-1)/2+1,(ny-1)/2+1,(nz-1)/2+1)=u((nx-1)/2,(ny-1)/2+1,(nz-1)/2+1)+UnW*dx;
u((nx-1)/2+1,(ny-1)/2+1,(nz-1)/2+1)=u((nx-1)/2+1,(ny-1)/2,(nz-1)/2+1)+UnS*dy;
u((nx-1)/2+1,(ny-1)/2+1,(nz-1)/2+1)=u((nx-1)/2+1,(ny-1)/2+1,(nz-1)/2)+UnZdwn*dz;
u((nx-1)/2+1,(ny-1)/2+1,(nz-1)/2+1)=u((nx-1)/2+2,(ny-1)/2+1,(nz-1)/2+1)+UnE*dx;
u((nx-1)/2+1,(ny-1)/2+1,(nz-1)/2+1)=u((nx-1)/2+1,(ny-1)/2+2,(nz-1)/2+1)+UnN*dy;
u((nx-1)/2+1,(ny-1)/2+1,(nz-1)/2+1)=u((nx-1)/2+1,(ny-1)/2+1,(nz-1)/2+2)+UnZup*dz;


p1=1:nx;
q1=2:ny-1;
r1=2:nz-1;
if un(p1,1,2)>0
unvxl(p1,1,1)=(un(p1,1,1).*un(p1,1,1))./un(p1,1,2);
        
        u(p1,1,1)=un(p1,1,1)+(D*dt*(unvxl(p1,1,1)-2*un(p1,1,1)+un(p1,1,2))/(dx*dx));
end

if un(p1,ny,2)>0
unvxl(p1,ny,1)=(un(p1,ny,1).*un(p1,ny,1))./un(p1,ny,2);
        
        u(p1,ny,1)=un(p1,ny,1)+(D*dt*(unvxl(p1,ny,1)-2*un(p1,ny,1)+un(p1,ny,2))/(dx*dx));
end

if un(p1,1,nz-1)>0
unvxl(p1,1,nz)=(un(p1,1,nz).*un(p1,1,nz))./un(p1,1,nz-1);
        
        u(p1,1,nz)=un(p1,1,nz)+(D*dt*(unvxl(p1,1,nz)-2*un(p1,1,nz)+un(p1,1,nz-1))/(dx*dx));
end

if un(p1,ny,nz-1)>0
unvxl(p1,ny,nz)=(un(p1,ny,nz).*un(p1,ny,nz))./un(p1,ny,nz-1);
        
        u(p1,ny,nz)=un(p1,ny,nz)+(D*dt*(unvxl(p1,ny,nz)-2*un(p1,ny,nz)+un(p1,ny,nz-1))/(dx*dx));
end

if un(2,q1,r1)>0 
        unvxl(1,q1,r1)=(un(1,q1,r1).*un(1,q1,r1))./un(2,q1,r1);
        
        u(1,q1,r1)=un(1,q1,r1)+(D*dt*(unvxl(1,q1,r1)-2*un(1,q1,r1)+un(2,q1,r1))/(dx*dx));
end
       
   
   if un(p1,2,r1)>0
            unvys(p1,1,r1)=(un(p1,1,r1).*un(p1,1,r1))./un(p1,2,r1);
            u(p1,1,r1)=un(p1,1,r1)+(D*dt*(unvys(p1,1,r1)-2*un(p1,1,r1)+un(p1,2,r1))/(dy*dy));
        
   end
    
    if un(p1,q1,2)>0
            unvzs(p1,q1,1)=(un(p1,q1,1).*un(p1,q1,1))./un(p1,q1,2);
            u(p1,q1,1)=un(p1,q1,1)+(D*dt*(unvzs(p1,q1,1)-2*un(p1,q1,1)+un(p1,q1,2))/(dz*dz));
        
    end
    
p=1:nx;
q=2:ny-1;
r=2:nz-1;
    
if un(nx-1,q,r)>0 
        unvx(nx,q,r)=(un(nx,q,r).*un(nx,q,r))./un(nx-1,q,r);
        u(nx,q,r)=un(nx,q,r)+(D*dt*(unvx(nx,q,r)-2*un(nx,q,r)+un(nx-1,q,r))/(dx*dx));
end
   
    if un(p,ny-1,r)>0
            unvy(p,ny,r)=(un(p,ny,r).*un(p,ny,r))./un(p,ny-1,r);
            u(p,ny,r)=un(p,ny,r)+(D*dt*(unvy(p,ny,r)-2*un(p,ny,r)+un(p,ny-1,r))/(dy*dy));
    end
    
    if un(p,q,nz-1)>0
            unvz(p,q,nz)=(un(p,q,nz).*un(p,q,nz))./un(p,q,nz-1);
            u(p,q,nz)=un(p,q,nz)+(D*dt*(unvz(p,q,nz)-2*un(p,q,nz)+un(p,q,nz-1))/(dz*dz));
    end

    %}

end
u;
nx;
ny;
nz;
dx;


