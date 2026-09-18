# sccache — shared Rust/C++ compiler cache

- **What / why:** Wraps `rustc` (`RUSTC_WRAPPER=sccache`) + MSVC `cl.exe`.
  On non-persistent Citrix (wiped `target/`), a warm `SCCACHE_DIR` on `U:`
  turns 20-min clean builds into 2-min restores.
- **Pinned version:** `v0.18.0` (2026-09-14).
- **Source (official):** https://github.com/mozilla/sccache/releases
  Direct: `https://github.com/mozilla/sccache/releases/download/v0.18.0/sccache-v0.18.0-x86_64-pc-windows-msvc.zip`
- **License:** Apache-2.0/MIT — freely redistributable.
- **In this repo:** release `win10-devtools-v1` → same zip.
- **Offline install (no admin):** unzip `sccache.exe` to `U:\tools\sccache\`,
  `setx SCCACHE_DIR U:\rust\sccache`, `setx RUSTC_WRAPPER sccache`.
- **Verify:** `sccache --show-stats`, then `cargo build` twice — 2nd run shows cache hits.
