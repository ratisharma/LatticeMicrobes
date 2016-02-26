## Spark Application - execute with spark-submit, e.g.
## spark-submit --master yarn-client --num-executors 16 --driver-memory 1g --executor-memory 1g --executor-cores 1 --jars ~/Work/Lab/Git/roberts-lab/Code/Hadoop/lib/robertslab-hadoop.jar ~/Work/Lab/Git/roberts-lab/Scripts/pyspark/sp_calc_lm_stationary_pdf.py pdf.dat "(0,)" /user/erober32/tmp/pdf3.sfile --skip_less_than=1.0 0 1 2 3 4 5 6 --interactive
## spark-submit --master yarn-client --num-executors 16 --driver-memory 1g --executor-memory 1g --executor-cores 1 --jars ~/Work/Lab/Git/roberts-lab/Code/Hadoop/lib/robertslab-hadoop.jar ~/Work/Lab/Git/roberts-lab/Scripts/pyspark/sp_calc_lm_stationary_pdf.py pdf.dat "(0,)" /user/erober32/tmp/pdf4*.sfile --skip_less_than=1e1 0 --interactive
## spark-submit --master yarn-client --num-executors 16 --driver-memory 1g --executor-memory 1g --executor-cores 1 --jars ~/Work/Lab/Git/roberts-lab/Code/Hadoop/lib/robertslab-hadoop.jar ~/Work/Lab/Git/roberts-lab/Scripts/pyspark/sp_calc_lm_stationary_pdf.py pdf.dat "(0,)" /user/erober32/tmp/pdf6.sfile --skip_less_than=1e1 0 --interactive
## spark-submit --master yarn-client --num-executors 16 --driver-memory 1g --executor-memory 1g --executor-cores 1 --jars ~/Work/Lab/Git/roberts-lab/Code/Hadoop/lib/robertslab-hadoop.jar ~/Work/Lab/Git/roberts-lab/Scripts/pyspark/sp_calc_lm_stationary_pdf.py pdf.dat "(0,)" /user/erober32/tmp/pdf7.sfile --skip_less_than=1e1 0 --interactive
##

## spark-submit --master yarn-client --num-executors 1 --driver-memory 1g --executor-memory 1g --executor-cores 1 --jars ../../git/roberts-lab/Code/Hadoop/lib/robertslab-hadoop.jar sp_calc_lm_onEvents2.py pdf.dat "(0,)" /user/erober32/tmp/pdf3.sfile 3 --skip_less_than=1.0 1 --interactive
## spark-submit --master yarn-client --num-executors 16 --driver-memory 1g --executor-memory 1g --executor-cores 1 --jars ../../git/roberts-lab/Code/Hadoop/lib/robertslab-hadoop.jar sp_calc_lm_onEvents2.py pdf.dat "(0,)" /projects/Gradient_Sensing/variable_diffusion/data/lm/ts_MII_5.00e-15_gradient_1.sfile 5 --skip_less_than=1.0 2 --interactive


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

from scipy.stats import norm

import matplotlib.pyplot as plt
from skimage import io, filter

import robertslab.cellio as cellio
import robertslab.pbuf.NDArray_pb2 as NDArray_pb2
import lm.io.SpeciesCounts_pb2 as SpeciesCounts_pb2
import lm.io.SpeciesTimeSeries_pb2 as SpeciesTimeSeries_pb2

import pickle

# Global variables.
globalSpeciesToBin=None
globalSkipTime=None

