# CMake — C/C++ build generator for `-sys` crates

- **What / why:** `libgit2-sys`, `aws-lc-sys`, `orhun` etc. build vendored C
  via the `cmake` crate. Needs real CMake + Ninja (§ninja) in PATH.
- **Pinned version:** `v4.4.3` (2026-08-25).
- **Source (official):** https://cmake.org/download/ /
  https://github.com/Kitware/CMake/releases
  Direct: `https://github.com/Kitware/CMake/releases/download/v4.4.3/cmake-4.4.3-windows-x86_64.zip`
  (`.msi` installer also on same page — zip needs no admin.)
- **License:** BSD-3-Clause — freely redistributable.
- **In this repo:** release `win10-devtools-v1` → same zip (~50 MB).
- **Offline install (no admin):** unzip to `U:\tools\cmake\`, add `bin\` to user PATH.
- **Verify:** `cmake --version` → `4.4.3`; `where cmake ninja`.
