# SPDX-License-Identifier: Apache-2.0 OR MIT
# Copyright (c) Status Research & Development GmbH 

import futhark
from os import parentDir, `/`

importc:
  outputPath currentSourcePath.parentDir / "tmp_boringssl_ffi.nim"
  path currentSourcePath.parentDir / "boringssl/include"
  rename FILE, CFile # Rename `FILE` that STB uses to `CFile` which is the Nim equivalent
  "openssl/aead.h"
  "openssl/hkdf.h"
  "openssl/curve25519.h"
  "openssl/ssl.h"
  "openssl/crypto.h"
  "openssl/rand.h"
  "openssl/asn1.h"
