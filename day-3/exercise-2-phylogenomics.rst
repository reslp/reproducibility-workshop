Exercise 2 - Creating a self sustained bioinformatic pipeline
=============================================================

Phylogenomics tutorial based on BUSCO genes

.. admonition:: Disclaimer

  To follow the demo and make the most of it, it helps if
  you have some basic skills with running software tools and manipulating
  files using the Unix shell command line. It assumes you have Singularity
  installed on your computer (tested with Singularity version 3.6.3 on Ubuntu 18.04).

Introduction
------------

We will be reconstructing the phylogenetic relationships of some
(iconic) vertebrates based on previously published whole genome data.
The list of species we will be including in the analyses, and the URL
for the data download can be found in `this <https://github.com/chrishah/phylogenomics_intro_vertebrata/blob/main/data/samples.csv>`_ table.

All software used in the demo is deposited as Docker images on `Dockerhub <https://hub.docker.com/>`_
and all data is freely and publicly available.

The workflow we will demonstrate is as follows:

 - Download genomes from Genbank
 - Identifying complete BUSCO genes in each of the genomes
 - pre-filtering of orthology/BUSCO groups
 - For each BUSCO group:
   - build alignment
   - trim alignment
   - identify model of protein evolution
   - infer phylogenetic tree (ML) - construct supermatrix from individual gene alignments
 - infer phylogenomic tree with paritions corresponding to the original gene alignments using ML

Let's begin
~~~~~~~~~~~

Before you get going I suggest you download this repository, so have all
scripts that you'll need. Ideally you'd do it through ``git``.

.. code:: bash

    (user@host)-$ git clone https://github.com/chrishah/phylogenomics_intro_vertebrata.git

Then move into the newly cloned directory, and get ready.

.. code:: bash

    (user@host)-$ cd phylogenomics_intro_vertebrata

**1.) Download data from Genbank**

What's the first species of vertebrate that pops into your head?
*Latimeria chalumnae* perhaps? Let's see if someone has already
attempted to sequence its genome. NCBI Genbank is usually a good place
to start. Surf to the `webpage <https://www.ncbi.nlm.nih.gov/genome/>`__
and have a look. And indeed we are
`lucky <https://www.ncbi.nlm.nih.gov/genome/?term=Latimeria+chalumnae>`__.

Let's get it downloaded. Note that the ``(user@host)-$`` part of the
code below just mimics a command line prompt. This will look differently
on each computer. The command you actually need to execute is the part
after that, so only, e.g. ``mkdir assemblies``:

.. code:: bash

    #First make a directory and enter it
    (user@host)-$ mkdir assemblies
    (user@host)-$ mkdir assemblies/Latimeria_chalumnae
    (user@host)-$ cd assemblies/Latimeria_chalumnae


    #use the wget program to download the genome
    (user@host)-$ wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/225/785/GCF_000225785.1_LatCha1/GCF_000225785.1_LatCha1_genomic.fna.gz

    #decompress for future use
    (user@host)-$ gunzip GCF_000237925.1_ASM23792v2_genomic.fna.gz

    #leave the directory for now
    (user@host)-$ cd ../..

We have compiled a list of published genomes that we will be including
in our analyses
`here <https://github.com/chrishah/phylogenomics_intro_vertebrata/tree/main/data/samples.csv>`__.
You don't have to download them all now, but do another few just as
practice. You can do one by one or use your scripting skills (for loop)
to get them all in one go.

To keep things clean I'd suggest to download each into a separate
directory that should be named according to the binomial (connected with
underscores, rather than spaces) - see example for *L. chalumnae* above.

**2.) Run BUSCO on each assembly**

.. warning::

   Since these genomes are relatively large BUSCO takes quite a while to run so this step has been already done for you.
   For a separate session detailing common steps for evaluating draft genome assemblies, including an example on how to run BUSCO, we refer you to `this <https://github.com/chrishah/post-assembly-intro>`_ repo.

