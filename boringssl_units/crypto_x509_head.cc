// SPDX-License-Identifier: Apache-2.0 OR MIT
// Copyright (c) Status Research & Development GmbH

// Unity build chunk for BoringSSL sources. Keep in sync with prelude.nim.
#include "../boringssl/crypto/x509/a_digest.cc"
#include "../boringssl/crypto/x509/a_sign.cc"
#include "../boringssl/crypto/x509/a_verify.cc"
#include "../boringssl/crypto/x509/algorithm.cc"
#include "../boringssl/crypto/x509/asn1_gen.cc"
#include "../boringssl/crypto/x509/by_dir.cc"
#include "../boringssl/crypto/x509/by_file.cc"
#include "../boringssl/crypto/x509/i2d_pr.cc"
#include "../boringssl/crypto/x509/name_print.cc"
#include "../boringssl/crypto/x509/policy.cc"
#include "../boringssl/crypto/x509/rsa_pss.cc"
#include "../boringssl/crypto/x509/t_crl.cc"
#include "../boringssl/crypto/x509/t_req.cc"
#include "../boringssl/crypto/x509/t_x509.cc"
#include "../boringssl/crypto/x509/t_x509a.cc"
