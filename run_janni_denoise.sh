#!/usr/bin/env bash

# Run janni_denoise on all micrographs
# This assumes motion-corrected micrographs are in a Micrographs/ directory
# under the working directory. Denoised micrographs will be written in
# denoised/Micrographs/
# See <http://sphire.mpg.de/wiki/doku.php?id=janni_tutorial>

module purge
module load cuda/9.0 cryolo/v1.5.1

janni_denoise.py \
    denoise \
    --gpu 0 \
    Micrographs/ \
    denoised/ \
    gmodel_janni_20190703.h5 \
2>janni_denoise.err | tee janni_denoise.log

