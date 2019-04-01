#! /usr/bin/env bash

# See documentation at <http://sphire.mpg.de/wiki/doku.php?id=pipeline:window:cryolo>

# Pick all micrographs with cryolo, using a generic model

# --weights indicates which model to use: optionally provide a model trained
# specifically on your own data here

# --threshold is a picking threshold: default 0.3, increase to make it more
# picky, decrease to make it more greedy

# --distance will consider duplicates two particles that are closer to each
# other than the set distance, and will only keep one such particle

# --otf means micrographs will be low-pass filtered on the fly and not saved.
# This saves disk space at the expense of slightly longer picking time. If you
# want to run picking several times with different options, removing this option
# might speed up subsequent runs.

# --gpu designates which GPU to use

# This line depends on your environment setup.
# Comment it out or edit it as needed.
module purge
module load cuda/9.0 cryolo/v1.3.1

cryolo_predict.py \
	--conf config.json \
	--weights gmodel_phosnet_20190314.h5 \
	--input micrographs/ \
	--output coordinates/ \
	--threshold 0.3 \
        --distance 0 \
        --otf \
	--gpu 0 \
	2>cryolo_generic_picking.err | tee cryolo_generic_picking.log

