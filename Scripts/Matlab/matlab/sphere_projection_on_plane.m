clear all
x1=6;
y1=6;
z1=6;
x2=6;
y2=6;
z2=44;
rho=19;
ctr=25;
lon2=atan2(y2-ctr,x2-ctr);
tlon2=180*lon2/3.14
lat2=atan2(z2-ctr,sqrt((x2-ctr)^2+(y2-ctr)^2));
tlat2=180*lat2/3.14
lon1=atan2(y1-ctr,x1-ctr);
tlon1=180*lon1/3.14
lat1=atan2(z1-ctr,sqrt((x1-ctr)^2+(y1-ctr)^2));
tlat1=180*lat1/3.14
% arclen1 = distance('gc',[lat1,lon1],[lat2,lon2])
% dist11=arclen1*rho
% arcAngle=acos(sin(lat1)*sin(lat2)+cos(lat1)*cos(lat2)*cos(lon2-lon1))
% dist11=arcAngle*rho

ax1=x1-ctr; ay1=y1-ctr; az1=z1-ctr;
bx2=x2-ctr; by2=y2-ctr; bz2=z2-ctr;
abcr=sqrt((ax1*by2-bx2*ay1)^2+(ay1*bz2-az1*by2)^2+(az1*bx2-ax1*bz2)^2);
abdot=ax1*bx2+ay1*by2+az1*bz2;
arcAngle=atan2(abcr,abdot)
dist=arcAngle*rho



