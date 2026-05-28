packageName = "boringssl"
version = "0.0.7"
author = "Status Research & Development GmbH"
description = "Nim ffi bindings for boringssl"
license = "MIT"
installDirs = @["boringssl"]
installFiles = @["boringssl.nim"]

requires "nim >= 2.0.0"

import os, strutils, sequtils

var flags = getEnv("NIMFLAGS", "") # Extra flags for the compiler

task format, "Format nim code using nph":
  exec "nph ./. *.nim"

task test, "Run tests":
  var nimc = "nim c -d:fast --threads:on " & flags

  when defined(windows):
    nimc &= " -d:nimDebugDlOpen"

  exec nimc & " tests/test_all.nim"
  exec "./tests/test_all --output-level=VERBOSE"

task test_release, "Run tests - release":
  flags = flags & " -d:release "
  testTask()
