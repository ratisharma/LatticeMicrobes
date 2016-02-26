## Spark Application - execute with spark-submit, e.g.
## spark-submit --master yarn-client --num-executors 16 --driver-memory 1g --executor-memory 1g --executor-cores 1 --jars ~/Work/Lab/Git/roberts-lab/Code/Hadoop/lib/robertslab-hadoop.jar ~/Work/Lab/Git/roberts-lab/Scripts/pyspark/sp_calc_lm_stationary_pdf.py pdf.dat "(0,)" /user/erober32/tmp/pdf3.sfile --skip_less_than=1.0 0 1 2 3 4 5 6 --interactive
## spark-submit --master yarn-client --num-executors 16 --driver-memory 1g --executor-memory 1g --executor-cores 1 --jars ~/Work/Lab/Git/roberts-lab/Code/Hadoop/lib/robertslab-hadoop.jar ~/Work/Lab/Git/roberts-lab/Scripts/pyspark/sp_calc_lm_stationary_pdf.py pdf.dat "(0,)" /user/erober32/tmp/pdf4*.sfile --skip_less_than=1e1 0 --interactive
## spark-submit --master yarn-client --num-executors 16 --driver-memory 1g --executor-memory 1g --executor-cores 1 --jars ~/Work/Lab/Git/roberts-lab/Code/Hadoop/lib/robertslab-hadoop.jar ~/Work/Lab/Git/roberts-lab/Scripts/pyspark/sp_calc_lm_stationary_pdf.py pdf.dat "(0,)" /user/erober32/tmp/pdf6.sfile --skip_less_than=1e1 0 --interactive
## spark-submit --master yarn-client --num-executors 16 --driver-memory 1g --executor-memory 1g --executor-cores 1 --jars ~/Work/Lab/Git/roberts-lab/Code/Hadoop/lib/robertslab-hadoop.jar ~/Work/Lab/Git/roberts-lab/Scripts/pyspark/sp_calc_lm_stationary_pdf.py pdf.dat "(0,)" /user/erober32/tmp/pdf7.sfile --skip_less_than=1e1 0 --interactive
##
try:
    from pyspark import SparkConf, SparkContext
except:
    print "No spark libraries found, ensure you are running locally."
    from robertslab.helper.sparkLocalHelper import SparkLocalGlobal
    from robertslab.sfile import SFile

from argparse import ArgumentParser
from ast import literal_eval as make_tuple
import cStringIO
import math
import matplotlib.pyplot as plt
import numpy as np
import os,sys
import re
from scipy.stats import norm
import time
from timeit import default_timer as timer
import zlib
import pickle

import robertslab.cellio as cellio
from robertslab.helper.sparkProfileHelper import SparkProfileDecorator
import robertslab.pbuf.NDArray_pb2 as NDArray_pb2
import lm.io.SpeciesCounts_pb2 as SpeciesCounts_pb2
import lm.io.SpeciesTimeSeries_pb2 as SpeciesTimeSeries_pb2

# Global variables.
globalSpeciesList=None
globalReplicates=None

