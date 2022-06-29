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

When you run the :bash:`conda activate` command, we will see that your command prompt changes. This tells you that you are now working in the virtual environment :bash:`myenvironment`.

 
