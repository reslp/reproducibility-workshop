FROM reslp/mamba:2.0.5

RUN mamba install -y -c bioconda flye=2.9

CMD ["flye", "-h"]
