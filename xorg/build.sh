#! /bin/bash

#  This a simple build script which uses sub-scripts to build an X.Org server
# from scratch, along with all of it's necessary dependencies.
SCRIPT_DIR="./scripts"
SOURCE_DIR="./sources"
XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static "
# Configurables
# Choose from: "amd", "intel" or "rpi"
# Nvidia cards are not supported because I do not have one to test on
GRAPHICS_DRIVER="amd"
INSTALL_SOURCES=0
CORES=$(grep -c ^processor /proc/cpuinfo)

# Start script
set -o errexit

## Start building some things
# util-macros
source "$SCRIPT_DIR/std_xorg_install.sh" "util-macros"
# X.Org protocol headers
source "$SCRIPT_DIR/group_build.sh" "proto"
# libXau
source "$SCRIPT_DIR/std_xorg_build.sh" "libXau"
# libXdmcp
source "$SCRIPT_DIR/std_xorg_build.sh" "libXdmcp"
# xcb-proto
source "$SCRIPT_DIR/std_xorg_install.sh" "xcb-proto"
# build libxcb
source "$SCRIPT_DIR/libxcb.sh"
# Start dependencies for Fontconfig which is a dependency for X.Org libraries
# build libpng
source "$SCRIPT_DIR/libpng.sh"
# build FreeType
source "$SCRIPT_DIR/freetype.sh"
# build elfutils (a glib optional dependency, but needed for Mesa later)
source "$SCRIPT_DIR/elfutils.sh"
# build GLib
source "$SCRIPT_DIR/glib.sh"
# build ICU
source "$SCRIPT_DIR/icu.sh"
# build HarfBuzz
source "$SCRIPT_DIR/harfbuzz.sh"
## Rebuild FreeType with HarfBuzz as a dependency
source "$SCRIPT_DIR/freetype.sh"
# Finally, build Fontconfig
source "$SCRIPT_DIR/fontconfig.sh"
# build the X.Org libraries group
source "$SCRIPT_DIR/group_build.sh" "lib"
# build xcb-util
source "$SCRIPT_DIR/std_xorg_build.sh" "xcb-util"
# build xcb-util-image
source "$SCRIPT_DIR/std_xorg_build.sh" "xcb-util-image"
# build xcb-util-keysms
source "$SCRIPT_DIR/std_xorg_build.sh" "xcb-util-keysyms"
# build xcb-util-renderutil
source "$SCRIPT_DIR/std_xorg_build.sh" "xcb-util-renderutil"
# build xcb-util-wm
source "$SCRIPT_DIR/std_xorg_build.sh" "xcb-util-wm"
# build xcb-util-cursor
source "$SCRIPT_DIR/std_xorg_build.sh" "xcb-util-cursor"
# Start Mesa build dependencies
# build libdrm
source "$SCRIPT_DIR/libdrm.sh"
# build llvm (without clang)
source "$SCRIPT_DIR/llvm.sh"
# build libvpdau
source "$SCRIPT_DIR/libvdpau.sh"
# mesa
source "$SCRIPT_DIR/mesa.sh"
# xbitmaps
source "$SCRIPT_DIR/std_xorg_install.sh" "xbitmaps"
# X.Org applications group
source "$SCRIPT_DIR/group_build.sh" "app"
source "$SCRIPT_DIR/std_xorg_build.sh" "xcursor-themes"
source "$SCRIPT_DIR/group_build.sh" "font"
source "$SCRIPT_DIR/xkeyboardconfig.sh"
source "$SCRIPT_DIR/pixman.sh"
source "$SCRIPT_DIR/libepoxy.sh"
source "$SCRIPT_DIR/xorgserver.sh"
## This is the part where it gets messy. Time to install drivers...
## Please make sure your kernel is configured correctly.
source "$SCRIPT_DIR/libevdev.sh"
source "$SCRIPT_DIR/mtdev.sh"
# Might try this alternative in the future
source "$SCRIPT_DIR/libinput.sh"
source "$SCRIPT_DIR/input-evdev.sh"

case "$GRAPHICS_DRIVER" in
"amd")
    echo "Making AMD/ATI graphics driver"
    sleep 2
    source "$SCRIPT_DIR/amd.sh"
;;
"intel")
    source "$SCRIPT_DIR/intel.sh"
;;
"rpi")
    echo "Making the RPi framebuffer driver 'fbturbo'"
    source "$SCRIPT_DIR/fbturbo.sh"
;;
esac
# xinit
source "$SCRIPT_DIR/xinit.sh"

echo "All done! Enjoy the remainder of your day"
## End script
