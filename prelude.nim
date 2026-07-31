# SPDX-License-Identifier: Apache-2.0 OR MIT
# Copyright (c) Status Research & Development GmbH

# libcrypto + libssl sources without cmake, no-asm, no fips, no tests, tools
# TODO: look into use assembly files for perf

import std/[os, strutils]

include boringssl_types

# ----- toolchain + includes -----
{.localPassC: "-DBORINGSSL_IMPLEMENTATION -DS2N_BN_HIDE_SYMBOLS".}

{.
  localPassC:
    "-fno-common -fvisibility=hidden -fno-strict-aliasing -Werror -Wformat=2 -Wsign-compare -Wwrite-strings -Wvla -Wshadow -Wtype-limits -Wmissing-field-initializers -ffunction-sections -fdata-sections -fno-exceptions -fno-rtti"
.}

const
  # use rsplit as a workaround for cross compilation path separator issue
  srcPath = currentSourcePath.rsplit({DirSep, AltSep}, 1)[0]

{.passc: "-I" & srcPath & "/boringssl/include".}

{.localPassC: "-DNDEBUG".}

when defined(linux):
  {.localPassC: "-D_XOPEN_SOURCE=700".}
elif defined(windows):
  {.
    localPassC:
      "-D_HAS_EXCEPTIONS=0 -DWIN32_LEAN_AND_MEAN -DNOMINMAX -D_CRT_SECURE_NO_WARNINGS"
  .}

when defined(i386):
  {.passc: "-msse2".}

when defined(windows):
  {.passl: "-lws2_32".}
  when defined(clang):
    {.passl: "-lpthread".}

# {.localPassC.} above only applies to the C file generated from this Nim
# module; it does NOT reach the files added with {.compile.} below. Pass the
# visibility flag per file (two-argument compile pragma) so the BoringSSL
# objects are really built with hidden visibility. Otherwise every BoringSSL
# symbol is exported -- and interposable by a host-process OpenSSL -- in any
# shared library built from code that imports this package
# (see logos-messaging/logos-delivery#4085).
const boringsslPerFileFlags = when defined(windows): "" else: "-fvisibility=hidden"

