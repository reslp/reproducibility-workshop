FROM reslp/mamba:2.0.5

RUN mamba install -y -c conda-forge pigz zsh boost openmpi compilers 
RUN mamba install -y -c bioconda arcs tigmint samtools google-sparsehash abyss
RUN mamba install -y -c bioconda -c conda-forge links ntlink longstitch


ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN apt-get update --allow-releaseinfo-change && \
	apt-get install -y \
		build-essential \ 
		git \
		make \
		gcc

CMD ["longstitch", "help"]
