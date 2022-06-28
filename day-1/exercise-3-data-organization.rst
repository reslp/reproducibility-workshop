.. role:: bash(code)
   :language: bash

==============================
Exercise 3 - Data organization
==============================

In this exercise we will have a look into how you can put structure into your research projects files and folder on your computer and how you can keep track of changes to them.


We will:

- Setup a directory structure
- Initialize a git repository
- Use git to track files in the repository
- Work with Markdown documents

First let us create a new project with a basic directory structure that can help us to organize our data better:

.. code-block:: bash

    $ mkdir my_project
    $ cd my_project
    $ mkdir bin data doc results tmp


At the beginning of a project, all directories will be empty, however they will fill quickly as you continue to work on the project.

Information in your project's directories 
=========================================

The suggested directory structure is intuitive (it follows basic naming convention on \*nix systems) as well as general enough to fit many different use cases. It should be relatively clear what should be put where. Of course it is up to you to decide where to place stuff, but keep in mind that your choice is reasonable and intuitive. For example if you, for some reason place a subset of Illumina read FASTQ files into :bash:`tmp/illumina/subsets` you may spend more time searching for the data then if you would have placed it into :bash:`data/`. Also, if you collaborate with somebody and send them your project, it may also be difficult for them to figure out where the subsetted Illumina read files are.

.. code-block:: bash

    A quick recapitulation of the proposed structure:
	
    bin			contains scripts and execuables for performing different analyses
    data		contains all raw-data
    results		contains analyses results. Ideally within subdirectories.
    tmp			Location of temporary files. The "playground" of your project
    doc			Contains all the documentation for your project. 
