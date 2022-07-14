Working environment
===================

The working environment will already contain everything you need to get started. If specific files are required, we will download them during the exercises.

The used system
---------------

Here is some information on the system we have been using. This is important because some of the installation commands given here are specific for this version of Ubuntu:

.. code-block:: bash

   $ cat /etc/os-release
   NAME="Ubuntu"
   VERSION="18.04.1 LTS (Bionic Beaver)"
   ID=ubuntu
   ID_LIKE=debian
   PRETTY_NAME="Ubuntu 18.04.1 LTS"
   VERSION_ID="18.04"
   HOME_URL="https://www.ubuntu.com/"
   SUPPORT_URL="https://help.ubuntu.com/"
   BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
   PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
   VERSION_CODENAME=bionic
   UBUNTU_CODENAME=bionic


Changes to the environment
--------------------------

We use several bash aliases to mask complex docker commands which we added globally to ``/etc/bash.bashrc``. This file is available `here <https://github.com/reslp/reproducibility-workshop/blob/main/additional-data/working-environment/bash.bashrc>`_. If you would like to use these settings locally, you can add these lines to your own ``.bashrc`` file (or equivalent).

.. code-block:: bash

   # a few aliases of docker run commmands
   alias pandoc="docker run --rm -it -v $(pwd):/data -w /data reslp/pandoc:2.18 pandoc"
   alias debian-alternative-miniconda="docker run --rm -it -v $(pwd):/data reslp/debian-alternative-miniconda:4.7.12"
   alias nextflow="docker run --rm -it -v $(pwd):/data -w /data nextflow/nextflow:22.04.4 nextflow "
   alias nf-core="docker run -it -v $(pwd):$(pwd) -w $(pwd) -u $(id -u):$(id -g) nfcore/tools:2.4.1"
   alias switch-on_ubuntu_20-04="docker run -it --rm --hostname ubuntu-20-04 -w /home ubuntu:20.04"
   alias switch-on_ubuntu_22-04="docker run -it --rm --hostname ubuntu-22-04 -w /home ubuntu:22.04" 

The conda setup
---------------

We are using ``Miniconda3 v4.8.2`` installed globally. Here is some additional information on the exact configuration:

.. code-block:: bash

   $ conda --version
   conda 4.8.2
   $ conda info
   conda info
   
        active environment : None
               shell level : 0
          user config file : /home/ubuntu/.condarc
    populated config files : /home/ubuntu/.condarc
             conda version : 4.8.2
       conda-build version : not installed
            python version : 3.7.6.final.0
          virtual packages : __glibc=2.27
          base environment : /home/ubuntu/conda/miniconda3  (writable)
              channel URLs : https://conda.anaconda.org/conda-forge/linux-64
                             https://conda.anaconda.org/conda-forge/noarch
                             https://conda.anaconda.org/bioconda/linux-64
                             https://conda.anaconda.org/bioconda/noarch
                             https://repo.anaconda.com/pkgs/main/linux-64
                             https://repo.anaconda.com/pkgs/main/noarch
                             https://repo.anaconda.com/pkgs/r/linux-64
                             https://repo.anaconda.com/pkgs/r/noarch
             package cache : /home/ubuntu/conda/miniconda3/pkgs
                             /home/ubuntu/.conda/pkgs
          envs directories : /home/ubuntu/conda/miniconda3/envs
                             /home/ubuntu/.conda/envs
                  platform : linux-64
                user-agent : conda/4.8.2 requests/2.22.0 CPython/3.7.6 Linux/5.4.0-1080-aws ubuntu/16.04.5 glibc/2.27
                   UID:GID : 1000:1000
                netrc file : None
              offline mode : False
   $ cat /home/ubuntu/.condarc
   channels:
     - conda-forge
     - bioconda
     - defaults
   auto_activate_base: false

Already created conda environments
----------------------------------

You should have a conda environment available that we created called ``serpentesmake`` which we will be using in the exercise on Snakemake. In case it is not available you can get the YAML file `here <https://github.com/reslp/reproducibility-workshop/blob/main/additional-data/conda-environments/serpentesmake.yaml`_.


Docker installation
-------------------

This is how we installed Docker. This is based on these `instructions <https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04>`_.

.. code-block:: bash

   $ sudo apt update
   $ sudo apt install apt-transport-https ca-certificates curl software-properties-common
   $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   $ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
   $ sudo apt update
   $ sudo apt install docker-ce
   $ sudo systemctl status docker
   $ sudo usermod -aG docker ${USER} #add current user to docker group
   $ su - ${USER} #password required - alternatively log off and back on to activate
   $ #check if user is part of docker group
   $ id -nG


Singularity installation
------------------------

This is how we installed Singularity, originally given in the Github issue thread `here <https://github.com/hpcng/singularity/issues/4765>`_ (way down in the thread).

.. code-block:: bash

   $ sudo apt-get update && \
     sudo apt-get install -y build-essential \
   $ libseccomp-dev pkg-config squashfs-tools cryptsetup
    
   $ sudo rm -r /usr/local/go
    
   $ export VERSION=1.13.15 OS=linux ARCH=amd64  # change this as you need
    
   $ wget -O /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz && \
     sudo tar -C /usr/local -xzf /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz
    
   $ echo 'export GOPATH=${HOME}/go' >> ~/.bashrc && \
     echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> ~/.bashrc && \
     source ~/.bashrc
    
   $ curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh |
     sh -s -- -b $(go env GOPATH)/bin v1.21.0
    
   $ mkdir -p ${GOPATH}/src/github.com/sylabs && \
     cd ${GOPATH}/src/github.com/sylabs && \
     git clone https://github.com/sylabs/singularity.git && \
     cd singularity
    
   $ git checkout v3.6.3
    
   $ cd ${GOPATH}/src/github.com/sylabs/singularity && \
     ./mconfig && \
     cd ./builddir && \
     make && \
     sudo make install
    
   $ singularity version
