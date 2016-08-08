#! /bin/bash

## Start variables

CONFIGURE_FILE="../build.conf"
CORES=9

# Get some variables from build.cfg
for name in "LFS" "SYSTEM" "INSTALL_SOURCES"
do
  # The 'eval' command evaluates a string into runable bash
  eval "export $name=$(grep $name "$CONFIGURE_FILE" | awk '{print $2}')"

  if [ "$?" -ne 0 ]
  then
    echo "$name could not be created! Error!"
    exit 1
  fi
done

SCRIPT_DIR='./scripts'
SOURCE_DIR="../sources"
TOOL_DIR="../tools"

# Some compression formats
XZIP=".tar.xz"
BZIP=".tar.bz2"
GZIP=".tar.gz"
## End variables

## Start script
# Exit when an error occurs
set -o errexit
# Start building stuff!
source "$SCRIPT_DIR/binutils1.sh"

source "$SCRIPT_DIR/gcc1.sh"
# Build the correct kernel for the build type
case $SYSTEM in
  "rpi")
    source "$SCRIPT_DIR/rpi-headers.sh"
  ;;
  *)
    source "$SCRIPT_DIR/linux-headers.sh"
  ;;
esac

source "$SCRIPT_DIR/glibc.sh"

source "$SCRIPT_DIR/libstdc.sh"

source "$SCRIPT_DIR/binutils2.sh"

source "$SCRIPT_DIR/gcc2.sh"

source "$SCRIPT_DIR/tcl.sh"

source "$SCRIPT_DIR/expect.sh"

source "$SCRIPT_DIR/dejagnu.sh"

source "$SCRIPT_DIR/check.sh"

source "$SCRIPT_DIR/ncurses.sh"

source "$SCRIPT_DIR/bash.sh"

source "$SCRIPT_DIR/bzip.sh"

source "$SCRIPT_DIR/coreutils.sh"

# All packages that use std_build use the same commands to be built and installed
source "$SCRIPT_DIR/std_build.sh" "diffutils" "$XZIP"

source "$SCRIPT_DIR/std_build.sh" "file" "$GZIP"

source "$SCRIPT_DIR/std_build.sh" "findutils" "$GZIP"

source "$SCRIPT_DIR/std_build.sh" "gawk" "$XZIP"

source "$SCRIPT_DIR/gettext.sh"

source "$SCRIPT_DIR/std_build.sh" "grep" "$XZIP"

source "$SCRIPT_DIR/std_build.sh" "gzip" "$XZIP"

source "$SCRIPT_DIR/std_build.sh" "m4" "$XZIP"

source "$SCRIPT_DIR/make.sh"

source "$SCRIPT_DIR/std_build.sh" "patch" "$XZIP"

source "$SCRIPT_DIR/perl.sh" "$BZIP"

source "$SCRIPT_DIR/std_build.sh" "sed" "$BZIP"

source "$SCRIPT_DIR/std_compress_build.sh" "tar" "1"

source "$SCRIPT_DIR/std_build.sh" "texinfo" "$XZIP"

source "$SCRIPT_DIR/utillinux.sh"

source "$SCRIPT_DIR/std_compress_build.sh" "xz" "5"

echo "The toolchain is complete, continue to the base build"
## End script
