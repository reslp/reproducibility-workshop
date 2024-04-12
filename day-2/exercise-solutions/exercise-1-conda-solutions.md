# Solutions for the exercises of the conda practical

## Creating the exported environment on a different computer:

First lets create an environment and install mamba into it:

```
$ conda create -n mamba
$ conda install mamba=0.23.3
```


Now let us export the environments in different ways:

```
$ conda env export -n mamba > mamba.yml
$ conda env export -n mamba --no-builds > mamba_nobuilds.yml
$ conda env export -n mamba --from-history > mamba_fromhistory.yml
```


```
$ debian-alternative-miniconda
(base) $ conda env create -f mamba.yml # this will fail
(base) $ conda env create -f mamba_nobuilds.yml # this will fail
(base) $ conda env create -f mamba_fromhistory.yml # this will fail (sometimes; depending on conda version)
```
The environment will have to be removed after each attempt.


Strange! The only thing that is different is the version of conda (you can check with `conda -V`). So what can we do to get mamba?
We have to modify the yml file. The easiest way is to modify the file `mamba_fromhistory.yml`. In this case we can see that the correct channel information about conda-forge is missing. Make sure that your yaml file looks like this after editing:

```
$ cat mamba_fromhistory.yml
name: mamba
channels:
  - defaults
  - conda-forge
dependencies:
  - mamba
prefix: /opt/conda/envs/mamba
```

Now the command should work:

```
(base) $ conda env create -f mamba_fromhistory.yml
```

## Incompatible packages from small channels

The issue has to do with unresolved dependencies and in how conda selects the version of the ete3 package. A way to resolve this is this:

```
$ conda create -n ete3 python=3.6
$ conda activate ete3
$ conda install -c etetoolkit ete3 ete_toolchain scipy
```

**Note:** This exercise does not work in a docker container (same as the R exercise).





