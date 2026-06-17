// SPDX-License-Identifier: Apache-2.0 OR MIT
// Copyright (c) Status Research & Development GmbH

// Unity build chunk for BoringSSL sources. Keep in sync with prelude.nim.
#include "../boringssl/crypto/cpu_aarch64_apple.cc"
#include "../boringssl/crypto/cpu_aarch64_fuchsia.cc"
#include "../boringssl/crypto/cpu_aarch64_linux.cc"
#include "../boringssl/crypto/cpu_aarch64_openbsd.cc"
#include "../boringssl/crypto/cpu_aarch64_sysreg.cc"
#include "../boringssl/crypto/cpu_aarch64_win.cc"
#include "../boringssl/crypto/cpu_arm_freebsd.cc"
#include "../boringssl/crypto/cpu_arm_linux.cc"
#include "../boringssl/crypto/cpu_intel.cc"
#include "../boringssl/crypto/crypto.cc"
#include "../boringssl/crypto/ex_data.cc"
#include "../boringssl/crypto/fuzzer_mode.cc"
#include "../boringssl/crypto/mem.cc"
#include "../boringssl/crypto/refcount.cc"
#include "../boringssl/crypto/thread.cc"
#include "../boringssl/crypto/thread_none.cc"
#include "../boringssl/crypto/thread_pthread.cc"
#include "../boringssl/crypto/thread_win.cc"
