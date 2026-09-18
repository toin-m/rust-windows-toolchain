<#
.SYNOPSIS
  Verify Rust + MSVC/GNU setup as a standard (non-admin) user.
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\scripts\Verify.ps1
#>
$ErrorActionPreference = "Continue"
$fail = 0
function Check([string]$name, [scriptblock]$b) {
  try { & $b; Write-Host "PASS: $name" -ForegroundColor Green }
  catch { Write-Host "FAIL: $name — $($_.Exception.Message)" -ForegroundColor Red; $script:fail++ }
}

Write-Host "=== env ==="
Write-Host "RUSTUP_HOME=$env:RUSTUP_HOME"
Write-Host "CARGO_HOME=$env:CARGO_HOME"
Write-Host "CARGO_TARGET_DIR=$env:CARGO_TARGET_DIR"

Check "rustc --version"   { rustc --version }
Check "cargo --version"   { cargo --version }
Check "rustup show"       { rustup show }
Check "cl.exe resolves"   { where.exe cl }
Check "link.exe resolves" { where.exe link }
Check "cargo fmt"         { cargo fmt --version }
Check "cargo clippy"      { cargo clippy --version }

$demo = Join-Path ([IO.Path]::GetTempPath()) ("rust-hello-" + $env:USERNAME)
Check "cargo new/run (msvc)" {
  if (Test-Path $demo) { Remove-Item -Recurse -Force $demo }
  cargo new --bin $demo | Out-Null
  Push-Location $demo
  try { cargo run --quiet }
  finally { Pop-Location }
}

if ((rustup target list --installed) -match "x86_64-pc-windows-gnu") {
  Check "cargo build (gnu)" {
    Push-Location $demo
    try { cargo build --quiet --target x86_64-pc-windows-gnu }
    finally { Pop-Location }
  }
} else {
  Write-Host "SKIP: gnu target not installed (rustup target add x86_64-pc-windows-gnu)" -ForegroundColor Yellow
}

Write-Host "=== long paths ==="
try {
  $lp = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name LongPathsEnabled -ErrorAction Stop).LongPathsEnabled
  Write-Host "LongPathsEnabled=$lp (want 1; 0 needs IT GPO)"
} catch { Write-Host "LongPathsEnabled=unknown (no HKLM read)" }

if ($fail -gt 0) { Write-Host "$fail check(s) FAILED" -ForegroundColor Red; exit 1 }
Write-Host "All checks passed." -ForegroundColor Green
