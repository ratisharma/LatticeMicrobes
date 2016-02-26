function [c3]=scaling_gradient(dx,scale,filename)
data=permute(hdf5read(filename,'/dataset1'),[3,2,1]);
nx=size(data,1);
ny=size(data,2);
nz=size(data,3);


l1=1;
d1=1;

for l2=[1:scale*size(data,1)] 
    m1=1;
    d2=1;
    for m2=[1:scale*size(data,2)]
        n1=1;
        d3=1;
        for n2=[1:scale*size(data,3)]
            c2(l2,m2,n2)=data(l1,m1,n1);
            d3=d3+1;
            if rem(d3-1,scale)==0
               n1=n1+1;
            end
        end
        d2=d2+1;
        if rem(d2-1,scale)==0
            m1=m1+1;
        end
    end
    d1=d1+1;
    if rem(d1-1,scale)==0
       l1=l1+1;
    end
end
a1=1:(scale*size(data,1)-2*(scale-1));
a2=1:(scale*size(data,2)-2*(scale-1));
a3=1:(scale*size(data,3)-2*(scale-1));
Na=6.023e+23; % mole constant
sublatticeVol=(dx^3) * 1e-18; % volume of each subvolume in the unscaled lattice
c3=zeros(size(a1,2),size(a2,2),size(a3,2));
c3(a1,a2,a3)=c2(scale:scale*size(data,1)-(scale-1),scale:scale*size(data,2)-(scale-1),scale:scale*size(data,3)-(scale-1)).*1/(Na*sublatticeVol*1e3); % conc in molar=mol/L
c3;