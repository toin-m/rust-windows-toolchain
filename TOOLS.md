# TOOLS — Complete Rust-on-Windows-10 Tooling (MSVC + GNU)

Target OS: Windows 10 22H2 x86_64. Rust 1.98.1 (2026-09-03) in this repo's
Releases. Binaries: `rustup-init.exe` + `rust/cargo/rustfmt/clippy`
tarballs for `x86_64-pc-windows-msvc` and `x86_64-pc-windows-gnu`.

> Rule 1: MSVC (`cl.exe`/`link.exe`, Windows SDK) is **not redistributable**.
> Never zip/copy it. Point to the Microsoft layout docs (§1). Everything
> from `static.rust-lang.org` in this repo's Releases is fine to mirror.

## 0. Pick a target

| Target | Linker | Needs VS? | Use when |
|---|---|---|---|
| `x86_64-pc-windows-msvc` (default) | `link.exe` (MSVC) | Yes | Default, best `-sys` crate support |
| `x86_64-pc-windows-gnu` | `gcc.exe` (MinGW-w64) | No | No-VS installs, Unix-style build scripts |
| `i686-…`, `aarch64-pc-windows-msvc` | same linkers | `-msvc` only for MSVC | 32-bit / ARM64 testing |

```powershell
rustup toolchain install stable-x86_64-pc-windows-msvc
rustup target add x86_64-pc-windows-gnu
```

## 1. Microsoft prerequisites (MSVC only)

### 1.1 Build Tools 2022 bootstrapper (~3 MB, install 2–7 GB)

- Download: https://aka.ms/vs/17/release/vs_BuildTools.exe
- Downloads hub: https://visualstudio.microsoft.com/downloads/
- Component IDs: https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2022
- Rust MSVC docs: https://rust-lang.github.io/rustup/installation/windows-msvc.html
- C++ setup: https://learn.microsoft.com/en-us/cpp/build/vscpp-step-0-installation

Minimal CLI install (admin):

```cmd
vs_BuildTools.exe --norestart --passive --downloadThenInstall --includeRecommended ^
 --add Microsoft.VisualStudio.Workload.VCTools ^
 --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 ^
 --add Microsoft.VisualStudio.Component.Windows11SDK.22621
```

Winget (admin):

```powershell
winget install --id Microsoft.VisualStudio.2022.BuildTools --source winget
```

Exact component IDs you need:

| ID | What |
|---|---|
| `Microsoft.VisualStudio.Workload.VCTools` | Desktop C++ workload (MSBuild, UCRT) |
| `Microsoft.VisualStudio.Component.VC.Tools.x86.x64` | MSVC v143 `cl/link/lib/ml64` — **required** |
| `Microsoft.VisualStudio.Component.VC.CoreBuildTools`, `Microsoft.Component.MSBuild` | Build driver |
| `Microsoft.VisualStudio.Component.Windows10SDK`, `Microsoft.Component.VC.Runtime.UCRTSDK` | UCRT (`ucrt.lib`) |
| `Microsoft.VisualStudio.Component.VC.Redist.14.Latest` | Runtime merge modules |
| `Microsoft.VisualStudio.Component.VC.CMake.Project` | Only if you want VS-bundled CMake |
| `Microsoft.VisualStudio.Component.Vcpkg` | vcpkg integration |
| `Microsoft.VisualStudio.ComponentGroup.VC.Tools.142.x86.x64` | Only to pin old v142 |

Offline layout (IT runs once, then `--noweb` on targets):
https://learn.microsoft.com/en-us/visualstudio/install/create-an-offline-installation-of-visual-studio?view=vs-2022

### 1.2 Windows SDK (pick ONE, ~2 GB each)

Hub: https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/

| SDK | VS component ID | Winget |
|---|---|---|
| 10.0.19041 (Win10 2004, last Win10-only baseline) | `Microsoft.VisualStudio.Component.Windows10SDK.19041` | `Microsoft.WindowsSDK.10.0.19041` |
| 10.0.22621 (Win11 22H2, rustup recommended min) | `Microsoft.VisualStudio.Component.Windows11SDK.22621` | `Microsoft.WindowsSDK.10.0.22621` |
| 10.0.26100 (Win11 24H2, current VS2022 default) | `Microsoft.VisualStudio.Component.Windows11SDK.26100` | `Microsoft.WindowsSDK.10.0.26100` |

Any SDK builds pure Rust. Default to `22621` (stable) or `26100` (latest).
Verify: `dir "%ProgramFiles(x86)%\Windows Kits\10\Lib"`.