const BORINGSS_USE_ASM {.booldefine.}: bool = true
when BORINGSS_USE_ASM:
  when not defined(windows):
    {.compile("./boringssl/crypto/hrss/asm/poly_rq_mul.S", boringsslPerFileFlags).}
    {.
      compile(
        "./boringssl/third_party/fiat/asm/fiat_curve25519_adx_mul.S",
        boringsslPerFileFlags,
      )
    .}
    {.
      compile(
        "./boringssl/third_party/fiat/asm/fiat_curve25519_adx_square.S",
        boringsslPerFileFlags,
      )
    .}
    {.
      compile(
        "./boringssl/third_party/fiat/asm/fiat_p256_adx_mul.S", boringsslPerFileFlags
      )
    .}
    {.
      compile(
        "./boringssl/third_party/fiat/asm/fiat_p256_adx_sqr.S", boringsslPerFileFlags
      )
    .}
    {.
      compile(
        "./boringssl/crypto/curve25519/asm/x25519-asm-arm.S", boringsslPerFileFlags
      )
    .}
    {.
      compile("./boringssl/crypto/poly1305/poly1305_arm_asm.S", boringsslPerFileFlags)
    .}
    {.
      compile(
        "./boringssl/gen/crypto/aes128gcmsiv-x86_64-apple.S", boringsslPerFileFlags
      )
    .}
    {.
      compile(
        "./boringssl/gen/crypto/aes128gcmsiv-x86_64-linux.S", boringsslPerFileFlags
      )
    .}
    {.compile("./boringssl/gen/crypto/chacha-armv4-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/crypto/chacha-armv8-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/crypto/chacha-armv8-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/crypto/chacha-armv8-win.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/crypto/chacha-x86-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/crypto/chacha-x86-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/crypto/chacha-x86_64-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/crypto/chacha-x86_64-linux.S", boringsslPerFileFlags).}
    {.
      compile(
        "./boringssl/gen/crypto/chacha20_poly1305_armv8-apple.S", boringsslPerFileFlags
      )
    .}
    {.
      compile(
        "./boringssl/gen/crypto/chacha20_poly1305_armv8-linux.S", boringsslPerFileFlags
      )
    .}
    {.
      compile(
        "./boringssl/gen/crypto/chacha20_poly1305_armv8-win.S", boringsslPerFileFlags
      )
    .}
    {.
      compile(
        "./boringssl/gen/crypto/chacha20_poly1305_x86_64-apple.S", boringsslPerFileFlags
      )
    .}
    {.
      compile(
        "./boringssl/gen/crypto/chacha20_poly1305_x86_64-linux.S", boringsslPerFileFlags
      )
    .}
    {.compile("./boringssl/gen/crypto/md5-586-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/crypto/md5-586-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/crypto/md5-x86_64-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/crypto/md5-x86_64-linux.S", boringsslPerFileFlags).}
    {.
      compile("./boringssl/gen/bcm/aes-gcm-avx2-x86_64-apple.S", boringsslPerFileFlags)
    .}
    {.
      compile("./boringssl/gen/bcm/aes-gcm-avx2-x86_64-linux.S", boringsslPerFileFlags)
    .}
    {.
      compile(
        "./boringssl/gen/bcm/aes-gcm-avx512-x86_64-apple.S", boringsslPerFileFlags
      )
    .}
    {.
      compile(
        "./boringssl/gen/bcm/aes-gcm-avx512-x86_64-linux.S", boringsslPerFileFlags
      )
    .}
    {.compile("./boringssl/gen/bcm/aesni-gcm-x86_64-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/aesni-gcm-x86_64-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/aesni-x86-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/aesni-x86_64-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/aesni-x86_64-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/aesni-x86-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/aesv8-armv7-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/aesv8-armv8-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/aesv8-armv8-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/aesv8-armv8-win.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/aesv8-gcm-armv8-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/aesv8-gcm-armv8-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/aesv8-gcm-armv8-win.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/armv4-mont-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/armv8-mont-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/armv8-mont-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/armv8-mont-win.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/bn-586-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/bn-586-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/bn-armv8-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/bn-armv8-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/bn-armv8-win.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/bsaes-armv7-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/co-586-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/co-586-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghash-armv4-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghash-neon-armv8-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghash-neon-armv8-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghash-neon-armv8-win.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghash-ssse3-x86-apple.S", boringsslPerFileFlags).}
    {.
      compile("./boringssl/gen/bcm/ghash-ssse3-x86_64-apple.S", boringsslPerFileFlags)
    .}
    {.
      compile("./boringssl/gen/bcm/ghash-ssse3-x86_64-linux.S", boringsslPerFileFlags)
    .}
    {.compile("./boringssl/gen/bcm/ghash-ssse3-x86-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghash-x86-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghash-x86_64-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghash-x86_64-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghash-x86-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghashv8-armv7-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghashv8-armv8-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghashv8-armv8-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/ghashv8-armv8-win.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/p256-armv8-asm-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/p256-armv8-asm-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/p256-armv8-asm-win.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/p256-x86_64-asm-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/p256-x86_64-asm-linux.S", boringsslPerFileFlags).}
    {.
      compile("./boringssl/gen/bcm/p256_beeu-armv8-asm-apple.S", boringsslPerFileFlags)
    .}
    {.
      compile("./boringssl/gen/bcm/p256_beeu-armv8-asm-linux.S", boringsslPerFileFlags)
    .}
    {.compile("./boringssl/gen/bcm/p256_beeu-armv8-asm-win.S", boringsslPerFileFlags).}
    {.
      compile("./boringssl/gen/bcm/p256_beeu-x86_64-asm-apple.S", boringsslPerFileFlags)
    .}
    {.
      compile("./boringssl/gen/bcm/p256_beeu-x86_64-asm-linux.S", boringsslPerFileFlags)
    .}
    {.compile("./boringssl/gen/bcm/rdrand-x86_64-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/rdrand-x86_64-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/rsaz-avx2-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/rsaz-avx2-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha1-586-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha1-586-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha1-armv4-large-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha1-armv8-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha1-armv8-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha1-armv8-win.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha1-x86_64-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha1-x86_64-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha256-586-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha256-586-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha256-armv4-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha256-armv8-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha256-armv8-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha256-armv8-win.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha256-x86_64-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha256-x86_64-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha512-586-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha512-586-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha512-armv4-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha512-armv8-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha512-armv8-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha512-armv8-win.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha512-x86_64-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/sha512-x86_64-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/vpaes-armv7-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/vpaes-armv8-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/vpaes-armv8-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/vpaes-armv8-win.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/vpaes-x86-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/vpaes-x86_64-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/vpaes-x86_64-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/vpaes-x86-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/x86-mont-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/x86_64-mont-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/x86_64-mont-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/x86-mont-linux.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/x86_64-mont5-apple.S", boringsslPerFileFlags).}
    {.compile("./boringssl/gen/bcm/x86_64-mont5-linux.S", boringsslPerFileFlags).}

  when defined(windows):
    import std/[macros, md5, os, pathnorm]
    const baseDir = currentSourcePath.parentDir
    const outDir = baseDir
    const asmFiles = [
      "./boringssl/gen/bcm/aes-gcm-avx2-x86_64-win.asm",
      "./boringssl/gen/bcm/aes-gcm-avx512-x86_64-win.asm",
      "./boringssl/gen/bcm/aesni-gcm-x86_64-win.asm",
      "./boringssl/gen/bcm/aesni-x86-win.asm",
      "./boringssl/gen/bcm/aesni-x86_64-win.asm",
      "./boringssl/gen/bcm/ghash-ssse3-x86-win.asm",
      "./boringssl/gen/bcm/ghash-ssse3-x86_64-win.asm",
      "./boringssl/gen/bcm/ghash-x86-win.asm",
      "./boringssl/gen/bcm/ghash-x86_64-win.asm",
      "./boringssl/gen/bcm/p256-x86_64-asm-win.asm",
      "./boringssl/gen/bcm/p256_beeu-x86_64-asm-win.asm",
      "./boringssl/gen/bcm/rdrand-x86_64-win.asm",
      "./boringssl/gen/bcm/rsaz-avx2-win.asm",
      "./boringssl/gen/bcm/sha1-x86_64-win.asm",
      "./boringssl/gen/bcm/sha256-x86_64-win.asm",
      "./boringssl/gen/bcm/sha512-x86_64-win.asm",
      "./boringssl/gen/bcm/vpaes-x86-win.asm",
      "./boringssl/gen/bcm/vpaes-x86_64-win.asm",
      "./boringssl/gen/bcm/x86-mont-win.asm", "./boringssl/gen/bcm/x86_64-mont-win.asm",
      "./boringssl/gen/bcm/x86_64-mont5-win.asm",
      "./boringssl/gen/crypto/md5-x86_64-win.asm",
      "./boringssl/gen/crypto/chacha20_poly1305_x86_64-win.asm",
      "./boringssl/gen/crypto/chacha-x86_64-win.asm",
    ]

    macro linkAsmFiles(
        files: static[openArray[string]], outDir: static[string]
    ): untyped =
      result = newStmtList()
      for f in files:
        let (_, name, _) = splitFile(f)
        let obj = normalizePath((outDir / name) & ".obj", dirSep = '/')
        let objLit = newLit(obj)
        result.add quote do:
          {.link: `objLit`.}

    static:
      let nasmIncludeDir =
        normalizePath(baseDir / "./boringssl/gen", dirSep = '/') & "/"
      let nasmPrefixIncludes =
        staticRead(
          baseDir /
            "./boringssl/gen/boringssl_prefix_symbols_internal_x86_64_win_asm.inc"
        ) &
        staticRead(
          baseDir / "./boringssl/gen/boringssl_prefix_symbols_internal_x86_win_asm.inc"
        )
      for asmPathRel in asmFiles:
        let asmPath = normalizePath(baseDir / asmPathRel, dirSep = '/')
        let outObj =
          normalizePath(outDir / (asmPath.splitFile.name & ".obj"), dirSep = '/')
        let hashPath = outObj & ".md5"
        let srcHash = getMD5(staticRead(asmPath) & nasmPrefixIncludes)
        let cachedHash =
          if fileExists(hashPath):
            readFile(hashPath)
          else:
            ""
        if (not fileExists(outObj)) or (cachedHash != srcHash):
          let cmd =
            "nasm -f win64 -I" & quoteShell(nasmIncludeDir) & " " & quoteShell(asmPath) &
            " -o " & quoteShell(outObj)
          let res = gorgeEx(cmd)
          doAssert res.exitCode == 0,
            "Failed cmd exit-code: " & $res.exitCode & " output: " & res.output
          writeFile(hashPath, srcHash)

    linkAsmFiles(asmFiles, outDir)

