#!/bin/bash
#SBATCH --account=lcls
#SBATCH --job-name=test
#SBATCH --output=output-%j.txt --error=output-%j.txt
#SBATCH --nodes=1 
#SBATCH --tasks-per-node=1
#SBATCH --constraint=haswell
#SBATCH --time=01:00:00
#SBATCH --time-min=00:10:00
#SBATCH --image=docker:slaclcls/ana-py3:latest
#SBATCH --qos=realtime
t_start=`date +%s`
export PMI_MMAP_SYNC_WAIT_TIME=600
srun shifter /img/entrypoint.sh python test.py
RC=$?
t_end=`date +%s`
echo PSJobCompleted TotalElapsed $((t_end-t_start)) $t_start $t_end
# tidy up and remove scripts?
exit $RC
