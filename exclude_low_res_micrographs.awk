#! /usr/bin/awk -f

# Takes a micrographs_ctf.star file from RELION and excludes all rows that have
# a rlnCtfMaxResolution worse than the value of the resolution= parameter
# provided on the command line.

# Usage:
# exclude_low_res_micrographs.awk resolution=<n> micrographs_ctf.star > new_file.star
# in which <n> is the resolution cut-off (only micrographs with better or equal
# resolution will be kept).

# Keep all metadata lines.
NF <= 4 {
    print;
}

# Keep rows for which rlnCtfMaxResolution is better than or equal to the
# resolution= parameter passed on the command line.
NF > 4 {
    # rlnCtfMaxResolution is the 13th field in micrographs_ctf.star files from
    # RELION-3.0. Change this if your version of RELION orders columns of star
    # files differently.
    rlnCtfMaxResolution = $13;

    if (rlnCtfMaxResolution <= resolution) {
        print;
    }
}
