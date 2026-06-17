#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# Copyright (c) Status Research & Development GmbH 

set -euo pipefail

root=$(dirname "$0")
sources=${root}

# assemble list of C files to be compiled
toCompile=(
  # "${sources}/path/to/file.c"
)

# futhark is required by generate_boringssl.nim, nph formats the generated bindings
nimble install -y futhark@0.15.0
nimble install -y nph@0.7.0
export PATH="${HOME}/.nimble/bin:${PATH}"

rm -f boringssl.nim

nim c -d:nodeclguards --maxLoopIterationsVM:100000000 generate_boringssl_ffi.nim

cat "${root}/prelude.nim" > boringssl.nim

echo >> boringssl.nim # linebreak

for file in "${toCompile[@]}"; do
    echo "{.compile: \"$file\".}" >> boringssl.nim
done

cat tmp_boringssl_ffi.nim >> boringssl.nim

nph boringssl.nim

rm -f tmp_boringssl_ffi.nim