### 1.3 VC Redistributable (~24 MB x64, ship with your app)

- Latest: https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist
- Direct x64: https://aka.ms/vs/17/release/vc_redist.x64.exe
- Winget: `winget install --id Microsoft.VCRedist.2015+.x64`
- Which DLLs / redistribution rules:
  https://learn.microsoft.com/en-us/cpp/windows/redistributing-visual-cpp-files?view=msvc-170

### 1.4 Linker paths + `vcvarsall`

```
C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\<14.44.x>\bin\Hostx64\x64\cl.exe
...\link.exe / lib.exe / ml64.exe
C:\Program Files (x86)\Windows Kits\10\bin\<10.0.22621.0>\x64\rc.exe
C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat
```

`rustc` finds VS via `vswhere` — you only need `vcvarsall.bat x64`
manually when invoking `cl`/`dumpbin` yourself.

## 2. Rust toolchain (this repo + rustup)

Installer: https://win.rustup.rs → https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe
Docs: https://www.rust-lang.org/tools/install, https://rust-lang.github.io/rustup/

| Component | Need? | Why |
|---|---|---|
| `rustc` + `cargo` + `rust-std` | **Required** | Compiler, package manager, std for each target |
| `rustfmt` | Required* | `cargo fmt` |
| `clippy` | Required* | `cargo clippy` |
| `rust-analyzer` | Highly recommended | LSP for VS Code |
| `rust-src` | Recommended | `rust-analyzer` go-to-std-def, `cargo expand` hover (~150 MB) |
| `llvm-tools-preview` | For coverage | `llvm-profdata/llvm-cov` for `cargo-llvm-cov` |
| `rust-docs` | Offline only | `rustup doc --std` (~50 MB) |

```powershell
rustup toolchain install stable-x86_64-pc-windows-msvc
rustup component add rustfmt clippy rust-analyzer rust-src
rustup target add x86_64-pc-windows-gnu
rustc -Vv; cargo -V; rustup show
```

Full offline method: https://forge.rust-lang.org/infra/other-installation-methods.html

## 3. System build deps for `-sys` crates

Only install what your tree needs. First try `cargo build`, then the
crate's `vendored`/`bundled` feature, before installing system libs.
(`openssl-sys`, `libgit2-sys`, `ring`/`aws-lc-sys`, `zstd-sys` are the
usual triggers via the `cc`/`cmake`/`pkg-config` helper crates.)

| Tool | Why | Install |
|---|---|---|
| CMake 3.30+ (150 MB) https://cmake.org/download/ | `cmake` crate | `winget install --id Kitware.CMake` / portable zip |
| Ninja 1.12+ (400 KB) https://github.com/ninja-build/ninja/releases | Fast CMake backend `-G Ninja` | `winget install --id Ninja-build.Ninja` |
| Strawberry Perl 5.38+ (350 MB) https://strawberryperl.com/ | `openssl-src` build scripts (must be Strawberry, not Cygwin) | `winget install --id StrawberryPerl.StrawberryPerl` |
| NASM 2.16+ (10 MB) https://www.nasm.us/ | asm paths (`ring`, `boringssl`) | `winget install --id NASM.NASM` |
| LLVM/libclang 19.x https://github.com/llvm/llvm-project/releases | `bindgen` needs `libclang.dll` → set `LIBCLANG_PATH=C:\Program Files\LLVM\bin` | `winget install --id LLVM.LLVM` |
| OpenSSL 3.x | `openssl-sys`/`native-tls`. Prefer `cargo add openssl --features vendored`, else `OPENSSL_DIR=C:\vcpkg\installed\x64-windows` | `vcpkg install openssl:x64-windows` |
| zlib / sqlite3 / libgit2 | `libz-sys`, `libsqlite3-sys`, `git2`. Prefer `bundled` features | `vcpkg install zlib:x64-windows sqlite3:x64-windows libgit2:x64-windows` |
| pkgconf (~1 MB) https://github.com/pkgconf/pkgconf | `.pc` probing fallback | `winget install --id pkgconf.pkgconf` (often unneeded on MSVC) |
| vcpkg https://github.com/microsoft/vcpkg | Best source for system OpenSSL/zlib/sqlite on Windows. Set `VCPKG_ROOT`. | `git clone https://github.com/microsoft/vcpkg C:\vcpkg` + `.\bootstrap-vcpkg.bat` |
| MinGW-w64 (GNU target only, 500 MB–1 GB) | `gcc.exe`/`ld` for `x86_64-pc-windows-gnu`. Use UCRT + seh/posix build. | MSYS2: `winget install --id msys2.msys2` then `pacman -S mingw-w64-x86_64-toolchain`, or WinLibs `BrechtSanders.WinLibs.POSIX.UCRT` |

