#! /bin/bash

#  Today, we will be building the ALSA and Pulseaudio libraries from scratch.
# Sounds like a load of fun? Well that is because it is.

## Start variables
SCRIPT_DIR="./scripts"
PACKAGE_DIR="./sources"
# Configuration
CORES=$(grep -c ^processor /proc/cpuinfo)
INSTALL=0
## End variables

## Start script
# End script when error occurs
set -o errexit
# Time to build!
# ALSA-lib
source "$SCRIPT_DIR/alsa_lib.sh" "1.1.1"
# ALSA-plugins
source "$SCRIPT_DIR/alsa_plugins.sh" "1.1.1"
# ALSA-utils
source "$SCRIPT_DIR/alsa_utils.sh" "1.1.1"
# Json-C
source "$SCRIPT_DIR/jsonc.sh" "0.12-20140410"
# libogg
source "$SCRIPT_DIR/libogg.sh" "1.3.2"
# libvorbis
source "$SCRIPT_DIR/libvorbis.sh" "1.3.5"
# FLAC
source "$SCRIPT_DIR/flac.sh" "1.3.1"
# LAME
source "$SCRIPT_DIR/lame.sh" "3.99.5"
# libsndfile
source "$SCRIPT_DIR/libsndfile.sh" "1.0.26"
# Pulseaudio
source "$SCRIPT_DIR/pulseaudio.sh" "8.0"

echo "Listen to all the audio your heart desires!"
## End script
