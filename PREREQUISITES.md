# Prerequisites for Rust Windows Development (MSVC Toolchain)

This document covers everything needed to **develop and build** Rust projects on Windows using the `x86_64-pc-windows-msvc` toolchain from this repository.

---

## 1. Visual Studio Build Tools (Required for MSVC)

The **minimal, free** option — no full Visual Studio IDE needed.

### Install via winget (recommended)
```powershell
# Run in Administrator PowerShell
winget install Microsoft.VisualStudio.2022.BuildTools --silent --accept-source-agreements --accept-package-agreements
```

### Or manual download
1. Download: [Visual Studio Build Tools 2022](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022)
2. Run installer → Select **only**:
   - ✅ **C++ build tools** (includes `cl.exe`, `link.exe`, `lib.exe`)
   - ✅ **Windows 11 SDK** (or **Windows 10 SDK** — latest version)
   - ✅ **MSVC v143 - VS 2022 C++ x64/x86 build tools** (latest)
   - ❌ Everything else (IDE, .NET, etc.)

### Size: ~2–5 GB (vs ~20+ GB for full VS)

---

## 2. Verify Installation

Open **Developer Command Prompt for VS 2022** (or run `vcvarsall.bat`):

```cmd
:: Verify compiler + linker
cl.exe
link.exe

:: Should show versions like:
:: Microsoft (R) C/C++ Optimizing Compiler Version 19.40.xxxxx
:: Microsoft (R) Incremental Linker Version 14.40.xxxxx
```

### If `cl.exe`/`link.exe` not found
Run the environment setup manually:
```cmd
"C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" x64
```
Or use **"Developer Command Prompt"** / **"Developer PowerShell"** from Start Menu.

---

## 3. Rust Toolchain (from this repo)

### Option A: rustup-init.exe (Recommended)
```powershell
# Download from latest release
.\rustup-init.exe

# Follow prompts → select "Default" (MSVC toolchain)
# This installs rustup + stable-x86_64-pc-windows-msvc
```

### Option B: Offline tarball (no internet on target machine)
```powershell
# Extract
tar -xf rust-1.98.1-x86_64-pc-windows-msvc.tar.xz
cd rust-1.98.1-x86_64-pc-windows-msvc

# Install
.\install.bat

# Add to PATH (permanent)
setx PATH "%PATH%;C:\Users\<USER>\.rustup\bin"
# Or if using custom install dir:
setx PATH "%PATH%;C:\rust\bin"
```

### Verify
```powershell
rustc --version   # rustc 1.98.1 (xxxxxxxx 2026-09-03)
cargo --version   # cargo 1.98.1 (xxxxxxxx 2026-09-03)
rustup --version  # rustup 1.27.x
```

---

## 4. Additional Components (Optional but Recommended)

| Component | Install Command | Purpose |
|-----------|-----------------|---------|
| **rustfmt** | `rustup component add rustfmt` | Code formatting |
| **clippy** | `rustup component add clippy` | Linting |
| **rust-analyzer** | `rustup component add rust-analyzer` | IDE support (VS Code) |
| **rust-src** | `rustup component add rust-src` | Source for `rust-analyzer` go-to-definition |
| **llvm-tools-preview** | `rustup component add llvm-tools-preview` | `cargo llvm-cov`, `cargo binstall` |

### Or download standalone from this repo
```powershell
# Extract and add bin/ to PATH
tar -xf rustfmt-1.98.1-x86_64-pc-windows-msvc.tar.xz
tar -xf clippy-1.98.1-x86_64-pc-windows-msvc.tar.xz
```

---

## 5. Git (Required for cargo)

```powershell
winget install Git.Git
# Or download from git-scm.com
```

---

## 6. Common C/C++ Dependencies (via vcpkg)

Many Rust crates depend on C libraries (openssl, sqlite, libgit2, etc.). Use **vcpkg**:

```powershell
# Install vcpkg
git clone https://github.com/microsoft/vcpkg.git C:\vcpkg
cd C:\vcpkg
.\bootstrap-vcpkg.bat

# Integrate with VS Build Tools
.\vcpkg integrate install

# Install common libraries (x64-windows)
.\vcpkg install openssl:x64-windows sqlite3:x64-windows libgit2:x64-windows zlib:x64-windows

# Set environment variable for cargo
setx VCPKG_ROOT "C:\vcpkg"
```

Now `cargo build` will find these automatically via `pkg-config` / `vcpkg` integration.

---

## 7. Alternative: GNU Toolchain (No Visual Studio)

If you **cannot install Build Tools**, use the GNU (mingw) toolchain:

```powershell
rustup toolchain install stable-x86_64-pc-windows-gnu
rustup default stable-x86_64-pc-windows-gnu
```

| Pros | Cons |
|------|------|
| No VS/Build Tools needed | Some `-sys` crates won't build |
| Smaller install | MSVC-specific APIs unavailable |
| Works cross-platform | Debugging harder (no PDB) |

**Install mingw:** `winget install mingw64.mingw64` or `scoop install mingw`

---

## 8. Complete Setup Script (PowerShell)

Run in **Administrator PowerShell**:

```powershell
# 1. Build Tools
winget install Microsoft.VisualStudio.2022.BuildTools --silent --accept-source-agreements --accept-package-agreements

# 2. Git
winget install Git.Git

# 3. Rust (via rustup-init.exe from this repo)
.\rustup-init.exe -y --default-toolchain stable --profile minimal

# 4. Refresh PATH
$env:PATH = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# 5. Verify
rustc --version
cargo --version
cl.exe 2>&1 | Select-Object -First 1

# 6. Optional components
rustup component add rustfmt clippy rust-analyzer rust-src

# 7. vcpkg (optional)
git clone https://github.com/microsoft/vcpkg.git C:\vcpkg
cd C:\vcpkg; .\bootstrap-vcpkg.bat; .\vcpkg integrate install
```

---

## 9. Troubleshooting

### `link.exe: LNK1104: cannot open file 'kernel32.lib'`
→ Windows SDK not installed. Re-run Build Tools installer, select **Windows 11 SDK**.

### `cl.exe: fatal error C1083: Cannot open include file: 'stdio.h'`
→ Run `vcvarsall.bat x64` or use **Developer Command Prompt**.

### `error: linker 'link.exe' not found`
→ Same as above: environment not set up. Use Developer Command Prompt.

### `cargo: could not find native static library 'openssl'`
→ Install via vcpkg: `.\vcpkg install openssl:x64-windows`

### Cross-compiling from Linux/macOS
```bash
# Use cross (Docker-based)
cargo install cross
cross build --target x86_64-pc-windows-msvc
```

---

## 10. File Checklist for Offline Machine

Copy these to target machine (no internet needed):

| File | Purpose |
|------|---------|
| `rustup-init.exe` | Install rustup + MSVC toolchain |
| `rust-1.98.1-x86_64-pc-windows-msvc.tar.xz` | Full offline toolchain |
| `cargo-*.tar.xz` | Cargo standalone |
| `rustfmt-*.tar.xz` | Formatter |
| `clippy-*.tar.xz` | Linter |
| `vs_BuildTools.exe` | VS Build Tools installer (download separately) |
| `vcpkg/` folder | Pre-cloned vcpkg (optional) |

---

## Summary

| Component | Required? | Size | Source |
|-----------|-----------|------|--------|
| VS Build Tools 2022 | **Yes** (MSVC) | 2–5 GB | Microsoft / winget |
| Windows SDK | **Yes** (MSVC) | Included | VS Installer |
| rustup-init.exe | **Yes** | 13 MB | **This repo** |
| Git | **Yes** | ~50 MB | winget / git-scm.com |
| vcpkg | Recommended | ~1 GB | GitHub |
| rustfmt/clippy | Recommended | 6 MB | **This repo** / rustup |

**Total download: ~3–7 GB** (mostly Build Tools + SDK)