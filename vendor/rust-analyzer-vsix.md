# rust-analyzer VSIX — offline editor brains

- **What / why:** Rust LSP (go-to-def, completion, `cargo check` on save).
  Needs `rust-src` component (`rustup component add rust-src`) for std jumps.
  Offline VDI can't reach the Marketplace, so the `.vsix` is mirrored here.
- **Pinned version:** latest Marketplace build at vendor date (~19 MB).
  Check exact build: `code --list-extensions --show-versions | findstr rust-analyzer`.
- **Source (official):** https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer
  Direct (browser UA): `https://marketplace.visualstudio.com/_apis/public/gallery/publishers/rust-lang/vsextensions/rust-analyzer/latest/vspackage`
  Mirror: https://open-vsx.org/extension/rust-lang/rust-analyzer
  Source code: https://github.com/rust-lang/rust-analyzer
- **License:** MIT/Apache-2.0 — freely redistributable.
- **In this repo:** release `win10-devtools-v1` → `rust-analyzer.vsix`.
- **Offline install:** `code --install-extension rust-analyzer.vsix`
  (portable: add `--extensions-dir U:\tools\VSCodium\data\extensions`).
- **Verify:** open a cargo project → hover/`F12` on a std type resolves.
