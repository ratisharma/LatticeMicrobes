clear all


for i=2
%     species=sp(i);
    inputFilename=sprintf('../pdf/pdf_c6_4_memThick2/Dkp_5e-15_500rep1_scatter.dat/00005.00002.0000%d.mat',i);
    load(inputFilename);
    [x1 y1]=ind2sub(size(celldata),find(celldata(:,:,3)==25));
    

for a=1:size(x1,1)
    l(a)=celldata(x1(a),y1(a),1);
    m(a)=celldata(x1(a),y1(a),2);
end
scatter(l,m)
figure(3)
[N,X,Y]=hist2d(l,m,[1:50],[1:50])
% [N,X,Y]=hist2d(l,m)
contourf(N)
end