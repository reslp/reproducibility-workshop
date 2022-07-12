FROM reslp/mamba:0.15.3

RUN mamba install -y -c bioconda clustalo=1.2.4

WORKDIR /data

CMD ["clustalo", "-h"]
