FROM fpoitevi/nersc:latest

ARG inputtxt

WORKDIR /opt

RUN apt-get -y update && \
    apt-get -y install git wget vim emacs tmux screen openssh-client \
        libgsl-dev libgtk-3-dev libcairo2-dev libpango1.0-dev \
        libgdk-pixbuf2.0-dev libfftw3-dev flex bison libzmq3-dev \
        libmsgpack-dev libeigen3-dev libccp4-dev ninja-build && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

COPY $inputtxt /opt/$inputtxt
RUN conda install -c lcls-ii -c conda-forge -c defaults -c tidair-packages -c cogsci --file $inputtxt

WORKDIR /home/psana2-build

ENV PATH=/home/psana2-build/lcls2/install/bin:$PATH
ENV PYTHONPATH=/home/psana2-build/lcls2/install/lib/python3.9/site-packages
RUN git clone https://github.com/apeck12/lcls2.git
RUN cd lcls2 && ./build_all.sh -d


RUN wget -nv https://www.mrc-lmb.cam.ac.uk/mosflm/mosflm/ver740/pre-built/mosflm-linux-64-noX11.zip
RUN unzip mosflm-linux-64-noX11.zip
RUN mv mosflm-linux-64-noX11 /usr/local/bin/mosflm

# see https://stash.desy.de/projects/CRYS/repos/crystfel/browse/INSTALL.md
RUN git clone https://stash.desy.de/scm/crys/crystfel.git
RUN cd crystfel && meson build -Dprefix=/usr/local
RUN cd crystfel && ninja -C build
RUN cd crystfel && ninja -C build test
RUN cd crystfel && ninja -C build install

ENV PATH=/home/psana2-build/btx/scripts:$PATH
ENV PYTHONPATH=/home/psana2-build/btx:$PYTHONPATH
RUN git clone https://github.com/lcls-users/btx.git
RUN cd btx && git checkout psana2_demo

ENV PS_SMD_CHUNKSIZE=64000000
ENV HDF5_USE_FILE_LOCKING=FALSE

RUN /sbin/ldconfig

#ADD entrypoint.sh /opt/entrypoint.sh
#WORKDIR /opt
#RUN chmod +x entrypoint.sh
#ENTRYPOINT ["/opt/entrypoint.sh"]