FROM continuumio/miniconda:4.7.10

ENV PATH /opt/conda/bin:$PATH

RUN conda config --append channels bioconda
RUN conda config --append channels conda-forge
RUN conda config --append channels anaconda
RUN conda install -c bioconda clustalo=1.2.4
RUN conda clean -a -y

WORKDIR /data

CMD ["clustalo", "-h"]
