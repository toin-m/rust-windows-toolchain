# cargo-binstall — prebuilt cargo-tool installer (no LLVM compile)

- **What / why:** Installs `cargo-nextest`, `cargo-llvm-cov`, `cargo-audit`,
  `cargo-deny` from prebuilt binaries in seconds. Compiling them with
  `cargo install` on a thin Citrix box takes 10–30 min each.
- **Pinned version:** `v1.23.0` (2026-09-05).
- **Source (official):** https://github.com/cargo-bins/cargo-binstall/releases
  Direct: `https://github.com/cargo-bins/cargo-binstall/releases/download/v1.23.0/cargo-binstall-x86_64-pc-windows-msvc.zip`
- **License:** GPL-3.0 (binary redistributable; source linked above).
- **In this repo:** release `win10-devtools-v1` → same zip.
- **Offline install:** unzip `cargo-binstall.exe` to `%CARGO_HOME%\bin`
  (= `U:\rust\.cargo\bin`), then `cargo binstall cargo-nextest cargo-llvm-cov`
  (needs crates.io through proxy, or pre-fetched `--offline` bundle).
- **Verify:** `cargo binstall --version` → `1.23.0`.
