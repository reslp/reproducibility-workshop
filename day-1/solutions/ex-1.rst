
**Task 1 - Copy file, retaining the original timestamp**

.. code:: bash

   user40@ip-172-31-4-141:~$ cp -p ${HOME}/Share/Day1/README.md linux-intro/data/


**Task 2 - Complex copy of relative directory structure**

.. code:: bash

   user40@ip-172-31-4-141:~$ rsync -avpuzP --relative ${HOME}/Share/./Day1/subfolder1 linux-intro/data/


  
