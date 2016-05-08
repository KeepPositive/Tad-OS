#! /bin/bash

#  Overwrite the current SHA256 files using local files as the hashes. Only
# works if you have all the files of the group installed locally. Mostly just
# for developement purposes.

START_DIR=$(pwd)
PACKAGE_DIR="$START_DIR/packs"
SHA_DIR="$START_DIR/sha256"

sha_maker () {

group=$1
group_dir="$PACKAGE_DIR/$group"

sha256sum "$group_dir/"* > "$SHA_DIR/$group.sha256"

#number_of_packs=$(find $group_dir -maxdepth 1 -type f | wc -l)
#lines_in_sha=$(cat "$SHA_DIR/$group.sha256" | wc -l)
#echo "$group: $number_of_packs $lines_in_wget"

}

sha_maker "base"
sha_maker "extra"
sha_maker "xorg"
