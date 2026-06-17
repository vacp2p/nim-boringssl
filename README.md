# nim-boringssl

Nim FFI bindings for [BoringSSL](https://boringssl.googlesource.com/boringssl/) — Google's fork of OpenSSL.

The package vendors a curated subset of BoringSSL sources (libcrypto + libssl) and compiles them directly through the Nim build system: no CMake, no FIPS module, no test/tool binaries. Optimised assembly is enabled by default on supported platforms.

- **Author**: Status Research & Development GmbH
- **License**: Apache-2.0 OR MIT
- **Nim**: `>= 2.0.0`

## Installation

```sh
nimble install boringssl
```

Or pin in your `.nimble`:

```nim
requires "boringssl"
```

The BoringSSL sources live in a git submodule that tracks our [`vacp2p/boringssl`](https://github.com/vacp2p/boringssl) fork. The fork exists to carry small portability patches on top of upstream — currently a Windows-specific fallback to portable C for the `fiat_p256_adx_mul` / `fiat_p256_adx_sqrt` routines, which fail to assemble cleanly under llvm-mingw.

When working from a clone, initialise submodules:

```sh
git clone --recursive https://github.com/vacp2p/nim-boringssl.git
# or, after a plain clone:
git submodule update --init --recursive
```

## Usage

```nim
import boringssl
```

The bindings expose BoringSSL's C API; refer to the headers under [`boringssl/include/openssl/`](boringssl/include/openssl/) for the available symbols.

[`boringssl.nim`](boringssl.nim) is a generated file. It is the concatenation of [`prelude.nim`](prelude.nim) — which carries the build glue (`{.compile:.}` directives for the C/assembly sources, compiler flags, platform guards) — and `tmp_boringssl_ffi.nim`, the raw FFI bindings produced by [futhark](https://github.com/PMunch/futhark) from the BoringSSL headers. Most compatible C++ sources are compiled through unity chunks under [`boringssl_units/`](boringssl_units/) to reduce compiler invocations. See [Regenerating bindings](#regenerating-bindings) below.

BoringSSL is a C++ library, so [`config.nims`](config.nims) overrides the linker to `g++` (Linux), `clang++` (macOS) for downstream builds. Windows uses the default `clang` toolchain.

## Build options

| Define | Default | Effect |
|--------|---------|--------|
| `-d:BORINGSS_USE_ASM=false` | `true` | Disable optimised assembly sources (portable C only) |
| `-d:fast` | off | Used by the test task; enables faster builds |

### Platform notes

- **Windows**: builds with `clang` (llvm-mingw) and assembles `.asm` files with [NASM](https://www.nasm.us/). NASM must be on `PATH`.
- **Linux i386**: requires `-msse2` (set automatically).
- **Threads**: bindings are built with `--threads:on` for testing; downstream consumers may build either way.

## Regenerating bindings

The committed [`boringssl.nim`](boringssl.nim) only needs to be regenerated when the BoringSSL submodule is bumped or when the set of imported headers in [`generate_boringssl_ffi.nim`](generate_boringssl_ffi.nim) changes. The [`build.sh`](build.sh) script drives the whole flow:

```sh
./build.sh
```

It installs `futhark@0.15.0`, runs `generate_boringssl_ffi.nim` to emit `tmp_boringssl_ffi.nim`, and prepends `prelude.nim` to produce the final `boringssl.nim`.

## Updating BoringSSL and releasing

BoringSSL updates are meant to flow through automation, with manual review at the pull request boundaries. The process spans two repositories:

1. [`vacp2p/boringssl`](https://github.com/vacp2p/boringssl) syncs from canonical upstream BoringSSL.
2. This repository consumes the updated fork through the `boringssl` submodule, regenerates Nim bindings, bumps the Nimble patch version, and releases the new package version.

### Fork sync

The fork's [`sync-upstream.yml`](https://github.com/vacp2p/boringssl/blob/main/.github/workflows/sync-upstream.yml) workflow runs weekly and can also be started manually. It uses `.vac/scripts/sync_upstream.py` to:

- resolve canonical upstream `https://boringssl.googlesource.com/boringssl` `main`;
- cross-check the `google/boringssl` GitHub mirror;
- verify the new upstream SHA is a fast-forward from `.vac/boringssl-upstream.json`;
- replay the local Windows `fiat_p256` patch from `.vac/patches/fiat-p256-windows.patch`;
- verify the ADX dispatch remains absent from `third_party/fiat/p256_64.h`;
- open or update the `automation/boringssl-upstream-sync` PR.

After that PR is reviewed and merged into the fork's `main`, the fork's [`notify-nim-boringssl.yml`](https://github.com/vacp2p/boringssl/blob/main/.github/workflows/notify-nim-boringssl.yml) workflow checks whether `.vac/boringssl-upstream.json` changed. If it did, it sends a `repository_dispatch` event named `boringssl-updated` to this repository, including the new fork commit SHA.

### Binding update

This repository receives that dispatch in [`update-boringssl.yml`](.github/workflows/update-boringssl.yml). The workflow can also be started manually with a `boringssl_sha` input when a specific fork commit needs to be tested.

The update workflow:

- checks out `master` and the `boringssl` submodule;
- resolves the requested fork SHA, or `main` when no SHA is provided;
- moves the submodule to that commit;
- runs [`build.sh`](build.sh) to regenerate [`boringssl.nim`](boringssl.nim);
- bumps the patch version in [`boringssl.nimble`](boringssl.nimble) when the submodule or generated bindings changed;
- runs `nimble install` and `nimble test --styleCheck:off --verbose --debug`;
- opens or updates the `automation/update-boringssl-submodule` PR.

Review that PR as the package update: check the submodule SHA, generated binding diff, Nimble version bump, and CI results before merging.

### Release

Releases are driven by the version in [`boringssl.nimble`](boringssl.nimble). When the update PR is merged to `master`, [`release.yml`](.github/workflows/release.yml) runs on the `boringssl.nimble` change. If the version changed and tag `vX.Y.Z` does not already exist, it creates a GitHub release for that tag with generated notes.

Both repositories' automation requires `BORINGSSL_UPDATE_BOT_TOKEN` for cross-repository PR and dispatch operations. The sync/update workflows also create or update failure issues when automation cannot complete, so failed runs should be handled there before retrying.

## Testing

```sh
nimble test          # debug build
nimble test_release  # -d:release build
```

Pass extra flags through `NIMFLAGS`, e.g.:

```sh
NIMFLAGS="--mm:orc" nimble test
```

CI exercises Linux (amd64, i386, gcc-14), macOS (arm64) and Windows (amd64) against Nim 2.2 with both `refc` and `orc` memory managers.

## Formatting

Code is formatted with [`nph`](https://github.com/arnetheduck/nph):

```sh
nimble format
```

## License

Licensed under either of [Apache License, Version 2.0](LICENSE-APACHEv2) or [MIT license](LICENSE-MIT) at your option. BoringSSL itself is distributed under its own [licenses](boringssl/LICENSE).
