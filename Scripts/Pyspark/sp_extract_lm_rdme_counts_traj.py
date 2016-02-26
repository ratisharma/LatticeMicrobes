## Spark Application - execute with spark-submit, e.g.
## spark-submit --master yarn-client --num-executors 12 --driver-memory 2g --executor-memory 2g --executor-cores 1 --jars git/roberts-lab/Code/Hadoop/lib/robertslab-hadoop.jar analysis/scripts/sp_calc_lm_rdme_stationary_counts_picktime.py analysis/pdf.dat "(0,)" /user/rsharm28/rdme/vol_full/data_rdme_Dkp15/cell_modelII_48reps_gradient_0_c1b_1.0e-6_c2b_2.0e-6_c3b_6.0e-5_c0a_5.0e-4_c4_2.0e-4_c5_2.0e-3_c6_2.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15_0.sfile 47 47 34.0 420.0 0 1 2 3 4 5 6
##

from ast import literal_eval as make_tuple
import os
from pyspark import SparkConf, SparkContext
import sys
from timeit import default_timer as timer

import numpy as np
import math
import re
import sys
import time
import cStringIO
import zlib
import h5py
import scipy.io
import pickle

from scipy.stats import norm

import matplotlib.pyplot as plt
from skimage import io, filter

import robertslab.cellio as cellio
import robertslab.zlib as rzlib
import robertslab.pbuf.NDArray_pb2 as NDArray_pb2
import lm.io.LatticeTimeSeries_pb2 as LatticeTimeSeries_pb2

# Global variables.
globalSpeciesToBin=None
globalSkipTime=None
globalSparse=None
globalReplicates=None
globalTrajectory=None

