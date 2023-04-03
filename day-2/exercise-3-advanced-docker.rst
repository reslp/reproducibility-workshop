============================================
Exercise 3 - Advanced Docker and Singularity
============================================

The following session assumes that you have Docker running on your
computer (we tested with Docker version 18.09.7, build 2d0083d). If
you're running on a Linux host it further assumes that you have it set
up in such a way that you don't have to prepend ``sudo`` to the
``docker`` command each time. There is a number of ways you can do that,
e.g. by creating a docker group and adding your user to it or by running
the Docker daemon as a non-root user (find some more info/instructions
here). If for some reason you don't want to or can do any of these
things, all of the below should also work if you simply prepend ``sudo``
to the ``docker`` command.

.. admonition:: Disclaimer

   Parts of the session below were inspired and indeed
   reuse examples from a CyVerse workshop documentation (Release 0.2.0; March 05,
   2020; `online <https://cyverse-foss-2020.readthedocs-hosted.com/en/latest/Containers/dockerintro.html>`_ - dowloaded as `pdf <https://github.com/reslp/reproducibility-workshop/blob/main/additional-data/external_documentations/cyverse-foss-2020-readthedocs-hosted-com-en-latest.pdf>`_ 03.04.2023).


Build your own image
====================

In the previous sesssion you have been shown how to run existing,
pre-build Docker containers. Now it's time to make your own Docker image
running only a particular piece of software of your choosing.

As an example I have chosen ``BLAST``, which is used to find regions of
similarity between biological sequences, DNA- and/or Protein. The BLAST
algorithm (Basic Local Alignment Search Tool) and its derivatives is
among the most used tools in DNA-sequence based research. There is an
online version hosted by NCBI, but there are many situations where it's
handy to have it running locally.

Interactive Build
-----------------

Since you've already used it in the previous session we will be starting
from a base Ubuntu image. Let's start a container interactively.

.. code:: bash

    (host)-$ docker run -it -h my_manual_blast --name ${USER}s_manual_blast ubuntu:18.04

Note the additional flags I am using - these are optional:

-  ``-h`` - Gives a defined name to the Docker host - just so it looks
   the same for all of us
-  ``--name`` - Name the container

Your prompt should look like this now:

.. code:: bash

    root@my_manual_blast:/#

Now, let's see if Ubuntu already comes with ``BLAST`` pre-installed,
specifically a programm called ``blastn``, which is used for comparing
DNA sequences.

.. code:: bash

    root@my_manual_blast:/$ blastn

    bash: blastn: command not found

No. But Ubuntu has an online registry for software and it happens to
contain the standard suite of BLAST programs. To set this up we need to
update this system first. Ubuntu has a free-software user interface
called ``apt`` (Advanced Package Tool) to manage installation and
removal of software between your system and the registry.

.. code:: bash

    root@my_manual_blast:/$ apt-get update

Note: If you're unsure if the program you want to install is in the
registry and what the package is called (it's important to know exactly,
because the command line is case sensitive and will not recognize your
request if you have misstyped), ``apt`` has a function for searching the
registry.

.. code:: bash

    (host)-$ apt-cache search blast

This is not a great example, because you get lots of packages back. But
somewhere in there you'll find ``ncbi-blast+``. This is what you want.

Then we can install the desired program as follows using ``apt-get``.
You will be notified that the installation will require some additional
diskspace and need to agree with typing ``y``.

.. code:: bash

    root@my_manual_blast:/$ apt-get install ncbi-blast+

If we try again now, it seems to work.

