# Some possible solutions:

## Using tr

```
cat input1/*.txt | tr [:upper:] [:lower:] > lower1.txt
```

## Using sed

```
cat input1/*.txt | sed -e 's/\(.*\)/\L\1/' > lower1.txt
```

## Using awk

```
cat input1/*.txt | awk '{print tolower($0)}' > lower1.txt
```