def main(sc, outputDir, outputIndices, filename, onThreshold, speciesToBin, skipTime, interactive):
    
    global globalSpeciesToBin, globalSkipTime, globalOnThreshold
    
    # Broadcast the global variables.
    globalSpeciesToBin=sc.broadcast(speciesToBin)
    globalSkipTime=sc.broadcast(skipTime)
    globalOnThreshold = sc.broadcast(onThreshold)
    
    # Load the records from the sfile.
    allRecords = sc.newAPIHadoopFile(filename, "robertslab.hadoop.io.SFileInputFormat", "robertslab.hadoop.io.SFileHeader", "robertslab.hadoop.io.SFileRecord", keyConverter="robertslab.spark.sfile.SFileHeaderToPythonConverter", valueConverter="robertslab.spark.sfile.SFileRecordToPythonConverter")

    # Bin the species counts records and sum across all of the bins.
    # results = allRecords.filter(filterSpeciesCounts).map(binSpeciesCounts).values().reduce(addBins)
    results = allRecords.filter(filterSpeciesCounts).map(storeEvent).values().reduce(addBins)
    results[0].sort()
    # print("results = " + str(results))

    #.reduceByKey(addLatticeBins).values().collect()

    # Save the on events in a file in pickle format.
    pickle.dump(results, open("analysis/pdf.dat/onEvent_gradient_sp2.p", "wb"))

    # Save the pdfs into a .mat file in the output directory named according to the output indices.
    # pdfs=np.zeros((len(speciesToBin),),dtype=object)
    # for i in range(0,len(speciesToBin)):
    #     minCount=results[i][0]
    #     maxCount=results[i][1]
    #     bins=results[i][2]
    #     pdf = np.zeros((len(bins),2),dtype=float)
    #     pdf[:,0]=np.arange(minCount,maxCount+1).astype(float)
    #     pdf[:,1]=bins.astype(float)/float(sum(bins))
    #     pdfs[i] = pdf
    #     print("Binned species %d: %d data points from %d to %d into %s"%(speciesToBin[i],sum(bins),minCount,maxCount,outputDir))
    # cellio.cellsave(outputDir,pdfs,outputIndices);
    # cellio.cellsave(outputDir,results,outputIndices);

    # If interactive, show the pdf.
    if interactive:
        for repidx in range(len(results[0])):
            replicate = results[0][repidx][0]
            times=[]
            event=[]
            for val in results[0][repidx][1:]:
                times.append(val[0])
                event.append(val[1])
            print("times = " + str(times))
            print("event = " + str(event))
            plt.figure()
            plt.subplot(1,1,1)
            plt.plot(times,event)
            plt.axis([0, times[-1], -1, 2])
            plt.xlabel('time')
            plt.ylabel('event')
            plt.title('replicate = %s'%(replicate))
            io.show()
    else:
        print "Warning: cannot plot PDF with only a single bin."

                # Save a copy of the records, for examples purposes only here.
    #records.saveAsNewAPIHadoopFile(sys.argv[1]+".copy", "robertslab.hadoop.io.SFileOutputFormat", "robertslab.hadoop.io.SFileHeader", "robertslab.hadoop.io.SFileRecord", keyConverter="robertslab.spark.sfile.PythonToSFileHeaderConverter", valueConverter="robertslab.spark.sfile.PythonToSFileRecordConverter", conf=conf)
    
    
def filterSpeciesCounts(record):
    
    # Extract the data.
    (name,dataType)=record[0]
    
    # Make sure the record and and type are correct.
    if dataType == "protobuf:lm.io.SpeciesCounts" or dataType == "protobuf:lm.io.SpeciesTimeSeries":
        if dataType == "protobuf:lm.io.SpeciesCounts":
            m=re.match("/Simulations/(\d+)/SpeciesCounts",name)
            if m == None:
                return False
            replicateNumber=int(m.group(1))
            # print("replicate number = " +str(replicateNumber))
            # if replicateNumber > 10:
            #     return False
        elif dataType == "protobuf:lm.io.SpeciesTimeSeries":
            m=re.match("/Simulations/(\d+)/SpeciesTimeSeries",name)
            if m == None:
                return False
            replicateNumber=int(m.group(1))
            # print("replicate number = " +str(replicateNumber))
            # if replicateNumber > 10:
            #     return False
        return True            
    return False
    
