is=`seq -f "%g" 16604 1 16639`;
for i in $is; do
	qdel $i
done
