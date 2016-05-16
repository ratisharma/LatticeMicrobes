
for i=1:200
a(i)=size(find(msd2(:,i)>0),1);
if a(i)>0
    s(i)=sum(msd,1)./a(i)
end
end
plot(1:140,s(1:140))
