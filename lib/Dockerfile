FROM ubuntu:trusty

# update
RUN apt-get update -y

# curl
RUN apt-get install -y curl

# python
RUN apt-get install -y python2.7

# pip
ADD get-pip.py .
RUN python2.7 get-pip.py

# requirements
ADD requirements.txt .
#RUN pip install -r requirements.txt

# node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
