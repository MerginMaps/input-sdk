# Be sure to update both of these versions together.
set(GEODIFF_VERSION 1.0.6)
set(GEODIFF_HASH e91c189fd14434cb8b1975de52f986e54495a4cebde27c53ec5b4fef78ff880df3b329705b50a39ffec3c60bae62967e235fd8f60ed41d8505191184d02cae8f)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MerginMaps/geodiff
    REF ${GEODIFF_VERSION}
    SHA512 ${GEODIFF_HASH}
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}/geodiff
    OPTIONS 
        -DENABLE_TESTS=OFF 
        -DBUILD_TOOLS=OFF
        -DWITH_POSTGRESQL=OFF
)

vcpkg_install_cmake()
file(WRITE ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright "Geodiff is MIT licensed\n")
