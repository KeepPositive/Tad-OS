#! /bin/bash

## Start variables
SOURCE_DIR="./sources"
SCRIPT_DIR="./scripts"
INSTALL_SOURCES=0
CORES=$(grep -c ^processor /proc/cpuinfo)
## End variables

## Start script
# Stop if error occurs
set -o errexit

# Let's build some stuff!
# libevent
#source "$SCRIPT_DIR/libevent.sh"
# zip
#source "$SCRIPT_DIR/zip.sh"
# unzip
#source "$SCRIPT_DIR/unzip.sh"
# yasm
#source "$SCRIPT_DIR/yasm.sh"
# libvpx
#source "$SCRIPT_DIR/libvpx.sh"
# x264
#source "$SCRIPT_DIR/x264.sh"
# x265
#source "$SCRIPT_DIR/x265.sh"
#ffmpeg
#source "$SCRIPT_DIR/ffmpeg.sh"
# firefox
source "$SCRIPT_DIR/firefox.sh"

echo "All done! Enjoy surfing the web!"

# End script
