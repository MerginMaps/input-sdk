set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CMAKE_SYSTEM_NAME iOS)
set(VCPKG_OSX_ARCHITECTURES arm64)
if(DEFINED ENV{MACOSX_DEPLOYMENT_TARGET})
  set(VCPKG_OSX_DEPLOYMENT_TARGET $ENV{MACOSX_DEPLOYMENT_TARGET})
endif()
set(VCPKG_BUILD_TYPE release)
set(VCPKG_CXX_FLAGS "-fvisibility=hidden")
set(VCPKG_C_FLAGS "-fvisibility=hidden")

set(VCPKG_ENV_PASSTHROUGH Qt6_DIR)