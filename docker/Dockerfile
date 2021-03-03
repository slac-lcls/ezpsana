FROM docker.io/nvidia/cuda:10.1-devel-ubuntu18.04
ARG inputyaml
WORKDIR /root

# Install useful packages
RUN apt-get -y update && \
    apt-get -y install wget vim-full emacs tmux screen && \
    rm -rf /var/lib/apt/lists/* 

# Download miniconda installer, perform the installation and remove it
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod +x /root/Miniconda3-latest-Linux-x86_64.sh && \
    /root/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/anaconda && \
    rm /root/Miniconda3-latest-Linux-x86_64.sh

# Copy the environment file and generate the environemtn
COPY $inputyaml /root/$inputyaml
RUN . /opt/anaconda/etc/profile.d/conda.sh && \
    conda env create -n ana -f ${inputyaml} && \
    conda clean -afy

# Copy and add the entrypoint script
ADD entrypoint.sh /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]

# Set an environment variable that stores the version of the container
ENV PSANA_VERSION $inputyaml
