#! /bin/bash

# Welcome to the Tad OS extra build script! The extra tools built in this
# script are part of the Tad OS base, but are separated for the sake of
# SIMPLICITY. This script requires internet access.
START_DIR=$(pwd)
SCRIPT_DIR="$START_DIR/build_scripts/extra"
PACKAGE_DIR="$START_DIR/packs/extra"
# Configure stuffs here
INSTALL=0
CORES=$(grep -c ^processor /proc/cpuinfo)
INTERNET=1
URL="http://anduin.linuxfromscratch.org/BLFS/other/certdata.txt"
SSLDIR=/etc/ssl

## Start script
# End script if error occurs
set -o errexit

echo "Building extra tools"

# Build some nice packages!
# openssl
source "$SCRIPT_DIR/openssl.sh" "1.0.2h"
# pcre
source "$SCRIPT_DIR/pcre.sh" "8.38"
# wget
source "$SCRIPT_DIR/wget.sh" "1.17.1"
# run certificate scripts here
if [ "$INSTALL" -eq 1 ] && [ "$INTERNET" -eq 1 ]
then
    echo "Creating web certificates!"
    cp ./certificates/* /usr/bin
    rm -vf certdata.txt
    wget "$URL"
    make-ca.sh
    remove-expired-certs.sh certs
    install -d "$SSLDIR/certs"
    cp -v certs/*.pem "$SSLDIR/certs"
    c_rehash
    install BLFS-ca-bundle*.crt ${SSLDIR}/ca-bundle.crt
    ln -sfv ../ca-bundle.crt ${SSLDIR}/certs/ca-certificates.crt
    rm -r certs BLFS-ca-bundle*
fi
# curl
source "$SCRIPT_DIR/curl.sh" "7_48_0"
# sqlite
source "$SCRIPT_DIR/sqlite.sh" "3130000"
# libffi
source "$SCRIPT_DIR/libffi.sh" "3.2.1"
# python2
source "$SCRIPT_DIR/python2.sh" "2.7.11"
# python3
source "$SCRIPT_DIR/python3.sh" "3.5.1"
# python-setuptools
source "$SCRIPT_DIR/py_setuptools.sh" "17.1.1"
# libxml2
source "$SCRIPT_DIR/libxml2.sh" "2.9.3"
# Ruby
source "$SCRIPT_DIR/ruby.sh" "2.3.1"
# p7zip
source "$SCRIPT_DIR/p7zip.sh" "15.14.1"
# git
source "$SCRIPT_DIR/git.sh" "2.8.0"
# cmake
source "$SCRIPT_DIR/cmake.sh" "3.5.2"

## End script
