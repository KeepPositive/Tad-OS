#! /bin/bash

## Start variables
CORES=$(grep -c ^processor /proc/cpuinfo)
INIT_DIR=$(pwd)
GROUP_NAME=""
PACKAGE_DIR="$INIT_DIR/$GROUP_NAME"
SCRIPT_DIR="$INIT_DIR/build_scripts/$GROUP_NAME"
## End variables

## Start script
# Stop if error occurs
set -o errexit

# Let's build some stuff!
source "$SCRIPT_DIR/" ""

## End script
