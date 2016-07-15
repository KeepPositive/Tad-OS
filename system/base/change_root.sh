RUN_MODE=$1
LFS=$2
BASH_BIN_PATH=$3

unmount () {
    
    umount -v "$LFS/run"
    umount -v "$LFS/sys"
    umount -v "$LFS/proc"
    umount -v "$LFS/dev/pts"
    umount -v "$LFS/dev"
    
    echo "Unmounted all virtual mounts"
}

mount_system () {
    mount -v --bind /dev "$LFS/dev"
    mount -vt devpts devpts "$LFS/dev/pts" -o gid=5,mode=620
    mount -vt proc proc "$LFS/proc"
    mount -vt sysfs sysfs "$LFS/sys"
    mount -vt tmpfs tmpfs "$LFS/run"

    chroot "$LFS" /usr/bin/env -i             \
        HOME=/root                          \
        TERM="linux"                        \
        PS1='\u:\w\$ '                      \
        PATH=/bin:/usr/bin:/sbin:/usr/sbin  \
        "$BASH_BIN_PATH" --login
}

case "$RUN_MODE" in

"chroot")
    mount_system 
;;

"umount")
    unmount
;;

*)
    echo "Invalid option!"
esac
