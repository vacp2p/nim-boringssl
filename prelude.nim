# SPDX-License-Identifier: Apache-2.0 OR MIT
# Copyright (c) Status Research & Development GmbH

# libcrypto + libssl sources without cmake, no-asm, no fips, no tests, tools
# TODO: look into use assembly files for perf

import std/[os, strutils]

type ptrdiff_t* {.importc: "ptrdiff_t", header: "<stddef.h>".} = int

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
      for asmPathRel in asmFiles:
        let asmPath = normalizePath(baseDir / asmPathRel, dirSep = '/')
        let outObj =
          normalizePath(outDir / (asmPath.splitFile.name & ".obj"), dirSep = '/')
        let hashPath = outObj & ".md5"
        let srcHash = getMD5(staticRead(asmPath))
        let cachedHash =
          if fileExists(hashPath):
            readFile(hashPath)
          else:
            ""
        if (not fileExists(outObj)) or (cachedHash != srcHash):
          let cmd = "nasm -f win64 " & quoteShell(asmPath) & " -o " & quoteShell(outObj)
          let res = gorgeEx(cmd)
          doAssert res.exitCode == 0,
            "Failed cmd exit-code: " & $res.exitCode & " output: " & res.output
          writeFile(hashPath, srcHash)

    linkAsmFiles(asmFiles, outDir)

