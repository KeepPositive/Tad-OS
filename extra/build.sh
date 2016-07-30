#! /bin/bash

# Welcome to the Tad OS extra build script! The extra tools built in this
# script are part of the Tad OS base, but are separated for the sake of
# SIMPLICITY. This script requires internet access.
SCRIPT_DIR="./scripts"
SOURCE_DIR="./sources"
# Configure stuffs here
INSTALL_SOURCES=0
CORES=$(grep -c ^processor /proc/cpuinfo)
# Does this machine have access to the internet?
INTERNET=1
URL="http://anduin.linuxfromscratch.org/BLFS/other/certdata.txt"
SSLDIR=/etc/ssl

## Start script
# End script if error occurs
set -o errexit

echo "Building extra tools"

# Build some nice packages!
# openssl
source "$SCRIPT_DIR/openssl.sh"
# pcre
source "$SCRIPT_DIR/pcre.sh"
# wget
source "$SCRIPT_DIR/wget.sh"
# run certificate scripts here
if [ "$INSTALL_SOURCES" -eq 1 ] && [ "$INTERNET" -eq 1 ]
then
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
  rm -vf certdata.txt
  rm -vr certs BLFS-ca-bundle*
fi
# curl
source "$SCRIPT_DIR/curl.sh"
# sqlite
source "$SCRIPT_DIR/sqlite.sh"
# libffi
source "$SCRIPT_DIR/libffi.sh"
# python2
source "$SCRIPT_DIR/python2.sh"
# python3
source "$SCRIPT_DIR/python3.sh"
# python-setuptools
source "$SCRIPT_DIR/py_setuptools.sh"
# libxml2
source "$SCRIPT_DIR/libxml2.sh"
# Ruby
source "$SCRIPT_DIR/ruby.sh"
# p7zip
source "$SCRIPT_DIR/p7zip.sh"
# git
source "$SCRIPT_DIR/git.sh"
# cmake
source "$SCRIPT_DIR/cmake.sh"
## End script
