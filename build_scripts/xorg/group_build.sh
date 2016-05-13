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
for package in $(grep -v '^#' "$START_DIR/sha256/$BUILD_TYPE.sha256" \
                         | awk '{print $2}')
do
    fold_name=${package%.tar.bz2}
    tar xvf "$START_DIR/packs/$BUILD_TYPE/$package"
    pushd $fold_name
    ./configure $XORG_CONFIG
    #as_root make install
    popd
    rm -rf $fold_name
done