def main(sc, outputDir, outputIndices, filename, replicates, trajectory, speciesToBin, outputFileNum, skipTime, sparse, interactive):
    
    global globalSpeciesToBin, globalSkipTime, globalSparse, globalReplicates, globalTrajectory
    
    # Broadcast the global variables.
    globalSpeciesToBin=sc.broadcast(speciesToBin)
    globalReplicates = sc.broadcast(replicates)
    globalTrajectory = sc.broadcast(trajectory)
    globalSkipTime=sc.broadcast(skipTime)
    globalSparse=sc.broadcast(sparse)
    
    # Load the records from the sfile.
    allRecords = sc.newAPIHadoopFile(filename, "robertslab.hadoop.io.SFileInputFormat", "robertslab.hadoop.io.SFileHeader", "robertslab.hadoop.io.SFileRecord", keyConverter="robertslab.spark.sfile.SFileHeaderToPythonConverter", valueConverter="robertslab.spark.sfile.SFileRecordToPythonConverter")

    # Bin the species counts records and sum across all of the bins.
    results = allRecords.filter(filterLatticeTimeSeries).map(binLatticeOccupancy).reduceByKey(addLatticeBins).values().collect()
    totalTimePoints=results[0][0]
    bins=results[0][1]
    # bins[:,:,:,:,0] += totalTimePoints
    print "Recovered bins from %d total time points"%(totalTimePoints)
    print bins.shape

    # # Get the file:
    # inputFile = "../../ltable/grad_bc/yeast_cell/molar/vol_full/data_rdme_Dkp15/cell_modelII_48reps_gradient_0_c1b_1.0e-6_c2b_2.0e-6_c3b_6.0e-5_c0a_5.0e-4_c4_2.0e-4_c5_2.0e-3_c6_2.0e-6_Dk_5.0e-12_Dkp_5.0e-15_Dr_5.0e-12_Drl_5.0e-15.lm"
    # f = h5py.File(inputFile,'r')
    # print ("Processing %s file."%(inputFile))
    #
    # # Get the membrane sites
    # lattice = f["/Model/Diffusion/LatticeSites"].value
    # MembraneSites = (lattice==1).astype(int)
    # l, m, n = MembraneSites.nonzero()
    # print "Length of membrane sites = " + str(len(l))
    #
    # # Calculating the mean:
    # particle = np.zeros((bins.shape[0],bins.shape[1],bins.shape[2],bins.shape[3],bins.shape[4]))
    # data = np.zeros((bins.shape[0],bins.shape[1],bins.shape[2],bins.shape[3],bins.shape[4]))
    # for p in range(0,bins.shape[4]):
    #     particle[:,:,:,:,p] = p
    #
    # counts = np.zeros((len(l),5))
    # for i in range(0,len(speciesToBin)):
    #     for mem in range(0,len(l)):
    #         data[i,l[mem],m[mem],n[mem],:] = particle[i,l[mem],m[mem],n[mem],:]*bins[i,l[mem],m[mem],n[mem],:]
    #     mean = np.sum(data,axis=4)
    #     for mem in range(0,len(l)):
    #         counts[mem,0] = speciesToBin[i]
    #         counts[mem,1] = l[mem]
    #         counts[mem,2] = m[mem]
    #         counts[mem,3] = n[mem]
    #         counts[mem,4] = float(mean[i,l[mem],m[mem],n[mem]])/float(totalTimePoints)

    # Save the counts into a .mat file in the output directory named according to the output indices.
    # cellio.cellsave(outputDir,counts,outputIndices);
    outputFile = 'traj_%s_%s_%s.p'%(trajectory[0],trajectory[-1],outputFileNum)
    pickle.dump(results, open(outputDir+outputFile, "wb"))
    # scipy.io.savemat(outputDir+outputFile, dict(bins=bins))
    print("Binned species data into %s"%(outputDir))

    # # Save the pdfs into a .mat file in the output directory named according to the output indices.
    # pdfs=np.zeros((len(speciesToBin),),dtype=object)
    # for i in range(0,len(speciesToBin)):
    #     counts = sum(data)
    #     pdf=bins[i,:,:,:,:].astype(float)/float(totalTimePoints)
    #     # /float(np.sum(bins[i,0,0,0,:]))
    #     pdfs[i] = pdf
    # cellio.cellsave(outputDir,pdfs,outputIndices);
    # print("Binned species data into %s"%(outputDir))

    # If interactive, show the pdf.
    if interactive:
        subvolumeCounts=bins.sum(axis=1).sum(axis=1).sum(axis=1)
        for i in range(0,len(speciesToBin)):
            print "Subvolume distribution for species %d"%(speciesToBin[i])
            plt.figure()
            plt.subplot(1,1,1)
            plt.bar(np.arange(0,subvolumeCounts.shape[1]),np.log10(subvolumeCounts[i,:]))
            io.show()

    # Save a copy of the records, for examples purposes only here.
    #records.saveAsNewAPIHadoopFile(sys.argv[1]+".copy", "robertslab.hadoop.io.SFileOutputFormat", "robertslab.hadoop.io.SFileHeader", "robertslab.hadoop.io.SFileRecord", keyConverter="robertslab.spark.sfile.PythonToSFileHeaderConverter", valueConverter="robertslab.spark.sfile.PythonToSFileRecordConverter", conf=conf)
    
    
def filterLatticeTimeSeries(record):
    
    global globalReplicates, globalTrajectory

    # Get the global variables.
    replicates = globalReplicates.value
    trajectory = globalTrajectory.value

    
    # Extract the data.
    (name,dataType)=record[0]
    data=record[1]
    
    # Make sure the record and and type are correct.
    if dataType == "protobuf:lm.io.LatticeTimeSeries":
        m=re.match("/Simulations/(\d+)/LatticeTimeSeries",name)
        if m == None:
            return False
        replicateNumber=int(m.group(1))

        # # Deserialize the data.
        # obj=LatticeTimeSeries_pb2.LatticeTimeSeries()
        # obj.ParseFromString(str(data))

        if replicateNumber in replicates:
            print "rati message: replicateNumber in replicates = " + str(replicateNumber)
            # times=np.zeros((obj.number_entries,),dtype=float)
            # i=0
            # for val in obj.v1_times:
            #     if val >= minTime and val < maxTime:
            #         print "rati message: times[i] = " + str(times[i])
            #         return True
            return True
                # return False
        return False
    return False
    

