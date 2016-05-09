#! /bin/bash

#  This script allows one to download and verify all of the packages necessary
# to build Tad OS from source code. It allows for the download of induviual
# 'groups' via arguments as well.

START_DIR=$(pwd)
WGET_DIR="$START_DIR/wget"
PACKAGE_DIR="$START_DIR/packs"
SETTING=$1

get_group() {
    # The xorg group which will be downloaded
    download_type=$1
    sha_file="$START_DIR/sha256/$download_type.sha256"

    echo "Downloading $download_type"

    # If directory does not exist for group, create it
    if [ ! -d "$PACKAGE_DIR/$download_type" ]
    then
        mkdir "$PACKAGE_DIR/$download_type"
    fi
    # Enter the directory where the packages should be kept
    pushd "$PACKAGE_DIR/$download_type" > /dev/null
    # Get the packages via a wget file
    wget --quiet --show-progress --continue --no-clobber   \
         --directory-prefix="$PACKAGE_DIR/$download_type"  \
         --input-file="$WGET_DIR/${download_type}.wget"

    # Verify that the packages are O.K.
    sha256sum --quiet -c "$sha_file" # Exit the package directory, back to the PACKAGE_DIR

    if [ "$?" -eq 0 ]
    then
        echo "SHA256 check passed for $download_type"
    else
        echo "Error with SHA256 checksum test."
    fi

    popd > /dev/null
}

get_xorg_group() {

    download_type=$1
    # X.Org groups are installed inside a folder with the 'xorg' folder
    group_dir="$START_DIR/packs/xorg/$download_type"
    sha_file="$START_DIR/sha256/xorg-$download_type.sha256"

    echo "Downloading xorg-$download_type"

    if [ ! -d "$group_dir" ]
    then
        mkdir "$group_dir"
    fi

    pushd "$group_dir" > /dev/null
    # This mess of a function below actually has three parts:

    #  'grep', when given then '^#' argument reads each line in the file it is
    # given, which is then piped to awk using the '|' character. awk's job is
    # to split the line into parts at each space. When the second 'word' is
    # found, it can be extracted and piped to wget.
    grep -v '^#' "$sha_file" | awk '{print $2}' | \
    #  Finally, 'wget' downloads all the packages in the group. Since all of
    # these packages in the group basically have the same prefix URL, they can
    # be downloaded using only there names in the respective SHA256 file.
        wget --quiet --show-progress --continue --no-clobber  \
             --directory-prefix="$group_dir"                  \
             --input-file=- -B "http://ftp.x.org/pub/individual/$download_type/"

    sha256sum --quiet -c "$sha_file"

    if [ "$?" -eq 0 ]
    then
        echo "SHA256 check passed for $download_type"
    else
        echo "Error with SHA256 checksum test."
    fi

    popd > /dev/null
}

## Start script

if [ ! -d "$PACKAGE_DIR" ]; then
    mkdir "$PACKAGE_DIR"
fi

# Pass an argument to the script so it can be searched here.
case $SETTING in

    "base")
        get_group "base"
    ;;
    "extra")
        get_group "extra"
    ;;

    "xorg")
        get_group "xorg"
    ;;

    "xorg-proto")
        get_xorg_group "proto"
    ;;

    "xorg-lib")
        get_xorg_group "lib"
    ;;

    "xorg-app")
        get_xorg_group "app"
    ;;

    "xorg-font")
        get_xorg_group "font"
    ;;

    "all")
        for group in "extra" "xorg"
        do
            get_group $group
        done

        for group in "proto" "lib" "app" "font"
        do
            get_xorg_group $group
        done
    ;;

    *) # Print a help  message if you enter an invalid argument
    echo "You should enter one of the following:"
    printf "\t'all': download all package groups\n"
    printf "\t'base': the packages need to build a base Tad OS system (Use for toolchain too)\n"
    printf "\t'extra': extra tools for building, like CMake and Git\n"
    printf "\t'xorg': libraries and tools necessary for GUIs\n"
    printf "\t'xorg-*': sub-groups for xorg: 'proto', 'lib', 'app' and 'font'\n"
    ;;

esac

## End script
