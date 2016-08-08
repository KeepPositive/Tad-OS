#! /bin/bash

## Start variables
CONFIGURE_FILE="./build.cfg"
CORES=$(grep -c ^processor /proc/cpuinfo)
SCRIPT_DIR="./scripts"
PACKAGE_DIR="../sources"
# Get variables from CONFIGURE_FILE
for name in "INSTALL_SOURCES" "LFS" "SYSTEM" "TIMEZONE"
do
    # The 'eval' command evaluates a string into runable bash
    eval "export $name=$(grep $name "$CONFIGURE_FILE" | awk '{print $2}')"

    if [ "$?" -ne 0 ]
    then
        echo "$name could not be created! Error!"
        exit 1
    fi
done

# Set common package compression extensions
GZIP=".tar.gz"
BZIP=".tar.bz2"
XZIP=".tar.xz"
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

# Link a bunch of directories if building for 64 bit system
case $(uname -m) in
"x86_64")
        ln -sfv lib /lib64
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
for passwd_string in                                                      \
"root:x:0:0:root:/root:/bin/bash"                                         \
"bin:x:1:1:bin:/dev/null:/bin/false"                                      \
"daemon:x:6:6:Daemon User:/dev/null:/bin/false"                           \
"messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false"   \
"systemd-bus-proxy:x:72:72:systemd Bus Proxy:/:/bin/false"                \
"systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/bin/false"    \
"systemd-journal-remote:x:74:74:systemd Journal Remote:/:/bin/false"      \
"systemd-journal-upload:x:75:75:systemd Journal Upload:/:/bin/false"      \
"systemd-network:x:76:76:systemd Network Management:/:/bin/false"         \
"systemd-resolve:x:77:77:systemd Resolver:/:/bin/false"                   \
"systemd-timesync:x:78:78:systemd Time Synchronization:/:/bin/false"      \
"systemd-coredump:x:79:79:systemd Core Dumper:/:/bin/false"               \
"nobody:x:99:99:Unprivileged User:/dev/null:/bin/false"
do
    echo "$passwd_string" >> /etc/passwd
done

# Create the group file
for group_string in              \
"root:x:0:"                      \
"bin:x:1:daemon"                 \
"sys:x:2:"                       \
"kmem:x:3:"                      \
"tape:x:4:"                      \
"tty:x:5:"                       \
"daemon:x:6:"                    \
"floppy:x:7:"                    \
"disk:x:8:"                      \
"lp:x:9:"                        \
"dialout:x:10:"                  \
"audio:x:11:"                    \
"video:x:12:"                    \
"utmp:x:13:"                     \
"usb:x:14:"                      \
"cdrom:x:15:"                    \
"adm:x:16:"                      \
"messagebus:x:18:"               \
"systemd-journal:x:23:"          \
"input:x:24:"                    \
"mail:x:34:"                     \
"systemd-bus-proxy:x:72:"        \
"systemd-journal-gateway:x:73:"  \
"systemd-journal-remote:x:74:"   \
"systemd-journal-upload:x:75:"   \
"systemd-network:x:76:"          \
"systemd-resolve:x:77:"          \
"systemd-timesync:x:78:"         \
"systemd-coredump:x:79:"         \
"nogroup:x:99:"                  \
"users:x:999:"
do
    echo "$group_string" >> /etc/group
done

# Create some log files to be used later on
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

# Now start building and installing a few things!
# Install Linux headers
case $SYSTEM in
"rpi")
    source "$SCRIPT_DIR/rpi_headers.sh" "4.4.y"
;;
*)
    source "$SCRIPT_DIR/linux_headers.sh" "4.6"
;;
esac
# man-pages
source "$SCRIPT_DIR/man_pages.sh" "4.05"
# glibc
source "$SCRIPT_DIR/glibc.sh" "2.23"

# Adjust the toolchain a little for building
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld

gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs
# Test the toolchain once again
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
rm -v dummy.c a.out dummy.log

