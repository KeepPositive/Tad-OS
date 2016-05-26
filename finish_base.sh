rm -f /usr/lib/lib{bfd,opcodes}.a
rm -f /usr/lib/libbz2.a
rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
rm -f /usr/lib/libltdl.a
rm -f /usr/lib/libfl.a
rm -f /usr/lib/libfl_pic.a
rm -f /usr/lib/libz.a

printf "0.0 0 0.0\n0\nLOCAL" >> "/etc/adjtime"

printf "LANG=en_US.UTF-8" >> "/etc/locale.conf"

cp "/system_files/inputrc" "/etc/inputrc"

printf "# Begin /etc/shells\n/bin/sh\n/bin/bash\n# End /etc/shells"
# Disable clearing the screen after boot
#mkdir -pv "/etc/systemd/system/getty@tty1.service.d"
#printf "[Service]\nTTYVTDisallocate=no" \
#>> "/etc/systemd/system/getty@tty1.service.d/noclear.conf"

printf "\n# DEVICE\t\t\tMOUNT\tTYPE\tOPTIONS\t\tDUMP\tORDER\n" \
       >> /etc/fstab

lsblk --output=NAME,LABEL,UUID,PARTUUID
