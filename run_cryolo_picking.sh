#! /usr/bin/env bash

# See documentation at <http://sphire.mpg.de/wiki/doku.php?id=pipeline:window:cryolo>

# Pick all micrographs with cryolo, using a generic model

# --weigths indicates which model to use: optionally provide a model trained
# specifically on your own data here

# --threshold is a picking threshold: default 0.3, increase to make it more
# picky, decrease to make it more greedy

# --distance will consider duplicates two particles that are closer to each
# other than the set distance, and will only keep one such particle

# --gpu designates which GPU to use

# This line depends on your environment setup.
# Comment it out or edit it as needed.
module load cuda/9.0 anaconda/3 eman2/2.22

cryolo_predict.py \
	--conf config.json \
	--weigths gmodel_phosnet_20190218_loss0042.h5 \
	--input micrographs/ \
	--output micrographs_coordinates/ \
	--threshold 0.3 \
        --distance 0 \
	--gpu 0 \
	2>cryolo_generic_picking.err | tee cryolo_generic_picking.log