# Back to building and/or installing things!
# zlib
source "$SCRIPT_DIR/zlib.sh" "1.2.8"
# File
source "$SCRIPT_DIR/std_build.sh" "file" "5.26" "$GZIP"
# binutils
source "$SCRIPT_DIR/binutils.sh" "2.26"
# GMP
source "$SCRIPT_DIR/gmp.sh" "6.1.0"
# MPFR
source "$SCRIPT_DIR/mpfr.sh" "3.1.4"
# MPC
source "$SCRIPT_DIR/mpc.sh" "1.0.3"
# GCC
source "$SCRIPT_DIR/gcc.sh" "6.1.0"
# bzip2
source "$SCRIPT_DIR/bzip.sh" "1.0.6"
# Pkg-config
source "$SCRIPT_DIR/pkg_config.sh" "0.29.1"
# Ncurses
source "$SCRIPT_DIR/ncurses.sh" "6.0"
# attr
source "$SCRIPT_DIR/attr.sh" "2.4.47"
# acl
source "$SCRIPT_DIR/acl.sh" "2.2.52"
# libcap
source "$SCRIPT_DIR/libcap.sh" "2.25"
# sed
source "$SCRIPT_DIR/sed.sh" "4.2.2"
# shadow
source "$SCRIPT_DIR/shadow.sh" "4.2.1"
# psmisc
source "$SCRIPT_DIR/psmisc.sh" "22.21"
# Iana-Etc
source "$SCRIPT_DIR/iana_etc.sh" "2.30"
# M4
source "$SCRIPT_DIR/std_build.sh" "m4" "1.4.17" "$XZIP"
# Bison
source "$SCRIPT_DIR/bison.sh" "3.0.4"
# flex
source "$SCRIPT_DIR/flex.sh" "2.6.0"
# grep
source "$SCRIPT_DIR/grep.sh" "2.25"
# readline
source "$SCRIPT_DIR/readline.sh" "6.3"
# bash
source "$SCRIPT_DIR/bash.sh" "4.3.30"
# bc
source "$SCRIPT_DIR/bc.sh" "1.06.95"
# Libtool
source "$SCRIPT_DIR/std_build.sh" "libtool" "2.4.6" "$XZIP"
# GDBM
source "$SCRIPT_DIR/gdbm.sh" "1.11"
# Gperf
source "$SCRIPT_DIR/gperf.sh" "3.0.4"
# Expat
source "$SCRIPT_DIR/expat.sh" "2.1.1"
# Inetutils
source "$SCRIPT_DIR/inetutils.sh" "1.9.4"
# Perl
source "$SCRIPT_DIR/perl.sh" "5.22.1"
# XML-Parser
source "$SCRIPT_DIR/xml_parser.sh" "2.44"
# Intltool
source "$SCRIPT_DIR/intltool.sh" "0.51.0"
# autoconf
source "$SCRIPT_DIR/std_build.sh" "autoconf" "2.69" "$XZIP"
# automake
source "$SCRIPT_DIR/automake.sh" "1.15"
# xz
source "$SCRIPT_DIR/xz.sh" "5.2.2"
# kmod
source "$SCRIPT_DIR/kmod.sh" "22"
# gettext
source "$SCRIPT_DIR/gettext.sh" "0.19.7"
# systemd
source "$SCRIPT_DIR/systemd.sh" "229"
# Procps-ng
source "$SCRIPT_DIR/procps_ng.sh" "3.3.11"
# e2fs
source "$SCRIPT_DIR/e2fs.sh" "1.42.13"
# Coreutils
source "$SCRIPT_DIR/coreutils.sh" "8.25"
# Diffutils
source "$SCRIPT_DIR/diffutils.sh" "3.3"
# Gawk
source "$SCRIPT_DIR/gawk.sh" "4.1.3"
# Findutils
source "$SCRIPT_DIR/findutils.sh" "4.6.0"
# Groff
source "$SCRIPT_DIR/groff.sh" "1.22.3"
# GRUB
source "$SCRIPT_DIR/grub.sh" "2.02~beta2"
# Less
source "$SCRIPT_DIR/less.sh" "481"
# Gzip
source "$SCRIPT_DIR/gzip.sh" "1.8"
# IPRoute
source "$SCRIPT_DIR/iproute.sh" "4.5.0"
# kbd
source "$SCRIPT_DIR/kbd.sh" "2.0.3"
# libpipeline
source "$SCRIPT_DIR/libpipeline.sh" "1.4.1"
# Make (HA!)
source "$SCRIPT_DIR/std_build.sh" "make" "4.1" "$BZIP"
# patch
source "$SCRIPT_DIR/std_build.sh" "patch" "2.7.5" "$XZIP"
# D-bus
source "$SCRIPT_DIR/dbus.sh" "1.11.2"
# util-linux
source "$SCRIPT_DIR/util_linux.sh" "2.28"
# man-DB
source "$SCRIPT_DIR/man_db.sh" "2.7.5"
# tar
source "$SCRIPT_DIR/tar.sh" "1.28"
# texinfo
source "$SCRIPT_DIR/texinfo.sh" "6.1"
# Update texinfo documents
pushd /usr/share/info
rm -v dir
for f in *
    do install-info $f dir 2> /dev/null
done
popd
# Sudo
source "$SCRIPT_DIR/sudo.sh" "1.8.16"
# which
source "$SCRIPT_DIR/which.sh" "2.21"

# Done installing. WOW.
echo "Finished building all packages. Continue to strip_symbols."
