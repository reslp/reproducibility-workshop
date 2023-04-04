# Solutions for the exercises of the conda practical

## Creating the exported environment on a different computer:


First let us export the environments in different ways:

```
$ conda env export -n myenvironment > myenvironment.yml
$ conda env export -n myenvironment --no-builds > myenvironment_nobuilds.yml
$ conda env export -n myenvironment --from-history > myenvironment_fromhistory.yml



```
$ debian-alternative-miniconda
(base) $ conda env create -f myenvironment.yml # this will fail
(base) $ conda env create -f myenvironment_nobuilds.yml # this will fail
(base) $ conda env create -f myenvironment_fromhistory.yml # this will fail
```

Strange! The only thing that is different is the version of conda (you can check with `conda -V`). So what can we do to get mamba?
We have to modify the yml file. The easiest way is to modify the file `myenvironment_fromhistory.yml`. In this case we can see that the correct channel information about conda-forge is missing. Make sure that your yaml file looks like this after editing:

```
$ cat myenvironment_fromhistory.yml
name: myenvironment
channels:
  - defaults
  - conda-forge
dependencies:
  - mamba
prefix: /opt/conda/envs/myenvironment
```

Now the command should work:

```
(base) $ conda env create -f myenvironment_fromhistory.yml
```

## Incompatible packages from small channels

The issue has todo with unresolved dependencies and in how conda selects the version of the ete3 package. A way to resolve this is this:

```
$ conda create -n ete3 python=3.6
$ conda activate ete3
$ conda install -c etetoolkit ete3 ete_toolchain scipy
```

**Note:** This exercise does not work in a docker container (same as the R exercise).





