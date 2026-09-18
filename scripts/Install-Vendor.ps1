<#
.SYNOPSIS
  Offline install of Tier-A vendor tools on the locked-down box (no admin).
.DESCRIPTION
  Reads release assets from -AssetDir (copies of win10-devtools-v1 files),
  extracts to U:\tools layout, wires user PATH + cargo/rust env.
  vc_redist.x64.exe needs admin — it is staged, not run (hand to IT).
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\scripts\Install-Vendor.ps1 -AssetDir D:\transfer\win10-devtools-v1
#>
[CmdletBinding()]
param(
  [string]$AssetDir = ".\vendor-dl",
  [string]$ToolsRoot = "U:\tools",
  [string]$RustRoot = "U:\rust"
)

$ErrorActionPreference = "Stop"
function Need([string]$p) { if (-not (Test-Path $p)) { throw "Missing: $p" } }

$sevenZr = Join-Path $ToolsRoot "7zr\7zr.exe"
if (-not (Test-Path $sevenZr)) {
  $src = Join-Path $AssetDir "7zr.exe"; Need $src
  New-Item -ItemType Directory -Force (Split-Path $sevenZr) | Out-Null
  Copy-Item $src $sevenZr
}
function Unzip([string]$zip, [string]$dest) {
  Need $zip; New-Item -ItemType Directory -Force $dest | Out-Null
  Write-Host "==> $zip -> $dest"
  & $sevenZr x $zip "-o$dest" -y | Out-Null
}
function Add-UserPath([string]$dir) {
  $cur = [Environment]::GetEnvironmentVariable("Path", "User")
  if (($cur -split ";") -notcontains $dir) {
    [Environment]::SetEnvironmentVariable("Path", "$cur;$dir", "User")
    $env:Path += ";$dir"; Write-Host "  + PATH: $dir"
  }
}

$CargoBin = Join-Path $RustRoot ".cargo\bin"

# 1. PortableGit (needs post-install)
$gitDir = Join-Path $ToolsRoot "Git"
if (-not (Test-Path (Join-Path $gitDir "cmd\git.exe"))) {
  & $sevenZr x (Join-Path $AssetDir "PortableGit-2.55.0.5-64-bit.7z.exe") "-o$gitDir" -y | Out-Null
  & (Join-Path $gitDir "post-install.bat")
}
Add-UserPath (Join-Path $gitDir "cmd")

# 2. Small tools
Unzip (Join-Path $AssetDir "ninja-win.zip") (Join-Path $ToolsRoot "ninja")
Unzip (Join-Path $AssetDir "nasm-3.02-win64.zip") (Join-Path $ToolsRoot "nasm")
Unzip (Join-Path $AssetDir "cmake-4.4.3-windows-x86_64.zip") (Join-Path $ToolsRoot "cmake")
Unzip (Join-Path $AssetDir "sccache-v0.18.0-x86_64-pc-windows-msvc.zip") (Join-Path $ToolsRoot "sccache")
Unzip (Join-Path $AssetDir "cargo-binstall-x86_64-pc-windows-msvc.zip") $CargoBin
Unzip (Join-Path $AssetDir "winlibs-x86_64-posix-seh-gcc-16.2.0-mingw-w64ucrt-14.0.0-r1.7z") $ToolsRoot
Unzip (Join-Path $AssetDir "VSCodium-win32-x64-1.135.06055.zip") (Join-Path $ToolsRoot "VSCodium")
New-Item -ItemType Directory -Force (Join-Path $ToolsRoot "VSCodium\data") | Out-Null

foreach ($d in @("$ToolsRoot\ninja","$ToolsRoot\nasm","$ToolsRoot\cmake\bin","$ToolsRoot\sccache","$ToolsRoot\mingw64\bin")) {
  if (Test-Path $d) { Add-UserPath $d }
}
Add-UserPath $CargoBin

# 3. rust-analyzer into portable VSCodium
$vsix = Join-Path $AssetDir "rust-analyzer.vsix"; Need $vsix
& (Join-Path $ToolsRoot "VSCodium\bin\codium.cmd") --install-extension $vsix `
  --extensions-dir (Join-Path $ToolsRoot "VSCodium\data\extensions")

Write-Host ""
Write-Host "Staged (needs IT/admin, NOT run): $(Join-Path $AssetDir 'vc_redist.x64.exe')"
Write-Host "Next: open a NEW terminal, run .\scripts\Install-User.ps1 then .\scripts\Verify.ps1"
