=======================================
Exercise 2 - Installing software reproducibly
=======================================

Ubuntu and other UNIX-like systems have package management tools that
allow you to conveniently install software, including necessary
dependencies. We’re probably not telling you anything new there. Be
aware that you have to have ``sudo`` rights to use ``apt``, but this
shouldn’t be a problem on your own computer for now.

That should foster reproducibility, right, since we can note down or
even script the exact installation steps for a given package. Let’s have
a look at Ubuntu’s Advanced packaging tools ``apt``.

Say, you’re interested in structural genome annotation. A very powerful
tool that is represented essentially in all larger genome annotation
pipelines is the ab-inito predictor ``augustus``. It is available on
Github `here <https://github.com/Gaius-Augustus/Augustus>`__.

On their Github repository we can find an
`Installation <https://github.com/Gaius-Augustus/Augustus#installation>`__
section. One of the options that is mentioned is ``apt``. Let’s try that
out.

We are just playing for now, so we have set up test environment for that
(how exactly this was done will be disclosed to you on Day2 of the
course at the latest).

Now, let’s enter a fresh Ubuntu 20.04 environment. Fresh in the sense
that nothing is installed there yet, just plain Ubuntu 20.04, as if you
had just set up your computer and switched it on for the first time.

.. code:: bash

   (user@host)-$ switch-on_ubuntu_20-04

You will see your prompt change - in this environment you are the root
user and have all rights you need to install packages globally. This you
would normally achieve by prepending ``sudo`` to your commands. You end
up in a ``/home`` directory that is currently empty.

.. code:: bash

   root@ubuntu-20-04:/home# ls
   root@ubuntu-20-04:/home# pwd
   /home

Now, let’s try to install ``augustus`` as suggested by the developers.
First, since we are on a fresh system we need to update ``apt``.

.. code:: bash

   root@ubuntu-20-04:/home# apt update

Then we can ``apt install``. You will have to confirm with ``y`` that
you sure want ``apt`` to go ahead and use up some extra disk space.

.. code:: bash

   root@ubuntu-20-04:/home# apt install augustus augustus-data augustus-doc

Seems to have worked. Now, let’s see which version of ``augustus`` we
got.

.. code:: bash

   root@ubuntu-20-04:/home# augustus --version
   AUGUSTUS (3.3.3) is a gene prediction tool
   written by M. Stanke, O. Keller, S. König, L. Gerischer and L. Romoth.

If the augustus developers hadn’t given us instructions I could have
asked ``apt`` directly if it has a package called augustus, too.

.. code:: bash

   root@ubuntu-20-04:/home# apt search augustus

Right, so this is the release of the software we’ve just installed. I
could note that down for future reference and also explicitly install
this version via ``apt``.

.. code:: bash

   root@ubuntu-20-04:/home# apt install augustus=3.3.3+dfsg-2build1

Installation done - happy Gene prediction - exit our environment for
now.

.. code:: bash

   root@ubuntu-20-04:/home# exit

Now, let’s say you have been happily predicting away for a couple of
years, then at some point you decide to set up your computer with the
current LTS version of Ubuntu. We are at LTS 22.04 at the moment.

Let’s switch it on ..

.. code:: bash

   (user@host)-$ switch-on_ubuntu_22-04

.. and initiate ``apt``.

.. code:: bash

   root@ubuntu-22-04:/home# apt update

We did our homework back then and noted the exact version of augustus
that we had. Let’s get it.

.. code:: bash

   root@ubuntu-22-04:/home# apt install augustus=3.3.3+dfsg-2build1

Ooops. Something’s not right. Shouldn’t this just work. Let’s search
``apt`` for augustus.

.. code:: bash

   root@ubuntu-22-04:/home# apt search augustus
   Sorting... Done
   Full Text Search... Done
   augustus/jammy 3.4.0+dfsg2-3build1 amd64
     gene prediction in eukaryotic genomes

   augustus-data/jammy 3.4.0+dfsg2-3build1 all
     data files for AUGUSTUS

   augustus-doc/jammy 3.4.0+dfsg2-3build1 all
     documentation files for AUGUSTUS

So, now you are faced with the reality that Ubuntu has moved on and
ships with a newer version of augustus now. Is that a problem? It
depends.. Let’s say you think it is. How to solve that now?

When we do our ``apt update`` apt reads in a special file that contains
the URLs for the source data of the repository. We can add the info of
the 20.04 LTS, which was called ``focal``, to this file.

.. code:: bash

   root@ubuntu-22-04:/home# release=focal
   root@ubuntu-22-04:/home# cat > "/etc/apt/sources.list.d/$release.list"<<EOF
   deb http://archive.ubuntu.com/ubuntu $release universe
   deb http://archive.ubuntu.com/ubuntu $release multiverse
   deb http://security.ubuntu.com/ubuntu $release-security main
   EOF

Then, update, and try to install again.

.. code:: bash

   root@ubuntu-22-04:/home# apt update
   root@ubuntu-22-04:/home# apt install augustus=3.3.3+dfsg-2build1 augustus-data=3.3.3+dfsg-2build1 augustus-doc=3.3.3+dfsg-2build1
   root@ubuntu-22-04:/home# augustus --version

Phew, seems to have worked! In this case.. I can report however, that
this will not always solve problems like that. It will depend on how
complicated the dependency structure of the particular software is.

Let’s be happy for now and return to our server.

.. code:: bash

   root@ubuntu-22-04:/home# exit

What to do if this hadn’t solved it? What other options do we have?
Well, you can normally build software from source. Augustus comes with
instructions for that
`here <https://github.com/Gaius-Augustus/Augustus/blob/master/docs/INSTALL.md>`__.

We are not doing that now, but have a look at them for 3 minutes and see
that this is not necessarily straightforward. There’s lots of
dependencies you’ll need and believe me it doesn’t just work out of the
box in Ubuntu 22.04. I tried .. ;-)

Another option could be to install augustus in a Docker container in the
first place. We will introduce Docker on Day2 of the course. For now, I
just want to draw your attention to the fact that Augustus already gives
Docker as a valid option for setting up the software. See
`here <https://github.com/Gaius-Augustus/Augustus#docker>`__. They
provide a so-called Dockerfile. Isn’t that neat. We’ll return to that in
the section ‘Pitfalls and caveates of Docker’ on Day2.

Finally, you could use another package management system called ``conda``.
Augustus has a conda recipe - see `here <https://anaconda.org/bioconda/augustus>`__.
We'll discuss ``conda`` including potential pitfalls as well on Day2.

Thanks for joining us today!!

