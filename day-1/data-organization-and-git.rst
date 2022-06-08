=======================================================
Exercise 3 - Data organization and proper documentation
=======================================================

First let us create a new project with a basic directory structure that can help us to organize our data better:

.. codeblock:: bash
	$ mkdir my_project
	$ cd my_project
	$ mkdir bin data doc results tmp


At the beginning of a project, all directories will be empty, however they will fill quickly as you continue to work on the project.

Information in your project's directories 
=========================================

The suggested directory structure is intuitive (it follows basic naming convention on \*nix systems) as well as general enough to fit many different use cases. It should be relatively clear what should be put where. Of course it is up to you to decide where to place stuff, but keep in mind that your choice is reasonable and intuitive. For example if you, for some reason place a subset of Illumina read FASTQ files into `tmp/illumina/subsets` you may spend more time searching for the data then if you would have placed it into `data/`. Also, if you collaborate with somebody and send them your project, it may also be difficult for them to figure out where the subsetted Illumina read files are.


Keeping track of your project using git
=======================================

Important terms:

* repository: Your directory that you would like to track with git. Also often called repo.
* commit: A snapshot of your repository with all the changes since your last commit. They are essential to your repository to keep track of all changes. You can also jump between commits to recover different versions of file.
- 

Initialize a new repository
---------------------------

With [git](https://git-scm.com/) you can easily track your work and see how it evolves into a large research project. A nice thing about git is that it uses very little memory and you almost don't 'see' it during your workflow. Git stays out of your way when you work on your project, but it is there when you need it. The first step when you start working with git is to create a repository or repo. On your machine a repo is just a folder that git is monitoring. It is straightforward to set up from within you projects directory using `git init`.

.. codeblock:: bash
	$ cd my_project 
	$ git init
	Initialized empty Git repository ...


Check the status of your repository
-----------------------------------


You should see a message that git init successfully create a git repository. Congratulations, Now your project is monitored by git. It is now possible to check the status of your repository with `git status`. This command is very handy to be able to see what git sees. Let us run it:

.. codeblock:: bash
	$ git status
	On branch master

	No commits yet

	nothing to commit (create/copy files and use "git add" to track)



Remeber this command. It is key to understand what git keeps track of and what not. You will use this command regularely. You can see that currently the repository is empty, also there are no tracked files. Let us change that and create a file in the doc directory. After this we run `git status` again.

.. codeblock:: bash
	$ touch protocol.md
	$ git status
	On branch master
	
	No commits yet

	Untracked files:
  	(use "git add <file>..." to include in what will be committed)

		protocol.md

	nothing added to commit but untracked files present (use "git add" to track)


You can see from the output of git status that git now has become aware of the `protocol.md` file. However git does not keep track of changes in the file yet, it is listed under "Untracked files".

Staging files
-------------


Now that git "sees" the file, we need to let it know that we would like to also track it. In git this is called Staging. The git command for that is called `git add`. See how it works:

.. codeblock:: bash
	$ git add protocol.md
	$ git status
	On branch master

	No commits yet

	Changes to be committed:
	  (use "git rm --cached <file>..." to unstage)

		new file:   protocol.md


`git add` will add the file to the staging environment. We are now ready to make a snapshot of the repository by making our first commit.

.. codeblock:: bash
	$ git commit -m "Adding the protocol.md file to the repository"
	[master (root-commit) 50d2cf8] First commit
	 1 file changed, 1 insertion(+)
	 create mode 100644 protocol.md


The commit command uses the flag `-m`. This flag takes a string as argument which is the commit message. The commit message describes what is in the commit. Make sure this is an informative message, because it will stay in your logfiles forever. Meaningful commit messages enable you to quickly idenftify what you did whitout having to look at the actual files.


This part of the git workflow is sometimes considered confusing. Why is it necessary to stage files first and how does git know that a file should be part of a commit? The answer to this question is that you can also combine changes of multiple files into a single commit. This makes sense, since you may be working on different things simultaneously or changes for one aspect of your project requires modifying multiple files. In this case you would probably want to group all changes together.




 
---
**NOTE**

You may wonder why git does not see the directories you created earlier. The reason is that git does not track directories at all. To make a directory visible to git, you need to place a file into it. We will look into that in more detail soon.
---









