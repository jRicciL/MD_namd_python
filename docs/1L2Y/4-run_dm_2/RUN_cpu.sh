#!/bin/bash
#BSUB -P project
#BSUB -J nd_curso
#BSUB -a openmpi
#BSUB -n 256
#BSUB -q q_hpc
#BSUB -eo err.err
#BSUB -oo out.out

module purge
module load namd/2.10

CORES=256

# Minimizacion
cd 1_min
mpirun -np $CORES namd2 ./1_min.conf.tcl > 1_min.log
wait

cd ../2_sa
mpirun -np $CORES namd2 ./2_sa.conf.tcl > 2_sa.log
wait

cd ../3_eq
mpirun -np $CORES namd2 ./3_eq.conf.tcl > 3_eq.log
wait

cd ../4_prod
mpirun -np $CORES namd2 ./4_prod.conf.tcl > 4_prod.log
#wait

#cd ./5_prod_100_ns
#mpirun -np $CORES namd2 ./5_prod.conf.tcl > 5_prod.log
#wait

