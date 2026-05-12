.. role:: bash(code)
   :language: bash

==============================
Exercise 3 - Data organization
==============================

Organizing data properly is the first step to reproducible bioinformatic analyses. It will help you and your collaborators and it is probably one of the largest time savers when developing and maintaining computational workflows. Here we will have a look into how you can put structure into your research project files and folders on your computer. We have used the proposed structure in different projects and have come to the conclusion that this system works pretty well. Additionally we will introduce a common format called Markdown which you can use as digital lab books and to specify parameters for your analyses to make them more reproducible and transparent.

Objectives
==========

- Setup a directory structure
- Distinguish between raw data, processed data and metadata
- Learn how to use Markdown
- Start our first digital lab book

Information in your project's directories
=========================================

The suggested directory structure is intuitive (it follows basic naming conventions on \*nix systems) as well as general enough to fit many different use cases. It should be relatively clear what should be put where. Of course it is up to you to decide where to place stuff, but keep in mind that your choices are reasonable and intuitive. For example if you, for some reason place a subset of Illumina read FASTQ files into :bash:`tmp/illumina/subsets` you may spend more time searching for the data than if you would have placed it into :bash:`data/`. Also, if you collaborate with somebody and send them your project, it may also be difficult for them to figure out where the subsetted Illumina read files are.

.. code-block:: bash

    A quick recapitulation of the proposed structure:

    bin			contains scripts and executables for performing different analyses
    data		contains data files. Ideally separated into raw, processed and metadata
    results		contains analyses results. Ideally within subdirectories.
    tmp			Location of temporary files. The "playground" of your project
    doc			Contains all the documentation for your project.

For bioinformatic projects it is often useful to further subdivide the :bash:`data/` directory. Raw sequencing files, metadata tables and files derived from analyses should not be mixed. A possible structure could look like this:

.. code-block:: bash

    data/raw		original input data. These files should not be changed
    data/processed	data files generated from raw data
    data/metadata	sample sheets, collection information and data dictionaries

This distinction is important because raw data should be treated as read-only. If a file in :bash:`data/raw/` changes, it should be clear why and when this happened. One simple way to check if files have changed is to calculate checksums:

