# RESOURCES — Official GitHub + Download Links

Canonical links only. Use for offline mirroring / allow-listing / vendoring.

## 1. Core Rust

| Name | Purpose | URL |
|---|---|---|
| rust-lang/rust | Compiler, stdlib, docs source | https://github.com/rust-lang/rust |
| rust-lang/rustup | Toolchain installer/manager | https://github.com/rust-lang/rustup |
| rust-lang/cargo | Package manager / build tool | https://github.com/rust-lang/cargo |
| rust-lang/rust-analyzer | Language server for IDEs | https://github.com/rust-lang/rust-analyzer |
| rust-lang/rustfmt | Formatter | https://github.com/rust-lang/rustfmt |
| rust-lang/clippy | Linter | https://github.com/rust-lang/clippy |
| rust-lang/miri | UB interpreter/checker | https://github.com/rust-lang/miri |
| Rust install page | Official Windows install entry | https://www.rust-lang.org/tools/install |
| rustup.rs | rustup landing page | https://rustup.rs |
| rustup Windows-MSVC prerequisites | MSVC setup for Rust | https://rust-lang.github.io/rustup/installation/windows-msvc.html |
| Other installation methods (offline) | Standalone installers | https://forge.rust-lang.org/infra/other-installation-methods.html |

## 2. Cargo tools

| Name | Purpose | URL |
|---|---|---|
| cargo-edit | `cargo add/rm/upgrade` | https://github.com/killercup/cargo-edit |
| cargo-watch | Rebuild/test on save | https://github.com/watchexec/cargo-watch |
| cargo-expand | Macro expansion viewer | https://github.com/dtolnay/cargo-expand |
| cargo-audit (+ RustSec monorepo) | Advisory audit | https://github.com/RustSec/rustsec |
| cargo-deny | Licenses/bans/sources policy | https://github.com/EmbarkStudios/cargo-deny |
| cargo-nextest | Parallel test runner | https://github.com/nextest-rs/nextest |
| cargo-llvm-cov | LLVM coverage | https://github.com/taiki-e/cargo-llvm-cov |
| cross | Docker cross-compile | https://github.com/cross-rs/cross |
| sccache | Shared compiler cache | https://github.com/mozilla/sccache |
| cargo-binstall | Prebuilt crate binaries | https://github.com/cargo-bins/cargo-binstall |
| cargo-wix | MSI from `Cargo.toml` | https://github.com/volks73/cargo-wix |

## 3. Microsoft toolchain / SDK / packaging

| Name | Purpose | URL |
|---|---|---|
| microsoft/vcpkg | C/C++ library manager | https://github.com/microsoft/vcpkg |
| microsoft/windows-rs | Rust bindings for Windows API | https://github.com/microsoft/windows-rs |
| VS downloads | Build Tools / Community | https://visualstudio.microsoft.com/downloads/ |
| VS C++ setup docs | C++ workload install | https://learn.microsoft.com/en-us/cpp/build/vscpp-step-0-installation |
| Build Tools component IDs | Exact workload IDs | https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2022 |
| VS CLI params | `--installPath`, `--layout`, `--nocache` | https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2022 |
| VS offline install | Layout / `--noweb` | https://learn.microsoft.com/en-us/visualstudio/install/create-an-offline-installation-of-visual-studio?view=vs-2022 |
| Acquire MSVC | MSVC acquisition guide | https://learn.microsoft.com/en-us/cpp/overview/acquire-msvc?view=msvc-170 |
| Redistributing C++ files | What you may ship | https://learn.microsoft.com/en-us/cpp/windows/redistributing-visual-cpp-files?view=msvc-170 |
| Windows SDK | SDK downloads | https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/ |
| VC Redist latest | Runtime downloads | https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist |
| winget-cli / winget-pkgs | Package manager + manifests | https://github.com/microsoft/winget-cli / https://github.com/microsoft/winget-pkgs |

## 4. Build dependencies