def binLatticeOccupancy(record):
    
    global globalSpeciesToBin, globalSkipTime, globalSparse, globalMinTime, globalMaxTime

    start=timer()

    # Get the global variables.
    speciesToBin = globalSpeciesToBin.value
    trajectory = globalTrajectory.value
    skipTime = globalSkipTime.value
    sparse = globalSparse.value
    
    # Parse the data.
    (name,dataType)=record[0]
    data=record[1]
    
    # If this is a SpeciesCounts object, extract the data.
    if dataType == "protobuf:lm.io.LatticeTimeSeries":
        m=re.match("/Simulations/(\d+)/LatticeTimeSeries",name)
        if m == None:
            return None
        replicateNumber=int(m.group(1))
    
        # Deserialize the data.
        obj=LatticeTimeSeries_pb2.LatticeTimeSeries()
        obj.ParseFromString(str(data))

        # If there are no entries, return an empty set.
        if obj.number_entries == 0:
            allBins=[]
            for species in speciesToBin:
                allBins.append(())
            return (0,(0,))

        # See if this is a v1 lattice time series.
        if len(obj.v1_times) == obj.number_entries:

            # Make sure the data is consistent.
            if len(obj.lattices) != obj.number_entries:
                raise "Invalid array shape."

            # Convert the times to a numpy array.
            t0=timer()
            times=np.zeros((obj.number_entries,),dtype=float)
            k=0
            timeIndex=[]
            for val in obj.v1_times:
                if val in trajectory:
                    times[k] = val
                    print "rati message: times[i] = " + str(times[k])
                    timeIndex.append(k)
                k+=1
            print "rati message: timeIndex = " + str(timeIndex) + " len(timeIndex) = " + str(len(timeIndex))

            # Create a tuple with the lattice shape.
            latticeShape=(obj.lattices[0].x_size,obj.lattices[0].y_size,obj.lattices[0].z_size,obj.lattices[0].particles_per_site)

            # Create the bins for this species.
            t1=timer()
            if not sparse:
                bins = np.zeros((len(speciesToBin),latticeShape[0],latticeShape[1],latticeShape[2],latticeShape[3]+1), dtype=np.int32)
            else:
                nonzeroCounts={}
                # binsShape = (len(speciesToBin),latticeShape[0],latticeShape[1],latticeShape[2],latticeShape[3]+1)
                bins = np.zeros((len(trajectory),500,3), dtype=np.int32)


            # Go through each lattice.
            t2=timer()
            totalTimePoints = 0
            # for i in range(0,len(obj.lattices)):
            for i in timeIndex:

                # Get the lattice.
                print "rati message: i in timeIndex = " + str(i)
                lattice = obj.lattices[i]

                t3=0.0
                t8=0.0
                t9=0.0
                t10=0.0

                # Version of the algorithm that will work better for highly populated lattices.
                if not sparse:

                    # Convert the data to a numpy array.
                    t=timer()
                    if lattice.v1_particles_compressed_deflate:
                        latticeData=np.reshape(np.fromstring(zlib.decompress(lattice.v1_particles), dtype=np.uint8), latticeShape)
                    else:
                        latticeData=np.reshape(np.fromstring(lattice.v1_particles, dtype=np.uint8), latticeShape)
                    t3=timer()-t

                    # Go through each species and bin the counts by lattice site.
                    t4=timer()
                    for j in range(0,len(speciesToBin)):

                        # Create a new lattice with the counts for this species.
                        t=timer()
                        latticeCounts=np.sum((latticeData==(speciesToBin[j]+1)), axis=3, dtype=np.int8)
                        t8+=timer()-t

                        # Find all the subvolumes with non-zero counts.
                        t=timer()
                        indices = np.argwhere(latticeCounts)
                        t9+=timer()-t

                        # Increment the bins.
                        t=timer()
                        for index in indices:
                            count = latticeCounts[index[0],index[1],index[2]]
                            bins[j,index[0],index[1],index[2],count] += 1
                            bins[j,index[0],index[1],index[2],0] -= 1

                        t10+=timer()-t
                    t5=timer()

                # Version of the algorithm that will work better for sparsely populated lattices.
                else:


                    t=timer()
                    if lattice.v1_particles_compressed_deflate:

                        latticeDataZ=np.fromstring(lattice.v1_particles, dtype=np.uint8)
                        flatIndices=np.empty((np.product(latticeShape)/1000,), dtype=np.int32)
                        flatParticles=np.empty((np.product(latticeShape)/1000,), dtype=np.uint8)
                        numberFound=rzlib.decompress_nonzero(latticeDataZ,np.product(latticeShape),flatIndices,flatParticles)
                        if numberFound < 0:
                            raise "Exception during decompress_nonzero: %d."%(numberFound)
                        elif numberFound > flatIndices.shape[0]:
                            raise "Too many nonzero indices found, lattice was not sparse."
                    else:
                        #flatIndices=np.flatnonzero(latticeData)
                        raise "Uncompressed data not currently supported."
                    t3=timer()-t

                    t4=timer()

                    t=timer()
                    (xs,ys,zs,ps)=np.unravel_index(flatIndices[0:numberFound], latticeShape)
                    nonzeroCounts={}
                    for j in range(0,len(xs)):
                        species=flatParticles[j]-1
                        if species in speciesToBin:
                            speciesIndex = speciesToBin.index(species)
                            key=(speciesIndex,xs[j],ys[j],zs[j])
                            nonzeroCounts[key] = nonzeroCounts.get(key,0)+1
                    t8+=timer()-t


                    t5=timer()

                    # Update bins.
                    keyNum = 0
                    for key in nonzeroCounts.keys():
                        keyNum += 1
                        print "rati message: times[i] = " + str(times[i])
                        bins[int(times[i]),keyNum,0] = key[1]
                        bins[int(times[i]),keyNum,1] = key[2]
                        bins[int(times[i]),keyNum,2] = key[3]


                # Update the number of lattices that we have processed.
                totalTimePoints += 1

            # Update the zero bin with the remainder, since we didn't track those as we went.
            t6=timer()
            t7=timer()

            #print "Map binLatticeOccupancy took %0.3f seconds for %d lattices."%(timer()-start,len(obj.lattices))
            stop = timer()
            #print "Map binLatticeOccupancy (%0.4f - %0.4f) took %0.3f seconds for %d lattices: %0.3f %0.3f %0.3f %0.3f (%0.3f %0.3f %0.3f) %0.3f"%(start,stop,stop-start,len(obj.lattices),t1-t0,t2-t1,t3,t5-t4,t8,t9,t10,t7-t6)

            # Return the bins.
            if not sparse:
                return (0,(totalTimePoints,bins))
            else:
                print "rati message: totalTimePoints = " + str(totalTimePoints)
                print "rati message: nonzeroCounts = " + str(nonzeroCounts)
                return (0,(totalTimePoints,nonzeroCounts,bins))
                # return (0,(totalTimePoints,nonzeroCounts,binsShape))

            # See if this is a v2 lattice time series.
        elif obj.HasField("times"):
            raise "V2 lattice time series not yet supported."

            # Make sure the data is consistent.
            #if len(obj.counts.shape) != 2 or len(obj.times.shape) != 1:
            #    raise "Invalid array shape."
            #if obj.counts.shape[0] != obj.times.shape[0]:
            #    raise "Inconsistent array sizes."
            #if obj.counts.data_type != NDArray_pb2.NDArray.int32 or obj.times.data_type != NDArray_pb2.NDArray.float64:
            #    raise "Invalid array data types."

        else:
            raise "Unknown lattice time series message version."


