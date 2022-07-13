#!/usr/bin/env bash

#conda activate serpentesmake
# function modified from https://stackoverflow.com/a/54920339
avg_time() {	
    #
    # usage: avg_time n command ...
    #
    n=$1; shift
    (($# > 0)) || return                   # bail if no command given
    for ((i = 0; i < n; i++)); do
        { time -p "$@" &>/dev/null; } 2>&1 # ignore the output of the command
                                           # but collect time's output in stdout
# the sed is used in case the decimal seperator is , instead of . due to locale
    done | tee | sed 's/,/\./' | awk '           
        /real/ { real = real + $2; }
        /user/ { user = user + $2; }
        /sys/  { sys  = sys  + $2; }
        END    {
                 printf("real %f sec\n", real);
                 printf("user %f sec\n", user);
                 printf("sys %f sec\n",  sys)
               }'
}

ntimes=10
echo "$ntimes GNU Make runs take:"
avg_time $ntimes make all -B
echo
echo "$ntimes Snakemake runs take:"
avg_time $ntimes snakemake --forceall all
echo
echo "$ntimes Nextflow runs take:"
avg_time $ntimes docker run --rm -it -v $(pwd):/data -w /data nextflow/nextflow:22.04.4 nextflow lower.nf