| Name | Purpose | URL |
|---|---|---|
| Kitware/CMake (+ downloads) | Build generator | https://github.com/Kitware/CMake / https://cmake.org/download/ |
| ninja-build/ninja (+ homepage) | Fast build backend | https://github.com/ninja-build/ninja / https://ninja-build.org/ |
| StrawberryPerl (+ releases) | Perl for OpenSSL builds | https://strawberryperl.com/ / https://strawberryperl.com/releases.html |
| nasm.us | Assembler for crypto crates | https://www.nasm.us/ |
| openssl/openssl (+ homepage) | TLS/crypto source | https://github.com/openssl/openssl / https://www.openssl.org/ |
| sqlite (+ homepage) | Embedded SQL | https://github.com/sqlite/sqlite / https://www.sqlite.org/download.html |
| libgit2/libgit2 | Git lib (`git2` crate) | https://github.com/libgit2/libgit2 |
| pkgconf/pkgconf | `pkg-config` impl | https://github.com/pkgconf/pkgconf |

## 5. Shell / editor / utils (Windows 10)

| Name | Purpose | URL |
|---|---|---|
| git-for-windows/git | Git source/SDK | https://github.com/git-for-windows/git |
| Git SCM Windows | Official installer | https://git-scm.com/download/win |
| Portable Git README | No-admin Git layout | https://github.com/git-for-windows/build-extra/blob/master/portable/root/README.portable |
| cli/cli (gh) | GitHub CLI | https://github.com/cli/cli |
| gh homepage | `gh` downloads/manual | https://cli.github.com/ |
| microsoft/vscode | VS Code source | https://github.com/microsoft/vscode |
| VS Code homepage | Windows downloads | https://code.visualstudio.com/ |
| VS Code Portable Mode | No-admin editor | https://code.visualstudio.com/docs/setup/portable |
| rust-analyzer Marketplace | VS Code extension | https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer |
| rust-analyzer Open VSX | VS Code extension mirror | https://open-vsx.org/extension/rust-lang/rust-analyzer |
| PowerShell | Shell source | https://github.com/PowerShell/PowerShell |
| PowerShell on Windows | Install docs | https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows |
| microsoft/terminal | Windows Terminal | https://github.com/microsoft/terminal |
| 7-Zip (+ source) | Unpack toolchains | https://www.7-zip.org/ / https://github.com/ip7z/7zip |
| wixtoolset/wix (+ homepage) | MSI toolset | https://github.com/wixtoolset/wix / https://wixtoolset.org/ |

## 6. Offline / vendor / proxy

| Name | Purpose | URL |
|---|---|---|
| `cargo vendor` docs | Vendor deps offline | https://doc.rust-lang.org/cargo/commands/cargo-vendor.html |
| Source replacement docs | crates.io → vendor | https://doc.rust-lang.org/cargo/reference/source-replacement.html |
| Cargo config / `[http]` / `net.offline` | Proxy, CA, offline | https://doc.rust-lang.org/cargo/reference/config.html |
| Cargo env vars | `CARGO_HTTP_*`, `HTTP_PROXY` | https://doc.rust-lang.org/stable/cargo/reference/environment-variables.html |
| rustup env vars / profiles | `RUSTUP_HOME`, `minimal` profile | https://rust-lang.github.io/rustup/environment-variables.html / https://rust-lang.github.io/rustup/concepts/profiles.html |

## 7. `static.rust-lang.org` distribution

| Name | Purpose | URL |
|---|---|---|
| channel-rust-stable.toml | Stable manifest (version + URLs + hashes) | https://static.rust-lang.org/dist/channel-rust-stable.toml |
| rustup-init MSVC x86_64 | `x86_64-pc-windows-msvc` installer | https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe |
| rustup-init GNU x86_64 | `x86_64-pc-windows-gnu` installer | https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-gnu/rustup-init.exe |
| sh.rustup.rs | Unix bootstrap | https://sh.rustup.rs |

## 8. Citrix / Defender / FSLogix admin docs (for IT ticket)

| Name | URL |
|---|---|
| Citrix Virtual Apps and Desktops docs | https://docs.citrix.com/en-us/citrix-virtual-apps-desktops |
| Profile Management exclusions | https://docs.citrix.com/en-us/citrix-virtual-apps-desktops/2607-ltsr/policies/reference/profile-management/file-system/exclusions-policy-settings.html |
| FSLogix `redirections.xml` | https://learn.microsoft.com/en-us/fslogix/concepts-redirections-xml |
| Defender exclusions | https://learn.microsoft.com/en-us/defender-endpoint/microsoft-defender-antivirus-exclusions-configure |
| Win32 Long Paths | https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=registry |
