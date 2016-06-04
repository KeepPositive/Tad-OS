#! /bin/bash

## Start variables

START_DIR=$(pwd)
PACKAGE_DIR="$START_DIR/gtk"
SCRIPT_DIR="$START_DIR/build_scripts/gtk"

## End variables

## Start script
# Stop if error occurs
set -o errexit

# Let's build some stuff!
# at-spi2-core
source "$SCRIPT_DIR/at_spi_core.sh" "2.20.1"
# ATK
source "$SCRIPT_DIR/atk.sh" "2.20.0"
# at-spi2-atk
source "$SCRIPT_DIR/at_spi_atk.sh" "2.20.1"
# hicolor-icon-theme
source "$SCRIPT_DIR/hicolor_icons.sh" "0.15"
# gtk+-2
source "$SCRIPT_DIR/gtk2.sh" "2.24.30"
# gtk+-3
source "$SCRIPT_DIR/gtk3.sh" "3.20.4"
# XML_Simple
source "$SCRIPT_DIR/xml_simple.sh" "2.22"
# icon-naming-utils
source "$SCRIPT_DIR/icon_naming_utils.sh" "0.8.90"
# gnome icons
source "$SCRIPT_DIR/gnome_icons.sh" "3.12.0"
# gnome icons extra
source "$SCRIPT_DIR/gnome_icons_extra.sh" "3.12.0"
## End script
