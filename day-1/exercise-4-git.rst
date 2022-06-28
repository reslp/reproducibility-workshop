.. role:: bash(code)
   :language: bash


=====================================
Exercise 4 - Version control with Git
=====================================



Keeping track of your project using git
=======================================

Important terms:

repository
	Your directory that you would like to track with git. Also often called repo.
commit
	A snapshot of your repository with all the changes since your last commit. They are essential to your repository to keep track of all changes. You can also jump between commits to recover different versions of file.

Initialize a new repository
---------------------------

With `git <https://git-scm.com>`_ you can easily track your work and see how it evolves into a large research project. A nice thing about git is that it uses very little memory and you almost don't 'see' it during your workflow. Git stays out of your way when you work on your project, but it is there when you need it. The first step when you start working with git is to create a repository or repo. On your machine a repo is just a folder that git is monitoring. It is straightforward to set up from within you projects directory using :bash:`git init`.

.. code-block:: bash

    $ cd my_project 
    $ git init
    Initialized empty Git repository ...

It is generally also a good idea to set up git with your name and email address so that contributions to a repository can be attributed transparently. This can be done with the following commands. They will set the global settings of git, it is only necessary to do this once regardless of how many reporitories you initialize.

More information `here <https://git-scm.com/docs/git-init>`_.

.. code-block:: bash

    $ git config --global user.name "FIRST_NAME LAST_NAME"
    $ git config --global user.email "MY_NAME@example.com"

.. hint::

    If you would like to perform this action only for your current repository, you just have to leave out the :bash:`--global` flag.

Check the status of your repository
-----------------------------------


You should see a message that git init successfully create a git repository. Congratulations, Now your project is monitored by git. It is now possible to check the status of your repository with :bash:`git status`. This command is very handy to be able to see what git sees. Let us run it:

.. code-block:: bash

    $ git status
    On branch master

    No commits yet

    nothing to commit (create/copy files and use "git add" to track)


Remember this command. It is key to understand what git keeps track of and what not. You will use this command regularely. You can see that currently the repository is empty, also there are no tracked files. Let us change that and create a file in the doc directory. After this we run :bash:`git status` again.

More information `here <https://git-scm.com/docs/git-status>`_.

.. code-block:: bash

    $ touch protocol.md
    $ git status
    On branch master
	
    No commits yet

    Untracked files:
    (use "git add <file>..." to include in what will be committed)

       protocol.md

    nothing added to commit but untracked files present (use "git add" to track)


You can see from the output of git status that git now has become aware of the :bash:`protocol.md` file. However git does not keep track of changes in the file yet, it is listed under "Untracked files".

Staging files
-------------

Now that git "sees" the file, we need to let it know that we would like to also track it. In git this is called Staging. The git command for that is called :bash:`git add`. See how it works:

.. code-block:: bash

    $ git add protocol.md
    $ git status
    On branch master
    
    No commits yet
    
    Changes to be committed:
      (use "git rm --cached <file>..." to unstage)
    
    	new file:   protocol.md


:bash:`git add` will add the file to the staging environment. We are now ready to make a snapshot of the repository by making our first commit.

More information `here <https://git-scm.com/docs/git-add>`_.


Commit changes
--------------

Committing changes (remember that all changes to be committed first need to be staged), is what makes git remember. A commit is a snapshot of the complete repository at a given time. Creating a commit requires the :bash:`git commit` command. Seee below:

.. code-block:: bash

    $ git commit -m "Adding the protocol.md file to the repository"
    [master (root-commit) 50d2cf8] First commit
     1 file changed, 1 insertion(+)
     create mode 100644 protocol.md


As you can see we are using the flag :bash:`-m`, which is short for message. This flag takes a string as argument which will become the commit message. The commit message describes what is contained in the commit. Make sure this is an informative message, because it will stay in your git log. Meaningful commit messages enable you to quickly idenftify what you did whitout having to look at the actual files.

More information `here <https://git-scm.com/docs/git-commit>`_.

.. admonition:: Exercise

    Create a short protocol in Mardown format of what we did so far to your :bash:`protocol.md` file and commit the changes to your repository.

Stage and commit. Why two steps?
--------------------------------

Let us quickly recapitualte what we have learned so far about working with git. A typical git workflow would look like this:

	1. Make changes to your file.
	2. Add the file to your staging area with :bash:`git add`.
	3. Commit your staged file using :bash:`git commit` and use an informative commit message.