def addLatticeBins(bins1, bins2):

    start=timer()

    # See if both records have data in them.
    if bins1[0] > 0 and bins2[0] > 0:

        totalTimePoints = bins1[0]+bins2[0]
        bins = np.zeros((len(trajectory),500,3), dtype=np.int32)
        if isinstance(bins1[1],np.ndarray) and isinstance(bins2[1],np.ndarray):
            bins = bins1[1]
            bins += bins2[1]
            stop = timer()
            #print "Reduce addLatticeBins/1 (%0.4f - %0.3f) took %0.3f seconds."%(start,stop,stop-start)
            return (totalTimePoints,bins)

        elif isinstance(bins1[1],np.ndarray) and isinstance(bins2[1],dict):
            bins=bins1[1]
            bins += bins2[2]
            # nonzeroCounts=bins2[1]
            # for key in nonzeroCounts.keys():
            #     bins[key[0],key[1],key[2],key[3],nonzeroCounts[key]] += 1
            #     bins[key[0],key[1],key[2],key[3],0] -= 1
            # stop = timer()
            # #print "Reduce addLatticeBins/2 (%0.4f - %0.4f) took %0.3f seconds."%(start,stop,stop-start)
            return (totalTimePoints,bins)

        elif isinstance(bins1[1],dict) and isinstance(bins2[1],np.ndarray):
            bins=bins2[1]
            bins += bins1[2]
            # nonzeroCounts=bins1[1]
            # for key in nonzeroCounts.keys():
            #     bins[key[0],key[1],key[2],key[3],nonzeroCounts[key]] += 1
            #     bins[key[0],key[1],key[2],key[3],0] -= 1
            # stop = timer()
            # #print "Reduce addLatticeBins/3 (%0.4f - %0.4f) took %0.3f seconds."%(start,stop,stop-start)
            return (totalTimePoints,bins)

        elif isinstance(bins1[1],dict) and isinstance(bins2[1],dict):
            bins = bins1[2]
            bins += bins2[2]
            # binsShape = bins1[2]
            # bins = np.zeros(binsShape, dtype=np.int32)
            # nonzeroCounts=bins1[1]
            # for key in nonzeroCounts.keys():
            #     # print "rati message: key = " + str(key)
            #     # print "rati message: nonzeroCounts[key] = " + str(nonzeroCounts[key])
            #     bins[key[0],key[1],key[2],key[3],nonzeroCounts[key]] += 1
            #     bins[key[0],key[1],key[2],key[3],0] -= 1
            # nonzeroCounts=bins2[1]
            # for key in nonzeroCounts.keys():
            #     bins[key[0],key[1],key[2],key[3],nonzeroCounts[key]] += 1
            #     bins[key[0],key[1],key[2],key[3],0] -= 1
            # stop = timer()
            # #print "Reduce addLatticeBins/4 (%0.4f - %0.4f) took %0.3f seconds."%(start,stop,stop-start)
            return (totalTimePoints,bins)

    # Otherwise, if just record 1 had data, return it.
    elif bins1[0] > 0:
        return bins1

    # Otherwise, if just record 2 had data, return it.
    elif bins2[0] > 0:
        return bins2

    # Otherwise, neither record had data.
    else:
        return bins1

