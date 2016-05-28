#! /bin/bash

#  This script allows one to download and verify all of the packages necessary
# to build Tad OS from source code. It allows for the download of induviual
# 'groups' via arguments as well.

START_DIR=$(pwd)
WGET_DIR="$START_DIR/wget"
PACKAGE_DIR="$START_DIR/packs"
SETTING=$1

checksum_check ()
{
    echo "Checking"
}

get_group () {
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

get_xorg_group () {

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

print_help_message () {
    
    for help_string in                                           \
    "get_packages accepts the following arguments:"              \
    "\tall\t\tDownload all package groups"                       \
    "\tbase\t\tPackages need to build a base Tad OS system"      \
    "\tdesktop\t\tPackages for the Openbox desktop"              \
    "\textra\t\tExtra tools for building and programming"        \
    "\thelp\t\tPrint this help message"                          \
    "\txorg\t\tLibraries and tools necessary for GUIs"           \
    "\txorg-*\t\tSub-groups for xorg: proto, lib, app and font"
    do
        echo -e "$help_string"
    done
}

## Start script
# Create the PACKAGE_DIR directory if it does not exist
if [ ! -d "$PACKAGE_DIR" ]
then
    mkdir "$PACKAGE_DIR"
fi
# Check if wget is installed
which wget &> /dev/null

if [ $? -ne 0 ]
then
    echo "'wget' is not installed! Please install if you wish to continue."
    exit 1
fi

# Pass an argument to the script so it can be searched here.
case $SETTING in
"all")
    #for group in "desktop" "extra" "xorg"
    for group in $(find $WGET_DIR -type f -printf "%f\n")
    do
        group_name=${group%.*}
        #echo "$group_name"
        get_group $group_name
    done

    for group in "proto" "lib" "app" "font"
    do
        get_xorg_group $group
    done
;;

"xorg-"*)
    xorg_type=$(echo $SETTING | cut -c 6-)
    echo "Found $SETTING"
    get_xorg_group "$xorg_type"
;;

"help")
    print_help_message
;;

*) # Print a help  message if you enter an invalid argument
    
    WGET_PATH="$WGET_DIR/$SETTING.wget"
    
    if [ -f "$WGET_PATH" ]
    then
        get_group "$SETTING"
    else
        echo -e "File $WGET_PATH does not exist!\n"
        print_help_message
    fi
;;
esac

## End script
