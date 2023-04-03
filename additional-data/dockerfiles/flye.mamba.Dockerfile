FROM reslp/mamba:0.15.3

RUN mamba install -y -c bioconda flye=2.9

CMD ["flye", "-h"]
