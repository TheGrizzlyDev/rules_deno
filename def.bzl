load("//internal:rules.bzl", _deno_binary = "deno_binary", _deno_library = "deno_library")
load("//internal:toolchain.bzl", _deno_toolchain = "deno_toolchain")

deno_binary = _deno_binary
deno_library = _deno_library
deno_toolchain = _deno_toolchain