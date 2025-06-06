
**Task 1 - Copy file, retaining the original timestamp**

.. code:: bash

   user40@ip-172-31-4-141:~$ cp -p ~/Share/linux-intro/data/README.md linux-intro/data/


**Task 2 - Complex copy of relative directory structure**

.. code:: bash

   user40@ip-172-31-4-141:~$ rsync -avpuzP --relative ~/Share/linux-intro/data/./Day1/subfolder1 linux-intro/data/

**Task 3a - check if files changed - use md5sums**

.. code:: bash

   #compare md5sums
   user40@ip-172-31-4-141:~$ md5sum ~/Share/linux-intro/data/README.md
   user40@ip-172-31-4-141:~$ md5sum linux-intro/data/README.md

   # check using md5sum text file provided with the original file
   user40@ip-172-31-4-141:~$ cd linux-intro/data/
   user40@ip-172-31-4-141:~$ cp ~/Share/linux-intro/data/md5sums.txt .
   user40@ip-172-31-4-141:~$ md5sum -c md5sums.txt

**Task 3b - find differences between text files**

.. code:: bash

   user40@ip-172-31-4-141:~$ diff ~/Share/linux-intro/data/README.md linux-intro/data/README.md 

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

**Task 5 - possible solution for ./linux-intro/bin/random_numbers.sh**

.. code:: bash

   #!/bin/bash

   n=$1
   seed=$2

   RANDOM=$seed

   for i in $(seq 1 $n); do echo "$i: $((1 + RANDOM % 1000))"; done


