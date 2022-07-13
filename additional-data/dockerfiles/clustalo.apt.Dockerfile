FROM ubuntu:20.04

RUN apt update && apt install -y clustalo=1.2.4-4build1 && apt-get clean && apt-get autoremove

WORKDIR /data

CMD ["clustalo", "-h"] 
