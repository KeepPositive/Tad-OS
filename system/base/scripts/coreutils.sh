#! /bin/bash

## Start variables
NAME='coreutils'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Apply a patch
patch -Np1 -i "$SOURCE_DIR/$FOLDER_NAME-i18n-2.patch"
# Configure the source
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
# Build using the configured sources
FORCE_UNSAFE_CONFIGURE=1 make -j "$CORES"
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make install
  mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
	mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
	mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
	mv -v /usr/bin/chroot /usr/sbin
	mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
	sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
	mv -v /usr/bin/{head,sleep,nice,test,[} /bin
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
