#! /bin/bash

#  No, we are not building you a desktop computer using a bash script, but 
# rather, this script builds everything for the Openbox desktop. If you
# are into another lightweight desktop, it likely has many of the same
# dependencies, so this script might be kinda useful.

## Start variables
START_DIR=$(pwd)
PACKAGE_DIR="$START_DIR/packs/desktop"
SCRIPT_DIR="$START_DIR/build_scripts/desktop"
# Install or naw?
INSTALL=0
# Number of cores to use
CORES=$(grep -c ^processor /proc/cpuinfo)
## End variables

## Start script
# Stop on errors
set -o errexit
# Lets build some stuff!
# cairo
source "$SCRIPT_DIR/cairo.sh" "1.14.6"
# gobject-introspection
source "$SCRIPT_DIR/gobject_intro.sh" "1.48.0"
# pango
source "$SCRIPT_DIR/pango.sh" "1.40.1"
# nasm
source "$SCRIPT_DIR/nasm.sh" "2.12.01"
# libjpeg-turbo
source "$SCRIPT_DIR/libjpeg.sh" "1.4.2"
# libtiff
source "$SCRIPT_DIR/libtiff.sh" "4.0.6"
# gdk-pixbuf
source "$SCRIPT_DIR/gdk_pixbuf.sh" "2.34.0"
# imlib2
source "$SCRIPT_DIR/imlib2.sh" "1.4.9"
# libcroco
source "$SCRIPT_DIR/libcroco.sh" "0.6.11"
# librsvg
source "$SCRIPT_DIR/librsvg.sh" "2.40.15"
# startup-notification
source "$SCRIPT_DIR/startup.sh" "0.12"
# rxvt-unicode (URxvt)
source "$SCRIPT_DIR/urxvt.sh" "9.22"
# openbox
source "$SCRIPT_DIR/openbox.sh" "3.6.1"

echo "All done! Have a good day." 

## End script
