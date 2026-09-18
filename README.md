# Rust Windows Toolchain Binaries

Pre-built Rust toolchain components for Windows (x86_64-pc-windows-msvc) for offline installation.

## Current Release: Rust 1.98.1 (2026-09-03)

### Files

| File | Size | Description |
|------|------|-------------|
| `rustup-init.exe` | 13 MB | Rustup installer for Windows |
| `rust-1.98.1-x86_64-pc-windows-msvc.tar.xz` | 172 MB | Full Rust toolchain (rustc, rust-std, cargo, rustdoc, etc.) |
| `cargo-1.98.1-x86_64-pc-windows-msvc.tar.xz` | 9.8 MB | Cargo package manager (standalone) |
| `rustfmt-1.98.1-x86_64-pc-windows-msvc.tar.xz` | 2.5 MB | Code formatter |
| `clippy-1.98.1-x86_64-pc-windows-msvc.tar.xz` | 3.8 MB | Linting tool |

### Usage

#### Option 1: rustup-init.exe (Recommended)
1. Download `rustup-init.exe`
2. Run it on the target Windows machine
3. Follow the installer prompts

#### Option 2: Offline Installation with Standalone Tarballs
1. Download the desired `.tar.xz` files
2. Extract on the target Windows machine:
   ```powershell
   # Using 7-Zip or tar
   tar -xf rust-1.98.1-x86_64-pc-windows-msvc.tar.xz
   cd rust-1.98.1-x86_64-pc-windows-msvc
   .\install.bat
   ```
3. Add the `bin` directory to PATH

#### Option 3: Using with rustup (Offline)
```powershell
# Install rustup first, then use local toolchain
rustup toolchain link my-toolchain ./rust-1.98.1-x86_64-pc-windows-msvc
rustup default my-toolchain
```

### Verification

SHA256 checksums (from official Rust releases):
```
rustup-init.exe: <verify from rust-lang.org>
rust-1.98.1-x86_64-pc-windows-msvc.tar.xz: c34c3f01633efe5edac0e1ed1ee66d5ec13a7f27e57c149059ed6bdbe0534407
cargo-1.98.1-x86_64-pc-windows-msvc.tar.xz: 230364e5f833a273f8e4215d05e32083ae58dabf08daa2a57f77928e23b952ff
rustfmt-1.98.1-x86_64-pc-windows-msvc.tar.xz: <verify from rust-lang.org>
clippy-1.98.1-x86_64-pc-windows-msvc.tar.xz: <verify from rust-lang.org>
```

### Source

All binaries downloaded from [static.rust-lang.org](https://static.rust-lang.org/dist/).

Official release channel: [channel-rust-stable.toml](https://static.rust-lang.org/dist/channel-rust-stable.toml)

### Updating

This repository is updated with each new Rust stable release. Watch the repository for notifications.