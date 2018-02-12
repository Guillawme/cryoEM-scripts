#! /usr/bin/env bash

# Wrapper to count_particles.sh to apply to all *_data.star files in a directory.

for iter in *_data.star; do
    count_particles.awk $iter > $iter.tsv
done

