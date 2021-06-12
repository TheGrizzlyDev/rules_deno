workspace(name = "rules_deno")

load("@rules_deno//:deps.bzl", "deno_rules_dependencies", "deno_register_toolchains")

deno_rules_dependencies()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
bazel_skylib_workspace()

deno_register_toolchains()