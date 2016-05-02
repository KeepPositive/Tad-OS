#! /bin/bash

# Welcome to the Tad OS extra build script! The extra tools built in this
# script are part of the Tad OS base, but are separated for the sake of
# SIMPLICITY.
START_DIR=$(pwd)
SCRIPT_DIR="$START_DIR/extra"
PACKAGE_DIR="$START_DIR/packs"
# Configure stuffs here
INSTALL=0
CORES=$(grep -c ^processor /proc/cpuinfo)

## Start script

echo "Building extra tools"
sleep 5
# build which
source "$SCRIPT_DIR/which.sh" "2.21"
# build openssl
source "$SCRIPT_DIR/openssl.sh" "1.0.2g"
# build pcre
source "$SCRIPT_DIR/pcre.sh" "8.38"
# build wget
source "$SCRIPT_DIR/wget.sh" "1.17.1"
# run certificate scripts here
# Not yet though!
# build curl
source "$SCRIPT_DIR/curl.sh" "7_48_0"
# build libffi
source "$SCRIPT_DIR/libffi.sh" "3.2.1"
# build python2
source "$SCRIPT_DIR/python2.sh" "2.7.11"
# build libxml2
source "$SCRIPT_DIR/libxml2.sh" "2.9.3"
# build asciidoc
source "$SCRIPT_DIR/asciidoc.sh" "8.6.9"
# build p7zip
source "$SCRIPT_DIR/p7zip.sh" "15.14.1"
# build git
source "$SCRIPT_DIR/git.sh" "2.8.0"
# build cmake
source "$SCRIPT_DIR/cmake.sh" "3.5.2"

## End script
