Workflow mamagement systems
===========================

Workflow management systems help to structure complex workflows. When a workflow has many steps with different input and outfile in different formats, using some kind of workflow management system can greatly help to increase readability and reusability and thus also reproducibility of your analyses. Once you will be familiar with workflow management, you will never turn back.

In this exercise we will introduce different ways how to automate workflows to increase productivity and reproducibility.

We will be using a simplified dummy dataset to illustrate the principle of what we want to do. The task is simple: We want to combine the content of several files into a single file and convert all text in the combined file to lower case. The resulting file should be called ``lower.txt``. The data for this exercise is in ``additional-data/simple-workflow-example/input``. You can copy the ``simple-workflow-example`` directory or work directly there.

Using commandline scripting
----------------------------

The task we have to do is simple and can easily be achieved by using a bash oneliner:

.. code-block:: bash

   $ cat input/*.txt | tr [:upper:] [:lower:] > lower.txt

However we will now try to divide this command into individual steps and then make an automated workflow out of it. 

The command does several things:

1. It gets a list of ``.txt`` files by using the ``*`` expansion.
2. It shows the content of all the files gather by 1 using ``cat``.
3. It pipes the output of 2 into ``tr`` which converts the streamed content to lower case.
4. Finally the result is piped into a file called ``lower.txt``

As we have mentioned earlier it is generally a good idea to keep more complex bash operations in shell script files, so they can be reused. How does this command look if we write a shell script.

.. code-block:: bash

   #!/usr/bin/env bash

   rm -f combined.txt lower.txt # remove output from previous runs

   files=$(ls input/*.txt) # get input files (see 1 above)

   for file in $files # the for loop helps to combine the files (see 2 above)
   do
           cat $file >> combined.txt
   done
   
   cat combined.txt | tr [:upper:] [:lower:] > lower.txt # convert the content of the intermediate file to lower case and pipe to lower.txt (see 3 and 4 above)
   
.. hint::

   Of course it is clear that it is overly complicated to write it like that given that we could also use a simple oneliner for this task. The point here is to show how to separate more complex tasks (and in the end complete bioinformatic analyses) into individual tasks.

Using a script already increases reproducibility quite a bit. We can take this script, transfer it to a different folder or computer and run it again to generate the final output ``lower.txt``. If we were to run it on the same input files again we would get the same output.

However, there are several potential pitfalls to keep in mind. One problem with an approach like this is that for complex analyses such a script can quickly become hard to understand. A solution would be to create different scripts (eg. for our test case ``step-1-get-input-files.sh step-2-combine-files.sh step-3-convert-to-lower.sh``). This would help to detect errors and make the code easier to understand because each script only contains code for a single part of the analysis.

Another problem is that if you run a script again (on purpose or by accident) the script will recreate all results regardless of it is necessary or not. Why is this relevant? For one, complex bioinformatic analyses can take a significant amount of time and computational resources. Another aspect is that in many cases it is simply not necessary to recreate results. Only when input files or parameters change you will want to rerun an analysis. However, in large-scale projects with thousands of input and output files it is impossible to keep track which files could have changed. To address these issues (and more which we will see below) workflow management systems have been developed. We will now implement our simple test workflow using different workflow managers.

GNU Make
--------

`GNU Make <https://www.gnu.org/software/make/>`_, make or sometimes gmake was first introduced in 1976 to build the source code of Unix and it has a long and successful track record in computer science. Typically make is used to compile software from source. If you have installed software on linux you may be familiar with commands like ``make``, ``make install`` or ``make clean``. Although make is usually used to build software, it can be used to automate almost any task.
