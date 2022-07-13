params.indir = "$baseDir/input1/"

process combine {
    input: path indir
    output: file "combined1.txt"
    shell:
        """
            for file in \$(ls $indir/*.txt); do
                cat \$file >> combined1.txt
            done
        """
}

process lower {
    input: file "combined1.txt"
    output: file "lower1.txt"
    shell:
       """
          cat combined1.txt | tr [:upper:] [:lower:] > lower1.txt
       """
}

workflow {
    combine(params.indir) | lower | view
}