def storeEvent(record):
    global globalSpeciesToBin
    global globalOnThreshold

    # Get the global variables:
    speciesToBin = globalSpeciesToBin.value
    onThreshold = globalOnThreshold.value
    # print("On threshold = " + str(onThreshold))

    # Parse the data
    (name,dataType) =  record[0]
    data = record[1]

    # If this is a speciesCounts object, extract the data.
    if dataType == "protobuf:lm.io.SpeciesCounts":
        m = re.match("/Simulations/(\d+)/SpeciesCounts",name)
        if m == None:
            return None
        replicateNumber=int(m.group(1))
        # print("replicate number = " + str(replicateNumber))

        # Deserialize the data.
        obj=SpeciesCounts_pb2.SpeciesCounts()
        obj.ParseFromString(str(data))

        # If there are no entries, return an empty set.
        if obj.number_entries == 0:
            allBins=[]
            for species in speciesToBin:
                allBins.append(())
            return (replicateNumber,allBins)

        # Convert the data to a numpy array.
        species_counts=np.zeros((obj.number_entries*obj.number_species,),dtype=int)
        # print("species_counts shape = " + str(len(species_counts)))
        # events=np.zeros((obj.number_entries,),dtype=int)
        events=[]
        # print ("size of events = " + str(len(events)))

        i=0
        for val in obj.species_count:
            species_counts[i] = val
            i+=1
        # print("species counts = " + str(species_counts))
        # print("species to bin = " + str(speciesToBin))
        # print("on threshold = " + str(onThreshold))
        if int(species_counts[speciesToBin][0]) > int(onThreshold):
            # print("Species counts is greater than onThreshold " + str(species_counts[speciesToBin][0]))
            on=1

        else:
            # print("Species counts is less than onThreshold " + str(species_counts[speciesToBin][0]))
            on=0
        events.append(on)
        species_counts.shape=(obj.number_entries,obj.number_species)
        i=0
        times=np.zeros((obj.number_entries,),dtype=float)
        for val in obj.time:
            times[i] = val
            i+=1


    # If this is a SpeciesCounts object, extract the data.
    elif dataType == "protobuf:lm.io.SpeciesTimeSeries":
        m=re.match("/Simulations/(\d+)/SpeciesTimeSeries",name)
        if m == None:
            return None
        replicateNumber=int(m.group(1))

        # Deserialize the data.
        obj=SpeciesTimeSeries_pb2.SpeciesTimeSeries()
        obj.ParseFromString(str(data))

        # Make sure the data is consistent.
        if len(obj.counts.shape) != 2 or len(obj.times.shape) != 1:
            raise "Invalid array shape."
        if obj.counts.shape[0] != obj.times.shape[0]:
            raise "Inconsistent array sizes."
        if obj.counts.data_type != NDArray_pb2.NDArray.int32 or obj.times.data_type != NDArray_pb2.NDArray.float64:
            raise "Invalid array data types."

        # If there are no entries, return an empty set.
        # if obj.counts.shape[0] == 0:
        #     # allBins=[]
        #     eventsTime=[]
        #     for species in speciesToBin:
        #         # allBins.append(())
        #         eventsTime.append(())
        #     return (replicateNumber,eventsTime)

        # Convert the data to a numpy array.
        if obj.counts.compressed_deflate:
            species_counts=np.reshape(np.fromstring(zlib.decompress(obj.counts.data), dtype=np.int32), obj.counts.shape)
        else:
            species_counts=np.reshape(np.fromstring(obj.counts.data, dtype=np.int32), obj.counts.shape)
        if obj.times.compressed_deflate:
            times=np.reshape(np.fromstring(zlib.decompress(obj.times.data), dtype=np.float64), obj.times.shape)
        else:
            times=np.reshape(np.fromstring(obj.times.data, dtype=np.float64), obj.times.shape)

    else:
        return None

    # Figure out if we need to skip any rows.
    if skipTime <= times[0]:
        firstRow=0
    elif skipTime > times[-1]:
        allBins=[]
        for species in speciesToBin:
            allBins.append(())
        return (replicateNumber,allBins)
    else:
        firstRow = np.searchsorted(times,skipTime)

    # Go through each species.
    # allBins=[]
    # for species in speciesToBin:
    #
    #     # Bin the data.
    #     bins,edges=np.histogram(species_counts[firstRow:,species],np.arange(minCounts[species],maxCounts[species]+2,dtype=int))
    #     allBins.append((minCounts[species],maxCounts[species],bins))
    # eventsTime=np.zeros((replicateNumber,2))
    # eventsTime[replicateNumber] = [times[0], events[0]]
    # eventsTime=[]
    eventsTime=[[[replicateNumber,[times[0],events[0]]]]]
    # print("eventsTime = " + str(eventsTime))

    # Return the bins.
    # print("replicate number =  " + str(replicateNumber))
    # print("eventsTime = " +str(eventsTime))
    # print("times = " +str(times))
    # return (replicateNumber,allBins)
    return(replicateNumber,eventsTime)

