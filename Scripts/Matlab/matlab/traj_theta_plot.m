clear all

sp=[0 1 2 5 6]
rows1=1; cols1=1; plotIndex1=1;
for R=1
    subplot(rows1,cols1,plotIndex1)
    rows=2;cols=2;plotIndex=1;
    for j=4
        species=sp(j);
%         inputFilename=sprintf('../pdf/matfiles/mono_Dkp15_Drl15/traj_Dkp15_rep%d_species%d.mat',R,species);
%         inputFilename=sprintf('../pdf/matfiles/traj_Dkp15_Drl15_rep%d_species%d.mat',R,species);
%         inputFilename=sprintf('../pdf/matfiles/Dkp15/traj_Dkp15_rep%d_species%d.mat',R,species);
%         inputFilename=sprintf('../pdf/matfiles/Dkp15_t100/traj_Dkp15_rep%d_species%d.mat',R,species);
        inputFilename=sprintf('../pdf/matfiles/sum_Dkp15_Drl15/data_Dkp15_Drl15_species_%d.mat',species);
        load(inputFilename)
        figure(3)
%         figure(R)
%         subplot(rows,cols,plotIndex)
        image(Ntheta*25)
        title(['replicate=',num2str(R),', species=',num2str(species)]);
%         plotIndex=plotIndex+1;
%         if (plotIndex>rows*cols), plotIndex=1; end
    end
    plotIndex1=plotIndex1+1;
    if (plotIndex1>rows1*cols1), plotIndex1=1; end
end