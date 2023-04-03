=======================================
Exercise 1 - Refresh command line skills
=======================================

For the following three days we assume that you can navigate in a
UNIX-like file system using the command line, list, copy, rename and
remove files, and alsodisplay the contents of files. Further, we assume
that you know how to execute scripts and use shell programs like
``grep``, ``sed``, ``cut``, etc. and have a basic understanding of how
piping ``|`` works.

Let’s do a few small things to get you warmed up.

.. admonition:: In case you need help

   Solutions to the below tasks can be found `here <https://github.com/reslp/reproducibility-workshop/blob/main/day-1/solutions/ex-1.rst>`_, if need be.


First, let’s connect to the server.

You’ve been provided with ``*.pem`` file that contains your users
credentials for connecting to the server. If you have ``ssh`` set up on
your computer connecting should be as easy as, where I set a few
variables first:

.. code:: bash

   (user@host)-$ pem="biorepo.pem" #your file may be called c1.pem, c2.pem, etc. depending on your user
   (user@host)-$ IP="18.237.42.108" #this will change every day
   (user@host)-$ user="ubuntu" #change to reflect your username, user1, user2, user3, etc.
   (user@host)-$ ssh -i $pem $user@$IP #connect - confirm with yes if you connect for the first time

If successful you’ll find yourself connected and your prompt will look
something like that:

.. code:: bash

   user40@ip-172-31-4-141:~$ 

Your home directory should only contain a single directory at this
stage.

.. code:: bash

   user40@ip-172-31-4-141:~$ pwd
   /home/user40
   user40@ip-172-31-4-141:~$ ls
   Share

Let’s create a bit of directory structure and navigate through it.

.. code:: bash

   user40@ip-172-31-4-141:~$ mkdir -p linux-intro/bin
   user40@ip-172-31-4-141:~$ mkdir linux-intro/data
   user40@ip-172-31-4-141:~$ mkdir linux-intro/results

.. code:: bash

   user40@ip-172-31-4-141:~$ cd linux-intro/data
   user40@ip-172-31-4-141:~$ pwd
   /home/user40/linux-intro/data
   user40@ip-172-31-4-141:~$ cd


.. admonition:: Task 1

   Copy a file called ``README.md`` from a directory called ``Day1`` in ``{HOME}/Share`` to ``linux-intro/data``. 
   **Make sure to retain the timestamp of the original file**.


.. admonition:: Task 2

   Copy the directory ``${HOME}/Share/Day1/subfolder1/`` and all it's content to ``linux-intro/data``.

   - make sure to also bring about the entire directory structure from ``Day1`` onwards
   - do not copy subfolders ``subfolder2`` and ``subfolder3`` of ``Day1``.
   - keep original timestamps


Print a random number between 1 and 1000 to screen.

.. code:: bash

   user40@ip-172-31-4-141:~$ echo "$((1 + RANDOM % 1000))"

Now, produce 10 random numbers between 1 and 1000, consecutively. Repeat
three times.

.. code:: bash

   user40@ip-172-31-4-141:~$ for i in {1..10}; do echo "$i: $((1 + RANDOM % 1000))"; done
   user40@ip-172-31-4-141:~$ for i in {1..10}; do echo "$i: $((1 + RANDOM % 1000))"; done
   user40@ip-172-31-4-141:~$ for i in {1..10}; do echo "$i: $((1 + RANDOM % 1000))"; done

Make the ‘random’ number generation reproducible by setting a seed -
``42`` seems to be a good choice.

.. code:: bash

   user40@ip-172-31-4-141:~$ RANDOM=42; for i in {1..10}; do echo "$i: $((1 + RANDOM % 1000))"; done
   user40@ip-172-31-4-141:~$ RANDOM=42; for i in {1..10}; do echo "$i: $((1 + RANDOM % 1000))"; done
   user40@ip-172-31-4-141:~$ RANDOM=42; for i in {1..10}; do echo "$i: $((1 + RANDOM % 1000))"; done

Write your solution into a bash script, and make it executable so you
can execute it like so:

.. code:: bash

   user40@ip-172-31-4-141:~$ ${HOME}/linux-intro/Day1/bin/random_numbers.sh 10 42

Where the first number is the number of random integers between 1 and
1000 to generate and the second number is your seed.

Add the directory ``${HOME}/linux-intro/Day1/bin`` to your users ${PATH}
so that your script will be avaiable globally.

Read in a csv file called ``${HOME}/Share/Day1/subfolder2/results.txt``,
find and copy the files that are listed in first the column and have the
label ‘complete’ in the second to ``${HOME}/linux-intro/Day1/results/``.
Note that the table has a header line. The files are in
``${HOME}/Share/Day1/subfolder3/``.

If you like a challenge, then try to do it all in one command..

Now you should be warmed up .. ;-)


