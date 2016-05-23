#! /bin/bash

PACKAGE="systemd"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"

if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Prevent an error
sed -i "s:blkid/::" $(grep -rl "blkid/blkid.h")
# Apply a patch
patch -Np1 -i "../systemd-$VERSION-compat-1.patch"
# Rebuild some edited files
autoreconf -fi
# Make a file
cat > config.cache << "EOF"
KILL=/bin/kill
MOUNT_PATH=/bin/mount
UMOUNT_PATH=/bin/umount
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include/blkid"
HAVE_LIBMOUNT=1
MOUNT_LIBS="-lmount"
MOUNT_CFLAGS="-I/tools/include/libmount"
cc_cv_CFLAGS__flto=no
XSLTPROC="/usr/bin/xsltproc"
EOF
# Configure the source
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --localstatedir=/var   \
            --config-cache         \
            --with-rootprefix=     \
            --with-rootlibdir=/lib \
            --enable-split-usr     \
            --disable-firstboot    \
            --disable-ldconfig     \
            --disable-sysusers     \
            --without-python       \
            --docdir=/usr/share/doc/systemd-$VERSION
# Build using the configured sources
make -j "$CORES" LIBRARY_PATH=/tools/lib
# Install the built package
if [ "$INSTALL_SOURCES" -eq 1 ]; then
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

popd

rm -rf "$FOLD_NAME"