print "Running in spark."
def main_spark(sc, outputDir, outputIndices, filename, replicates, speciesList, interactive):
    
    global globalSpeciesList, globalReplicates
    
    # Broadcast the global variables.
    globalSpeciesList=sc.broadcast(speciesList)
    globalReplicates=sc.broadcast(replicates)
    
    # Load the records from the sfile.
    allRecords = sc.newAPIHadoopFile(filename, "robertslab.hadoop.io.SFileInputFormat", "robertslab.hadoop.io.SFileHeader", "robertslab.hadoop.io.SFileRecord", keyConverter="robertslab.spark.sfile.SFileHeaderToPythonConverter", valueConverter="robertslab.spark.sfile.SFileRecordToPythonConverter")

    # Bin the species counts records and sum across all of the bins.
    results = allRecords.filter(filterReplicatesAndRecordType).map(extractTimeSeries).reduce(combineTimeSeriesSpark)

    #.reduceByKey(addLatticeBins).values().collect()

    # Save the time series in hdf5 file format.
    print "len of species list = " + str(len(speciesList))
    print "size of results = " +str(len(results))
    #print "size of results[0] = " +str(len(results[0][0])) + " " +str(len(results[0][1]))
    #print "size of results[1] = " + str(len(results[1]))
    pickle.dump(results, open("analysis/pdf.dat/time_series_gradient_t1000_rep1.p", "wb"))
    #combinedRecords = combineRecordsSpark(results)
    #saveRecords(outputDir, outputIndices, combinedRecords)  

    # Save the pdfs into a .mat file in the output directory named according to the output indices.
    #pdfs=np.zeros((len(speciesList),),dtype=object)
    #print "len of species list = " + str(len(speciesList))
    #print "size of results = " +str(len(results[0]))
    #for i in replicates:
	#print "replicate = " +str(i)
        #minCount=results[i][0]
        #maxCount=results[i][1]
	#print str(len(minCount))
	#print str(len(maxCount))
        #bins=results[i][2]
        #pdf = np.zeros((len(bins),2),dtype=float)
        #pdf[:,0]=np.arange(minCount,maxCount+1).astype(float)
        #pdf[:,1]=bins.astype(float)/float(sum(bins))
        #pdfs[i] = pdf
        #print "Binned species %d: %d data points from %d to %d into %s"%(speciesToBin[i],sum(bins),minCount,maxCount,outputDir)
    #cellio.cellsave(outputDir,pdfs,outputIndices)


def main_local(outputDir, outputIndices, filename, replicates, speciesList, interactive):

    global globalSpeciesList, globalReplicates

    # Broadcast the global variables.
    globalSpeciesList=SparkLocalGlobal(speciesList)
    globalReplicates=SparkLocalGlobal(replicates)

    # Open the file.
    fp = SFile.fromFilename(filename, "r")

    # Loop through the records.
    reducedRecords = {}
    while True:
        rawRecord = fp.readNextRecord()
        if rawRecord is None: break

        # Filter the record.
        sparkRecord = [(rawRecord.name,rawRecord.dataType)]
        if filterReplicatesAndRecordType(sparkRecord):
            sparkRecord.append(fp.readDataRaw(rawRecord.dataSize))
            mapRecord = extractTimeSeries(sparkRecord)
            replicate = mapRecord[0]
            if replicate not in reducedRecords: reducedRecords[replicate] = (replicate,([],[]))
            reducedRecords[replicate] = combineTimeSeries(reducedRecords[replicate], mapRecord)
            print "Processed replicate %d with %d records"%(replicate,len(reducedRecords[replicate][1][0]))
        else:
            fp.skipData(rawRecord.dataSize)

    combinedRecords = combineRecords(reducedRecords)
    saveRecords(outputDir, outputIndices, combinedRecords)

def combineRecords(reducedRecords):

    combinedRecords={}
    for replicate in reducedRecords.keys():
        (times,counts)=reducedRecords[replicate][1]
        numberRows = 0
        for time in times:
            numberRows += time.shape[0]
        allTimes = np.zeros((numberRows))
        allCounts = np.zeros((numberRows,counts[0].shape[1]))
        start=0
        end=0
        for i in range(0, len(times)):
            end += times[i].shape[0]
            allTimes[start:end] = times[i]
            allCounts[start:end,:] = counts[i]
            start += times[i].shape[0]
        combinedRecords["/%d/Times"%(replicate)] = allTimes
        combinedRecords["/%d/Counts"%(replicate)] = allCounts

    return combinedRecords


def saveRecords(outputDir, outputIndices, records):

    cellio.cellsave(outputDir, records, outputIndices, format="hdf5")
    # Save the pdfs into a .mat file in the output directory named according to the output indices.
    #pdfs=np.zeros((len(speciesList),),dtype=object)
    #for i in range(0,len(speciesList)):
    ##    minCount=results[i][0]
    #    maxCount=results[i][1]
    #    bins=results[i][2]
    #    pdf = np.zeros((len(bins),2),dtype=float)
    #    pdf[:,0]=np.arange(minCount,maxCount+1).astype(float)
    #    pdf[:,1]=bins.astype(float)/float(sum(bins))
    #    pdfs[i] = pdf
    #    print "Binned species %d: %d data points from %d to %d into %s"%(speciesToBin[i],sum(bins),minCount,maxCount,outputDir)
    #cellio.cellsave(outputDir,pdfs,outputIndices)

