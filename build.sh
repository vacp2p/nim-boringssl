#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# Copyright (c) Status Research & Development GmbH 

root=$(dirname "$0")
sources=${root}

rm -f boringssl.nim

# assemble list of C files to be compiled
toCompile=(
  # "${sources}/path/to/file.c"
)

# futhark is required by generate_boringssl.nim
nimble install -y futhark@0.15.0
export PATH="${HOME}/.nimble/bin:${PATH}"

nim c --maxLoopIterationsVM:100000000 generate_boringssl_ffi.nim

cat "${root}/prelude.nim" > boringssl.nim

echo >> boringssl.nim # linebreak

for file in "${toCompile[@]}"; do
    echo "{.compile: \"$file\".}" >> boringssl.nim
done

cat tmp_boringssl_ffi.nim >> boringssl.nim

rm -f tmp_boringssl_ffi.nim