.. code:: bash

    root@my_manual_blast:/$ blastn -h
    USAGE
      blastn [-h] [-help] [-import_search_strategy filename]
        [-export_search_strategy filename] [-task task_name] [-db database_name]
        [-dbsize num_letters] [-gilist filename] [-seqidlist filename]
        [-negative_gilist filename] [-entrez_query entrez_query]
        [-db_soft_mask filtering_algorithm] [-db_hard_mask filtering_algorithm]
        [-subject subject_input_file] [-subject_loc range] [-query input_file]
        [-out output_file] [-evalue evalue] [-word_size int_value]
        [-gapopen open_penalty] [-gapextend extend_penalty]
        [-perc_identity float_value] [-qcov_hsp_perc float_value]
        [-max_hsps int_value] [-xdrop_ungap float_value] [-xdrop_gap float_value]
        [-xdrop_gap_final float_value] [-searchsp int_value]
        [-sum_stats bool_value] [-penalty penalty] [-reward reward] [-no_greedy]
        [-min_raw_gapped_score int_value] [-template_type type]
        [-template_length int_value] [-dust DUST_options]
        [-filtering_db filtering_database]
        [-window_masker_taxid window_masker_taxid]
        [-window_masker_db window_masker_db] [-soft_masking soft_masking]
        [-ungapped] [-culling_limit int_value] [-best_hit_overhang float_value]
        [-best_hit_score_edge float_value] [-window_size int_value]
        [-off_diagonal_range int_value] [-use_index boolean] [-index_name string]
        [-lcase_masking] [-query_loc range] [-strand strand] [-parse_deflines]
        [-outfmt format] [-show_gis] [-num_descriptions int_value]
        [-num_alignments int_value] [-line_length line_length] [-html]
        [-max_target_seqs num_sequences] [-num_threads int_value] [-remote]
        [-version]

    DESCRIPTION
       Nucleotide-Nucleotide BLAST 2.6.0+

    Use '-help' to print detailed descriptions of command line arguments

Note, that I call the software and add a ``-h`` to the call. This is a
very common, so-called ***flag*** in command line software that usually
gives you some kind of help about the program. In this case it shows all
the options the ``blastn`` program has. In this case there is even a
more extensive help you can get by typing ``blastn -help``.

Great! Now you have ``blastn`` running in a container. But how to make
this permanent?

Let's exit the container and see what we can do. The following will
get you out of the container and bring your original prompt back.

.. code:: bash

    root@my_manual_blast:/$ exit

Now, if you type ``docker container ls -a`` (in older docker versions
this is the same as ``docker ps -a``) you will see the list of all
containers that you ran so far (the ones that are running as well as
those which are already exited), including ``${USER}s_manual_blast``,
which you have just exited.

We can convert this container, including the changes you made to the
base Ubuntu image to a new image - I will call it
``${USER}s_manual_blast_image``. Docker has a subroutine for that, called
``commit``. You need to also provide a commit message via the ``-m``
flag. This is usually short information about how you changed the image,
so when you look at it later you will be able to remember what the
changes were.

.. code:: bash

    (host)-$ docker commit -m "ubuntu + blast" ${USER}s_manual_blast ${USER}s_manual_blast_image

Great! Now the image should show up if you type ``docker image ls``.

You can use it like we've done before. The ``--rm`` just tells Docker to
remove the container once you're done. This is handy, otherwise you will
accumulate excited containers very fast. Below I dropped the ``--name``
flag, because it's optional and at this stage I don't care which name
the system gives to the container while it's running.

.. code:: bash

    (host)-$ docker run -it --rm -h my_manual_blast ${USER}s_manual_blast_image

    root@my_manual_blast:/$ blastn -h
    USAGE
       .
       .
       .
    root@manual_blast_image:/$ exit

You can use the image also like an executable, rather than
interactively, try:

.. code:: bash

    (host)-$ docker run --rm ${USER}s_manual_blast_image blastn -h

Automatic Build
---------------

Docker can build images automatically, reading instructions from a text
file, the so-called ``Dockerfile``. This is simply a text document that
contains all the commands you would normally execute manually in order
to build your Docker image.

The official reference to all features and extensions is provided at Docker's
official documentation `here <https://docs.docker.com/engine/reference/builder/>`_.

Let's try to create your first ``Dockerfile`` and design it to build an
image as the one we did manually above.

To keep things tidy, let's first make and move to a new directory.

.. code:: bash

    (host)-$ mkdir automatic-blast && cd automatic-blast

Using your favorite text editor, create a file called ``Dockerfile`` and
copy/paste/type the following text into it.

::

    FROM ubuntu:18.04

    RUN apt-get update

    RUN apt-get install ncbi-blast+

Note that these are mostly the exact same commands that we just ran
interactively, but that we prepend specific directives that will be
interpreted by Docker.

-  ``FROM`` - tells Docker to start building our image onto a certain
   base image.
-  ``RUN`` - The commands in each of these lines are actually executed
   during the process of building the image.

