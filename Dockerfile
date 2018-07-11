FROM ubuntu:xenial
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#############################################################
# Preparation
#############################################################
ARG proxy_name

ENV http_proxy $proxy_name
ENV https_proxy $proxy_name
ENV all_proxy $proxy_name
ENV HTTP_PROXY $proxy_name
ENV HTTPS_PROXY $proxy_name
ENV ALL_PROXY $proxy_name

#############################################################
# install additional tools
#############################################################
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y libgtk2.0-dev
RUN apt-get install -y pkg-config
RUN apt-get install -y libopenblas-dev

# install dependencies for building packages
RUN apt-get install -y python-wstool build-essential

# install additional dependencies - see https://www.binarytides.com/install-wxwidgets-ubuntu/
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y tar
RUN apt-get install -y sed
RUN apt-get update

#############################################################
# Install Miniconda and CarND-Term1-Starter-Kit
#############################################################
# Instructions see: https://github.com/udacity/CarND-Term1-Starter-Kit/blob/master/doc/configure_via_anaconda.md
RUN mkdir -p ~/udacity && \
    cd ~/udacity
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/udacity/miniconda && \
    export PATH="$HOME/udacity/miniconda/bin:$PATH"
RUN echo "source $HOME/udacity/miniconda/bin/activate" >> ~/.bashrc
RUN source ~/.bashrc
RUN echo $PATH

#############################################################
# Install Bazel for Building Tensorflow
#############################################################
# See: https://docs.bazel.build/versions/master/install-ubuntu.html
RUN apt-get install -y pkg-config zip g++ zlib1g-dev unzip python
RUN apt-get install -y openjdk-8-jdk
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
RUN apt-get update
RUN apt-get install -y bazel
RUN apt-get upgrade -y bazel

#############################################################
# Get Tensorflow 1.8 Sources
#############################################################
# See: https://www.tensorflow.org/install/install_sources
RUN git clone -b r1.8 --single-branch https://github.com/tensorflow/tensorflow.git ~/udacity/tensorflow

#############################################################
# Get prebuilt Tensorflow Wheel (OLD:Build Tensorflow)
#############################################################
RUN apt-get install -y python3-numpy python3-dev python3-pip python3-wheel python-numpy python-dev python-pip python-wheel

# See: https://github.com/tensorflow/tensorflow/issues/7843
#RUN cd ~/udacity/tensorflow && bazel clean
#RUN cd ~/udacity/tensorflow && echo "\n\n\n\n\n\n\n\n\n" | ./configure
#RUN cd ~/udacity/tensorflow && bazel build --config=mkl --config=opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-mfpmath=both --copt=-msse4.2 //tensorflow/tools/pip_package:build_pip_package
#RUN cd ~/udacity/tensorflow && bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg


# Copy locla file into docker
#COPY tensorflow-1.8.0-cp35-cp35m-linux_x86_64.whl /tmp/tensorflow_pkg/tensorflow-1.8.0-cp35-cp35m-linux_x86_64.whl
RUN wget -P /tmp/tensorflow_pkg/ https://github.com/JonathanSchmalhofer/UDACITY-Docker-CircleCI/releases/download/0.1.0-alpha/tensorflow-1.8.0-cp35-cp35m-linux_x86_64.whl

#############################################################
# Setup Conda Environment
#############################################################
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
    conda list && \
    conda remove opencv3 && \
    conda list && \
    conda install --channel loopbio --channel conda-forge --channel menpo --channel pkgw-forge gtk2 ffmpeg gtk2-feature opencv3 && \
    conda list
RUN cd ~/udacity/CarND-Term1-Starter-Kit && \
    source ~/udacity/miniconda/bin/activate && \
    conda info --envs && \
    conda activate carnd-term1-cpu && \
    conda list && \
    python -V && \
    python -m pip install --upgrade /tmp/tensorflow_pkg/tensorflow-*.whl && \
    conda clean -tp

RUN apt-get update
