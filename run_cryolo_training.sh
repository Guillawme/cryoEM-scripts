#! /usr/bin/env bash

# See documentation at <http://sphire.mpg.de/wiki/doku.php?id=pipeline:window:cryolo>

# Train a cryolo model on your own data
# Indicate a filename in which to save the model in config.json

# --early indicates how many epochs without improvement the training procedure
# will wait before early training termination

# --gpu designates which GPU to use

# --fine_tune is only useful when training from a pre-existing model, to speed
# up training by only optimizing weights of two layers (instead of all of them);
# add this option as necessary.

# This line depends on your environment setup.
# Comment it out or edit it as needed.
module purge
module load cuda/9.0 cryolo/v1.3.1

RUN=001

# Warm-up
# This is not strictly required if starting from pre-trained weigths
cryolo_train.py \
    --conf config.json \
    --warmup 3 \
    --gpu 0 \
    2>cryolo_warmup_"$RUN".err | tee cryolo_warmup_"$RUN".log

# Training
cryolo_train.py \
    --conf config.json \
    --warmup 0 \
    --gpu 0 \
    --early 10 \
    \ #--fine_tune \
    2>cryolo_training_"$RUN".err | tee cryolo_training_"$RUN".log

