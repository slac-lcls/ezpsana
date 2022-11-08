# https://gitlab.com/NERSC/nersc-official-images/-/blob/main/nersc/python/3.9-anaconda-2021.11/Dockerfile
# https://docs.nersc.gov/development/shifter/how-to-use/#using-mpi-in-shifter
FROM docker.io/library/ubuntu:latest
WORKDIR /opt

RUN \
    apt-get update        && \
    apt-get install --yes    \
        build-essential      \
        gfortran             \
        wget              && \
    apt-get clean all

#anaconda
ARG installer=Anaconda3-2021.11-Linux-x86_64.sh
RUN wget https://repo.anaconda.com/archive/$installer && \
    bash ./$installer -b -p /opt/anaconda3 && \
    rm -rf $installer
ENV PATH=/opt/anaconda3/bin:$PATH

#mpich from source. python installation needs to come first.
ARG mpich=4.0
ARG mpich_prefix=mpich-$mpich
RUN \
    wget https://www.mpich.org/static/downloads/$mpich/$mpich_prefix.tar.gz && \
    tar xvzf $mpich_prefix.tar.gz                                           && \
    cd $mpich_prefix                                                        && \
    export FCFLAGS=-fallow-argument-mismatch && \
    export FFLAGS=-fallow-argument-mismatch && \
    ./configure  && \
    make -j 16                                                              && \
    make install                                                            && \
    make clean                                                              && \
    cd ..                                                                   && \
    rm -rf $mpich_prefix
RUN /sbin/ldconfig

#update conda tool
#remove mpich/mpi that now come with anaconda
RUN conda update --yes conda && \
    conda uninstall mpich mpi --yes && \
    conda install --yes -c conda-forge mamba

#uninstalling mpi removes essential packages, so re-add
#RUN mamba install --yes astropy cartopy cython cfitsio dask scipy scikit-learn scikit-image numba h5py matplotlib joblib pandas seaborn statsmodels

#build mpi4py on top of our mpich
RUN python -m pip install mpi4py
