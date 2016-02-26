import os
import pickle
import numpy as np
import matplotlib.pyplot as plt
import robertslab.cellio as cellio
#from skimage import io, filter

results = pickle.load(open('../pdf.dat/rdme_time_series_gradient.p','rb'))
outputDir = "../pdf.dat"
outputIndices = (2,)
# results = pickle.load(open('../pdf.dat/pdfs_gradient.p','rb'))

# for key in results.keys():
#     print key
#     sizeArray = len(results[key])
#     print sizeArray
#     x= np.zeros((sizeArray,1))
#     pdf = np.zeros((sizeArray,1))
#     for i in range(0,sizeArray):
#         x[i] = results[key][i][0]
#         pdf[i] = results[key][i][1]
#     plt.figure()
#     plt.plot(x,pdf)
#     plt.show()

# print results['/0']

# print len(results[0][1])
# print results
# print results[0][1][3]
# plt.figure()
# plt.plot(results[0][0],results[0][1][0])
# plt.show()

def combineRecords(reducedRecords):

    combinedRecords={}
    for replicate in range(len(reducedRecords)):
        print replicate
        (times,counts)=reducedRecords[replicate]
        print len(counts[0])
        print len(times)
        numberRows = 0
        for time in times:
            # print time
            numberRows += 1
            # time.shape[0]
        allTimes = np.zeros((numberRows))
        allCounts = np.zeros((numberRows,len(counts[0])))
        start=0
        end=0
        for i in range(0, len(times)):
            end += 1
            allTimes[start:end] = times[i]
            allCounts[start:end,:] = counts[i]
            start += 1
        combinedRecords["/%d/Times"%(replicate)] = allTimes
        combinedRecords["/%d/Counts"%(replicate)] = allCounts

    return combinedRecords

def combineRecordsSingle(reducedRecords):

    combinedRecords={}
    replicate = 1
    print replicate
    (times,counts)=reducedRecords[1]
    # (times,counts)=reducedRecords[replicate]
    print len(counts[0])
    print len(times)
    numberRows = 0
    for time in times:
        # print time
        numberRows += time.shape[0]
        # time.shape[0]
    allTimes = np.zeros((numberRows,1))
    allCounts = np.zeros((numberRows,7))
    start=0
    end=0
    for i in range(0, len(times)):
        print str(len(times[i]))
        for j in range(0,len(times[i])):
            end += 1
            allTimes[start:end] = times[i][j]
            # print len(allTimes)
            print counts[i][j]
            allCounts[start:end,:] = counts[i][j]
            start += 1
    combinedRecords["/%d/Times"%(replicate)] = allTimes
    combinedRecords["/%d/Counts"%(replicate)] = allCounts

    return combinedRecords

def combineRdmeRecordsSingle(reducedRecords):

    combinedRecords={}
    replicate = 1
    print replicate
    (times,lattices)=reducedRecords[1]
    # (times,counts)=reducedRecords[replicate]
    print len(lattices[0])
    print len(times)
    numberRows = 0
    for time in times:
        # print time
        numberRows += time.shape[0]
        # time.shape[0]
    allTimes = np.zeros((numberRows,))
    start=0
    end=0
    for i,time in enumerate(times):
        print str(len(times[i]))
        end += time.shape[0]
        print end
        print time
        allTimes[start:end] = time
        for j,lattice in enumerate(lattices[i]):
            combinedRecords["/%d/Lattice/%d"%(replicate,start+j)] = lattice
        start += time.shape[0]
    combinedRecords["/%d/Times"%(replicate)] = allTimes

    return combinedRecords

def saveRecords(outputDir, outputIndices, records):

    cellio.cellsave(outputDir, records, outputIndices, format="hdf5")

combinedRecords = combineRdmeRecordsSingle(results)
saveRecords(outputDir, outputIndices, combinedRecords)
