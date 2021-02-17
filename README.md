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

### Pull
For example, using Singularity on SDF:
```bash
singularity pull docker://slaclcls/ana-py3:latest
```

### Run
For example, requesting a compute node with GPU on SDF:
```bash
srun -A LCLS -p LCLS -n 1 --gpus 1 --pty /bin/bash
```
then
```bash
singularity exec --nv -B /sdf,/gpfs,/scratch,/lscratch /scratch/fpoitevi/singularity_images/ana-py3_latest.sif /bin/bash
```
