# Tad OS
_The simple OS for people who care about computers and stuff_

This is an in-development Linux-based OS which can be built using Bash build scripts. This repo holds those build scripts, sha256 files, etc. needed to build your own Tad OS. It can be built and run well on a large variety of systems.

## System Compatibility
Theoretically, this build system will work on any CPU that is supported by the GNU Compiler and the Linux kernel. Some may need some minor patches. But if you want to build Tad OS, please make sure your system is supported. The below CPUs types have been tested so far:
+ arm7l (Tested on a Raspberry Pi 3, which has a Broadcom BCM2837)
+ x86_64 (Tested using an AMD FX-9370)

## How to Build Tad OS
Tad OS is built using a series of bash build scripts split into different groups. Currently, you can start a build of Tad OS using the following commands.  

```
$ git clone https://github.com/KeepPositive/Tad-OS
$ cd Tad-OS
```

Now, you can configure your install by editing your 'toolchain.cfg' in the toolchain directory. Here, set the partition you would like to mount and build the system on. There are also some other useful variables, but this is the only line you need to edit. 
