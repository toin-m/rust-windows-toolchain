# Ninja — fast CMake backend

- **What / why:** `ninja.exe` (~130 KB single binary). CMake backend
  (`-G Ninja`, `CMAKE_GENERATOR=Ninja`) used by `cmake`-crate builds
  (`libgit2-sys`, `aws-lc-sys`). 10x faster C/C++ rebuilds.
- **Pinned version:** `v1.13.2` (2025-11-20).
- **Source (official):** https://github.com/ninja-build/ninja/releases
  Direct: `https://github.com/ninja-build/ninja/releases/download/v1.13.2/ninja-win.zip`
- **License:** Apache-2.0 — freely redistributable. Source in same repo.
- **In this repo:** release `win10-devtools-v1` → `ninja-win.zip`.
- **Offline install (no admin):** unzip to `U:\tools\ninja\ninja.exe`, add dir to user PATH.
- **Verify:** `ninja --version` → `1.13.2`.
