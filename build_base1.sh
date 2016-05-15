#! /bin/bash

## Start variables
START_DIR=$(pwd)
CONFIGURE_FILE="$START_DIR/build.cfg"
for name in "LFS" "TIMEZONE"
do
    # The 'eval' command evaluates a string into runable bash
    eval "export $name=$(grep $name "$CONFIGURE_FILE" | awk '{print $2}')"

    if [ "$?" -ne 0 ]
    then
        echo "$name could not be created! Error!"
        exit 1
    fi
done
## End variables

## Start script

# Exit on errors
set -o errexit

# Make a whole bunch of standard directories
mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp
mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv  /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv  /usr/libexec
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{log,mail,spool}
mkdir -pv /var/{opt,cache,lib/{color,misc,locate,hwclock},local}

# Link a bunch of directories
case $(uname -m) in
x86_64) ln -sfv lib /lib64
        ln -sfv lib /usr/lib64
        ln -sfv lib /usr/local/lib64
;;
esac

# Link some more
ln -sfv /run /var/run
ln -sfv /run/lock /var/lock
ln -sfv /tools/bin/{bash,cat,echo,pwd,stty} /bin
ln -sfv /tools/bin/perl /usr/bin
ln -sfv /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -sfv /tools/lib/libstdc++.so{,.6} /usr/lib
sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la
ln -sfv bash /bin/sh
ln -sfv /proc/self/mounts /etc/mtab

# Create a password file
cat > $LFS/etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
systemd-bus-proxy:x:72:72:systemd Bus Proxy:/:/bin/false
systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/bin/false
systemd-journal-remote:x:74:74:systemd Journal Remote:/:/bin/false
systemd-journal-upload:x:75:75:systemd Journal Upload:/:/bin/false
systemd-network:x:76:76:systemd Network Management:/:/bin/false
systemd-resolve:x:77:77:systemd Resolver:/:/bin/false
systemd-timesync:x:78:78:systemd Time Synchronization:/:/bin/false
systemd-coredump:x:79:79:systemd Core Dumper:/:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

# Create the group file
cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
systemd-bus-proxy:x:72:
systemd-journal-gateway:x:73:
systemd-journal-remote:x:74:
systemd-journal-upload:x:75:
systemd-network:x:76:
systemd-resolve:x:77:
systemd-timesync:x:78:
systemd-coredump:x:79:
nogroup:x:99:
users:x:999:
EOF

# Update the login prompt
exec /tools/bin/bash --login +h
