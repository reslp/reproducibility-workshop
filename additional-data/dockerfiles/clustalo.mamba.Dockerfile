FROM reslp/mamba:2.0.5

RUN mamba install -y -c bioconda clustalo=1.2.4

WORKDIR /data

CMD ["clustalo", "-h"]
