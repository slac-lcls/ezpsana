FROM fpoitevi/nersc:latest

#ARG inputyaml
ARG inputtxt

WORKDIR /opt

RUN apt-get -y update && \
    apt-get -y install git wget vim emacs tmux screen openssh-client && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

#COPY $inputyaml /opt/$inputyaml
COPY $inputtxt /opt/$inputtxt
#RUN . /opt/anaconda3/etc/profile.d/conda.sh && \
#    conda env create -n ana -f ${inputyaml} && \
#    conda clean -afy
RUN conda install -c lcls-ii -c conda-forge -c defaults -c tidair-packages -c cogsci --file $inputtxt


#WORKDIR /home/psana2-build
#
#RUN git clone https://github.com/apeck12/lcls2.git
#RUN cd lcls2 && \
#    unset LD_LIBRARY_PATH && \
#    unset PYTHONPATH && \
#    . /opt/anaconda3/etc/profile.d/conda.sh && \
#    conda activate ana && \
#    export PATH=/home/psana2-build/lcls2/install/bin:$PATH && \
#    export PYTHONPATH=/home/psana2-build/lcls2/install/lib/python3.9/site-packages && \
#    export TESTRELDIR=/home/psana2-build/lcls2/install && \
#    export MANPATH=$CONDA_PREFIX/share/man${MANPATH:+:${MANPATH}} && \
#    ./build_all.sh -d
#
#RUN unset LD_LIBRARY_PATH && \
#    unset PYTHONPATH && \
#    . /opt/anaconda3/etc/profile.d/conda.sh && \
#    conda activate ana && \
#    conda uninstall --force mpich mpi

#RUN git clone https://github.com/lcls-users/btx.git
#RUN cd btx && \
#    git checkout psana2_demo

RUN /sbin/ldconfig

ADD entrypoint.sh /opt/entrypoint.sh
WORKDIR /opt
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]