A reduced representation of the BUSCO results for each species ships
with our repository in the directory
``results/orthology/busco/busco_runs``.

Take a few minutes to explore the reports.

**3.) Prefiltering of BUSCO groups**

.. admonition:: Important Information

  In this tutorial we'll be using Docker containers through Singularity.
  When calling ``singularity exec docker://<containername:version>`` as below the corresponding container will be downloaded from Dockerhub automatically if it is not yet present locally. This is very convenient, but might in some instances take a bit of time. 

  If you are doing this exercise as part of a course you might be provided with local copies of the images to save some time. 

  In some courses for example you'll find local ``*sif`` files in ``~/Share/Singularity_images/`` - **Please doublecheck with your instructor(s) if this is the case**.
  If it is the case you are encouraged to use the local files instead of the images from the cloud, so whenever there is a singularity call you can replace the cloud id with the path to the local ``*sif`` file. Filenames should correspond to the docker ids, like e.g. the following:

  .. code-block:: bash

     (user@host)-$ singularity exec docker://reslp/biopython_plus:1.77 \
                   <rest of the command>

  could be replaced with:
  
  .. code-block:: bash

     (user@host)-$ singularity exec ~/Share/Singularity_images/biopython_plus_1.77.sif \
                   <rest of the command>


  FYI, the following command would download the image and safe it to a local `*.sif` file.

     .. code-block:: bash
     
        (user@host)-$ singularity pull docker://reslp/biopython_plus:1.77
        (user@host)-$ ls -hrlt #see what happened


Now, assuming that we ran BUSCO across a number of genomes, we're going
to select us a bunch of BUSCO genes to be included in our phylogenomic
analyses. Let's get an overview.

We have a script to produce a matrix of presence/absence of BUSCO genes
across multiple species. Let's try it out. 


.. code:: bash

    (user@host)-$ singularity exec docker://reslp/biopython_plus:1.77 \
                  bin/extract_busco_table.py \
                  --hmm results/orthology/busco/busco_set/vertebrata_odb10/hmms \
                  --busco_results results/orthology/busco/busco_runs/ \
                  -o busco_table.tsv

The resulting file ``busco_table.tsv`` can be found in your current
directory.

We'd want for example to identify all genes that are present in at least
20 of our 25 taxa and concatenate the sequences from each species into a
single fasta file.

.. code:: bash

    (user@host)-$ mkdir -p by_gene/raw
    (user@host)-$ singularity exec docker://reslp/biopython_plus:1.77 \
                  bin/create_sequence_files.py \
                  --busco_table busco_table.tsv \
                  --busco_results results/orthology/busco/busco_runs \
                  --cutoff 0.5 \
                  --outdir by_gene/raw \
                  --minsp 20 \
                  --type aa \
                  --gene_statistics gene_stats.txt \
                  --genome_statistics genome_statistics.txt 

A bunch of files have been created in your current directory
(``gene_stats.txt``) and also in the directory ``by_gene/raw`` (per gene
``fasta`` files).

**4.) For each BUSCO group**

For each of the BUSCOs that passed we want to:

  - do multiple sequence alignment
  - filter the alignment, i.e. remove ambiguous/problematic positions
  - build a phylogenetic tree

Let's go over a possible solution step by step for gene:
``409625at7742``.

Perform multiple sequence alignment with
`clustalo <http://www.clustal.org/omega/>`__.

.. code:: bash

    #alignment with clustalo
    (user@host)-$ mkdir by_gene/aligned
    (user@host)-$ singularity exec docker://reslp/clustalo:1.2.4 \
                  clustalo \
                  -i by_gene/raw/409625at7742_all.fas \
                  -o by_gene/aligned/409625at7742.clustalo.fasta \
                  --threads=2

