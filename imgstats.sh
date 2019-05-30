#! /usr/bin/env bash

# Run this script in a directory containing MRC files (e.g. a MotionCorr job
# directory in a RELION project) to get a table of minimum, maximum and mean
# pixel values for each micrograph.
# This depends on IMOD.

# Adapt this line to your environment
module load imod/4.9.10

DATASET=$1
MICS=$2

for micrograph in $MICS; do
    header -minimum $micrograph
done > minimum.txt

for micrograph in $MICS; do
    header -maximum $micrograph
done > maximum.txt

for micrograph in $MICS; do
    header -mean $micrograph
done > mean.txt

nl -v 0 minimum.txt > minimum_num.txt

echo -e "micrograph\tminimum\tmaximum\tmean" > header.txt

paste minimum_num.txt maximum.txt mean.txt > data.txt

cat header.txt data.txt > "$DATASET"_imgstats.txt

rm minimum.txt minimum_num.txt maximum.txt mean.txt header.txt data.txt

