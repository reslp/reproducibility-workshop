Workflow management systems
===========================

Workflow management systems help to structure complex workflows. When a workflow has many steps with many different input and output files in different formats, using some kind of workflow management system can greatly help to increase readability and reusability and thus also reproducibility of your analyses. Once you will be familiar with workflow management, you will never turn back.

In this exercise we will introduce different ways how to automate workflows to increase productivity and reproducibility.

We will be using a simplified dummy dataset to illustrate the principle of what we want to do. The task is simple: We want to combine the content of several files into a single file and convert all text in the combined file to lower case. The resulting file should be called ``lower.txt``. The data for this exercise is in ``additional-data/simple-workflow-example/input``.

.. admonition:: Exercise

   Copy the ``simple-workflow-example`` to your home directory and familiarize yourself with the input data. If possible try to come up with a solution to the proposed task from above by using bash before reading on.

Using commandline scripting
----------------------------

As you probably figured out yourself, the task we have to do is simple and can easily be achieved by using a bash oneliner:

.. code-block:: bash

   $ cat input/*.txt | tr [:upper:] [:lower:] > lower.txt

However we will now try to divide this command into individual steps for the sake of this exercise and then make an automated workflow out of it. 

The command iabove does several things:

1. First, it gets a list of all ``.txt`` files in the ``input`` directory by using the ``*`` expansion.
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
   all: lower.txt

   combined.txt: input/*.txt 
           for file in $^; do \
                   cat $$file >> combined.txt; \
           done
   
   lower.txt: combined.txt
           cat combined.txt | tr [:upper:] [:lower:] > lower.txt

   clean:
           rm -rf combined.txt lower.txt 

In this makefile there are four rules: ``combined.txt``, ``lower.txt``, ``all`` and ``clean``. The first two rules have file targets making it clear what they should do: Generate the files ``combined.txt`` and ``lower.txt``. Let's look at the ``combined.txt`` rule in more detail:

.. code-block:: bash
   :linenos:
   
   combined.txt: input/*.txt 
        for file in $^; do \
                cat $$file >> combined.txt; \
        done
   

In the first line, the target and input is specified, seperated by a colon (:). We use ``input/*.txt`` to expand to all ``*.txt`` files in the ``input`` directory. The recipe in the rule is a simple bash ``for`` loop. What is new here is the variable ``$^`` which is make specific (look `here <https://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html>`_ for additional details). It holds a list of all input files which the for loop should iterate over. Also multi-line statements as given here (the recipe consits of lines 2-4) have to be separated by a backslash ``\``. This is a peculiarity of make, which requires recipies to only contain one line of code. With the backslash make knows that the command continues in the next line. The third line contains the actual ``cat`` command. In bash we would write ``cat $file`` instead of ``cat $$file``. Since make also has variables which start with ``$`` we need to let make know that this is a bash variable which is why we need the extra ``$``.

.. tip::

   If you are familiar with ``bash`` scripting, the escaping rules and formatting of multi line commands may look weird. Keep in mind that although it looks similar ``make`` is not ``bash`` and the syntax is different. Here are a few links where escaping rules are explained in more detail:

   - `Escaping $ in Makefiles <https://til.hashrocket.com/posts/k3kjqxtppx-escape-dollar-sign-on-makefiles>`_
   - `GNU Make Escaping: A Walk on the Wild Side <https://www.cmcrossroads.com/article/gnu-make-escaping-walk-wild-side>`_
   - `Stackoverflow answer to escaping in make <https://stackoverflow.com/a/7860705>`_

Now that we know the basic structure of make rules, the rule to create ``lower.txt`` should be self explanatory.

Special make rules
~~~~~~~~~~~~~~~~~~

The rules ``all`` and ``clean`` are new and they don't exist in the shellscript version of our pipeline. It is often quite useful to have these special rules in your makefile. If you have already build some software with make you will know that ``clean`` removes (intermediate) results and ``all`` is the rule to recreate all output. It is not necessary to have these special rules, but there are many cases where they become useful.

Execute a make workflow
~~~~~~~~~~~~~~~~~~~~~~~

Executing a make workflow is simple. You have to navigate to the directory where your makefile is located and execute ``make``.

.. code-block:: bash

   $ make
   for file in input/A.txt input/B.txt input/C.txt input/D.txt; do \
   	cat $file >> combined.txt; \
   done
   cat combined.txt | tr [:upper:] [:lower:] > lower.txt
   $

This is it. Given that the makefile is correct and it finds all the files, this is all you have to do to execute the workflow and you should find the final output file ``lower.txt`` in the same directory.

Behind the scenes, ``make`` searches for a Makefile in the present directory and executes the first rule it finds in the file. Since the first rule is the *all* rule, which requires the ``lower.txt`` file, make will continue to search for a rule called ``lower.txt``. It sees that the lower.txt rule requires the ``combined.txt`` file which is created in the according rule. The order of rule executon thus is: combined.txt -> lower.txt -> all.

.. admonition:: Exercise

   Play around with this workflow. Run make again and see what happens. Try to break the workflow by changing the Makefile. Which error messages do you get? Can you change the workflow so that it only usestwo files instead of four?

Many more possibilities
~~~~~~~~~~~~~~~~~~~~~~~