Let's try to build the image as instructed in the Dockerfile. Docker has
a command for that.

.. code:: bash

    (host)-$ docker build -t ${USER}s_automatic_blast_image .

Note the flag ``-t`` which I use to name the image
``automatic_blast_image``. The ``.`` is mandatory and just tells it to
look for a file called ``Dockerfile`` (per default) in your current
working directory. This behavior can be changed, i.e. you can specifiy a custom filename for your Dockerfile, but you can try to
figure that one out for yourself if you want.

You will see the same information as before during system update, but
then unfortunately we get an error. Remember you've been prompted to
agree that extra diskspace is used before? Docker does not allow user
interaction during build. Let's make a small change to the Dockerfile to
fix that - add ``-y`` to the ``apt install`` command, which tells apt: 'don't prompt - yes to all'.

::

    FROM ubuntu:18.04

    RUN apt-get update

    RUN apt-get install -y ncbi-blast+

Try again.

.. code:: bash

    (host)-$ docker build -t ${USER}s_automatic_blast_image .

Looks good! Take a second to inspect the output Docker created and note
that **during the second build attempt Docker has not redone the update**,
but rather continued from from the first line in the Dockerfile that
caused the error.

If you type ``docker image ls`` now, the image should exist. We can try
it out, like so:

.. code:: bash

    (host)-$ docker run --rm ${USER}s_automatic_blast_image blastn -h

Backup and share your container
===============================

Create a local backup of your image
-----------------------------------

Docker allows you to create local backup of your custom image, that you
can store away safely somewhere and/or share with your mates. Let's do
that for the last image we've built.

.. code:: bash

    (host)-$ docker save ${USER}s_automatic_blast_image > ${USER}s_automatic_blast_image.tar

You can restore the image any time from the archive that has been
created. Let's live dangerously and remove the image - pretend it was an
accident.

.. code:: bash

    (host)-$ docker image rm ${USER}s_automatic_blast_image

Check ``docker image ls`` - Ups - it's gone. But, we can reload it from
the archive.

.. code:: bash

    (host)-$ docker load -i ${USER}s_automatic_blast_image.tar

Once present as a Docker tar archive the image can be easily converted to a Singularity image file (SIF).

.. code:: bash

   (host)-$ singularity build ${USER}s_automatic_blast_image.sif docker-archive://${USER}s_automatic_blast_image.tar

