FROM ubuntu:22.04

RUN apt-get update && apt install -y wget && wget http://www.clustal.org/omega/clustalo-1.2.4-Ubuntu-x86_64 && mv clustalo-1.2.4-Ubuntu-x86_64 /bin/clustalo && chmod a+x /bin/clustalo && apt-get clean && apt-get autoremove

WORKDIR /data

CMD ["clustalo", "-h"]


 
