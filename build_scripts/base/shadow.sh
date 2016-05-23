#! /bin/bash

PACKAGE="shadow"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
       -e 's@/var/spool/mail@/var/mail@' etc/login.defs
sed -i 's/1000/999/' etc/useradd
./configure --sysconfdir=/etc --with-group-name-max-length=32
# Build using the configured sources
make -j "$CORES"
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
    make install
    mv -v /usr/bin/passwd /bin
    # Enable shadowed passwords
    pwconv
    grpconv
    sed -i 's/yes/no/' /etc/default/useradd
fi

popd

rm -rf "$FOLD_NAME"
