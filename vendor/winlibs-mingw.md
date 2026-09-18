# WinLibs MinGW UCRT — gcc for the GNU target (no VS at all)

- **What / why:** Provides `gcc.exe`/`ld` for `x86_64-pc-windows-gnu`.
  On a Citrix box where IT won't install Build Tools, this + the Tier-B
  `rust-*-gnu.tar.xz` gives a working `cargo build` with zero admin.
  Caveat: some `-sys` crates still assume MSVC — prefer MSVC when available.
- **Pinned version:** `gcc 16.2.0 / mingw-w64 14.0.0 / UCRT r1`
  (`16.2.0posix-14.0.0-ucrt-r1`, 2026-08-09). Flavor: **x86_64 posix-seh ucrt**.
- **Source (official):** https://github.com/brechtsanders/winlibs_mingw/releases
  (upstream https://www.mingw-w64.org/, builds https://winlibs.com/)
  Direct: `https://github.com/brechtsanders/winlibs_mingw/releases/download/16.2.0posix-14.0.0-ucrt-r1/winlibs-x86_64-posix-seh-gcc-16.2.0-mingw-w64ucrt-14.0.0-r1.7z`
  (~110 MB, plus `.sha256` on same page — verify before use.)
- **License:** GPL + GCC Runtime Library Exception — freely redistributable.
- **In this repo:** release `win10-devtools-v1` → same `.7z`.
- **Offline install (no admin):** `7zr x winlibs-….7z -oU:\tools\`,
  add `U:\tools\mingw64\bin` to user PATH.
- **Verify:** `gcc --version` → `16.2.0`; `rustup target add x86_64-pc-windows-gnu`;
  `cargo build --target x86_64-pc-windows-gnu`.
