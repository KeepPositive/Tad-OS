#! /bin/bash

PACKAGE="coreutils"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"
# Apply a patch
patch -Np1 -i "$PACKAGE_DIR/coreutils-$VERSION-i18n-2.patch"
# Configure the source
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
# Build using the configured sources
FORCE_UNSAFE_CONFIGURE=1 make -j "$CORES"

# Install the built package
	mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
	mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
	mv -v /usr/bin/chroot /usr/sbin
	mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
	sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
	mv -v /usr/bin/{head,sleep,nice,test,[} /bin
fi

popd

rm -rf "$FOLD_NAME"
