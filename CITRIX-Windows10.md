# CITRIX-Windows10 — Rust Dev on Citrix VDI (No-Admin, Non-Persistent)

Assumes pooled/non-persistent MCS/PVS catalog on Windows 10, standard user
(no admin), UPM or FSLogix profiles, folder redirection, managed Defender,
TLS-inspecting proxy, blocked Store/winget. Adjust drive letters to yours
(`U:` = persistent home share below).

Citrix root docs: https://docs.citrix.com/en-us/citrix-virtual-apps-desktops

## 1. What breaks and why

| Citrix constraint | Effect on Rust |
|---|---|
| No local admin — can't write `C:\Program Files` / `HKLM` | VS Installer officially requires admin: https://learn.microsoft.com/en-us/visualstudio/install/deploy-a-layout-onto-a-client-machine?view=vs-2022 |
| Non-persistent `C:` / `AppData\Local` wiped on reboot | `.rustup` (1.5–3 GB per toolchain), `.cargo` registry (1–3 GB), `target/` (2–10 GB per project) vanish |
| UPM/FSLogix syncs `%USERPROFILE%` at logon/logoff | 5–30 min logons, VHDX bloat, file-lock errors |
| Redirected `Documents`/`Desktop` → `\\fileserver\…` | Cargo does 10k+ small files + hardlinks — SMB latency/locks fail builds |
| Managed Defender, no self-exclusions | Every `rustc`/`link.exe` call scanned. Exclusions doc: https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-antivirus-exclusions-configure |
| Proxy + TLS inspection, custom corp CA | `rustup` (vendored curl) + `cargo` ignore Windows cert store when `CAINFO` set — need explicit PEM or `60 unable to get local issuer` |
| Blocked Store/winget/USB/AppLocker | Must use IT-pushed layout or approved portable `.zip` on `U:` / golden image |
| Win32 Long Paths OFF (`LongPathsEnabled=0`) | Cargo `registry\src\…` > 260 chars fails. Fix needs IT GPO: https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=registry |

## 2. Layout that survives reboot (no admin)

Golden rule: **MSVC goes in the golden image / IT layout; everything else
is user-scope on persistent `U:`.**

```powershell
# Run at each logon (logon script / first cell of scripts/Install-User.ps1)
$Root  = "U:\rust"
$Tools = "U:\tools"
[Environment]::SetEnvironmentVariable("RUSTUP_HOME","$Root\.rustup","User")
[Environment]::SetEnvironmentVariable("CARGO_HOME","$Root\.cargo","User")
[Environment]::SetEnvironmentVariable("CARGO_TARGET_DIR","C:\Temp\$env:USERNAME\target","User")
[Environment]::SetEnvironmentVariable("SCCACHE_DIR","$Root\sccache","User")
```

| Tool | Portable layout (no admin) |
|---|---|
| rustup/cargo | Pre-download `rustup-init.exe` from this repo's Releases on a connected host. On VDI:<br>`$env:RUSTUP_HOME="U:\rust\.rustup"; $env:CARGO_HOME="U:\rust\.cargo"`<br>`.\rustup-init.exe --no-modify-path -y --profile minimal --default-toolchain stable-x86_64-pc-windows-msvc`<br>Docs: https://rust-lang.github.io/rustup/installation/index.html, https://rust-lang.github.io/rustup/environment-variables.html, https://rust-lang.github.io/rustup/concepts/profiles.html |
| MSVC Build Tools | **Do NOT zip/copy.** Ask IT to bake into image or host a layout:<br>`vs_buildtools.exe --layout U:\VSLayout --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.Windows11SDK.22621 --lang en-US`<br>(IT, admin) `vs_buildtools.exe --installPath "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools" --add Microsoft.VisualStudio.Workload.VCTools --nocache --wait --passive`<br>Docs: https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2022, https://learn.microsoft.com/en-us/visualstudio/install/create-an-offline-installation-of-visual-studio?view=vs-2022 |
| GNU fallback if MSVC denied | `rustup toolchain add stable-x86_64-pc-windows-gnu` + portable MinGW ZIP → `U:\tools\mingw64` (no admin; proves `cargo build`, but some `-sys` crates still need MSVC) |
| Git | `PortableGit-*.7z.exe` → `U:\tools\Git`, run `post-install.bat`. https://git-scm.com/install/windows, https://github.com/git-for-windows/build-extra/blob/master/portable/root/README.portable |
| VS Code | `VSCode-win32-x64-*.zip` → `U:\tools\VSCode` + create `U:\tools\VSCode\data\` (Portable Mode: https://code.visualstudio.com/docs/setup/portable). Offline ext: `code --install-extension rust-analyzer.vsix --extensions-dir U:\tools\VSCode\data\extensions` |
| sccache | Release ZIP → `U:\tools\sccache\sccache.exe`, `SCCACHE_DIR=U:\rust\sccache` |
| Cargo offline | Connected host: `cargo fetch` + `cargo vendor vendor` → copy `vendor/` + `Cargo.lock` + `.cargo/config.toml` to VDI → `cargo build --offline`. Docs: https://doc.rust-lang.org/cargo/commands/cargo-vendor.html, https://doc.rust-lang.org/cargo/reference/source-replacement.html |

`CARGO_TARGET_DIR` must be **local fast, non-roaming**:
`C:\Temp\%USERNAME%\target` (fast, rebuilt per boot) or `U:\rust\target`
(persistent, slower). Never `%USERPROFILE%`, never redirected `Documents`.

## 3. Stop profile bloat (ask IT)

Defaults: `.cargo\registry` + `git\db` = 1–3 GB; each
`.rustup\toolchains\stable-*` = 1.5–3 GB; each `target\debug` = 2–10 GB.

UPM exclusions (`Profile Management > File system`, relative to
`%USERPROFILE%`, no leading `\`):
https://docs.citrix.com/en-us/citrix-virtual-apps-desktops/2607-ltsr/policies/reference/profile-management/file-system/exclusions-policy-settings.html

```
.cargo\registry
.cargo\git
.rustup\toolchains
.rustup\downloads
AppData\Local\rustup
source\repos\*\target
VSCode\data\tmp
sccache
```

FSLogix `redirections.xml` equivalent (`RedirXMLSourceFolder`):
https://learn.microsoft.com/en-us/fslogix/concepts-redirections-xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<FrxProfileFolderRedirection ExcludeCommonFolders="0">
<Excludes>
<Exclude Copy="0">.cargo\registry</Exclude>
<Exclude Copy="0">.cargo\git</Exclude>
<Exclude Copy="0">.rustup\downloads</Exclude>
<Exclude Copy="0">.rustup\toolchains</Exclude>
</Excludes>
</FrxProfileFolderRedirection>
```

