.. role:: bash(code)
   :language: bash

=================================
Exercise 1 - Virtual environments
=================================

In recent years virtual environments have become more and more common in bioinformatics and scientific computing. Researchers work with many different software packages and may depend on specific versions for their code to run. This problem is intensified when working on remote servers or high performance computing clusters because usually on these systems regular users will have no possibility to install their own software system wide (eg. with :bash:`sudo apt-get` or similar). In both these scenarios virtual environment software can help. Virtual environments are typically run and/or installed locally in the context of a single user and do not interfer with software installed globally on the respective machine.

.. hint::

    There are different variants of virtual environments each with its own strengths, weaknesses and use cases. Some promiment examples include `python venv <https://docs.python.org/3/library/venv.html>`_ for all things in the python ecosystem, `environment modules <https://modules.readthedocs.io/en/latest/index.html>`_ which are often used on HPC clusters to load different software.


A now very common way to work with virtual environments is `conda <https://www.anaconda.com/>`_. Conda provides convenient handling of virtual environments and it serves as an installer for many open-sources tools used in bioinformatics, statistics, machine-learning etc. In the conda ecosystem software which should be installed are called packages. Packages are somewhat loosely group by topic which are called channels. Common channels containing bioinformatic packages are :bash:`bioconda` and :bash:`conda-forge`. Conda offers version controlled installation and works without administrator privileges on most operating systems.

.. warning::

   Although conda is a convenient tool, we would like to point out already here that it comes with several issues that can prevent full reproducibility and can cause different, sometimes very difficult to solve problems. It is important to keep this in mind when relying on conda environments in your work. We will highlight some of the problems you may come across and how to solve them.

Working with conda
==================

We will now learn how to work with :bash:`conda`. It should already be installed on our AWS instance:

.. code-block:: bash

   $ conda
   usage: conda [-h] [-V] command ...
    
    conda is a tool for managing and deploying applications, environments and packages.
    
    Options:
    
    positional arguments:
      command
        clean        Remove unused packages and caches.
        config       Modify configuration values in .condarc. This is modeled
                     after the git config command. Writes to the user .condarc
                     file (/home/reslp/.condarc) by default.
        create       Create a new conda environment from a list of specified
                     packages.
        help         Displays a list of available conda commands and their help
                     strings.
        info         Display information about current conda install.
        init         Initialize conda for shell interaction. [Experimental]
        install      Installs a list of packages into a specified conda
                     environment.
        list         List linked packages in a conda environment.
        package      Low-level conda package utility. (EXPERIMENTAL)
        remove       Remove a list of packages from a specified conda environment.
        uninstall    Alias for conda remove.
        run          Run an executable in a conda environment. [Experimental]
        search       Search for packages and display associated information. The
                     input is a MatchSpec, a query language for conda packages.
                     See examples below.
        update       Updates conda packages to the latest compatible version.
        upgrade      Alias for conda update.
    
    optional arguments:
      -h, --help     Show this help message and exit.
      -V, --version  Show the conda version number and exit.
    
    conda commands available from other packages:
      env


As you can see conda offeres different commands to create and remove environments or install and uninstall packages. Let us first see which version of conda we have running.

.. hint::

   There are different distribution of conda which all use the ``conda`` executable. We have installed `miniconda <https://docs.conda.io/en/latest/miniconda.html>`_ which is the minimal version of conda. You may also come across anaconda. Anaconda comes with a larger number of preinstalled packages. We recommend using miniconda instead of anaconda. Especially if you want to install additional packages, dependency errors between packages could cause troubles in anaconda.

.. code-block:: bash

   $ conda -V
   conda 4.8.3


Additionally you can get a more detailed account of your conda installation by running :bash:`conda info`.

