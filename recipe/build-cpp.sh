#!/bin/bash

set -ex

case "${PKG_NAME}" in
    libadbc-driver-manager)
        export CMAKE_FLAGS="-DADBC_DRIVER_MANAGER=ON"
        ;;
    libadbc-driver-flightsql)
        export CGO_ENABLED=1
        export CMAKE_FLAGS="-DADBC_DRIVER_FLIGHTSQL=ON"
        ;;
    libadbc-driver-postgresql)
        export CMAKE_FLAGS="-DADBC_DRIVER_POSTGRESQL=ON"
        ;;
    libadbc-driver-snowflake)
        export CMAKE_FLAGS="-DADBC_DRIVER_SNOWFLAKE=ON"
        ;;
    libadbc-driver-sqlite)
        export CMAKE_FLAGS="-DADBC_DRIVER_SQLITE=ON"
        ;;
    *)
        echo "Unknown package ${PKG_NAME}"
        exit 1
        ;;
esac

if [[ "${target_platform}" == "linux-aarch64" ]] ||
       [[ "${target_platform}" == "osx-arm64" ]]; then
    export GOARCH="arm64"

    # conda sets these which trip the build up
    CFLAGS="$(echo $CFLAGS | sed 's/-march=core2 //g')"
    CFLAGS="$(echo $CFLAGS | sed 's/-mtune=haswell //g')"
    CFLAGS="$(echo $CFLAGS | sed 's/-march=nocona //g')"
    CFLAGS="$(echo $CFLAGS | sed 's/-mssse3 //g')"
elif [[ "${target_platform}" == "linux-ppc64le" ]]; then
    export GOARCH="ppc64le"
else
    export GOARCH="amd64"
fi

mkdir -p "build-cpp/${PKG_NAME}"
pushd "build-cpp/${PKG_NAME}"

cmake "../../c" \
      -G Ninja \
      -DADBC_BUILD_SHARED=ON \
      -DADBC_BUILD_STATIC=OFF \
      -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
      -DCMAKE_PREFIX_PATH="${PREFIX}" \
      ${CMAKE_FLAGS}

cmake --build . --target install -j

popd
