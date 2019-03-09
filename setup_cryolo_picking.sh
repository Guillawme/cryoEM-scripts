#! /usr/bin/env bash

# Set up a working directory for particle picking with crYOLO.
# Run this at the root of a RELION project directory.

# Update this URL with latest model before running this script.
# This can also be an absolute path if the file is already present on the local
# machine or if you are using a model you trained yourself.
LATEST_CRYOLO_MODEL=ftp://ftp.gwdg.de/pub/misc/sphire/crYOLO-GENERAL-MODELS/gmodel_phosnet_20190218_loss0042.h5

# Don't change after this line
CWD=$(pwd)
CRYOLO_CONFIG=https://raw.githubusercontent.com/Guilz/cryoEM-scripts/master/cryolo_config.json
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
To pick micrographs using an already trained crYOLO model:

1. Symlink or copy your motion corrected micrographs into training_micrographs/
   ln -s /absolute/path/to/micrographs_*.mrc micrographs/
3. Edit config.json to adjust parameters, see following docs
   http://sphire.mpg.de/wiki/doku.php?id=pipeline:window:cryolo
   http://sphire.mpg.de/wiki/doku.php?id=cryolo_config
4. Edit run_cryolo_picking.sh to indicate your model file (otherwise, crYOLO's
   pretrained model will be used)
5. Pick your micrographs: run run_cryolo_picking.sh
   resulting coordinate files will be written to micrographs_coordinates/
6. Optionally inspect picking results visually, but more likely import
   coordinates into your favorite 2D classification software.
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
         -O $CRYOLO_PICKING \
        -o config.json -O $CRYOLO_CONFIG
elif [ $WGET_AVAILABLE ]
then
    echo "Downloading config file and run scripts..."
     wget $CRYOLO_PICKING
    wget -O config.json $CRYOLO_CONFIG
else
    cannot_download
fi

# Make run scripts executable
chmod +x run_cryolo_picking.sh

