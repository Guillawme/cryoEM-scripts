#! /usr/bin/env bash

# See documentation at <http://sphire.mpg.de/wiki/doku.php?id=pipeline:window:cryolo>

# Provide either a runfile or a training set (images and box files), not all at
# the same time.

# This line depends on your environment setup.
# Comment it out or edit it as needed.
module purge
module load cuda/9.0 cryolo/v1.5.1

RUN="001"

cryolo_evaluation.py \
    --config config.json \
    --weights your-model.h5 \
    --runfile runfiles/your-latest-runfile.json \
    --gpu 0 \
    2>cryolo_evaluation_"$RUN".err | tee cryolo_evaluation_"$RUN".log