# ----- generated sources -----
{.compile: "./boringssl/crypto/fipsmodule/bcm.cc".}
{.compile: "./boringssl/crypto/aes/aes.cc".}
{.compile: "./boringssl/crypto/asn1/a_bitstr.cc".}
{.compile: "./boringssl/crypto/asn1/a_bool.cc".}
{.compile: "./boringssl/crypto/asn1/a_d2i_fp.cc".}
{.compile: "./boringssl/crypto/asn1/a_dup.cc".}
{.compile: "./boringssl/crypto/asn1/a_gentm.cc".}
{.compile: "./boringssl/crypto/asn1/a_i2d_fp.cc".}
{.compile: "./boringssl/crypto/asn1/a_int.cc".}
{.compile: "./boringssl/crypto/asn1/a_mbstr.cc".}
{.compile: "./boringssl/crypto/asn1/a_object.cc".}
{.compile: "./boringssl/crypto/asn1/a_octet.cc".}
{.compile: "./boringssl/crypto/asn1/a_strex.cc".}
{.compile: "./boringssl/crypto/asn1/a_strnid.cc".}
{.compile: "./boringssl/crypto/asn1/a_time.cc".}
{.compile: "./boringssl/crypto/asn1/a_type.cc".}
{.compile: "./boringssl/crypto/asn1/a_utctm.cc".}
{.compile: "./boringssl/crypto/asn1/asn1_lib.cc".}
{.compile: "./boringssl/crypto/asn1/asn1_par.cc".}
{.compile: "./boringssl/crypto/asn1/asn_pack.cc".}
{.compile: "./boringssl/crypto/asn1/f_int.cc".}
{.compile: "./boringssl/crypto/asn1/f_string.cc".}
{.compile: "./boringssl/crypto/asn1/posix_time.cc".}
{.compile: "./boringssl/crypto/asn1/tasn_dec.cc".}
{.compile: "./boringssl/crypto/asn1/tasn_enc.cc".}
{.compile: "./boringssl/crypto/asn1/tasn_fre.cc".}
{.compile: "./boringssl/crypto/asn1/tasn_new.cc".}
{.compile: "./boringssl/crypto/asn1/tasn_typ.cc".}
{.compile: "./boringssl/crypto/asn1/tasn_utl.cc".}
{.compile: "./boringssl/crypto/base64/base64.cc".}
{.compile: "./boringssl/crypto/bio/bio.cc".}
{.compile: "./boringssl/crypto/bio/bio_mem.cc".}
{.compile: "./boringssl/crypto/bio/connect.cc".}
{.compile: "./boringssl/crypto/bio/errno.cc".}
{.compile: "./boringssl/crypto/bio/fd.cc".}
{.compile: "./boringssl/crypto/bio/file.cc".}
{.compile: "./boringssl/crypto/bio/hexdump.cc".}
{.compile: "./boringssl/crypto/bio/pair.cc".}
{.compile: "./boringssl/crypto/bio/printf.cc".}
{.compile: "./boringssl/crypto/bio/socket.cc".}
{.compile: "./boringssl/crypto/bio/socket_helper.cc".}
{.compile: "./boringssl/crypto/blake2/blake2.cc".}
{.compile: "./boringssl/crypto/bn/bn_asn1.cc".}
{.compile: "./boringssl/crypto/bn/convert.cc".}
{.compile: "./boringssl/crypto/bn/div.cc".}
{.compile: "./boringssl/crypto/bn/exponentiation.cc".}
{.compile: "./boringssl/crypto/bn/sqrt.cc".}
{.compile: "./boringssl/crypto/buf/buf.cc".}
{.compile: "./boringssl/crypto/bytestring/asn1_compat.cc".}
{.compile: "./boringssl/crypto/bytestring/ber.cc".}
{.compile: "./boringssl/crypto/bytestring/cbb.cc".}
{.compile: "./boringssl/crypto/bytestring/cbs.cc".}
{.compile: "./boringssl/crypto/bytestring/unicode.cc".}
{.compile: "./boringssl/crypto/chacha/chacha.cc".}
{.compile: "./boringssl/crypto/cipher/derive_key.cc".}
{.compile: "./boringssl/crypto/cipher/e_aesctrhmac.cc".}
{.compile: "./boringssl/crypto/cipher/e_aeseax.cc".}
{.compile: "./boringssl/crypto/cipher/e_aesgcmsiv.cc".}
{.compile: "./boringssl/crypto/cipher/e_chacha20poly1305.cc".}
{.compile: "./boringssl/crypto/cipher/e_des.cc".}
{.compile: "./boringssl/crypto/cipher/e_null.cc".}
{.compile: "./boringssl/crypto/cipher/e_rc2.cc".}
{.compile: "./boringssl/crypto/cipher/e_rc4.cc".}
{.compile: "./boringssl/crypto/cipher/e_tls.cc".}
{.compile: "./boringssl/crypto/cipher/get_cipher.cc".}
{.compile: "./boringssl/crypto/cipher/tls_cbc.cc".}
{.compile: "./boringssl/crypto/cms/cms.cc".}
{.compile: "./boringssl/crypto/conf/conf.cc".}
{.compile: "./boringssl/crypto/cpu_aarch64_apple.cc".}
{.compile: "./boringssl/crypto/cpu_aarch64_fuchsia.cc".}
{.compile: "./boringssl/crypto/cpu_aarch64_linux.cc".}
{.compile: "./boringssl/crypto/cpu_aarch64_openbsd.cc".}
{.compile: "./boringssl/crypto/cpu_aarch64_sysreg.cc".}
{.compile: "./boringssl/crypto/cpu_aarch64_win.cc".}
{.compile: "./boringssl/crypto/cpu_arm_freebsd.cc".}
{.compile: "./boringssl/crypto/cpu_arm_linux.cc".}
{.compile: "./boringssl/crypto/cpu_intel.cc".}
{.compile: "./boringssl/crypto/crypto.cc".}
{.compile: "./boringssl/crypto/curve25519/curve25519.cc".}
{.compile: "./boringssl/crypto/curve25519/curve25519_64_adx.cc".}
{.compile: "./boringssl/crypto/curve25519/spake25519.cc".}
{.compile: "./boringssl/crypto/des/des.cc".}
{.compile: "./boringssl/crypto/dh/dh_asn1.cc".}
{.compile: "./boringssl/crypto/dh/params.cc".}
{.compile: "./boringssl/crypto/digest/digest_extra.cc".}
{.compile: "./boringssl/crypto/dsa/dsa.cc".}
{.compile: "./boringssl/crypto/dsa/dsa_asn1.cc".}
{.compile: "./boringssl/crypto/ec/ec_asn1.cc".}
{.compile: "./boringssl/crypto/ec/ec_derive.cc".}
{.compile: "./boringssl/crypto/ec/hash_to_curve.cc".}
{.compile: "./boringssl/crypto/ecdh/ecdh.cc".}
{.compile: "./boringssl/crypto/ecdsa/ecdsa_asn1.cc".}
{.compile: "./boringssl/crypto/ecdsa/ecdsa_p1363.cc".}
{.compile: "./boringssl/crypto/engine/engine.cc".}
{.compile: "./boringssl/crypto/err/err.cc".}
{.compile: "./boringssl/crypto/evp/evp.cc".}
{.compile: "./boringssl/crypto/evp/evp_asn1.cc".}
{.compile: "./boringssl/crypto/evp/evp_ctx.cc".}
{.compile: "./boringssl/crypto/evp/p_dh.cc".}
{.compile: "./boringssl/crypto/evp/p_dsa.cc".}
{.compile: "./boringssl/crypto/evp/p_ec.cc".}
{.compile: "./boringssl/crypto/evp/p_ed25519.cc".}
{.compile: "./boringssl/crypto/evp/p_hkdf.cc".}
{.compile: "./boringssl/crypto/evp/p_rsa.cc".}
{.compile: "./boringssl/crypto/evp/p_x25519.cc".}
{.compile: "./boringssl/crypto/evp/pbkdf.cc".}
{.compile: "./boringssl/crypto/evp/print.cc".}
{.compile: "./boringssl/crypto/evp/scrypt.cc".}
{.compile: "./boringssl/crypto/evp/sign.cc".}
{.compile: "./boringssl/crypto/ex_data.cc".}
{.compile: "./boringssl/crypto/fipsmodule/fips_shared_support.cc".}
{.compile: "./boringssl/crypto/fuzzer_mode.cc".}
{.compile: "./boringssl/crypto/hpke/hpke.cc".}
{.compile: "./boringssl/crypto/hrss/hrss.cc".}
{.compile: "./boringssl/crypto/kyber/kyber.cc".}
{.compile: "./boringssl/crypto/lhash/lhash.cc".}
{.compile: "./boringssl/crypto/md4/md4.cc".}
{.compile: "./boringssl/crypto/md5/md5.cc".}
{.compile: "./boringssl/crypto/mem.cc".}
{.compile: "./boringssl/crypto/mldsa/mldsa.cc".}
{.compile: "./boringssl/crypto/mlkem/mlkem.cc".}
{.compile: "./boringssl/crypto/obj/obj.cc".}
{.compile: "./boringssl/crypto/obj/obj_xref.cc".}
{.compile: "./boringssl/crypto/pem/pem_all.cc".}
{.compile: "./boringssl/crypto/pem/pem_info.cc".}
{.compile: "./boringssl/crypto/pem/pem_lib.cc".}
{.compile: "./boringssl/crypto/pem/pem_oth.cc".}
{.compile: "./boringssl/crypto/pem/pem_pk8.cc".}
{.compile: "./boringssl/crypto/pem/pem_pkey.cc".}
{.compile: "./boringssl/crypto/pem/pem_x509.cc".}
{.compile: "./boringssl/crypto/pem/pem_xaux.cc".}
{.compile: "./boringssl/crypto/pkcs7/pkcs7.cc".}
{.compile: "./boringssl/crypto/pkcs7/pkcs7_x509.cc".}
{.compile: "./boringssl/crypto/pkcs8/p5_pbev2.cc".}
{.compile: "./boringssl/crypto/pkcs8/pkcs8.cc".}
{.compile: "./boringssl/crypto/pkcs8/pkcs8_x509.cc".}
{.compile: "./boringssl/crypto/poly1305/poly1305.cc".}
{.compile: "./boringssl/crypto/poly1305/poly1305_arm.cc".}
{.compile: "./boringssl/crypto/poly1305/poly1305_vec.cc".}
{.compile: "./boringssl/crypto/pool/pool.cc".}
{.compile: "./boringssl/crypto/rand/deterministic.cc".}
{.compile: "./boringssl/crypto/rand/fork_detect.cc".}
{.compile: "./boringssl/crypto/rand/forkunsafe.cc".}
{.compile: "./boringssl/crypto/rand/getentropy.cc".}
{.compile: "./boringssl/crypto/rand/ios.cc".}
{.compile: "./boringssl/crypto/rand/passive.cc".}
{.compile: "./boringssl/crypto/rand/rand.cc".}
{.compile: "./boringssl/crypto/rand/trusty.cc".}
{.compile: "./boringssl/crypto/rand/urandom.cc".}
{.compile: "./boringssl/crypto/rand/windows.cc".}
{.compile: "./boringssl/crypto/rc4/rc4.cc".}
{.compile: "./boringssl/crypto/refcount.cc".}
{.compile: "./boringssl/crypto/rsa/rsa_asn1.cc".}
{.compile: "./boringssl/crypto/rsa/rsa_crypt.cc".}
{.compile: "./boringssl/crypto/rsa/rsa_extra.cc".}
{.compile: "./boringssl/crypto/rsa/rsa_print.cc".}
{.compile: "./boringssl/crypto/sha/sha1.cc".}
{.compile: "./boringssl/crypto/sha/sha256.cc".}
{.compile: "./boringssl/crypto/sha/sha512.cc".}
{.compile: "./boringssl/crypto/siphash/siphash.cc".}
{.compile: "./boringssl/crypto/slhdsa/slhdsa.cc".}
{.compile: "./boringssl/crypto/spake2plus/spake2plus.cc".}
{.compile: "./boringssl/crypto/stack/stack.cc".}
{.compile: "./boringssl/crypto/thread.cc".}
{.compile: "./boringssl/crypto/thread_none.cc".}
{.compile: "./boringssl/crypto/thread_pthread.cc".}
{.compile: "./boringssl/crypto/thread_win.cc".}
{.compile: "./boringssl/crypto/trust_token/pmbtoken.cc".}
{.compile: "./boringssl/crypto/trust_token/trust_token.cc".}
{.compile: "./boringssl/crypto/trust_token/voprf.cc".}
{.compile: "./boringssl/crypto/x509/a_digest.cc".}
{.compile: "./boringssl/crypto/x509/a_sign.cc".}
{.compile: "./boringssl/crypto/x509/a_verify.cc".}
{.compile: "./boringssl/crypto/x509/algorithm.cc".}
{.compile: "./boringssl/crypto/x509/asn1_gen.cc".}
{.compile: "./boringssl/crypto/x509/by_dir.cc".}
{.compile: "./boringssl/crypto/x509/by_file.cc".}
{.compile: "./boringssl/crypto/x509/i2d_pr.cc".}
{.compile: "./boringssl/crypto/x509/name_print.cc".}
{.compile: "./boringssl/crypto/x509/policy.cc".}
{.compile: "./boringssl/crypto/x509/rsa_pss.cc".}
{.compile: "./boringssl/crypto/x509/t_crl.cc".}
{.compile: "./boringssl/crypto/x509/t_req.cc".}
{.compile: "./boringssl/crypto/x509/t_x509.cc".}
{.compile: "./boringssl/crypto/x509/t_x509a.cc".}
{.compile: "./boringssl/crypto/x509/v3_akey.cc".}
{.compile: "./boringssl/crypto/x509/v3_akeya.cc".}
{.compile: "./boringssl/crypto/x509/v3_alt.cc".}
{.compile: "./boringssl/crypto/x509/v3_bcons.cc".}
{.compile: "./boringssl/crypto/x509/v3_bitst.cc".}
{.compile: "./boringssl/crypto/x509/v3_conf.cc".}
{.compile: "./boringssl/crypto/x509/v3_cpols.cc".}
{.compile: "./boringssl/crypto/x509/v3_crld.cc".}
{.compile: "./boringssl/crypto/x509/v3_enum.cc".}
{.compile: "./boringssl/crypto/x509/v3_extku.cc".}
{.compile: "./boringssl/crypto/x509/v3_genn.cc".}
{.compile: "./boringssl/crypto/x509/v3_ia5.cc".}
{.compile: "./boringssl/crypto/x509/v3_info.cc".}
{.compile: "./boringssl/crypto/x509/v3_int.cc".}
{.compile: "./boringssl/crypto/x509/v3_lib.cc".}
{.compile: "./boringssl/crypto/x509/v3_ncons.cc".}
{.compile: "./boringssl/crypto/x509/v3_ocsp.cc".}
{.compile: "./boringssl/crypto/x509/v3_pcons.cc".}
{.compile: "./boringssl/crypto/x509/v3_pmaps.cc".}
{.compile: "./boringssl/crypto/x509/v3_prn.cc".}
{.compile: "./boringssl/crypto/x509/v3_purp.cc".}
{.compile: "./boringssl/crypto/x509/v3_skey.cc".}
{.compile: "./boringssl/crypto/x509/v3_utl.cc".}
{.compile: "./boringssl/crypto/x509/x509.cc".}
{.compile: "./boringssl/crypto/x509/x509_att.cc".}
{.compile: "./boringssl/crypto/x509/x509_cmp.cc".}
{.compile: "./boringssl/crypto/x509/x509_d2.cc".}
{.compile: "./boringssl/crypto/x509/x509_def.cc".}
{.compile: "./boringssl/crypto/x509/x509_ext.cc".}
{.compile: "./boringssl/crypto/x509/x509_lu.cc".}
{.compile: "./boringssl/crypto/x509/x509_obj.cc".}
{.compile: "./boringssl/crypto/x509/x509_req.cc".}
{.compile: "./boringssl/crypto/x509/x509_set.cc".}
{.compile: "./boringssl/crypto/x509/x509_trs.cc".}
{.compile: "./boringssl/crypto/x509/x509_txt.cc".}
{.compile: "./boringssl/crypto/x509/x509_v3.cc".}
{.compile: "./boringssl/crypto/x509/x509_vfy.cc".}
{.compile: "./boringssl/crypto/x509/x509_vpm.cc".}
{.compile: "./boringssl/crypto/x509/x509cset.cc".}
{.compile: "./boringssl/crypto/x509/x509name.cc".}
{.compile: "./boringssl/crypto/x509/x509rset.cc".}
{.compile: "./boringssl/crypto/x509/x509spki.cc".}
{.compile: "./boringssl/crypto/x509/x_algor.cc".}
{.compile: "./boringssl/crypto/x509/x_all.cc".}
{.compile: "./boringssl/crypto/x509/x_attrib.cc".}
{.compile: "./boringssl/crypto/x509/x_crl.cc".}
{.compile: "./boringssl/crypto/x509/x_exten.cc".}
{.compile: "./boringssl/crypto/x509/x_name.cc".}
{.compile: "./boringssl/crypto/x509/x_pubkey.cc".}
{.compile: "./boringssl/crypto/x509/x_req.cc".}
{.compile: "./boringssl/crypto/x509/x_sig.cc".}
{.compile: "./boringssl/crypto/x509/x_spki.cc".}
{.compile: "./boringssl/crypto/x509/x_x509.cc".}
{.compile: "./boringssl/crypto/x509/x_x509a.cc".}
{.compile: "./boringssl/crypto/xwing/xwing.cc".}
{.compile: "./boringssl/gen/crypto//err_data.cc".}
{.compile: "./boringssl/ssl/bio_ssl.cc".}
{.compile: "./boringssl/ssl/d1_both.cc".}
{.compile: "./boringssl/ssl/d1_lib.cc".}
{.compile: "./boringssl/ssl/d1_pkt.cc".}
{.compile: "./boringssl/ssl/d1_srtp.cc".}
{.compile: "./boringssl/ssl/dtls_method.cc".}
{.compile: "./boringssl/ssl/dtls_record.cc".}
{.compile: "./boringssl/ssl/encrypted_client_hello.cc".}
{.compile: "./boringssl/ssl/extensions.cc".}
{.compile: "./boringssl/ssl/handoff.cc".}
{.compile: "./boringssl/ssl/handshake.cc".}
{.compile: "./boringssl/ssl/handshake_client.cc".}
{.compile: "./boringssl/ssl/handshake_server.cc".}
{.compile: "./boringssl/ssl/s3_both.cc".}
{.compile: "./boringssl/ssl/s3_lib.cc".}
{.compile: "./boringssl/ssl/s3_pkt.cc".}
{.compile: "./boringssl/ssl/ssl_aead_ctx.cc".}
{.compile: "./boringssl/ssl/ssl_asn1.cc".}
{.compile: "./boringssl/ssl/ssl_buffer.cc".}
{.compile: "./boringssl/ssl/ssl_cert.cc".}
{.compile: "./boringssl/ssl/ssl_cipher.cc".}
{.compile: "./boringssl/ssl/ssl_credential.cc".}
{.compile: "./boringssl/ssl/ssl_file.cc".}
{.compile: "./boringssl/ssl/ssl_key_share.cc".}
{.compile: "./boringssl/ssl/ssl_lib.cc".}
{.compile: "./boringssl/ssl/ssl_privkey.cc".}
{.compile: "./boringssl/ssl/ssl_session.cc".}
{.compile: "./boringssl/ssl/ssl_stat.cc".}
{.compile: "./boringssl/ssl/ssl_transcript.cc".}
{.compile: "./boringssl/ssl/ssl_versions.cc".}
{.compile: "./boringssl/ssl/ssl_x509.cc".}
{.compile: "./boringssl/ssl/t1_enc.cc".}
{.compile: "./boringssl/ssl/tls13_both.cc".}
{.compile: "./boringssl/ssl/tls13_client.cc".}
{.compile: "./boringssl/ssl/tls13_enc.cc".}
{.compile: "./boringssl/ssl/tls13_server.cc".}
{.compile: "./boringssl/ssl/tls_method.cc".}
{.compile: "./boringssl/ssl/tls_record.cc".}
{.compile: "./boringssl/decrepit/x509/x509_decrepit.cc".}
