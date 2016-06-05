#! /bin/bash

## Start variables
PACKAGE="firefox"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]
then
	CORES=4
fi
## End variables

## Start script
tar xf "$PACKAGE_DIR/$FOLD_NAME.source.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
# Copy the premade config file
echo "$SCRIPT_DIR/firefox.conf"
cp "$SCRIPT_DIR/firefox.conf" mozconfig
# Force compatability with GCC 6.1
sed -e '/#include/i\
    print OUT "#define _GLIBCXX_INCLUDE_NEXT_C_HEADERS\\n"\;' \
    -i nsprpub/config/make-system-wrappers.pl
sed -e '/#include/a\
    print OUT "#undef _GLIBCXX_INCLUDE_NEXT_C_HEADERS\\n"\;' \
    -i nsprpub/config/make-system-wrappers.pl
# Build using the configured sources
CXX='g++ -std=c++11' make -f client.mk
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]
then
    make -f client.mk install INSTALL_SDK=
    chown -R 0:0 "/usr/lib/firefox-$VERSION"
    mkdir -pv /usr/lib/mozilla/plugins
    ln -sfv ../../mozilla/plugins "/usr/lib/firefox-$VERSION/browser"
fi

popd

rm -rf "$FOLD_NAME"
## End script