Best option: keep `RUSTUP_HOME`/`CARGO_HOME` on `U:` outside the
container entirely. Defender exclusion ticket: `U:\rust\`, `U:\tools\`,
`C:\Temp\%USERNAME%\target`, processes
`rustc.exe,cargo.exe,sccache.exe,cl.exe,link.exe,rust-analyzer.exe`.

## 4. Proxy + corp CA + offline

Cargo refs: https://doc.rust-lang.org/stable/cargo/reference/environment-variables.html,
https://doc.rust-lang.org/nightly/cargo/reference/config.html

```powershell
$env:HTTP_PROXY="http://proxy.corp:8080"; $env:HTTPS_PROXY="http://proxy.corp:8080"
$env:NO_PROXY="localhost,127.0.0.1,.corp.local"
# Ask PKI team for corp root+intermediates PEM:
$env:CARGO_HTTP_CAINFO="U:\certs\corp-bundle.pem"
```

`%CARGO_HOME%\config.toml` (persistent on `U:`, see
`config/cargo-config.example.toml` in this repo):

```toml
[http]
proxy = "http://proxy.corp:8080"
cainfo = "U:\\certs\\corp-bundle.pem"
timeout = 60
# check-revoke = false  # only with security approval if CRL is blocked
[net]
offline = false
[source.crates-io]
replace-with = "vendored-sources"
[source.vendored-sources]
directory = "vendor"
```

`rustup` inherits `HTTP(S)_PROXY`; if `rustup update` fails with `60`,
reuse the same PEM or pre-download tarballs from
`https://static.rust-lang.org/dist/` + `rustup toolchain link`.

## 5. Verify as standard user

```powershell
.\scripts\Verify.ps1
```

Pass = `cl`/`link` resolve without admin, `cargo new/run` works for
`msvc` (and `gnu` if required), Portable VS Code shows `rust-analyzer`
with no `%APPDATA%\Code` created, `RUSTUP_HOME`/`CARGO_HOME` resolve to
`U:`, `target/` lands outside the profile, `cargo build --offline`
works from `vendor/`. If
`reg query HKLM\…\FileSystem /v LongPathsEnabled` is `0`, keep paths
short (`U:\r\proj`, `C:\T\t`) until IT enables the GPO.

## 6. What to hand IT (copy-paste ticket)

1. Bake `VS Build Tools 2022` + `Windows SDK 22621/26100` + `VC Redist`
   into the Win10 golden image (or approved `--layout` share).
2. Enable Win32 Long Paths GPO + keep `U:` persistent with `\\share`
   execution allowed for `rustup-init.exe`/`PortableGit`/`VSCode.zip`.
3. Apply UPM/FSLogix exclusions from §3 + Defender exclusions for
   `U:\rust`, `U:\tools`, `C:\Temp\%USERNAME%\target`.
4. Publish corp proxy + PEM bundle path + allow
   `static.rust-lang.org`, `crates.io`, `github.com` (or provide
   vendored mirror).