def filterReplicatesAndRecordType(record):

    global globalReplicates

    # Get the global variables.
    replicates = globalReplicates.value

    # Extract the data.
    (name,dataType)=record[0]

    # Make sure the record and and type are correct.
    if dataType == "protobuf:lm.io.SpeciesCounts":
        m=re.match("/Simulations/(\d+)/SpeciesCounts",name)
        if m is not None and int(m.group(1)) in replicates:
            return True
    elif dataType == "protobuf:lm.io.SpeciesTimeSeries":
        m=re.match("/Simulations/(\d+)/SpeciesTimeSeries",name)
        if m is not None and int(m.group(1)) in replicates:
            return True
    return False


def extractTimeSeriesSpark(record):

    global globalSpeciesList

    # Parse the data.
    (name,dataType)=record[0]
    data=record[1]

    # If this is a SpeciesCounts object, extract the data.
    if dataType == "protobuf:lm.io.SpeciesCounts":
        m=re.match("/Simulations/(\d+)/SpeciesCounts",name)
        if m is None:
            raise ValueError("Invalid record, no replicate number.")
        replicateNumber=int(m.group(1))

        # Deserialize the data.
        obj=SpeciesCounts_pb2.SpeciesCounts()
        obj.ParseFromString(str(data))

        # If there are no entries, return an empty set.
        if obj.number_entries == 0:
            return (((replicateNumber,(None,None))))

        # Convert the data to a numpy array.
        species_counts=np.zeros((obj.number_entries*obj.number_species,),dtype=int)
        for i,val in enumerate(obj.species_count):
            species_counts[i] = val
        species_counts.shape=(obj.number_entries,obj.number_species)
        times=np.zeros((obj.number_entries,),dtype=float)
        for i,val in enumerate(obj.time):
            times[i] = val
        #print "rati message: extract replicate and time series = " + str((replicateNumber,(times,species_counts)))
	return (replicateNumber,(times,species_counts))

    # If this is a SpeciesTimeSeries object, extract the data.
    elif dataType == "protobuf:lm.io.SpeciesTimeSeries":
        m=re.match("/Simulations/(\d+)/SpeciesTimeSeries",name)
        if m == None:
            raise ValueError("Invalid record, no replicate number.")
        replicateNumber=int(m.group(1))

        # Deserialize the data.
        obj=SpeciesTimeSeries_pb2.SpeciesTimeSeries()
        obj.ParseFromString(str(data))

        # Make sure the data is consistent.
        if len(obj.counts.shape) != 2 or len(obj.times.shape) != 1:
            raise ValueError("Invalid array shape.")
        if obj.counts.shape[0] != obj.times.shape[0]:
            raise ValueError("Inconsistent array sizes.")
        if obj.counts.data_type != NDArray_pb2.NDArray.int32 or obj.times.data_type != NDArray_pb2.NDArray.float64:
            raise TypeError("Invalid array data types.")

        # If there are no entries, return an empty set.
        if obj.counts.shape[0] == 0:
            return (replicateNumber,(None,None))

        # Convert the data to a numpy array.
        if obj.counts.compressed_deflate:
            species_counts=np.reshape(np.fromstring(zlib.decompress(obj.counts.data), dtype=np.int32), obj.counts.shape)
        else:
            species_counts=np.reshape(np.fromstring(obj.counts.data, dtype=np.int32), obj.counts.shape)
        if obj.times.compressed_deflate:
            times=np.reshape(np.fromstring(zlib.decompress(obj.times.data), dtype=np.float64), obj.times.shape)
        else:
            times=np.reshape(np.fromstring(obj.times.data, dtype=np.float64), obj.times.shape)
            #print "rati message: extract replicate and time series = " + str((replicateNumber,(times,species_counts)))
            return (replicateNumber,(times,species_counts))

    return None
    

