# VSCodium portable — no-admin editor (MIT build of VS Code)

- **What / why:** Full VS Code-compatible editor without admin or Store.
  Runs from `U:\tools\VSCodium` in Portable Mode (`data\` folder), so
  settings/extensions stay on `U:` and out of roaming profiles.
  Chosen over Microsoft-branded VS Code because the binaries are MIT-licensed
  and safe to mirror; see Tier C in [README](README.md) for the licensing reason.
- **Pinned version:** `1.135.06055` (2026-09-09).
- **Source (official):** https://github.com/VSCodium/vscodium/releases
  (upstream editor: https://github.com/microsoft/vscode,
  downloads: https://code.visualstudio.com/,
  portable docs: https://code.visualstudio.com/docs/setup/portable)
  Direct: `https://github.com/VSCodium/vscodium/releases/download/1.135.06055/VSCodium-win32-x64-1.135.06055.zip`
  (~250 MB, `.sha256` on same page.)
- **License:** MIT — freely redistributable.
- **In this repo:** release `win10-devtools-v1` → same zip.
- **Offline install (no admin):** unzip to `U:\tools\VSCodium`, create
  `U:\tools\VSCodium\data\`, install LSP:
  `Code.exe --install-extension rust-analyzer.vsix --extensions-dir U:\tools\VSCodium\data\extensions`.
- **Verify:** extensions list shows `rust-analyzer`, no `%APPDATA%\Code` created,
  Rust hover/`F12` works in a cargo project.
