# vendor/ — Every Required URL, Documented + Mirrored

The target Citrix box can only reach GitHub. So for every external URL the
Rust-on-Windows setup needs, there is one page here with **what it is, the
pinned version, the official source link, license/redistribution note, and
where its copy lives in this repo's Releases**.

## Tier A — mirrored in `win10-devtools-v1` release (download from this repo)

| Tool | Version | Page | Release asset |
|---|---|---|---|
| Ninja (CMake backend) | 1.13.2 | [ninja.md](ninja.md) | `ninja-win.zip` |
| NASM (crypto asm) | 3.02 | [nasm.md](nasm.md) | `nasm-3.02-win64.zip` |
| 7zr (bootstrap extractor) | 24.09 | [7zr.md](7zr.md) | `7zr.exe` |
| sccache (compiler cache) | 0.18.0 | [sccache.md](sccache.md) | `sccache-v0.18.0-x86_64-pc-windows-msvc.zip` |
| cargo-binstall (prebuilt cargo tools) | 1.23.0 | [cargo-binstall.md](cargo-binstall.md) | `cargo-binstall-x86_64-pc-windows-msvc.zip` |
| VC Redist x64 (run Rust exes) | VS17 14.44 | [vc-redist.md](vc-redist.md) | `vc_redist.x64.exe` |
| CMake (C builds) | 4.4.3 | [cmake.md](cmake.md) | `cmake-4.4.3-windows-x86_64.zip` |
| PortableGit (cargo needs git) | 2.55.0.5 | [portable-git.md](portable-git.md) | `PortableGit-2.55.0.5-64-bit.7z.exe` |
| rust-analyzer VSIX (editor LSP) | latest at vendor date | [rust-analyzer-vsix.md](rust-analyzer-vsix.md) | `rust-analyzer.vsix` |
| WinLibs MinGW UCRT (GNU target gcc) | gcc 16.2 / ucrt r1 | [winlibs-mingw.md](winlibs-mingw.md) | `winlibs-….7z` |
| VSCodium portable (no-admin editor) | 1.135.06055 | [vscodium.md](vscodium.md) | `VSCodium-win32-x64-….zip` |

Install on the offline box with `scripts/Install-Vendor.ps1`
(see each page for the manual one-liner too).

## Tier B — already in `rust-1.98.1` release (this repo)

`rustup-init.exe`, `rust-*-msvc.tar.xz`, `cargo/rustfmt/clippy-*-msvc.tar.xz`,
`rust-*-gnu.tar.xz`, `cargo/rustfmt/clippy-*-gnu.tar.xz`.
See `README.md`.

## Tier C — NOT mirrored (license forbids it), docs + source links only

| Item | Why not mirrored | Get it from |
|---|---|---|
| VS Build Tools 2022 / Windows SDK / `cl.exe`+`link.exe` | Microsoft license: compiler toolchain is never redistributable | [TOOLS.md](../TOOLS.md#1-microsoft-prerequisites-msvc-only), IT `--layout` share — source: https://aka.ms/vs/17/release/vs_BuildTools.exe |
| Official VS Code (Microsoft brand) | Binary license is use-only, not re-host friendly | Use Tier-A **VSCodium** (MIT) instead, or IT-approved VS Code — source: https://code.visualstudio.com/ |
| Strawberry Perl / LLVM / WiX full | Size (100 MB–2 GB) / rarely needed | Versioned URLs + `winget` lines in [TOOLS.md](../TOOLS.md#3-system-build-deps-for--sys-crates) |

## Reproduce (connected machine)

```powershell
.\scripts\Download-Vendor.ps1 -OutDir .\vendor-dl
```

Checks every official URL above and drops the files into `vendor-dl/`.
