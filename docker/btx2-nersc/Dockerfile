FROM fpoitevi/psana2nersc:latest

WORKDIR /home/psana2-build

RUN cd btx && git pull origin psana2_demo

ENTRYPOINT ["/opt/entrypoint.sh"]