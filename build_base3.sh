#! /bin/bash

## Start variables
START_DIR=$(pwd)
PACKAGE_DIR="/source"
SCRIPT_DIR="/base"
CONFIGURE_FILE="$START_DIR/build.cfg"
for name in "LFS" "TIMEZONE"
do
    # The 'eval' command evaluates a string into runable bash
    eval "export $name=$(grep $name "$CONFIGURE_FILE" | awk '{print $2}')"

    if [ "$?" -ne 0 ]
    then
        echo "$name could not be created! Error!"
        exit 1
    fi
done

# Set common package compression extensions
GZIP=".tar.gz"
BZIP=".tar.bz2"
XZIP=".tar.xz"
## End variables

## Start script

# Exit on errors
set -o errexit

# Continue building packages!
# bc
#source "$SCRIPT_DIR/bc.sh" "1.06.95"
# Libtool
#source "$SCRIPT_DIR/std_build.sh" "libtool" "2.4.6" "$XZIP"
# GDBM
#source "$SCRIPT_DIR/gdbm.sh" "1.11"
# Gperf
#source "$SCRIPT_DIR/gperf.sh" "3.0.4"
# Expat
#source "$SCRIPT_DIR/expat.sh" "2.1.1"
# Inetutils
#source "$SCRIPT_DIR/inetutils.sh" "1.9.4"
# Perl
#source "$SCRIPT_DIR/perl.sh" "5.22.1"
# XML-Parser
#source "$SCRIPT_DIR/xml_parser.sh" "2.44"
# Intltool
#source "$SCRIPT_DIR/intltool.sh" "0.51.0"
# autoconf
#source "$SCRIPT_DIR/std_build.sh" "autoconf" "2.69" "$XZIP"
# automake
#source "$SCRIPT_DIR/automake.sh" "1.15"
# xz
#source "$SCRIPT_DIR/xz.sh" "5.2.2"
# kmod
#source "$SCRIPT_DIR/kmod.sh" "22"
# gettext
source "$SCRIPT_DIR/gettext.sh" "0.19.7"
# systemd
source "$SCRIPT_DIR/systemd.sh" "229"
# Procps-ng
source "$SCRIPT_DIR/procps_ng.sh" "3.3.11"
# e2fs
source "$SCRIPT_DIR/e2fs.sh" "1.42.13"
# Coreutils
source "$SCRIPT_DIR/coreutils.sh" "8.25"
# Diffutils
source "$SCRIPT_DIR/diffutils.sh" "3.3"
# Gawk
source "$SCRIPT_DIR/gawk.sh" "4.1.3"
# Findutils
source "$SCRIPT_DIR/findutils.sh" "4.6.0"
# Groff
source "$SCRIPT_DIR/groff.sh" "1.22.3"
# GRUB
source "$SCRIPT_DIR/grub.sh" "2.02~beta2"
# Less
source "$SCRIPT_DIR/less.sh" "481"
# Gzip
source "$SCRIPT_DIR/gzip.sh" "1.8"
# IPRoute
source "$SCRIPT_DIR/iproute.sh" "4.5.0"
# kdb
source "$SCRIPT_DIR/ksb.sh" "2.0.3"
# libpipeline
source "$SCRIPT_DIR/libpipeline.sh" "1.4.1"
# Make (HA!)
source "$SCRIPT_DIR/std_build.sh" "make" "4.1" "$BZIP"
# patch
source "$SCRIPT_DIR/std_build.sh" "patch" "2.7.5" "$XZIP"
# d-bus
source "$SCRIPT_DIR/dbus.sh" "1.10.6"
# util-linux
source "$SCRIPT_DIR/util_linux.sh" "2.28"
# man-DB
source "$SCRIPT_DIR/man_db.sh" "2.7.5"
# tar
source "$SCRIPT_DIR/tar.sh" "1.28"
# texinfo
source "$SCRIPT_DIR/texinfo.sh" "6.1"
# Update texinfo documents
pushd /usr/share/info

rm -v dir

for f in *
    do install-info $f dir 2>/dev/null
done

popd
# Log out of the toolchain environment
logout
