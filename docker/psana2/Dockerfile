FROM debian:buster

ARG inputyaml

WORKDIR /root

RUN apt-get -y update && \
    apt-get -y install git wget vim emacs tmux screen openssh-client && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x /root/Miniconda3-latest-Linux-x86_64.sh && \
    /root/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/anaconda && \
    rm /root/Miniconda3-latest-Linux-x86_64.sh

COPY $inputyaml /root/$inputyaml
RUN . /opt/anaconda/etc/profile.d/conda.sh && conda update -c conda-forge conda
RUN . /opt/anaconda/etc/profile.d/conda.sh && \
    conda env create -n ana -f ${inputyaml} && \
    conda clean -afy

WORKDIR /home/psana2-build

RUN git clone https://github.com/apeck12/lcls2.git
RUN cd lcls2 && \
    source /opt/anaconda/etc/profile.d/conda.sh && \
    conda activate ana && \
    export PATH=/home/psana2-build/lcls2/install/bin:$PATH && \
    export PYTHONPATH=$RELDIR/install/lib/python3.10/site-packages && \
    export TESTRELDIR=$RELDIR/install && \
    export MANPATH=$CONDA_PREFIX/share/man${MANPATH:+:${MANPATH}} && \
    ./build_all.sh

ADD docker/psana2/entrypoint.sh /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]