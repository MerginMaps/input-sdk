#!/bin/bash

# version of your package
VERSION_geodiff=1.0.4

# dependencies of this recipe
DEPS_geodiff=(sqlite3)

# url of the package
# custom commit with fix to cmake policy
URL_geodiff=https://github.com/lutraconsulting/geodiff/archive/${VERSION_geodiff}.tar.gz

# md5 of the package
MD5_geodiff=58c499df6dc61ed99942f4df1f6c9f7f

# default build path
BUILD_geodiff=$BUILD_PATH/geodiff/$(get_directory $URL_geodiff)

# default recipe path
RECIPE_geodiff=$RECIPES_PATH/geodiff

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_geodiff() {
  cd $BUILD_geodiff

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_geodiff() {
  # If lib is newer than the sourcecode skip build
  if [ $STAGE_PATH/lib/libgeodiff.a -nt $BUILD_geodiff/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_geodiff() {
  try mkdir -p $BUILD_PATH/geodiff/build-$ARCH
  try cd $BUILD_PATH/geodiff/build-$ARCH

  # we use CMAKE < 3.12 on the ubuntu-20.04, so
  # FindSQLite3 is not yet part of the package
  # and also transitional
  try mkdir -p $BUILD_geodiff/geodiff/cmake/
  try cp $RECIPE_geodiff/FindSQLite3.cmake $BUILD_geodiff/geodiff/cmake/

  push_arm

  try $CMAKECMD \
    -DCMAKE_MODULE_PATH:PATH=$BUILD_geodiff/geodiff/cmake \
    -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
    -DENABLE_TESTS=OFF \
    -DBUILD_TOOLS=OFF \
    -DBUILD_STATIC=ON \
    -DBUILD_SHARED=OFF \
    -DWITH_POSTGRESQL=OFF \
    -DSQLITE3_INCLUDE_DIR=$STAGE_PATH/include \
    -DSQLITE3_LIBRARY=$STAGE_PATH/lib/libsqlite3.a \
    $BUILD_geodiff/geodiff

  try $MAKESMP
  try $MAKESMP install
  pop_arm
}

# function called after all the compile have been done
function postbuild_geodiff() {
    if [ ! -f ${STAGE_PATH}/lib/libgeodiff.a ]; then
        error "Library was not successfully build for ${ARCH}"
        exit 1;
    fi
}
