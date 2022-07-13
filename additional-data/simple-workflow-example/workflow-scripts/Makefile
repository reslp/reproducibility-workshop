
all: lower1.txt lower2.txt

combined%.txt: input%/*.txt 
	for file in $^; do \
		cat $$file >> $@; \
	done

lower%.txt: combined%.txt
	cat $^ | tr [:upper:] [:lower:] > $@

clean:
	rm -rf combined*.txt lower*.txt