def extractTimeSeries(record):

    global globalSpeciesList

    # Parse the data.
    (name,dataType)=record[0]
    data=record[1]
    
    # If this is a SpeciesCounts object, extract the data.
    if dataType == "protobuf:lm.io.SpeciesCounts":
        m=re.match("/Simulations/(\d+)/SpeciesCounts",name)
        if m is None:
            raise ValueError("Invalid record, no replicate number.")
        replicateNumber=int(m.group(1))
        
        # Deserialize the data.
        obj=SpeciesCounts_pb2.SpeciesCounts()
        obj.ParseFromString(str(data))
            
        # If there are no entries, return an empty set.
        if obj.number_entries == 0:
            return (replicateNumber,(None,None))
        
        # Convert the data to a numpy array.
        species_counts=np.zeros((obj.number_entries*obj.number_species,),dtype=int)
        for i,val in enumerate(obj.species_count):
            species_counts[i] = val
        species_counts.shape=(obj.number_entries,obj.number_species)
        times=np.zeros((obj.number_entries,),dtype=float)
        for i,val in enumerate(obj.time):
            times[i] = val
	#print "rati message: extract replicate and time series = " + str((replicateNumber,(times,species_counts)))
        return (replicateNumber,(times,species_counts))

    # If this is a SpeciesTimeSeries object, extract the data.
    elif dataType == "protobuf:lm.io.SpeciesTimeSeries":
        m=re.match("/Simulations/(\d+)/SpeciesTimeSeries",name)
        if m == None:
            raise ValueError("Invalid record, no replicate number.")
        replicateNumber=int(m.group(1))
    
        # Deserialize the data.
        obj=SpeciesTimeSeries_pb2.SpeciesTimeSeries()
        obj.ParseFromString(str(data))
        
        # Make sure the data is consistent.
        if len(obj.counts.shape) != 2 or len(obj.times.shape) != 1:
            raise ValueError("Invalid array shape.")
        if obj.counts.shape[0] != obj.times.shape[0]:
            raise ValueError("Inconsistent array sizes.")
        if obj.counts.data_type != NDArray_pb2.NDArray.int32 or obj.times.data_type != NDArray_pb2.NDArray.float64:
            raise TypeError("Invalid array data types.")
            
        # If there are no entries, return an empty set.
        if obj.counts.shape[0] == 0:
            return (replicateNumber,(None,None))
    
        # Convert the data to a numpy array.
        if obj.counts.compressed_deflate:
            species_counts=np.reshape(np.fromstring(zlib.decompress(obj.counts.data), dtype=np.int32), obj.counts.shape)
        else:
            species_counts=np.reshape(np.fromstring(obj.counts.data, dtype=np.int32), obj.counts.shape)
        if obj.times.compressed_deflate:
            times=np.reshape(np.fromstring(zlib.decompress(obj.times.data), dtype=np.float64), obj.times.shape)
        else:
            times=np.reshape(np.fromstring(obj.times.data, dtype=np.float64), obj.times.shape)
	    #print "rati message: extract replicate and time series = " + str((replicateNumber,(times,species_counts)))
            return (replicateNumber,(times,species_counts))

    return None

