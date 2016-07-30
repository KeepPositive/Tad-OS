#! /bin/bash

#  No, we are not building you a desktop computer using a bash script, but
# rather, this script builds everything for the Openbox desktop. If you
# are into another lightweight desktop, it likely has many of the same
# dependencies, so this script might be kinda useful.

## Start variables
SOURCE_DIR="./sources"
SCRIPT_DIR="./scripts"
# Install or naw?
INSTALL_SOURCES=0
# Number of cores to use
CORES=$(grep -c ^processor /proc/cpuinfo)
## End variables

## Start script
# Stop on errors
set -o errexit
# Lets build some stuff!
# cairo
source "$SCRIPT_DIR/cairo.sh"
# gobject-introspection
source "$SCRIPT_DIR/gobject_intro.sh"
# pango
source "$SCRIPT_DIR/pango.sh"
# nasm
source "$SCRIPT_DIR/nasm.sh"
# libjpeg-turbo
source "$SCRIPT_DIR/libjpeg.sh"
# libtiff
source "$SCRIPT_DIR/libtiff.sh"
# gdk-pixbuf
source "$SCRIPT_DIR/gdk_pixbuf.sh"
# imlib2
source "$SCRIPT_DIR/imlib2.sh"
# libcroco
source "$SCRIPT_DIR/libcroco.sh"
# librsvg
source "$SCRIPT_DIR/librsvg.sh"
# startup-notification
source "$SCRIPT_DIR/startup.sh"
# rxvt-unicode (URxvt)
source "$SCRIPT_DIR/urxvt.sh"
# openbox
source "$SCRIPT_DIR/openbox.sh"
# hsetroot
source "$SCRIPT_DIR/hsetroot.sh"

echo "All done! Have a good day."

## End script
