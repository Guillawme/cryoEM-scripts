#! /usr/bin/awk -f

# Count particles in each class from a class2D or class3D run_it***_data.star
# file from RELION.

# Usage:
# count_particles.awk run_it025_data.star

# Report which file is being analyzed.
$1 ~ /data_/ {
    print "Analyzing star file:", FILENAME;
}

# Go through the file line by line and count how many times each class appears
# (each line is a particle). Only analyze lines with more than 2 fields.
NF > 2 {
    # rlnClassNumber is the 3rd field in run_it***_data.star files from
    # RELION-3.0. Change this if your version of RELION orders columns of star
    # files differently.
    rlnClassNumber = $3;

    # Count particles in each class.
    particles[rlnClassNumber]++;

    # Count all particles.
    total++;
}

# Report results.
END {
    print "Total number of particles:", total;
    printf("%5s\t%9s\t%10s\n", "Class", "Particles", "% of total");
    for (i in particles) {
        printf("%5d\t%9d\t%10.2f\n", i, particles[i], 100*particles[i]/total) | "sort -k 2 -n -r";
    }
}