.. code-block:: bash

    $ conda info
         active environment : None
                shell level : 0
           user config file : /home/user/.condarc
     populated config files : /home/user/.condarc
              conda version : 4.8.3
        conda-build version : not installed
             python version : 3.7.7.final.0
           virtual packages : __glibc=2.27
           base environment : /home/user/.miniconda3  (writable)
               channel URLs : https://conda.anaconda.org/bioconda/linux-64
                              https://conda.anaconda.org/bioconda/noarch
                              https://repo.anaconda.com/pkgs/main/linux-64
                              https://repo.anaconda.com/pkgs/main/noarch
                              https://repo.anaconda.com/pkgs/r/linux-64
                              https://repo.anaconda.com/pkgs/r/noarch
              package cache : /home/user/.miniconda3/pkgs
                              /home/user/.conda/pkgs
           envs directories : /home/user/.miniconda3/envs
                              /home/user/.conda/envs
                   platform : linux-64
                 user-agent : conda/4.8.3 requests/2.23.0 CPython/3.7.7 Linux/5.4.0-73-generic ubuntu/18.04.5 glibc/2.27
                    UID:GID : 1000:1000
                 netrc file : None
               offline mode : False

.. tip::

   Using the same conda version is the first important bit to ensure reproducibility when working with conda.

Our first environment
---------------------

Let us create a first conda environment:

.. code-block:: bash

   $ conda create -n myenvironment
   Collecting package metadata (current_repodata.json): done
   Solving environment: done
   
   
   ==> WARNING: A newer version of conda exists. <==
     current version: 4.8.3
     latest version: 4.13.0
   
   Please update conda by running
   
       $ conda update -n base -c defaults conda
   
   
   
   ## Package Plan ##
   
     environment location: /home/reslp/.miniconda3/envs/myenvironment
   
   
   
   Proceed ([y]/n)? y
   
   Preparing transaction: done
   Verifying transaction: done
   Executing transaction: done
   #
   # To activate this environment, use
   #
   #     $ conda activate myenvironment
   #
   # To deactivate an active environment, use
   #
   #     $ conda deactivate
  
After creating the environment we can now activate it:

.. code-block:: bash

   $ conda activate myenvironment
   (myenvironment) $

When you run the :bash:`conda activate` command, you will see that your command prompt changes. This tells you that you are now working in the virtual environment :bash:`myenvironment`. In this environment we can now start to install other conda packages.

.. code-block:: bash

   (myenvironment) $ conda install -c conda-forge mamba=0.24.0
   # output of command omitted due to length

This is the basic syntax of how to install conda packages. Notice the ``=0.24.0`` after the package name. This is the exact version number of the package. It is very important to specify version numbers with conda, otherwise you will end up with the latest version available on conda and your work may not be reproducible when you recreate the environment at a later time.

The package we installed is called ``mamba`` and we installed it through the `conda forge <https://conda-forge.org/>`_ channel (``-c conda-forge``) which contains over 18.000 utility packages. `mamba <https://github.com/mamba-org/mamba>`_ is a replacement for the ``conda`` command executable. While it does not have every feature ``conda`` has we still highly recommend using ``mamba`` when installing packages because it is a lot faster than regular ``conda`` when resolving dependencies.


Saving environments
-------------------

For the sake of reproducibility you will often want to have the exact same conda environment on multiple computers. To achieve this, conda has a feature to export your complete environment as a YAML file.


