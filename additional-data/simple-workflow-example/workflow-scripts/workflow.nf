params.indir = "$baseDir/input/"

process combine {
    input: path indir
    output: file "combined.txt"
    shell:
        """
            for file in \$(ls $indir/*.txt); do
                cat \$file >> combined.txt
            done
        """
}

process lower {
    input: file "combined.txt"
    output: file "lower.txt"
    shell:
       """
          cat combined.txt | tr [:upper:] [:lower:] > lower.txt
       """
}

workflow {
    combine(params.indir) | lower | view
}
