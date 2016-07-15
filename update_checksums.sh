#! /bin/bash

#  Overwrite the current SHA256 files using local files as the hashes. Only
# works if you have all the files of the group installed locally. Mostly for
# developement purposes.

## Start variables

## End variables

## Start functions
sha_maker ()
{
  group=$1
  source_directory="./$group/sources"
  sha_file="./$group/sha256sums"
  old_sha_file="./$group/sha256sums.old"

  if [ -f "$sha_file" ]
  then
    if [ -f "$old_sha_file" ]
    then
      rm -f "$old_sha_file"
    fi

    mv "$sha_file" "$old_sha_file"
  fi

  sha256sum "./$group/sources/"* >> "$sha_file" 2> /dev/null

  # Remove path from file name (Thanks to Greg from sysnet-adventures)
  sed -i -r "s/ .*\/(.+)/  \1/g" "$sha_file"

  if [ $? -eq 0 ]
  then
      echo "Successfully updated $group checksums"
  else
      echo "Update of $group checksums failed"
  fi

}

print_help_message () {
  echo "Here to help"
}
## End functions

## Start script
case $1 in
"all")
  for group in $(find * -maxdepth 0 -type d)
  do
    if [ -d "./$group/sources" ]
    then
      sha_maker "$group"
    fi
  done
;;
"help")
  print_help_message
;;
*)
  if [ -d "./$1/sources" ]
  then
    sha_maker "$1"
  else
      echo "Please enter a valid group"
      print_help_message
  fi
;;
esac
## End script
