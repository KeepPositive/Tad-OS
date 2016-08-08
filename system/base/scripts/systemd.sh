#! /bin/bash

## Start variables
NAME='systemd'
EXTENSION='.tar.xz'
PACKAGE_FILE=$(ls --ignore='*.patch' $SOURCE_DIR | grep -m 1 "$NAME-*")
FOLDER_NAME=$(echo "$PACKAGE_FILE" | sed -e "s/$EXTENSION//")
## End variables

## Start script
# Extract the package file
tar xvf "$SOURCE_DIR/$PACKAGE_FILE"
# Enter the source directory
pushd "$FOLDER_NAME"
# Prevent an error
sed -i "s:blkid/::" $(grep -rl "blkid/blkid.h")
# Prevent a security issue
sed -e 's@DRI and frame buffer@DRI@'                  \
    -e '/SUBSYSTEM==\"graphics\", KERNEL==\"fb\*\"/d' \
    -i  src/login/70-uaccess.rules
# Rebuild some edited files
autoreconf -fi
# Make a configure file
for $line in 'KILL=/bin/kill'                           \
             'MOUNT_PATH=/bin/mount'                    \
             'UMOUNT_PATH=/bin/umount'                  \
             'HAVE_BLKID=1'                             \
             'BLKID_LIBS="-lblkid"'                     \
             'BLKID_CFLAGS="-I/tools/include/blkid"'    \
             'HAVE_LIBMOUNT=1'                          \
             'MOUNT_LIBS="-lmount"'                     \
             'MOUNT_CFLAGS="-I/tools/include/libmount"' \
             'cc_cv_CFLAGS__flto=no'                    \
             'XSLTPROC="/usr/bin/xsltproc"'
do
  echo $line > config.cache
done
# Configure the source
./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var     \
            --config-cache           \
            --with-rootprefix=       \
            --with-rootlibdir=/lib   \
            --enable-split-usr       \
            --disable-firstboot      \
            --disable-ldconfig       \
            --disable-sysusers       \
            --without-python         \
            --with-default-dnssec=no \
            --docdir="/usr/share/doc/$FOLDER_NAME"
# Build using the configured sources
make -j "$CORES" LIBRARY_PATH=/tools/lib
# Install the built package, if set in main script
if [ "$INSTALL_SOURCES" -eq 1 ]
then
  make LD_LIBRARY_PATH=/tools/lib install
  mv -v /usr/lib/libnss_{myhostname,mymachines,resolve}.so.2 /lib
  # Remove dumb RPM package manager support
  rm -rfv /usr/lib/rpm
  # Allow systemd to work as the init system
  for tool in runlevel reboot shutdown poweroff halt telinit; do
      ln -sfv ../bin/systemctl /sbin/${tool}
  done
  ln -sfv ../lib/systemd/systemd /sbin/init
  # Make a file for systemd-journald
  systemd-machine-id-setup
fi
# Leave the source directory
popd
# Remove the built source code
rm -rf "$FOLDER_NAME"
## End script
