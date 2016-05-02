#! /bin/bash

BUILD_TYPE=$1

if [ -z "$CORES" ]; then
	CORES='4'
fi

as_root() {
  # Run things as the root user if necessary.
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

cd "$BUILD_DIR/$build_type"
# For each package in the group, run the commands in the do loop.
for package in $(grep -v '^#' "$START_DIR/sha256/$build_type.sha256" \
                         | awk '{print $2}')
do
    fold_name=${package%.tar.bz2}
    tar xvf $package
    pushd $package_dir
    ./configure $XORG_CONFIG
    as_root make install
    popd
    rm -rf $package_dir
done