We can then look at the alignment result. There is a number of programs
available to do that, e.g. MEGA, Jalview, Aliview, or you can do it
online. A link to the upload client for the NCBI Multiple Sequence
Alignment Viewer is
`here <https://www.ncbi.nlm.nih.gov/projects/msaviewer/?appname=ncbi_msav&openuploaddialog>`__
(I suggest to open in new tab). Upload
(``by_gene/aligned/409625at7742.clustalo.fasta``), press 'Close' button,
and have a look.

What do you think? It's actually quite messy..

Let's move on to score and filter the alignment, using
`TrimAl <https://vicfero.github.io/trimal/>`__.

.. code:: bash

    #alignment trimming with trimal
    (user@host)-$ mkdir by_gene/trimmed
    (user@host)-$ singularity exec docker://reslp/trimal:1.4.1 \
                  trimal \
                  -in by_gene/aligned/409625at7742.clustalo.fasta \
                  -out by_gene/trimmed/409625at7742.clustalo.trimal.fasta \
                  -gappyout

Try open the upload
`dialog <https://www.ncbi.nlm.nih.gov/projects/msaviewer/?appname=ncbi_msav&openuploaddialog>`__
for the Alignment viewer in a new tab and upload the new file
(``by_gene/trimmed/409625at7742.clustalo.trimal.fasta``). What do you
think? The algorithm has removed quite a bit at the ends of the original
alignment, reducing it to only ~100, but these look mostly ok, at first
glance.

Now, let's infer a ML tree with `IQtree <http://www.iqtree.org/>`__.

.. code:: bash

    #ML inference with IQTree
    (user@host)-$ mkdir -p by_gene/phylogeny/409625at7742
    (user@host)-$ singularity exec docker://reslp/iqtree:2.0.7 \
                  iqtree \
                  -s by_gene/trimmed/409625at7742.clustalo.trimal.fasta \
                  --prefix by_gene/phylogeny/409625at7742/409625at7742 \
                  -m MFP --seqtype AA -T 2 -bb 1000

The best scoring Maximum Likelihood tree can be found in the file:
``by_gene/phylogeny/409625at7742/409625at7742.treefile``.

The tree is in the Newick tree format. There is a bunch of programs that
allow you to view and manipulate trees in this format. You can only do
it online, for example through
`iTOL <https://itol.embl.de/upload.cgi>`__, embl's online tree viewer.
There is others, e.g. `ETE3 <http://etetoolkit.org/treeview/>`__,
`icytree <https://icytree.org/>`__, or
`trex <http://www.trex.uqam.ca/index.php?action=newick&project=trex>`__.
You can try it out, but first let's have a quick look at the terminal.

.. code:: bash

    (user@host)-$ cat by_gene/phylogeny/409625at7742/409625at7742.treefile

**Well done!**

**5.) Run the process for multiple genes**

Now, let's say we want to go over these steps for multiple genes, say
these:

 - 359032at7742
 - 413149at7742
 - 409719at7742
 - 406935at7742

.. admonition:: Exercise

  For loop would do the job right? See the below code. Do you manage to
  add the tree inference step in, too? It's not in there yet.

  .. code:: bash

    (user@host)-$ for gene in $(echo "359032at7742 413149at7742 409719at7742 406935at7742")
    do
            echo -e "\n$(date)\t$gene"
            echo -e "$(date)\taligning"
            singularity exec docker://reslp/clustalo:1.2.4 clustalo -i by_gene/raw/${gene}_all.fas -o by_gene/aligned/${gene}.clustalo.fasta --threads=2
            echo -e "$(date)\ttrimming"
            singularity exec docker://reslp/trimal:1.4.1 trimal -in by_gene/aligned/${gene}.clustalo.fasta -out by_gene/trimmed/${gene}.clustalo.trimal.fasta -gappyout
            echo -e "$(date)\tDone"
    done

  Possible solutions using docker images or local ``*sif`` files (make sure to change the path to the ``*sif`` files) can be found `here <https://github.com/chrishah/phylogenomics_intro_vertebrata/blob/main/backup/bygene.sh>`_ and `here <https://github.com/chrishah/phylogenomics_intro_vertebrata/blob/main/backup/bygene_local.sh>`_, respectively. See scripts ``backup/bygene.sh`` and ``backup/bygene_local.sh`` in this repository.

  If you want to skip this step alltogehter you can fetch the files that would be produced by this step from the ``backup`` directory, like so:

  .. code:: bash

    (user@host)-$ rsync -avpuzP backup/by_gene .


