#! /usr/bin/env bash

# Set up a working directory for particle picking with crYOLO.
# Run this at the root of a RELION project directory.

# Update this URL with latest model before running this script
# This can also be an absolute path if the file is already present on the local
# machine
LATEST_CRYOLO_MODEL=ftp://ftp.gwdg.de/pub/misc/sphire/crYOLO-GENERAL-MODELS/gmodel_phosnet_20190218_loss0042.h5

# Don't change after this line
CWD=$(pwd)
CRYOLO_CONFIG=https://raw.githubusercontent.com/Guilz/cryoEM-scripts/master/cryolo_config.json
CRYOLO_TRAINING=https://raw.githubusercontent.com/Guilz/cryoEM-scripts/master/run_cryolo_training.sh
CRYOLO_PICKING=https://raw.githubusercontent.com/Guilz/cryoEM-scripts/master/run_cryolo_picking.sh

## Stop if there is already a crYOLO directory here
if [ -d "crYOLO" ]; then
    echo "There is already a crYOLO directory here."
    exit 0
fi

## Create directory structure under a new directory
mkdir -p \
      $CWD/crYOLO \
      $CWD/crYOLO/micrographs \
      $CWD/crYOLO/micrographs_coordinates \
      $CWD/crYOLO/training_micrographs \
      $CWD/crYOLO/training_micrographs_coordinates \
      $CWD/crYOLO/validation_micrographs \
      $CWD/crYOLO/validation_micrographs_coordinates

## Keep all files under crYOLO/
cd $CWD/crYOLO

## Add some instructions
cat >README.txt <<EOF
To run crYOLO:
1. symlink your motion corrected micrographs into micrographs/
   ln -s /absolute/path/to/micrographs_*.mrc micrographs/
2. if you plan to use the generic model, there is no need for training
   and validation sets of micrographs
2. edit config.json to adjust parameters, see following docs
   http://sphire.mpg.de/wiki/doku.php?id=pipeline:window:cryolo
   http://sphire.mpg.de/wiki/doku.php?id=cryolo_config
3. if you plan to train a model on your own data:
   a. symlink or copy a set of micrographs covering the entire defocus range and
      various pixel sizes you may have for the same particle into
      training_micrographs/ and corresponding particle coordinates into
      training_micrographs_coordinates (.box format); micrographs should ideally
      be picked to completion and cleanly (only particles, no frost picked)
   b. crYOLO will automatically use a subset of 20% of the training set and use
      it as a validation set
4. run run_cryolo_training.sh to train a model
5. run run_cryolo_picking.sh to pick particles
EOF

## Helpers
CURL_AVAILABLE=$(which curl)
WGET_AVAILABLE=$(which wget)

function cannot_download() {
    echo "Could not download files."
    echo "Check that wget or curl is installed and rerun this script."
    echo "You can also create crYOLO config file manually."
    echo "You can find run scripts at https://github.com/Guilz/cryoEM-scripts"
    echo "You can find crYOLO model at http://sphire.mpg.de/wiki/doku.php?id=downloads:cryolo_1"
    exit 1
}

## Download or symlink generic cryolo model
if [ -f "$LATEST_CRYOLO_MODEL" ]; then
    ln -s $LATEST_CRYOLO_MODEL .
elif [ $CURL_AVAILABLE ]
then
     curl -O $LATEST_CRYOLO_MODEL
elif [ $WGET_AVAILABLE ]
then
     wget $LATEST_CRYOLO_MODEL
else
    cannot_download
fi

## Download config file and run scripts
if [ $CURL_AVAILABLE ]; then
    curl \
        -O $CRYOLO_CONFIG -o config.json \
        -O $CRYOLO_TRAINING \
        -O $CRYOLO_PICKING
elif [ $WGET_AVAILABLE ]
then
    wget \
        $CRYOLO_CONFIG -O config.json \
        $CRYOLO_TRAINING \
        $CRYOLO_PICKING
else
    cannot_download
fi

