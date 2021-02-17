FROM ubuntu:18.04
LABEL maintainer="Frederic Poitevin <frederic.poitevin@stanford.edu>"
# adapted from Johannes Blaschke <jpblaschke@lbl.gov>

#-------------------------------------------------------------------------------
# Base Ubuntu packages

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN \
    apt-get update          &&                                                 \
    apt-get --yes upgrade   &&                                                 \
    apt-get --yes install                                                      \
        bzip2                                                                  \
        curl                                                                   \
        git                                                                    \
        libffi-dev                                                             \
        lsb-release                                                            \
        tzdata                                                                 \
        vim                                                                    \
        wget                                                                   \
        bash                                                                   \
        autoconf                                                               \
        automake                                                               \
        gcc                                                                    \
        g++                                                                    \
        make                                                                   \
        gfortran                                                               \
        tar                                                                    \
        strace
    apt-get --yes clean

# Timezone to Stanford

ENV TZ=America/Los_Angeles
RUN \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  &&  \
    echo $TZ > /etc/timezone


# In case source is requires => switch `RUN` to execute bash (instead sh)
SHELL ["/bin/bash", "-c"]

#-------------------------------------------------------------------------------
# Install miniconda
#

RUN mkdir /img
COPY conda.local /img/conda.local
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
    mv Miniconda3-latest-Linux-x86_64.sh /img/conda.local/                      && \
    chmod +x /img/conda.local/Miniconda3-latest-Linux-x86_64.sh
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-ppc64le.sh && \
    mv Miniconda3-latest-Linux-ppc64le.sh /img/conda.local/                     && \
    chmod +x /img/conda.local/Miniconda3-latest-Linux-ppc64le.sh

RUN cd /img/conda.local                                                     && \
    . sites/default.sh                                                      && \
    export STATIC_DIR=../../static                                          && \
    ./install_conda.sh

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# Create PSANA Conda environment
#

ARG inputyaml

RUN mkdir -p /img/conda
COPY conda/build-envs.sh /img/conda
COPY conda/$inputyaml /img/conda

RUN cd /img/conda/                                                          && \
    chmod +x build-envs.sh                                                  && \
    ./build-envs.sh $inputyaml

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# LDCONFIG
#
# We recommend running an /sbin/ldconfig as part of the image build (e.g. in
# the Dockerfile) to update the cache after installing any new libraries in in
# the image build.
#

RUN /sbin/ldconfig

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# ENTRYPOINT
#

ADD docker/entrypoint.sh /img

# set workdir
WORKDIR /img

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/img/entrypoint.sh"]

#-------------------------------------------------------------------------------
