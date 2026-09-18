<#
.SYNOPSIS
  Fetch all Tier-A vendor files from their OFFICIAL URLs (run on a connected machine).
.DESCRIPTION
  Downloads the exact pinned versions documented in vendor/*.md into -OutDir.
  Copy that folder to the offline Citrix box (or let CI upload it to the
  win10-devtools-v1 release). Uses a browser UA for the Marketplace VSIX.
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\scripts\Download-Vendor.ps1 -OutDir .\vendor-dl
#>
[CmdletBinding()]
param([string]$OutDir = ".\vendor-dl")

$ErrorActionPreference = "Stop"
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
$OutDir = (Resolve-Path $OutDir).Path

$files = @(
  @{ Name = "ninja-win.zip"; Url = "https://github.com/ninja-build/ninja/releases/download/v1.13.2/ninja-win.zip" },
  @{ Name = "nasm-3.02-win64.zip"; Url = "https://www.nasm.us/pub/nasm/releasebuilds/3.02/win64/nasm-3.02-win64.zip" },
  @{ Name = "7zr.exe"; Url = "https://www.7-zip.org/a/7zr.exe" },
  @{ Name = "sccache-v0.18.0-x86_64-pc-windows-msvc.zip"; Url = "https://github.com/mozilla/sccache/releases/download/v0.18.0/sccache-v0.18.0-x86_64-pc-windows-msvc.zip" },
  @{ Name = "cargo-binstall-x86_64-pc-windows-msvc.zip"; Url = "https://github.com/cargo-bins/cargo-binstall/releases/download/v1.23.0/cargo-binstall-x86_64-pc-windows-msvc.zip" },
  @{ Name = "vc_redist.x64.exe"; Url = "https://aka.ms/vs/17/release/vc_redist.x64.exe" },
  @{ Name = "cmake-4.4.3-windows-x86_64.zip"; Url = "https://github.com/Kitware/CMake/releases/download/v4.4.3/cmake-4.4.3-windows-x86_64.zip" },
  @{ Name = "PortableGit-2.55.0.5-64-bit.7z.exe"; Url = "https://github.com/git-for-windows/git/releases/download/v2.55.0.windows.5/PortableGit-2.55.0.5-64-bit.7z.exe" },
  @{ Name = "rust-analyzer.vsix"; Url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/rust-lang/vsextensions/rust-analyzer/latest/vspackage"; UA = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" },
  @{ Name = "winlibs-x86_64-posix-seh-gcc-16.2.0-mingw-w64ucrt-14.0.0-r1.7z"; Url = "https://github.com/brechtsanders/winlibs_mingw/releases/download/16.2.0posix-14.0.0-ucrt-r1/winlibs-x86_64-posix-seh-gcc-16.2.0-mingw-w64ucrt-14.0.0-r1.7z" },
  @{ Name = "VSCodium-win32-x64-1.135.06055.zip"; Url = "https://github.com/VSCodium/vscodium/releases/download/1.135.06055/VSCodium-win32-x64-1.135.06055.zip" }
)

foreach ($f in $files) {
  $dest = Join-Path $OutDir $f.Name
  if (Test-Path $dest) { Write-Host "  skip (exists): $($f.Name)"; continue }
  Write-Host "==> $($f.Name)"
  if ($f.UA) {
    Invoke-WebRequest -Uri $f.Url -OutFile $dest -UserAgent $f.UA
  } else {
    Invoke-WebRequest -Uri $f.Url -OutFile $dest
  }
  Write-Host ("  {0:N1} MB" -f ((Get-Item $dest).Length / 1MB))
}
Write-Host "Done -> $OutDir"
Get-ChildItem $OutDir | Format-Table Name, @{N="MB";E={[math]::Round($_.Length/1MB,1)}} -AutoSize
