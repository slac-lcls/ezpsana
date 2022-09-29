FROM debian:buster

ARG inputyaml

WORKDIR /root

RUN apt-get -y update && \
    apt-get -y install git wget vim emacs tmux screen openssh-client && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

RUN export CC=cc && \
    export CXX=CC && \
    export MPI4PY_CC="\$(which cc)" && \
    export MPI4PY_MPICC="\$(which cc) --shared" && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x /root/Miniconda3-latest-Linux-x86_64.sh && \
    /root/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/anaconda && \
    rm /root/Miniconda3-latest-Linux-x86_64.sh

COPY $inputyaml /root/$inputyaml
RUN . /opt/anaconda/etc/profile.d/conda.sh && \
    conda update -c conda-forge conda
RUN . /opt/anaconda/etc/profile.d/conda.sh && \
    conda env create -n ana -f ${inputyaml} && \
    conda activate ana && \
    conda uninstall -y --force mpich && \
    conda clean -afy

WORKDIR /home/psana2-build

RUN git clone https://github.com/apeck12/lcls2.git
RUN cd lcls2 && \
    . /opt/anaconda/etc/profile.d/conda.sh && \
    conda activate ana && \
    export PATH=/home/psana2-build/lcls2/install/bin:$PATH && \
    export PYTHONPATH=/home/psana2-build/lcls2/install/lib/python3.10/site-packages && \
    export TESTRELDIR=/home/psana2-build/lcls2/install && \
    export MANPATH=$CONDA_PREFIX/share/man${MANPATH:+:${MANPATH}} && \
    ./build_all.sh \

RUN git clone https://github.com/lcls-users/btx.git
RUN cd btx && \
    git checkout psana2_demo \

RUN /sbin/ldconfig

ADD entrypoint.sh /opt/entrypoint.sh
WORKDIR /opt
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]