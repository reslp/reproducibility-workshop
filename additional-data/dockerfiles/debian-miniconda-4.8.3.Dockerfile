FROM continuumio/miniconda3:4.8.3

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update --allow-releaseinfo-change && apt install -y nano vim
WORKDIR /data

CMD ["/bin/bash"]
