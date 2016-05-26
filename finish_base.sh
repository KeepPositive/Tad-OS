#! /bin/bash

# Set the hostname
echo "$DEFAULT_USER" > /etc/hostname

# Set up defaul hosts for internet connection
printf "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n" >> /etc/hosts

# Force timedatectl to read RTC
printf "0.0 0 0.0\n0\nLOCAL" >> /etc/adjtime

# Choose a locale for the system
printf "LANG=en_US.UTF-8" >> /etc/locale.conf

# Create the inputrc
for inputrc_string in                                                   \
"# Begin /etc/inputrc\n"                                                \
"# Allow the command prompt to wrap to the next line"                   \
"set horizontal-scroll-mode Off\n"                                      \
"# Enable 8bit input"                                                   \
"set meta-flag On"                                                      \
"set input-meta On\n"                                                   \
"# Turns off 8th bit stripping"                                         \
"set convert-meta Off\n"                                                \
"# Keep the 8th bit for display"                                        \
"set output-meta On\n"                                                  \
"# none, visible or audible"                                            \
"set bell-style none\n"                                                 \
"# All of the following map the escape sequence of the value"           \
"# contained in the 1st argument to the readline specific functions"    \
'"\eOd": backward-word'                                                 \
'"\eOc": forward-word\n'                                                \
"# for linux console"                                                   \
'"\e[1~": beginning-of-line'                                            \
'"\e[4~": end-of-line'                                                  \
'"\e[5~": beginning-of-history'                                         \
'"\e[6~": end-of-history'                                               \
'"\e[3~": delete-char'                                                  \
'"\e[2~": quoted-insert'                                                \
"# for xterm"                                                           \
'"\eOH": beginning-of-line'                                             \
'"\eOF": end-of-line'                                                   \
"\n# End /etc/inputrc"
do
    echo -e "$inputrc_string"  >> /etc/inputrc
done

# Define shells that can be used
printf "/bin/sh\n/bin/bash" >> /etc/shells

# Create the header for a fstab file
printf "\n# DEVICE\t\t\tMOUNT\tTYPE\tOPTIONS\t\tDUMP\tORDER\n" >> /etc/fstab

echo "Almost done, just complete fstab, build the kernel and install bootloader"

