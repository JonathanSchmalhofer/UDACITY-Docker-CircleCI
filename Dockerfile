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
RUN apt-get install -y sed
RUN apt-get update

# Install Miniconda and CarND-Term1-Starter-Kit
# Instructions see: https://github.com/udacity/CarND-Term1-Starter-Kit/blob/master/doc/configure_via_anaconda.md
RUN mkdir -p ~/udacity && \
    cd ~/udacity
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/udacity/miniconda && \
    export PATH="$HOME/udacity/miniconda/bin:$PATH"

RUN echo "source $HOME/udacity/miniconda/bin/activate" >> ~/.bashrc
RUN source ~/.bashrc

RUN git clone https://github.com/udacity/CarND-Term1-Starter-Kit.git
RUN cd CarND-Term1-Starter-Kit

# Replace 'carnd-term1' with 'carnd-term1-cpu' ...
# ... and '0.12.1' with '1.8.0' ...
# ... and '1.2.1' with '2.1.6'
RUN sed -i 's/carnd-term1/carnd-term1-cpu/g' environment.yml
RUN sed -i 's/0.12.1/1.8.0/g' environment.yml
RUN sed -i 's/1.2.1/2.1.6/g' environment.yml

RUN conda env create -f environment.yml
RUN conda info --envs
RUN conda clean -tp
