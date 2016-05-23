#! /bin/bash

## Start variables

SCRIPT_DIR="$LFS/toolchain"
PACKAGE_DIR="$LFS/source"
TOOL_DIR=/tools
PATH="$TOOL_DIR/bin":/bin:/usr/bin
INSTALL=1
SYSTEM=$(grep "SYSTEM" "$SCRIPT_DIR/build.cfg" | awk '{print $2}')
# Some compression formats
XZIP=".tar.xz"
BZIP=".tar.bz2"
GZIP=".tar.gz"

## End variables

## Start script
# Exit when an error occurs
set -o errexit
# Start building stuff!
source "$SCRIPT_DIR/binutils1.sh" "2.26"

source "$SCRIPT_DIR/gcc1.sh" "6.1.0" "3.1.4" "6.1.0" "1.0.3"

case $SYSTEM in
"rpi")
    source "$SCRIPT_DIR/rpi-headers.sh" "4.4.y"
;;

*)
    source "$SCRIPT_DIR/linux-headers.sh" "4.5.2"
;;
esac

source "$SCRIPT_DIR/glibc.sh" "2.23"

source "$SCRIPT_DIR/libstdc.sh" "6.1.0"

source "$SCRIPT_DIR/binutils2.sh" "2.26"

source "$SCRIPT_DIR/gcc2.sh" "6.1.0" "3.1.4" "6.1.0" "1.0.3"

source "$SCRIPT_DIR/tcl.sh" "8.6.5"

source "$SCRIPT_DIR/expect.sh" "5.45"

source "$SCRIPT_DIR/dejagnu.sh" "1.6"

source "$SCRIPT_DIR/check.sh" "0.10.0"

source "$SCRIPT_DIR/ncurses.sh" "6.0"

source "$SCRIPT_DIR/bash.sh" "4.3.30"

source "$SCRIPT_DIR/bzip.sh" "1.0.6"

source "$SCRIPT_DIR/coreutils.sh" "8.25"

# All packages that use std_build use the same commands to be built and installed
source "$SCRIPT_DIR/std_build.sh" "diffutils" "3.3" "$XZIP"

source "$SCRIPT_DIR/std_build.sh" "file" "5.26" "$GZIP"

source "$SCRIPT_DIR/std_build.sh" "findutils" "4.6.0" "$GZIP"

source "$SCRIPT_DIR/std_build.sh" "gawk" "4.1.3" "$XZIP"

source "$SCRIPT_DIR/gettext.sh" "0.19.7"

source "$SCRIPT_DIR/std_build.sh" "grep" "2.25" "$XZIP"

source "$SCRIPT_DIR/std_build.sh" "gzip" "1.8" "$XZIP"

source "$SCRIPT_DIR/std_build.sh" "m4" "1.4.17" "$XZIP"

source "$SCRIPT_DIR/make.sh" "4.1"

source "$SCRIPT_DIR/std_build.sh" "patch" "2.7.5" "$XZIP"

source "$SCRIPT_DIR/perl.sh" "5.22.1" "$BZIP"

source "$SCRIPT_DIR/std_build.sh" "sed" "4.2.2" "$BZIP"

source "$SCRIPT_DIR/std_build.sh" "tar" "1.28" "$XZIP"

source "$SCRIPT_DIR/std_build.sh" "texinfo" "6.1" "$XZIP"

source "$SCRIPT_DIR/utillinux.sh" "2.28"

source "$SCRIPT_DIR/std_build.sh" "xz" "5.2.2" "$XZIP"

## End script
