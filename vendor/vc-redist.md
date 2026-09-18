# VC Redist x64 — run Rust-built `.exe` on machines without VS

- **What / why:** `VC_redist.x64.exe` (~24 MB). Any Rust MSVC binary linked
  against the dynamic CRT needs `msvcp140.dll`/`vcruntime140.dll` at runtime.
  Ship/run this once per target machine.
- **Pinned version:** VS 2022 17.x / VC 14.44 (current at vendor date).
- **Source (official):** https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist
  Direct: `https://aka.ms/vs/17/release/vc_redist.x64.exe`
  (x86: `…/vc_redist.x86.exe`, ARM64: `…/vc_redist.arm64.exe`)
- **License:** Microsoft — **explicitly redistributable** unmodified by
  licensed VS users (see Redist.txt / https://learn.microsoft.com/en-us/cpp/windows/redistributing-visual-cpp-files?view=msvc-170).
- **In this repo:** release `win10-devtools-v1` → `vc_redist.x64.exe`.
- **Install:** needs admin — hand to IT, or `vc_redist.x64.exe /install /quiet /norestart`.
  App-local alternative: copy the `VC\Redist\MSVC\…\x64\*.dll` next to your `.exe`.
- **Verify:** your `hello.exe` runs on a clean Win10 image after install.