# ----- generated sources -----
# Compile compatible BoringSSL C++ files as unity chunks.
{.compile("./boringssl/crypto/fipsmodule/bcm.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/aes/aes.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_asn1.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/base64/base64.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_bio_core.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/bio/socket.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/blake2/blake2.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_bn.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/buf/buf.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_bytestring.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/chacha/chacha.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_cipher_core.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/cipher/e_rc2.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/cms/cms.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/conf/conf.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_curve25519.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/des/des.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_dh.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/digest/digest_extra.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_dsa.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_ec.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/ecdh/ecdh.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_ecdsa.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/engine/engine.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/err/err.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_evp_core.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/evp/p_mlkem.cc", boringsslPerFileFlags).}
{.
  compile("./boringssl/crypto/fipsmodule/fips_shared_support.cc", boringsslPerFileFlags)
.}
{.compile("./boringssl/crypto/hpke/hpke.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/hrss/hrss.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/kyber/kyber.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/lhash/lhash.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/md4/md4.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/md5/md5.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/mldsa/mldsa.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/mlkem/mlkem.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_obj.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_pem.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_pkcs7.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_pkcs8.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_poly1305.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/pool/pool.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_rand.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/rc4/rc4.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_rsa.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_sha.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/siphash/siphash.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/slhdsa/slhdsa.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/spake2plus/spake2plus.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/stack/stack.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_trust_token_core.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/trust_token/voprf.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_x509_head.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_x509_v3.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_x509_mid.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/crypto_x509_x.cc", boringsslPerFileFlags).}
{.compile("./boringssl/crypto/xwing/xwing.cc", boringsslPerFileFlags).}
{.compile("./boringssl/gen/crypto//err_data.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/ssl_dtls.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/ssl_common.cc", boringsslPerFileFlags).}
{.compile("./boringssl/ssl/handshake.cc", boringsslPerFileFlags).}
{.compile("./boringssl/ssl/handshake_client.cc", boringsslPerFileFlags).}
{.compile("./boringssl/ssl/handshake_server.cc", boringsslPerFileFlags).}
{.compile("./boringssl/ssl/ssl_cipher.cc", boringsslPerFileFlags).}
{.compile("./boringssl/ssl/ssl_credential.cc", boringsslPerFileFlags).}
{.compile("./boringssl/ssl/ssl_session.cc", boringsslPerFileFlags).}
{.compile("./boringssl_units/ssl_tls13_misc.cc", boringsslPerFileFlags).}
{.compile("./boringssl/ssl/tls13_client.cc", boringsslPerFileFlags).}
{.compile("./boringssl/ssl/tls13_server.cc", boringsslPerFileFlags).}
{.compile("./boringssl/decrepit/x509/x509_decrepit.cc", boringsslPerFileFlags).}
