#!/bin/bash

# version of your package in ../../version.conf

# dependencies of this recipe
DEPS_qtkeychain=()

# default build path
BUILD_qtkeychain=$BUILD_PATH/qtkeychain/$(get_directory $URL_qtkeychain)

# default recipe path
RECIPE_qtkeychain=$RECIPES_PATH/qtkeychain

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qtkeychain() {
  cd $BUILD_qtkeychain
  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_qtkeychain() {
 # If lib is newer than the sourcecode skip build
 if [ ${STAGE_PATH}/lib/libqt5keychain.a -nt $BUILD_qtkeychain/.patched ]; then
  DO_BUILD=0
 fi
}

# function called to build the source code
function build_qtkeychain() {
 try mkdir -p $BUILD_qtkeychain/build-$ARCH
 try cd $BUILD_qtkeychain/build-$ARCH

 push_env

 # configure
 try ${CMAKECMD} \
  -DQT4_BUILD=OFF \
  -DQCA_SUFFIX=qt5 \
  -DBUILD_TESTS=OFF \
  -DBUILD_TOOLS=OFF \
  -DWITH_nss_PLUGIN=OFF \
  -DWITH_pkcs11_PLUGIN=OFF \
  -DQTKEYCHAIN_STATIC=TRUE \
  $BUILD_qtkeychain
 
 check_file_configuration CMakeCache.txt
 
 try $MAKESMP install
 
 
 pop_env
}

# function called after all the compile have been done
function postbuild_qtkeychain() {
  if [ ! -f ${STAGE_PATH}/lib/libqt5keychain.a ]; then
      error "Library was not successfully build for ${ARCH}"
      exit 1;
  fi
}
