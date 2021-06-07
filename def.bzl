load("//internal:rules.bzl", _deno_binary = "deno_binary", _deno_library = "deno_library", _deno_app = "deno_app")
load("//internal:providers.bzl", _DenoAppProviderInfo = "DenoAppProviderInfo")
load("//internal:toolchain.bzl", _deno_toolchain = "deno_toolchain")

deno_binary = _deno_binary
deno_library = _deno_library
deno_app = _deno_app
DenoAppProviderInfo = _DenoAppProviderInfo
deno_toolchain = _deno_toolchain