#!/bin/bash

# This script is used to rename files in a directory  
# he take the name of file and remove the first 3 characters

for file in $@; do
    mv "$file" "${file:4}"
done