#!/usr/bin/env python

import sys
import os
import h5py
import numpy
from numpy import *
from array import array
import random

#a=np.random.randinit(0, 5, size=(5, 4))
#print(random.randint(0,5)) 
#a=arange(81).reshape((3, 3, 3, 3))
#a=random(3,3,3,3)
#print(shape(a))
counts=zeros((3,3,3,5))

for L in range (0,5):
#b=a<3
#print(b)
#c=b.astype(int)
	#b=random.shuffle(a)
	#print(b)
	a=numpy.random.randint(10, size=(3,3,3,3))
	c=sum((a>5).astype(int),3)
	#print(c)
	i, j, k=c.nonzero()
	print("i=",i)
	print("j=",j)
	print("k=",k)
	if (len(i)==len(j)) & (len(j)==len(k)):
   	   for x in range(0,len(i)):
		print("length(i)",len(i))
		print(i[x],j[x],k[x])
		count=c[i[x],j[x],k[x]]
		print(count)
		counts[i[x],j[x],k[x],count]+=1
		print(counts[i[x],j[x],k[x],count])




# Calculate and save the pdf.
print(sum(counts,3))
#print(counts)
#print(counts[0,0,0,0])
#print(sum(counts,3)[0,0,0])
counts[:,:,:,0]=5-sum(counts,3)

print(counts)
#print(counts)
totalCounts=sum(counts,3)
#print(totalCounts)
pdf=zeros((3,3,3,5))
for x in range(0,shape(a)[0]):
    for y in range(0,shape(a)[1]):
        for z in range(0,shape(a)[2]):
	    #counts[x,y,z,0]=10-counts[x,y,z,:].sum(axis=1)
	    #counts[x,y,z,0]=10-sum(counts,3)
	    #print(counts) 
            for p in range(0,5):
		
                pdf[x,y,z,p]=float(counts[x,y,z,p])/totalCounts[x,y,z]
#print(pdf)
#cellsave(outputDir,pdf,indices);
                #pdf[x]
#print(counts)
#print("Binned %d data points for lattice size %s to %s"%(sum(counts),pdf.shape,outputDir))

