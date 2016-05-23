#! /bin/bash

PACKAGE="bash"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.gz"

pushd "$FOLD_NAME"

# Apply a patch
patch -Np1 -i "$PACKAGE_DIR/bash-4.3.30-upstream_fixes-3.patch"
# Configure the source
./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/bash-4.3.30 \
            --without-bash-malloc               \
            --with-installed-readline
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make install
    mv -vf /usr/bin/bash /bin
fi

popd

rm -rf "$FOLD_NAME"