def addBins(data1,data2):

    # print("addBins data1 = " +str(data1))
    # print("len data1[0] = " +str(len(data1[0])))
    # print("addBins data2 = " +str(data2))
    # print("len data2[0] = " +str(len(data2[0])))

    # Combine the data.
    combinedData = [[]]
    combinedReps = []
    if len(data1[0]) > 0 and len(data2[0]) > 0:
        for i in data1[0]:
            combinedData[0].append(i)
            combinedReps.append(i[0])
            # print("combinedReps = " +str(combinedReps))
        for j in range(len(data2[0])):
            if data2[0][j][0] in combinedReps:
                idx = combinedReps.index(data2[0][j][0])
                # print("idx = " +str(idx))
                for k in range(1,len(data2[0][j])):
                    combinedData[0][idx].append(data2[0][j][k])
            else:
                combinedData[0].append(data2[0][j])

    elif len(data1[0]) > 0:
        for i in data1[0]:
            combinedData[0].append(i)

    elif len(data2[0]) > 0:
        for i in data2[0]:
            combinedData[0].append(i)

    # Sort the combined Data:
    # if len(combinedData)==3:
    #     combinedData=np.array(combinedData)
    #     sortTimes = np.array(combinedData[1])
    #     idTimes = np.argsort(sortTimes)
    #     combinedData = combinedData[:,idTimes]
    #     sortReps = np.array(combinedData[0])
    #     idReps = np.argsort(sortReps)
    #     combinedData = combinedData[:,idReps]
    #     combinedData = np.array(combinedData).tolist()
    
    # Return the bins with -1 as the replicate number.
    # print("combinedData = " +str(combinedData))
    return combinedData
    
if __name__ == "__main__":
    
    if len(sys.argv) < 6:
        print "Usage: output_dir output_indices hdfs_sfile [--skip_less_than=<time>] species+ [--interactive]"
        quit()
    
    outputDir = sys.argv[1]
    outputIndices = make_tuple(sys.argv[2])
    if type(outputIndices) != type((0,)):
        print "Error: output indices must be specified in as a python formatted tuple, got: %s"%(type(outputIndices))
        quit()
    filename = sys.argv[3]
    onThreshold = sys.argv[4]
    interactive = False
    skipTime=0.0
    species=[]
    for i in range(5,len(sys.argv)):
        if sys.argv[i] == "--interactive":
            interactive=True
            continue
            
        m=re.match(r'--skip_less_than=([+-]?(\d+(\.\d*)?|\.\d+)([eE][+-]?\d+)?)',sys.argv[i])
        if m != None:
            skipTime=float(m.group(1))
            continue
            
        species.append(int(sys.argv[i]))
        
    # Make sure we got at least one species.
    if len(species) == 0:
        print "Error: at least one species must be specified."
        quit()
        
    # Configure Spark
    conf = SparkConf().setAppName("LM On Events Calculation")
    sc = SparkContext(conf=conf)

    # Execute Main functionality
    main(sc, outputDir, outputIndices, filename, onThreshold, species, skipTime, interactive)