## 4. Cargo extensions

Prefer `cargo-binstall` (prebuilt binaries, no LLVM compile):

```powershell
cargo install cargo-binstall
cargo binstall cargo-nextest cargo-llvm-cov cargo-audit cargo-deny
```

| Crate | Why |
|---|---|
| `cargo-edit` https://github.com/killercup/cargo-edit | `cargo add/rm/upgrade` (`add/rm` built into cargo 1.62+ now) |
| `cargo-watch` https://github.com/watchexec/cargo-watch | rebuild/test on save |
| `cargo-expand` https://github.com/dtolnay/cargo-expand | macro expansion (needs nightly + `rust-src`) |
| `cargo-audit` https://github.com/RustSec/rustsec | RustSec advisory audit |
| `cargo-deny` https://github.com/EmbarkStudios/cargo-deny | license/ban/source policy for CI |
| `cargo-nextest` https://github.com/nextest-rs/nextest | fast parallel test runner |
| `cargo-llvm-cov` https://github.com/taiki-e/cargo-llvm-cov | coverage (needs `llvm-tools-preview`) |
| `cross` https://github.com/cross-rs/cross | Docker-based cross compile (needs Docker) |
| `sccache` https://github.com/mozilla/sccache | shared compiler cache, `RUSTC_WRAPPER=sccache` |
| `cargo-wix` https://github.com/volks73/cargo-wix | MSI from `Cargo.toml` (needs WiX §5) |

## 5. Companion apps (Windows 10)

| App | Link | Winget |
|---|---|---|
| Git for Windows (~300 MB, **required** for cargo) https://git-scm.com/download/win | https://github.com/git-for-windows/git/releases | `Git.Git` (portable `PortableGit-*.7z.exe` exists) |
| GitHub CLI (~30 MB) https://cli.github.com/ | https://github.com/cli/cli/releases | `GitHub.cli` |
| VS Code (~350 MB) https://code.visualstudio.com/ | https://github.com/microsoft/vscode | `Microsoft.VisualStudioCode` (offline: `VSCode-win32-x64-*.zip` + `*.vsix`) |
| rust-analyzer extension (~20 MB) | https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer / https://open-vsx.org/extension/rust-lang/rust-analyzer | `code --install-extension rust-lang.rust-analyzer` |
| Windows Terminal (~30 MB) | https://github.com/microsoft/terminal/releases | `Microsoft.WindowsTerminal` |
| PowerShell 7 (~100 MB) | https://github.com/PowerShell/PowerShell/releases | `Microsoft.PowerShell` |
| 7-Zip (~5 MB) https://www.7-zip.org/ | https://github.com/ip7z/7zip/releases | `7zip.7zip` |
| WiX Toolset (100–250 MB) https://wixtoolset.org/ | https://github.com/wixtoolset/wix/releases | `WiX.Toolset` |

## 6. Environment variables

| Var | Value / note |
|---|---|
| `PATH` | Must include `%USERPROFILE%\.cargo\bin`; CMake, Strawberry `perl\bin`, NASM, MinGW `bin` (GNU), WiX `bin` |
| `INCLUDE` / `LIB` | Do NOT set globally — let `rustc` discover via `vswhere`; only `vcvarsall.bat x64` for manual sessions |
| `VCPKG_ROOT` | e.g. `C:\vcpkg` |
| `OPENSSL_DIR` / `OPENSSL_LIB_DIR` / `OPENSSL_INCLUDE_DIR` | Only for system OpenSSL, e.g. `C:\vcpkg\installed\x64-windows` |
| `LIBCLANG_PATH` | e.g. `C:\Program Files\LLVM\bin` (bindgen) |
| `CARGO_HOME` / `RUSTUP_HOME` | Defaults `%USERPROFILE%\.cargo` / `.rustup`; override to move off `C:` |
| `CARGO_TARGET_DIR` | e.g. `D:\target` — share/dedup build output |
| `CARGO_NET_OFFLINE=true` | Force offline (after `cargo fetch` + `cargo vendor`) |
| `RUSTC_WRAPPER=sccache` | Compiler cache |
| `CC`/`CXX`/`CMAKE_GENERATOR` | Advanced pinning, e.g. `CMAKE_GENERATOR=Ninja` |

Verify:

```powershell
.\scripts\Verify.ps1
```
