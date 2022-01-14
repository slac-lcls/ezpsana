# Easy Photon System ANAlysis

How to:
- bring psana where you need it
- build a psana tailored to your needs

## Usage

There are 3 main ways to work with psana: through a JupyterHub, or using a scheduler (LSF or SLURM) in either batch or interactive mode. We describe below how to go about each of those modalities at various facilities: TBD.

### Find or build your container
While most of the approach we follow is based on building conda environment, we ultimately build and run containers. Here is how to find or build your own psana-based container!

#### Check if your container already exists!

All psana-based containers that we build are stored at the following [URL](https://hub.docker.com/repository/docker/slaclcls)
Have a look there! If you don't find what you are looking for, proceed to the next step...

#### Create your container
In order to run the following script, make sure your `python` has the `docker` module. If not, `pip install docker`. If you want, you can also run it in the `ezpsana` environment that you could create with `conda env create -f ezpsana.yml`.

```bash
(env)[terminal]$ python create-container.py -h
usage: create-container.py [-h] -b BASE_ENV_FILENAME
                           [-a ADDITIONAL_DEPS_FILENAME] -o OUTPUT_FILENAME
                           [-d] [-c] -r REPOSITORY -t TAG -v VERSION

optional arguments:
  -h, --help            show this help message and exit
  -b BASE_ENV_FILENAME, --base-env-yaml-file BASE_ENV_FILENAME
                        YAML file for base environment
  -a ADDITIONAL_DEPS_FILENAME, --additional-deps-yaml-file ADDITIONAL_DEPS_FILENAME
                        YAML file for additional dependencies
  -o OUTPUT_FILENAME, --output-yaml-file OUTPUT_FILENAME
                        output YAML file name (will be written in the 'docker'
                        directory)
  -d, --build-docker-container
                        Build docker container
  -c, --no-cache        Do not use cache when building the docker container
  -r REPOSITORY, --repository REPOSITORY
                        Repository for the docker image
  -t TAG, --tag TAG     Tag for the docker image
  -v VERSION, --version VERSION
                        Version for the docker image
```

Below is an example where the container is built with GitHub Actions:
```bash
python create-container.py -b yaml/ana-4.0.35.yml -o ana-4.0.35.yml -e -c -r fpoitevi -t ana -v 4.0.35
git add .github/workflows/main.yml
git tag -a build-ana-4.0.35 -m "attempt at building psana and pushing it to fpoitevi's DockerHub"
git push origin build-ana-4.0.35
```

### Run your container

#### on SDF
If the Singularity image you need is not already on SDF, you can pull it from DockerHub like so:
```bash
singularity pull docker://slaclcls/ana-py3:latest
```
Then, request the resources that you need and run the container once the resources have been allocated:
```bash
srun -A LCLS -n 1 --gpus 1 --pty /bin/bash
```
```bash
singularity exec --nv -B /sdf,/gpfs,/scratch,/lscratch /scratch/fpoitevi/singularity_images/ana-py3_latest.sif /bin/bash
```
