#! /usr/bin/env bash

# See documentation at <http://sphire.mpg.de/wiki/doku.php?id=pipeline:window:cryolo>

# Train a cryolo model on your own data
# Indicate a filename in which to save the model in config.json

# --early indicates how many epochs without improvement the training procedure
# will wait before early training termination

# --gpu designates which GPU to use

# This line depends on your environment setup.
# Comment it out or edit it as needed.
module load cuda/9.0 anaconda/3 eman2/2.22

# Warm-up
# This is not strictly required if starting from pre-trained weigths
cryolo_train.py \
	--conf config.json \
	--warmup 3 \
	--gpu 0 \
	2>cryolo_warmup.err | tee cryolo_warmup.log

# Training
cryolo_train.py \
	--conf config.json \
	--warmup 0 \
	--gpu 0 \
	--early 10 \
	2>cryolo_training.err | tee cryolo_training.log

