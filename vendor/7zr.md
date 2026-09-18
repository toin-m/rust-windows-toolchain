# 7zr — bootstrap extractor (unpack everything else offline)

- **What / why:** Standalone 7-Zip console extractor (~500 KB, no install).
  Unpacks the `.7z`/`.zip` assets in `win10-devtools-v1`
  (PortableGit `.7z.exe`, WinLibs `.7z`) on a box with no 7-Zip/WinRAR.
- **Pinned version:** 7-Zip `24.09`.
- **Source (official):** https://www.7-zip.org/download.html
  Direct: `https://www.7-zip.org/a/7zr.exe`
  Full 7-Zip: https://github.com/ip7z/7zip/releases
- **License:** LGPL + unRAR restriction — freely redistributable as-is.
- **In this repo:** release `win10-devtools-v1` → `7zr.exe`.
- **Offline install:** copy to `U:\tools\7zr\7zr.exe`, add to PATH.
- **Verify:** `7zr` prints version `24.09`. Usage: `7zr x file.7z -oU:\tools\Git`.