Now, run it through singularity (based on your local ``sif`` file.

.. code:: bash

   (host)-$ singularity exec ${USER}s_automatic_blast_image.sif blastn -h


Share your image with the world - Dockerhub
-------------------------------------------

Docker hosts an online repository where users can deposit and host their
images: `Dockerhub <https://hub.docker.com/>`_. An extensive documentation of what Dockerhub can do,
far beyond what we can cover in todays introduction can be found in
Docker's official Dockerhub documentation `here <https://docs.docker.com/docker-hub/>`_.

In order to use it you'll need to register. With the free registration
you can deposit as many images as you want publicly, plus one private
image that is only accessible to you. You can buy more space for private images if you want
that.

Manual push
~~~~~~~~~~~

I have made a public repository to show you how to deposit custom images
on Dockerhub - it's `here <https://hub.docker.com/r/chrishah/docker-training-push-demo>`_ .

Let's deposit our image there. In order for Dockerhub to know where the
image should go I need to rename it to match the name of the repository
which is usually something like ``username/reponame``. My Dockerhub
username is ``chrishah``, and I called the repo
``docker-training-push-demo``. Note that I will also give the image a
specific tag ``v04042023``. This could be anything as long as it's in
one word an all lower case.

.. code:: bash

    (host)-$ docker tag ${USER}s_automatic_blast_image chrishah/docker-training-push-demo:v04042023

Now we can push it Dockerhub.

.. code:: bash

    (host)-$ docker push chrishah/docker-training-push-demo:v04042023

Done! Check it out on `Dockerhub <https://hub.docker.com/r/chrishah/docker-training-push-demo>`_.

This image can now be pulled and used by anybody!

.. code:: bash

    (host)-$ docker run --rm chrishah/docker-training-push-demo:v04042023 blastn -h

Also, if you happen to be using ``Singularity`` rather than ``Docker``,
this image is compatible. Assuming you have ``Singularity`` up and
running you could just do the following (add ``--disable-cache`` to pull
afresh):

.. code:: bash

    (host)-$ singularity exec docker://chrishah/docker-training-push-demo:v11072022 blastn -h

Automated build
~~~~~~~~~~~~~~~

A very neat feature in my opinion is that Dockerhub allows you
to link its repos to Github repositories. By this, one can neatly and
reprodcibly organize ones Docker containers.

Check out this example `here <https://hub.docker.com/r/chrishah/ncbi-blast>`_.


Exercises
=========

.. warning::

   If you do the following exercises on a shared resource, i.e. you are sharing Docker with multiple users on a single computer (e.g. AWS instance), please make sure that you build your images under unique names. Something like ``${USER}_imagename``.



.. admonition:: Exercise 1

   `Clustalo <http://www.clustal.org/omega/>`_ is a very popular tool for multiple sequence alignment. It can be easily installed with conda, or built from source, or simply setup with precompiled binaries.
   
   Write a ``Dockerfile`` and build an image to run ``clustalo`` version 1.2.4 in Ubuntu:20.04 or Ubuntu:22.04. 
   Possible solutions can be found here:
 
   - `apt <https://github.com/reslp/reproducibility-workshop/blob/main/additional-data/dockerfiles/clustalo.apt.Dockerfile>`_
   - `binaries <https://github.com/reslp/reproducibility-workshop/blob/main/additional-data/dockerfiles/clustalo.binaries.Dockerfile>`_
   - `conda <https://github.com/reslp/reproducibility-workshop/blob/main/additional-data/dockerfiles/clustalo.conda.Dockerfile>`_
   - `mamba <https://github.com/reslp/reproducibility-workshop/blob/main/additional-data/dockerfiles/clustalo.mamba.Dockerfile>`_.


.. admonition:: Exercise 2

   `Flye <https://github.com/fenderglass/Flye>`_ is a denovo genome assembler built for long reads (PacBio and ONT). It performs very well and is relatively fast and memory efficient, as far as denovo assemblers go.. ;-) 
   Check out the installation instructions of Flye on their Github `page <https://github.com/fenderglass/Flye/blob/flye/docs/INSTALL.md>`_.
   
   Write a ``Dockerfile`` and build an image for the Flye assembler **(version 2.9)** running in Ubuntu 20.04. According to the installation `instructions <https://github.com/fenderglass/Flye/blob/flye/docs/INSTALL.md>`_ you could get it through conda or build it locally. 
   Possible solutions can be found here:

   - `build <https://github.com/reslp/reproducibility-workshop/blob/main/additional-data/dockerfiles/flye.build.Dockerfile>`_
   - `mamba <https://github.com/reslp/reproducibility-workshop/blob/main/additional-data/dockerfiles/flye.mamba.Dockerfile>`_.


.. admonition:: Exercise 3

   Another interesting tool in the context of long read genome assembly is `LongStitch <https://github.com/bcgsc/longstitch>`_. This is a pipeline for scaffolding of draft assemblies with long reads incorporating multiple tools and controlled through ``make``. I found it relatively difficult to set up because of the many dependencies it requires, but if you like a challenge .. ;-)

   Write a ``Dockerfile`` and build an image for LongStitch.

   A possible solution can be found `here <https://github.com/reslp/reproducibility-workshop/blob/main/additional-data/dockerfiles/longstitch.Dockerfile>`_.


Phew, for a minute there ... **Well Done !!!**


Demos
=====

.. warning::

    The following demos are assuming that you are running Docker locally on your computer. They can also be run on a server and forwarded to your local computer via port forwarding, but this is a little bit more advanced topic.


Running an RStudio server
-------------------------

The demo is inspired by `this <http://ropenscilabs.github.io/r-docker-tutorial/>`_ tutorial (last accessed 24.04.2020) and relies on images provided by
The Rocker Project (see also the Github `Wiki <https://github.com/rocker-org/rocker/wiki>`_).

Start the RStudio server Docker container like so:

.. code:: bash

    (host)-$ docker run -e PASSWORD=yourpassword --rm -p 8787:8787 rocker/rstudio:4.0.3

