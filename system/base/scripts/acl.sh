#! /bin/bash

# Start variables
PACKAGE="acl"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
# End variables

tar xf "$PACKAGE_DIR/$FOLD_NAME.src.tar.gz"

pushd "$FOLD_NAME"

# Configure the source
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
            --disable-static \
            --libexecdir=/usr/lib
# Build using the configured sources
make -j "$CORES"
# Install the built package
	mv -v /usr/lib/libacl.so.* /lib
    ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
fi

popd

rm -rf "$FOLD_NAME"
