#!/usr/bin/env bash

   rm -f combined1.txt lower1.txt # remove output from previous runs

   files=$(ls input1/*.txt) # get input files (see 1 above)

   for file in $files # the for loop helps to combine the files (see 2 above)
   do
           cat $file >> combined1.txt
   done
   
   cat combined1.txt | tr [:upper:] [:lower:] > lower1.txt # convert the content of the intermediate file to lower case and pipe to lower.txt (see 3 and 4 above)
