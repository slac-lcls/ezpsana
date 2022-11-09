FROM fpoitevi/nersc:latest

ARG inputtxt

WORKDIR /opt

RUN apt-get -y update && \
    apt-get -y install git wget unzip vim emacs tmux screen openssh-client \
        libgsl-dev libgtk-3-dev libcairo2-dev libpango1.0-dev \
        libgdk-pixbuf2.0-dev libfftw3-dev flex bison libzmq3-dev \
        libmsgpack-dev libeigen3-dev libccp4-dev ninja-build && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install meson

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

ENV PATH=/home/psana2-build/XDS-INTEL64_Linux_x86_64:$PATH
ENV KMP_STACKSIZE=8m
RUN wget -nv https://xds.mr.mpg.de/XDS-INTEL64_Linux_x86_64.tar.gz
RUN tar -xzf XDS-INTEL64_Linux_x86_64.tar.gz && \
    rm -f XDS-INTEL64_Linux_x86_64.tar.gz

# see https://stash.desy.de/projects/CRYS/repos/crystfel/browse/INSTALL.md
ENV SYMINFO=/usr/share/ccp4/syminfo.lib
RUN git clone https://stash.desy.de/scm/crys/crystfel.git
RUN cd crystfel && meson build -Dprefix=/usr/local
RUN cd crystfel && ninja -C build
RUN cd crystfel && ninja -C build test
RUN cd crystfel && ninja -C build install

RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1XvZ1FJFFaunq151e4WrjFkpc-My3m8XQ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1XvZ1FJFFaunq151e4WrjFkpc-My3m8XQ" -O ccp4-7.1.002-shelx-linux64.tar.gz &&                         \
    rm -rf /tmp/cookies.txt
RUN tar -xzvf ccp4-7.1.002-shelx-linux64.tar.gz &&\
    cd ccp4-7.1 &&\
    ./BINARY.setup --run-from-script &&\
    sed -i 's|export CCP4_SCR|#export CCP4_SCR=|g' /home/psana2-build/ccp4-7.1/bin/ccp4.setup-sh &&\
    cd /home/psana2-build &&\
    rm -f ccp4-7.1.002-shelx-linux64.tar.gz
ENV CCP4_SCR=/tmp/ccp4scr

ENV PATH=/home/psana2-build/btx/scripts:$PATH
ENV PYTHONPATH=/home/psana2-build/btx:$PYTHONPATH
RUN git clone https://github.com/lcls-users/btx.git
RUN cd btx && git checkout psana2_demo

ENV PS_SMD_CHUNKSIZE=64000000
ENV HDF5_USE_FILE_LOCKING=FALSE

RUN /sbin/ldconfig

ADD entrypoint.sh /opt/entrypoint.sh
WORKDIR /opt
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]