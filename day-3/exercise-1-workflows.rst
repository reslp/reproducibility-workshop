Workflow management systems
===========================

Workflow management systems help to structure complex workflows. When a workflow has many steps with many different input and output files in different formats, using some kind of workflow management system can greatly help to increase readability and reusability and thus also reproducibility of your analyses. Once you will be familiar with workflow management, you will never turn back.

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

`GNU Make <https://www.gnu.org/software/make/>`_, make or sometimes gmake was first introduced in 1976 to build the source code of Unix and it has a long and successful track record in computer science. Typically make is used to compile software from source. Previous to make Unix was compiled using custom shell scripts. If you have installed software on Linux or Unix you may be familiar with commands like ``make``, ``make install`` or ``make clean``. As already mentioned make is usually used to build software, however it can be used to automate almost any task and even large bioinformatics projects (such as `LongStitch <https://github.com/bcgsc/longstitch>`_) use make as a workflow manager.

How does make work?
~~~~~~~~~~~~~~~~~~~

Make uses the concept of rules. You can think of rules as individual tasks that are executed in a given order determined by other rules. If we take our example from above, we have already identified the steps that need to happen for the whole workflow to complete successfully. Each rule has a target and one (or more) dependencies. Other words for that would be: output (target) and input (dependencies). The rule then contains all instructions (the recipe) to build the output from the input. This is a common concept also in other workflow managers.

Let's have a look at the general structure of a rule in make:

.. code-block:: bash

   targets: prerequisites
        recipe
        …
 
Here is how this could look for our task of converting a file to lower case:

.. code-block:: bash

   lower.txt: combined.txt
        cat combined.txt | tr [:upper:] [:lower:] > lower.txt

The *target* (output) of this rule is the file ``lower.txt`` and the *dependency* (input) is ``combined.txt``. The *recipe* for this rule is the second line. Typically all rules are combined into one or more socalled Makefiles which typically are named ``Makefile`` or ``makefile``.

Our simple test workflow in make
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

How would our simple test workflow look written in make? Let us have a look at the complete ``makefile`` and then discuss it.

.. code-block:: bash
   
   $ cat Makefile
   input_files=$$(ls input/*.txt)
   
   combined.txt: 
           for file in $(input_files); do \
                   cat $$file >> combined.txt; \
           done
   
   lower.txt: combined.txt
           cat combined.txt | tr [:upper:] [:lower:] > lower.txt
   
   all: lower.txt

   clean:
           rm -rf combined.txt lower.txt 




.. tip::

   If you are familiar with ``bash`` scripting, the escaping rules and formatting of multi line commands may look weird. Keep in mind that although it looks similar ``make`` is not ``bash`` and the syntax is different. Here are a few links where escaping rules are explained in more detail:

   - `Escaping $ in Makefiles <https://til.hashrocket.com/posts/k3kjqxtppx-escape-dollar-sign-on-makefiles>`_
   - `GNU Make Escaping: A Walk on the Wild Side <https://www.cmcrossroads.com/article/gnu-make-escaping-walk-wild-side>`_
   - `Stackoverflow answer to escaping in make <https://stackoverflow.com/a/7860705>`_