It is sometimes considered confusing that git uses this two-part workflow with staging and commiting. Why is it necessary to stage files first and how does git know that a file should be part of a commit? The answer to this question is that you can also combine changes of multiple files into a single commit. This makes sense, since you may be working on different things simultaneously or changes for one aspect of your project requires modifying multiple files. In this case you would probably want to group all changes together and only create a single commit.


Keeping track of your commits
=============================

Git offers several commands which let you quickly check the history of your repository. Let us look at our repository now:

.. code-block:: bash

    $ git log --oneline
    13202ab (HEAD -> master) Add protocol document
    50d2cf8 First commit

    $ git log
    commit 13202abad4911ba1158161b0ab8120a3be2e1387 (HEAD -> master)
    Author: Philipp Resl <xxx@yyy.com>
    Date:   Thu Jun 9 13:39:43 2022 +0200

         Add protocol document

    commit 50d2cf80c9461eef8f67c9273eec8fd3e687162b
    Author: Philipp Resl <xxx@yyy.com>
    Date:   Tue Jun 7 13:23:04 2022 +0200

         First commit

 
The difference between the two commands presented above is simply the amount of information you get controlled by the :bash:`--oneline` flag. The standard :bash:`git log` command show additional information such as who contributed to the repository and the exact date and time of the commits. The last commit is always on top of the list. It is also called HEAD. This is also indicated by :bash:`(HEAD -> master)` which also tells you the branch you are on. In this case: master. We did not talk about branches yet. This will come a little bit later.

To make them identifiable commits get unique IDs that consists of combinations of numbers and letters. These are also called hashes. We can use commit hashes to switch between different versions of the repository. For example let us try to switch back to the First commit with the hash :bash:`50d2cf8` (long version: :bash:`50d2cf80c9461eef8f67c9273eec8fd3e687162b`). Mind you, that your hashes will be different. You need to use the ones from your :bash:`git log` output. 

More information `here <https://git-scm.com/docs/git-log>`.

Reverting to an older version of your repository
================================================

Since git keeps track of all your commited changes by using unique hashes, it is also possible to revert the repository to a specific commit. This is done with :bash:`git checkout`. 

.. code-block:: bash
   
   $ git checkout 50d2cf8
   You are in 'detached HEAD' state. You can look around, make experimental
   changes and commit them, and you can discard any commits you make in this
   state without impacting any branches by performing another checkout.
   
   If you want to create a new branch to retain commits you create, you may
   do so (now or later) by using -b with the checkout command again. Example:

      git checkout -b <new-branch-name>

   HEAD is now at 50d2cf8 First commit 


This will revert (checkout) your repository to how it was when you made your first commit.

.. admonition:: Exercise

    Revert your reporitory to the second commit we made earlier. Hint you may use :bash:`git reflog` to get the hash.

More information `here <https://git-scm.com/docs/git-checkout>`_.

Ignoring files
==============

In general git is aware of all files in your repository. However, it is common that there are files which you do not want to be tracked e.g. large input files or software executables which your are not allowed to distribute. 

You can tell git to ignore files by using what is called a :bash:`.gitignore` file. In this file you can add all folders and files which git should ignore, each entry on its own line. You can also use regular expressions to specify multiple files. Here are some examples from a :bash:`.gitignore` file:

