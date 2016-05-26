ROOT_DIR=$1
BASH_BIN_PATH=$2
BASH_HASH_PATH=$3

chroot "$ROOT_DIR" /usr/bin/env -i      \
    HOME=/root                          \
    TERM="linux"                        \
    PS1='\u:\w\$ '                      \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin  \
    "$BASH_BIN_PATH" --login
