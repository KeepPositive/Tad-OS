#! /bin/bash

#  Overwrite the current SHA256 files using local files as the hashes. Only
# works if you have all the files of the group installed locally. Mostly just
# for developement purposes.

START_DIR=$(pwd)
PACKAGE_DIR="$START_DIR/packs"
SHA_DIR="$START_DIR/sha256"
SETTING=$1

sha_maker () {

group=$1
group_dir="$PACKAGE_DIR/$group"

sha256sum "$group_dir/"* >> "$SHA_DIR/$group.sha256" 2> /dev/null

# Remove path from file name (Thanks to Greg from sysnet-adventures)
sed -i -r "s/ .*\/(.+)/  \1/g" $SHA_DIR/$group.sha256  

if [ $? -eq 0 ]
then
    echo "Updated $group"
else
    echo "Update of $group failed"
    exit 1
fi

}

## Start script

# Read the first argument
case $SETTING in

    "base")
        sha_maker "base"
    ;;

    "extra")
        sha_maker "extra"
    ;;

    "xorg")
        sha_maker "xorg"
    ;;

    "all")
        for name in "base" "extra" "xorg"
        do
            sha_maker $name
        done
    ;;

    *)
        echo "Please enter one of the following options:"
        echo "'all'"
        echo "base"
        echo "extra"
        echo "xorg"
    ;;

esac

## End script
