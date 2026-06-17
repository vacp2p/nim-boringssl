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

const BORINGSS_USE_ASM {.booldefine.}: bool = true
when BORINGSS_USE_ASM:
  when not defined(windows):
    {.compile: "./boringssl/crypto/hrss/asm/poly_rq_mul.S".}
    {.compile: "./boringssl/third_party/fiat/asm/fiat_curve25519_adx_mul.S".}
    {.compile: "./boringssl/third_party/fiat/asm/fiat_curve25519_adx_square.S".}
    {.compile: "./boringssl/third_party/fiat/asm/fiat_p256_adx_mul.S".}
    {.compile: "./boringssl/third_party/fiat/asm/fiat_p256_adx_sqr.S".}
    {.compile: "./boringssl/crypto/curve25519/asm/x25519-asm-arm.S".}
    {.compile: "./boringssl/crypto/poly1305/poly1305_arm_asm.S".}
    {.compile: "./boringssl/gen/crypto/aes128gcmsiv-x86_64-apple.S".}
    {.compile: "./boringssl/gen/crypto/aes128gcmsiv-x86_64-linux.S".}
    {.compile: "./boringssl/gen/crypto/chacha-armv4-linux.S".}
    {.compile: "./boringssl/gen/crypto/chacha-armv8-apple.S".}
    {.compile: "./boringssl/gen/crypto/chacha-armv8-linux.S".}
    {.compile: "./boringssl/gen/crypto/chacha-armv8-win.S".}
    {.compile: "./boringssl/gen/crypto/chacha-x86-apple.S".}
    {.compile: "./boringssl/gen/crypto/chacha-x86-linux.S".}
    {.compile: "./boringssl/gen/crypto/chacha-x86_64-apple.S".}
    {.compile: "./boringssl/gen/crypto/chacha-x86_64-linux.S".}
    {.compile: "./boringssl/gen/crypto/chacha20_poly1305_armv8-apple.S".}
    {.compile: "./boringssl/gen/crypto/chacha20_poly1305_armv8-linux.S".}
    {.compile: "./boringssl/gen/crypto/chacha20_poly1305_armv8-win.S".}
    {.compile: "./boringssl/gen/crypto/chacha20_poly1305_x86_64-apple.S".}
    {.compile: "./boringssl/gen/crypto/chacha20_poly1305_x86_64-linux.S".}
    {.compile: "./boringssl/gen/crypto/md5-586-apple.S".}
    {.compile: "./boringssl/gen/crypto/md5-586-linux.S".}
    {.compile: "./boringssl/gen/crypto/md5-x86_64-apple.S".}
    {.compile: "./boringssl/gen/crypto/md5-x86_64-linux.S".}
    {.compile: "./boringssl/gen/bcm/aes-gcm-avx2-x86_64-apple.S".}
    {.compile: "./boringssl/gen/bcm/aes-gcm-avx2-x86_64-linux.S".}
    {.compile: "./boringssl/gen/bcm/aes-gcm-avx512-x86_64-apple.S".}
    {.compile: "./boringssl/gen/bcm/aes-gcm-avx512-x86_64-linux.S".}
    {.compile: "./boringssl/gen/bcm/aesni-gcm-x86_64-apple.S".}
    {.compile: "./boringssl/gen/bcm/aesni-gcm-x86_64-linux.S".}
    {.compile: "./boringssl/gen/bcm/aesni-x86-apple.S".}
    {.compile: "./boringssl/gen/bcm/aesni-x86_64-apple.S".}
    {.compile: "./boringssl/gen/bcm/aesni-x86_64-linux.S".}
    {.compile: "./boringssl/gen/bcm/aesni-x86-linux.S".}
    {.compile: "./boringssl/gen/bcm/aesv8-armv7-linux.S".}
    {.compile: "./boringssl/gen/bcm/aesv8-armv8-apple.S".}
    {.compile: "./boringssl/gen/bcm/aesv8-armv8-linux.S".}
    {.compile: "./boringssl/gen/bcm/aesv8-armv8-win.S".}
    {.compile: "./boringssl/gen/bcm/aesv8-gcm-armv8-apple.S".}
    {.compile: "./boringssl/gen/bcm/aesv8-gcm-armv8-linux.S".}
    {.compile: "./boringssl/gen/bcm/aesv8-gcm-armv8-win.S".}
    {.compile: "./boringssl/gen/bcm/armv4-mont-linux.S".}
    {.compile: "./boringssl/gen/bcm/armv8-mont-apple.S".}
    {.compile: "./boringssl/gen/bcm/armv8-mont-linux.S".}
    {.compile: "./boringssl/gen/bcm/armv8-mont-win.S".}
    {.compile: "./boringssl/gen/bcm/bn-586-apple.S".}
    {.compile: "./boringssl/gen/bcm/bn-586-linux.S".}
    {.compile: "./boringssl/gen/bcm/bn-armv8-apple.S".}
    {.compile: "./boringssl/gen/bcm/bn-armv8-linux.S".}
    {.compile: "./boringssl/gen/bcm/bn-armv8-win.S".}
    {.compile: "./boringssl/gen/bcm/bsaes-armv7-linux.S".}
    {.compile: "./boringssl/gen/bcm/co-586-apple.S".}
    {.compile: "./boringssl/gen/bcm/co-586-linux.S".}
    {.compile: "./boringssl/gen/bcm/ghash-armv4-linux.S".}
    {.compile: "./boringssl/gen/bcm/ghash-neon-armv8-apple.S".}
    {.compile: "./boringssl/gen/bcm/ghash-neon-armv8-linux.S".}
    {.compile: "./boringssl/gen/bcm/ghash-neon-armv8-win.S".}
    {.compile: "./boringssl/gen/bcm/ghash-ssse3-x86-apple.S".}
    {.compile: "./boringssl/gen/bcm/ghash-ssse3-x86_64-apple.S".}
    {.compile: "./boringssl/gen/bcm/ghash-ssse3-x86_64-linux.S".}
    {.compile: "./boringssl/gen/bcm/ghash-ssse3-x86-linux.S".}
    {.compile: "./boringssl/gen/bcm/ghash-x86-apple.S".}
    {.compile: "./boringssl/gen/bcm/ghash-x86_64-apple.S".}
    {.compile: "./boringssl/gen/bcm/ghash-x86_64-linux.S".}
    {.compile: "./boringssl/gen/bcm/ghash-x86-linux.S".}
    {.compile: "./boringssl/gen/bcm/ghashv8-armv7-linux.S".}
    {.compile: "./boringssl/gen/bcm/ghashv8-armv8-apple.S".}
    {.compile: "./boringssl/gen/bcm/ghashv8-armv8-linux.S".}
    {.compile: "./boringssl/gen/bcm/ghashv8-armv8-win.S".}
    {.compile: "./boringssl/gen/bcm/p256-armv8-asm-apple.S".}
    {.compile: "./boringssl/gen/bcm/p256-armv8-asm-linux.S".}
    {.compile: "./boringssl/gen/bcm/p256-armv8-asm-win.S".}
    {.compile: "./boringssl/gen/bcm/p256-x86_64-asm-apple.S".}
    {.compile: "./boringssl/gen/bcm/p256-x86_64-asm-linux.S".}
    {.compile: "./boringssl/gen/bcm/p256_beeu-armv8-asm-apple.S".}
    {.compile: "./boringssl/gen/bcm/p256_beeu-armv8-asm-linux.S".}
    {.compile: "./boringssl/gen/bcm/p256_beeu-armv8-asm-win.S".}
    {.compile: "./boringssl/gen/bcm/p256_beeu-x86_64-asm-apple.S".}
    {.compile: "./boringssl/gen/bcm/p256_beeu-x86_64-asm-linux.S".}
    {.compile: "./boringssl/gen/bcm/rdrand-x86_64-apple.S".}
    {.compile: "./boringssl/gen/bcm/rdrand-x86_64-linux.S".}
    {.compile: "./boringssl/gen/bcm/rsaz-avx2-apple.S".}
    {.compile: "./boringssl/gen/bcm/rsaz-avx2-linux.S".}
    {.compile: "./boringssl/gen/bcm/sha1-586-apple.S".}
    {.compile: "./boringssl/gen/bcm/sha1-586-linux.S".}
    {.compile: "./boringssl/gen/bcm/sha1-armv4-large-linux.S".}
    {.compile: "./boringssl/gen/bcm/sha1-armv8-apple.S".}
    {.compile: "./boringssl/gen/bcm/sha1-armv8-linux.S".}
    {.compile: "./boringssl/gen/bcm/sha1-armv8-win.S".}
    {.compile: "./boringssl/gen/bcm/sha1-x86_64-apple.S".}
    {.compile: "./boringssl/gen/bcm/sha1-x86_64-linux.S".}
    {.compile: "./boringssl/gen/bcm/sha256-586-apple.S".}
    {.compile: "./boringssl/gen/bcm/sha256-586-linux.S".}
    {.compile: "./boringssl/gen/bcm/sha256-armv4-linux.S".}
    {.compile: "./boringssl/gen/bcm/sha256-armv8-apple.S".}
    {.compile: "./boringssl/gen/bcm/sha256-armv8-linux.S".}
    {.compile: "./boringssl/gen/bcm/sha256-armv8-win.S".}
    {.compile: "./boringssl/gen/bcm/sha256-x86_64-apple.S".}
    {.compile: "./boringssl/gen/bcm/sha256-x86_64-linux.S".}
    {.compile: "./boringssl/gen/bcm/sha512-586-apple.S".}
    {.compile: "./boringssl/gen/bcm/sha512-586-linux.S".}
    {.compile: "./boringssl/gen/bcm/sha512-armv4-linux.S".}
    {.compile: "./boringssl/gen/bcm/sha512-armv8-apple.S".}
    {.compile: "./boringssl/gen/bcm/sha512-armv8-linux.S".}
    {.compile: "./boringssl/gen/bcm/sha512-armv8-win.S".}
    {.compile: "./boringssl/gen/bcm/sha512-x86_64-apple.S".}
    {.compile: "./boringssl/gen/bcm/sha512-x86_64-linux.S".}
    {.compile: "./boringssl/gen/bcm/vpaes-armv7-linux.S".}
    {.compile: "./boringssl/gen/bcm/vpaes-armv8-apple.S".}
    {.compile: "./boringssl/gen/bcm/vpaes-armv8-linux.S".}
    {.compile: "./boringssl/gen/bcm/vpaes-armv8-win.S".}
    {.compile: "./boringssl/gen/bcm/vpaes-x86-apple.S".}
    {.compile: "./boringssl/gen/bcm/vpaes-x86_64-apple.S".}
    {.compile: "./boringssl/gen/bcm/vpaes-x86_64-linux.S".}
    {.compile: "./boringssl/gen/bcm/vpaes-x86-linux.S".}
    {.compile: "./boringssl/gen/bcm/x86-mont-apple.S".}
    {.compile: "./boringssl/gen/bcm/x86_64-mont-apple.S".}
    {.compile: "./boringssl/gen/bcm/x86_64-mont-linux.S".}
    {.compile: "./boringssl/gen/bcm/x86-mont-linux.S".}
    {.compile: "./boringssl/gen/bcm/x86_64-mont5-apple.S".}
    {.compile: "./boringssl/gen/bcm/x86_64-mont5-linux.S".}

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
{.compile: "./boringssl/crypto/fipsmodule/bcm.cc".}
{.compile: "./boringssl/crypto/aes/aes.cc".}
{.compile: "./boringssl_units/crypto_asn1.cc".}
{.compile: "./boringssl/crypto/base64/base64.cc".}
{.compile: "./boringssl_units/crypto_bio_core.cc".}
{.compile: "./boringssl/crypto/bio/socket.cc".}
{.compile: "./boringssl/crypto/blake2/blake2.cc".}
{.compile: "./boringssl_units/crypto_bn.cc".}
{.compile: "./boringssl/crypto/buf/buf.cc".}
{.compile: "./boringssl_units/crypto_bytestring.cc".}
{.compile: "./boringssl/crypto/chacha/chacha.cc".}
{.compile: "./boringssl_units/crypto_cipher_core.cc".}
{.compile: "./boringssl/crypto/cipher/e_rc2.cc".}
{.compile: "./boringssl/crypto/cms/cms.cc".}
{.compile: "./boringssl/crypto/conf/conf.cc".}
{.compile: "./boringssl_units/crypto.cc".}
{.compile: "./boringssl_units/crypto_curve25519.cc".}
{.compile: "./boringssl/crypto/des/des.cc".}
{.compile: "./boringssl_units/crypto_dh.cc".}
{.compile: "./boringssl/crypto/digest/digest_extra.cc".}
{.compile: "./boringssl_units/crypto_dsa.cc".}
{.compile: "./boringssl_units/crypto_ec.cc".}
{.compile: "./boringssl/crypto/ecdh/ecdh.cc".}
{.compile: "./boringssl_units/crypto_ecdsa.cc".}
{.compile: "./boringssl/crypto/engine/engine.cc".}
{.compile: "./boringssl/crypto/err/err.cc".}
{.compile: "./boringssl_units/crypto_evp_core.cc".}
{.compile: "./boringssl/crypto/evp/p_mlkem.cc".}
{.compile: "./boringssl/crypto/fipsmodule/fips_shared_support.cc".}
{.compile: "./boringssl/crypto/hpke/hpke.cc".}
{.compile: "./boringssl/crypto/hrss/hrss.cc".}
{.compile: "./boringssl/crypto/kyber/kyber.cc".}
{.compile: "./boringssl/crypto/lhash/lhash.cc".}
{.compile: "./boringssl/crypto/md4/md4.cc".}
{.compile: "./boringssl/crypto/md5/md5.cc".}
{.compile: "./boringssl/crypto/mldsa/mldsa.cc".}
{.compile: "./boringssl/crypto/mlkem/mlkem.cc".}
{.compile: "./boringssl_units/crypto_obj.cc".}
{.compile: "./boringssl_units/crypto_pem.cc".}
{.compile: "./boringssl_units/crypto_pkcs7.cc".}
{.compile: "./boringssl_units/crypto_pkcs8.cc".}
{.compile: "./boringssl_units/crypto_poly1305.cc".}
{.compile: "./boringssl/crypto/pool/pool.cc".}
{.compile: "./boringssl_units/crypto_rand.cc".}
{.compile: "./boringssl/crypto/rc4/rc4.cc".}
{.compile: "./boringssl_units/crypto_rsa.cc".}
{.compile: "./boringssl_units/crypto_sha.cc".}
{.compile: "./boringssl/crypto/siphash/siphash.cc".}
{.compile: "./boringssl/crypto/slhdsa/slhdsa.cc".}
{.compile: "./boringssl/crypto/spake2plus/spake2plus.cc".}
{.compile: "./boringssl/crypto/stack/stack.cc".}
{.compile: "./boringssl_units/crypto_trust_token_core.cc".}
{.compile: "./boringssl/crypto/trust_token/voprf.cc".}
{.compile: "./boringssl_units/crypto_x509_head.cc".}
{.compile: "./boringssl_units/crypto_x509_v3.cc".}
{.compile: "./boringssl_units/crypto_x509_mid.cc".}
{.compile: "./boringssl_units/crypto_x509_x.cc".}
{.compile: "./boringssl/crypto/xwing/xwing.cc".}
{.compile: "./boringssl/gen/crypto//err_data.cc".}
{.compile: "./boringssl_units/ssl_dtls.cc".}
{.compile: "./boringssl_units/ssl_common.cc".}
{.compile: "./boringssl/ssl/handshake.cc".}
{.compile: "./boringssl/ssl/handshake_client.cc".}
{.compile: "./boringssl/ssl/handshake_server.cc".}
{.compile: "./boringssl/ssl/ssl_cipher.cc".}
{.compile: "./boringssl/ssl/ssl_credential.cc".}
{.compile: "./boringssl/ssl/ssl_session.cc".}
{.compile: "./boringssl_units/ssl_tls13_misc.cc".}
{.compile: "./boringssl/ssl/tls13_client.cc".}
{.compile: "./boringssl/ssl/tls13_server.cc".}
{.compile: "./boringssl/decrepit/x509/x509_decrepit.cc".}
