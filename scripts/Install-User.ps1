<#
.SYNOPSIS
  User-scope Rust bootstrap for locked-down Windows 10 (Citrix VDI, no admin).
.DESCRIPTION
  Sets RUSTUP_HOME / CARGO_HOME / CARGO_TARGET_DIR to persistent locations,
  installs rustup without touching machine PATH, adds user PATH entries,
  installs the MSVC toolchain + GNU target + core components.
  MSVC Build Tools themselves still require IT (see CITRIX-Windows10.md §2).
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\scripts\Install-User.ps1
  powershell -ExecutionPolicy Bypass -File .\scripts\Install-User.ps1 -RustRoot U:\rust -Toolchain stable-x86_64-pc-windows-msvc
#>
[CmdletBinding()]
param(
  [string]$RustRoot = "U:\rust",
  [string]$ToolsRoot = "U:\tools",
  [string]$Toolchain = "stable-x86_64-pc-windows-msvc",
  [string]$RustupInit = ".\rustup-init.exe",
  [switch]$IncludeGnu,
  [switch]$SkipRustup
)

$ErrorActionPreference = "Stop"

$CargoHome  = Join-Path $RustRoot ".cargo"
$RustupHome = Join-Path $RustRoot ".rustup"
$TargetDir  = Join-Path "C:\Temp\$env:USERNAME" "target"

Write-Host "==> Rust root : $RustRoot"
Write-Host "==> CARGO_HOME: $CargoHome"
Write-Host "==> RUSTUP_HOME: $RustupHome"
Write-Host "==> TARGET_DIR: $TargetDir"

foreach ($d in @($RustRoot, $CargoHome, $RustupHome, $TargetDir, $ToolsRoot)) {
  if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d | Out-Null }
}

[Environment]::SetEnvironmentVariable("RUSTUP_HOME", $RustupHome, "User")
[Environment]::SetEnvironmentVariable("CARGO_HOME", $CargoHome, "User")
[Environment]::SetEnvironmentVariable("CARGO_TARGET_DIR", $TargetDir, "User")
$env:RUSTUP_HOME = $RustupHome
$env:CARGO_HOME = $CargoHome
$env:CARGO_TARGET_DIR = $TargetDir

function Add-UserPath([string]$dir) {
  $cur = [Environment]::GetEnvironmentVariable("Path", "User")
  if ($cur -split ";" | Where-Object { $_ -ieq $dir }) { return }
  [Environment]::SetEnvironmentVariable("Path", "$cur;$dir", "User")
  $env:Path += ";$dir"
  Write-Host "  + user PATH: $dir"
}

if (-not $SkipRustup) {
  if (-not (Test-Path $RustupInit)) { throw "Missing $RustupInit. Copy it from this repo's Releases first." }
  Write-Host "==> Running rustup-init ($Toolchain, --no-modify-path)…"
  & $RustupInit --no-modify-path -y --profile minimal --default-toolchain $Toolchain
}

Add-UserPath (Join-Path $CargoHome "bin")
Add-UserPath (Join-Path $ToolsRoot "sccache")
Add-UserPath (Join-Path $ToolsRoot "Git\cmd")

Write-Host "==> rustup toolchain + components…"
& (Join-Path $CargoHome "bin\rustup.exe") toolchain install $Toolchain --profile minimal
& (Join-Path $CargoHome "bin\rustup.exe") default $Toolchain
& (Join-Path $CargoHome "bin\rustup.exe") component add rustfmt clippy rust-analyzer rust-src
if ($IncludeGnu) {
  & (Join-Path $CargoHome "bin\rustup.exe") target add x86_64-pc-windows-gnu
  Write-Host "NOTE: GNU target needs MinGW-w64 gcc in PATH (U:\tools\mingw64\bin)."
}

Write-Host "==> Done. Open a NEW terminal, then run .\scripts\Verify.ps1"
