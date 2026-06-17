// SPDX-License-Identifier: Apache-2.0 OR MIT
// Copyright (c) Status Research & Development GmbH

// Unity build chunk for BoringSSL sources. Keep in sync with prelude.nim.
#include "../boringssl/crypto/rand/deterministic.cc"
#include "../boringssl/crypto/rand/fork_detect.cc"
#include "../boringssl/crypto/rand/forkunsafe.cc"
#include "../boringssl/crypto/rand/getentropy.cc"
#include "../boringssl/crypto/rand/ios.cc"
#include "../boringssl/crypto/rand/passive.cc"
#include "../boringssl/crypto/rand/rand.cc"
#include "../boringssl/crypto/rand/trusty.cc"
#include "../boringssl/crypto/rand/urandom.cc"
#include "../boringssl/crypto/rand/windows.cc"
