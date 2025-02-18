#!/bin/bash
#SBATCH --job-name=norm
#SBATCH --mail-user=tr1@uw.edu
#SBATCH --mail-type=ALL
#SBATCH --account=kurtlab
#SBATCH --partition=gpu-a40 
#SBATCH --nodes=1
#SBATCH --mem=128G
#SBATCH --cpus-per-task=13
#SBATCH --gres=gpu:1
#SBATCH --time=12:00:00
#SBATCH --output=/gscratch/scrubbed/tr1/test/outputtxt/output_skull.txt
#SBATCH --error=/gscratch/scrubbed/tr1/test/outputtxt/error_skull.txt
#SBATCH --chdir=/gscratch/scrubbed/tr1/test/

source ~/.bashrc
source activate undergraddl
module load escience/freesurfer/7.3.2

# Run the script.
echo "Running skull stripping"


# mri_synthstrip -i samples/I48589/wI48589_no_nan.nii -o samples/I48589/stripped.nii
# Find all NIfTI files in the specified directory or subdirectories that start with 'w' and end with '.nii'
shopt -s globstar nullglob

nii_files=(/gscratch/scrubbed/tr1/compiled_data/validation/adni_normalized/**/**/w*.nii)
echo "Found ${#nii_files[@]} NIfTI files."

shopt -u globstar nullglob

if [ ${#nii_files[@]} -eq 0 ]; then
    echo "No NIfTI files found in the specified directory or subdirectories."
    exit 1
fi

for nii_file in "${nii_files[@]}"; do
    
    # nii_file="${nii_files[0]}"
    no_nan_file="${nii_file%.nii}_normalized.nii"
    output_file="${no_nan_file%.nii}_stripped.nii"
    echo "Processing $nii_file"
    echo "no_nan_file: $no_nan_file"
    echo "output_file: $output_file"

    # Run mri_synthstrip for each file
    python3 remove_nan.py remove_nan $nii_file $no_nan_file
    mri_synthstrip -i $no_nan_file -o $output_file
done

