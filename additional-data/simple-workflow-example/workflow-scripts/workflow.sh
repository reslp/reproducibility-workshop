#!/usr/bin/env bash

for file in $(ls input/*.txt)
do
	cat $file >> combined.txt
done

cat combined.txt | tr [:upper:] [:lower:] > lower.txt

#alternative:
# cat combined.txt | tr A-Z a-z > lower.txt

