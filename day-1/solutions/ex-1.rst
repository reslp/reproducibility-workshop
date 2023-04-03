
**Task 1 - Copy file, retaining the original timestamp**

.. code:: bash

   user40@ip-172-31-4-141:~$ cp -p ${HOME}/Share/Day1/README.md linux-intro/data/


**Task 2 - Complex copy of relative directory structure**

.. code:: bash

   user40@ip-172-31-4-141:~$ rsync -avpuzP --relative ${HOME}/Share/./Day1/subfolder1 linux-intro/data/


**Task 3 - find differences between text files**

.. code:: bash

   user40@ip-172-31-4-141:~$ diff ${HOME}/Share/Day1/README.md linux-intro/data/README.md 

**Task 4 - generate random numbers in for loop**

.. code:: bash

   user40@ip-172-31-4-141:~$ for i in {1..10}; do echo "$i: $((1 + RANDOM % 1000))"; done
   user40@ip-172-31-4-141:~$ for i in {1..10}; do echo "$i: $((1 + RANDOM % 1000))"; done
   user40@ip-172-31-4-141:~$ for i in {1..10}; do echo "$i: $((1 + RANDOM % 1000))"; done

**Task 5 - set random number seed**

.. code:: bash

   user40@ip-172-31-4-141:~$ RANDOM=42; for i in {1..10}; do echo "$i: $((1 + RANDOM % 1000))"; done
   user40@ip-172-31-4-141:~$ RANDOM=42; for i in {1..10}; do echo "$i: $((1 + RANDOM % 1000))"; done
   user40@ip-172-31-4-141:~$ RANDOM=42; for i in {1..10}; do echo "$i: $((1 + RANDOM % 1000))"; done


