load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("//internal:repo.bzl", _deno_download = "deno_download")

deno_download = _deno_download

def deno_rules_dependencies():
    """Declares external repositories that rules_go_simple depends on. This
    function should be loaded and called from WORKSPACE files."""

    # bazel_skylib is a set of libraries that are useful for writing
    # Bazel rules. We use it to handle quoting arguments in shell commands.
    _maybe(
        git_repository,
        name = "bazel_skylib",
        remote = "https://github.com/bazelbuild/bazel-skylib",
        commit = "3fea8cb680f4a53a129f7ebace1a5a4d1e035914",
    )

def _maybe(rule, name, **kwargs):
    """Declares an external repository if it hasn't been declared already."""
    if name not in native.existing_rules():
        rule(name = name, **kwargs)

def deno_register_toolchains():
    deno_download(
        name = "toolchain_deno_linux_amd64",
        urls = ["https://github.com/denoland/deno/releases/download/v1.10.3/deno-x86_64-unknown-linux-gnu.zip"],
        sha256 = "7b278d41356ad0b36e79f9f444bd3e6b8e308fd08cb4ea381e085390825db22d",
        os = "linux",
        arch = "amd64",
    )

    native.register_toolchains(
        "@toolchain_deno_linux_amd64//:toolchain"
    )