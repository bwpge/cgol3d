set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

build_dir := "build"
vcpkg_root := env('VCPKG_ROOT')
toolchain_file := vcpkg_root / "scripts" / "buildsystems" / "vcpkg.cmake"
extension := if os_family() == "windows" { ".exe" } else { "" }
triplet := if os_family() == "windows" { "-DVCPKG_TARGET_TRIPLET=x64-windows-static " } else { "" }
exe := "build/app/cgol3dapp" + extension

[unix]
clean:
    rm -rf ./{{build_dir}}

[windows]
clean:
    Remove-Item -Recurse -Force ./{{build_dir}}

configure:
    cmake --toolchain {{toolchain_file}} {{triplet}}-G Ninja -B {{build_dir}} -S .

build conf='Debug': configure
    cmake --build ./{{build_dir}} --config {{conf}}

run: build
    ./{{exe}}

run-release: (build 'Release')
    ./{{exe}}
