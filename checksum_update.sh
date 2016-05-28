#! /bin/bash

#  Overwrite the current SHA256 files using local files as the hashes. Only
# works if you have all the files of the group installed locally. Mostly for 
# developement purposes.

## Start variables

START_DIR=$(pwd)
PACKAGE_DIR="$START_DIR/packs"
SHA_DIR="$START_DIR/sha256"
SETTING=$1

## End variables

## Start functions
sha_maker () {

    group=$1
    group_dir="$PACKAGE_DIR/$group"
    sha_file="$SHA_DIR/$group.sha256"
    old_sha_file="$sha_file.old"

    if [ -f "$old_sha_file" ]
    then
        #echo "Found $old_sha_file. Removing it"
        rm -f "$old_sha_file"
    fi

    if [ -f "$sha_file" ]
    then
        #echo "Moving $sha_file to $old_sha_file"
        mv "$sha_file" "$old_sha_file"
    fi

    sha256sum "$group_dir/"* >> "$sha_file" 2> /dev/null

    # Remove path from file name (Thanks to Greg from sysnet-adventures)
    sed -i -r "s/ .*\/(.+)/  \1/g" "$sha_file" 

    if [ $? -eq 0 ]
    then
        echo "Updated $group successfully"
    else
        echo "Update of $group failed"
        exit 1
    fi

}

print_usage_message () {

    echo "Please enter a valid group"

}

## End functions

## Start script
case $SETTING in
"audio")
    sha_maker "audio"
;;

"base")
    sha_maker "base"
;;

"desktop")
    sha_maker "desktop"
;;

"extra")
    sha_maker "extra"
;;

"gtk")
    sha_maker "gtk"
;;
"xorg")
    sha_maker "xorg"
;;

"all")
    for name in "base" "desktop" "extra" "xorg"
    do
        sha_maker $name
    done
;;

*)
    print_usage_message
;;
esac

## End script
