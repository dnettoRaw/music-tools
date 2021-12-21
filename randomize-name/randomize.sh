#!/bin/bash

# dnetto v0.0.1

declare -a files

#this function generate txt file with original names and ranme all files to numerical suite 

# on error scape script whitout initialize that
[[ "$#" -lt 1 ]] && echo -e "imput error\n\$>$0 *.mp3" && exit

# source https://askcodez.com/methode-simple-pour-melanger-les-elements-dun-tableau-dans-le-shell-bash.html
shuffle() {
   local i tmp size max rand

   # $RANDOM % (i+1) is biased because of the limited range of $RANDOM
   # Compensate by using a range which is a multiple of the array size.
   size=${#files[*]}
   max=$(( 32768 / size * size ))

   for ((i=size-1; i>0; i--)); do
      while (( (rand=$RANDOM) >= max )); do :; done
      rand=$(( rand % (i+1) ))
      tmp=${files[i]} files[i]=${files[rand]} files[rand]=$tmp
   done
}

files=($@)
shuffle

for i in ${files[@]} ; do
    # mv ${files[$i]} $i
    printf '%3d -=- %s\n' $i ${files[$i]}
done 