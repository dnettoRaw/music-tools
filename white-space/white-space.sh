#!/bin/bah

#dnetto v0.0.1

for f in "$@" ; do 
	mv "$f" "${f// /-}"
done

# Path: white-space\white-space.sh