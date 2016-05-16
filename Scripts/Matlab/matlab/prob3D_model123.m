%%%%% This script gives the scatter plot of the probability density in 3D
%%%%% space (in micrometers) as well as in theta-z space. 


rows=1;cols=1;plotIndex=1;
inputFilename2=sprintf('../data/data_mono_Dkp15_Drl15/cell_rdme_mono_ligand.lm');
LS=permute(hdf5read(inputFilename2,'/Model/Diffusion/LatticeSites'),[3:-1:1]);
[x1 y1 z1]=ind2sub(size(LS),find(LS==1));
ctr=25;
[theta phi rho]=cart2sph(x1-ctr,y1-ctr,z1-ctr);

for model=1:3
    if model==1
        data=zeros(50,50,50,17);
        mean2_min=zeros(1,size(x1,1));
        mean2_grad=zeros(1,size(x1,1));
        matfile_grad1=sprintf('../pdf/pdf_mono_Dkp15_Drl15/gradient_countR_400.dat/00005.00005.00002.mat');
        matfile_min1=sprintf('../pdf/pdf_mono_Dkp15_Drl15/min_ligand_countR_400.dat/00005.00005.00002.mat');
        matfile_grad2=sprintf('../pdf/pdf_mono_Dkp15_Drl15/gradient_2_countR_400.dat/00005.00005.00002.mat');
        matfile_min2=sprintf('../pdf/pdf_mono_Dkp15_Drl15/min_ligand_2_countR_400.dat/00005.00005.00002.mat');
        matfile_grad3=sprintf('../pdf/pdf_mono_Dkp15_Drl15/gradient_3_countR_400.dat/00005.00005.00002.mat');
        matfile_min3=sprintf('../pdf/pdf_mono_Dkp15_Drl15/min_ligand_3_countR_400.dat/00005.00005.00002.mat');
        load(matfile_grad1);
        for i=[1:50]
            for j=[1:50]
                for k=[1:50]
                    for l=[1:9]

                        density_grad(i,j,k,l)=(l-1)*celldata(i,j,k,l);


                    end

                end
            end
        end
        load(matfile_grad2);
        for i=[1:50]
            for j=[1:50]
                for k=[1:50]
                    for l=[1:9]

                        density_grad(i,j,k,l)=density_grad(i,j,k,l)+(l-1)*celldata(i,j,k,l);


                    end

                end
            end
        end
        load(matfile_grad3);
        for i=[1:50]
            for j=[1:50]
                for k=[1:50]
                    for l=[1:9]

                        density_grad(i,j,k,l)=density_grad(i,j,k,l)+(l-1)*celldata(i,j,k,l);


                    end

                end
            end
        end
        sum_grad=sum(sum(sum(sum(density_grad,4),3),2));
        mean1_grad=sum(density_grad,4)./sum_grad;
        load(matfile_min1);
        for i=[1:50]
            for j=[1:50]
                for k=[1:50]
                    for l=[1:9]

                        density_min(i,j,k,l)=(l-1)*celldata(i,j,k,l);


                    end

                end
            end
        end
        load(matfile_min2);
        for i=[1:50]
            for j=[1:50]
                for k=[1:50]
                    for l=[1:9]

                        density_min(i,j,k,l)=density_min(i,j,k,l)+(l-1)*celldata(i,j,k,l);


                    end

                end
            end
        end
        load(matfile_min3);
        for i=[1:50]
            for j=[1:50]
                for k=[1:50]
                    for l=[1:9]

                        density_min(i,j,k,l)=density_min(i,j,k,l)+(l-1)*celldata(i,j,k,l);


                    end

                end
            end
        end
        
        sum_min=sum(sum(sum(sum(density_min,4),3),2));
        mean1_min=sum(density_min,4)./sum_min;
        for a=1:size(x1)
            mean2_grad(a)=mean1_grad(x1(a),y1(a),z1(a));
            mean2_min(a)=mean1_min(x1(a),y1(a),z1(a));
            ratio(a)=mean2_grad(a)/mean2_min(a);
        end
        max(ratio);
        subplot(2,3,1)
        scatter3(x1*0.05,y1*0.05,z1*0.05,10,ratio,'filled')
        axis([0.3 2.2 0.3 2.2 0.3 2.2])
        ax = gca;
        ax.XTick = [1 2];
        ax.YTick = [1 2];
        ax.ZTick = [1 2];
        xlabel('x ({\mum})');ylabel('y ({\mum})');zlabel('z ({\mum})')
        caxis manual
        caxis([0.80 1.25]);
        colorbar
        subplot(2,3,4)
        scatter(theta,z1*0.05,20,ratio,'filled')
        axis([-3.2 3.2 0.25 2.25])
        ax = gca;
        ax.XTick = [-pi -pi/2 0 pi/2 pi];
        ax.YTick = [1 2];
        xlabel('{\theta}');ylabel('z ({\mum})')
        caxis manual
        caxis([0.80 1.25]);
        colorbar
        
    elseif model==2
        mean2_min=zeros(1,size(x1,1));
        mean2_grad=zeros(1,size(x1,1));
        matfile_grad=sprintf('analysisData/pdf_gradient.mat');
        matfile_min=sprintf('analysisData/pdf_min_ligand.mat');
        load(matfile_grad);
        for i=[1:50]
            for j=[1:50]
                for k=[1:50]
                    for l=[1:9]

                        density_grad(i,j,k,l)=(l-1)*pdf(i,j,k,l);


                    end

                end
            end
        end
        sum_grad=sum(sum(sum(sum(pdf,4),3),2));
        mean1_grad=sum(density_grad,4)./sum_grad;
        load(matfile_min);
        for i=[1:50]
            for j=[1:50]
                for k=[1:50]
                    for l=[1:9]

                        density_min(i,j,k,l)=(l-1)*pdf(i,j,k,l);


                    end

                end
            end
        end
        
        sum_min=sum(sum(sum(sum(pdf,4),3),2));
        mean1_min=sum(density_min,4)./sum_min;
        for a=1:size(x1)
            mean2_grad(a)=mean1_grad(x1(a),y1(a),z1(a));
            mean2_min(a)=mean1_min(x1(a),y1(a),z1(a));
            ratio(a)=mean2_grad(a)/mean2_min(a);
        end
        max(ratio)
        subplot(2,3,2)
        scatter3(x1*0.05,y1*0.05,z1*0.05,10,ratio,'filled')
        axis([0.3 2.2 0.3 2.2 0.3 2.2])
        ax = gca;
        ax.XTick = [1 2];
        ax.YTick = [1 2];
        ax.ZTick = [1 2];
        xlabel('x ({\mum})');ylabel('y ({\mum})');zlabel('z ({\mum})')
        caxis manual
        caxis manual
        caxis([0.80 1.25]);
        colorbar
        subplot(2,3,5)
        scatter(theta,z1*0.05,20,ratio,'filled')
        axis([-3.2 3.2 0.25 2.25])
        ax = gca;
        ax.XTick = [-pi -pi/2 0 pi/2 pi];
        ax.YTick = [1 2];
        xlabel('{\theta}');ylabel('z {\mum}')
        caxis manual
        caxis([0.80 1.25]);
        colorbar
        
        elseif model==3
        mean2_min=zeros(1,size(x1,1));
        mean2_grad=zeros(1,size(x1,1));
        matfile_grad=sprintf('analysisData/feedback_kp/Dkp15_Drl15/pdf_gradient.mat');
        matfile_min=sprintf('analysisData/feedback_kp/Dkp15_Drl15/pdf_min_ligand.mat');
        load(matfile_grad);
        for i=[1:50]
            for j=[1:50]
                for k=[1:50]
                    for l=[1:9]

                        density_grad(i,j,k,l)=(l-1)*pdf(i,j,k,l);


                    end

                end
            end
        end
        sum_grad=sum(sum(sum(sum(pdf,4),3),2));
        mean1_grad=sum(density_grad,4)./sum_grad;
        load(matfile_min);
        for i=[1:50]
            for j=[1:50]
                for k=[1:50]
                    for l=[1:9]

                        density_min(i,j,k,l)=(l-1)*pdf(i,j,k,l);


                    end

                end
            end
        end
        
        sum_min=sum(sum(sum(sum(pdf,4),3),2));
        mean1_min=sum(density_min,4)./sum_min;
        for a=1:size(x1)
            mean2_grad(a)=mean1_grad(x1(a),y1(a),z1(a));
            mean2_min(a)=mean1_min(x1(a),y1(a),z1(a));
            ratio(a)=mean2_grad(a)/mean2_min(a);
        end
        max(ratio)
        subplot(2,3,3)
        scatter3(x1*0.05,y1*0.05,z1*0.05,10,ratio,'filled')
        axis([0.3 2.2 0.3 2.2 0.3 2.2])
        ax = gca;
        ax.XTick = [1 2];
        ax.YTick = [1 2];
        ax.ZTick = [1 2];
        xlabel('x ({\mum})');ylabel('y ({\mum})');zlabel('z ({\mum})')
        caxis manual
        caxis manual
        caxis([0.80 1.25]);
        colorbar
        subplot(2,3,6)
        scatter(theta,z1*0.05,20,ratio,'filled')
        axis([-3.2 3.2 0.25 2.25])
        ax = gca;
        ax.XTick = [-pi -pi/2 0 pi/2 pi];
        ax.YTick = [1 2];
        xlabel('{\theta}');ylabel('z ({\mum})')
        caxis manual
        caxis([0.80 1.25]);
        colorbar
    end
end