if __name__ == "__main__":
    
    if len(sys.argv) < 7:
        print "Usage: output_dir output_indices hdfs_sfile replicate minTime maxTime outputFileNum [--skip_less_than=<time>] [--not-sparse] species+ [--interactive]"
        quit()
    
    outputDir = sys.argv[1]
    outputIndices = make_tuple(sys.argv[2])
    if type(outputIndices) != type((0,)):
        print "Error: output indices must be specified in as a python formatted tuple, got: %s"%(type(outputIndices))
        quit()
    filename = sys.argv[3]
    replicates = [int(sys.argv[4])]
    minTime = int(sys.argv[5])
    maxTime = int(sys.argv[6])
    times = range(minTime,maxTime+1)
    trajectory = [float(t) for t in times]
    outputFileNum = int(sys.argv[7])
    interactive = False
    sparse = True
    skipTime=0.0
    species=[]
    for i in range(8,len(sys.argv)):
        if sys.argv[i] == "--interactive":
            interactive=True
            continue
        if sys.argv[i] == "--not-sparse":
            sparse=False
            continue

        m=re.match(r'--skip_less_than=([+-]?(\d+(\.\d*)?|\.\d+)([eE][+-]?\d+)?)',sys.argv[i])
        if m != None:
            skipTime=float(m.group(1))
            continue

        m = re.match(r'-o=(\S+)', sys.argv[i])
        if m:
            outputDir = m.group(1) + '.dat'
            continue

        m = re.match(r'--suffix=(\S+)', sys.argv[i])
        if m:
            outputName,outputExt = os.path.splitext(outputDir)
            outputDir = outputName + m.group(1) + outputExt
            continue

        species.append(int(sys.argv[i]))
        
    # Make sure we got at least one species.
    if len(species) == 0:
        print "Error: at least one species must be specified."
        quit()
        
    # Configure Spark
    conf = SparkConf().setAppName("LM RDME PDF Calculation for an onEvent")
    sc = SparkContext(conf=conf)

    # Execute Main functionality
    main(sc, outputDir, outputIndices, filename, replicates, trajectory, species, outputFileNum, skipTime, sparse, interactive)
