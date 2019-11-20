#!/usr/bin/env python

# Initially written by Dr. Sam Bowerman

import glob, os, argparse, shutil
import numpy as np

parser = argparse.ArgumentParser()

parser.add_argument("-bf",
                    dest = 'base_folder',
                    help = "Absolute path to base folder containing full collection of micrographs",
                    type = str,
                    required = True)

parser.add_argument("-ext",
                    dest = 'file_ext',
                    help = 'Extension for micrograph files (i.e., "*.mrc" or "*.tif"). Default = "*.mrc"',
                    type = str,
                    default = "*.mrc")

parser.add_argument("-of",
                    dest = 'out_folder',
                    help = "Output folder where subset should be stored",
                    type = str,
                    required = True)

parser.add_argument("-n",
                    dest = 'num',
                    help = 'Number of micrographs to include in the trial set. Over-rides the "-frac" option.',
                    type = int,
                    default = 0)

parser.add_argument("-frac",
                    dest = 'frac',
                    help = 'Fraction of micrographs (0.0 - 1.0) to use in trial set. Over-ridden by the "-n" flag.',
                    type = float,
                    default = 0.0)

parser.add_argument("--copy",
                    dest = 'copy',
                    action = 'store_true',
                    help = 'Copy files instead of creating symlinks')

args = parser.parse_args()

# Gather up a list of all the possible micrographs
search_pattern = os.path.join(args.base_folder, args.file_ext)
FILELIST = glob.glob(search_pattern)

# Check to see if output directory exists
if os.path.isdir(args.out_folder):
    # Warn user that old training images will be deleted
    print("WARNING: output directory already exists!")
    print("         Continuing will remove old files and create new ones!")
    overwrite = ""
    # Continue asking the user until they say "Y" or "N"
    while not (overwrite.lower() in ['y', 'n']):
        overwrite = input("         Would you like to continue (Y/N)?  > ")
    if overwrite.lower() == 'y':
        # If authorized, remove old symlinks
        print("\nRemoving old symlinks.")
        old_link_path = os.path.join(args.out_folder, args.file_ext)
        old_links = glob.glob(old_link_path)
        for symlink in old_links:
            os.unlink(symlink)
            os.remove(symlink)
    else:
        # Otherwise, quit
        print("\nDirectory over-write aborted. No new symlinks created.")
        quit()
# If path doesn't exist, create the directory
else:
    print("Creating output folder \"" + args.out_folder)
    os.mkdir(args.out_folder)

if (args.num == 0) and (args.frac == 0.0):
    print("\n\n\tERROR: You must provide either the total number of trial images (-n) or the fraction of micrographs to include in the trial (-frac)!!!!")
    print("\n\n")
    quit()
elif (args.num == 0) and (args.frac != 0.0):
    num_frames = int(args.frac * len(FILELIST))
else:
    num_frames = args.num

# Randomly select the subset of micrographs
image_subset = np.random.choice(FILELIST, size=num_frames, replace=False)

# Create symbolic links each of the subset micrographs
for MICROGRAPH in image_subset:
    micrograph_basename = os.path.basename(MICROGRAPH)
    symlink_name = os.path.join(args.out_folder, micrograph_basename)
    if not args.copy:
        os.symlink(MICROGRAPH, symlink_name)

        # Inform user that symlink is complete
        print("Symbolic link created for " + MICROGRAPH + " at location " + symlink_name)
    else:
        shutil.copy2(MICROGRAPH, symlink_name)
        print("File copied from " + MICROGRAPH + " to " + symlink_name)

# Inform user that program is complete
print("All symbolic links complete. " + str(num_frames) + " links created.")
