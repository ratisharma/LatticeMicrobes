numberReplicates=3000;
species=1;
nlattice1=50;
nlattice2=50;
nlattice3=50;
totParticles=170;
ni=10;
t=size(ts,2);
cts=zeros(ni,size(x,2),t);

load('Pt1_alpha_D50.mat')
ni2=5;
i=1:ni2;
j=1:nlattice2;
k=1:nlattice3;
E=zeros(ni2,size(ts,2));
V=zeros(ni2,size(ts,2));
for x=[1:totParticles+1]
    cts(:,x,:)=x-1;
end
n=1:totParticles+1;
for ti=[1:size(ts,2)]
E(i,ti)=sum(cts(i,:,ti).*Pt1(i,:,ti),2);
V(i,ti)=sum(cts(i,:,ti).*cts(i,:,ti).*Pt1(i,:,ti),2)-sum(cts(i,:,ti).*Pt1(i,:,ti),2).*sum(cts(i,:,ti).*Pt1(i,:,ti),2);
StdDev(i,ti)=V(i,ti).^0.5;
end
% meanE=mean(E(:,2:end),2)
% meanVar=mean(V(:,2:end),2)

subplot(2,1,1);
plot(ts(1:end), E(1,1:end));
hold on;
for i=[2:ni2]
plot(ts(1:end), E(i,1:end),'m');
plot(ts(2:end),StdDev(i,2:end),'-k');
end
%plot(ts(1:10:end-1), E(3,1:10:end-1),'g');
xlabel('Time (s)'); ylabel('E\{A(t)\}');
subplot(2,1,2);
plot(ts(2:end), V(1,2:end));
hold on;
for i=[2:ni2]
plot(ts(2:end), V(i,2:end),'k');
% plot(ts(2:end),StdDev(i,2:end),'-k')
end;
%plot(ts(1:10:end-1), V(3,1:10:end-1),'g');
xlabel('Time (s)'); ylabel('V\{A(t)\}');