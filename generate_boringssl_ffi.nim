# SPDX-License-Identifier: Apache-2.0 OR MIT
# Copyright (c) Status Research & Development GmbH 

import futhark
import std/json
from os import parentDir, `/`

type ptrdiff_t* {.importc: "ptrdiff_t", header: "<stddef.h>".} = int

proc normalizeOpirImpl(opirOutput: JsonNode): JsonNode =
  var resp = newJArray()
  for node in opirOutput:
    # The prelude owns ptrdiff_t through <stddef.h>. Dropping Futhark's
    # typedef avoids a host-sized clong fallback during cross compilation.
    if node{"kind"}.getStr("") == "typedef" and node{"name"}.getStr("") == "ptrdiff_t":
      continue

    # enums are generated manually to avoid issue described in
    # https://github.com/PMunch/futhark/issues/152
    if node{"kind"}.getStr("") == "enum":
      continue

    resp.add node
  resp

importc:
  outputPath currentSourcePath.parentDir / "tmp_boringssl_ffi.nim"
  path currentSourcePath.parentDir / "boringssl/include"
  addopircallback proc(opirOutput: JsonNode): JsonNode {.closure.} =
    normalizeOpirImpl(opirOutput)
  rename FILE, CFile # Rename `FILE` that STB uses to `CFile` which is the Nim equivalent
  "openssl/aead.h"
  "openssl/hkdf.h"
  "openssl/curve25519.h"
  "openssl/ssl.h"
  "openssl/crypto.h"
  "openssl/rand.h"
  "openssl/asn1.h"
