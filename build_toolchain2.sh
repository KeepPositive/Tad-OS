#! /bin/bash

## Start script
# Make two nice bash-related files
printf "exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash" > \
    ~/.bash_profile

printf "set +h\numask 022\n"    \
       "LFS=$LFS\n"             \
       "LC_ALL=$LC_ALL\n"       \
       "LFS_TGT=$LFS_TGT\n"     \
       "PATH=$PATH\n"           \
       "export LFS LC_ALL LFS_TGT PATH\n"

source ~/.bash_profile


## End script
