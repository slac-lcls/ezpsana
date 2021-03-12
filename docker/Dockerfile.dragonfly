FROM slaclcls/ana:4.0.17

RUN apt-get update &&\
    apt-get --yes install git make && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"] 

RUN source /opt/anaconda/etc/profile.d/conda.sh && \
    conda activate ana && \
    mkdir -p /img && \
    cd /img && \
    git clone https://github.com/duaneloh/Dragonfly.git && \
    cd Dragonfly && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make install
