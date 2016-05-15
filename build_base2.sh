#! /bin/bash

## Start variables
START_DIR=$(pwd)
SCRIPT_DIR="$START_DIR/base"
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

# Create some log files to be used later on
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

# Now start building and installing a few things!
# Install Linux headers
case $SYSTEM in
"rpi")
    source "$SCRIPT_DIR/rpi_headers.sh"
;;
*)
    source "$SCRIPT_DIR/linux_headers.sh" "4.5.2"
;;
esac
# Install man-pages
source "$SCRIPT_DIR/man_pages.sh" "4.05"
# Build glibc
source "$SCRIPT_DIR/glibc.sh" "2.23"

# Adjust the toolchain a little for building
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld

gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs
# Test the toolchain once again
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
# Test some other things too
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
grep -B1 '^ /usr/include' dummy.log
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log
rm -v dummy.c a.out dummy.log

# Back to building and/or installing things!
# zlib
source "$SCRIPT_DIR/zlib.sh" "1.2.8"
# File
source "$SCRIPT_DIR/std_build.sh" "file" "5.26"
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
source "$SCRIPT_DIR/psmsic.sh" "22.21"
# Iana-Etc
source "$SCRIPT_DIR/" ""
# M4
source "$SCRIPT_DIR/std_build.sh" "m4" "1.4.17"
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
exec /bin/bash --login +h
