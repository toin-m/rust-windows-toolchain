# PortableGit — git without admin (cargo requires git)

- **What / why:** `cargo` shells out to `git` for git deps, `cargo vendor`,
  and `vcpkg` bootstrap. Portable layout runs from `U:\tools\Git`, no admin.
- **Pinned version:** `v2.55.0.windows.5` (2026-08-20).
- **Source (official):** https://git-scm.com/download/win /
  https://github.com/git-for-windows/git/releases
  Direct: `https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.5/PortableGit-2.55.0.5-64-bit.7z.exe`
  Portable docs: https://github.com/git-for-windows/build-extra/blob/master/portable/root/README.portable
- **License:** GPL-2.0 — freely redistributable (keep license notice).
- **In this repo:** release `win10-devtools-v1` → same `.7z.exe` (~60 MB).
- **Offline install (no admin):** extract with `7zr x PortableGit-….7z.exe -oU:\tools\Git`,
  run `U:\tools\Git\post-install.bat`, add `U:\tools\Git\cmd` to user PATH.
- **Verify:** `git --version` → `2.55.0.windows.5`; `cargo new hello` works.
