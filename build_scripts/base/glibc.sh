#! /bin/bash

PACKAGE="glibc"
VERSION=$1
FOLD_NAME="$PACKAGE-$VERSION"
BUILD_DIR="$FOLD_NAME/build"
# Timezone related variables
ZONEINFO=/usr/share/zoneinfo
TZ=$(tzselect)


if [ -z "$CORES" ]; then
	CORES='4'
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

patch -Np1 -i "$PACKAGE_DIR/glibc-2.23-fhs-1.patch"
patch -Np1 -i "$PACKAGE_DIR/glibc-2.23-upstream_fixes-1.patch"

popd

mkdir "$BUILD_DIR"

pushd "$BUILD_DIR"

# Configure the source
../configure --prefix=/usr          \
             --enable-kernel=2.6.32 \
             --enable-obsolete-rpc

# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    # Prevent an error from occuring by making this file
    touch /etc/ld.so.conf

    make install
    # According to PiLFS, this symbolic link is needed
    case $SYSTEM in

    "rpi")
        ln -sfv ld-2.23.so "$LFS/tools/lib/ld-linux.so.3"
    ;;

    esac
    # Make some configuration stuff
    cp -v ../nscd/nscd.conf /etc/nscd.conf
    mkdir -pv /var/cache/nscd
    # Install these files for systemd
    install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf
    install -v -Dm644 ../nscd/nscd.service /lib/systemd/system/nscd.service
    # Make some locales for later
    mkdir -pv /usr/lib/locale
    localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
    localedef -i de_DE -f ISO-8859-1 de_DE
    localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
    localedef -i de_DE -f UTF-8 de_DE.UTF-8
    localedef -i en_GB -f UTF-8 en_GB.UTF-8
    localedef -i en_HK -f ISO-8859-1 en_HK
    localedef -i en_PH -f ISO-8859-1 en_PH
    localedef -i en_US -f ISO-8859-1 en_US
    localedef -i en_US -f UTF-8 en_US.UTF-8
    localedef -i es_MX -f ISO-8859-1 es_MX
    localedef -i fa_IR -f UTF-8 fa_IR
    localedef -i fr_FR -f ISO-8859-1 fr_FR
    localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
    localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
    localedef -i it_IT -f ISO-8859-1 it_IT
    localedef -i it_IT -f UTF-8 it_IT.UTF-8
    localedef -i ja_JP -f EUC-JP ja_JP
    localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
    localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
    localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
    localedef -i zh_CN -f GB18030 zh_CN.GB18030
    # Make another file to prevent Glibc networking issues
    cat > /etc/nsswitch.conf << "EOF"
    # Begin /etc/nsswitch.conf

    passwd: files
    group: files
    shadow: files

    hosts: files dns myhostname
    networks: files

    protocols: files
    services: files
    ethers: files
    rpc: files

    # End /etc/nsswitch.conf
EOF
# ^ Sorry about this. It doesn't notice an indented EOF
# Install some timezone related things
    tar -xf ../../tzdata2016d.tar.gz

    mkdir -pv $ZONEINFO/{posix,right}

    for tz in etcetera southamerica northamerica europe africa antarctica  \
              asia australasia backward pacificnew systemv; do
        zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
        zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
        zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
    done

    cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
    zic -d $ZONEINFO -p America/New_York
    unset ZONEINFO 

popd

rm -rf "$FOLD_NAME"
