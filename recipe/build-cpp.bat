if "%PKG_NAME%" == "libadbc-driver-flightsql" (
    set CMAKE_FLAGS=-DADBC_DRIVER_FLIGHTSQL=ON
    goto BUILD
)
if "%PKG_NAME%" == "libadbc-driver-manager" (
    set CMAKE_FLAGS=-DADBC_DRIVER_MANAGER=ON
    goto BUILD
)
if "%PKG_NAME%" == "libadbc-driver-postgresql" (
    set CMAKE_FLAGS=-DADBC_DRIVER_POSTGRESQL=ON
    goto BUILD
)
if "%PKG_NAME%" == "libadbc-driver-snowflake" (
    set CMAKE_FLAGS=-DADBC_DRIVER_SNOWFLAKE=ON
    goto BUILD
)
if "%PKG_NAME%" == "libadbc-driver-sqlite" (
    set CMAKE_FLAGS=-DADBC_DRIVER_SQLITE=ON
    goto BUILD
)
echo Unknown package %PKG_NAME%
exit 1

:BUILD

mkdir "%SRC_DIR%"\build-cpp\%PKG_NAME%
pushd "%SRC_DIR%"\build-cpp\%PKG_NAME%

cmake ..\..\c ^
      -G Ninja ^
      -DADBC_BUILD_SHARED=ON ^
      -DADBC_BUILD_STATIC=OFF ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DCMAKE_PREFIX_PATH=%PREFIX% ^
      %CMAKE_FLAGS% ^
      || exit /B 1

ninja -t targets
cmake --build . --target install --config Release -j || exit /B 1

popd
