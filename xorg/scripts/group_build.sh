#! /bin/bash

BUILD_TYPE=$1
BUILD_DIR="./$BUILD_TYPE-build"

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
for package in $(grep -v '^#' "../$BUILD_TYPE/sha256sums" | awk '{print $2}')
do
    folder_name=${package%.tar.bz2}

    tar xvf "../$BUILD_TYPE/sources/$package"

    pushd "$folder_name"

    # For a few X.Org apps, some changes must be made
    case $folder_name in
    luit-[0-9]* )
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
    # Configure the package
    ./configure $XORG_CONFIG
    #  Use the as_root function above so passwords do not have to be entered
    # every time
    as_root make install
    # Leave the source directory
    popd
    # Remove the sources
    rm -rf "$folder_name"
done
# Exit the build directory
popd
# Remove the build directory
rm -rf "$BUILD_DIR"
