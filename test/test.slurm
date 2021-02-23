#!/bin/bash
#SBATCH --account=lcls
#SBATCH --job-name=test
#SBATCH --output=output-%j.txt --error=output-%j.txt
#SBATCH --nodes=1 --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --gpus=1
singularity run --nv -B /sdf,/gpfs,/scratch,/lscratch /scratch/fpoitevi/singularity_images/ana-py3_latest.sif python ~/ezpsana/test/test.py
