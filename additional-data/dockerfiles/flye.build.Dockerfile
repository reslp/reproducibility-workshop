FROM ubuntu:20.04

MAINTAINER <christoph.hahn@uni-graz.at>

WORKDIR /usr/src

RUN apt update && apt install -y build-essential python3 git zlib1g zlib1g-dev libz-dev

RUN git clone https://github.com/fenderglass/Flye && \
	cd Flye && \
	git reset --hard f6ec19e41632f36bb441a2ce6a574632a94694ed && \
	make

ENV PATH="${PATH}:/usr/src/Flye/bin"

CMD ["flye", "-h"]
