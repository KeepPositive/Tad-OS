### A build script for standard tools in Tad OS

START_DIR=$(pwd)
BUILD_DIR=$START_DIR/packs
CORES=$(grep -c ^processor /proc/cpuinfo)

custom_build() {

  package_name=$1
  package_version=$2
  compression_type=$3

  case $compression_type in
    "g")
      file_type=".tar.gz"
    ;;
    "b")
      file_type=".tar.bz2"
    ;;
    "x")
      file_type=".tar.xz"
    ;;
    "z")
      file_type=".zip"
    ;;
    "l")
      file_type=".lmza"
    ;;
  esac

  full_name="$package_name-$package_version"
  file_name="$full_name$file_type"

  echo "$file_name"

  cd $BUILD_DIR
  tar xvf $file_name

# Config case loop
  case $package_name in
    "openssl")
      ./config --prefix=/usr          \
               --openssldir=/etc/ssl  \
               --libdir=lib           \
               shared zlib-dynamic
      make depend
    ;;

    "wget")
      ./configure --prefix=/usr      \
                  --sysconfdir=/etc  \
                  --with-ssl=openssl
    ;;
    
    "curl")
      ./configure --prefix=/usr               \
                  --disable-static            \
                  --enable-threaded-resolver
    *)
      ./configure --prefix=/usr --disable-static
    ;;
  esac


# Make case loop
  case $package_name in
    "p7zip")
      make -j $CORES all
    ;;
    
    *)
      make -j $CORES
    ;;

  case $package_name in 
    "openssl")
      sed -i 's# libcrypto.a##;s# libssl.a##' Makefile
      make MANDIR=/usr/share/man MANSUFFIX=ssl install
      install -dv -m755 /usr/share/doc/openssl-$package_version
      cp -vfr doc/* /usr/share/doc/openssl-$package_version
    ;;
    "p7zip")
      make DEST_HOME=/usr      \
      DEST_MAN=/usr/share/man  \
      DEST_SHARE_DOC=/usr/share/doc/p7zip-$package_version install
    ;;
    "nettle")
      make install &&
      chmod -v 755 /usr/lib/lib{hogweed,nettle}.so
      install -v -m755 -d /usr/share/doc/nettle-3.2
      install -v -m644 nettle.html /usr/share/doc/nettle-3.2
    ;;
    "gnutls")
      make install
      make -C doc/reference install-data-local
    ;;
    "curl")
      make install
      cp -a docs docs-save
      rm -rf docs/examples/.deps
      find docs \( -name Makefile\*   \
                  -o -name \*.1       \
                  -o -name \*.3 \)    \
                  -exec rm {} \;
      install -v -d -m755 /usr/share/doc/curl-$package_version
      cp -v -R docs/*     /usr/share/doc/curl-$package_version
      rm -rf docs
      mv -i docs-save doc
    ;;
    *)  
      make install
    ;;
  esac
}

custom_build "openssl" "1.0.2g" "g"
custom_build "p7zip" "15.14.1" "b"
custom_build "wget" "1.17.1" "x"

