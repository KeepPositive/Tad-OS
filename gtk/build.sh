#! /bin/bash

## Start variables
SOURCE_DIR="./sources"
SCRIPT_DIR="./scripts"
INSTALL_SOURCES=0
CORES=$(grep -c ^processor /proc/cpuinfo)
## End variables

## Start script
# Stop if error occurs
set -o errexit

# Let's build some stuff!
# at-spi2-core
source "$SCRIPT_DIR/at_spi_core.sh"
# ATK
source "$SCRIPT_DIR/atk.sh"
# at-spi2-atk
source "$SCRIPT_DIR/at_spi_atk.sh"
# hicolor-icon-theme
source "$SCRIPT_DIR/hicolor_icons.sh"
# gtk+-2
source "$SCRIPT_DIR/gtk2.sh"
# gtk+-3
source "$SCRIPT_DIR/gtk3.sh"
# XML_Simple
source "$SCRIPT_DIR/xml_simple.sh"
# icon-naming-utils
source "$SCRIPT_DIR/icon_naming_utils.sh"
# gnome icons
source "$SCRIPT_DIR/gnome_icons.sh"
# gnome icons extra
source "$SCRIPT_DIR/gnome_icons_extra.sh"
## End script
