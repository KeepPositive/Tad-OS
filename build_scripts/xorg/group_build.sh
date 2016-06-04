#! /bin/bash

BUILD_TYPE=$1
BUILD_DIR="$START_DIR/$BUILD_TYPE"

if [ -z "$CORES" ]
then
    CORES=4
fi

as_root() {
  # Run things as the root user if necessary.
    if   [ $EUID = 0 ]
    then 
        $*
    elif [ -x /usr/bin/sudo ]
    then 
        sudo $*
    else
        su -c \\"$*\\"
    fi
}

mkdir -p "$BUILD_DIR"
pushd "$BUILD_DIR"

# For each package in the group, run the commands in the do loop.
for package in $(grep -v '^#' "$START_DIR/sha256/xorg-$BUILD_TYPE.sha256" \
                         | awk '{print $2}')
do
    fold_name=${package%.tar.bz2}
    tar xvf "$START_DIR/packs/xorg/$BUILD_TYPE/$package"
    pushd "$fold_name"
    # For a few X.Org apps, some changes must be made
    case "$foldname" in
    luit-* )
        line1="#ifdef _XOPEN_SOURCE"
        line2="#  undef _XOPEN_SOURCE"
        line3="#  define _XOPEN_SOURCE 600"
        line4="#endif"

        sed -i -e "s@#ifdef HAVE_CONFIG_H@$line1\n$line2\n$line3\n$line4\n\n&@" sys.c
        unset line1 line2 line3 line4
    ;;
    sessreg-* )
        sed -e 's/\$(CPP) \$(DEFS)/$(CPP) -P $(DEFS)/' -i man/Makefile.in
    ;;
    esac
    ./configure $XORG_CONFIG
    #  Use the as_root function above so passwords do not have to be entered 
    # every time
    as_root make install
    popd
    rm -rf "$fold_name"
done
popd
rm -rf "$BUILD_DIR"
