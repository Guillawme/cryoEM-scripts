#! /usr/bin/env bash

# Use relion_printtable to count particles in each class from a class2D or
# class3D run_it***_data.star file

STAR_FILE=$1
CLASSES=$2

# If a wrong number of command-line arguments is provided, display a short
# usage guide.
if [ $# != 2 ]; then
    echo "Usage: count_particles.sh STAR_FILE NUMBER_OF_CLASSES"
    echo "STAR_FILE must be run_it***_data.star from a Class2D or Class3D job"
    echo "NUMBER_OF_CLASSES can be less than the actual number (if so, remaining classes will be ignored)"
    exit 0
fi

TOTAL_PARTICLES=$(relion_star_printtable $STAR_FILE data_ _rlnClassNumber | wc -l)

echo Analysing star file: $(realpath $STAR_FILE)
echo Total number of particles: $TOTAL_PARTICLES

for i in $(eval echo "{1..$CLASSES}"); do
    PARTICLES=$(relion_star_printtable $STAR_FILE data_ _rlnClassNumber | grep $i | wc -l)
    PRCT_TOTAL=$((100*$PARTICLES/$TOTAL_PARTICLES))
    echo "Number of particles in class $i: $PARTICLES ($PRCT_TOTAL % of total)"
done

