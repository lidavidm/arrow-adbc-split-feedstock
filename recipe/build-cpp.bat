if "%PKG_NAME%" == "libadbc-driver-flightsql" (
    set DRIVER_BINARY=libadbc_driver_flightsql.dll
    goto BUILDGO
)
if "%PKG_NAME%" == "libadbc-driver-manager" (
    set CMAKE_FLAGS=-DADBC_DRIVER_MANAGER=ON
    goto BUILDCPP
)
if "%PKG_NAME%" == "libadbc-driver-postgresql" (
    set CMAKE_FLAGS=-DADBC_DRIVER_POSTGRESQL=ON
    goto BUILDCPP
)
if "%PKG_NAME%" == "libadbc-driver-snowflake" (
    set DRIVER_BINARY=libadbc_driver_snowflake.dll
    goto BUILDGO
)
if "%PKG_NAME%" == "libadbc-driver-sqlite" (
    set CMAKE_FLAGS=-DADBC_DRIVER_SQLITE=ON
    goto BUILDCPP
)
echo Unknown package %PKG_NAME%
exit 1

:BUILDCPP

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

goto END

:BUILDGO

pushd "%SRC_DIR%"\go\adbc\pkg

make %DRIVER_BINARY%

goto END

:END

popd