.. hint:: 

   What are YAML files?

   `YAML <https://en.wikipedia.org/wiki/YAML>`_ (YAML Ain't Markup Language) is a simple format and language typically used in config files to store settings and other information. This information can be read and interpreted by other software. By saving settings and parameters into YAML files, it becomes easy to reproduce analyses without having to remember each paramter. There are libraries to interact with YAML files for each major programming language and many bioinformatics software uses YAML files as an input. YAML files have the syntax ``name: value``. Typical extensions are ``.yaml`` or ``.yml``. Additional grouping of values can be made by assigning named block and indenting all name-value pairs belonging to this block. Look at this section of a YAML file:

   .. code-block:: bash
   
      samtools:
         memory: 10G
         threads: 20
         params: "-a -x sr"

   As you can see the three last lines are indented and the whole indented block has the name samtools. Hopefully this quick introduction helps to understand YAML files, We will come accross them often so it is good to know their structure. There are other, more complex laguages such as JSON or also XML (if you are ready for frustration) which are less human readable but have libraries to interact with them in different languages. If you are interested in this topic here are some links with further information:

   `What is YAML? <https://blog.stackpath.com/yaml/>`_
   `More extensive YAML tutorial <https://www.cloudbees.com/blog/yaml-tutorial-everything-you-need-get-started>`_
   `YAML vs. JSON <https://www.geeksforgeeks.org/what-is-the-difference-between-yaml-and-json/>`_
   `JSON or YAML? Which is better <https://linuxhint.com/yaml-vs-json-which-is-better/>`_
   `Working with YAML files in Python <https://python.land/data-processing/python-yaml>`_

Now we will save the environment with mamba installed to a YAML file:

.. code-block:: bash
   
   $ conda env export -n myenvironment > myenvironment.yml
   $ head myenvironment.yml
   name: myenvironment
   channels:
     - conda-forge
     - bioconda
     - defaults
   dependencies:
     - _libgcc_mutex=0.1=conda_forge
     - _openmp_mutex=4.5=2_gnu
     - bzip2=1.0.8=h7f98852_4
     - c-ares=1.18.1=h7f98852_0 

As you can see ``conda env export`` creates a YAML file. The first few lines already indicate how it is structured, we have different indented blocks which belong together (such as name, channels and dependencies). You can also see that each installed packages is specified with a version number and a build number using the format ``packagename=version=build``. This means conda is very specific when exporting environments. In terms of reproducibility this should be a good thing right? Well in fact this can cause many problems. We will have a look at this and other issues you may encounter with conda in the next section.

Problems with conda
===================

Conda is a very nice tool to create virtual environments and install software packages. However there are a few, not immediately obvious challenges when working with conda that can impact reproducibility negatively. Let us continue with the example of creating an environment from a saved yaml file.

Challenges when exporting environments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The standard way of creating an environment from a compatible YAML file with conda is this:

.. code-block:: bash

   $ conda env create -f myenvironment.yml 

Conda will parse the YAML file, create a new environment by the name given in the first line of the file and install all packages listed under dependencies. It will install the exact same version and build and this is where the problem starts. Not every version and build exists for every operating system and computer architecture. It will depend if you are working on Linux or Mac and there are differences between 32bit and 64bit CPUs as well as ARM and x86 CPU architectures. Since there are many dependencies that need to be considered (look at the complete environment files with ``less``), there is a lot of room for problems. 

A possible solution to this problem is to export environments like this:

.. code-block:: bash
   
   $ conda env export -n myenvironment --no-builds > myenvironment.yml
   $ head myenvironment.yml
   name: myenvironment
   channels:
     - conda-forge
     - bioconda
     - defaults
   dependencies:
     - _libgcc_mutex=0.1
     - _openmp_mutex=4.5
     - bzip2=1.0.8
     - c-ares=1.18.1

As you can see this will create an environment file that still has the version number of the packages but is missing the build. You can be even more restrictive with what is exported by doing this:

.. code-block:: bash

   $ conda env export --from-history -n myenvironment
   name: myenvironment
   channels:
     - bioconda
     - defaults
   dependencies:
     - mamba
   prefix: /home/user/.miniconda3/envs/myenvironment 

In this case only the packages that have been installed explicitly (with ``conda install``) will be listed here. But unfortunately without version numbers and also a package channel is missing.

.. admonition:: Exercise
  
   You will now try to install your conda environment on a differently setup computer. If you have conda installed locally on your computer you can try it there. If not, we have provided an alternative environment for you to perform this exercise. To get to this environment run: ``debian-alternate-miniconda`` in the same directory where your YAML environment file is. This is a stripped down version of Debian Linux with Miniconda 4.7.12 installed. You may use ``vim`` or ``nano`` to edit the file there. Use ``exit`` to close this environment. Your task is to try to get the environment to install properly and mama working inside the environment.


Incompatible packages from small channels
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Beside the large conda channels (such as bioconda, conda-forge, r) it is possible to install also from alternative channels. However also this can come with several challenges and unexpected behaviour. For example some channels can provide incompatible dependecy versions even when thy should be compatible. This can sometimes happen unexpectedly and also rarely with large channels, but far less often. Here is an example where we try to install `ete3 <http://etetoolkit.org/>`_ and its associated tools. Ete3 is an API for working with phylogenetic data in python. It is powerful and provides many interesting functions to work with alignments and phylogenetic trees. Let us see how this goes by following installation instructions which you can find if you search for `ete3 conda install <https://www.google.com/search?channel=fs&client=ubuntu&q=install+ete3+conda>`_ . 

.. code-block:: bash

   $ conda create -n ete3
   $ conda activate ete3
   (ete3) $ conda install -c conda-forge ete3=3.1.2
   # output of this command is omitted here due to length
   (ete3) $ ete3 build check
   
   WARNING: external applications not found
   Install using conda (recomended):
    conda install -c etetoolkit ete_toolchain
   or manually compile from:
    https://github.com/etetoolkit/ete_toolchain


It seems the installation of ete3 went well, however we are missing external applications. Let's install them according to the suggested command:

.. code-block:: bash

   (ete3) $ conda install -c etetoolkit ete_toolchain=3.0.0
   Collecting package metadata (current_repodata.json): done
   Solving environment: / 
   The environment is inconsistent, please check the package plan carefully
   The following packages are causing the inconsistency:
   
     - conda-forge/linux-64::pyqt==5.15.4=py310h29803b5_1
     - conda-forge/linux-64::libudev1==249=h166bdaf_4
     - conda-forge/noarch::ete3==3.1.2=pyh9f0ad1d_0
     - conda-forge/linux-64::pulseaudio==14.0=h7f54b18_8
     - conda-forge/linux-64::qt-main==5.15.4=ha5833f6_2
   failed with initial frozen solve. Retrying with flexible solve.
   Solving environment: failed with repodata from current_repodata.json, will retry with next repodata source.
   
   ResolvePackageNotFound: 
     - python=3.1

This is strange! Shouldn't conda help us solve these issues? Apparently it does not always work.

.. admonition:: Exercise

   As you can see, this does not work so easily. Your task is now to try to install ete3 and ete_toolchain into the same environment. The underlying issue is discussed `here <https://github.com/etetoolkit/ete/issues/500>`_ .

Once you have solved this, we can look at all packages installed through the etetoolkit channel:

.. code-block:: bash

   (ete3) $ conda list | grep etetoolkit
   argtable2                 2.13                          0    etetoolkit
   clustalo                  1.2.4                h4346872_0    etetoolkit
   dialigntx                 1.0.2                hdce4c0c_0    etetoolkit
   ete3                      3.1.2              pyh39e3cac_0    etetoolkit
   ete_toolchain             3.0.0                h73706c9_0    etetoolkit
   fasttree                  2.1                  hdfd2403_0    etetoolkit
   iqtree                    1.5.5                he390d98_0    etetoolkit
   kalign                    2.03                 h29c49b8_0    etetoolkit
   mafft                     6.861                h7f9ae3c_0    etetoolkit
   muscle                    3.8.31               he5e28f3_0    etetoolkit
   paml                      4.8                  h48adae2_0    etetoolkit
   phylobayes                4.1c                 hac87e47_0    etetoolkit
   phyml                     20160115.patched      hee5dff1_0    etetoolkit
   pmodeltest                1.4              py36h545a9a4_0    etetoolkit
   raxml                     8.2.11               h6db2ed4_0    etetoolkit
   slr                       1.4.3                h69822e3_0    etetoolkit
   t_coffee                  11.00                h99d273f_0    etetoolkit
   trimal                    1.4                  h87cb4c3_0    etetoolkit

You may recognize several of these programs. They are standard software in phylogenetics which ete3 uses, however the used version here are pretty outdated. The ete channel does not provide more recent versions and updating these packages through a different channel. For example we can try to update iqtree (a Maximum-Likelihood phylogenetic tree building software) to it's latest version available on bioconda:

.. code-block:: bash

   (ete3) $ conda install -c bioconda iqtree=2.2.0.3 

   Collecting package metadata (current_repodata.json): done
   Solving environment: - 
   The environment is inconsistent, please check the package plan carefully
   The following packages are causing the inconsistency:
   
     - defaults/linux-64::libgfortran-ng==7.5.0=ha8ba4b0_17
     - etetoolkit/noarch::ete3==3.1.2=pyh39e3cac_0
     - defaults/linux-64::scipy==1.5.2=py36h0b6359f_0
   failed with initial frozen solve. Retrying with flexible solve.
   Solving environment: failed with repodata from current_repodata.json, will retry with next repodata source.
   Collecting package metadata (repodata.json): done
   Solving environment: | 
   The environment is inconsistent, please check the package plan carefully
   The following packages are causing the inconsistency:
   
     - defaults/linux-64::libgfortran-ng==7.5.0=ha8ba4b0_17
     - etetoolkit/noarch::ete3==3.1.2=pyh39e3cac_0
     - defaults/linux-64::scipy==1.5.2=py36h0b6359f_0
   failed with initial frozen solve. Retrying with flexible solve.
   Solving environment: / 
   Found conflicts! Looking for incompatible packages.
   This can take several minutes.  Press CTRL-C to abort.
   failed                                                                                                                                                                                         
   
   UnsatisfiableError: The following specifications were found to be incompatible with each other:
   
   Output in format: Requested package -> Available versions
   
   Package __glibc conflicts for:
   @|@/linux-64::__glibc==2.27=0
   @/linux-64::__glibc==2.27=0
   python=3.6 -> libgcc-ng[version='>=7.5.0'] -> __glibc[version='>=2.17']
   
   Package _libgcc_mutex conflicts for:
   python=3.6 -> libgcc-ng[version='>=7.5.0'] -> _libgcc_mutex[version='*|0.1',build=main]
   iqtree=2.2.0.3 -> libgcc-ng[version='>=10.3.0'] -> _libgcc_mutex[version='*|0.1',build=main]
   

Welcome to `dependency hell <https://en.wikipedia.org/wiki/Dependency_hell>`_ ! We are having the same problem conda set out to solve. 

R and conda
~~~~~~~~~~~

Many of you probably also work with R. In case your are not familiar with R, R is a `statistical programming language <https://en.wikipedia.org/wiki/R_(programming_language)>`_ that has become heavily used in natural sciences. It has countless user-developed extensions for different kinds of analysis and visualizing data. If you rely on R heavily, it may be tempting to install R in conda. This may be necessary to keep different R versions and according version of R packages. However if you plan to do so, there are several things to keep in mind. In R it is not the standard to install specific version (although you definitely should) when installing packages. Although it is possible, given you have devtools installed: 

.. code-block:: bash

  $ R
    
  R version 4.1.3 (2022-03-10) -- "One Push-Up"
  Copyright (C) 2022 The R Foundation for Statistical Computing
  Platform: x86_64-conda-linux-gnu (64-bit)
  
  R is free software and comes with ABSOLUTELY NO WARRANTY.
  You are welcome to redistribute it under certain conditions.
  Type 'license()' or 'licence()' for distribution details.
  
    Natural language support but running in an English locale
  
  R is a collaborative project with many contributors.
  Type 'contributors()' for more information and
  'citation()' on how to cite R or R packages in publications.
  
  Type 'demo()' for some demos, 'help()' for on-line help, or
  'help.start()' for an HTML browser interface to help.
  Type 'q()' to quit R.
  
  > require(devtools)
  > install_version("ggplot2", version = "3.3.6", repos = "http://cran.us.r-project.org")


The ggplot package in R is probably one of the most commonly used packages for data visualization. Due to its popularity it is also available on as a conda package. In fact there are multiple available ggplot packages:

- `ggplot on conda-forge <https://anaconda.org/conda-forge/r-ggplot2>`_
- `an old version of ggplot <https://anaconda.org/conda-forge/ggplot>`_ (also on conda-forge)
- `ggplot on bioconda <https://anaconda.org/bioconda/r-ggplot2>`_ 

and probably others on small channels. This is not ideal. 




Tips to increase reproducibility with conda
===========================================

From what we have seen in the exercises above, several hurdles can come in the way to achieve full reproducibility when working with conda. There are however several things you can do to increase reproducibility:

- Make sure to have the same conda version installed on each system.
- Explicitly specify package version numbers.
- When exporting environment files, only include packages you installed explicitly.
- Make sure to have the correct channel order because channel oder matters (often the order conda-forge, bioconda, defaults works).
- Try to avoid installing from small (and often not well maintained channels).
- Create many small environments instead of installing everything into a single environment.

When working with R in conda:

- Alawys install R first before installing packages.
- Avoid installing R packages from different channels
- Don't mix R packages installed through conda and directly in R (eg. with ``install.packages()``.
- If possible avoid the r channel and make sure to use the corret one.
- Be prepared to run into problems.













