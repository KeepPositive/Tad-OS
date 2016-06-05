#! /bin/bash

PACKAGE="mesa"
VERSION=$1
FOLD_NAME=$PACKAGE-$VERSION
GLL_DRV="nouveau,r300,r600,radeonsi,svga,swrast"

if [ -z "$CORES" ]
then
	CORES=4
fi

tar xvf "$PACKAGE_DIR/$FOLD_NAME.tar.xz"

pushd "$FOLD_NAME"

# Configure the source
case "$GRAPHICS_DRIVER" in
"rpi")
    ./autogen.sh CFLAGS='-O2' CXXFLAGS='-O2'    \
                --prefix=$XORG_PREFIX           \
                --sysconfdir=/etc               \
                --enable-texture-float          \
                --enable-gles1                  \
                --enable-gles2                  \
                --enable-osmesa                 \
                --enable-xa                     \
                --enable-gbmi			\
		--with-dri-drivers=             \
                --enable-glx-tls                \
                --enable-shared-glapi   	\
                --with-egl-platforms="drm,x11"  \
                --with-gallium-drivers=vc4
;;
*)
    ./autogen.sh CFLAGS='-O2' CXXFLAGS='-O2'    \
                --prefix=$XORG_PREFIX           \
                --sysconfdir=/etc               \
                --enable-texture-float          \
                --enable-gles1                  \
                --enable-gles2                  \
                --enable-osmesa                 \
                --enable-xa                     \
                --enable-gbm                    \
                --enable-glx-tls                \
                --enable-r600-llvm-compiler     \
                --with-egl-platforms="drm,x11"  \
                --with-gallium-drivers=$GLL_DRV
;;    
esac
# Build using the configured sources
make -j "$CORES"

# Install the built package
if [ "$INSTALL" -eq 1 ]
then
    make install
fi

popd

rm -rf "$FOLD_NAME"
