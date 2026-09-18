# NASM — assembler for crypto crates

- **What / why:** Netwide Assembler. `ring`, `boringssl`/`aws-lc-sys`,
  `rav1e` asm paths fail without it (`nasm` not found / `C1083` on `.asm`).
- **Pinned version:** `3.02` stable (2026-06-29).
- **Source (official):** https://www.nasm.us/
  Direct: `https://www.nasm.us/pub/nasm/releasebuilds/3.02/win64/nasm-3.02-win64.zip`
  Index: https://www.nasm.us/pub/nasm/releasebuilds
- **License:** BSD-2-Clause — freely redistributable.
- **In this repo:** release `win10-devtools-v1` → `nasm-3.02-win64.zip`.
- **Offline install (no admin):** unzip to `U:\tools\nasm\`, add to user PATH.
- **Verify:** `nasm -v` → `NASM version 3.02`.
