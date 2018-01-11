#! /usr/bin/awk -f

# Count particles in each class from a class2D or class3D run_it***_data.star
# file from RELION. In class2D jobs, each particle can contribute to several
# classes (with different weights adding up to 1), therefore the sum of reported
# particles per class will exceed the total number of particles.

# Report which file is being analyzed.
$1 ~ /data_/ {
    print "Analyzing star file:", FILENAME;
}

# Go through the file line by line and count how many times each class appears
# (each line is a particle). Only analyze lines with more than 2 fields.
NF > 2 {
    # rlnClassNumber is the 3rd field in run_it***_data.star files from RELION.
    rlnClassNumber = $3;

    # Count particles in each class.
    classes[rlnClassNumber]++;

    # Count all particles.
    total++;
}

# Report results.
END {
    print "Total number of particles:", total;
    printf("%5s\t%9s\t%10s\n", "Class", "Particles", "% of total");
    for (i in classes) {
        printf("%5d\t%9d\t%10.2f\n", i, classes[i], 100*classes[i]/total) | "sort -k 1 -n";
    }
}

