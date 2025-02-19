# Brain_Preprocessing_Pipeline

$ tree .
.
├── Normalization_module
│   ├── group-TRAIN_template.nii
│   ├── normalize.m
│   └── main.sh
├── Skullstripping_module
│   ├── remove_nan.py
│   └── skullstripping.sh
└── README.md


group-TRAIN_template.nii: This is the template file for normalization
normalize.m: this is the matlab script for image normalization using SPM
main.sh: this is the slurm command for running the normalization 
remove_nan.py: This python function remove the nan in the output of the normalization 
skullstripping.sh: This is the slurm script for running the skull stripping using synthstrip via freesurfer
