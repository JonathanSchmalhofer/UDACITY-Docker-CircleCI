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

# Install Miniconda and CarND-Term1-Starter-Kit
# Instructions see: https://github.com/udacity/CarND-Term1-Starter-Kit/blob/master/doc/configure_via_anaconda.md
RUN mkdir -p ~/udacity && \
    cd ~/udacity
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/udacity/miniconda && \
    export PATH="$HOME/udacity/miniconda/bin:$PATH"

RUN apt-get update
