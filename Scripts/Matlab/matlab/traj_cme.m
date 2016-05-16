numberReplicates=25;
totParticles=300;
species=3
x=[0:totParticles];
L=75;
inputFile=sprintf('../data/data_cme/pdf_off_on_%d_64_0.lm',L);
% for R=[1:numberReplicates]
for R=14
ts=cast(permute(hdf5read(inputFile,...
sprintf('/Simulations/%07d/SpeciesCountTimes',R)),[2,1]),'double');
counts=cast(permute(hdf5read(inputFile,...
sprintf('/Simulations/%07d/SpeciesCounts',R)),[2,1]),'double');
% subplot(5,5,R)
plot(ts,64-counts(:,1))
axis([0 10000 0 64])
end