.. code-block:: bash

   $ md5sum data/raw/* > data/raw/checksums.txt

The file :bash:`checksums.txt` can later be used to verify that the raw input files are still identical. This is especially useful for large FASTQ files or genome assemblies which may be downloaded again or moved between computers.

.. admonition:: Exercise

   Your first task is to create a new project directory in your home directory with the subdirectories as listed above. Also create the subdirectories :bash:`data/raw`, :bash:`data/processed` and :bash:`data/metadata`. Is there something you are missing?

.. hint::

   We have created a shell script to initialize new projects. This script also initializes a git repository (we will learn about this in the next exercise) and adds your project's bin directory to the PATH if you want. You can find the script here on Github: `create-project.sh <https://github.com/reslp/reproducibility-workshop/blob/main/additional-data/create-project.sh>`_. It provides a stripped-down directory structure (minus some of the directories listed above).

Keeping track of your work
==========================

The digital lab book
~~~~~~~~~~~~~~~~~~~~

Apart from a clear and transparent directory structure, it is very important to keep track of what you are doing. If you have experience of working in a wet-lab, you are probably familiar with the concept of having a lab book. In a lab book you keep track of what exactly you did in the lab eg. which protocols you followed and how you altered them, how samples were treated etc. Usually lab-books have to stay in the lab even after you leave for a different job. We like you to think of computer environments as labs as well. This means that we need to make sure our "samples" are properly labeled (stored in well-organized project folders) and we keep a lab book containing instructions of what exactly we did. Similar to the wet-lab such notes will help to repeat analyses and they are an important step to increase reproducibility.

Requirements
~~~~~~~~~~~~

We can imagine several features a digital lab book should have so that it really facilitates reproducibility, clarity and collaboration.

Ideally a digital lab book should be:

- Accessible (this implies a standard file format)
- Platform independent (not specific to Linux/Windows/MacOS)
- Structured (in the sense that we can make different sections such as code, plain text, headers etc distinguishable)
- Internet ready
- Easy to read and edit

A good project should also contain a short :bash:`README.md` file in the main project directory. This file should explain what the project is about, where the data came from, which scripts or commands were used, and who worked on the project. A README does not have to be long. It only needs to contain enough information so that you, or someone else, can understand the project again after some time has passed.

It is also helpful to keep a small data dictionary or sample table in :bash:`data/metadata/`. Such a file should explain what each sample is, what the columns in a table mean, which units were used, and where the data came from. This is often more important than it may seem at the beginning of a project.

Introducing Markdown
~~~~~~~~~~~~~~~~~~~~

`Markdown <https://en.wikipedia.org/wiki/Markdown>`_ fulfills these criteria. Markdown is a simple markup language to create formatted text. It does not require any specific editor (although `many <https://github.com/mundimark/awesome-markdown-editors>`_ exist). It is easy to write and read and is a great tool to bring structure into your notes.

Markdown is written in plain text in any text-editor and it uses special characters to distinguish between headings, lists, blocks of programming code etc. This makes it easy to share and collaborate on markdown documents. Even without any prior knowledge of the markdown language they are easy to read. Originally it was created as an easy to read and write format that can be easily converted to HTML (a more complex and less easy to read markup language that is used to create websites). Now Markdown is used in many additional settings and it is perfect for creating documentation and notes.

Here is a first example showing many features of Markdown:

.. code-block:: bash

   # Heading

   ## Sub-heading

   ### Sub-Sub-Heading

   Headings can also be made like this
   ===================================

   Paragraphs are separated
   by a blank line.

   Two spaces at the end of a line
   produce a line break.

   ## You can also create tables:
   | Left columns  | Right columns |
   | ------------- |:-------------:|
   | left foo      | right foo     |
   | left bar      | right bar     |
   | left baz      | right baz     |

   ## Code or bash commands can be written like this:
   ```
   ls | wc -l
   ```

   Inline code can be written like this: `ls | wc -l`.

   *this will be written in italic*
   **this will be written in bold**


It should be self explanatory what this means. The :bash:`#` characters are used to create headings of different levels and there are other special characters to identify code blocks (`), bold (**) and italic (*) text can be used to create tables.

.. admonition:: Exercise

   It is much easier to understand Markdown when you see it live in action. In this exercise you should play around with Markdown directly in the browser.
   Go to `https://markdownlivepreview.com/ <https://markdownlivepreview.com/>`_ and see how it works. You can also copy and paste from your own local document.

Hopefully you agree that although we are using special characters here in otherwise regular text, it is still easy to read and comprehend. Apart from this Markdown truly shines when it is rendered. This means that headers become real headers, bold text becomes bold etc. There is a lot of dedicated software to render Markdown locally on your computer, and many websites (eg. Github) are able to do so as well.

Other Markdown languages
~~~~~~~~~~~~~~~~~~~~~~~~

Many different markdown languages exist for different purposes and with different features. In fact, the course material you are currently reading is also written in a markup language called `reStructuredText <https://de.wikipedia.org/wiki/ReStructuredText>`_. A cool thing about markdown languages is that they can be converted in one another relatively easily. With ``pandoc`` you can convert between different markdown languages and also produce PDF files and MS Word documents. It can be very handy when you want to share documents with collaborators or bring them into a format where they are better suited to be printed.

Let's see how it works:

.. code-block:: bash

   $ pandoc test.md --from markdown --to rst > test.rst

The above command converts a file from Markdown to reStructuredText.

.. admonition:: Exercise

   Play around with pandoc and convert your .md file into a few different formats. You may also look at the pandoc website `https://pandoc.org/ <https://pandoc.org/>`_ for more information and possible conversions.


A powerful command-line open-source note taking application
===========================================================

Many people have struggled with the above mentioned aspects of easily taking notes in a command line setting. A tool which combines many of the tools mentioned above to make note taking less painful is the application `nb <https://xwmx.github.io/nb/>`_. It also has several advanced features like encryption or syncing with git repositories. It is easy to use and scriptable. An introduction to nb would be beyond the scope of this course, but I suggest you give it a try. I think if you start using it you will quickly come across the concepts mentioned in this exercise.


Additional resources
====================

Once you start using Markdown more extensively, you will realize that it is used in many different settings that could complement your work. Here are some examples where Markdown is used. In fact, what we have shown today is the backbone technology of several software solutions such as RMarkdown in RStudio or Quarto. Although these solutions have additional features, the underlying concept of having pandoc based conversion of different Markup languages is the same in all of them.

- `R Markdown <https://rmarkdown.rstudio.com/>`_
- `Quarto <https://quarto.org/docs/guide/>`_
- `Markdown in Jupyter Notebooks <https://www.datacamp.com/tutorial/markdown-in-jupyter-notebook>`_
- `Markdown guide <https://www.markdownguide.org/>`_
- `Markdown cheatsheet <https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet>`_
- `John Gruber inventor of Markdown <https://daringfireball.net/projects/markdown/>`_






