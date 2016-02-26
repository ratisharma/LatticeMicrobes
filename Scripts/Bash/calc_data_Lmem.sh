#!/bin/bash    

is=`seq -f "%g" 3 3`;
for i in $is, do
	qdel ${i};
done;
