FROM ubuntu:xenial
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# install additional tools
RUN apt-get update
RUN apt-get install -y git

# install dependencies for building packages
RUN apt-get install -y python-wstool build-essential

# install additional dependencies - see https://www.binarytides.com/install-wxwidgets-ubuntu/
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y tar

RUN apt-get update
