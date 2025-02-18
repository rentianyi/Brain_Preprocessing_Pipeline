import nibabel as nib
import numpy as np
def remove_nan(filename, save_name):
    """
    Remove NaN values from a NIfTI file and save the modified file.
    """
    # Load the NIfTI file
    nii = nib.load(filename)
    data = nii.get_fdata()

    # Replace NaNs with 0
    data[np.isnan(data)] = 0

    # Save the modified data back to a new NIfTI file
    new_nii = nib.Nifti1Image(data, nii.affine, nii.header)
    # save_name = filename.split('.nii')[0] + '_no_nan.nii'
    nib.save(new_nii, save_name)




def parse_args():
    import argparse

    parser = argparse.ArgumentParser(
        description="Run a specified function with optional arguments."
    )
    parser.add_argument("function_name", type=str, help="The function to run")
    parser.add_argument(
        "additional_args",
        nargs=argparse.REMAINDER,
        help="Additional arguments for the function, passed as strings to the function",
    )
    return parser.parse_args()


if __name__ == "__main__":
    """
    Example usage of a function in this script:
        python3 train.py train_seg_synth arg1 arg2
        python3 train.py eval arg1 arg2 arg3
        python3 train.py get_wandb_config
    NOTE: all args are passed as strings to the function called.
    """

    args = parse_args()

    # Validate function_name argument
    function_name = args.function_name

    if function_name in globals() and callable(globals()[function_name]):
        # Call the function by name, pass additional arguments as a list
        print(
            f"(@window_images.py) Running function: {function_name} with arguments: {args.additional_args}\n"
        )
        globals()[function_name](*args.additional_args)
    else:
        print(f"Function '{function_name}' not found.")
        print(
            f"Available functions: {[fn for fn in globals() if callable(globals()[fn])]}"
        )