def combineTimeSeriesSpark(data1, data2):

    print "rati message: started combineTimeSeriesSpark"
    # Make sure we have some new data.
    if data1 is None:
	#print "rati message: returning data2."
	return data2
    if data2 is None:
	#print "rati message: returning data1"
	return data1
    if len(data1) != 2 or len(data1[1]) != 2:
	#print "rati message: len(data1) = " +str(len(data1))
	#print "rati message: data1 = " + str(data1)
	#print "rati message: len!=2 for data1. returning data2."
	return data2
    if len(data2) != 2 or len(data2[1]) != 2:
	#print "rati message: len(data2) = " +str(len(data2))
        #print "rati message: data2 = " + str(data2)
	#print "rati message: len!=2 for data2. returning data1."
	return data1
    if data1[1][0] is None:
	#print "rati message: data1[1][0] is none. returning data2."
	return data2
    if data2[1][0] is None:
	#print "rati message: data2[1][0] is none. returning data1."
	return data1

    print "rati message: Next stage -- making sure replicate is the same"
    # Make sure the replicate is the same.
    replicate = data1[0]
    if data2[0] != replicate:
	raise Exception("rati message Error: tried to combine times series for replciates %d and %d"%(replicate,data2[0]))
    else:
	print "rati message: data2 and data1 have same replicates."

    # See if these are two raw records.
    if isinstance(data1[1][0],np.ndarray) and isinstance(data2[1][0],np.ndarray):
	#print "rati message: data1[1][0] and data2[1][0] are np.ndarray."
        accumulator_times = [data1[1][0]]
        accumulator_counts = [data1[1][1]]
        new_times = data2[1][0]
        new_counts = data2[1][1]
    elif isinstance(data1[1][0],list) and isinstance(data2[1][0],np.ndarray):
	#print "rati message: data1[1][0] is a list and data2[1][0] is an np.ndarray."
        accumulator_times = data1[1][0]
        accumulator_counts = data1[1][1]
        new_times = data2[1][0]
        new_counts = data2[1][1]
    elif isinstance(data1[1][0],np.ndarray) and isinstance(data2[1][0],list):
	#print "rati message: data1[1][0] is an np.ndarray and data2[1][0] is a list."
        accumulator_times = data2[1][0]
        accumulator_counts = data2[1][1]
        new_times = data1[1][0]
        new_counts = data1[1][1]
    elif isinstance(data1[1][0],list) and isinstance(data2[1][0],list):
	print "rati message: data1[1][0] and data2[1][0] are lists."
	accumulator_times = data1[1][0]
	accumulator_counts = data1[1][1]
	#print "rati message: accumulator_times = " + str(accumulator_times)
	new_times = data2[1][0]
	new_counts = data2[1][1]
	#print "rati message: new_times = " + str(new_times)
        # Combine the list and we are done.
	# Find the position where the new records should be added in the list.
	added = False
    	#print "rati message: len(accumulator_times) = " +str(len(accumulator_times))+ " accumulator_times[0][0] = " +str(accumulator_times[0][0])
    	#print "rati message: new_times[-1] = " +str(new_times[-1])
    	for i in range(0, len(accumulator_times)):
	    if len(new_times[-1]) == 1:
		ntime = new_times[-1][0]
	    else:
		ntime = new_times[-1][-1]
	    if len(accumulator_times[i]) == 1:
		atime = accumulator_times[i][0]
	    else:
		atime = accumulator_times[i][-1]
            #print "rati message: ntime  = " +str(ntime)
	    #print "rati message: atime = " + str(atime)
	    if ntime < atime:
		#print "rati message: index of insertion = " + str(i)
            	accumulator_times[i:i] = new_times
                accumulator_counts[i:i] = new_counts
            	added = True
            	#print "rati message: new_times added to accumulator_times."
            	break
    	if not added:
            #print "rati message: new_times not added to accumulator_times."
            accumulator_times.extend(new_times)
            accumulator_counts.extend(new_counts)
    	#print "rati message: check if new times is added = " + str(accumulator_times[len(accumulator_times)-1][0])
    	#print "rati message: (replicate, (accumulator_times, accumulator_counts)) = " + str((replicate,(accumulator_times,accumulator_counts)))
    	#print "rati message: len(accumulator_times) = " + str(len(accumulator_times[0]))
    	#print "rati message: len(accumulator_counts) = " + str(len(accumulator_counts[0]))
    	return (replicate,(accumulator_times,accumulator_counts))

        #raise "Error: not yet implemented."
    else:
        raise "Error: could not determine the record types for the map operation."

    # Find the position where the new records should be added in the list.
    added = False
    #print "rati message: len(accumulator_times) = " +str(len(accumulator_times))+ " accumulator_times[0][0] = " +str(accumulator_times[0][0])
    #print "rati message: new_times[-1] = " +str(new_times[-1])
    for i in range(0, len(accumulator_times)):
	#print "rati message: len(accumulator_times) = " +str(new_times[-1])
        if new_times[-1] < accumulator_times[i][0]:
            accumulator_times.insert(i, new_times)
            accumulator_counts.insert(i, new_counts)
            added = True
	    print "rati message: new_times added to accumulator_times."
            break
    if not added:
	print "rati message: new_times not added to accumulator_times."
        accumulator_times.append(new_times)
        accumulator_counts.append(new_counts)
    #print "rati message: check if new times is added = " + str(accumulator_times[len(accumulator_times)-1][0])
    #print "rati message: (replicate, (accumulator_times, accumulator_counts)) = " + str((replicate,(accumulator_times,accumulator_counts)))
    #print "rati message: len(accumulator_times) = " + str(len(accumulator_times[0]))
    #print "rati message: len(accumulator_counts) = " + str(len(accumulator_counts[0]))
    return (replicate,(accumulator_times,accumulator_counts))


