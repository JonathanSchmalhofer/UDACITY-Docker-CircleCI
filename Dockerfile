FROM ubuntu:xenial
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# install additional tools
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y libgtk2.0-dev
RUN apt-get install -y pkg-config

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

RUN echo $PATH

# Replace 'carnd-term1' with 'carnd-term1-cpu' ...
# ... and '0.12.1' with '1.8.0' ...
# ... and '1.2.1' with '2.1.6'
# ... and install OpenCV with GTK2 support in conda, see: https://stackoverflow.com/questions/40207011/opencv-not-working-properly-with-python-on-linux-with-anaconda-getting-error-th
RUN git clone https://github.com/udacity/CarND-Term1-Starter-Kit.git ~/udacity/CarND-Term1-Starter-Kit
RUN cd ~/udacity/CarND-Term1-Starter-Kit && \
    sed -i "s/carnd-term1/carnd-term1-cpu/g" ~/udacity/CarND-Term1-Starter-Kit/environment.yml && \
    sed -i "s/0.12.1/1.8.0/g" ~/udacity/CarND-Term1-Starter-Kit/environment.yml && \
    sed -i "s/1.2.1/2.1.6/g" ~/udacity/CarND-Term1-Starter-Kit/environment.yml && \
    source ~/udacity/miniconda/bin/activate && \
    conda env create -f ~/udacity/CarND-Term1-Starter-Kit/environment.yml && \
    conda info --envs && \
    conda activate carnd-term1-cpu && \
    conda remove opencv3 && \
    conda update conda && \
    conda install --channel loopbio --channel conda-forge --channel pkgw-forge gtk2 ffmpeg ffmpeg-feature gtk2-feature opencv3 && \
    conda clean -tp

RUN apt-get update
