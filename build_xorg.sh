#! /bin/bash

#  This a simple build script which uses sub-scripts to build an X.Org server
# from scratch, along with all of it's necessary dependencies.
START_DIR=$(pwd)
SCRIPT_DIR="$START_DIR/xorg"
PACKAGE_DIR="$START_DIR/packs"
XORG_PREFIX="/usr"
XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
             --localstatedir=/var --disable-static"
# Configurables
INSTALL=0
CORES=$(grep -c ^processor /proc/cpuinfo)

## Start script

echo "Building xorg server"
sleep 5
# build util-macros
source "$SCRIPT_DIR/std_xorg_install.sh" "util-macros" "1.19.0"
# build the X.Org protocol headers
source "$SCRIPT_DIR/group_build.sh" "proto"
# build libXau
source "$SCRIPT_DIR/std_xorg_build" "libXau" "1.0.8"
# build libXdmcp
source "$SCRIPT_DIR/std_xorg_build" "libXdmcp" "1.1.2"
# build xcb-proto
source "$SCRIPT_DIR/std_xorg_install.sh" "xcb-proto" "1.11"
# build libxcb
source "$SCRIPT_DIR/libxcb.sh" "1.11.1"
### FONTCONFIG AND DEPENDENCIES MUST GO HERE!
# build the X.Org libraries group
source "$SCRIPT_DIR/group_build.sh" "lib"
#
source "$SCRIPT_DIR/std_xorg_build" "xcb-util" "0.4.0"
#
source "$SCRIPT_DIR/std_xorg_build" "xcb-util-image" "0.4.0"
#
source "$SCRIPT_DIR/std_xorg_build" "xcb-util-keysms" "0.4.0"
#
source "$SCRIPT_DIR/std_xorg_build" "xcb-util-renderutil" "0.3.9"
#
source "$SCRIPT_DIR/std_xorg_build" "xcb-util-wm" "0.4.1"
#
source "$SCRIPT_DIR/std_xorg_build" "xcb-util-cursor" "0.1.2"
### MESA + DEPENDENCIES MUST GO HERE!
## End script
