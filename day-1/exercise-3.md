# Exercise 3 - Data organization and proper documentation


First let us create a new project with a basic directory structure that can help us to organize our data better:

```
$ mkdir my_project
$ cd my_project
$ mkdir bin data doc results tmp
```

At the beginning of a project, all directories will be empty, however they will fill quickly as you continue to work on the project.

## Information in your project's directories 

The suggested directory structure is intuitive (it follows basic naming convention on \*nix systems) as well as general enough to fit many different use cases. It should be relatively clear what should be put where. Of course it is up to you to decide where to place stuff, but keep in mind that your choice is reasonable and intuitive. For example if you, for some reason place a subset of Illumina read FASTQ files into `tmp/illumina/subsets` you may spend more time searching for the data then if you would have placed it into `data/`. Also, if you collaborate with somebody and send them your project, it may also be difficult for them to figure out where the subsetted Illumina read files are.


## Keeping track of your project using git

### Initialize a new repository

With [git](https://git-scm.com/) you can easily track your work and see how it evolves into a large research project. A nice thing about git is that it uses very little memory and you almost don't 'see' it during your workflow. Git stays out of your way when you work on your project, but it is there when you need it. The first step when you start working with git is to create a repository or repo. On your machine a repo is just a folder that git is monitoring. It is straightforward to set up from within you projects directory using `git init`.

```
$ cd my_project 
$ git init
Initialized empty Git repository ...
```

### Check the status of your repository

You should see a message that git init successfully create a git repository. Congratulations, Now your project is monitored by git. It is now possible to check the status of your repository with `git status`. This command is very handy to be able to see what git sees. Let us run it:

```
$ git status
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)

```

Remeber this command. It is key to understand what git keeps track of and what not. You will use this command regularely. You can see that currently the repository is empty, also there are no tracked files. Let us change that and create a file in the doc directory. After this we run `git status` again.

```
$ touch doc/protocol.md
$ git status
On branch master

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	doc/

nothing added to commit but untracked files present (use "git add" to track)
```

You can see from the output of git status that git now has become aware of the doc/ directory. However git does not keep track of changes in the files inside doc/ yet ("Untracked files"). 

---
**NOTE**

You may wonder why git does not see the directories you created earlier. The reason is that git does not track directories at all. To make a directory visible to git, you need to place a file into it. We will look into that in more detail soon.
---









