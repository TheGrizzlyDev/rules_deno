workspace(name = "rules_deno")

load("@rules_deno//:deps.bzl", "deno_rules_dependencies", "deno_download")

deno_rules_dependencies()

deno_download(
    name = "toolchain_deno_linux_amd64",
    urls = ["https://github.com/denoland/deno/releases/download/v1.10.3/deno-x86_64-unknown-linux-gnu.zip"],
    sha256 = "7b278d41356ad0b36e79f9f444bd3e6b8e308fd08cb4ea381e085390825db22d",
    os = "linux",
    arch = "amd64",
)

register_toolchains(
    "@toolchain_deno_linux_amd64//:toolchain"
)