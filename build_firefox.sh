#! /bin/bash

## Start variables

START_DIR=$(pwd)
PACKAGE_DIR="$START_DIR/packs/firefox"
SCRIPT_DIR="$START_DIR/build_scripts/firefox"

INSTALL_SOURCES=1
## End variables

## Start script
# Stop if error occurs
set -o errexit

# Let's build some stuff!
# libevent
source "$SCRIPT_DIR/libevent.sh" "2.0.22"
# zip
source "$SCRIPT_DIR/zip.sh" "30"
# unzip
source "$SCRIPT_DIR/unzip.sh" "60"
# yasm
source "$SCRIPT_DIR/yasm.sh" "1.3.0"
# libvpx
source "$SCRIPT_DIR/libvpx.sh" "1.5.0"
# x264
source "$SCRIPT_DIR/x264.sh" "20160220-2245"
# x265
source "$SCRIPT_DIR/x265.sh" "1.9"
 ffmpeg
source "$SCRIPT_DIR/ffmpeg.sh" "3.0.2"
# firefox
source "$SCRIPT_DIR/firefox.sh" "46.0.1"

echo "All done! Enjoy surfing the web!"

# End script