.. code-block:: bash

   $ cat .gitignore
   data/raw_reads.fq.gz
   data/*.fq
   software/
   log/
   !log/.gitkeep

These covers several practical examples of how you can exclude (and keep) files. It should be pretty self explanatory what they do. Lines starting with ! have a special meaning though. It means that this file will not be included. Remember earlier when we said that it is not possible to commit empty directories to a git repository? This is a away around this problem.
Git treats your .gitignore file as a regular file, so make sure to also commit the changes to it.


.. admonition:: Exercise

   Create two files in your repository and add one of these files to your :bash:`.gitignore` file. Hint: You can use :bash:`git status` to keep track of the files and find you what git "sees". 

Branches
========

Sometimes you may want to make larger changes to your repository with the risk that they are incompatible with your main workflow. Of course you don't want to overwrite anything that already works. It may also be that you collaborate with somebody on a project and you don't want to mess up their work in the shared repository. In souch cases git offers a concept called branches. A branch is exactly what the name implies. It creates a named branch of your repository starting from a specific commit (usualy HEAD). A branch may contain many commits and you may have many branches. At a later stage, branches can also be merged to combine all commits. The standard branch is called master or main. :bash:`git status` will show you the current branch you are in. These examples should make it more clear:

.. code-block:: bash

   $ git branch testbranch
   $ git checkout testbranch
   $ git status
     On branch testbranch
     nothing to commit, working tree clean

First we have to create a branch and give it a name: :bash:`git branch testbranch`. Next we need to switch to that branch: :bash:`git checkout testbranch`. With :bash:`git status` we can now see that we are working in this new branch. Everyting we commit will be committed to this new branch.

More information `here <https://git-scm.com/docs/git-branch>`_.


Merging branches
================

At some point you may want to combine work made in different branches. This is possible with :bash:`git merge`. Typically you will want to merge your new branch with the main (or master) branch. Git will identify the last commit the branches we want to merge have in common and it will create a new merge commit. Before merging you need to make sure thate the current HEAD is in the branch that should be the merge target. This means you will need to check out the branch you want to merge with first. This is typicall is the main (or master) branch. Given we are already in the main branch we can merge a branch with master like this:

.. code-block:: bash

   $ git merge testbranch
     Merge made by the 'recursive' strategy.
      bla | 1 +
      1 file changed, 1 insertion(+)

More information `here <https://git-scm.com/docs/git-merge>`.

.. warning::

   Merging can be tricky and cause conflicts if commits made in different branches change the same file. In such a case you need to manually inspect the conflicting files to resolve the problem.

.. admonition:: Exercise

   Create a new branch, and make two commits to this branch and merge it with the master branch.

Working with online Git repositories
====================================

There are several services that provide online services that provide hosting of git repositories. The three large services are `Github <https://github.com/>`_ `Gitlab <https://about.gitlab.com/>`_ and `BitBucket <https://bitbucket.org/>`_. Many different bioinformatic software packages are hosted and developed using one of these platforms. It is one of the great strengths of git to be able to access repositories that are located on different computers. It greatly facilitates collabrative work, transparency and reproducibility. 

Each of the three platforms have their own special features complementing the core functionality of git. There is a lot you can do on these platforms going far beyond this introduction here. We will therefore only provide a very general introduction to how to interact with online repositories. Here is a simple example:

.. code-block:: bash

   $ git clone https://github.com/reslp/reproducibility-workshop.git
     Cloning into 'reproducibility-workshop'...
     remote: Enumerating objects: 54, done.
     remote: Counting objects: 100% (54/54), done.
     remote: Compressing objects: 100% (32/32), done.
     remote: Total 54 (delta 25), reused 45 (delta 19), pack-reused 0
     Unpacking objects: 100% (54/54), done.

:bash:`git clone` is the command to create a local copy of the repository of this course hosted on Github. It will download the complete repository, together with a complete history of all commits on all branches.

More information `here <https://git-scm.com/docs/git-clone>`_.


Transfering local changes to an online repository
=================================================

If you have made local changes to a repository, at some point you will want to include these changes in the online version of it. This is called pushing and the corresponding command is :bash:`git push`.

.. code-block:: bash

  $ git push origin main

This command will push all committed changes made in the main branch to the online repository (which is called origin).

More information `here <https://git-scm.com/docs/git-push>`_.

Getting changes from an online repository
=========================================

It can happen that changes have been pushed to an online repository, but your local copy is older and you do not have the latest changes. In such a case you can download all changes from a remote repository directly into your local copy:

.. code-block:: bash

   $ git pull
   
This command will compare the remote and local repositories and will download all changes from the remot version of the repository

More information `here <https://git-scm.com/docs/git-pull>`_.

There is a lot more...
=======================

This practical can only be considered a basic introduction to git. Git can do a lot more. The commands provided here will get you started and as you familiarize and apply them in your own projects you will quickly discover additional functionality. Here are additional resources that we found helpful when learning git.

    - `Git reference manual <https://git-scm.com/docs>`_
    - `Git Pro Book <https://git-scm.com/book/en/v2>`_
    - `Oh Shit, Git?! <https://ohshitgit.com/>`_
    - `W3 Schools Git Tutorial <https://www.w3schools.com/git/>`_
    - `Learn Git interactively <https://learngitbranching.js.org/>`_ 
    - `Linus Torvalds talking about Git <https://www.youtube.com/watch?v=4XpnKHJAok8>`_
    - `A Quick Introduction to Version Control with Git and GitHub <https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004668>`_
