
#using the ubuntu docker base image, my personal favorite flavor of linux
FROM ubuntu:focal-20200925

#set up the files we need for the rest of the image build
COPY start.sh /inventory_bootstrap/start.sh
COPY requirements.txt /inventory_bootstrap/requirements.txt
WORKDIR /inventory_bootstrap


#get the package installer ready and just do everything we need
RUN apt-get clean \
    && apt-get -y update

RUN apt-get -y install -y nginx \
    && apt-get -y install -y python3 \
    && apt-get -y install -y python3-pip \
    && apt-get -y install -y build-essential \
    && apt-get -y install gnupg \
    && apt-get install -y wget \
    && apt-get -y install systemctl

RUN apt-get update && apt-get -y install -y zip gzip tar

#adapted from the mongodb ubuntu installation guidelines to work in our docker container

RUN apt-get update && wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -

RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list


RUN apt-get -y update && apt-get install -y mongodb-org

RUN systemctl enable --now mongod

#get everything set up to run an nginx/uwsgi server for out flask backend

RUN pip install -r requirements.txt --src /usr/local/src

COPY nginx.conf /etc/nginx


RUN chmod +x ./start.sh


#entrypoint so we know this script is ready
CMD ["./start.sh"]