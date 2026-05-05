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

[`boringssl.nim`](boringssl.nim) is a generated file. It is the concatenation of [`prelude.nim`](prelude.nim) — which carries the build glue (`{.compile:.}` directives for the C/assembly sources, compiler flags, platform guards) — and `tmp_boringssl_ffi.nim`, the raw FFI bindings produced by [futhark](https://github.com/PMunch/futhark) from the BoringSSL headers. See [Regenerating bindings](#regenerating-bindings) below.

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
