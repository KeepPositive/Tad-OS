#! /bin/bash

#  This script allows one to download and verify all of the packages necessary
# to build Tad OS from source code. It allows for the download of induviual
# 'groups' via arguments as well.

## Start functions

get_git_package ()
{
  group=$1

  for url in $(cat "./$group/git-list")
  do
    basename=${url##*/}
    package=$(echo $basename | sed -e 's/.git//')
    output_dir="./$group/sources/$package"
    if [ -d "$output_dir" ]
    then
      pushd "$output_dir" > /dev/null
      git pull
      popd > /dev/null
    else
      git clone "$url" "$output_dir" --quiet --progress
    fi
  done
}

get_induvidual_group ()
{
  group=$1
  wget_list="./$group/wget-list"
  source_directory="./$group/sources"

  if [ -f "$wget_list" ]
  then
    echo "Getting $group packages"
    # Have wget read the wget-list file and output to '$group/sources'
    wget --quiet --show-progress --continue --no-clobber   \
         --directory-prefix="$source_directory"            \
         --input-file="$wget_list"
    # If any files must be found via Git
    if [ -f "./$group/git-list" ]
    then
      get_git_package "$group"
    fi
    # Enter the source directory
    pushd "$source_directory" > /dev/null
    # Verify the source files using the sha256sums file
    sha256sum --quiet -c "../sha256sums"
    if [ "$?" -eq 0 ]
    then
      echo "SHA256 check passed for $group"
    else
      echo "Error with SHA256 checksum test"
    fi
    # Leave the source directory
    popd > /dev/null
    echo "Packages for $group retrieved successfully"
  else
    echo "Invalid package entered"
  fi
}

get_xorg_group ()
{
  group="$1"
  source_directory="./xorg/$group/sources"
  sha_file="./xorg/$group/sha256sums"

  if [ -f "$sha_file" ]
  then
    echo "Getting xorg-$group packages"
    #  'grep', when given then '^#' argument reads each line in the
    # file it is given, which is then piped to awk using the '|'
    # character. awk's job is to split the line into parts at each
    # space. When the second 'part', in this case, the package name,
    # is found, it can be extracted and piped to wget.
    grep -v '^#' "$sha_file" | awk '{print $2}' | \
    #  Finally, 'wget' downloads all the packages in the group. Since
    # all of these packages in the group basically have the same
    # prefix URL, they can be downloaded using only there names in the
    # respective SHA256 file.
    wget --quiet --show-progress --continue --no-clobber  \
         --directory-prefix="$source_directory"           \
         --input-file=- -B "http://ftp.x.org/pub/individual/$download_type/"

    pushd "$source_directory" > /dev/null
    sha256sum --quiet -c "../sha256sums"
    if [ "$?" -eq 0 ]
    then
      echo "SHA256 check passed for $group"
    else
      echo "Error with SHA256 checksum test"
    fi
    popd > /dev/null
    echo "Packages for $group retrieved successfully"
  else
    echo "Invalid package entered"
  fi
}

get_all_groups ()
{
  for directory in $(find * -maxdepth 0 -type d)
  do
    if [ -f "./$directory/wget-list" ]
    then
      get_induvidual_group "$directory"
    fi
  done
  for xorg_group in "app" "font" "lib" "proto"
  do
    get_xorg_group "$xorg_group"
  done
}

print_help_message ()
{
  for help_string in                                        \
  "USAGE: bash get_packages [ARGUMENT]\n"                   \
  "ARGUMENTS:"                                              \
  "  all\t\tDownload all package groups"                    \
  "  base\t\tPackages need to build a base Tad OS system"   \
  "  desktop\tPackages for the Openbox desktop"             \
  "  extra\t\tExtra tools for building and/or programming"  \
  "  help\t\tPrint this help message"                       \
  "  xorg\t\tLibraries and tools necessary for a GUI"       \
  "  xorg-*\tSub-groups for xorg: proto, lib, app and font"
  do
      echo -e "$help_string"
  done
}
## End functions

## Start script
# Note: $1 is the first argument
case $1 in
"help")
  print_help_message
;;
"all")
  get_all_groups
;;
"xorg-"*)
  xorg_type=$(echo $1 | cut -c 6-)
  get_xorg_group "$xorg_type"
;;
*)
  get_induvidual_group $1
;;
esac
## End script
