# SPDX-License-Identifier: Apache-2.0 OR MIT
# Copyright (c) Status Research & Development GmbH
{.used.}

import std/[strutils, unittest]
import ../boringssl

proc toHexLower(bytes: openArray[uint8]): string =
  result = newStringOfCap(bytes.len * 2)
  for b in bytes:
    result.add(b.toHex(2).toLowerAscii)

suite "boringssl SHA256":
  test "empty input matches known digest":
    var digest: array[32, uint8]
    discard SHA256(nil, 0.csize_t, digest)
    check toHexLower(digest) ==
      "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

  test "abc matches known digest":
    var input = [uint8('a'), uint8('b'), uint8('c')]
    var digest: array[32, uint8]
    discard SHA256(addr input[0], input.len.csize_t, digest)
    check toHexLower(digest) ==
      "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
