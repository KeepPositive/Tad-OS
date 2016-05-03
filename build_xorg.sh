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
## Choose from: "amd", "intel" or "pi"
## Nvidia cards are not supported because I do not have one to test on
GRAPHICS_DRIVER="amd"
INSTALL=0
CORES=$(grep -c ^processor /proc/cpuinfo)

## Start script

echo "Building xorg server"
sleep 3
# build util-macros
source "$SCRIPT_DIR/std_xorg_install.sh" "util-macros" "1.19.0"
# build the X.Org protocol headers
source "$SCRIPT_DIR/group_build.sh" "proto"
# build libXau
source "$SCRIPT_DIR/std_xorg_build.sh" "libXau" "1.0.8"
# build libXdmcp
source "$SCRIPT_DIR/std_xorg_build.sh" "libXdmcp" "1.1.2"
# build xcb-proto
source "$SCRIPT_DIR/std_xorg_install.sh" "xcb-proto" "1.11"
# build libxcb
source "$SCRIPT_DIR/libxcb.sh" "1.11.1"
## Start dependencies for Fontconfig which is a dependency for X.Org libraries
# build libpng
source "$SCRIPT_DIR/libpng.sh" "1.6.21"
# build FreeType
source "$SCRIPT_DIR/freetype.sh" "2.6.3"
# build elfutils (a glib optinal dependency, but needed for Mesa later)
source "$SCRIPT_DIR/elfutils.sh" "0.166"
# build GLib
source "$SCRIPT_DIR/glib.sh" "2.48.0"
# build ICU
source "$SCRIPT_DIR/icu.sh" "57_1"
# build HarfBuzz
source "$SCRIPT_DIR/harfbuzz.sh" "1.2.6"
## Rebuild FreeType with HarfBuzz as a dependency
source "$SCRIPT_DIR/freetype.sh" "2.6.3"
# Finally, build Fontconfig
source "$SCRIPT_DIR/fontconfig.sh" "2.11.1"
# build the X.Org libraries group
source "$SCRIPT_DIR/group_build.sh" "lib"
# build xcb-util
source "$SCRIPT_DIR/std_xorg_build.sh" "xcb-util" "0.4.0"
# build xcb-util-image
source "$SCRIPT_DIR/std_xorg_build.sh" "xcb-util-image" "0.4.0"
# build xcb-util-keysms
source "$SCRIPT_DIR/std_xorg_build.sh" "xcb-util-keysyms" "0.4.0"
# build xcb-util-renderutil
source "$SCRIPT_DIR/std_xorg_build.sh" "xcb-util-renderutil" "0.3.9"
# build xcb-util-wm
source "$SCRIPT_DIR/std_xorg_build.sh" "xcb-util-wm" "0.4.1"
# build xcb-util-cursor
source "$SCRIPT_DIR/std_xorg_build.sh" "xcb-util-cursor" "0.1.2"
## Start Mesa build dependencies
# build libdrm
source "$SCRIPT_DIR/libdrm.sh" "2.4.67"
# build llvm (without clang)
source "$SCRIPT_DIR/llvm.sh" "3.8.0"
# build libvpdau
source "$SCRIPT_DIR/libvdpau.sh" "1.1.1"
# build mesa
source "$SCRIPT_DIR/std_xorg_install.sh" "xbitmaps" "1.1.1"
# build the X.Org applications group
source "$SCRIPT_DIR/group_build.sh" "app"
source "$SCRIPT_DIR/std_xorg_build".sh "xcursor-themes" "1.0.4"
source "$SCRIPT_DIR/group_build.sh" "font"
source "$SCRIPT_DIR/xkeyboardconfig.sh" "2.17"
source "$SCRIPT_DIR/pixman.sh" "0.34.0"
source "$SCRIPT_DIR/libepoxy.sh" "1.3.1"
source "$SCRIPT_DIR/xorgserver.sh" "1.18.3"
## This is the part where it gets messy. Time to install drivers...
## Please make sure your kernel is configured correctly.
source "$SCRIPT_DIR/libevdev.sh" "1.4.6"
source "$SCRIPT_DIR/mtdev.sh" "1.1.5"
## Might try this alternative in the future
source "$SCRIPT_DIR/libinput.sh" "1.2.4"
source "$SCRIPT_DIR/input-evdev.sh" "2.10.1"

case "$GRAPHICS_DRIVER" in
"amd")
    echo "Making AMD/ATI graphics driver" && sleep 2
    source "$SCRIPT_DIR/amd.sh" "7.7.0"
;;
"intel") 
    source "$SCRIPT_DIR/intel.sh" "0340718"
;;
"pi")
    source "$SCRIPT_DIR/fbturbo.sh"
;;
esac

## End script
