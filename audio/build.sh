#! /bin/bash

#  Today, we will be building the ALSA and Pulseaudio libraries from scratch.
# Sounds like a load of fun? Well that is because it is.

## Start variables
SCRIPT_DIR="./scripts"
SOURCE_DIR="./sources"
# Configuration
CORES=$(grep -c ^processor /proc/cpuinfo)
INSTALL_SOURCES=0
## End variables

## Start script
echo "$SCRIPT_DIR"
echo "$PACKAGE_DIR"
# End script when error occurs
set -o errexit
# Time to build!
# ALSA-lib
echo "NIM"
source "$SCRIPT_DIR/alsa_lib.sh"
echo "SQUID"
# ALSA-plugins
source "$SCRIPT_DIR/alsa_plugins.sh"
# ALSA-utils
source "$SCRIPT_DIR/alsa_utils.sh"
# Json-C
source "$SCRIPT_DIR/jsonc.sh"
# libogg
source "$SCRIPT_DIR/libogg.sh"
# libvorbis
source "$SCRIPT_DIR/libvorbis.sh"
# FLAC
source "$SCRIPT_DIR/flac.sh"
# LAME
source "$SCRIPT_DIR/lame.sh"
# libsndfile
source "$SCRIPT_DIR/libsndfile.sh"
# Pulseaudio
source "$SCRIPT_DIR/pulseaudio.sh"

echo "Listen to all the audio your heart desires!"
## End script