Now, let's infer a ML tree using a supermatrix of all 5 genes that we
have processed so far.

.. code:: bash

    (user@host)-$ singularity exec docker://reslp/iqtree:2.0.7 \
                  iqtree \
                  -s by_gene/trimmed/ \
                  --prefix five_genes \
                  -m MFP --seqtype AA -T 2 -bb 1000 


This will run for about 10 Minutes. You can check out the result
``five_genes.treefile``, once it's done.
A backup ships with the repository in ``backup/five_genes.treefile``.

.. code:: bash

    (user@host)-$ cat five_genes.treefile


Now, we can also try to build a speciestree from the 5 individual gene trees using ASTRAL. 

First bring the individual gene trees together into one file. Let's call the file ``trees.txt``, then run ASTRAL:

.. code:: bash

  (user@host)-$ cat by_gene/phylogeny/*/*.treefile > trees.txt 
  (user@host)-$ singularity exec docker://reslp/astral:5.7.1 \
                java -jar /ASTRAL-5.7.1/Astral/astral.5.7.1.jar \
                -i trees.txt -o species_tree.astral.tre 


Have a look at the result.

.. code:: bash

  (user@host)-$ cat species_tree.astral.tre #or try backup/species_tree.astral.tre instead if you had trouble


Instead of looking at the plain text representation you can also explore the trees e.g. via `ITOL <https://itol.embl.de/upload.cgi>`_.

**Congratulations, you've just built your first phylogenomic tree(s)!!!**


**5.) Automate the workflow with Snakemake**

A very neat way of handling this kind of thing is
`Snakemake <https://snakemake.readthedocs.io/en/stable/>`__.

.. admonition:: Important Information

  Snakemake should be installed on your system. An easy way to get it set up is through ``conda``. If you haven't set it up yet, we provide some instructions `here <https://github.com/chrishah/phylogenomics_intro_vertebrata/tree/main/Snakemake_intro/README.md>`_.


The very minimum you'll need to create Snakemake workflow is a so called Snakefile. The repository ships with a file called ``Snakemake_intro/Snakefile_cloud``. This file contains the instructions for running a basic workflow with Snakemake. Let's have a look. Note that we have prepared also a file ``Snakemake_intro_Snakefile_local`` in case you've been instructed to use local ``*sif`` files.

.. code:: bash

    (user@host)-$ less Snakemake_intro/Snakefile_cloud #exit less with 'q'
    (user@host)-$ less Snakemake_intro/Snakefile_local #exit less with 'q'

In the Snakefile you'll see *rules* (that's what individual steps in the
analyses are called in the Snakemake world). Some of which should look
familiar, because we just ran them manually, and then from within a
simple bash script. Filenames etc. are replaced with variables but other
than that..

Assuming you've set up a ``conda`` environment called ``snakemake`` (either you just did or it's already set up for you), in order to run Snakemake you first need to enter this environment.

.. code:: bash

    (user@host)-$ conda activate snakemake
    (snakemake) (user@host)-$ snakemake -h

Now, let's try to do a Snakemake 'dry-run' (flag ``-n``), providing a specific target
file and see what happens. Remember that ``snakemake`` expects a file called ``Snakefile``
in the working directory per default, so you could copy the file ``Snakemake_intro/Snakefile_local`` or ``Snakemake_intro/Snakefile_cloud`` here, renamed ``Snakefile`` (this is what will be assumed) or find another way (``-s <path/to/Snakefile>``).

.. code:: bash

    (user@host)-$ snakemake -n -rp auto/trimmed/193525at7742.clustalo.trimal.fasta

Now, you could extend the analyses to further genes.

.. code:: bash

    (user@host)-$ snakemake -n -rp \
                  auto/trimmed/193525at7742.clustalo.trimal.fasta \
                  auto/trimmed/406935at7742.clustalo.trimal.fasta

Actually running would happen if you remove the ``-n`` flag. Note that I've added another flag (``--use-singularity``) which tells snakemake to use containers for certain rules if so indicated in the ``Snakefile``. 

.. code:: bash

    (user@host)-$ snakemake -rp --use-singularity --jobs 4 \
                  auto/trimmed/193525at7742.clustalo.trimal.fasta \
                  auto/trimmed/406935at7742.clustalo.trimal.fasta

**Well Done!**


.. admonition:: Challenge

   Add two rules to the ``Snakefile``:

   - ``rule gene_tree`` - infer a gene tree for each alignment
   - ``rule supermatrix`` - infer the final tree (target filename: ``super.treefile``) based the supermatrix created from the individual gene alignments

   Further, make sure your workflow includes the following genes:

   - 409625at7742
   - 409719at7742
   - 413149at7742
   - 42971at7742
   - 97645at7742

   A possible solution can be found `here <https://github.com/chrishah/phylogenomics_intro_vertebrata/blob/main/backup/Snakefile_with_ml>`_. It also ships with the repository ``backup/Snakefile_with_ml`` or ``backup/Snakefile_with_ml_local``.

   The snakemake call could look something like this (assuming you've first put a file called ``Snakefile`` in place):

   .. code:: bash

       (snakemake) (user@host)-$ snakemake -nrp --use-singularity --jobs 4 super.treefile

   Also check out snakemakes functionality to generate dags (directed acyclic graphs)
   notice that I am using a backup Snakefile ``backup/Snakefile_with_ml_from_dir``:

   .. code:: bash

      (snakemake) (user@host)-$ snakemake -n --dag \
                  -s backup/Snakefile_with_ml_from_dir | dot -Tpdf > dag.from.dir.pdf


**Well Done!!!**

All that you need now is to practice .. ;-)


**6.) Full automation**

We have developed a pipeline for automating the entire process of
phylogenomic analyses from BUSCO genes (for now). You can find it
`here <https://github.com/reslp/phylociraptor>`__.

The current repository is actually a snapshot of
`phylociraptor <https://github.com/reslp/phylociraptor>`__. In the base
directory of this repository you could resume an analysis as shown
below. If there is time we'll talk about the setup a little bit.

The main things you need are:

  - config file ``data/config.vertebrata_minimal.yaml``
  - sample file ``data/vertebrata_minimal.csv``

A few steps were already run for you - see the file
``data/preparation.md``, and you could resume and finish the analyses with the following
commands.

.. code:: bash

    #get table
    ./phylociraptor orthology -t serial=2 --config-file data/config.vertebrata_minimal.yaml

    #filter-orthology
    ./phylociraptor filter-orthology -t serial=2 --config-file data/config.vertebrata_minimal.yaml --verbose

    #align
    ./phylociraptor align -t serial=2 --config-file data/config.vertebrata_minimal.yaml --verbose

    #filter align
    ./phylociraptor filter-align -t serial=2 --config-file data/config.vertebrata_minimal.yaml --verbose

    #modeltest
    ./phylociraptor modeltest -t serial=2 --config-file data/config.vertebrata_minimal.yaml

    #ml tree
    ./phylociraptor mltree -t serial=2 --config-file data/config.vertebrata_minimal.yaml --verbose

    #speciestree
    ./phylociraptor speciestree -t serial=2 --config-file data/config.vertebrata_minimal.yaml --verbose

    #figure
    ./phylociraptor report --config-file data/config.vertebrata_minimal.yaml 
    ./phylociraptor report --figure --config-file data/config.vertebrata_minimal.yaml

