// SPDX-License-Identifier: Apache-2.0 OR MIT
// Copyright (c) Status Research & Development GmbH

// Unity build chunk for BoringSSL sources. Keep in sync with prelude.nim.
#include "../boringssl/crypto/evp/evp.cc"
#include "../boringssl/crypto/evp/evp_asn1.cc"
#include "../boringssl/crypto/evp/evp_ctx.cc"
#include "../boringssl/crypto/evp/evp_kem.cc"
#include "../boringssl/crypto/evp/p_dh.cc"
#include "../boringssl/crypto/evp/p_dsa.cc"
#include "../boringssl/crypto/evp/p_ec.cc"
#include "../boringssl/crypto/evp/p_ed25519.cc"
#include "../boringssl/crypto/evp/p_hkdf.cc"
#include "../boringssl/crypto/evp/p_mldsa.cc"
#include "../boringssl/crypto/evp/p_rsa.cc"
#include "../boringssl/crypto/evp/p_x25519.cc"
#include "../boringssl/crypto/evp/p_xwing.cc"
#include "../boringssl/crypto/evp/pbkdf.cc"
#include "../boringssl/crypto/evp/print.cc"
#include "../boringssl/crypto/evp/scrypt.cc"
#include "../boringssl/crypto/evp/sign.cc"
