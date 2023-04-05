# Changing the make workflow to online include two files:

This is the content of the corresponding Makefile:

```
all: lower1.txt

combined1.txt: input1/A.txt input1/B.txt
	for file in $^; do \
		cat $$file >> combined1.txt; \
	done

lower1.txt: combined1.txt
	cat combined1.txt | tr [:upper:] [:lower:] > lower1.txt

clean:
	rm -rf combined1.txt lower1.txt
```

# Adding another rule to convert the file back to upper case:

```
all: upper1.txt

combined1.txt: input1/*.txt
        for file in $^; do \
                cat $$file >> combined1.txt; \
        done

lower1.txt: combined1.txt
        cat combined1.txt | tr [:upper:] [:lower:] > lower1.txt

upper1.txt: lower1.txt
	cat lower1.txt |  tr [:lower:] [:upper:] > upper1.txt

clean:
        rm -rf combined1.txt lower1.txt upper1.txt
```

# Extending the make workflow to include three directories:

You will also need a third directory called `input3` containing upper case files.

```
all: lower1.txt lower2.txt lower3.txt

combined%.txt: input%/*.txt
        for file in $^; do \
                cat $$file >> $@; \
        done

lower%.txt: combined%.txt
        cat $^ | tr [:upper:] [:lower:] > $@

clean:
        rm -rf combined*.txt lower*.txt
```

# Extending the workflow so that it includes three directories (and a new combine rule):

```
all: combineall.txt

combined%.txt: input%/*.txt
        for file in $^; do \
                cat $$file >> $@; \
        done

lower%.txt: combined%.txt
        cat $^ | tr [:upper:] [:lower:] > $@

combineall.txt: lower*.txt
        cat $^ > $@

clean:
        rm -rf combined*.txt lower*.txt combineall.txt
```

# Create a snakemake rulegraph:

```
snakemake --rulegraph | dot -Tpdf > myrulegraph.pdf
```
