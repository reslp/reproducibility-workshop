FROM continuumio/miniconda3:4.7.12

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update --allow-releaseinfo-change && apt install -y nano vim
WORKDIR /data

CMD ["/bin/bash"]
