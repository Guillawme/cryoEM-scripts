#! /usr/bin/env bash

# Set up a working directory for particle picking with crYOLO.
# Run this at the root of a RELION project directory.

# Update this URL with latest model before running this script.
# This can also be an absolute path if the file is already present on the local
# machine.
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

## Keep all files under crYOLO/
cd $CWD/crYOLO

## Add some instructions
cat >README.txt <<EOF
To train crYOLO from unpicked micrographs:

1. Choose a set of micrographs covering the entire defocus range of your
   dataset, and from various datasets with different pixel sizes you may have
   for the same particle; micrographs must be picked perfectly (only particles,
   no junk or any kind of false positives, and no remaining unpicked particles).
2. Symlink or copy your motion corrected micrographs into training_micrographs/
   ln -s /absolute/path/to/micrographs_*.mrc micrographs/
3. Edit config.json to adjust parameters, see following docs
   http://sphire.mpg.de/wiki/doku.php?id=pipeline:window:cryolo
   http://sphire.mpg.de/wiki/doku.php?id=cryolo_config
4. Pick your micrographs using the pre-trained model: run run_cryolo_picking.sh
   resulting coordinate files will be written to training_micrographs_coordinates/
5. Inspect picking results and manually fix what needs to be fixed (unpick junk,
   pick missed particles) with cryolo_box_manager.py
6. crYOLO will automatically use a subset of 20% of the training set and use it
   as a validation set, so no need to assemble a validation set.
7. Run run_cryolo_training.sh to train a model.
8. The resulting model can now be used to pick your entire dataset.
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

## Symlink or download generic cryolo model
if [ -f "$LATEST_CRYOLO_MODEL" ]; then
    echo "Linking to local crYOLO model file..."
    ln -s $LATEST_CRYOLO_MODEL .
elif [ $CURL_AVAILABLE ]
then
    echo "Downloading crYOLO model..."
    curl -O $LATEST_CRYOLO_MODEL
elif [ $WGET_AVAILABLE ]
then
    echo "Downloading crYOLO model..."
    wget $LATEST_CRYOLO_MODEL
else
    cannot_download
fi

## Download config file and run scripts
if [ $CURL_AVAILABLE ]; then
    echo "Downloading config file and run scripts..."
    curl \
        -O $CRYOLO_TRAINING \
        -O $CRYOLO_PICKING \
        -o config.json -O $CRYOLO_CONFIG
elif [ $WGET_AVAILABLE ]
then
    echo "Downloading config file and run scripts..."
    wget $CRYOLO_TRAINING
    wget $CRYOLO_PICKING
    wget -O config.json $CRYOLO_CONFIG
else
    cannot_download
fi

# Make run scripts executable
chmod +x run_cryolo_training.sh run_cryolo_picking.sh

