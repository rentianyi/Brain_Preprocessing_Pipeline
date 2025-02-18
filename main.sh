#!/bin/bash

#SBATCH --job-name=norm
#SBATCH --mail-user=tr1@uw.edu
#SBATCH --mail-type=ALL

#SBATCH --account=kurtlab
#SBATCH --partition=cpu-g2 
#SBATCH --nodes=1
#SBATCH --mem=15G
#SBATCH --cpus-per-task=2
#SBATCH --time=12:00:00
#SBATCH --output=/gscratch/scrubbed/tr1/test/outputtxt/output_train_%A_%a.txt
#SBATCH --error=/gscratch/scrubbed/tr1/test/outputtxt/error_train_%A_%a.txt
#SBATCH --chdir=/gscratch/scrubbed/tr1/test/
#SBATCH --array=1-32

source ~/.bashrc
source activate undergraddl
module load matlab/r2023b

# Run the script.
matlab -nodisplay -nodesktop -nosplash -r "normalize $SLURM_ARRAY_TASK_ID; exit;"