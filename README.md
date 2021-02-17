# Easy Photon System ANAlysis

How to:
- bring psana where you need it
- build a psana tailored to your needs

## conda environment

Follow the steps in `conda/README.md`

## docker image

### Build
```bash
./build_docker.sh conda/<YAML filename>
```

### Push
For example:
```bash
(base) [fpoitevi@PC98123 ezpsana]$ docker tag ana-py3:latest slaclcls/ana-py3:latest
(base) [fpoitevi@PC98123 ezpsana]$ docker push slaclcls/ana-py3:latest
```