def combineTimeSeries(data1, data2):

    # Make sure we have some new data.
    if data1 is None: return data2
    if data2 is None: return data1
    if len(data1) != 2 or len(data1[1]) != 2: return data2
    if len(data2) != 2 or len(data2[1]) != 2: return data1
    if data1[1][0] is None: return data2
    if data2[1][0] is None: return data1

    # Make sure the replicate is the same.
    replicate = data1[0]
    if data2[0] != replicate: raise "Error: tried to combine times series for replciates %d and %d"%(replicate,data2[0])

    # See if these are two raw records.
    if isinstance(data1[1][0],np.ndarray) and isinstance(data2[1][0],np.ndarray):
        accumulator_times = [data1[1][0]]
        accumulator_counts = [data1[1][1]]
        new_times = data2[1][0]
        new_counts = data2[1][1]
    elif isinstance(data1[1][0],list) and isinstance(data2[1][0],np.ndarray):
        accumulator_times = data1[1][0]
        accumulator_counts = data1[1][1]
        new_times = data2[1][0]
        new_counts = data2[1][1]
    elif isinstance(data1[1][0],np.ndarray) and isinstance(data2[1][0],list):
        accumulator_times = data2[1][0]
        accumulator_counts = data2[1][1]
        new_times = data1[1][0]
        new_counts = data1[1][1]
    elif isinstance(data1[1][0],list) and isinstance(data2[1][0],list):

        # Combine the list and we are done.

        raise "Error: not yet implemented."
    else:
        raise "Error: could not determine the record types for the map operation."

    # Find the position where the new records should be added in the list.
    added = False
    for i in range(0, len(accumulator_times)):
        if new_times[-1] < accumulator_times[i][0]:
            accumulator_times.insert(i, new_times)
            accumulator_counts.insert(i, new_counts)
            added = True
            break
    if not added:
        accumulator_times.append(new_times)
        accumulator_counts.append(new_counts)

    return (replicate,(accumulator_times,accumulator_counts))



if __name__ == "__main__":
    
    if len(sys.argv) < 7:
        print "Usage: output_dir output_indices hdfs_sfile min_replicate max_replicate species+ [--local] [--interactive]"
        quit()

    outputDir = sys.argv[1]
    outputIndices = make_tuple(sys.argv[2])
    if type(outputIndices) != type((0,)):
        print "Error: output indices must be specified in as a python formatted tuple, got: %s"%(type(outputIndices))
        quit()
    filename = sys.argv[3]
    replicates = range(int(sys.argv[4]),int(sys.argv[5])+1)
    print "replicates = " +str(replicates)
    time.sleep(2)
    species = []
    interactive = False
    local = False
    for i in range(6,len(sys.argv)):
        if sys.argv[i] == "--interactive":
            interactive=True
            continue

        if sys.argv[i] == "--local":
            local=True
            continue

        species.append(int(sys.argv[i]))

    # Make sure we got at least one species.
    if len(species) == 0:
        print "Error: at least one species must be specified."
        quit()

    # Execute Main functionality
    if not local:
        conf = SparkConf().setAppName("LM Time Series")
        sc = SparkContext(conf=conf)
        main_spark(sc, outputDir, outputIndices, filename, replicates, species, interactive)
    else:
        main_local(outputDir, outputIndices, filename, replicates, species, interactive)
