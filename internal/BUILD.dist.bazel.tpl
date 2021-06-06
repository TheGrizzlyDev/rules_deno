load("@rules_deno//:def.bzl", "deno_toolchain")

filegroup(
    name = "deno_tools",
    srcs = ["deno{exe}"],
    visibility = ["//visibility:public"],
)

deno_toolchain(
    name = "toolchain_impl",
    tools = ":deno_tools"
)

toolchain(
    name = "toolchain",
    exec_compatible_with = [
        {exec_constraints},
    ],
    target_compatible_with = [
        {target_constraints},
    ],
    toolchain = ":toolchain_impl",
    toolchain_type = "@rules_deno//:toolchain_type",
)