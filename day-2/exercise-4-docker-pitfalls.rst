===============================
Exercise 4 - Container pitfalls
===============================

The 'latest' tag is not your friend
===================================

Pulling and running a container from an online repo is super easy. Be aware that container images are deposited with tags, which identify versions of a given container. Note that often, per default, if you do not give a specific tag you will get the ``latest``. 

Try it out.

.. code:: bash

   (user@host)-$ docker run ubuntu echo "Hello new container"

Now checkout your list of images.

.. code:: bash

   (user@host)-$ docker image ls | grep "ubuntu"

You'll see that in addition to the specific versions of Ubuntu images we used before we now also have ``latest`` in our list. Right now it happens to be the same image as ``22.04`` - **observe the hash** - but this will change as time goes by.. Pulling ``latest`` in half a year may/will give you another image. 

.. warning::

   Using ``latest`` tag is fine for testing, but if you attempt to work reproducibly, **USE SPECIFIC TAGS**.


The root 'problem'
==================

Within Docker containers we normally appear as root users. This is necessary - after all we want to have all rights to install packages, etc. in the container. The way Docker works this root privileges also need to extend to the local system on which the Docker daemon is running. Actually you always have to run Docker as root user, so ``sudo docker run ..``, and you will sometimes see that in Docker discussions. On the system wer are running we have created a Docker usergroup and added each user to it. Members of the docker group were given root privileges per default, so you don't have to use ``sudo`` each time. This is just for convenience and so you know.

**This has already been done for you**, but just so you know for the future if you set up Docker yourself. Add your user to the docker group of users.

.. code:: bash

   (user@host)-$ sudo usermod -aG docker ${USER}

Let's look at the consequences this has.

Create a file as 'you' on your local system.

.. code:: bash

   (user@host)-$ touch file.from.user.txt

Now, check what metadata this file has attached to it.

.. code:: bash

   (user@host)-$ ls -hl file.from.user.txt

The third column in the answer you get shows the user that is the owner of this file, i.e. who created it: e.g. ``user22`` and in the fourth column you see through which usergroup the user was acting when he/she created it: e.g. ``user22``. Normally, each user has it's own usergroup per default.

Now, let's create a file through a container.

.. code:: bash

   (user@host)-$ docker run --rm -v $(pwd):/in -w /in ubuntu:22.04 touch file.from.docker.txt


Let's have a look at the metadata of both files.

.. code:: bash

   (user@host)-$ ls -hlrt file.from.*.txt

Spot the difference? The file created through docker looks like it's been created by ``root``, so as if someone with root privileges, e.g. the system admin has come around and made this file.

One consequence is that your average user (without root privileges) can't remove or modify this file.

.. code:: bash

   (user@host)-$ rm file.from.docker.txt

This can be anoying.. 

Two ways around that. 

First, forward your user information to the container. Note the extra flags in the Docker command. I've just split the command across multiple lines to make it easier readable (Note the ``\`` at the end of each line).

.. code:: bash

   (user@host)-$ docker run --rm -v $(pwd):/in -w /in -u $(id -u):$(id -g) ubuntu:22.04 \
                                                     touch file.from.docker_as_user.txt

Now let's see.

.. code:: bash

   (user@host)-$ ls -hlrt file.from.*.txt

Solved, right? And quite elegantly so..

However, be aware that whether you will be able to use this solution depends heavily on the container and how it was set up and so there is no guarantue. Sometimes you'll need ``sudo`` rights within the container to actually run the program within and with what we did above we gave those up.

Now, if you happen to work with a container with which the above solution does not work, you can always 'cheat' the system by using another container (with root privileges) to actually change the metadata of the files to look like they've been produced by your user. Note that the ``-R`` flag below is not necessary when applied to just a single file. It stands for recursive and when applied to a directory it would change the metadata for all files and all subdirectories within the one it was applied to - for future reference.

.. code:: bash

   (user@host)-$ docker run --rm -v $(pwd):/in -w /in ubuntu:22.04 chown -R $(id -u):$(id -g) file.from.docker.txt

Check it out.

.. code:: bash

   (user@host)-$ ls -hlrt file.from.*.txt


.. warning::

   I want to draw your attention to the fact that of course through tricks like the above we could actually modify parts of the system that as a regular user we don't have the right to - and probably for good reasons. 

   This is why system admins don't 'like' Docker and we resort to Singularity on such systems because it is more restrictive with respect to user privileges.


What's actually in the container?
=================================

If you surf to `DockerHub <https://hub.docker.com/>`_, or other repositories, like `Quay.io <https://quay.io/>`_, you will find containers for many of your favourite tools. These are fantastic resources. 

However, it needs to be made clear that very often it's not entirely (or not at all) transparent what actually is in the container, other than that it claims to contain a certain piece of software. This is particularly true if the Docker Image is the result of a manual push, as demonstrated in a previous exercise.

Of course the same argument could be made for a lot of other 'black boxes' of software. I just want to stress that Docker, per se, isn't solving this problem.

See for example this container on `DockerHub <https://hub.docker.com/r/biocontainers/spades>`_. If you browse through this repository you can find some info about how it was built and so on but overall it's not really easily accessible or satisfying.

Automated builds should solve this to a certain extent, right. I mean we hook up our Docker repo to a Github repo that contains the Dockerfile. If you go, for example to `this <https://hub.docker.com/r/staphb/spades>`_ repository, you will see that on the main page this is linked to a Github repository. However, also here the very version of the Dockerfile that was used to create the image may be hard to find.

We've mentioned tags above as a prerequisite to work reproducibly with containers. However, there is no guarantuee that if you pull ``user/image:tag-xyz`` today and then again in half a year, that the same tag actually gives you the same image.


Dockerfiles alone aren't reproducible
=====================================

Until recently I thought: 

*Everything I need is my Dockerfile to be reproducible.* 

I can share it with the community and if I or anyone else wants to build the same container they can just reuse the recipe.

**This is not neccessarily true.**

Why? Because we tend to build on other people's Docker images and, as stressed above, images may change even if their tags stay the same. Users may just remove their images from DockerHub or other repos.

The only real long term solution I see currently, is saving your images locally. 

Unfortunately, as far as we are aware, there is currently no dedicated system that guarantuees permanent long term storage of containers, including e.g. assignment of a `DOI <https://www.doi.org/>`_. So far the community doesn't seem to have picked up on that on a larger scale.

You can upload images to and receive DOI from, e.g. `Dryad <https://datadryad.org/stash>`_, this is not a dedicated Image repository, however, but it can be a solution in the meantime.


