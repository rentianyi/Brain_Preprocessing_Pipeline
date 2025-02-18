function normalize(task_id)
    task_id = str2double(task_id)
    % Make sure SPM12 is added to your MATLAB path before running.
    fprintf('Processing Task ID: %d\n', task_id);
    addpath('/gscratch/scrubbed/tr1/test/spm12') 
    spm('Defaults','fmri');
    spm_jobman('initcfg');

    % Define input directory containing NIfTI images
    templeteDir = '/gscratch/scrubbed/tr1/test/group-TRAIN_template.nii'
    inputDir = '/gscratch/scrubbed/tr1/compiled_data/validation/adni_normalized'; % Change this to your directory
    % inputDir = '/gscratch/scrubbed/tr1/test/samples'; % Change this to your directory
    outputDir = inputDir; % Change this to your output directory



    % Get list of .nii files in input directory
    niiFiles = dir(fullfile(inputDir, '**', '*.nii'));
    fprintf('Number of nii files: %d\n', length(niiFiles));
    % Divide niiFiles into 32 folds based on task_id
    numFolds = 32;
    foldSize = ceil(length(niiFiles) / numFolds);
    startIndex = (task_id - 1) * foldSize + 1;
    endIndex = min(task_id * foldSize, length(niiFiles));
    niiFiles = niiFiles(startIndex:endIndex);
    fprintf('Processing fold %d with files from index %d to %d\n', task_id, startIndex, endIndex);
    % Loop through each file and run normalization
    matlabbatch = {};
    for i = 1:length(niiFiles)
        fprintf('Processing file: %s\n', fullfile(niiFiles(i).folder, niiFiles(i).name));
        fprintf('Index: %d\n', i);
        niiPath = fullfile(niiFiles(i).folder, niiFiles(i).name);
        matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {niiPath};
        matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = {niiPath};
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {templeteDir};
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0 0.1 0.01 0.04];
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
        matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
        matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70; 78 76 85];
        matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [1 1 1];
        matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
        matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
        
        % Run SPM batch job
        spm_jobman('run', matlabbatch);
        fprintf('Normalized: %s\n', niiFiles(i).name);
    end

    fprintf('All files have been normalized.\n');
end