Then scoot to ``http://localhost:8787`` in your webbrowser. Enter your
username ``rstudio`` (per default) and password we've set it to
``yourpassword`` when we called the container.

If you also want to read/write files on your host from within the
container, you can extend the above command, like so, e.g.:

.. code:: bash

    (host)-$ docker run -d -e PASSWORD=yourpassword -e USERID=$UID --rm -v $(pwd):/working -w /working -p 8787:8787 rocker/rstudio:4.0.3

For an example Dockerfile you can use to build an Rstudio image that has
some packages already pre-installed, see this
`Dockerfile <https://github.com/chrishah/docker-intro/tree/master/Dockerfiles/Dockerfile>`__.
Incidentally, this is the RStudio server setup I used for doing the Differential
Expression analyses a few lectures ago. For a Dockerfile setting up plain R with all dependencies for running SarTools go `here <https://github.com/chrishah/R-SARTools-plus-docker/blob/main/Dockerfile>`_ and find the corresponding image `here <https://hub.docker.com/r/chrishah/r-sartools-plus>`_.

Jupyter Notebook
----------------

`Cyverse <https://cyverse.org/>`_ US has created a number of Docker images and deposited the contexts on Github `here <https://github.com/cyverse-vice/>`_.

Very nice are for example their Jupyterlab Servers in Docker containers.
Try the following, but note that this image is rather large and may take
a while to download, depending on your download speed..

.. code:: bash

    (host)-$ docker run -it --rm -v /$HOME:/app --workdir /app -p 8888:8888 -e REDIRECT_URL=http://localhost:8888 cyversevice/jupyterlab-scipy:2.2.9

Once the download has finished and the server started running move to
``http://localhost:8888`` in your webbrowser. Cool, no?

Here's another one that has ``snakemake`` setup within it.

.. code:: bash

    (host)-$ docker run -it --rm -v /$HOME:/app --workdir /app -p 8888:8888 -e REDIRECT_URL=http://localhost:8888 chrishah/snakemake-vice:v05062020 

Mkdocs server
-------------

MkDocs (`mkdocs.org <https://www.mkdocs.org/>`_) is a neat tool for creating project documentation sites. Instead of installing and running it locally, why not build it into an image and run it from within a Docker container?

To keep things organized, let's first make a new directory.

.. code:: bash

    (host)-$ mkdir mkdocs && cd mkdocs

Open your favorite text editor, copy, paste and save the following text
into a file called ``Dockerfile`` in the ``mkdocs`` directory you've
just created.

::

    FROM jfloff/alpine-python:2.7-slim

    WORKDIR /usr/src/app

    RUN pip install --no-cache-dir mkdocs==0.17.1 Pygments==2.2 pymdown-extensions==3.4

    WORKDIR /docs

    EXPOSE 8000

    ENTRYPOINT ["mkdocs"]
    CMD ["serve", "--dev-addr=0.0.0.0:8000"]

Now, build your image:

::

    (host)-$ docker build -t mkdocs-serve .

I've deposited the context for a little test site on Github - let's
clone it - guess what, using Docker..

.. code:: bash

    (host)-$ docker run -ti --rm -v ${HOME}:/root -v $(pwd):/git alpine/git:v2.24.2 clone https://github.com/chrishah/mkdocs-readthedocs-docker-demo.git

Then, move into it - ``cd mkdocs-readthedocs-docker-demo/``.

Now we're ready to launch our server.

.. code:: bash

    (host)-$ docker run -it --rm -p 8000:8000 -v ${PWD}:/docs --name mkdocs-serve mkdocs-serve

In your webbrowser, scoot to ``http://localhost:8000`` and see what you
have done.

Shut down the running server by pressing ``CTRL+C``.

*Note:* If you cloned the context of the test site using the method
above, you might need to change permissions on the directory in case you
want to modify it, like so
``sudo chown -R $USER:$USER mkdocs-readthedocs-docker-demo/``.

Links
=====

-  `Dockerhub <https://hub.docker.com/>`_
-  Dockerhub's `documentation <https://docs.docker.com/docker-hub/>`_
-  The Rocker Project `Main <https://www.rocker-project.org/>`_ / Github `Wiki <https://github.com/rocker-org/rocker/wiki>`_

Contact
=======

Christoph Hahn - christoph.hahn@uni-graz.at
